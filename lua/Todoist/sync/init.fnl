(let [requests (require :Todoist.sync.requests)
      utils (require :Todoist.util)
      M {:get_project_sync_response (fn [opts]
                                      (let [request_provider (require opts.request.provider)]
                                        (assert request_provider.post
                                                "Provider must support the post function to properly interact with the sync API for todoist")
                                        (utils.run_pipeline {:data opts
                                                             :pipeline [requests.create_project_sync_request
                                                                        request_provider.post
                                                                        requests.process_response]})))}]
  M)

