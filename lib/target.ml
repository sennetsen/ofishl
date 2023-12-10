open Raylib

type t = Vector2.t
(** AF: The 2-D vector from the Raylib.Vector2 module represents a target at the
    coordinate position of the vector with respect to the origin at the top-left
    corner. RI: The coordinates of the vector must always be contained within
    the dimensions of the game window.*)

let generate (() : unit) : t =
  Vector2.create (Random.float 512.) (Random.float 512.)

let draw (target : t) : unit = draw_circle_v target 18. Color.gray

let colliding (mouse : Vector2.t) (target : t) : bool =
  check_collision_point_circle mouse target 18.
