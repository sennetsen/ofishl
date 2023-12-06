open Raylib
open Boat
open Fish
open Coin
open AudioSprite
open Constants
open Target
open Score

type state =
  | Main
  | Minigame
  | Store
  | Settings

let current_state = ref Main
let current_fish = ref (Fish.spawn ())
let current_coin = ref (Coin.generate ())
let score = Score.new_score ()

(* Documentation of the library can be found here:
   https://tjammer.github.io/raylib-ocaml/raylib/Raylib/index.html *)

module type WindowSig = sig
  val setup : string -> string -> unit
  val loop : string -> unit
end

module MainWin : WindowSig = struct
  (** Helper function for drawing the current background by file name. *)
  let draw_background (background : string) =
    let texture_background = load_texture background in
    draw_texture texture_background 0 0 Color.raywhite

  let setup (map : string) (user : string) =
    Raylib.set_window_title (user ^ "'s Game | Map " ^ map)

  let loop (map : string) =
    begin_drawing ();
    draw_background ("data/sprites/bkg" ^ map ^ ".png");
    Score.print score;

    if Raylib.window_should_close () then Raylib.close_window ()
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
    if is_key_pressed Key.F && Fish.colliding !Boat.boat_pos !current_fish then (
      current_state := Minigame;
      current_fish := Fish.spawn ());
    if Coin.colliding !Boat.boat_pos !current_coin then (
      current_coin := Coin.generate ();
      Score.update_score score 1);
    Boat.draw ();
    Fish.draw !current_fish;
    Coin.draw !current_coin;
    end_drawing ()
end

module MiniWin : WindowSig = struct
  (** The current score in the minigame. *)
  let score = ref 0

  (** Represents the current target to be displayed in the window. *)
  let current_target = ref (Target.generate ())

  let setup (map : string) (user : string) =
    Raylib.set_window_title "Catch the fish!"

  let loop (map : string) =
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

let setup (map : string) (user : string) =
  Raylib.init_window 512 512 (user ^ "'s Game | Map " ^ map);
  AudioSprite.start ();
  AudioSprite.play "data/audio-sprites/track1.wav";
  Raylib.set_target_fps 60

let rec looper (map : string) (user : string) (st : state) =
  match st with
  | Main ->
      MainWin.setup map user;
      MainWin.loop map;
      looper map user !current_state
  | Minigame ->
      MiniWin.setup map user;
      MiniWin.loop map;
      looper map user !current_state
  | Store -> ()
  | Settings -> ()

let run (map : string) (user : string) =
  Raylib.set_trace_log_level Error;
  setup map user;
  (* Silence verbose log output. *)
  looper map user !current_state
