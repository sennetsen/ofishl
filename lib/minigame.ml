open Raylib

(** The module used for controlling targets. *)
module Target = struct
  type t = Vector2.t

  let generate (() : unit) : t =
    Vector2.create (Random.float 512.) (Random.float 512.)

  let draw (target : t) : unit = draw_circle_v target 18. Color.gray

  let colliding (mouse : Vector2.t) (target : t) : bool =
    check_collision_point_circle mouse target 18.
end

let score = ref 0
let current_target = ref (Target.generate ())

(** Sets up the window where the game is being run. *)
let setup () =
  Raylib.init_window 512 512 "Catch the fish!";
  Raylib.set_target_fps 60

(** Runs all the operating functions for the game while the window is open. *)
let rec loop () =
  if !score = 5 then Raylib.close_window ()
  else if
    is_mouse_button_pressed MouseButton.Left
    && Target.colliding (get_mouse_position ()) !current_target
  then (
    score := succ !score;
    current_target := Target.generate ());
  begin_drawing ();
  clear_background Color.raywhite;
  Target.draw !current_target;
  end_drawing ();
  loop ()

let run () =
  Raylib.set_trace_log_level Error;
  setup ();
  loop ()
