open Raylib
open Constants

type t
(** The type of a score element. *)

val new_score : unit -> t
(** Creates a new score value for use in the game. *)

val is_score : t -> bool
(** Determines if the current score meets a certain threshold for further
    actions to be executed depending on the game level. *)

val get_score : t -> int
(** Returns the integer value of the current score. *)

val print : t -> Font.t -> unit
(** Prints a score value when called during a game run. *)

val update_score : t -> int -> unit
(** Updates the score based on changes in user actions and gameplay.*)

val set_font_size : t -> float -> unit
(** Sets the font size of a printed score value. *)

val set_color : t -> Color.t -> unit
(** Sets the color of a printed score value. *)
