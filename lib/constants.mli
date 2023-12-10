open Raylib
open Vector2

val canvas_height_fl : float
(** Fixed float value for the height of the game window. *)

val canvas_width_fl : float
(** Fixed float value for the width of the game window. *)

val speed : float ref
(** Represents the speed of the sprite. Speed can be mutated. *)

val set_speed : float -> unit
(** Sets the speed of the sprite to a specific float value. *)

val get_speed : unit -> float
(** Gets the speed of the sprite at that instant. *)

val diag_speed : unit -> float
(** Gets the appropriately matched speed of the sprite when moving diagonally
    rather than horizontally or vertically. *)
