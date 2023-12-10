open Raylib
open Constants

(** The signature of the boat character. *)
module type BoatSig = sig
  type t

  val boat_angle : float ref
  val new_boat : float -> float -> float -> float -> t
  val get_x : t -> float
  val get_y : t -> float
  val get_w : t -> float
  val get_h : t -> float
  val get_vect : t -> Vector2.t
  val get_boat_angle : t -> bool * bool * bool * bool -> float
  val is_border_crossed : t -> bool * string
  val move : t -> float -> float -> unit
  val draw : t -> Texture2D.t -> bool * bool * bool * bool -> unit
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

  let boat_angle = ref 0.

  let new_boat (x : float) (y : float) (width : float) (height : float) : t =
    ref (Rectangle.create x y width height)

  let get_x (boat : t) : float = Rectangle.x !boat
  let get_y (boat : t) : float = Rectangle.y !boat
  let get_w (boat : t) : float = Rectangle.width !boat
  let get_h (boat : t) : float = Rectangle.height !boat
  let get_vect (boat : t) : Vector2.t = Vector2.create (get_x boat) (get_y boat)

  let get_boat_angle (boat : t) (keys : bool * bool * bool * bool) : float =
    match keys with
    | true, true, false, false -> 45.
    | true, false, false, true -> 135.
    | false, false, true, true -> 225.
    | false, true, true, false -> 315.
    | false, true, false, false | true, true, true, false -> 0.
    | true, true, false, true | true, false, false, false -> 90.
    | true, false, true, true | false, false, false, true -> 180.
    | false, true, true, true | false, false, true, false -> 270.
    | _ -> -1.

  let is_border_crossed (boat : t) : bool * string =
    if Rectangle.x !boat <= 0. then (true, "x left")
    else if Rectangle.x !boat >= Constants.canvas_width_fl then (true, "x right")
    else if Rectangle.y !boat <= 0. then (true, "y upper")
    else if Rectangle.y !boat >= Constants.canvas_height_fl then
      (true, "y lower")
    else (false, "border is not crossed")

  let move (boat : t) (dx : float) (dy : float) : unit =
    Rectangle.set_x !boat (get_x boat +. dx);
    Rectangle.set_y !boat (get_y boat +. dy)

  let draw (boat : t) (texture_boat : Texture2D.t)
      (keys : bool * bool * bool * bool) : unit =
    let angle = get_boat_angle boat keys in
    let correct_angle =
      if angle = -1. then !boat_angle
      else (
        boat_angle := angle;
        angle)
    in
    draw_texture_pro texture_boat
      (Rectangle.create 0. 0. 109. 100.)
      !boat
      (Vector2.create
         (Rectangle.width !boat /. 2.)
         (Rectangle.height !boat /. 2.))
      correct_angle Color.white

  (* draw_rectangle_pro !boat (Vector2.create (Rectangle.width !boat /. 2.)
     (Rectangle.height !boat /. 2.)) angle Color.brown *)

  let border_crossed (boat : t) : unit =
    match is_border_crossed boat with
    | true, "x left" -> Rectangle.set_x !boat Constants.canvas_width_fl
    | true, "x right" -> Rectangle.set_x !boat 0.
    | true, "y upper" -> Rectangle.set_y !boat Constants.canvas_height_fl
    | true, "y lower" -> Rectangle.set_y !boat 0.
    | _, _ -> ()
end
