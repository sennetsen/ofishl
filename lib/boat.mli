open Raylib
open Constants

(** The signature of the boat character. *)
module type BoatSig = sig
  type t
  (** The type representing a boat. *)

  val boat_angle : float ref
  (** The angle of the boat in the previous frame. *)

  val new_boat : float -> float -> float -> float -> t
  (** Creates a new boat character at position (x, y) with width w and height h. *)

  val get_x : t -> float
  (** Given a boat, returns the x position of the boat in float value. *)

  val get_y : t -> float
  (** Given a boat, returns the y position of the boat in float value. *)

  val get_w : t -> float
  (** Given a boat, returns the width of the boat in float value. *)

  val get_h : t -> float
  (** Given a boat, returns the width of the boat in float value. *)

  val get_vect : t -> Vector2.t
  (** Given a boat, returns a Vector2.t representation of the boat at that
      instant. *)

  val get_boat_angle : t -> bool * bool * bool * bool -> float
  (** Given a boat and a quadruple of key presses, returns a float
      representation of the boat's angle heading. *)

  val is_border_crossed : t -> bool * string
  (** [is_border_crossed boat] returns whether the border of the window was
      crossed and in what way in the form of a tuple. *)

  val move : t -> float -> float -> unit
  (** Given a boat and the differences in x and y in float values, move the boat
      accordingly. *)

  val draw : t -> Texture2D.t -> bool * bool * bool * bool -> unit
  (** Given a boat and a quadruple of bools for each direction, draw the boat in
      the direction it should be facing based on the movement. *)

  val border_crossed : t -> unit
  (** Given a boat, moves the boat to the opposite side of the map if the boat
      touches the edges of the canvas window, respective of each edge of the
      map. *)
end

module Boat : BoatSig
(** The module used for controlling the boat. *)
