open Raylib

(** The signature of the fish object. *)
module type FishSig = sig
  type t
  (** The type of a fish. *)

  val spawn : unit -> t
  (** Determines the location of the fish at a random place anywhere in the
      window such that it doesn't collide with any other current elements in the
      game. *)

  val draw : t -> unit
  (** Given a fish, draw it at its current position. *)

  val colliding : Vector2.t -> t -> bool
  (** Given a boat and a fish, return true if they are colliding and false if 
      not. *)
end

(** The module used for controlling fish elements. *)
module Fish : FishSig