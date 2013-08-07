module MinecraftServer
	module JSONAPI
		class Response
			attr_reader :result, :source, :response

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
		end
	end
end
