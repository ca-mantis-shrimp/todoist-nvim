local util = require("Todoist.util")

describe("persistent tables", function()
	it("can can immutably update a table", function()
		local test_table = util.create_persistent_table({ test = "hello" })

		local insert_table = { stuff = 0 }
		local updated_table = test_table:set("new", "value")
		local another_updated_table = updated_table:set("test_table", insert_table)

		assert(test_table.new == nil) -- didnt get updated
		assert(updated_table.test == "hello") -- DID get updated
		assert(another_updated_table.test_table == insert_table) -- can handle a table insert
	end)
end)
