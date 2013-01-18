module Minecraft
	module JSONAPI
		class Response
			def initialize(data)
				data = JSON.parse data

				# Was this a multi-call?
				if data["result"].nil?
					@result = data.map { |r| r["result"] }
					@source = data.map { |r| r["source"] }

					# This is weird. Duplicates the above information in data["success"]
					@response = data["success"].map { |r| r["success"] }
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
