open Raylib
open Boat
open Score

type diff
(** The type of trap. *)

(** The signature of the seamine sprite. *)
module type MineSig = sig
  type t
  (** The type of a sprite. *)

  val random_diff : unit -> diff
  (** Gives a random difficulty bomb given the three categories: Trap, Mine, and
      Bomb *)

  val get_damage : t -> int
  (** Given some mine returns the damage done by bombs Trap = -1, Mine = -3, and
      Bomb = -5. *)

  val generate : Boat.t -> t
  (** Determines the location of the mine at a random place anywhere in the
      window such that it doesn't collide with any other current elements in the
      game. *)

  val draw : t -> unit
  (** Given a sprite, draw it at its current position. *)

  val colliding : Vector2.t -> t -> bool
  (** [colliding boat sprite] returns true if [boat] and [sprite] are colliding
      and false if not. *)
end

module Seamine : MineSig
(** The module to represent the seamine sprite. *)
