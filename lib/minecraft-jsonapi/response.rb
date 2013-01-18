module Minecraft
	module JSONAPI
		class Response
			def initialize(data)
				data = JSON.parse data

				@result = data["result"]
				@source = data["source"]
				@response = data["success"]
			end

			def result
				@result
			end

			def source
				@source
			end

			def response
				@response
			end
		end
	end
end
