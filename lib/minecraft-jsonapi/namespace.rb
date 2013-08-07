module MinecraftServer
	module JSONAPI
		class Namespace
			def initialize(parent, namespace)
				@parent = parent
				@namespace = namespace
			end

			def method_missing(method, *args)
				method = [@namespace, method.to_s].join(".")
				url = @parent.make_url(method, args)

				Minecraft::JSONAPI.send_request(url)
			end

			# This will bubble upwards until we hit the actual JSONAPI class
			def make_url(*args)
				@parent.make_url(*args)
			end
		end
	end
end
