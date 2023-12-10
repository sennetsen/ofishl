open Raylib
open Vector2

(** The signature of the audio object. *)
module type AudioSpriteSig = sig
  type t

  val start : unit -> unit
  val play : Sound.t -> unit
  val is_playing : Sound.t -> bool
end

(** The module used for controlling audio. *)
module AudioSprite : AudioSpriteSig = struct
  type t = Sound.t

  let start () = init_audio_device ()
  let play (sound : Sound.t) : unit = play_sound sound
  let is_playing (sound : Sound.t) : bool = is_sound_playing sound
end
