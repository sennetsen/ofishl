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
  val coin_sound : t -> Sound.t
  val trapmine : t -> Texture2D.t
  val minemine : t -> Texture2D.t
  val bombamine : t -> Texture2D.t
  val coinpic : t -> Texture2D.t
  val bobber : t -> Texture2D.t
end

module Loadables : LoadList = struct
  type t = {
    unisans_heavy : Font.t;
    boldenvan : Font.t;
    map : Texture2D.t;
    hsufish : Texture2D.t;
    kozenfish : Texture2D.t;
    background_sound : Sound.t;
    coin_sound : Sound.t;
    trapmine : Texture2D.t;
    minemine : Texture2D.t;
    bombamine : Texture2D.t;
    coinpic : Texture2D.t;
    bobber : Texture2D.t;
  }
  (** AF: The record [{ ... }] represents a LoadList to be used in the game. RI:
      No representation invariant necessary. *)

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
    let c_sound = load_sound "data/audio-sprites/underwater_coin.wav" in
    let trap = load_image "data/seamines/trap.png" in
    let texture_trap = load_texture_from_image trap in
    let mine = load_image "data/seamines/mine.png" in
    let texture_mine = load_texture_from_image mine in
    let bomba = load_image "data/seamines/bomba.png" in
    let texture_bomba = load_texture_from_image bomba in
    let coin = load_image "data/coin-sprites/coin.png" in
    let texture_coin = load_texture_from_image coin in
    let target = load_image "data/bobber/bobber.png" in
    let texture_target = load_texture_from_image target in

    unload_image background;
    unload_image hsu;
    unload_image kozen;
    unload_image trap;
    unload_image mine;
    unload_image bomba;
    unload_image coin;
    unload_image target;
    {
      unisans_heavy = uni_font;
      boldenvan = bolden_font;
      map = texture_background;
      hsufish = texture_hsu;
      kozenfish = texture_kozen;
      background_sound = bg_sound;
      coin_sound = c_sound;
      trapmine = texture_trap;
      minemine = texture_mine;
      bombamine = texture_bomba;
      coinpic = texture_coin;
      bobber = texture_target;
    }

  let uni_font (loads : t) = loads.unisans_heavy
  let bolden_font (loads : t) = loads.boldenvan
  let map (loads : t) = loads.map
  let hsufish (loads : t) = loads.hsufish
  let kozenfish (loads : t) = loads.kozenfish
  let background_sound (loads : t) = loads.background_sound
  let coin_sound (loads : t) = loads.coin_sound
  let trapmine (loads : t) = loads.trapmine
  let minemine (loads : t) = loads.minemine
  let bombamine (loads : t) = loads.bombamine
  let coinpic (loads : t) = loads.coinpic
  let bobber (loads : t) = loads.bobber
end
