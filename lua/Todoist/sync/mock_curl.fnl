(local M {})
(fn M.post [?request]
  {:url "https://api.todoist.com/sync/v9/sync"
   :headers {:Authorization "Bearer good-key"}
   :data {"sync_token:" nil
          :resource_types (_G.vim.json.encode [:projects :notes :sections])
          :timeout 100000}
   :status 200
   :body {:true_sync true
          :sync_token :sync-token
          :projects [{:name :Inbox :id 2 :child_order 1}]}})

(M.post {:some :something})
M

