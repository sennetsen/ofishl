open OUnit2
open Game
open Terminalentry
open Box
open Raylib
open Vector2
open Boat
open Score
open Sprites
open Constants
open Window
open Loadables
open Gamestats
open AudioSprite

(**Test Plan: Because the nature of the game returns most values as units, the
   test suite functions to ensure text functions in the terminal, collision
   logistics, and values such as boat angle and position, score, and other
   variables are working as intended. More specifically, it tests the modules
   [Boat], [Box], [Score], [Sprites], and [Terminalentry]. Modules like
   [Gamestats] and [Window] are manually tested by running the game and
   observing that everything runs as intended (this contributes to the majority
   of our testing). Testing in OUnit is primarily glass-box with asserts to
   check the functions are executing with the behavior that the implementors
   intended. The actual coverage illustrated by [make bisect] is not indicative
   of the correctness of our program, we merely used it as a tool to identify
   potential areas for testing since many functions can only be tested manually
   by running the game. Correctness is ensured by the fact that our game runs
   free of bugs and exactly as intended, supplemented by the fact that our OUnit
   suite passes. *)

let filepath_test_string in1 =
  Printf.sprintf "function: Gamestats.output_file\ninput: %s" in1

let terminal_tests =
  [
    (* Tests for make_fish_string function in terminal user interaction. *)
    ( "make_fish_string, zero count" >:: fun _ ->
      let expected_fish = "" in
      let fish = Terminalentry.make_fish_string "🐟" 0 "" in
      assert_equal expected_fish fish );
    ( "make_fish_string, one count" >:: fun _ ->
      let expected_fish = "" in
      let fish = Terminalentry.make_fish_string "🐟" 0 "" in
      assert_equal expected_fish fish );
    ( "make_fish_string, multiple count" >:: fun _ ->
      let expected_fish = "🐟🐟🐟🐟🐟" in
      let fish = Terminalentry.make_fish_string "🐟" 5 "" in
      assert_equal expected_fish fish );
    ( "make_fish_string, non-emoji one count" >:: fun _ ->
      let expected_fish = "@" in
      let fish = Terminalentry.make_fish_string "@" 1 "" in
      assert_equal expected_fish fish );
    ( "make_fish_string, non-emoji multiple count" >:: fun _ ->
      let expected_fish = "-------" in
      let fish = Terminalentry.make_fish_string "-" 7 "" in
      assert_equal expected_fish fish );
    ( "make_fish_string, emoji and ASCII character multiple count" >:: fun _ ->
      let expected_fish = "🐪$🐠🐪$🐠🐪$🐠" in
      let fish = Terminalentry.make_fish_string "🐪$🐠" 3 "" in
      assert_equal expected_fish fish );
    (* Tests for Gamestats output_file function in terminal user interaction. *)
    ( "Gamestats output_file, empty user string" >:: fun _ ->
      let name = "" in
      let filename = Gamestats.output_file name in
      let expected = "player_data/_stats.txt" in
      assert_equal ~msg:(filepath_test_string name) expected filename );
    ( "Gamestats output_file, multiple character user string" >:: fun _ ->
      let name = "James" in
      let filename = Gamestats.output_file name in
      let expected = "player_data/James_stats.txt" in
      assert_equal ~msg:(filepath_test_string name) expected filename );
    ( "Gamestats output_file, first and last name user string" >:: fun _ ->
      let name = "James Smith" in
      let filename = Gamestats.output_file name in
      let expected = "player_data/James Smith_stats.txt" in
      assert_equal ~msg:(filepath_test_string name) expected filename );
    ( "Gamestats output_file, emoji user string" >:: fun _ ->
      let name = "🐠" in
      let filename = Gamestats.output_file name in
      let expected = "player_data/🐠_stats.txt" in
      assert_equal ~msg:(filepath_test_string name) expected filename );
    ( "Gamestats output_file, emoji and ASCII mixed user string" >:: fun _ ->
      let name = "🐠camels3110🐪" in
      let filename = Gamestats.output_file name in
      let expected = "player_data/🐠camels3110🐪_stats.txt" in
      assert_equal ~msg:(filepath_test_string name) expected filename );
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

let score_text_print in1 = Printf.sprintf "function: Score.text\ninput: %d" in1

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
    "Score.update_score: max value" >:: score_test max_int [ max_int ];
    "Score.update_score: min value" >:: score_test min_int [ min_int ];
    "Score.update_score: zero updates" >:: score_test 0 [];
    "Score.update_score: single large positive update"
    >:: score_test 1000000 [ 1000000 ];
    "Score.update_score: single large negative update"
    >:: score_test (-1000000) [ -1000000 ];
    "Score.update_score: large positive updates"
    >:: score_test 10000 [ 1000; 2000; 3000; 4000 ];
    "Score.update_score: large negative updates"
    >:: score_test (-10000) [ -1000; -2000; -3000; -4000 ];
    "Score.set: large negative updates"
    >:: score_test (-10000) [ -1000; -2000; -3000; -4000 ];
    ( "Score.text: Score of 0 (starting score)" >:: fun _ ->
      let new_score = Score.new_score () in
      let input = Score.text new_score in
      let expected = "Score: 0" in
      assert_equal
        ~msg:(score_text_print (Score.get_score new_score))
        expected input );
    ( "Score.text: Score of 5 (low int)" >:: fun _ ->
      let new_score = Score.new_score () in
      Score.update_score new_score 5;
      let input = Score.text new_score in
      let expected = "Score: 5" in
      assert_equal
        ~msg:(score_text_print (Score.get_score new_score))
        expected input );
    ( "Score.text: Score of 100000 (high int)" >:: fun _ ->
      let new_score = Score.new_score () in
      Score.update_score new_score 100000;
      let input = Score.text new_score in
      let expected = "Score: 100000" in
      assert_equal
        ~msg:(score_text_print (Score.get_score new_score))
        expected input );
    ( "Score.text: Score of -5 (high negative int, after penalties)" >:: fun _ ->
      let new_score = Score.new_score () in
      Score.update_score new_score ~-5;
      let input = Score.text new_score in
      let expected = "Score: -5" in
      assert_equal
        ~msg:(score_text_print (Score.get_score new_score))
        expected input );
    ( "Score.text: Score of -100000 (low negative int, after incurred penalties)"
    >:: fun _ ->
      let new_score = Score.new_score () in
      Score.update_score new_score ~-100000;
      let input = Score.text new_score in
      let expected = "Score: -100000" in
      assert_equal
        ~msg:(score_text_print (Score.get_score new_score))
        expected input );
    ( "Score.text: Score of max_int" >:: fun _ ->
      let new_score = Score.new_score () in
      Score.update_score new_score max_int;
      let input = Score.text new_score in
      let expected = "Score: " ^ string_of_int max_int in
      assert_equal
        ~msg:(score_text_print (Score.get_score new_score))
        expected input );
    ( "Score.text: Score of min_int" >:: fun _ ->
      let new_score = Score.new_score () in
      Score.update_score new_score min_int;
      let input = Score.text new_score in
      let expected = "Score: " ^ string_of_int min_int in
      assert_equal
        ~msg:(score_text_print (Score.get_score new_score))
        expected input );
  ]

