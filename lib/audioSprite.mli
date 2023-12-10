open Raylib
open Boat

(** The signature of the sound object. *)
module type AudioSpriteSig = sig
  type t
  (** The type of a sound object. *)

  val start : unit -> unit
  (** Initializes the audio player in-game to process sound. *)

  val play : Sound.t -> unit
  (** Plays a sound file from a Sound.t. *)

  val is_playing : Sound.t -> bool
  (** Returns a bool of whether a sound is playing. *)
end

module AudioSprite : AudioSpriteSig
(** The module used for manipulating sprites. *)
