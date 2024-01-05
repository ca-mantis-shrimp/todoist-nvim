M = {}

M.conversion_table = { ["projects"] = M.convert_projects_to_dictionary, ["items"] = M.add_tasks_to_nodes }

M.add_projects_to_nodes_immutably = function(projects, nodes)
	local copy = vim.deepcopy(nodes)

	for _, project in ipairs(projects) do
		copy[tonumber(project.id)] = {
			name = project.name,
			parent_id = tonumber(project.parent_id),
			inbox_project = project.inbox_project,
			collapsed = project.collapsed,
			color = project.color,
			child_order = project.child_order,
			is_archived = project.is_archived,
			is_deleted = project.is_deleted,
			view_style = project.view_style,
			children = {},
			type = "project",
		}
	end

	return copy
end

M.add_tasks_to_nodes = function(tasks, nodes)
	local copy = vim.deepcopy(nodes)

	for _, task in ipairs(tasks) do
		copy[tonumber(task.id)] = {
			content = task.content,
			description = task.description,
			checked = task.checked,
			priority = task.priority,
			due = task.due,
			all_day = task.all_day,
			day_order = task.day_order,
			labels = task.labels,
			parent_id = task.parent_id or task.project_id,
			child_order = task.child_order,
			collapsed = task.collapsed,
			date_added = task.date_added,
			in_history = task.in_history,
			is_deleted = task.is_deleted,
			sync_id = task.sync_id,
			type = "task",
		}
	end

	return copy
end

M.convert_to_todoist_tree = function(nodes)
	local root_nodes = {}

	for id, node in ipairs(nodes) do
		if node.parent_id then
			nodes[node.parent_id].children[id] = node
		else
			root_nodes[id] = node
		end
	end

	return root_nodes
end

M.set_tree_depth = function(tree)
	for id, _ in pairs(tree) do
		M.set_node_depth_from_root(tree[id], 0)
	end
end

M.set_node_depth_from_root = function(node, depth)
	node.depth = depth
	for _, child in pairs(node.children) do
		M.set_node_depth_from_root(child, depth + 1)
	end
end

return M
