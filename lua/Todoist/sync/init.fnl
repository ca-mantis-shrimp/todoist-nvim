(local requests (require :Todoist.sync.request_utils))
(local M {})
(fn M.get_project_sync_response [api_key provider ?sync_token]
  "given an http provider, and an api key, run a full sync request. if sync_token is given, conduct partial sync"
  (let [sync_request (requests.create_project_sync_request api_key ?sync_token)
        sync_response (provider.post sync_request)]
    (requests.process_response sync_response)))

M

