-- [nfnl] Compiled from lua/Todoist/fnl_util.fnl by https://github.com/Olical/nfnl, do not edit.
local M = {}
M.is_higher_child_order = function(type_1, type_2)
	return (type_1.child_order < type_2.child_order)
end
M.list_is_populated = function(list)
	return (list and (#list > 0))
end
M.list_is_sortable = function(list)
	return (list and (#list > 1))
end
return M
