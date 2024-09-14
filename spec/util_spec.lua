local util = require("Todoist.util")

describe("persistent tables", function()
	it("can can immutably update a table", function()
		local test_table = util.create_persistent_table({ test = "hello" })

		local updated_table = test_table:set("new", "value")

		assert(updated_table.test == "hello")
		assert(test_table.new == nil)
	end)
end)
