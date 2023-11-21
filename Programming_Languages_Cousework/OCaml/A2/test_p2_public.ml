open Printf

let args = Array.to_list Sys.argv

let t =
  let open Prob2 in
  [ "table1", [ ("str", Str "hello")
              ; ("int", Int 5)
              ; ("table", Table ["a", Str "x"; "b", Str "Y"])
              ; ("list", ListOf [Int 1; Int 2]) ]
  ; "table2", [ ("something", Str "maybe" )] ]

let out =
  try
    match List.tl args with
    | "zip" :: _ ->
      let z = Prob2.zip [1; 2] ["a"] in
      sprintf "%b" (z = None)
    | "flatmap" :: _ ->
      let z = Prob2.flatmap (fun x -> [x; -x]) [1; 2; 3] in
      sprintf "%b" (z = [1; -1; 2; -2; 3; -3])
    | "flatmap_opt" :: _ ->
      let z = Prob2.flatmap_opt (fun x -> Some x) [] in
      sprintf "%b" (z = Some [])
    | "get_strings" :: _ ->
      let z = Prob2.get_strings t in
      sprintf "%b" (z = [("table1", "hello"); ("table1", "x"); ("table1", "Y"); ("table2", "maybe")])
    | "is_uppercase" :: _ ->
      let z = Prob2.is_uppercase "HELLO" in
      sprintf "%b" (z = true)
    | "get_uppercase_strings_1" :: _ ->
      let z = Prob2.get_uppercase_strings_1 t in
      sprintf "%b" (z = ["Y"])
    | "get_uppercase_strings_2" :: _ ->
      let z = Prob2.get_uppercase_strings_2 t in
      sprintf "%b" (z = ["Y"])
    | _ -> sprintf "!ERR %s" (String.concat "; " args)
  with
  (* | Prob2.NotImplemented -> sprintf "!NIE %s" (List.hd @@ List.tl args) *)
  | e -> sprintf "!EXC %s" (Printexc.to_string e)
;;
flush_all ();
printf "[csc330_tester] %s\n" out
