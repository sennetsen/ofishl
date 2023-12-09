open Raylib
open Boat

(** The signature of the fish object. *)
module type FishSig = sig
  type t
  (** The type of a fish. *)

  val spawn : Boat.t -> t
  (** Determines the location of the fish at a random place anywhere in the
      window such that it doesn't collide with any other current elements in the
      game. *)

  val draw_fish : Texture2D.t -> t -> unit
  (** Given an image texture and a fish object, draws the fish. *)

  val colliding : Vector2.t -> t -> bool
  (** Given a boat and a fish, return true if they are colliding and false if
      not. *)
end

module Fish : FishSig
(** The module used for controlling fish elements. *)
