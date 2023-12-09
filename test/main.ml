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

let box_collision_test out in1 in2 _ =
  assert_equal ~printer:string_of_bool
    ~msg:(Printf.sprintf "function: Box.colliding\ninput: ")
    out (Box.colliding in1 in2)

let box1 = Box.generate 120. 120. 10. 10.
let box2 = Box.generate 120. 120. 0.5 0.5

let box_tests =
  [
    (let mouse = Vector2.create 100. 100. in
     "Box.colliding: false" >:: box_collision_test false mouse box1);
    (let mouse = Vector2.create 125. 125. in
     "Box.colliding: true" >:: box_collision_test true mouse box1);
    (let mouse = Vector2.create 119. 119. in
     "Box.colliding: false, more accuracy"
     >:: box_collision_test false mouse box2);
    (let mouse = Vector2.create 120. 120. in
     "Box.colliding: true, more accuracy" >:: box_collision_test true mouse box2);
  ]

let rec update_score_from_lst score lst =
  match lst with
  | [] -> score
  | h :: t ->
      Score.update_score score h;
      update_score_from_lst score t

let score_test out in1 _ =
  assert_equal ~printer:string_of_int
    ~msg:(Printf.sprintf "function: Score.update_score\ninput: ")
    out
    (Score.get_score (update_score_from_lst (Score.new_score ()) in1))

let score_tests =
  [
    "Score.update_score: zero" >:: score_test 0 [];
    "Score.update_score: one" >:: score_test 1 [ 1 ];
    "Score.update_score: three, multiple updates" >:: score_test 3 [ 1; 2 ];
    "Score.update_score: negative three, multiple updates"
    >:: score_test (-3) [ -1; -2 ];
    "Score.update_score: negative 126, multitude of updates"
    >:: score_test (-126) [ -1; -2; -3; -6; 6; -120 ];
  ]

let rec move_boat_from_lst boat lst =
  match lst with
  | [] -> ()
  | (dx, dy) :: t ->
      Boat.move boat dx dy;
      move_boat_from_lst boat t

let boat_test out in1 _ =
  assert_equal
    ~msg:(Printf.sprintf "function: Boat.move\ninput: ")
    out
    (let boat = Boat.new_boat 310. 260. 30. 20. in
     move_boat_from_lst boat in1;
     Boat.border_crossed boat;
     (Boat.get_x boat, Boat.get_y boat))

let boat_tests =
  [
    "Boat: new_boat" >:: boat_test (310., 260.) [];
    "Boat: new_boat minus and plus 10 on each x and y, canceling movements"
    >:: boat_test (310., 260.) [ (-10., -10.); (10., 10.) ];
    "Boat: new_boat, x + 50 and y - 100"
    >:: boat_test (360., 160.) [ (50., -100.) ];
    "Boat: new_boat, x + 30 and y + 100, multiple movements"
    >:: boat_test (340., 360.) [ (50., -100.); (-20., 200.) ];
    "Boat: new_boat, multiple movements, ends (305, 397)"
    >:: boat_test (305., 397.)
          [ (50., -100.); (-49., 2.); (-20., 200.); (14., 35.) ];
    "Boat: new_boat, border collision check for x"
    >:: boat_test (512., 260.) [ (-700., 0.) ];
    "Boat: new_boat, border collision check for y"
    >:: boat_test (310., 512.) [ (0., -500.) ];
  ]

let suite =
  "final project test suite"
  >::: List.flatten [ terminal_tests; box_tests; score_tests; boat_tests ]

let () = run_test_tt_main suite
