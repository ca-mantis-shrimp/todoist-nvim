(local describe (. (require :plenary.busted) :describe))
(local it (. (require :plenary.busted) :it))
(local mock_curl (require :Todoist.sync.mock_curl))
(local sync_fun (require :Todoist.sync))
(local curl (require :plenary.curl))

(describe "we can test just general sync requests"
          (fn []
            (it "can be used to make a full sync request"
                (fn []
                  (let [test_response (sync_fun.get_project_sync_response :god-key
                                                                          mock_curl)
                        expected_response {:projects [{:name :Inbox
                                                       :id 1
                                                       :child_order 1}]}]
                    (assert.are.equal test_response expected_response))
                  nil))))

