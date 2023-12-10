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
open Loadables

type state =
  | StartMenu
  | Main
  | Minigame
  | Store
  | GameOver
  | Quit

let current_state = ref StartMenu
let boat = Boat.new_boat 310. 260. 30. 20.
let current_fish = ref (Fish.spawn boat)
let current_coin = ref (Coin.generate boat)
let current_seamine = ref (Seamine.generate boat)
let score = Score.new_score ()

type game_data = {
  mutable final_score : int;
  mutable rods : int;
  mutable bait : int;
}

let game_data = { final_score = Score.get_score score; rods = 0; bait = 0 }

module type WindowSig = sig
  val setup : string -> string -> Loadables.t -> unit
  val loop : string -> bool -> Loadables.t -> unit
end

module StartMenuWin : WindowSig = struct
  let play_button = Box.generate 100. 256. 100. 50.
  let quit_button = Box.generate 300. 256. 100. 50.

  let setup (map : string) (user : string) (loads : Loadables.t) =
    Raylib.set_window_title "OFishl: The OCaml Fishing Tournament";
    Box.draw play_button Color.lightgray;
    Box.draw_text play_button "Play" 25. 118. (Color.create 66 20 0 150)
      (Loadables.uni_font loads);
    Box.draw quit_button Color.beige;
    Box.draw_text quit_button "Quit" 25. 322. (Color.create 66 20 0 150)
      (Loadables.uni_font loads);
    Raylib.draw_text_ex
      (Loadables.bolden_font loads)
      "Click to play the game!" (Vector2.create 80. 120.) 40. 1.
      (Color.create 255 102 204 400)
  (* Exit button *)

  let loop (map : string) (is_custom : bool) (loads : Loadables.t) =
    if Raylib.window_should_close () then current_state := Quit
    else if Box.colliding (get_mouse_position ()) play_button then (
      if is_mouse_button_down MouseButton.Left then
        Box.draw play_button Color.darkgreen;
      if is_mouse_button_released MouseButton.Left then current_state := Main;
      Box.draw_text play_button "Play" 25. 118. (Color.create 46 14 0 150)
        (Loadables.uni_font loads))
    else (
      Box.draw play_button (Color.create 41 205 63 100);
      Box.draw_text play_button "Play" 25. 118. (Color.create 46 14 0 150)
        (Loadables.uni_font loads));

    if Box.colliding (get_mouse_position ()) quit_button then (
      if is_mouse_button_down MouseButton.Left then
        Box.draw quit_button (Color.create 216 52 6 100);
      if is_mouse_button_released MouseButton.Left then current_state := Quit;
      Box.draw_text quit_button "Quit" 25. 322. (Color.create 46 14 0 150)
        (Loadables.uni_font loads))
    else (
      Box.draw quit_button (Color.create 245 110 110 100);
      Box.draw_text quit_button "Quit" 25. 322. (Color.create 46 14 0 150)
        (Loadables.uni_font loads));

    begin_drawing ();
    clear_background (Color.create 194 243 255 120);
    end_drawing ()
end

