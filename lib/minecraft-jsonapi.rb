require 'json'
require 'digest/sha2'
require 'net/http'
require 'cgi'

%w{version jsonapi namespace response}.each do |file|
	require "minecraft-jsonapi/#{file}"
end

module MinecraftServer
	module JSONAPI
		CALL_URL          = 'http://%{host}:%{port}/api/call?method=%{method}&args=%{args}&key=%{key}'
		CALL_MULTIPLE_URL = 'http://%{host}:%{port}/api/call-multiple?method=%{method}&args=%{args}&key=%{key}'

		# Shortcut to Minecraft::JSONAPI::JSONAPI.new
		def self.new(options = {})
			Minecraft::JSONAPI::JSONAPI.new options
		end

		def self.send_request(url)
			get_raw_response(url).response
		end

		def self.get_raw_response(url)
			uri = URI.parse(url)

			http = Net::HTTP.new(uri.host, uri.port)
			http.open_timeout = 10
			http.read_timeout = 10
			response = http.request(Net::HTTP::Get.new(uri.request_uri))

			Minecraft::JSONAPI::Response.new(response.body)
		end

		# Wrap arguments in an array if they're not already an array or hash
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
			begin
				URI.escape JSON.generate data
			rescue JSON::GeneratorError
				URI.escape data
			end
		end
	end
end
