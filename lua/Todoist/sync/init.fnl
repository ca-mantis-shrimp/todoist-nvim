(local requests (require :Todoist.sync.request_utils))
(local curl (require :plenary.curl))
(fn get_project_sync_response [api_key ?sync_token ?provider]
  "given an http provider, and an api key, run a full sync request. if sync_token is given, conduct partial sync"
  (-> (requests.create_project_sync_request api_key ?sync_token)
      ((or (?. ?provider.post) curl.post))
      (requests.process_response)))

get_project_sync_response