let rec move_boat_from_lst boat lst =
  match lst with
  | [] -> ()
  | (dx, dy) :: t ->
      Boat.move boat dx dy;
      move_boat_from_lst boat t

let boat_move_test out in1 _ =
  assert_equal
    ~msg:(Printf.sprintf "function: Boat.move")
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
    "Boat: new_boat without movement"
    >:: boat_move_test (310., 260.) [ (0., 0.) ];
    "Boat: new_boat without movement 2"
    >:: boat_move_test (310., 260.) [ (0., 0.); (0., 0.); (0., 0.) ];
    "Boat: new_boat with forward movement"
    >:: boat_move_test (320., 270.) [ (10., 10.) ];
    "Boat: new_boat with backward movement"
    >:: boat_move_test (300., 250.) [ (-10., -10.) ];
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
    "Boat: draw boat positioned at 45 degrees"
    >:: boat_angle_test 45. (true, true, false, false);
    "Boat: draw boat positioned at 225 degrees"
    >:: boat_angle_test 225. (false, false, true, true);
    "Boat: draw boat positioned at 315 degrees"
    >:: boat_angle_test 315. (false, true, true, false);
    "Boat: draw boat positioned at 135 degrees"
    >:: boat_angle_test 135. (true, false, false, true);
    "Boat: draw boat positioned at 0 degrees 1"
    >:: boat_angle_test 0. (false, true, false, false);
    "Boat: draw boat positioned at 0 degrees 2"
    >:: boat_angle_test 0. (true, true, true, false);
    "Boat: draw boat positioned at 90 degrees 1"
    >:: boat_angle_test 90. (true, true, false, true);
    "Boat: draw boat positioned at 90 degrees 2"
    >:: boat_angle_test 90. (true, false, false, false);
    "Boat: draw boat positioned at 180 degrees 1"
    >:: boat_angle_test 180. (true, false, true, true);
    "Boat: draw boat positioned at 180 degrees 2"
    >:: boat_angle_test 180. (false, false, false, true);
    "Boat: draw boat positioned at 270 degrees"
    >:: boat_angle_test 270. (false, true, true, true);
    "Boat: draw boat positioned at 270 degrees"
    >:: boat_angle_test 270. (false, false, true, false);
    ( "Boat: check if border is crossed, above upper border" >:: fun _ ->
      let boat = Boat.new_boat 234. (-143.) 24. 45. in
      let expected = (Boat.get_x boat, Boat.get_y boat) in
      assert_equal
        ~msg:(formatted_border_cross_string expected)
        (true, "y upper")
        (Boat.is_border_crossed boat) );
    ( "Boat: check if border is crossed, below lower border" >:: fun _ ->
      let boat =
        Boat.new_boat 234. (Constants.canvas_height_fl +. 124.) 24. 45.
      in
      let expected = (Boat.get_x boat, Boat.get_y boat) in
      assert_equal
        ~msg:(formatted_border_cross_string expected)
        (true, "y lower")
        (Boat.is_border_crossed boat) );
    ( "Boat: check if border is crossed, left of left border" >:: fun _ ->
      let boat = Boat.new_boat (-157.) 35. 24. 45. in
      let expected = (Boat.get_x boat, Boat.get_y boat) in
      assert_equal
        ~msg:(formatted_border_cross_string expected)
        (true, "x left")
        (Boat.is_border_crossed boat) );
    ( "Boat: check if border is crossed, right of right border" >:: fun _ ->
      let boat =
        Boat.new_boat (Constants.canvas_width_fl +. 234.) 217. 24. 45.
      in
      let expected = (Boat.get_x boat, Boat.get_y boat) in
      assert_equal
        ~msg:(formatted_border_cross_string expected)
        (true, "x right")
        (Boat.is_border_crossed boat) );
    ( "Boat: check if border is crossed, exactly on right border" >:: fun _ ->
      let boat = Boat.new_boat Constants.canvas_width_fl 217. 24. 45. in
      let expected = (Boat.get_x boat, Boat.get_y boat) in
      assert_equal
        ~msg:(formatted_border_cross_string expected)
        (true, "x right")
        (Boat.is_border_crossed boat) );
    ( "Boat: check if border is crossed, exactly on left border" >:: fun _ ->
      let boat = Boat.new_boat 0. 217. 24. 45. in
      let expected = (Boat.get_x boat, Boat.get_y boat) in
      assert_equal
        ~msg:(formatted_border_cross_string expected)
        (true, "x left")
        (Boat.is_border_crossed boat) );
    ( "Boat: check if border is crossed, exactly on upper border" >:: fun _ ->
      let boat = Boat.new_boat 34. 0. 24. 45. in
      let expected = (Boat.get_x boat, Boat.get_y boat) in
      assert_equal
        ~msg:(formatted_border_cross_string expected)
        (true, "y upper")
        (Boat.is_border_crossed boat) );
    ( "Boat: check if border is crossed, exactly on lower border" >:: fun _ ->
      let boat = Boat.new_boat 34. Constants.canvas_height_fl 24. 45. in
      let expected = (Boat.get_x boat, Boat.get_y boat) in
      assert_equal
        ~msg:(formatted_border_cross_string expected)
        (true, "y lower")
        (Boat.is_border_crossed boat) );
    ( "Boat: check if border is crossed, not crossing any border " >:: fun _ ->
      let boat =
        Boat.new_boat
          (Constants.canvas_width_fl -. 244.)
          (Constants.canvas_height_fl -. 37.)
          24. 45.
      in
      let expected = (Boat.get_x boat, Boat.get_y boat) in
      assert_equal
        ~msg:(formatted_border_cross_string expected)
        (false, "border is not crossed")
        (Boat.is_border_crossed boat) );
    ( "Boat: check if border is crossed, center " >:: fun _ ->
      let boat =
        Boat.new_boat
          (Constants.canvas_width_fl -. 256.)
          (Constants.canvas_height_fl -. 256.)
          24. 45.
      in
      let expected = (Boat.get_x boat, Boat.get_y boat) in
      assert_equal
        ~msg:(formatted_border_cross_string expected)
        (false, "border is not crossed")
        (Boat.is_border_crossed boat) );
    ( "Boat: check if border is crossed, min float left side" >:: fun _ ->
      let boat = Boat.new_boat min_float 25. 24. 45. in
      let expected = (Boat.get_x boat, Boat.get_y boat) in
      assert_equal
        ~msg:(formatted_border_cross_string expected)
        (true, "x left")
        (Boat.is_border_crossed boat) );
    ( "Boat: check if border is crossed, max float right side" >:: fun _ ->
      let boat = Boat.new_boat max_float 25. 24. 45. in
      let expected = (Boat.get_x boat, Boat.get_y boat) in
      assert_equal
        ~msg:(formatted_border_cross_string expected)
        (true, "x right")
        (Boat.is_border_crossed boat) );
  ]

