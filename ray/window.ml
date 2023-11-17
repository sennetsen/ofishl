open Raylib
open Boat
open Fish
open Sprite

(* Documentation of the library can be found here:
   https://tjammer.github.io/raylib-ocaml/raylib/Raylib/index.html *)

let current_fish = ref (Fish.spawn ())
let current_coin = ref (Sprite.generate ())

let setup () =
  Raylib.init_window 512 512 "basic window";
  Raylib.set_target_fps 60

let draw_background (background : string) =
  let texture_background = load_texture background in 
  draw_texture texture_background 0 0 Color.raywhite

let rec loop (map : string) =
  draw_background ("data/sprites/bkg" ^ map ^ ".png");
  if Raylib.window_should_close () then Raylib.close_window ()
  else
    (* Responding to key presses. *)
    if is_key_down Key.A then Boat.move (Vector2.create ~-.2. 0.) else ();
    if is_key_down Key.D then Boat.move (Vector2.create 2. 0.) else ();
    if is_key_down Key.W then Boat.move (Vector2.create 0. ~-.2.) else ();
    if is_key_down Key.S then Boat.move (Vector2.create 0. 2.) else ();
    if is_key_pressed Key.F && Fish.colliding !Boat.boat_pos !current_fish then
      current_fish := Fish.spawn ()
    else
    if Sprite.colliding !Boat.boat_pos !current_coin then
        current_coin := Sprite.generate ()
    else
    begin_drawing ();
    clear_background Color.raywhite;
    Boat.draw ();
    Fish.draw !current_fish;
    Sprite.draw !current_coin;
    end_drawing ();
    loop (map)

let run (map : string) =
  setup ();
  loop map
