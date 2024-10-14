(let [describe (. (require :plenary.busted) :describe)
      it (. (require :plenary.busted) :it)
      sync (require :Todoist.sync)]
  (describe "we can test just general sync requests"
            (fn []
              (it "can be used to make a full sync request"
                  (fn []
                    (nil))))))

