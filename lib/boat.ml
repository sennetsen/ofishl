open Raylib
open Constants

(** The signature of the boat character. *)
module type BoatSig = sig
  type t

  val new_boat : t
  val boat_h : Vector2.t
  val boat_v : Vector2.t
  val boat_face : Vector2.t ref
  val get_x : t -> int
  val get_y : t -> int
  val get_vect : t -> Vector2.t
  val move : t -> float -> float -> unit
  val draw : t -> unit
  val border_crossed : t -> unit
end

(** The module used for controlling the boat. *)
module Boat : BoatSig = struct
  type t = Vector2.t ref

  let new_boat = ref (Vector2.create 400. 225.)
  let boat_h = Vector2.create 15. 10.
  let boat_v = Vector2.create 10. 15.
  let boat_face = ref boat_h
  let get_x (boat : t) : int = int_of_float (Vector2.x !boat)
  let get_y (boat : t) : int = int_of_float (Vector2.y !boat)
  let get_vect (boat : t) : Vector2.t = !boat

  let move (boat : t) (dx : float) (dy : float) : unit =
    if dx = 0. then boat_face := boat_v else boat_face := boat_h;
    boat := Vector2.add !boat (Vector2.create dx dy)

  let draw (boat : t) : unit =
    (* The horiztonal and vertical radii respectively of the ellipse that
       represents the boat. *)
    let radh = Vector2.x !boat_face in
    let radv = Vector2.y !boat_face in
    draw_ellipse (get_x boat) (get_y boat) radh radv Color.brown

  let border_crossed (boat : t) : unit =
    if Vector2.x !boat <= 0. then Vector2.set_x !boat Const.canvas_width_fl
    else if Vector2.x !boat >= Const.canvas_width_fl then Vector2.set_x !boat 0.
    else if Vector2.y !boat <= 0. then
      Vector2.set_y !boat Const.canvas_height_fl
    else if Vector2.y !boat >= Const.canvas_height_fl then
      Vector2.set_y !boat 0.
end
