open Raylib
open Boat

module type FishSig = sig
  type t

  val spawn : unit -> t
  val draw_fish : Texture2D.t -> t -> unit
  val colliding : Vector2.t -> t -> bool
end

module Fish : FishSig = struct
  type t = Vector2.t

  let spawn (() : unit) : t =
    Vector2.create (Random.float 512.) (Random.float 512.)

  (* let draw (fish : t) : unit = draw_circle_v fish 8. Color.blue *)

  let draw_fish (texture : Texture2D.t) (fish : t) =
    draw_texture texture
      (int_of_float (Vector2.x fish) - 50)
      (int_of_float (Vector2.y fish) - 50)
      Color.raywhite

  let colliding (boat : Vector2.t) (fish : t) : bool =
    check_collision_circles boat 15. fish 50.
end
