open Raylib
open Boat

(** The signature of the coin sprite. *)
module type SpriteSig = sig
  type t
  (** The type of a sprite. *)

  val generate : Boat.t -> t
  (** Determines the location of the sprite at a random place anywhere in the
      window such that it doesn't collide with any other current elements in the
      game. *)

  val draw : t -> unit
  (** Given a sprite, draw it at its current position. *)

  val colliding : Vector2.t -> t -> bool
  (** [colliding boat sprite] returns true if [boat] and [sprite] are colliding
      and false if not. *)
end

module Coin : SpriteSig
(** The module to represent the coin sprite. *)
