open Raylib
open Constants

(** The signature of the boat character. *)
module type BoatSig = sig
    type t
    (* TODO: change these 4 variables to a type t. *)
    val boat_pos : Vector2.t ref
    (** The vector value for the current position of the center of the boat in the
        window. *)
  
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

    val move : Vector2.t -> unit
    (** Given a movement vector and a bool which is true when the boat is facing 
        horizontally and false when facing vertically, move the boat accordingly. *)

    val draw : unit -> unit
    (** Draws the boat at its current position and orientation and colors it brown. *)
 
    val border_crossed : unit -> unit
    (** Given a boat, return true if the boat touches the edges of the canvas
        window. *)
    (* TODO: Change this documentation. *)
end

(** The module used for controlling the boat. *)
module Boat : BoatSig