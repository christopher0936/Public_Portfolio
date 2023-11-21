open Prob1 (* this is the _only_ place you should use `open` in this assignment *)

let test_is_older () =
  assert (is_older ((1990, 1, 1), (1995, 15, 1)) = true);
  assert (is_older ((1990, 1, 1), (1990, 2, 1)) = true);
  assert (is_older ((1990, 1, 1), (1990, 1, 2)) = true);
  assert (is_older ((1990, 1, 1), (1990, 1, 1)) = false);
  assert (is_older ((1990, 1, 2), (1990, 1, 1)) = false);
  assert (is_older ((1990, 2, 1), (1990, 1, 1)) = false);
  assert (is_older ((1995, 15, 1), (1990, 1, 1)) = false);
  assert (is_older ((3000, 12, 31), (1990, 1, 1)) = false);
  assert (is_older ((1990, 1, 1), (3000, 12, 31)) = true);
  assert (is_older ((1990, 12, 31), (1990, 12, 31)) = false);
  assert (is_older ((1990, 12, 31), (1990, 12, 30)) = false);
  assert (is_older ((1990, 12, 30), (1990, 12, 31)) = true);
  assert (is_older ((1990, 1, 31), (1990, 2, 1)) = true);
  assert (is_older ((1990, 2, 1), (1990, 1, 31)) = false);
  assert (is_older ((1990, 12, 31), (1991, 1, 1)) = true);
  assert (is_older ((1991, 1, 1), (1990, 12, 31)) = false);
  assert (is_older ((1990, 2, 28), (1990, 3, 1)) = true);
  assert (is_older ((1990, 3, 1), (1990, 2, 28)) = false);
  assert (is_older ((2000, 2, 29), (2000, 3, 1)) = true);
  assert (is_older ((2000, 3, 1), (2000, 2, 29)) = false);
  assert (is_older ((2000, 2, 28), (2000, 3, 1)) = true);
  assert (is_older ((2000, 3, 1), (2000, 2, 28)) = false);
  assert (is_older ((2000, 2, 29), (2000, 2, 29)) = false);
  assert (is_older ((2000, 2, 29), (2001, 3, 1)) = true);
  assert (is_older ((2001, 3, 1), (2000, 2, 29)) = false);
  assert (is_older ((2000, 2, 29), (2001, 2, 28)) = true);
  assert (is_older ((2001, 2, 28), (2000, 2, 29)) = false);
  assert (is_older ((2000, 2, 29), (2000, 2, 28)) = false);
  assert (is_older ((2000, 2, 28), (2000, 2, 29)) = true);
  assert (is_older ((2000, 1, 1), (2000, 1, 2)) = true)
let _ = test_is_older ()



let test_days_in_month () =
  assert (days_in_month (1990, 1) = Some 31);
  assert (days_in_month (2000, 2) = Some 29);
  assert (days_in_month (2001, 2) = Some 28);
  assert (days_in_month (2000, 4) = Some 30);
  assert (days_in_month (2000, 6) = Some 30);
  assert (days_in_month (2000, 9) = Some 30);
  assert (days_in_month (2000, 11) = Some 30);
  assert (days_in_month (2000, 12) = Some 31);
  assert (days_in_month (2000, 13) = None);
  assert (days_in_month (2020, 2) = Some 29);
  assert (days_in_month (2021, 2) = Some 28);
  assert (days_in_month (2022, 2) = Some 28);
  assert (days_in_month (2000, 0) = None);
  assert (days_in_month (2000, 14) = None);
  assert (days_in_month (2000, 15) = None);
  assert (days_in_month (2000, -1) = None);
  assert (days_in_month (2000, -2) = None);
  assert (days_in_month (2000, -3) = None);
  assert (days_in_month (2000, -4) = None);
  assert (days_in_month (2023, 1) = Some 31);
  assert (days_in_month (2023, 15) = None)
let _ = test_days_in_month ()


