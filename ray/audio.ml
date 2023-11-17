open Raylib
open Vector2

(** The signature of the audio object. *)
module type AudioSig = sig
  type t

end

(** The module used for controlling audio. *)
module Audio : AudioSig = struct
  
end