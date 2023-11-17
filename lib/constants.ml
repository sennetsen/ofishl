open Raylib
open Vector2

(** Constant values for use in code implementations of Raylib GUI application. *)
module Const = struct
  let canvas_height_fl : float = 512.

  (* Fixed height value for the interactive window. *)
  let canvas_width_fl : float = 512.

  (* Fixed height value for the interactive window. *)
  let gravity : float = 9.81

  (* Gravity constant for implementation of game physics. *)
  let volume : int = 75

  (* Master volume for audio soundtrack for game when GUI window is open. *)
  let level_easy = 1
  let level_med = 2
  let level_hard = 3
  (* Constants for game difficulty level. *)
end