let boat = Boat.new_boat 310. 260. 30. 20.
let coin_true1 = Coin.generate_fixed 310. 260.
let coin_true2 = Coin.generate_fixed 308. 255.
let coin_true3 = Coin.generate_fixed 315. 265.
let coin_true4 = Coin.generate_fixed 322. 272.
let coin_false1 = Coin.generate_fixed 260. 120.
let coin_false2 = Coin.generate_fixed 440. 360.
let coin_false3 = Coin.generate_fixed 325. 280.

let coins_colliding_test out in1 in2 _ =
  assert_equal ~printer:string_of_bool
    ~msg:(Printf.sprintf "function: Coin.colliding")
    out (Coin.colliding in1 in2)

let coins_colliding_tests =
  [
    "Coin collision: true 1"
    >:: coins_colliding_test true (Boat.get_vect boat) coin_true1;
    "Coin collision: true 2"
    >:: coins_colliding_test true (Boat.get_vect boat) coin_true2;
    "Coin collision: true 3"
    >:: coins_colliding_test true (Boat.get_vect boat) coin_true3;
    "Coin collision: true 4"
    >:: coins_colliding_test true (Boat.get_vect boat) coin_true4;
    "Coin collision: false 1"
    >:: coins_colliding_test false (Boat.get_vect boat) coin_false1;
    "Coin collision: false 2"
    >:: coins_colliding_test false (Boat.get_vect boat) coin_false2;
    "Coin collision: false 3"
    >:: coins_colliding_test false (Boat.get_vect boat) coin_false3;
  ]

