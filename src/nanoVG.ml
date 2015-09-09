
open Ctypes
open Foreign


type context = unit ptr
let context : context typ = ptr void

type color
let color : color structure typ = structure "color"
let r = field color "r" float
let g = field color "g" float
let b = field color "b" float
let a = field color "a" float
let () = seal color

let null = Ctypes.null

let begin_frame =
  foreign "nvgBeginFrame" (context @-> int @-> int @-> float @-> returning void)

let cancel_frame =
  foreign "nvgCancelFrame" (context @-> returning void)

let end_frame =
  foreign "nvgEndFrame" (context @-> int @-> int @-> float @-> returning void)

let begin_path =
  foreign "nvgBeginPath" (context @-> returning void)

let fill =
  foreign "nvgFill" (context @-> returning void)

let round_rect =
  foreign "nvgRoundedRect" (context @-> float @-> float @-> float @-> float
                                    @-> float @-> returning void)

let fill_color =
  foreign "nvgFillColor" (context @-> color @-> returning void)

let create_gl3 =
  foreign "nvgCreateGL3" (int @-> returning context)

