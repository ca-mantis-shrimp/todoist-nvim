(local describe (. (require :plenary.busted) :describe))
(local it (. (require :plenary.busted) :it))
(local sync (require :Todoist.sync))
(local mock_curl {:post (fn [opts]
                          (if (= opts
                                 {:url "https://api.todoist.com/sync/v9/sync"
                                  :headers {:Authorization "Bearer good-key"}
                                  :data {"sync_token:" nil
                                         :resource_types (_G.vim.json.encode [:projects
                                                                              :notes
                                                                              :sections])
                                         :timeout 100000}})
                              {:status 200
                               :body {:true_sync true
                                      :sync_token :sync-token
                                      :projects [{:name :Inbox
                                                  :id 2
                                                  :child_order 1}]}}
                              {:status_code 401}))})

(describe "we can test just general sync requests"
          (fn []
            (it "can be used to make a full sync request"
                (fn []
                  (let [test_response (sync :good-key nil mock_curl)
                        expected_response {:projects [{:name :Inbox
                                                       :id 1
                                                       :child_order 1}]}]
                    (assert.are.same test_response expected_response))
                  nil))))

