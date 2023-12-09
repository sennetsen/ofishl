open Raylib
open Constants

(** The signature of the boat character. *)
module type BoatSig = sig
  type t

  val new_boat : t
  (** Creates a new boat character at initial position. *)

  val boat_h : Vector2.t
  (** Represents the orientation of the boat with respect to an ellpise. boat_h
      specifically represents the boat's orientation when it is moving left and
      right. The x value corresponds with the horizontal radius and the y value
      corresponds with the vertical radius. *)

  val boat_v : Vector2.t
  (** Using the same format at boat_h, boat_v represents the boat's orientation
      when it moves up and down.*)

  val boat_face : Vector2.t ref
  (** The reference to the boat's current orientation. Set to boat_h by default. *)

  val get_x : t -> float
  (** Given a boat, returns the x position of the boat, converted from a float
      to an int. *)

  val get_y : t -> float
  (** Given a boat, returns the y position of the boat, converted from a float
      to an int. *)

  val get_vect : t -> Vector2.t
  (** Given a boat, returns a Vector2.t representation of the boat at that
      instant. *)

  val move : t -> float -> float -> unit
  (** Given a movement vector and a bool which is true when the boat is facing
      horizontally and false when facing vertically, move the boat accordingly. *)

  val draw : t -> unit
  (** Draws the boat at its current position and orientation and colors it
      brown. *)

  val border_crossed : t -> unit
  (** Given a boat, return true if the boat touches the edges of the canvas
      window. *)
  (* TODO: Change this documentation. *)
end

module Boat : BoatSig
(** The module used for controlling the boat. *)
