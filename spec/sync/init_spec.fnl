(local describe (. (require :plenary.busted) :describe))
(local it (. (require :plenary.busted) :it))
(local sync (require :Todoist.sync))

(describe "we can test just general sync requests"
          (fn []
            (it "can be used to make a full sync request"
                (fn []
                  (let [test_response (sync :good-key nil mock_curl)
                        expected_response {:projects [{:name :Inbox
                                                       :id 1
                                                       :child_order 1}]}]
                    (assert.are.equal test_response expected_response))
                  nil))))