let seamine_true1 = Seamine.generate_fixed 310. 260.
let seamine_true2 = Seamine.generate_fixed 302. 252.
let seamine_true3 = Seamine.generate_fixed 305. 265.
let seamine_true4 = Seamine.generate_fixed 308. 268.
let seamine_false1 = Seamine.generate_fixed 294. 240.
let seamine_false2 = Seamine.generate_fixed 325. 282.
let seamine_false3 = Seamine.generate_fixed 120. 120.
let seamine_false4 = Seamine.generate_fixed 400. 310.

let seamines_colliding_test out in1 in2 _ =
  assert_equal ~printer:string_of_bool
    ~msg:(Printf.sprintf "function: Seamine.colliding")
    out
    (Seamine.colliding in1 in2)

let seamines_colliding_tests =
  [
    "Seamine collision: true 1"
    >:: seamines_colliding_test true (Boat.get_vect boat) seamine_true1;
    "Seamine collision: true 2"
    >:: seamines_colliding_test true (Boat.get_vect boat) seamine_true2;
    "Seamine collision: true 3"
    >:: seamines_colliding_test true (Boat.get_vect boat) seamine_true3;
    "Seamine collision: true 4"
    >:: seamines_colliding_test true (Boat.get_vect boat) seamine_true4;
    "Seamine collision: false 1"
    >:: seamines_colliding_test false (Boat.get_vect boat) seamine_false1;
    "Seamine collision: false 2"
    >:: seamines_colliding_test false (Boat.get_vect boat) seamine_false2;
    "Seamine collision: false 3"
    >:: seamines_colliding_test false (Boat.get_vect boat) seamine_false3;
    "Seamine collision: false 4"
    >:: seamines_colliding_test false (Boat.get_vect boat) seamine_false4;
  ]

let mouse = Vector2.create 310. 260.
let target_true1 = Target.generate_fixed 310. 260.
let target_true2 = Target.generate_fixed 300. 250.
let target_true3 = Target.generate_fixed 322. 270.
let target_true4 = Target.generate_fixed 315. 266.
let target_false1 = Target.generate_fixed 291. 241.
let target_false2 = Target.generate_fixed 329. 279.
let target_false3 = Target.generate_fixed 120. 122.
let target_false4 = Target.generate_fixed 400. 300.

