open Prob1 (* this is the _only_ place you should use `open` in this assignment *)
let test_is_empty () =
  let cmp = Int.compare in
  let set = FuncSet.empty_set cmp in
  assert (FuncSet.is_empty set = true);
  let set = FuncSet.insert set 1 in
  assert (FuncSet.is_empty set = false);
;;

let _ = test_is_empty ()