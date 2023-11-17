open Raylib
open Vector2

(** The signature of the audio object. *)
module type AudioSpriteSig = sig
  type t

  val start : unit -> unit
  val play : string -> unit
end

(** The module used for controlling audio. *)
module AudioSprite : AudioSpriteSig = struct
  type t = Sound.t

  let start () = init_audio_device ()

  let play (audio_file : string) : unit =
    let sound = load_sound audio_file in
    play_sound sound
end
