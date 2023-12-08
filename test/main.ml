open OUnit2
open Game
open Terminalentry


let terminal_tests =
  [
    ( "make_fish_string" >:: fun _ ->
      let expected_fish = "🐟🐟🐟" in
      let fish = make_fish_string "🐟" 3 "" in
      assert_equal expected_fish fish );
    ( "make_fish_string_zero_count" >:: fun _ ->
      let expected_fish = "" in
      let fish = make_fish_string "🐟" 0 "" in
      assert_equal expected_fish fish );
  ]

let suite = "Final project test suite" >::: List.flatten [ terminal_tests ]
let () = run_test_tt_main suite
