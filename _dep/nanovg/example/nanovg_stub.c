
#include <unistd.h>

#include <stdio.h>
#ifdef NANOVG_GLEW
#	include <GL/glew.h>
#endif

#ifdef __APPLE__
#	define GLFW_INCLUDE_GLCOREARB
#endif

#include <GLFW/glfw3.h>
#include "nanovg.h"
/* #define NANOVG_GL3_IMPLEMENTATION */
#include "nanovg_gl.h"

void hello_nanovg() {
    puts("hello_nanovg");
}

