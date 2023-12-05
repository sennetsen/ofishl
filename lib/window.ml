open Raylib
open Boat
open Fish
open Coin
open AudioSprite
open Constants
open Minigame

(* Documentation of the library can be found here:
   https://tjammer.github.io/raylib-ocaml/raylib/Raylib/index.html *)

let current_fish = ref (Fish.spawn ())
let current_coin = ref (Coin.generate ())

let setup (map : string) (user : string) =
  Raylib.init_window 512 512 (user ^ "'s Game | Map " ^ map);
  AudioSprite.start ();
  AudioSprite.play "data/audio-sprites/track1.wav";
  Raylib.set_target_fps 60

let draw_background (background : string) =
  let texture_background = load_texture background in
  draw_texture texture_background 0 0 Color.raywhite

(* TODO: make this loop the recursively repeating loop. Make other loops
   non-recursive and we just call them from here. Set up mutable state types so
   pattern match between states. Pattern matching will allow us to call
   different state loops. *)
let rec loop (map : string) =
  draw_background ("data/sprites/bkg" ^ map ^ ".png");
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
    Minigame.run ();
    current_fish := Fish.spawn ());
  if Coin.colliding !Boat.boat_pos !current_coin then
    current_coin := Coin.generate ();

  Boat.border_crossed ();

  begin_drawing ();
  clear_background Color.raywhite;
  Boat.draw ();
  Fish.draw !current_fish;
  Coin.draw !current_coin;
  end_drawing ();
  loop map

let run (map : string) (user : string) =
  Raylib.set_trace_log_level Error;
  (* Silence verbose log output. *) setup map user;
  loop map
