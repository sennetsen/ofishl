open Raylib
open Boat
open Fish

type state
(** [value] is the type of the game state *)

val setup : string -> string -> unit
(** Sets up the window where the game is being run. *)

val looper : string -> state -> unit
(** Runs all the operating functions for the current state of the game while the
    window is open. *)

val loop : string -> unit
(** Runs all the operating functions for main window. *)

val run : string -> string -> unit
(** Activates the window and allows the user to interact with what's inside. *)
