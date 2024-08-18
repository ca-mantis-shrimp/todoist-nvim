local schema = require("jsonschema")
local todoist_sync_schema = require("Todoist.definitions").sync_response_schema

describe("jsonschema testing", function()
	it("should validate a basic schema", function()
		-- Note: Cache the result of the schema compilation as this is quite expensive
		local myvalidator = schema.generate_validator({
			type = "array",
			items = {
				type = "object",
				properties = {
					foo = { type = "string" },
					bar = { type = "number", optional = false },
				},
				required = { "foo" },
			},
		})

		assert(myvalidator({ { foo = "test" } }))
	end)
end)
