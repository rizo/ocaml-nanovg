
open Ctypes
open Foreign

let discard x = ()

let array_field st name t n =
  let r = field st name t in
  for i = 0 to (n - 1) do
    discard (field st name t)
  done; r

let antialias = 1 lsl 0
let stencil_strokes	= 1 lsl 1
let debug = 1 lsl 2

type context = unit ptr
let context : context typ = ptr void

type color
let color : color structure typ = structure "NVGcolor"
let color_r = field color "r" float
let color_g = field color "g" float
let color_b = field color "b" float
let color_a = field color "a" float
let () = seal color

type paint = {
  xform       : float list;
  extent      : float list;
  radius      : float;
  feather     : float;
  inner_color : color;
  outer_color : color;
  image       : int;
}

let paint : paint structure typ = structure "NVGpaint"

let paint_xform       = array_field paint "xform" float 6
let paint_extent      = array_field paint "extent" float 2
let paint_radius      = field paint "radius" float
let paint_feather     = field paint "feather" float
let paint_inner_color = field paint "innerColor" color
let paint_outer_color = field paint "outerColor" color
let paint_image       = field paint "image" int
let ()                = seal paint

let rgba =
  foreign "nvgRGBA"
    (int @-> int @-> int @-> int @-> returning color)

let rgb =
  foreign "nvgRGB"
    (int @-> int @-> int @-> returning color)

let rgbaf =
  foreign "nvgRGBAf"
    (float @-> float @-> float @-> float @-> returning color)

let null = Ctypes.null

let begin_frame =
  foreign "nvgBeginFrame" (context @-> int @-> int @-> float @-> returning void)

let cancel_frame =
  foreign "nvgCancelFrame" (context @-> returning void)

let end_frame =
  foreign "nvgEndFrame" (context @-> returning void)

let begin_path =
  foreign "nvgBeginPath" (context @-> returning void)

let fill =
  foreign "nvgFill" (context @-> returning void)

let rect =
  foreign "nvgRect" (context @-> float @-> float @-> float @-> float
                             @-> returning void)

let round_rect =
  foreign "nvgRoundedRect" (context @-> float @-> float @-> float @-> float
                                    @-> float @-> returning void)

let ellipse =
  foreign "nvgEllipse" (context @-> float @-> float @-> float @-> float
                                @-> returning void)

let fill_color =
  foreign "nvgFillColor" (context @-> color @-> returning void)

let create_image =
  foreign "nvgCreateImage" (context @-> string @-> int @-> returning int)

let image_size_c =
  foreign "nvgImageSize" (context @-> int @-> ptr int @-> ptr int @-> returning void)

let get_image_size vg img_id =
  let w = allocate int 0 in
  let h = allocate int 0 in
  image_size_c vg img_id w h;
  !@ w, !@ h

let image_pattern =
  foreign "nvgImagePattern" (context @-> float @-> float @-> float @-> float
                                     @-> float @-> int @-> float @-> returning paint)

let fill_paint =
  foreign "nvgFillPaint" (context @-> paint @-> returning void)

let create_gl3 =
  foreign "nvgCreateGL3" (int @-> returning context)


