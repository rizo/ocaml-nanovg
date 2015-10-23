
open Ctypes
open Foreign

let discard x = ()

let array_field st name t n =
  let r = field st name t in
  for i = 0 to (n - 1) do
    discard (field st name t)
  done; r

let antialias       = 1 lsl 0
let stencil_strokes = 1 lsl 1
let debug           = 1 lsl 2

(* Align *)

let align_left 		= 1 lsl 0
let align_center 	= 1 lsl 1
let align_right 	= 1 lsl 2

let align_top      = 1 lsl 3
let align_middle   = 1 lsl 4
let align_bottom   = 1 lsl 5
let align_baseline = 1 lsl 6


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

let font_size =
  foreign "nvgFontSize" (context @-> float @-> returning void)

let font_face =
  foreign "nvgFontFace" (context @-> string @-> returning void)

let text_align =
  foreign "nvgTextAlign" (context @-> int @-> returning void)

let _text =
  foreign "nvgText" (context @-> float @-> float @-> string @-> ptr void @-> returning float)

let text vg x y txt =
  discard (_text vg x y txt null)

(* let _text_bounds = *)
  (* foreign "nvgTextBounds" (context @-> float @-> float @-> string @-> string @-> ptr float @-> returning float) *)

(* let text_bounds vg x y str end_str = *)
  (* let b = allocate_n float ~count:4 in *)
  (* let h_advancment = _text_bounds vg x y str end_str b in *)
  (* let xmin = !@b in *)
  (* let ymin = !@(b +@ 1) in *)
  (* let xmax = !@(b +@ 2) in *)
  (* let ymax = !@(b +@ 3) in *)
  (* ((xmin, ymin, xmax, ymax), h_advancment) *)

let create_font =
  foreign "nvgCreateFont" (context @-> string @-> string @-> returning int)

let save =
  foreign "nvgSave" (context @-> returning void)

let restore =
  foreign "nvgRestore" (context @-> returning void)

let reset =
  foreign "nvgReset" (context @-> returning void)

(* Starts new sub-path with specified point as first point. *)
(* void nvgMoveTo(NVGcontext* ctx, float x, float y); *)
let move_to =
  foreign "nvgMoveTo" (context @-> float @-> float @-> returning void)

(* Adds line segment from the last point in the path to the specified point. *)
(* void nvgLineTo(NVGcontext* ctx, float x, float y); *)
let line_to =
  foreign "nvgLineTo" (context @-> float @-> float @-> returning void)

(* Adds cubic bezier segment from last point in the path via two control points to the specified point. *)
(* void nvgBezierTo(NVGcontext* ctx, float c1x, float c1y, float c2x, float c2y, float x, float y); *)
let bezier_to =
  foreign "nvgBezierTo" (context @-> float @-> float @-> float @-> float @-> float @-> float
                                 @-> returning void)

(* Adds quadratic bezier segment from last point in the path via a control point to the specified point. *)
(* void nvgQuadTo(NVGcontext* ctx, float cx, float cy, float x, float y); *)
let quad_to =
  foreign "nvgQuadTo" (context @-> float @-> float @-> float @-> float @-> returning void)

(* Adds an arc segment at the corner defined by the last path point, and two specified points. *)
(* void nvgArcTo(NVGcontext* ctx, float x1, float y1, float x2, float y2, float radius); *)
let arc_to =
  foreign "nvgArcTo" (context @-> float @-> float @-> float @-> float @-> float @-> returning void)

(* Closes current sub-path with a line segment. *)
(* void nvgClosePath(NVGcontext* ctx); *)
let close_path =
  foreign "nvgClosePath" (context @-> returning void)

(* Sets current stroke style to a solid color. *)
(* void nvgStrokeColor(NVGcontext* ctx, NVGcolor color); *)
let stroke_color =
  foreign "nvgStrokeColor" (context @-> color @-> returning void)

(* Sets the stroke width of the stroke style. *)
(* void nvgStrokeWidth(NVGcontext* ctx, float size); *)
let stroke_width =
  foreign "nvgStrokeWidth" (context @-> float @-> returning void)

(* Fills the current path with current stroke style. *)
(* void nvgStroke(NVGcontext* ctx); *)
let stroke =
  foreign "nvgStroke" (context @-> returning void)


