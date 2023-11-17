open Raylib
open Boat

(** The signature of the coin sprite. *)
module type SpriteSig = sig

  val play : string -> unit
  (** Plays a sound file from a parsed string.  *)

  val draw : t -> unit
  (** Given a sprite, draw it at its current position. *)

  val colliding : Vector2.t -> t -> bool
  (** Given a boat and a sprite, return true if they are colliding and false if 
      not. *)
end

(** The module used for manipulating sprites. *)
module Sprite : SpriteSig