let test_dates_in_month () =
  assert (dates_in_month (2023, 1) = Some [(2023, 1, 1); (2023, 1, 2); (2023, 1, 3); (2023, 1, 4); (2023, 1, 5); (2023, 1, 6); (2023, 1, 7); (2023, 1, 8); (2023, 1, 9); (2023, 1, 10); (2023, 1, 11); (2023, 1, 12); (2023, 1, 13); (2023, 1, 14); (2023, 1, 15); (2023, 1, 16); (2023, 1, 17); (2023, 1, 18); (2023, 1, 19); (2023, 1, 20); (2023, 1, 21); (2023, 1, 22); (2023, 1, 23); (2023, 1, 24); (2023, 1, 25); (2023, 1, 26); (2023, 1, 27); (2023, 1, 28); (2023, 1, 29); (2023, 1, 30); (2023, 1, 31)]);
  assert (dates_in_month (2022, 2) = Some[(2022, 2, 1); (2022, 2, 2); (2022, 2, 3); (2022, 2, 4); (2022, 2, 5); (2022, 2, 6); (2022, 2, 7); (2022, 2, 8); (2022, 2, 9); (2022, 2, 10); (2022, 2, 11); (2022, 2, 12); (2022, 2, 13); (2022, 2, 14); (2022, 2, 15); (2022, 2, 16); (2022, 2, 17); (2022, 2, 18); (2022, 2, 19); (2022, 2, 20); (2022, 2, 21); (2022, 2, 22); (2022, 2, 23); (2022, 2, 24); (2022, 2, 25); (2022, 2, 26); (2022, 2, 27); (2022, 2, 28)] );
  assert (dates_in_month (2000, 2) = Some[(2000, 2, 1); (2000, 2, 2); (2000, 2, 3); (2000, 2, 4); (2000, 2, 5); (2000, 2, 6); (2000, 2, 7); (2000, 2, 8); (2000, 2, 9); (2000, 2, 10); (2000, 2, 11); (2000, 2, 12); (2000, 2, 13); (2000, 2, 14); (2000, 2, 15); (2000, 2, 16); (2000, 2, 17); (2000, 2, 18); (2000, 2, 19); (2000, 2, 20); (2000, 2, 21); (2000, 2, 22); (2000, 2, 23); (2000, 2, 24); (2000, 2, 25); (2000, 2, 26); (2000, 2, 27); (2000, 2, 28); (2000, 2, 29)] );
  assert (dates_in_month (2022, 4)= Some [(2022, 4, 1); (2022, 4, 2); (2022, 4, 3); (2022, 4, 4); (2022, 4, 5); (2022, 4, 6); (2022, 4, 7); (2022, 4, 8); (2022, 4, 9); (2022, 4, 10); (2022, 4, 11); (2022, 4, 12); (2022, 4, 13); (2022, 4, 14); (2022, 4, 15); (2022, 4, 16); (2022, 4, 17); (2022, 4, 18); (2022, 4, 19); (2022, 4, 20); (2022, 4, 21); (2022, 4, 22); (2022, 4, 23); (2022, 4, 24); (2022, 4, 25); (2022, 4, 26); (2022, 4, 27); (2022, 4, 28); (2022, 4, 29); (2022, 4, 30)]);
  assert (dates_in_month (2022, 6)  = Some [(2022, 6, 1); (2022, 6, 2); (2022, 6, 3); (2022, 6, 4); (2022, 6, 5); (2022, 6, 6); (2022, 6, 7); (2022, 6, 8); (2022, 6, 9); (2022, 6, 10); (2022, 6, 11); (2022, 6, 12); (2022, 6, 13); (2022, 6, 14); (2022, 6, 15); (2022, 6, 16); (2022, 6, 17); (2022, 6, 18); (2022, 6, 19); (2022, 6, 20); (2022, 6, 21); (2022, 6, 22); (2022, 6, 23); (2022, 6, 24); (2022, 6, 25); (2022, 6, 26); (2022, 6, 27); (2022, 6, 28); (2022, 6, 29); (2022, 6, 30)]);
  assert (dates_in_month (2022, 9) = Some [(2022, 9, 1); (2022, 9, 2); (2022, 9, 3); (2022, 9, 4); (2022, 9, 5); (2022, 9, 6); (2022, 9, 7); (2022, 9, 8); (2022, 9, 9); (2022, 9, 10); (2022, 9, 11); (2022, 9, 12); (2022, 9, 13); (2022, 9, 14); (2022, 9, 15); (2022, 9, 16); (2022, 9, 17); (2022, 9, 18); (2022, 9, 19); (2022, 9, 20); (2022, 9, 21); (2022, 9, 22); (2022, 9, 23); (2022, 9, 24); (2022, 9, 25); (2022, 9, 26); (2022, 9, 27); (2022, 9, 28); (2022, 9, 29); (2022, 9, 30)]);
  assert (dates_in_month (2022, 11) = Some[(2022, 11, 1); (2022, 11, 2); (2022, 11, 3); (2022, 11, 4); (2022, 11, 5); (2022, 11, 6); (2022, 11, 7); (2022, 11, 8); (2022, 11, 9); (2022, 11, 10); (2022, 11, 11); (2022, 11, 12); (2022, 11, 13); (2022, 11, 14); (2022, 11, 15); (2022, 11, 16); (2022, 11, 17); (2022, 11, 18); (2022, 11, 19); (2022, 11, 20); (2022, 11, 21); (2022, 11, 22); (2022, 11, 23); (2022, 11, 24); (2022, 11, 25); (2022, 11, 26); (2022, 11, 27); (2022, 11, 28); (2022, 11, 29); (2022, 11, 30)] );
  assert (dates_in_month (2022, 12) = Some [(2022, 12, 1); (2022, 12, 2); (2022, 12, 3); (2022, 12, 4); (2022, 12, 5); (2022, 12, 6); (2022, 12, 7); (2022, 12, 8); (2022, 12, 9); (2022, 12, 10); (2022, 12, 11); (2022, 12, 12); (2022, 12, 13); (2022, 12, 14); (2022, 12, 15); (2022, 12, 16); (2022, 12, 17); (2022, 12, 18); (2022, 12, 19); (2022, 12, 20); (2022, 12, 21); (2022, 12, 22); (2022, 12, 23); (2022, 12, 24); (2022, 12, 25); (2022, 12, 26); (2022, 12, 27); (2022, 12, 28); (2022, 12, 29); (2022, 12, 30); (2022, 12, 31)]);
  assert (dates_in_month (2022, 0) = None );
  assert (dates_in_month (2022, -1) = None );
  assert (dates_in_month (0, 1) = None);
  assert (dates_in_month (-1, 1) = None);
  assert (dates_in_month (-1, -1) = None);
  assert (dates_in_month (3001, 1) = None);
  assert (dates_in_month (2000, 15) = None)
