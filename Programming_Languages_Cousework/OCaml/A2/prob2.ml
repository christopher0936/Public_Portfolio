(*
Chris McLaughlin 
================
V00912353
*)

(* From spec *)
type ovalue =
(* a string constant, e.g., "foo" *)
| Str of string
(* an integer constant, e.g., 15 *)
| Int of int
(* table, e.g., {name1 = val1, name2 = val2} *)
| Table of okeyvalue list
(* list, e.g., [val1, val2] *)
| ListOf of ovalue list
and okeyvalue = string * ovalue
and otable = string * okeyvalue list
and otoml = otable list
;;

(* Code *)
let rec zip in_lista in_listb =
  if List.compare_lengths in_lista in_listb <> 0 then None else
  let out_list = match (in_lista, in_listb) with
  | (last_el_a::[],last_el_b::[]) -> [(last_el_a, last_el_b)]
  | (some_nonlast_el_a::more_elsa, some_nonlast_el_b::more_elsb) -> (some_nonlast_el_a, some_nonlast_el_b)::(Option.get (zip more_elsa more_elsb))
  | _ -> failwith "_ matched in zip"
  in
  Some out_list
;;

let rec flatmap in_func in_list =
  (* in_func returns a LIST of 'b for a given 'a, we will apply to each 'a element of in_list, concatenating the results into one big 'b list *)
  match in_list with
  | [] -> []
  | some_el::more_els -> (in_func some_el)@(flatmap in_func more_els)
;;

let rec flatmap_opt in_func in_list =
  (* in_func returns a LIST of 'b for a given 'a, we will apply to each 'a element of in_list, concatenating the results into one big 'b list *)
  match in_list with
  | [] -> Some []
  | some_el::more_els -> let func_eval = in_func some_el in if func_eval = None then None else Some ((Option.get func_eval)@(Option.get (flatmap_opt in_func more_els)))
;;

(* otoml is otable list. otable is string*okeyvalue list. okeyvalue is string*ovalue *)

(* A value corresponding to the sample file in Problem 2
let t = [ "table1", [ ("str", Str "hello")
        ; ("int", Int 5)
        ; ("table", Table ["a", Str "x"; "b", Str "Y"])
        ; ("list", ListOf [Int 1; Int 2] ]
      ; "table2", [ ("something", Str "maybe" )] ]

get_strings t
[("table1", "hello"), ("table1", "x"), ("table1", "y"), ("table2", "maybe")] *)

(* (* Test case: *)
let t = [ "table1", [ ("str", Str "hello")
; ("int", Int 5)
; ("table", Table ["a", Str "x"; "b", Str "Y"])
; ("list", ListOf [Int 1; Int 2]) ]
; "table2", [ ("something", Str "maybe" )] ]

get_strings t
(* [("table1", "hello"), ("table1", "x"), ("table1", "y"), ("table2", "maybe")] *)
*)


let get_strings (in_otoml : otoml) =
  let rec list_strings_from_okeyvalue (nameforvals : string) (in_okv : okeyvalue) =
    let (_,oval) = in_okv in (* Don't care about keys *)
    list_strings_from_ovalue nameforvals oval

  and list_strings_from_ovalue (nameforvals : string) (in_oval : ovalue) = (* Need mutual recursion here*)
    match in_oval with
    | Str a_string -> [(nameforvals,a_string)]
    | Table a_table -> List.concat_map (list_strings_from_okeyvalue nameforvals) a_table
    | ListOf a_list -> List.concat_map (list_strings_from_ovalue nameforvals) a_list
    | Int a_int -> [] (* We don't care about ints *)
  in
  let get_strings_from_otable in_otable =
    let (table_name, keyval_list) = in_otable in
    List.concat_map (list_strings_from_okeyvalue table_name) keyval_list
  in
  List.concat_map get_strings_from_otable in_otoml
;;

let is_uppercase in_str =
  String.uppercase_ascii in_str = in_str
;;

(* From lecture examples *)
let compose =
  fun f -> fun g -> (fun x -> f (g x))
;;
(* infix notation for composition *)
let (%) = compose;;

let get_uppercase_strings_1 in_otoml =
  (List.filter is_uppercase % List.map snd % get_strings) in_otoml
;;

let (|>) x f = f x;; (* From class examples *)
let get_uppercase_strings_2 in_otoml =
  in_otoml |> get_strings |> List.map snd |> List.filter is_uppercase
;;