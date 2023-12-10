open Raylib
open Boat
open Vector2
open Score
open Box

module type SpriteSig = sig
  type t

  val generate_fixed : float -> float -> t
  val generate : Boat.t -> Box.t -> t
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

  let generate_fixed (x : float) (y : float) : t = Vector2.create x y

  let rec generate (boat : Boat.t) (store : Box.t) : t =
    let x, y = (Random.float 488., Random.float 488.) in
    let store_x, store_y = (Box.get_coord "x" store, Box.get_coord "y" store) in
    if
      x <= store_x +. 60.
      && x >= store_x -. 10.
      && y <= store_y +. 60.
      && y >= store_y -. 10.
    then generate boat store
    else
      let boat_x, boat_y, boat_w, boat_h =
        (Boat.get_x boat, Boat.get_y boat, Boat.get_w boat, Boat.get_h boat)
      in
      if
        x <= boat_x +. boat_w
        && x >= boat_x -. boat_w
        && y <= boat_y +. boat_w
        && y >= boat_x -. boat_h
      then generate boat store
      else Vector2.create (x +. 12.) (y +. 12.)

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

  let generate_fixed (x : float) (y : float) : t =
    (Vector2.create x y, random_diff ())

  let rec generate (boat : Boat.t) (store : Box.t) : t =
    let x, y = (Random.float 496., Random.float 496.) in
    let store_x, store_y = (Box.get_coord "x" store, Box.get_coord "y" store) in
    if
      x <= store_x +. 60.
      && x >= store_x -. 10.
      && y <= store_y +. 60.
      && y >= store_y -. 10.
    then generate boat store
    else
      let boat_x, boat_y, boat_w, boat_h =
        (Boat.get_x boat, Boat.get_y boat, Boat.get_w boat, Boat.get_h boat)
      in
      if
        x <= boat_x +. boat_w
        && x >= boat_x -. boat_w
        && y <= boat_y +. boat_w
        && y >= boat_x -. boat_h
      then generate boat store
      else (Vector2.create (x +. 8.) (y +. 8.), random_diff ())

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

  let generate_fixed (x : float) (y : float) : t = Vector2.create x y

  let generate (boat : Boat.t) (store : Box.t) : t =
    let x, y = (Random.float 476., Random.float 476.) in
    Vector2.create (x +. 18.) (y +. 18.)

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

  let generate_fixed (x : float) (y : float) : t = Vector2.create x y

  let rec generate (boat : Boat.t) (store : Box.t) : t =
    let x, y = (Random.float 412., Random.float 412.) in
    let store_x, store_y = (Box.get_coord "x" store, Box.get_coord "y" store) in
    if
      x <= store_x +. 60.
      && x >= store_x -. 10.
      && y <= store_y +. 60.
      && y >= store_y -. 10.
    then generate boat store
    else
      let boat_x, boat_y, boat_w, boat_h =
        (Boat.get_x boat, Boat.get_y boat, Boat.get_w boat, Boat.get_h boat)
      in
      if
        x <= boat_x +. boat_w
        && x >= boat_x -. boat_w
        && y <= boat_y +. boat_w
        && y >= boat_x -. boat_h
      then generate boat store
      else Vector2.create (x +. 50.) (y +. 50.)

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
