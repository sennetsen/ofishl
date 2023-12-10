open Raylib

(** The signature for the collection of loaded data. *)
module type LoadList = sig
  type t
  (** The type to represent a LoadList. *)

  val initialize : string -> t
  (** [initialize map] initializes the LoadList according to the specified map
      given by [map]. *)

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

  val background_sound : t -> Sound.t
  (** Given a LoadList [loads] return the loaded background sound. *)

  val coin_sound : t -> Sound.t
  (** Given a LoadList [loads] return the loaded coin sound. *)

  val seamine_sound : t -> Sound.t
  (** Given a LoadList [loads] return the loaded seamine sound. *)

  val water_sound : t -> Sound.t
  (** Given a LoadList [loads] return the loaded water sound. *)

  val click_sound : t -> Sound.t
  (** Given a LoadList [loads] return the loaded click sound. *)

  val trapmine : t -> Texture2D.t
  (** Given a LoadList [loads] return the loaded texture of the trapmine. *)

  val minemine : t -> Texture2D.t
  (** Given a LoadList [loads] return the loaded texture of the minemine. *)

  val bombamine : t -> Texture2D.t
  (** Given a LoadList [loads] return the loaded texture of the bombamine. *)

  val coinpic : t -> Texture2D.t
  (** Given a LoadList [loads] return the loaded texture of the coin. *)

  val bobber : t -> Texture2D.t
  (** Given a LoadList [loads] return the loaded texture of the bobber. *)

  val exit : t -> Texture2D.t
  (** Given a LoadList [loads] return the loaded texture of the exit button. *)

  val boat : t -> Texture2D.t
  (** Given a LoadList [loads] return the loaded texture of the boat. *)
end

module Loadables : LoadList
(** The module that contains all the loaded data necessary for the game. *)
