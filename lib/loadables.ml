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
  val seamine_sound : t -> Sound.t
  val water_sound : t -> Sound.t
  val click_sound : t -> Sound.t
  val trapmine : t -> Texture2D.t
  val minemine : t -> Texture2D.t
  val bombamine : t -> Texture2D.t
  val coinpic : t -> Texture2D.t
  val bobber : t -> Texture2D.t
  val exit : t -> Texture2D.t
  val boat : t -> Texture2D.t
end

module Loadables : LoadList = struct
  type fonts = {
    unisans_heavy : Font.t;
    boldenvan : Font.t;
  }

  type textures = {
    map : Texture2D.t;
    hsufish : Texture2D.t;
    kozenfish : Texture2D.t;
    trapmine : Texture2D.t;
    minemine : Texture2D.t;
    bombamine : Texture2D.t;
    coinpic : Texture2D.t;
    bobber : Texture2D.t;
    exit : Texture2D.t;
    boat : Texture2D.t;
  }

  type sounds = {
    background_sound : Sound.t;
    coin_sound : Sound.t;
    seamine_sound : Sound.t;
    water_sound : Sound.t;
    click_sound : Sound.t;
  }

  type t = {
    fonts : fonts;
    textures : textures;
    sounds : sounds;
  }
  (** AF: The record [{ fonts = ...; textures = ...; sounds = ... }] represents
      a LoadList to be used in the game. RI: No representation invariant
      necessary. *)

  let initialize (map : string) =
    let uni_font = load_font "./data/fonts/uni-sans/Uni Sans Heavy.otf" in
    let bolden_font = load_font "./data/fonts/boldenvan/boldenvan.ttf" in
    let background = load_image ("./data/sprites/bkg" ^ map ^ ".png") in
    let texture_background = load_texture_from_image background in
    let hsu = load_image "./data/fish-sprites/smallerhsu.png" in
    let texture_hsu = load_texture_from_image hsu in
    let kozen = load_image "./data/fish-sprites/smallerkozen.png" in
    let texture_kozen = load_texture_from_image kozen in
    let bg_sound = load_sound "./data/audio-sprites/track1.wav" in
    let c_sound = load_sound "./data/audio-sprites/underwater_coin.wav" in
    let mine_sound = load_sound "./data/audio-sprites/seamine.wav" in
    let wat_sound = load_sound "./data/audio-sprites/water_click.wav" in
    let clk_sound = load_sound "./data/audio-sprites/click_sound.wav" in
    let trap = load_image "./data/seamines/trap.png" in
    let texture_trap = load_texture_from_image trap in
    let mine = load_image "./data/seamines/mine.png" in
    let texture_mine = load_texture_from_image mine in
    let bomba = load_image "./data/seamines/bomba.png" in
    let texture_bomba = load_texture_from_image bomba in
    let coin = load_image "./data/coin-sprites/coin.png" in
    let texture_coin = load_texture_from_image coin in
    let target = load_image "./data/bobber/bobber.png" in
    let texture_target = load_texture_from_image target in
    let exit = load_image "./data/buttons/exit.png" in
    let texture_exit = load_texture_from_image exit in
    let bt_img = load_image "./data/boat/boat.png" in
    let texture_bt = load_texture_from_image bt_img in
    unload_image background;
    unload_image hsu;
    unload_image kozen;
    unload_image trap;
    unload_image mine;
    unload_image bomba;
    unload_image coin;
    unload_image target;
    unload_image exit;
    unload_image bt_img;
    {
      fonts = { unisans_heavy = uni_font; boldenvan = bolden_font };
      textures =
        {
          map = texture_background;
          hsufish = texture_hsu;
          kozenfish = texture_kozen;
          trapmine = texture_trap;
          minemine = texture_mine;
          bombamine = texture_bomba;
          coinpic = texture_coin;
          bobber = texture_target;
          exit = texture_exit;
          boat = texture_bt;
        };
      sounds =
        {
          background_sound = bg_sound;
          coin_sound = c_sound;
          seamine_sound = mine_sound;
          water_sound = wat_sound;
          click_sound = clk_sound;
        };
    }

  let uni_font (loads : t) = loads.fonts.unisans_heavy
  let bolden_font (loads : t) = loads.fonts.boldenvan
  let map (loads : t) = loads.textures.map
  let hsufish (loads : t) = loads.textures.hsufish
  let kozenfish (loads : t) = loads.textures.kozenfish
  let background_sound (loads : t) = loads.sounds.background_sound
  let coin_sound (loads : t) = loads.sounds.coin_sound
  let seamine_sound (loads : t) = loads.sounds.seamine_sound
  let water_sound (loads : t) = loads.sounds.water_sound
  let click_sound (loads : t) = loads.sounds.click_sound
  let trapmine (loads : t) = loads.textures.trapmine
  let minemine (loads : t) = loads.textures.minemine
  let bombamine (loads : t) = loads.textures.bombamine
  let coinpic (loads : t) = loads.textures.coinpic
  let bobber (loads : t) = loads.textures.bobber
  let exit (loads : t) = loads.textures.exit
  let boat (loads : t) = loads.textures.boat
end