module MainWin : WindowSig = struct
  let store_box = ref (Box.generate 230. 218. 50. 50.)
  let score_box = ref (Box.generate 380. 15. 125. 35.)
  let fish_type = ref (Random.int 2)

  let setup (map : string) (user : string) (loads : Loadables.t) =
    (* TODO: *)
    if map = "2" then store_box := Box.generate 100. 450. 50. 50. else ();
    if map = "3" then store_box := Box.generate 100. 450. 50. 50. else ();
    Raylib.set_window_title (user ^ "'s Game | Map " ^ map)

  let loop (map : string) (is_custom : bool) (loads : Loadables.t) =
    (* Custom map implemention incomplete (TODO)*)
    if is_custom then begin
      let arr = [| [| 1; 0; 1 |]; [| 1; 0; 1 |] |] in
      Custom.generate_map arr
    end
    else draw_texture (Loadables.map loads) 0 0 Color.raywhite;

    let texture_fish =
      if !fish_type = 0 then Loadables.hsufish loads
      else Loadables.kozenfish loads
    in

    begin_drawing ();

    if Raylib.window_should_close () then current_state := Quit;

    (* Responding to key presses. *)
    if
      (is_key_down Key.W || is_key_down Key.Up)
      && (is_key_down Key.A || is_key_down Key.Left)
      && (not (is_key_down Key.S || is_key_down Key.Down))
      && not (is_key_down Key.D || is_key_down Key.Right)
    then Boat.move boat (-.Constants.diag_speed ()) (-.Constants.diag_speed ())
    else if
      (is_key_down Key.A || is_key_down Key.Left)
      && (is_key_down Key.S || is_key_down Key.Down)
      && (not (is_key_down Key.D || is_key_down Key.Right))
      && not (is_key_down Key.W || is_key_down Key.Up)
    then Boat.move boat (-.Constants.diag_speed ()) (Constants.diag_speed ())
    else if
      (is_key_down Key.S || is_key_down Key.Down)
      && (is_key_down Key.D || is_key_down Key.Right)
      && (not (is_key_down Key.W || is_key_down Key.Up))
      && not (is_key_down Key.A || is_key_down Key.Left)
    then Boat.move boat (Constants.diag_speed ()) (Constants.diag_speed ())
    else if
      (is_key_down Key.D || is_key_down Key.Right)
      && (is_key_down Key.W || is_key_down Key.Up)
      && (not (is_key_down Key.A || is_key_down Key.Left))
      && not (is_key_down Key.S || is_key_down Key.Down)
    then Boat.move boat (Constants.diag_speed ()) (-.Constants.diag_speed ())
    else (
      if is_key_down Key.A || is_key_down Key.Left then
        Boat.move boat (-.Constants.get_speed ()) 0.;
      if is_key_down Key.D || is_key_down Key.Right then
        Boat.move boat (Constants.get_speed ()) 0.;
      if is_key_down Key.W || is_key_down Key.Up then
        Boat.move boat 0. (-.Constants.get_speed ());
      if is_key_down Key.S || is_key_down Key.Down then
        Boat.move boat 0. (Constants.get_speed ()));

    if is_key_pressed Key.F && Fish.colliding (Boat.get_vect boat) !current_fish
    then (
      current_state := Minigame;
      fish_type := Random.int 2;
      current_fish := Fish.spawn boat);
    if Coin.colliding (Boat.get_vect boat) !current_coin then (
      current_coin := Coin.generate boat;
      Score.update_score score 1);
    if Seamine.colliding (Boat.get_vect boat) !current_seamine then (
      Score.update_score score (Seamine.get_damage !current_seamine);
      current_seamine := Seamine.generate boat);
    if is_key_pressed Key.F && Box.colliding (Boat.get_vect boat) !store_box
    then current_state := Store;

    Fish.draw_fish texture_fish !current_fish;
    Seamine.draw !current_seamine;
    Coin.draw !current_coin;

    Boat.draw boat
      ( is_key_down Key.W || is_key_down Key.Up,
        is_key_down Key.A || is_key_down Key.Left,
        is_key_down Key.S || is_key_down Key.Down,
        is_key_down Key.D || is_key_down Key.Right );

    Box.draw !score_box (Color.create 232 253 255 150);
    Box.draw !store_box Color.lightgray;

    Boat.border_crossed boat;

    Score.print score (Loadables.uni_font loads);
    end_drawing ()
end

