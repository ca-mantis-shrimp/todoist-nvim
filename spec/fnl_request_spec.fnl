(local describe (. (require :plenary.busted) :describe))
(local it (. (require :plenary.busted) :it))
(local request_generator (require :Todoist.sync.requests))

(describe "unit tests for todoist requests"
          (fn []
            (it "should produce a proper sync request"
                (fn []
                  (let [sync_request (request_generator.create_project_sync_request {:request {:api_key "good key"}})]
                    (assert.are.equal sync_request.headers.Authorization
                                      "Bearer good key")
                    (assert.are.equal sync_request.data.sync_token "*")
                    (assert.are.equal (_G.vim.inspect (_G.vim.json.decode sync_request.data.resource_types))
                                      (_G.vim.inspect (_G.vim.json.decode "[\"projects\", \"notes\", \"sections\"]"))))))))

