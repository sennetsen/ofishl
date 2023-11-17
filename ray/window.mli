open Raylib
open Boat
open Fish

val setup : unit -> unit
(** Sets up the window where the game is being run. *)
  
val loop : string -> unit
(** Runs all the operating functions for the game while the window is open. *)

val run : string -> unit
(** Activates the window and allows the user to interact with what's inside. *)