open Raylib
open Constants

(** The signature of the custom map maker. *)
module type MapCustomMaker = sig
  type t

  val get_height : t -> int
  (** [get_height map] retrieves the height of the custom map [map]. *)

  val get_width : t -> int
  (** [get_width map] retrieves the width of the custom map [map]. *)

  (*val make_arr : string -> int array array
  (** [make_arr input] generates a new array for creating a custom map from
      user-specified input. *)*)

  val generate_map : int array array -> unit
  (** [generate_map array] generates a custom map from an integer array. *)
end

(** The module used for creating custom maps. *)
module Custom : MapCustomMaker