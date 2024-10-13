-- [nfnl] Compiled from fnl_request_spec.fnl by https://github.com/Olical/nfnl, do not edit.
local describe = require("plenary.busted").describe
local it = require("plenary.busted").it
local request_generator = require("Todoist.sync.requests")
local function _1_()
	local function _2_()
		local sync_request = request_generator.create_project_sync_request({ request = { api_key = "good key" } })
		assert.are.equal(sync_request.headers.Authorization, "Bearer good key")
		assert.are.equal(sync_request.data.sync_token, "*")
		return assert.are.equal(
			_G.vim.inspect(_G.vim.json.decode(sync_request.data.resource_types)),
			_G.vim.inspect(_G.vim.json.decode('["projects", "notes", "sections"]'))
		)
	end
	return it("should produce a proper sync request", _2_)
end
return describe("unit tests for todoist requests", _1_)
