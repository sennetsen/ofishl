open Raylib
open Boat
open Vector2

(** The signature of the sprite. *)
module type SpriteSig = sig
  type t

  val generate : unit -> t
  val draw : t -> unit
  val colliding : Vector2.t -> t -> bool

end

(** The module used for controlling sprites. *)
module Sprite : SpriteSig = struct
  type t = Vector2.t

  let generate (() : unit) : t =
    Vector2.create (Random.float 512.) (Random.float 512.)

  let draw (sprite : t) : unit = draw_circle_v sprite 18. Color.gold

  let colliding (boat : Vector2.t) (sprite : t) : bool =
    check_collision_circles boat 15. sprite 8.


end