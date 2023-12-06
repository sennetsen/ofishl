open Raylib

type t
(** The type to represent a target in the fishing minigame. *)

val generate : unit -> t
(** [generate ()] generates a target at a random location in the window. *)

val draw : t -> unit
(** [draw target] draws [target] at its given location and colors it gray. *)

val colliding : Vector2.t -> t -> bool
(** [colliding mouse target] returns true if the mouse cursor at vector location
    [mouse] is colliding with [target]. *)