let targets_colliding_test out in1 in2 _ =
  assert_equal ~printer:string_of_bool
    ~msg:(Printf.sprintf "function: Target.colliding")
    out (Target.colliding in1 in2)

let targets_colliding_tests =
  [
    "Target collision: true 1"
    >:: targets_colliding_test true mouse target_true1;
    "Target collision: true 2"
    >:: targets_colliding_test true mouse target_true2;
    "Target collision: true 3"
    >:: targets_colliding_test true mouse target_true3;
    "Target collision: true 4"
    >:: targets_colliding_test true mouse target_true4;
    "Target collision: false 1"
    >:: targets_colliding_test false mouse target_false1;
    "Target collision: false 2"
    >:: targets_colliding_test false mouse target_false2;
    "Target collision: false 3"
    >:: targets_colliding_test false mouse target_false3;
    "Target collision: false 4"
    >:: targets_colliding_test false mouse target_false4;
  ]

let fish_true1 = Fish.generate_fixed 310. 260.
let fish_true2 = Fish.generate_fixed 290. 240.
let fish_true3 = Fish.generate_fixed 330. 280.
let fish_true4 = Fish.generate_fixed 300. 270.
let fish_false1 = Fish.generate_fixed 250. 200.
let fish_false2 = Fish.generate_fixed 370. 320.
let fish_false3 = Fish.generate_fixed 200. 400.
let fish_false4 = Fish.generate_fixed 400. 200.

let fish_colliding_test out in1 in2 _ =
  assert_equal ~printer:string_of_bool
    ~msg:(Printf.sprintf "function: Fish.colliding")
    out (Fish.colliding in1 in2)

let fish_colliding_tests =
  [
    "Fish collision: true 1"
    >:: fish_colliding_test true (Boat.get_vect boat) fish_true1;
    "Fish collision: true 2"
    >:: fish_colliding_test true (Boat.get_vect boat) fish_true2;
    "Fish collision: true 3"
    >:: fish_colliding_test true (Boat.get_vect boat) fish_true3;
    "Fish collision: true 4"
    >:: fish_colliding_test true (Boat.get_vect boat) fish_true4;
    "Fish collision: false 1"
    >:: fish_colliding_test false (Boat.get_vect boat) fish_false1;
    "Fish collision: false 2"
    >:: fish_colliding_test false (Boat.get_vect boat) fish_false2;
    "Fish collision: false 3"
    >:: fish_colliding_test false (Boat.get_vect boat) fish_false3;
    "Fish collision: false 4"
    >:: fish_colliding_test false (Boat.get_vect boat) fish_false4;
  ]

module SpriteTester =
functor
  (S : SpriteSig)
  ->
  struct
    let boat = Boat.new_boat 310. 260. 30. 20.

    let sprite_generate_test out in1 _ =
      assert_equal ~printer:string_of_bool ~msg:"function: Sprites.generate" out
        in1

    let rec multi_gen_tests (n : int) : bool =
      if n > 0 then
        let current_sprite = S.generate boat (Box.generate 0. 0. 0. 0.) in
        S.in_bounds current_sprite && multi_gen_tests (n - 1)
      else true

    let sprite_generate_tests =
      [
        "1000 generated sprites are in bounds"
        >:: sprite_generate_test true (multi_gen_tests 1000);
      ]

    let tests = List.flatten [ sprite_generate_tests ]
  end

module CoinTester = SpriteTester (Coin)
module TargetTester = SpriteTester (Target)
module SeamineTester = SpriteTester (Seamine)
module FishTester = SpriteTester (Fish)

let get_bait = game_data.bait
let bait_tests = []
let h = canvas_height_fl
let w = canvas_width_fl
let s = set_speed 50.

let constant_tests =
  [
    ("canvas_height_f1 checker" >:: fun _ -> assert_equal 512. h);
    ("canvas_width_f1 checker" >:: fun _ -> assert_equal 512. w);
    ("speed checker" >:: fun _ -> assert_equal 50. (get_speed ()));
  ]

let suite =
  "final project test suite"
  >::: List.flatten
         [
           terminal_tests;
           box_tests;
           score_tests;
           boat_tests;
           CoinTester.tests;
           TargetTester.tests;
           SeamineTester.tests;
           FishTester.tests;
           coins_colliding_tests;
           seamines_colliding_tests;
           targets_colliding_tests;
           fish_colliding_tests;
           bait_tests;
           constant_tests;
         ]

let () = run_test_tt_main suite
