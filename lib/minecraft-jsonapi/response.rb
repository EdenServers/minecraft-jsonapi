module Minecraft
	module JSONAPI
		class Response
			def initialize(data)
				puts data
				data = JSON.parse data
				puts data

				# Was this a multi-call?
				if data["result"].nil?
					@result = data.map { |r| r["result"] }
					@source = data.map { |r| r["source"] }
					@response = data.map { |r| r["success"] }
				else
					@result = data["result"]
					@source = data["source"]
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
