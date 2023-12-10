open Raylib
open Constants

(** The signature of the boat character. *)
module type BoatSig = sig
  type t

  val new_boat : float -> float -> float -> float -> t
  val get_x : t -> float
  val get_y : t -> float
  val get_vect : t -> Vector2.t
  val get_boat_angle : t -> bool * bool * bool * bool -> float
  val move : t -> float -> float -> unit
  val draw : t -> bool * bool * bool * bool -> unit
  val border_crossed : t -> unit
end

(** The module used for controlling the boat. *)
module Boat : BoatSig = struct
  type t = Rectangle.t ref
  (** AF: The boat is represented by a mutable Raylib.Rectangle whose x and y
      position correspond with the position of the boat in the game window and
      whose width and height correspond with the dimensions of the boat. RI: the
      x and y of the rectangle must always be within the dimensions of the game
      window. So must the height and width. *)

  type inv = {
    rods : int;
    bait : int;
  }

  let new_boat (x : float) (y : float) (width : float) (height : float) : t =
    ref (Rectangle.create x y width height)

  let get_x (boat : t) : float = Rectangle.x !boat
  let get_y (boat : t) : float = Rectangle.y !boat
  let get_vect (boat : t) : Vector2.t = Vector2.create (get_x boat) (get_y boat)

  let get_boat_angle (boat : t) (keys : bool * bool * bool * bool) : float =
    match keys with
    | true, true, false, false | false, false, true, true -> 45.
    | false, true, true, false | true, false, false, true -> 135.
    | true, false, false, false | false, false, true, false -> 90.
    | _ -> 0.

  let move (boat : t) (dx : float) (dy : float) : unit =
    Rectangle.set_x !boat (get_x boat +. dx);
    Rectangle.set_y !boat (get_y boat +. dy)

  let draw (boat : t) (keys : bool * bool * bool * bool) : unit =
    let angle = get_boat_angle boat keys in
    draw_rectangle_pro !boat
      (Vector2.create
         (Rectangle.width !boat /. 2.)
         (Rectangle.height !boat /. 2.))
      angle Color.brown

  let border_crossed (boat : t) : unit =
    if Rectangle.x !boat <= 0. then Rectangle.set_x !boat Const.canvas_width_fl
    else if Rectangle.x !boat >= Const.canvas_width_fl then
      Rectangle.set_x !boat 0.
    else if Rectangle.y !boat <= 0. then
      Rectangle.set_y !boat Const.canvas_height_fl
    else if Rectangle.y !boat >= Const.canvas_height_fl then
      Rectangle.set_y !boat 0.
end
