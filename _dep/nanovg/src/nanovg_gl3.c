
#ifdef NANOVG_GLEW
#	include <GL/glew.h>
#endif

#ifdef __APPLE__
#	define GLFW_INCLUDE_GLCOREARB
#endif

#include <GLFW/glfw3.h>
#include "nanovg.h"
#define NANOVG_GL3_IMPLEMENTATION
#include "nanovg_gl.h"

int main() {
  glfwInit();

  glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
  glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 2);
  glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
  glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);

  printf("%d %d\n", GLFW_CONTEXT_VERSION_MAJOR, 3);
  printf("%d %d\n", GLFW_CONTEXT_VERSION_MINOR, 2);
  printf("%d %d\n", GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
  printf("%d %d\n", GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);

  GLFWwindow *win = glfwCreateWindow(800,600,"GLFW OCaml Demo",NULL,NULL);
  glfwMakeContextCurrent(win);
  glfwSwapInterval(0);
  while (! glfwWindowShouldClose(win)) {
    glViewport(0,0,800,600);
    glClearColor(0.5,0.5,0.9,1.0);
    glClear(GL_COLOR_BUFFER_BIT);

	NVGcontext *ctx = nvgCreateGL3(0);
    nvgBeginFrame(ctx,800,600,1.0);

    glfwSwapBuffers(win);
    glfwPollEvents();
  }
}

