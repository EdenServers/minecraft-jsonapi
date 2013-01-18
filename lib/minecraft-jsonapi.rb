require 'minecraft-jsonapi/version'
require 'json'
require 'digest/sha2'
require 'net/http'
require 'cgi'

module Minecraft
	module JSONAPI
		CALL_URL          = 'http://%{host}:%{port}/api/call?method=%{method}&args=%{args}&key=%{key}'
		CALL_MULTIPLE_URL = 'http://%{host}:%{port}/api/call-multiple?method=%{method}&args=%{args}&key=%{key}'

		class JSONAPI
			def initialize(options = {})
				raise "A username must be provided." if options[:username].nil?
				raise "A password must be provided." if options[:password].nil?
				raise "Please use a salt."           if options[:salt].nil?

				@host     = options[:host]     || 'localhost'
				@port     = options[:port]     || 20059
				@username = options[:username]
				@password = options[:password]
				@salt     = options[:salt]
			end

			def make_url(method, args)
				if method.is_a? Array
					Minecraft::JSONAPI::CALL_MULTIPLE_URL % { host: @host, port: @port, method: Minecraft::JSONAPI.url_encoded_json(method), args: Minecraft::JSONAPI.url_encoded_json(args), key: create_key(method) }
				else
					Minecraft::JSONAPI::CALL_URL          % { host: @host, port: @port, method: Minecraft::JSONAPI.url_encoded_json(method), args: Minecraft::JSONAPI.url_encoded_json(args), key: create_key(method) }
				end
			end

			def call(methods)
				method_names = methods.keys.map(&:to_s)
				method_arguments = methods.values.map { |args| Minecraft::JSONAPI.map_to_array args }

				url = Minecraft::JSONAPI.make_url(method_names, method_arguments)
				JSON.parse Minecraft::JSONAPI.send_raw_request(url)
			end

			def method_missing(method, *args, &block)
				if block_given?
					block.call Minecraft::JSONAPI::Namespace.new(self, method)
				else
					url = Minecraft::JSONAPI.make_url(method, args)
					JSON.parse Minecraft::JSONAPI.send_raw_request(url)
				end
			end

			def create_key(method)
				method = JSON.generate(method) if method.is_a? Array

				Digest::SHA2.new.update([@username, method, @password, @salt].join).to_s
			end

			def namespace
			end
		end

		class Namespace
			def initialize(parent, namespace)
				@parent = parent
				@namespace = namespace
			end

			def namespace
				[parent.namespace, @namespace].reject {|x| x.nil? }.join(".")
			end

			def method_missing(method, *args, &block)
				if block_given?
					block.call Minecraft::JSONAPI::Namespace.new(self, method)
				else
					method = [namespace, method].join(".")
					url = parent.make_url(method, args)

					JSON.parse Minecraft::JSONAPI.send_raw_request(url)
				end
			end

			# This will bubble upwards until we hit the actual JSONAPI class
			def make_url(*args)
				parent.make_url(*args)
			end
		end

		# Shortcut to Minecraft::JSONAPI::JSONAPI.new
		def self.new(options = {})
			Minecraft::JSONAPI::JSONAPI.new options
		end

		def self.send_raw_request(url)
			uri = URI.parse(url)

			http = Net::HTTP.new(uri.host, uri.port)
			http.open_timeout = 10
			http.read_timeout = 10
			response = http.request(Net::HTTP::Get.new(uri.request_uri))

			response.body
		end

		# Map all arguments into an array if they're not already an array or hash
		# Converts nil to [], "" to [""], "Username" to ["Username"], etc.
		def self.map_to_array(arguments)
			if arguments.nil?
				[]
			elsif arguments.is_a?(Array) || arguments.is_a?(Hash)
				arguments
			else
				[arguments]
			end
		end

		def self.url_encoded_json(data)
			::CGI.escape JSON.generate data
		end
	end
end
