open Raylib
open Boat
open Fish
open Coin
open Seamine
open AudioSprite
open Constants
open Target
open Score
open Mapcustom
open Box

type state =
  | StartMenu
  | Main
  | Minigame
  | Store
  | GameOver
  | Quit

let current_state = ref StartMenu
let current_fish = ref (Fish.spawn ())
let current_coin = ref (Coin.generate ())
let current_seamine = ref (Seamine.generate ())
let score = Score.new_score ()

(* Documentation of the library can be found here:
   https://tjammer.github.io/raylib-ocaml/raylib/Raylib/index.html *)

module type WindowSig = sig
  val setup : string -> string -> unit
  val loop : string -> bool -> unit
end

module StartMenuWin : WindowSig = struct
  let play_button = Box.generate 100. 256. 100. 50.
  let quit_button = Box.generate 300. 256. 100. 50.
  let exit_button = Box.generate 15. 15. 15. 15.

  let setup (map : string) (user : string) =
    let unisans_heavy = load_font "data/fonts/uni-sans/Uni Sans Heavy.otf" in
    Raylib.set_window_title "OFishl: The OCaml Fishing Tournament";
    Box.draw play_button Color.lightgray;
    Box.draw_text play_button "Play" 25. 118. (Color.create 66 20 0 150)
      unisans_heavy;
    Box.draw quit_button Color.beige;
    Box.draw_text quit_button "Quit" 25. 318. (Color.create 66 20 0 150)
      unisans_heavy;
    (* Exit button *)
    Box.draw exit_button Color.red;
    unload_font unisans_heavy

  let loop (map : string) (is_custom : bool) =
    let unisans_heavy = load_font "data/fonts/uni-sans/Uni Sans Heavy.otf" in
    if Raylib.window_should_close () then current_state := Quit
    else if Box.colliding (get_mouse_position ()) play_button then (
      if is_mouse_button_down MouseButton.Left then
        Box.draw play_button Color.darkgreen;
      if is_mouse_button_released MouseButton.Left then current_state := Main;
      Box.draw_text play_button "Play" 25. 118. (Color.create 46 14 0 150)
        unisans_heavy)
    else (
      Box.draw play_button (Color.create 41 205 63 100);
      Box.draw_text play_button "Play" 25. 118. (Color.create 46 14 0 150)
        unisans_heavy);

    if Box.colliding (get_mouse_position ()) quit_button then (
      if is_mouse_button_down MouseButton.Left then
        Box.draw quit_button (Color.create 216 52 6 100);
      if is_mouse_button_released MouseButton.Left then current_state := Quit;
      Box.draw_text quit_button "Quit" 25. 318. (Color.create 46 14 0 150)
        unisans_heavy)
    else (
      Box.draw quit_button (Color.create 245 110 110 100);
      Box.draw_text quit_button "Quit" 25. 318. (Color.create 46 14 0 150)
        unisans_heavy);

    begin_drawing ();
    clear_background Color.blue;
    end_drawing ();
    unload_font unisans_heavy
end

module MainWin : WindowSig = struct
  let store_box = ref (Box.generate 475. 450. 75. 75.)
  let score_box = ref (Box.generate 380. 15. 125. 35.)

  let setup (map : string) (user : string) =
    Raylib.set_window_title (user ^ "'s Game | Map " ^ map)

  let loop (map : string) (is_custom : bool) =
    (* Custom map implemention incomplete (TODO)*)
    if is_custom then begin
      let arr = [| [| 1; 0; 1 |]; [| 1; 0; 1 |] |] in
      Custom.generate_map arr
    end
    else
      let background = "data/sprites/bkg" ^ map ^ ".png" in
      let texture_background = load_texture background in
      draw_texture texture_background 0 0 Color.raywhite;

      let fish_type = Random.int 1 in
      let fish_name = if fish_type = 0 then "smallerhsu" else "smallerkozen" in
      let texture_fish =
        load_texture ("data/fish-sprites/" ^ fish_name ^ ".png")
      in

      begin_drawing ();

      if Raylib.window_should_close () then current_state := Quit
      else if
        (* Responding to key presses. *)
        is_key_down Key.A || is_key_down Key.Left
      then Boat.move (Vector2.create ~-.2. 0.);
      if is_key_down Key.D || is_key_down Key.Right then
        Boat.move (Vector2.create 2. 0.);
      if is_key_down Key.W || is_key_down Key.Up then
        Boat.move (Vector2.create 0. ~-.2.);
      if is_key_down Key.S || is_key_down Key.Down then
        Boat.move (Vector2.create 0. 2.);
      if is_key_pressed Key.F && Fish.colliding !Boat.boat_pos !current_fish
      then (
        current_state := Minigame;
        Score.update_score score 3;
        current_fish := Fish.spawn ());
      if Coin.colliding !Boat.boat_pos !current_coin then (
        current_coin := Coin.generate ();
        Score.update_score score 1);
      if Seamine.colliding !Boat.boat_pos !current_seamine then (
        Score.update_score score (Seamine.get_damage !current_seamine);
        current_seamine := Seamine.generate ());
      if is_key_pressed Key.F && Box.colliding !Boat.boat_pos !store_box then
        current_state := Store;

      Fish.draw_fish texture_fish !current_fish;
      Seamine.draw !current_seamine;
      Coin.draw !current_coin;
      Boat.draw ();

      (* Box.draw !store_box Color.lightgray; Box.draw !score_box (Color.create
         232 253 255 150); *)
      Score.print score;
      end_drawing ();

      unload_texture texture_fish;
      unload_texture texture_background
end

module MiniWin : WindowSig = struct
  (** The current score in the minigame. *)
  let score = ref 0

  (** Represents the current target to be displayed in the window. *)
  let current_target = ref (Target.generate ())

  let setup (map : string) (user : string) =
    Raylib.set_window_title "Catch the fish!"

  let loop (map : string) is_custom =
    if !score = 5 then (
      score := 0;
      current_state := Main)
    else if
      is_mouse_button_pressed MouseButton.Left
      && Target.colliding (get_mouse_position ()) !current_target
    then (
      score := succ !score;
      current_target := Target.generate ());
    begin_drawing ();
    clear_background Color.raywhite;
    Target.draw !current_target;
    end_drawing ()
end

module StoreWin : WindowSig = struct
  (** The current score in the minigame. *)

  (** Represents the current target to be displayed in the window. *)
  let buy_rod_button = Box.generate 100. 400. 100. 50.

  let buy_bait_button = Box.generate 300. 400. 100. 50.
  let exit_button = Box.generate 15. 15. 15. 15.
  let score_box = Box.generate 380. 15. 125. 35.

  let setup (map : string) (user : string) =
    let unisans_heavy = load_font "data/fonts/uni-sans/Uni Sans Heavy.otf" in
    Raylib.set_window_title "Welcome home!";
    (* Buy Rod for $3 button *)
    Box.draw buy_rod_button Color.lightgray;
    Box.draw_text buy_rod_button "$3 Rod" 25. 107. (Color.create 66 20 0 150)
      unisans_heavy;
    (* Buy Bait for $1 button *)
    Box.draw buy_bait_button Color.beige;
    Box.draw_text buy_bait_button "$1 Bait" 25. 307. (Color.create 66 20 0 150)
      unisans_heavy;
    (* Exit button *)
    Box.draw exit_button Color.red;
    (* Box around score *)
    Box.draw score_box (Color.create 232 253 255 150);
    unload_font unisans_heavy

  let loop (map : string) is_custom =
    if Raylib.window_should_close () then current_state := Quit
    else (
      Score.print score;

      let unisans_heavy = load_font "data/fonts/uni-sans/Uni Sans Heavy.otf" in
      if Box.colliding (get_mouse_position ()) buy_rod_button then (
        if
          is_mouse_button_pressed MouseButton.Left && Score.get_score score >= 3
        then Score.update_score score (-3);
        if is_mouse_button_down MouseButton.Left then
          if Score.get_score score >= 3 then (
            Box.draw buy_rod_button Color.darkgray;
            Box.draw_text buy_rod_button "$3 Rod" 25. 107.
              (Color.create 46 14 0 150) unisans_heavy)
          else (
            Box.draw buy_rod_button (Color.create 245 110 110 100);
            Box.draw_text buy_rod_button "$3 Rod" 25. 107.
              (Color.create 46 14 0 150) unisans_heavy));

      if Box.colliding (get_mouse_position ()) buy_bait_button then (
        if
          is_mouse_button_pressed MouseButton.Left && Score.get_score score >= 1
        then Score.update_score score (-1);
        if is_mouse_button_down MouseButton.Left then
          if Score.get_score score >= 3 then (
            Box.draw buy_bait_button (Color.create 161 138 101 150);
            Box.draw_text buy_bait_button "$1 Bait" 25. 307.
              (Color.create 46 14 0 150) unisans_heavy)
          else (
            Box.draw buy_bait_button (Color.create 245 110 110 100);
            Box.draw_text buy_bait_button "$1 Bait" 25. 307.
              (Color.create 46 14 0 150) unisans_heavy));

      if
        is_mouse_button_pressed MouseButton.Left
        && Box.colliding (get_mouse_position ()) exit_button
      then current_state := Main;
      begin_drawing ();
      clear_background Color.raywhite;
      end_drawing ();
      unload_font unisans_heavy)
end

let setup (map : string) (user : string) =
  Raylib.init_window 512 512 (user ^ "'s Game | Map " ^ map);
  AudioSprite.start ();
  AudioSprite.play "data/audio-sprites/track1.wav";
  Raylib.set_target_fps 60

let rec looper (map : string) (user : string) (st : state) =
  let is_custom = if map <> "c" then false else true in
  match st with
  | StartMenu ->
      StartMenuWin.setup map user;
      StartMenuWin.loop map is_custom;
      looper map user !current_state
  | Main ->
      MainWin.setup map user;
      MainWin.loop map is_custom;
      looper map user !current_state
  | Minigame ->
      MiniWin.setup map user;
      MiniWin.loop map is_custom;
      looper map user !current_state
  | Store ->
      StoreWin.setup map user;
      StoreWin.loop map is_custom;
      looper map user !current_state
  | GameOver -> ()
  | Quit -> Raylib.close_window ()

let run (map : string) (user : string) =
  (*Raylib.set_trace_log_level Error; *)
  setup map user;
  (* Silence verbose log output. *)
  looper map user !current_state
