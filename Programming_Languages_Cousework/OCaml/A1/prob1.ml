(* =============
Chris McLaughlin
V00912353   
============= *)

(* From Assignment Spec *)
let fst3 (x, _, _) = x;;
let snd3 (_, x, _) = x;;
let thd3 (_, _, x) = x;;

(* is_leapyear - helper func*)
let is_leapyear year =
  year mod 4 = 0 && ((not (year mod 100 = 0)) || year mod 400 = 0)
;;

(* is_valid_date - helper func *)
let is_valid_date date =
  (1 <= fst3 date && fst3 date <= 3000) &&
  (1 <= snd3 date && snd3 date <= 12) &&
  (1 <= thd3 date) &&

  (* Check days in month *)
  (
  (* Month is Jan,Mar,May,Jul,Aug,Oct,Dec and day less than or equal to 31*)
  ((snd3 date = 1||snd3 date = 3||snd3 date = 5||snd3 date = 7||snd3 date = 8||snd3 date = 10||snd3 date = 12)&&(thd3 date <= 31))||
  ((snd3 date = 4||snd3 date = 6||snd3 date = 9||snd3 date = 11)&&(thd3 date <= 30))||
  (snd3 date = 2 && thd3 date <= 28)||
  (snd3 date = 2 && thd3 date <= 29 && is_leapyear (fst3 date))
  )
;;

let is_valid_year_month date =
  (1 <= fst date && fst date <= 3000) &&
  (1 <= snd date && snd date <= 12)
;;

(* is_older *)
let is_older (date1, date2) =
  (* YEARS *)
  if fst3 date1 < fst3 date2 then (* If year of date1 less than year of date2, then it MUST be before, no further eval needed, return true *)
    true
  else
    if fst3 date1 > fst3 date2 then
      false (* Likewise if year of date1 greater than year of date2, then it MUST be after, no further eval needed, return false *)
    else (* Year is equal - we need to do months *)
      (*MONTHS*)
      if snd3 date1 < snd3 date2 then (* If month of date1 less than month of date2, then it MUST be before, no further eval needed, return true *)
        true
      else
        if snd3 date1 > snd3 date2 then
          false (* Likewise if month of date1 greater than month of date2, then it MUST be after, no further eval needed, return false *)
        else (* Year is equal - we need to do days *)
          (*DAYS*)
          thd3 date1 < thd3 date2(* If day of date1 less than day of date2, then it MUST be before, OTHERWISE it must be greater than date2 or the same as date2, since this is an if x true else false scenario we can just take the bool of the comparison directly*)
;;


let days_in_month yearmonth =
  if not (is_valid_year_month yearmonth) then
    None
  else
    (* This is similar to the valid date checker! *)
    if (snd yearmonth = 1||snd yearmonth = 3||snd yearmonth = 5||snd yearmonth = 7||snd yearmonth = 8||snd yearmonth = 10||snd yearmonth = 12) then
      Some 31
    else
      if (snd yearmonth = 4||snd yearmonth = 6||snd yearmonth = 9||snd yearmonth = 11) then
        Some 30
      else (* is Feb *)
        if is_leapyear (fst yearmonth) then
          Some 29
        else
          Some 28
;;

let dates_in_month yearmonth =
  if not (is_valid_year_month yearmonth) then
    None
  else
    let rec date_countup (date3tup) =
      if thd3 date3tup = Option.get (days_in_month yearmonth)+1 then
        []
      else
        date3tup :: date_countup(fst3 date3tup, snd3 date3tup, thd3 date3tup+1)
    in
      Some (date_countup (fst yearmonth, snd yearmonth, 1))
;;

let num_of_days date =
  if not (is_valid_date date) then
    None
  else
    let rec sum_month_days int_yearmonth =
      if snd int_yearmonth = 0 then
        0
      else
        Option.get (days_in_month int_yearmonth) + sum_month_days (fst int_yearmonth, (snd int_yearmonth)-1)
    in
      Some ( (sum_month_days(fst3 date, (snd3 date)-1)) + thd3 date )
;;

let nth_day year_num =
  (* Check validity - no helper function for this format so do it manually *)
  if ((not (1 <= fst year_num && fst year_num <= 3000)) || (snd year_num > Option.get (num_of_days ((fst year_num),12,31)))) || not (1 <= snd year_num && snd year_num <= 366) then
    None
  else
    let rec cumulative_add month_cumulativetotal_tup =
      let numdaysincurrmonth = Option.get (days_in_month(fst year_num, fst month_cumulativetotal_tup)) in
      let cumulative_and_currmonth = (snd month_cumulativetotal_tup)+numdaysincurrmonth in
      if cumulative_and_currmonth >= snd year_num then (* if cumulative total AT CURRMONTH >= n *)
        (fst month_cumulativetotal_tup, (snd year_num) - (snd month_cumulativetotal_tup)) (* "return" current month and n - cumulativetotal of all prior months, ie date day *)
      else
        cumulative_add (((fst month_cumulativetotal_tup)+1), ((snd month_cumulativetotal_tup) + Option.get (days_in_month(fst year_num, fst month_cumulativetotal_tup))))
    in
      let result = cumulative_add(1,0) in
        Some (fst year_num, fst result, snd result)
;;