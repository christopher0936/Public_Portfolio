(*
Chris McLaughlin 
================
V00912353
*)

(* Module Sig Code *)
module type FSET = sig
type 'a set
(* type 'a set = { cmp : 'a -> 'a -> int; lst : 'a list } (* DEBUG: EXPOSE ATTRIBUTES SO I CAN SEE LIST WHILE TESTING *) *)
exception EmptySet
val empty_set : ('a -> 'a -> int) -> 'a set
val is_empty : 'a set -> bool
val size : 'a set -> int
val insert : 'a set -> 'a -> 'a set
val remove : 'a set -> 'a -> 'a set
val union : 'a set -> 'a set -> 'a set
val intersect : 'a set -> 'a set -> 'a set
val from_list : ('a -> 'a -> int) -> 'a list -> 'a set
val to_list : 'a set -> 'a list
val map : ('a -> 'a) -> 'a set -> 'a set
val fold : ('a -> 'b -> 'a) -> 'a -> 'b set -> 'a
end
;;

(* Code *)
module FuncSet: FSET = struct
type 'a set = { cmp : 'a -> 'a -> int; lst : 'a list } (* cmp will take a val1 and val2 (curried) and return an int *)
exception EmptySet

let is_in_set in_set in_element = (* Helper function returns true if the provided element is in the set, otherwise false *)
  let rec is_in_list in_list find_element =
    match in_list with
    | [] -> false
    | el::more_els -> if (el = find_element) then true else is_in_list more_els find_element
  in
  is_in_list in_set.lst in_element

let empty_set ordfunc =
  {cmp = ordfunc; lst = []}

let is_empty in_set =
  in_set.lst = []

let size in_set =
  List.length in_set.lst

let insert in_set new_element =
  if is_in_set in_set new_element then
    in_set
  else
    let rec insert_list in_list = (* Could program to handle dumplicates here (would do an else if check in the second case rather than a hard else, ensuring that the new element does equal the last element, as well as for each case making sure the new value doesnt match (either) existing element, BUT this is spaghetti enough code already and I already made the check if in helper function so I'm making a design call to do it this way *)
      match in_list with
      | el1::el2::more_els -> if ((in_set.cmp el1  new_element) > 0) then new_element::el1::el2::more_els else (if ((in_set.cmp new_element el1) >= 0) && ((in_set.cmp new_element el2) < 0) then el1::new_element::el2::more_els else el1::(insert_list(el2::more_els)))
      | last_el::[] -> if ((in_set.cmp new_element last_el) >= 0) then last_el::new_element::[] else new_element::last_el::[]
      | [] -> [new_element]
    in
    {cmp = in_set.cmp; lst = (insert_list in_set.lst)}

let remove in_set rem_element =
  let rec remove_list in_list =
    match in_list with
    | el::more_els -> if el = rem_element then more_els else el::remove_list(more_els)
    | [] -> raise EmptySet

  in
  {cmp = in_set.cmp; lst = remove_list in_set.lst}

let union seta setb =
  {cmp=seta.cmp; lst = List.sort_uniq seta.cmp (List.append seta.lst setb.lst)}

let intersect seta setb = (* Since intersection is commutative, We just filter out everything from set a thats not in set b *)
  let rec intersect_list lista =
    match lista with
    | el::more_els -> if is_in_set setb el then el::intersect_list(more_els) else intersect_list(more_els)
    | [] -> []
  in
  {cmp = seta.cmp; lst = intersect_list seta.lst}

let from_list in_cmp in_list =
  {cmp = in_cmp; lst = List.sort_uniq in_cmp in_list}

let to_list in_set =
  in_set.lst

let map in_func in_set =
  {cmp = in_set.cmp; lst = List.sort_uniq in_set.cmp (List.map in_func in_set.lst)}

let fold in_func in_acc in_set = (* Understanding of how left folds work is from Ocaml list library documentation *)
  List.fold_left in_func in_acc in_set.lst

end
;;

(* Bonus Question 12: The most glaringly obvious problems with the signature is the union and intersect functions having ambiguous behaviour, where the set that is returned uses the comparator function from the first set in the join, when
in reality it is impossible to know if this is what the user actually wants. A better implementation might have take a flag that allows the user to specify which comparator they would like to use, or maybe even provide a new comparative function for use in sorting the resulting set.
Other possible issues are that fold's currying is in a different order from List.fold_left 's, possibly leading to confusion, and speaking of which, fold should really be called fold_left to make clear to the user what is going on. *)

(* Bonus Question 13: The main difference is obviously that stlib works with lists directly while we work with sets, resulting in our main function taking and resulting in a set, in terms of the difference between 'a -> 'a and 'a -> 'b - our module restricts our mapping to return a set of
   the same type as the input set, while stdlib doesn't apply this restriction to lists. This is a design decision in ocaml, since our list is of type 'a, a map function that changed the type would no longer be compatible with the set's cmp function. *)