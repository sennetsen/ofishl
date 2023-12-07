open Raylib

module type BoxSig = sig
  type t

  val generate : float -> float -> float -> float -> t
  val draw : t -> Color.t -> unit
  val colliding : Vector2.t -> t -> bool
end

module Box : BoxSig = struct
  type t = Rectangle.t

  let generate (x : float) (y : float) (width : float) (height : float) : t =
    Rectangle.create x y width height

  let draw (rectangle : t) (color : Color.t) : unit =
    draw_rectangle_rounded rectangle 0.15 1 color

  let colliding (mouse : Vector2.t) (rectangle : t) : bool =
    check_collision_circle_rec mouse 1. rectangle
end
