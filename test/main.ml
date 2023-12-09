open OUnit2
open Game
open Terminalentry
open Box
open Raylib
open Vector2
open Boat
open Coin
open Score

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

let box_tests =
  [
    ( "box colliding false" >:: fun _ ->
      let box = Box.generate 120. 120. 10. 10. in
      let mouse = Vector2.create 100. 100. in
      assert_equal false (Box.colliding mouse box) );
    ( "box colliding true" >:: fun _ ->
      let box = Box.generate 120. 120. 10. 10. in
      let mouse = Vector2.create 125. 125. in
      assert_equal true (Box.colliding mouse box) );
    ( "box colliding more accurate false" >:: fun _ ->
      let box = Box.generate 120. 120. 10. 10. in
      let mouse = Vector2.create 119. 119. in
      assert_equal false (Box.colliding mouse box) );
    ( "box colliding more accurate true" >:: fun _ ->
      let box = Box.generate 120. 120. 1. 1. in
      let mouse = Vector2.create 120. 120. in
      assert_equal true (Box.colliding mouse box) );
  ]

let score_tests =
  [
    ( "score is zero" >:: fun _ ->
      let score0 = Score.new_score () in
      assert_equal 0 (Score.get_score score0) );
    ( "score is one" >:: fun _ ->
      let score1 = Score.new_score () in
      Score.update_score score1 1;
      assert_equal 1 (Score.get_score score1) );
    ( "score is three, multiple updates" >:: fun _ ->
      let score3 = Score.new_score () in
      Score.update_score score3 1;
      Score.update_score score3 2;
      assert_equal 3 (Score.get_score score3) );
    ( "score is negative 3, multiple updates" >:: fun _ ->
      let score_n3 = Score.new_score () in
      Score.update_score score_n3 1;
      Score.update_score score_n3 (-2);
      assert_equal (-1) (Score.get_score score_n3) );
  ]

let suite =
  "final project test suite"
  >::: List.flatten [ terminal_tests; box_tests; score_tests ]

let () = run_test_tt_main suite
