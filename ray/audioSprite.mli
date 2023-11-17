open Raylib
open Boat

(** The signature of the sound object. *)
module type AudioSpriteSig = sig
  type t
  (** The type of a sound object. *)

  val start : unit -> unit
  (** Initializes the audio player in-game to process sound. *)
  
  val play : string -> unit
  (** Plays a sound file from a parsed string.  *)
end

(** The module used for manipulating sprites. *)
module AudioSprite : AudioSpriteSig