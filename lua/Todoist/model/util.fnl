;Intended as a list of pure functions to use for functional data transformations
(local M {})

(fn M.is_higher_child_order [type_1 type_2]
  "checks if the first dictionary has a lower child order than the second"
  (< type_1.child_order type_2.child_order))

(fn M.list_is_populated [list]
  "returns true if the collection is both non-nil and has atleast one item in it"
  (and list (> (length list) 0)))

(fn M.list_is_sortable [list]
  "return true if a list is populated AND has more than one entry which may necesitate sorting"
  (and list (> (length list) 1)))

M

