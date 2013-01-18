require 'test/unit'
require 'minecraft-jsonapi'

class MinecraftJSONAPITest < Test::Unit::TestCase
	def api
		@api ||= Minecraft::JSONAPI.new(username: "admin", password: "12345", salt: "mmm")
	end

	def test_create_new_shortcut
		assert_equal Minecraft::JSONAPI::JSONAPI, api.class
	end

	def test_map_to_array
		assert_equal [], Minecraft::JSONAPI.map_to_array(nil)
		assert_equal [""], Minecraft::JSONAPI.map_to_array("")
		assert_equal ["Fustrate"], Minecraft::JSONAPI.map_to_array("Fustrate")

		assert_equal [12345], Minecraft::JSONAPI.map_to_array(12345)
		assert_equal [1, 2, 3], Minecraft::JSONAPI.map_to_array([1, 2, 3])
		assert_equal [1, "2", 3.0], Minecraft::JSONAPI.map_to_array([1, "2", 3.0])

		hash = { :one => "two", :three => "four" }

		assert_equal hash, Minecraft::JSONAPI.map_to_array(hash)
	end

	def test_url_encoded_json
		assert_equal "%5B%22test%22%5D", Minecraft::JSONAPI.url_encoded_json(["test"])
		assert_equal "%5B%22test%22%2C5%5D", Minecraft::JSONAPI.url_encoded_json(["test", 5])
	end

	def test_connection
		assert_equal 0, api.getPlayerCount
	end
end
