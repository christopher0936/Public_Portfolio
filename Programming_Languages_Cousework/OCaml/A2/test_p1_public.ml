open Printf

let args = Array.to_list Sys.argv

let ci = Int.compare
let prni l =
  sprintf "[%s]" (String.concat "," @@ List.map (fun s -> sprintf "%d" s) @@ Prob1.FuncSet.to_list l)

let make_set c l =
  List.fold_left (fun a i -> Prob1.FuncSet.insert a i) (Prob1.FuncSet.empty_set c) l

let out =
  try
    match List.tl args with
    | "empty_set" :: _ ->
      prni @@ Prob1.FuncSet.empty_set ci
    | "is_empty" :: _ ->
      let s = Prob1.FuncSet.empty_set ci in
      sprintf "%b" (Prob1.FuncSet.is_empty s)
    | "size" :: _ ->
      let s = Prob1.FuncSet.empty_set ci in
      sprintf "%d" (Prob1.FuncSet.size s)
    | "insert" :: _ ->
      let s = Prob1.FuncSet.empty_set ci in
      let s = Prob1.FuncSet.insert s 1 in
      prni s
    | "remove" :: _ ->
      let s = Prob1.FuncSet.empty_set ci in
      let s = Prob1.FuncSet.insert s 1 in
      let s = Prob1.FuncSet.remove s 1 in
      prni s
    | "union" :: _ ->
      let s = Prob1.FuncSet.empty_set ci in
      let s = Prob1.FuncSet.insert s 1 in
      let s' = Prob1.FuncSet.empty_set ci in
      let s' = Prob1.FuncSet.insert s' 2 in
      prni (Prob1.FuncSet.union s s')
    | "intersect" :: _ ->
      let s = Prob1.FuncSet.empty_set ci in
      let s = Prob1.FuncSet.insert s 1 in
      let s' = Prob1.FuncSet.empty_set ci in
      let s' = Prob1.FuncSet.insert s' 2 in
      prni (Prob1.FuncSet.intersect s s')
    | "from_list" :: _ ->
      let s = Prob1.FuncSet.from_list ci [1;2] in
      prni s
    | "map" :: _ ->
      let set2 = Prob1.FuncSet.insert (Prob1.FuncSet.insert (Prob1.FuncSet.insert (Prob1.FuncSet.empty_set ci) 1) 2) (-1) in
      prni (Prob1.FuncSet.map (fun x -> x mod 2) set2)
    | "fold" :: _ ->
      let set2 = Prob1.FuncSet.insert (Prob1.FuncSet.insert (Prob1.FuncSet.insert (Prob1.FuncSet.empty_set ci) 1) 2) (-1) in
      sprintf "%d" (Prob1.FuncSet.fold (fun acc x -> acc + x) 0 set2)
    | _ -> sprintf "!ERR %s" (String.concat "; " args)
  with
  (* | Prob1.NotImplemented -> sprintf "!NIE %s" (List.hd @@ List.tl args) *)
  | e -> sprintf "!EXC %s" (Printexc.to_string e)
;;
flush_all ();
printf "[csc330_tester] %s\n" out


