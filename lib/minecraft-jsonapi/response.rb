module Minecraft
	module JSONAPI
		class Response
			def initialize(data)
				data = JSON.parse data

				# Was this a multi-call?
				if data["source"].is_a? Array
					@result =   data["success"].map { |r| r["result"] }
					@source =   data["success"].map { |r| r["source"] }
					@response = data["success"].map { |r| r["success"] }
				else
					@result =   data["result"]
					@source =   data["source"]
					@response = data["success"]
				end
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
