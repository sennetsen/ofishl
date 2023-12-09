open Raylib
open Vector2

(** Constant values for use in code implementations of Raylib GUI application. *)
module Const = struct
  type level =
    | Easy
    | Medium
    | Hard  (** Type for game difficulty level. *)

  (** Fixed height value for the interactive window. *)
  let canvas_height_fl : float = 512.

  (* Fixed width value for the interactive window. *)
  let canvas_width_fl : float = 512.

  (** Gravity constant for implementation of game physics. *)
  let gravity : float = 9.81

  (** Master volume for audio soundtrack for game when GUI window is open. *)
  let volume : int = 75

  let speed : float ref = ref 1.
  let set_speed (sp : float) : unit = speed := sp
  let get_speed () : float = !speed
  let diag_speed () : float = !speed /. sqrt 2.
end
