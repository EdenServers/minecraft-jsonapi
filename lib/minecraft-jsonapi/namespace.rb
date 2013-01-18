module Minecraft
	module JSONAPI
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
					block.call Minecraft::JSONAPI::Namespace.new(self, method.to_s)
				else
					method = [namespace, method.to_s].join(".")
					url = parent.make_url(method, args)

					Minecraft::JSONAPI.send_request(url)
				end
			end

			# This will bubble upwards until we hit the actual JSONAPI class
			def make_url(*args)
				parent.make_url(*args)
			end
		end
	end
end
