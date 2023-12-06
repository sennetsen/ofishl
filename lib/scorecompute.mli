open Raylib
open Constants

  type t
  (** The type of a score element. *)

  (** The type of a score element. *)

  val new_score : unit -> t
  (** Creates a new score value for use in the game. *)

  val is_score : t -> bool
  (** Determines if the current score meets a certain threshold for further 
      actions to be executed depending on the game level. *)

  val print : t -> unit
  (** Prints a score value when called during a game run. *)

  val update_score : t -> int -> unit
  (** Updates the score based on changes in user actions and gameplay.*)

  val set_font_size : t -> int -> unit
  (** Sets the font size of a printed score value. *)

  val set_color : t -> string -> unit
  (** Sets the color of a printed score value. *)