module MiniWin : WindowSig = struct
  (** The current score in the minigame. *)
  let mini_score = ref 0

  (** The score required to win the minigame. *)
  let win_con = ref 10

  (** Represents the current target to be displayed in the window. *)
  let current_target = ref (Target.generate ())

  let setup (map : string) (user : string) (loads : Loadables.t) =
    Raylib.set_window_title "Catch the fish!";
    win_con := if game_data.rods < 10 then 10 - game_data.rods else 1

  let loop (map : string) is_custom (loads : Loadables.t) =
    if !mini_score = !win_con then (
      mini_score := 0;
      current_state := Main;
      Score.update_score score (3 + game_data.bait))
    else if
      is_mouse_button_pressed MouseButton.Left
      && Target.colliding (get_mouse_position ()) !current_target
    then (
      mini_score := succ !mini_score;
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

  let setup (map : string) (user : string) (loads : Loadables.t) =
    Raylib.set_window_title "Welcome home!";
    (* Buy Rod for $3 button *)
    Box.draw buy_rod_button Color.lightgray;
    Box.draw_text buy_rod_button "$3 Rod" 25. 107. (Color.create 66 20 0 150)
      (Loadables.uni_font loads);
    (* Buy Bait for $1 button *)
    Box.draw buy_bait_button Color.beige;
    Box.draw_text buy_bait_button "$1 Bait" 25. 307. (Color.create 66 20 0 150)
      (Loadables.uni_font loads);
    (* Exit button *)
    Box.draw exit_button Color.red;
    (* Box around score *)
    Box.draw score_box (Color.create 232 253 255 150)

  let loop (map : string) is_custom (loads : Loadables.t) =
    if Raylib.window_should_close () then current_state := Quit
    else (
      Score.print score (Loadables.uni_font loads);
      if Box.colliding (get_mouse_position ()) buy_rod_button then (
        if
          is_mouse_button_pressed MouseButton.Left && Score.get_score score >= 3
        then
          if is_key_down Key.Left_shift && Score.get_score score >= 30 then (
            Score.update_score score (-30);
            game_data.rods <- game_data.rods + 10)
          else (
            Score.update_score score (-3);
            game_data.rods <- game_data.rods + 1);

        if is_mouse_button_down MouseButton.Left then
          if Score.get_score score >= 3 then (
            Box.draw buy_rod_button Color.darkgray;
            Box.draw_text buy_rod_button "$3 Rod" 25. 107.
              (Color.create 46 14 0 150) (Loadables.uni_font loads))
          else (
            Box.draw buy_rod_button (Color.create 245 110 110 100);
            Box.draw_text buy_rod_button "$3 Rod" 25. 107.
              (Color.create 46 14 0 150) (Loadables.uni_font loads)));

      if Box.colliding (get_mouse_position ()) buy_bait_button then (
        if
          is_mouse_button_pressed MouseButton.Left && Score.get_score score >= 1
        then
          if is_key_down Key.Left_shift && Score.get_score score >= 10 then (
            Score.update_score score (-10);
            game_data.bait <- game_data.bait + 10)
          else (
            Score.update_score score (-1);
            game_data.bait <- game_data.bait + 1);
        if is_mouse_button_down MouseButton.Left then
          if Score.get_score score >= 3 then (
            Box.draw buy_bait_button (Color.create 161 138 101 150);
            Box.draw_text buy_bait_button "$1 Bait" 25. 307.
              (Color.create 46 14 0 150) (Loadables.uni_font loads))
          else (
            Box.draw buy_bait_button (Color.create 245 110 110 100);
            Box.draw_text buy_bait_button "$1 Bait" 25. 307.
              (Color.create 46 14 0 150) (Loadables.uni_font loads)));

      if
        is_mouse_button_pressed MouseButton.Left
        && Box.colliding (get_mouse_position ()) exit_button
        || is_key_pressed Key.X
      then current_state := Main;
      begin_drawing ();
      clear_background Color.raywhite;
      end_drawing ())
end

let setup (map : string) (user : string) =
  Raylib.init_window 512 512 (user ^ "'s Game | Map " ^ map);
  AudioSprite.start ();
  Raylib.set_target_fps 60;
  let img = Raylib.load_image "data/fish-sprites/smallerkozen.png" in
  Raylib.unload_image img;
  Raylib.set_window_icon img;
  Raylib.set_window_min_size 512 512;
  Constants.set_speed 3.;
  Loadables.initialize map

let rec looper (map : string) (user : string) (st : state) (loads : Loadables.t)
    =
  if AudioSprite.is_playing (Loadables.background_sound loads) then ()
  else AudioSprite.play (Loadables.background_sound loads);

  let is_custom = if map <> "custom" then false else true in
  match st with
  | StartMenu ->
      StartMenuWin.setup map user loads;
      StartMenuWin.loop map is_custom loads;
      looper map user !current_state loads
  | Main ->
      MainWin.setup map user loads;
      MainWin.loop map is_custom loads;
      looper map user !current_state loads
  | Minigame ->
      MiniWin.setup map user loads;
      MiniWin.loop map is_custom loads;
      looper map user !current_state loads
  | Store ->
      StoreWin.setup map user loads;
      StoreWin.loop map is_custom loads;
      looper map user !current_state loads
  | GameOver -> ()
  | Quit ->
      game_data.final_score <- Score.get_score score;
      Raylib.close_window ()

let run (map : string) (user : string) =
  (*Raylib.set_trace_log_level Error; *)
  let loads = setup map user in
  AudioSprite.play (Loadables.background_sound loads);
  (* Silence verbose log output. *)
  looper map user !current_state loads
