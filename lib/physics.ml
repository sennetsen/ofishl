open Raylib
open Vector2
open Constants

let accelerate velocity accel =
  if Raylib.is_key_down Key.Right then
    velocity +. accel
  else if Raylib.is_key_down Key.Left then
    velocity -. accel
  else
    velocity *. 0.9 (* Deceleration when no key is pressed *)