let _ = test_dates_in_month ()

let test_num_of_days () =
  (* Test valid date *)
  assert (num_of_days (2022, 2, 15) = Some (46));

  (* Test invalid year *)
  assert (num_of_days (0, 2, 15) = None);
  assert (num_of_days (3001, 2, 15) = None);

  (* Test invalid month *)
  assert (num_of_days (2022, 0, 15) = None);
  assert (num_of_days (2022, 13, 15) = None);

  (* Test invalid day *)
  assert (num_of_days (2022, 2, 0) = None);
  assert (num_of_days (2022, 2, 29) = None);
  assert (num_of_days (2022, 4, 31) = None);
  assert (num_of_days (2022, 6, 31) = None);
  assert (num_of_days (2022, 9, 31) = None);
  assert (num_of_days (2022, 11, 31) = None);

  (* Test leap year *)
  assert (num_of_days (2000, 2, 29) = Some (60));
  assert (num_of_days (1900, 2, 29) = None);

  (* Additional test cases *)
  assert (num_of_days (2022, 1, 1) = Some (1));
  assert (num_of_days (2022, 12, 31) = Some (365));
  assert (num_of_days (2021, 2, 28) = Some (59));
  assert (num_of_days (2020, 2, 29) = Some (60));
  assert (num_of_days (2000, 2, 28) = Some (59))
let _ = test_num_of_days ()  

let test_nth_day () =
  (* Test valid input *)
  assert (nth_day (2020, 1) = Some (2020, 1, 1));
  assert (nth_day (2020, 59) = Some (2020, 2, 28));
  assert (nth_day (2020, 60) = Some (2020, 2, 29));
  assert (nth_day (2021, 59) = Some (2021, 2, 28));
  assert (nth_day (2021, 60) = Some (2021, 3, 1));
  assert (nth_day (2000, 59) = Some (2000, 2, 28));
  assert (nth_day (2000, 60) = Some (2000, 2, 29));
  assert (nth_day (2000, 365) = Some (2000, 12, 30));
  
  (* Test invalid year *)
  assert (nth_day (0, 1) = None);
  assert (nth_day (3001, 1) = None);
  
  (* Test invalid number *)
  assert (nth_day (2000, 0) = None);
  assert (nth_day (2010, 366) = None);
  assert (nth_day (2000, 367) = None);
  
  (* Test leap year *)
  assert (nth_day (2000, 366) = Some (2000, 12, 31));
  assert (nth_day (2004, 366) = Some (2004, 12, 31))
let _ = test_nth_day ()
;;