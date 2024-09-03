print(vim.inspect(vim.json.decode(vim.iter(io.lines(vim.fn.stdpath("cache") .. "/Todoist/todoist.json")):join("\n"))))

-- local response_dict = vim.json.decode(response_text)
-- print(vim.inspect(response_text))
