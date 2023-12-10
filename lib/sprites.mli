open Raylib
open Boat
open Vector2
open Score
open Box

(** The signature of a sprite. *)
module type SpriteSig = sig
  type t
  (** The type of a sprite. *)

  val generate_fixed : float -> float -> t
  (** Creates a sprite in a specific position (x, y). May collide with other
      elements in the game. *)

  val generate : Boat.t -> Box.t -> t
  (** Determines the location of the sprite at a random place anywhere in the
      window such that it doesn't collide with any other current elements in the
      game. *)

  val draw : Texture2D.t -> t -> unit
  (** Given a sprite, draw it at its current position. *)

  val colliding : Vector2.t -> t -> bool
  (** [colliding boat sprite] returns true if [boat] and [sprite] are colliding
      and false if not. *)

  val get_score : t -> int
  (** [get_score sprite] returns the score change when the boat collides with
      [sprite]. *)

  val in_bounds : t -> bool
  (** [in_bounds sprite] returns true if the sprite is within the bounds of the
      game window. False otherwise.*)
end

module Coin : SpriteSig
(** The module to represent the coin sprite. *)

module Seamine : SpriteSig
(** The module to represent the seamine sprite. *)

module Target : SpriteSig
(** The module to represent the target sprite. *)

module Fish : SpriteSig
(** The module to represent the fish sprite. *)
