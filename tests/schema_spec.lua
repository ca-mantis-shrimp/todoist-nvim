local schema = require("jsonschema")

describe("jsonschema testing", function()
	it("shoudl validate a basic schema", function()
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
