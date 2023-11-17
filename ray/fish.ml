open Raylib
open Boat

(** The signature of the fish object. *)
module type FishSig = sig
  type t

  val spawn : unit -> t
  val draw : t -> unit
  val colliding : Vector2.t -> t -> bool
end

(** The module used for controlling fish elements. *)
module Fish : FishSig = struct
  type t = Vector2.t

  let spawn (() : unit) : t =
    Vector2.create (Random.float 800.) (Random.float 450.)

  let draw (fish : t) : unit = draw_circle_v fish 8. Color.blue

  let colliding (boat : Vector2.t) (fish : t) : bool =
    check_collision_circles boat 15. fish 8.
end
