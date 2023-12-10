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

(* Test boxes for certain unit test cases. *)
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
    ( "Box.generate small box, x-y coordinates, width, and height quadruple"
    >:: fun _ ->
      let box_small = Box.generate 22. 21. 5. 4. in
      assert_equal
        ( Rectangle.x (Rectangle.create 22. 21. 5. 4.),
          Rectangle.y (Rectangle.create 22. 21. 5. 4.),
          Rectangle.width (Rectangle.create 22. 21. 5. 4.),
          Rectangle.height (Rectangle.create 22. 21. 5. 4.) )
        ( Box.get_coord "x" box_small,
          Box.get_coord "y" box_small,
          Box.get_coord "width" box_small,
          Box.get_coord "height" box_small ) );
    ( "Box.generate large box, x-y coordinates, width, and height quadruple"
    >:: fun _ ->
      let box_small = Box.generate 450. 857. 225.55 856.1 in
      assert_equal
        ( Rectangle.x (Rectangle.create 450. 857. 225.55 856.1),
          Rectangle.y (Rectangle.create 450. 857. 225.55 856.1),
          Rectangle.width (Rectangle.create 450. 857. 225.55 856.1),
          Rectangle.height (Rectangle.create 450. 857. 225.55 856.1) )
        ( Box.get_coord "x" box_small,
          Box.get_coord "y" box_small,
          Box.get_coord "width" box_small,
          Box.get_coord "height" box_small ) );
    ( "Box.generate 0-dimension box, x-y coordinates, width, and height \
       quadruple"
    >:: fun _ ->
      let box_small = Box.generate 0. 0. 0. 0. in
      assert_equal
        ( Rectangle.x (Rectangle.create 0. 0. 0. 0.),
          Rectangle.y (Rectangle.create 0. 0. 0. 0.),
          Rectangle.width (Rectangle.create 0. 0. 0. 0.),
          Rectangle.height (Rectangle.create 0. 0. 0. 0.) )
        ( Box.get_coord "x" box_small,
          Box.get_coord "y" box_small,
          Box.get_coord "width" box_small,
          Box.get_coord "height" box_small ) );
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
    "Score.update_score: positive 122, multitude of updates"
    >:: score_test 122 [ 1; 2; -3; 6; -6; 120; 0; 0; 0; 2 ];
  ]

let rec move_boat_from_lst boat lst =
  match lst with
  | [] -> ()
  | (dx, dy) :: t ->
      Boat.move boat dx dy;
      move_boat_from_lst boat t

let boat_move_test out in1 _ =
  assert_equal
    ~msg:(Printf.sprintf "function: Boat.move\ninput: ")
    out
    (let boat = Boat.new_boat 310. 260. 30. 20. in
     move_boat_from_lst boat in1;
     Boat.border_crossed boat;
     (Boat.get_x boat, Boat.get_y boat))

let boat_angle_test out in1 _ =
  let boat_45 = Boat.new_boat 240. 240. 30. 20. in
  assert_equal ~printer:string_of_float
    ~msg:
      (Printf.sprintf "function: Boat.get_boat_angle\ninput: %s"
         (string_of_float (Boat.get_boat_angle boat_45 in1)))
    out
    (Boat.get_boat_angle boat_45 in1)

let formatted_border_cross_string expect =
  Printf.sprintf
    "function: Boat.is_border_crossed\ninput: Boat position %.2f, %.2f\n"
    (fst expect) (snd expect)

let boat_tests =
  [
    "Boat: new_boat" >:: boat_move_test (310., 260.) [];
    "Boat: new_boat minus and plus 10 on each x and y, canceling movements"
    >:: boat_move_test (310., 260.) [ (-10., -10.); (10., 10.) ];
    "Boat: new_boat, x + 50 and y - 100"
    >:: boat_move_test (360., 160.) [ (50., -100.) ];
    "Boat: new_boat, x + 30 and y + 100, multiple movements"
    >:: boat_move_test (340., 360.) [ (50., -100.); (-20., 200.) ];
    "Boat: new_boat, multiple movements, ends (305, 397)"
    >:: boat_move_test (305., 397.)
          [ (50., -100.); (-49., 2.); (-20., 200.); (14., 35.) ];
    "Boat: new_boat, border collision check for x"
    >:: boat_move_test (512., 260.) [ (-700., 0.) ];
    "Boat: new_boat, border collision check for y"
    >:: boat_move_test (310., 512.) [ (0., -500.) ];
    "Boat: draw boat positioned at 45 degrees math case 1"
    >:: boat_angle_test 45. (true, true, false, false);
    "Boat: draw boat positioned at 45 degrees match case 2"
    >:: boat_angle_test 45. (false, false, true, true);
    "Boat: draw boat positioned at 135 degrees match case 1"
    >:: boat_angle_test 135. (false, true, true, false);
    "Boat: draw boat positioned at 135 degrees match case 2"
    >:: boat_angle_test 135. (true, false, false, true);
    "Boat: draw boat positioned at 90 degrees match case 1"
    >:: boat_angle_test 90. (true, false, false, false);
    "Boat: draw boat positioned at 90 degrees match case 2"
    >:: boat_angle_test 90. (false, false, true, false);
    "Boat: draw boat positioned at 90 degrees match case 3"
    >:: boat_angle_test 90. (false, true, true, true);
    "Boat: draw boat positioned at 90 degrees match case 4"
    >:: boat_angle_test 90. (true, true, false, true);
    "Boat: draw boat positioned at 0 degrees wildcard case 1"
    >:: boat_angle_test 0. (false, false, false, false);
    "Boat: draw boat positioned at 0 degrees wildcard case 2"
    >:: boat_angle_test 0. (true, true, true, false);
    "Boat: draw boat positioned at 0 degrees wildcard case 3"
    >:: boat_angle_test 0. (true, false, true, true);
    "Boat: draw boat positioned at 0 degrees wildcard case 4"
    >:: boat_angle_test 0. (true, true, true, true);

  ]

let suite =
  "final project test suite"
  >::: List.flatten [ terminal_tests; box_tests; score_tests; boat_tests ]

let () = run_test_tt_main suite
