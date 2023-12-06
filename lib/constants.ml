open Raylib
open Vector2

(** Constant values for use in code implementations of Raylib GUI application. *)
module Const = struct
  
  type level =
  | Easy
  | Medium
  | Hard
  (* Type for game difficulty level. *)

  let canvas_height_fl : float = 512.

  (* Fixed height value for the interactive window. *)
  let canvas_width_fl : float = 512.

  (* Fixed height value for the interactive window. *)
  let gravity : float = 9.81

  (* Gravity constant for implementation of game physics. *)
  let volume : int = 75

  (* Master volume for audio soundtrack for game when GUI window is open. *)
 
end
