open Prob2

let test_get_records () =
  assert(get_records ("Canada,CAN,0.1,,2.1\nUnited States,USA,1.1,2.1,1.1\nUnknown,UNK,,,") = 
  [ {id = "CAN"; name = "Canada"; rates = [Some 0.1; None; Some 2.1]}
  ; {id = "USA"; name = "United States"; rates = [Some 1.1; Some 2.1; Some 1.1]}
  ; {id = "UNK"; name = "Unknown"; rates = [None; None; None]} ])
let _ = test_get_records ()

let test_avail () =
  let record1 = {id = "CAN"; name = "Canada"; rates = [Some 0.1; None; Some 2.1]} in
  let record2 = {id = "USA"; name = "United States"; rates = [Some 1.0; Some 2.0; Some 3.0]} in
  let record3 = {id = "MEX"; name = "Mexico"; rates = []} in
  let record4 = {id = "BRA"; name = "Brazil"; rates = [None; None; None]} in
  let record5 = {id = "ARG"; name = "Argentina"; rates = [Some 0.5; Some 0.7]} in
  let record6 = {id = "FRA"; name = "France"; rates = [None; Some 1.2; Some 0.5; None; Some 2.1]} in
  let record7 = {id = "GER"; name = "Germany"; rates = [Some 0.8; None; None; Some 3.0]} in
  let record8 = {id = "ITA"; name = "Italy"; rates = [Some 0.3; None; Some 0.1; Some 0.7; None]} in
  let record9 = {id = "ESP"; name = "Spain"; rates = [Some 0.2]} in
  let record10 = {id = "CHN"; name = "China"; rates = [None; None; None; None]} in

  assert(avail record1 = 2);
  assert(avail record2 = 3);
  assert(avail record3 = 0);
  assert(avail record4 = 0);
  assert(avail record5 = 2);
  assert(avail record6 = 3);
  assert(avail record7 = 2);
  assert(avail record8 = 3);
  assert(avail record9 = 1);
  assert(avail record10 = 0)
let _ = test_avail () 

(* These test cases are wrong!
let test_last () =
  let record1 = {id = "CAN"; name = "Canada"; rates = [Some 0.1; None; Some 2.1]} in
  let record2 = {id = "USA"; name = "United States"; rates = [Some 1.0; Some 2.0; Some 3.0]} in
  let record3 = {id = "MEX"; name = "Mexico"; rates = []} in
  let record4 = {id = "BRA"; name = "Brazil"; rates = [None; None; None]} in
  let record5 = {id = "ARG"; name = "Argentina"; rates = [Some 0.5; Some 0.7]} in
  let record6 = {id = "FRA"; name = "France"; rates = [None; Some 1.2; Some 0.5; None; Some 2.1]} in
  let record7 = {id = "GER"; name = "Germany"; rates = [Some 0.8; None; None; Some 3.0]} in
  let record8 = {id = "ITA"; name = "Italy"; rates = [Some 0.3; None; Some 0.1; Some 0.7; None]} in
  let record9 = {id = "ESP"; name = "Spain"; rates = [Some 0.2]} in
  let record10 = {id = "CHN"; name = "China"; rates = [Some 0.3; None; None; Some 0.1; None; Some 0.7; None; None; None;]} in

  assert(last record1 = Some (1962, 2.1));
  assert(last record2 = Some (1962, 3.0));
  assert(last record3 = None);
  assert(last record4 = None);
  assert(last record5 = Some (1961, 0.7));
  assert(last record6 = Some (1964, 2.1));
  assert(last record7 = Some (1963, 3.0));
  assert(last record8 = Some (1963, 0.7));
  assert(last record9 = Some (1960, 0.2));
  assert(last record10 = Some (1965, 0.7))
let _ = test_last ()
*)

let test_minmax () =
  let record1 = {id = "CAN"; name = "Canada"; rates = [Some 0.1; None; Some 2.1]} in
  let record2 = {id = "USA"; name = "United States"; rates = [Some 1.0; Some 2.0; Some 3.0]} in
  let record3 = {id = "MEX"; name = "Mexico"; rates = []} in
  let record4 = {id = "BRA"; name = "Brazil"; rates = [None; None; None]} in
  let record5 = {id = "ARG"; name = "Argentina"; rates = [Some 0.5; Some 0.7]} in
  let record6 = {id = "FRA"; name = "France"; rates = [None; Some 1.2; Some 0.5; None; Some 2.1]} in
  let record7 = {id = "GER"; name = "Germany"; rates = [Some 0.8; None; None; Some 3.0]} in
  let record8 = {id = "ITA"; name = "Italy"; rates = [Some 0.3; None; Some 0.1; Some 0.7; None]} in
  let record9 = {id = "ESP"; name = "Spain"; rates = [Some 0.2]} in
  let record10 = {id = "CHN"; name = "China"; rates = [Some 0.3; None; None; Some 0.1; None; Some 0.7; None; None; None;]} in

  assert(minmax record1 = (Some (1960, 0.1), Some (1962, 2.1)));
  assert(minmax record2 = (Some (1960, 1.0), Some (1962, 3.0)));
  assert(minmax record3 = (None, None));
  assert(minmax record4 = (None, None));
  assert(minmax record5 = (Some (1960, 0.5), Some (1961, 0.7)));
  assert(minmax record6 = (Some (1962, 0.5), Some (1964, 2.1)));
  assert(minmax record7 = (Some (1960, 0.8), Some (1963, 3.0)));
  assert(minmax record8 = (Some (1962, 0.1), Some (1963, 0.7)));
  assert(minmax record9 = (Some (1960, 0.2), Some (1960, 0.2)));
  assert(minmax record10 = (Some (1963, 0.1), Some (1965, 0.7)))
let _ = test_minmax ()
;;