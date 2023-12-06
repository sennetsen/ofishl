open Raylib

type t = Vector2.t

let generate (() : unit) : t =
  Vector2.create (Random.float 512.) (Random.float 512.)

let draw (target : t) : unit = draw_circle_v target 18. Color.gray

let colliding (mouse : Vector2.t) (target : t) : bool =
  check_collision_point_circle mouse target 18.
