open Raylib

module type LoadList = sig
  type t

  val initialize : string -> t
  val uni_font : t -> Font.t
  val bolden_font : t -> Font.t
  val map : t -> Texture2D.t
  val hsufish : t -> Texture2D.t
  val kozenfish : t -> Texture2D.t
  val background_sound : t -> Sound.t
end

module Loadables : LoadList = struct
  type t = {
    unisans_heavy : Font.t;
    boldenvan : Font.t;
    map : Texture2D.t;
    hsufish : Texture2D.t;
    kozenfish : Texture2D.t;
    background_sound : Sound.t;
  }
  (** AF: The record
      [{
        unisans_heavy = font1; 
        boldenvan = font2; 
        map = maptexture; 
        hsufish = hsufishtexture; 
        kozenfish = kozenfishtexture;
        background_sound = backgroundsound;
      }]
      represents a LoadList to be used in the game. RI: No representation
      invariant necessary. *)

  let initialize (map : string) =
    let uni_font = load_font "data/fonts/uni-sans/Uni Sans Heavy.otf" in
    let bolden_font = load_font "data/fonts/boldenvan/boldenvan.ttf" in
    let background = load_image ("data/sprites/bkg" ^ map ^ ".png") in
    let texture_background = load_texture_from_image background in
    let hsu = load_image "data/fish-sprites/smallerhsu.png" in
    let texture_hsu = load_texture_from_image hsu in
    let kozen = load_image "data/fish-sprites/smallerkozen.png" in
    let texture_kozen = load_texture_from_image kozen in
    let bg_sound = load_sound "data/audio-sprites/track1.wav" in
    unload_image background;
    unload_image hsu;
    unload_image kozen;
    {
      unisans_heavy = uni_font;
      boldenvan = bolden_font;
      map = texture_background;
      hsufish = texture_hsu;
      kozenfish = texture_kozen;
      background_sound = bg_sound;
    }

  let uni_font (loads : t) = loads.unisans_heavy
  let bolden_font (loads : t) = loads.boldenvan
  let map (loads : t) = loads.map
  let hsufish (loads : t) = loads.hsufish
  let kozenfish (loads : t) = loads.kozenfish
  let background_sound (loads : t) = loads.background_sound
end
