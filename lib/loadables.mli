open Raylib

(** The signature for the collection of loaded data. *)
module type LoadList = sig
  type t
  (** The type to represent a LoadList. *)

  val initialize : string -> t
  (** [initialize map] initializes the LoadList according to the specified map given by [map]. *)

  val uni_font : t -> Font.t
  (** Given a LoadList [loads] return the loaded unisans_heavy font. *)

  val bolden_font : t -> Font.t
  (** Given a LoadList [loads] return the loaded boldenvan font. *)

  val map : t -> Texture2D.t
  (** Given a LoadList [loads] return the loaded map texture. *)

  val hsufish : t -> Texture2D.t
  (** Given a LoadList [loads] return the loaded texture of the hsufish. *)

  val kozenfish : t -> Texture2D.t
  (** Given a LoadList [loads] return the loaded texture of the kozenfish. *)
end

module Loadables : LoadList