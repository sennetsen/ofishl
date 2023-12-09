open Raylib
open Constants

(** The signature of the boat character. *)
module type BoatSig = sig
  type t

  val new_boat : t
  val boat_h : Vector2.t
  val boat_v : Vector2.t
  val boat_face : Vector2.t ref
  val get_x : t -> float
  val get_y : t -> float
  val get_vect : t -> Vector2.t
  val move : t -> float -> float -> unit
  val draw : t -> unit
  val draw2 : t -> bool * bool * bool * bool -> unit
  val border_crossed : t -> unit
end

(** The module used for controlling the boat. *)
module Boat : BoatSig = struct
  type t = Vector2.t ref

  let new_boat : t = ref (Vector2.create 310. 260.)
  let boat_h = Vector2.create 15. 10.
  let boat_v = Vector2.create 10. 15.
  let boat_face = ref boat_h
  let get_x (boat : t) : float = Vector2.x !boat
  let get_y (boat : t) : float = Vector2.y !boat
  let get_vect (boat : t) : Vector2.t = !boat

  let move (boat : t) (dx : float) (dy : float) : unit =
    (* Unused now: if dx = 0. then boat_face := boat_v else boat_face :=
       boat_h; *)
    boat := Vector2.add !boat (Vector2.create dx dy)

  let draw (boat : t) : unit =
    (* The horiztonal and vertical radii respectively of the ellipse that
       represents the boat. *)
    let radh = Vector2.x !boat_face in
    let radv = Vector2.y !boat_face in

    draw_ellipse
      (int_of_float (get_x boat))
      (int_of_float (get_y boat))
      radh radv Color.brown

  let draw2 (boat : t) (keys : bool * bool * bool * bool) : unit =
    let angle =
      match keys with
      | true, true, false, false | false, false, true, true -> 45.
      | false, true, true, false | true, false, false, true -> 135.
      | true, false, false, false | false, false, true, false -> 90.
      | _ -> 0.
    in
    let rec_boat = Rectangle.create (get_x boat) (get_y boat) 40. 25. in
    draw_rectangle_pro rec_boat (Vector2.create 20. 12.5) angle Color.brown

  let border_crossed (boat : t) : unit =
    if Vector2.x !boat <= 0. then Vector2.set_x !boat Const.canvas_width_fl
    else if Vector2.x !boat >= Const.canvas_width_fl then Vector2.set_x !boat 0.
    else if Vector2.y !boat <= 0. then
      Vector2.set_y !boat Const.canvas_height_fl
    else if Vector2.y !boat >= Const.canvas_height_fl then
      Vector2.set_y !boat 0.
end
