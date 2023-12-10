open Raylib
open Boat
open Vector2

module type SpriteSig = sig
  type t

  val generate : Boat.t -> t
  val draw : t -> unit
  val colliding : Vector2.t -> t -> bool
end

module Coin : SpriteSig = struct
  type t = Vector2.t
  (** AF: The 2-D vector from the Raylib.Vector2 module represents a coin at the
      coordinate position of the vector with respect to the origin at the
      top-left corner. RI: The coordinates of the vector must always be
      contained within the dimensions of the game window.*)

  let rec generate (boat : Boat.t) : t =
    let x, y = (Random.float 512., Random.float 512.) in
    if x <= 310. && x >= 220. && y <= 310. && y >= 220. then generate boat
    else
      let boat_x, boat_y = (Boat.get_x boat, Boat.get_y boat) in
      if
        x <= boat_x +. 20.
        && x >= boat_x -. 20.
        && y <= boat_y +. 20.
        && y >= boat_x -. 20.
      then generate boat
      else Vector2.create x y

  let draw (sprite : t) : unit = draw_circle_v sprite 10. Color.gold

  let colliding (boat : Vector2.t) (sprite : t) : bool =
    check_collision_circles boat 15. sprite 8.
end
