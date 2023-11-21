(* =============
Chris McLaughlin
V00912353   
============= *)

let read_file path =
  let fp = open_in path in
  let s = really_input_string fp (in_channel_length fp) in
  close_in fp;
  s
;;

type country = { id : string;
                 name : string;
                 rates : float option list }
;;


(* Begin functions for get_records - these helper funcs could be made into local functions but it wouldn't really save space and they might be useful later *)
let filestring_to_list_of_lists filestring =
  let rowlist = (String.split_on_char '\n') filestring in (* Parse file to list of strings, one string for each row *)

  let rec rowlist_to_list_of_lists in_rowlist = (* Parses string list of rows to list of lists *)
    match in_rowlist with
    | row :: rows -> ((String.split_on_char ',') row) :: rowlist_to_list_of_lists(rows)
    | [] -> []
  in
    rowlist_to_list_of_lists rowlist
;;

let rec stringvallist_to_float_opt_list stringvallist =
  match stringvallist with
  | value::restoflist -> Float.of_string_opt value :: stringvallist_to_float_opt_list(restoflist)
  | [] -> []
;;


let list_to_country in_list_for_row =
  match in_list_for_row with
  | cname::cid::crates_list -> { id=cid; name=cname; rates=(stringvallist_to_float_opt_list(crates_list))}
  | _ -> failwith "list_to_country was passed an ill-formatted list, which shouldnt be possible per assignment spec"
;;

let get_records filestring =
  let list_of_lists = filestring_to_list_of_lists (filestring) in
  
  let rec build_country_list in_lol =
    match in_lol with
    | listforrow::restofrows -> list_to_country(listforrow)::build_country_list(restofrows)
    | [] -> []
  in
  build_country_list list_of_lists
;;


(* Avail *)
let avail in_country =
  let rec add_avail (rateslist,acc) =
    match rateslist with
    | [] -> acc
    | entry::more_entries -> (add_avail[@tailcall])(more_entries,(match entry with | None -> 0 | _ -> 1)+acc) (* Will throw a warn 51 if this ISN'T a tailcall, but it is so it doesn't *)
  in
  add_avail(in_country.rates, 0)
;;

(* Last *)
let last in_country =
  let rec rev_tail(inlist,acc) =
    match inlist with
    | [] -> acc
    | x::xs -> (rev_tail[@tailcall]) (xs, x::acc)
  in
  let rec get_first_some_and_year (list,num_cd) =
    match list with
    | entry::more_entries -> (match entry with | Some i -> Some (num_cd, i) | _ -> get_first_some_and_year(more_entries,num_cd-1))
    | [] -> None
  in
  let revd = rev_tail(in_country.rates, []) in
  (get_first_some_and_year[@tailcall])(revd,2021)
;;

(* minmax *)
(* two tail recursive functions, one after the other, is fine, since compiler will simply make overall minmax func 2*O(n) which is still O(n) *)
let minmax in_country =
  let rec get_max (year,in_rates) = (*want this to be int*(float option list) -> int*(float option)*)
    match in_rates with
    | singleval::[] -> (year,singleval)
    | val1opt::val2opt::[] ->
      (match (val1opt,val2opt) with
      | (Some flt1, Some flt2) -> if flt2 >= flt1 then (year+1,Some flt2) else (year,Some flt1)
      | (Some flta, None) -> (year,Some flta)
      | (None, Some fltb) -> (year+1,Some fltb)
      | (None, None) -> (year,None)
      )
    | valopta::morevalues ->
      (let max_of_morevalues = get_max(year+1,morevalues) in
      let (maxyear, maxoption) = max_of_morevalues in
      if maxoption = None then (year, valopta) else (* If this check clear, we know we have a (Year,Some float) case in max_of_more_values and can continue, since any None case will have send up a None at the check *)

      match (valopta,maxoption) with
      | (Some flt1, Some flt2) -> if flt2 >= flt1 then (maxyear,Some flt2) else (year,Some flt1)
      | (Some flta, None) -> (year,Some flta)
      | (None, Some fltb) -> (maxyear,Some fltb)
      | (None, None) -> (year,None)
      )
    | [] -> (year,None)
  in
  
  (* Get eventual max compenent by processing result of get_max *)
  let (max_result_year, max_result_rate) = get_max (1960, in_country.rates) in
  let max_component = match max_result_rate with
  | None -> None
  | Some rate -> Some (max_result_year, rate)
  in
  
  let rec get_min (year,in_rates) =
    match in_rates with
    | singleval::[] -> (year,singleval)
    | val1opt::val2opt::[] ->
      (match (val1opt,val2opt) with
      | (Some flt1, Some flt2) -> if flt2 <= flt1 then (year+1,Some flt2) else (year,Some flt1)
      | (Some flta, None) -> (year,Some flta)
      | (None, Some fltb) -> (year+1,Some fltb)
      | (None, None) -> (year,None)
      )
    | valopta::morevalues ->
      (let min_of_morevalues = get_min(year+1,morevalues) in
      let (minyear, minoption) = min_of_morevalues in
      if minoption = None then (year, valopta) else (* If this check clear, we know we have a (Year,Some float) case in min_of_more_values and can continue, since any None case will have send up a None at the check *)

      match (valopta,minoption) with
      | (Some flt1, Some flt2) -> if flt2 <= flt1 then (minyear,Some flt2) else (year,Some flt1)
      | (Some flta, None) -> (year,Some flta)
      | (None, Some fltb) -> (minyear,Some fltb)
      | (None, None) -> (year,None)
      )
    | [] -> (year,None)
    in

    (* Now get min component *)
    let (min_result_year, min_result_rate) = get_min (1960, in_country.rates) in
    let min_component = match min_result_rate with
    | None -> None
    | Some rate -> Some (min_result_year, rate)
    in

  (* Now assemble tuple result*)
  (min_component,max_component)
;;

(* Summarize *)
let summarize (list_of_countries, country_id) =
  (* Get the country's record from the list of countries *)
  let rec get_country_from_list_by_id (l_o_c, c_id) =
    match l_o_c with
    | [] -> None
    | country::more_countries -> if country.id = c_id then Some country else get_country_from_list_by_id(more_countries, c_id)
  in

  let somecountry = get_country_from_list_by_id (list_of_countries, country_id) in
  if somecountry = None then ("Cannot find "^country_id) else
  let acountry = match somecountry with | Some country -> country | _ -> failwith ("Cannot find "^country_id) in
  
  let rec_avail = avail (acountry) in
  let rec_last = last(acountry) in
  let rec_min,rec_max = minmax(acountry) in (* both of these will be (int*float) options *)

  let str_country = "Country: "^acountry.name^" ("^acountry.id^")" in

  let str_avail = "Records available: "^(string_of_int rec_avail)^" years" in

  let str_last = match rec_last with
  | Some (lastyear, lastrate) -> "Last record: "^(string_of_int lastyear)^" with rate of "^(string_of_float lastrate)^"%"
  | None -> "Last record: <N/A - No rates>"
  in

  let str_min = match rec_min with
  | Some (minyear, minrate) -> "Lowest rate: "^(string_of_int minyear)^" with rate of "^(string_of_float minrate)^"%"
  | None -> "Lowest rate: <N/A - No lowest rate>"
  in

  let str_max = match rec_max with
  | Some (maxyear, maxrate) -> "Highest rate: "^(string_of_int maxyear)^" with rate of "^(string_of_float maxrate)^"%"
  | None -> "Highest rate: <N/A - No highest rate>"
  in

  str_country^"\n"^str_avail^"\n"^str_last^"\n"^str_min^"\n"^str_max
;;