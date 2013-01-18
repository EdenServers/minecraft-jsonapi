require 'minecraft-jsonapi/version'
require 'json'
require 'digest/sha2'
require 'net/http'

module Minecraft
	module JSONAPI
		CALL_URL = 'http://%s:%s/api/call?method=%s&args=%s&key=%s'
		CALL_MULTIPLE_URL = 'http://%s:%s/api/call-multiple?method=%s&args=%s&key=%s'

		def initialize(options = {})
			@host = options[:host] || 'localhost'
			@port = options[:port] || 20059
			@username = options[:username]
			@password = options[:password]
			@salt = options[:salt]
		end

		def create_key(method)
			method = JSON.generate(method) if method.is_a? Array

			Digest::SHA2.new.update([@username, method, @password, @salt].join).to_s
		end

		def make_url(method, args = {})
			if method.is_a? Array
				CALL_MULTIPLE_URL.sprintf @host, @port, CGI.escape(method), CGI.escape(JSON.generate(args)), create_key(method)
			else
				CALL_URL.sprintf @host, @port, CGI.escape(JSON.generate(method)), CGI.escape(JSON.generate(args)), create_key(method)
			end
		end

		def call_multiple(methods, args)
		end

		def method_missing(method, *args)
			JSON.parse send_raw_request(make_url(method, args))
		end

		private

		def send_raw_request(url)
			uri = URI.parse(url)

			http = Net::HTTP.new(uri.host, uri.port)
			http.open_timeout = 10
			http.read_timeout = 10
			request = http.request(Net::HTTP::Get.new(uri.request_uri))

			request.body
		end
	end
end
