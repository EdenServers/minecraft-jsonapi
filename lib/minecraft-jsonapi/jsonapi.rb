module MinecraftServer
	module JSONAPI
		class JSONAPI
			attr_reader :host, :port, :username, :salt

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
					MinecraftServer::JSONAPI::CALL_MULTIPLE_URL % { host: @host, port: @port, method: MinecraftServer::JSONAPI.url_encoded_json(method), args: MinecraftServer::JSONAPI.url_encoded_json(args), key: create_key(method) }
				else
					MinecraftServer::JSONAPI::CALL_URL          % { host: @host, port: @port, method: MinecraftServer::JSONAPI.url_encoded_json(method), args: MinecraftServer::JSONAPI.url_encoded_json(args), key: create_key(method) }
				end
			end

			def call(methods)
				method_names = methods.keys.map(&:to_s)
				method_arguments = methods.values.map { |args| MinecraftServer::JSONAPI.map_to_array args }

				url = make_url(method_names, method_arguments)
				MinecraftServer::JSONAPI.send_request(url)
			end

			def method_missing(method, *args, &block)
				if block_given?
					block.call MinecraftServer::JSONAPI::Namespace.new(self, method.to_s)
				else
					url = make_url(method.to_s, args)
					MinecraftServer::JSONAPI.send_request(url)
				end
			end

			def create_key(method)
				method = JSON.generate(method) if method.is_a? Array

				Digest::SHA2.new.update([@username, method, @password, @salt].join).to_s
			end

			def namespace
			end
		end
	end
end
