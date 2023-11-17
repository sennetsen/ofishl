open Raylib
open Boat

(** The signature of the coin sprite. *)
module type SpriteSig = sig
  type t
  (** The type of a sprite. *)

  val generate : unit -> t
  (** Determines the location of the sprite at a random place anywhere in the
      window such that it doesn't collide with any other current elements in the
      game. *)

  val draw : t -> unit
  (** Given a sprite, draw it at its current position. *)

  val colliding : Vector2.t -> t -> bool
  (** Given a boat and a sprite, return true if they are colliding and false if 
      not. *)

  val is_border_crossed : t -> bool
  (** Given a sprite, return true if it touches the edges of the canvas
      window. *)
end

(** The module used for manipulating sprites. *)
module Sprite : SpriteSig