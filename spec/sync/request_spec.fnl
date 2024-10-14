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
                                      (_G.vim.inspect (_G.vim.json.decode "[\"projects\", \"notes\", \"sections\"]"))))))
            (it "should be able to process a successful request response"
                (fn []
                  (let [response {:status 200
                                  :body (_G.vim.json.encode {:full_sync true})}
                        processed_response (request_generator.process_response response)]
                    (assert processed_response.full_sync))))
            (it "should be able to produce a project add command string"
                (fn []
                  (let [expected_json {:type :project_add
                                       :temp_id :4ff1e388-5ca6-453a-b0e8-662ebf373b6b
                                       :uuid :32774db9-a1da-4550-8d9d-910372124fa4
                                       :args {:name "Shopping List"
                                              :parent 4
                                              :child_order 2
                                              :is_favorite true}}
                        command_string ((. request_generator.todoist_commands
                                           :project_add) "Shopping List"
                                                                                                                                       :4ff1e388-5ca6-453a-b0e8-662ebf373b6b
                                                                                                                                       :32774db9-a1da-4550-8d9d-910372124fa4
                                                                                                                                       4
                                                                                                                                       2
                                                                                                                                       true)]
                    (assert.are.same expected_json
                                     (_G.vim.json.decode command_string)))))))

