open Raylib
open Boat
open Vector2
open Score

module type SpriteSig = sig
  type t

  val generate : Boat.t -> t
  val draw : Texture2D.t -> t -> unit
  val colliding : Vector2.t -> t -> bool
  val get_score : t -> int
  val in_bounds : t -> bool
end

module Coin : SpriteSig = struct
  type t = Vector2.t
  (** AF: The 2-D vector from the Raylib.Vector2 module represents a coin at the
      coordinate position of the vector with respect to the origin at the
      top-left corner. RI: The coordinates of the vector must always be
      contained within the dimensions of the game window.*)

  let rec generate (boat : Boat.t) : t =
    let x, y = (Random.float 512., Random.float 512.) in
    if x <= 310. && x >= 220. && y <= 310. && y >= 220. then generate boat
    else
      let boat_x, boat_y = (Boat.get_x boat, Boat.get_y boat) in
      if
        x <= boat_x +. 20.
        && x >= boat_x -. 20.
        && y <= boat_y +. 20.
        && y >= boat_x -. 20.
      then generate boat
      else Vector2.create x y

  let draw (texture : Texture2D.t) (sprite : t) : unit =
    draw_texture texture
      (int_of_float (Vector2.x sprite) - 10)
      (int_of_float (Vector2.y sprite) - 10)
      Color.raywhite

  let colliding (boat : Vector2.t) (sprite : t) : bool =
    check_collision_circles boat 15. sprite 8.

  let get_score (coin : t) = 1

  let in_bounds (coin : t) =
    Vector2.x coin >= 8.
    && Vector2.x coin <= 504.
    && Vector2.y coin >= 8.
    && Vector2.y coin <= 504.
end

module Seamine : SpriteSig = struct
  type diff =
    | Trap
    | Mine
    | Bomba

  type t = Vector2.t * diff
  (** AF: The tuple [(v, diff)] represents a seamine where [v] is a 2-D vector
      from the Raylib.Vector2 module represents a mine at the coordinate
      position of the vector with respect to the origin at the top-left corner
      and the value of [diff] is the severity of the mine. RI: The coordinates
      of the vector must always be contained within the dimensions of the game
      window.*)

  (** Gives a random difficulty bomb given the three categories: Trap, Mine, and
      Bomb *)
  let random_diff (() : unit) : diff =
    match Random.int 3 with
    | 0 -> Trap
    | 1 -> Mine
    | 2 -> Bomba
    | _ -> failwith ""

  (** Given some mine returns the damage done by bombs Trap = -1, Mine = -3, and
      Bomb = -5. *)
  let get_score (mine : t) : int =
    match snd mine with
    | Trap -> -1
    | Mine -> -3
    | Bomba -> -5

  let rec generate (boat : Boat.t) : t =
    let x, y = (Random.float 512., Random.float 512.) in
    if x <= 310. && x >= 220. && y <= 310. && y >= 220. then generate boat
    else
      let boat_x, boat_y = (Boat.get_x boat, Boat.get_y boat) in
      if
        x <= boat_x +. 20.
        && x >= boat_x -. 20.
        && y <= boat_y +. 20.
        && y >= boat_x -. 20.
      then generate boat
      else (Vector2.create x y, random_diff ())

  let draw (texture : Texture2D.t) (sprite : t) : unit =
    draw_texture texture
      (int_of_float (Vector2.x (fst sprite)) - 15)
      (int_of_float (Vector2.y (fst sprite)) - 15)
      Color.raywhite

  let colliding (boat : Vector2.t) (sprite : t) : bool =
    check_collision_circles boat 15. (fst sprite) 8.

  let in_bounds (mine : t) =
    Vector2.x (fst mine) >= 8.
    && Vector2.x (fst mine) <= 504.
    && Vector2.y (fst mine) >= 8.
    && Vector2.y (fst mine) <= 504.
end

module Target : SpriteSig = struct
  type t = Vector2.t
  (** AF: The 2-D vector from the Raylib.Vector2 module represents a target at
      the coordinate position of the vector with respect to the origin at the
      top-left corner. RI: The coordinates of the vector must always be
      contained within the dimensions of the game window.*)

  let generate (boat : Boat.t) : t =
    Vector2.create (Random.float 512.) (Random.float 512.)

  let draw (texture : Texture2D.t) (target : t) : unit =
    draw_texture texture
      (int_of_float (Vector2.x target) - 18)
      (int_of_float (Vector2.y target) - 18)
      Color.raywhite

  let colliding (mouse : Vector2.t) (target : t) : bool =
    check_collision_point_circle mouse target 18.

  let get_score (target : t) = 1

  let in_bounds (target : t) =
    Vector2.x target >= 18.
    && Vector2.x target <= 494.
    && Vector2.y target >= 18.
    && Vector2.y target <= 494.
end

module Fish : SpriteSig = struct
  type t = Vector2.t
  (** AF: The 2-D vector from the Raylib.Vector2 module represents a fish at the
      coordinate position of the vector with respect to the origin at the
      top-left corner. RI: The coordinates of the vector must always be
      contained within the dimensions of the game window.*)

  let rec generate (boat : Boat.t) : t =
    let x, y = (Random.float 512., Random.float 512.) in
    if x <= 310. && x >= 220. && y <= 310. && y >= 220. then generate boat
    else
      let boat_x, boat_y = (Boat.get_x boat, Boat.get_y boat) in
      if
        x <= boat_x +. 20.
        && x >= boat_x -. 20.
        && y <= boat_y +. 20.
        && y >= boat_x -. 20.
      then generate boat
      else Vector2.create x y

  let draw (texture : Texture2D.t) (fish : t) =
    draw_texture texture
      (int_of_float (Vector2.x fish) - 50)
      (int_of_float (Vector2.y fish) - 50)
      Color.raywhite

  let colliding (boat : Vector2.t) (fish : t) : bool =
    check_collision_circles boat 15. fish 50.

  let get_score (fish : t) = 3

  let in_bounds (target : t) =
    Vector2.x target >= 50.
    && Vector2.x target <= 462.
    && Vector2.y target >= 50.
    && Vector2.y target <= 462.
end
