#include <stdio.h>
#include <stdlib.h>
#include <GLFW/glfw3.h>

static void error_callback (int error, const char* description)
{
  fputs (description, stderr);
}

static void key_callback (GLFWwindow* window, int key, int scancode, int action, int mods)
{
  if (key == GLFW_KEY_ESCAPE && action == GLFW_PRESS)
    glfwSetWindowShouldClose (window, GL_TRUE);
}

static void framebuffer_size_callback (GLFWwindow* window, int width, int height)
{
  glViewport (0, 0, width, height);
}

static void render (double time, GLFWwindow* window)
{
  int width, height;
  float ratio;

  glfwGetFramebufferSize (window, &width, &height);
  ratio = (float) width / height;

  glClear (GL_COLOR_BUFFER_BIT);

  glMatrixMode (GL_PROJECTION);
  glLoadIdentity ();
  glOrtho (-ratio, ratio, -1.0, 1.0, 1.0, -1.0);

  glMatrixMode (GL_MODELVIEW);
  glLoadIdentity ();
  glRotatef (time * 50.0, 0, 1, 0);

  glBegin(GL_TRIANGLES);
  glColor3f(1.f, 0.f, 0.f);
  glVertex3f(-0.6f, -0.4f, 0.f);
  glColor3f(0.f, 1.f, 0.f);
  glVertex3f(0.6f, -0.4f, 0.f);
  glColor3f(0.f, 0.f, 1.f);
  glVertex3f(0.f, 0.6f, 0.f);
  glEnd();
}

int main()
{
  if (!glfwInit ())
    exit (EXIT_FAILURE);

  glfwSetErrorCallback (error_callback);

  GLFWwindow* window = glfwCreateWindow (640, 480, "Main Window", NULL, NULL);
  if (!window)
  {
    glfwTerminate ();
    exit (EXIT_FAILURE);
  }

  glfwMakeContextCurrent (window);
  glfwSetKeyCallback (window, key_callback);
  glfwSetFramebufferSizeCallback (window, framebuffer_size_callback);

  while (!glfwWindowShouldClose (window))
  {
    render (glfwGetTime (), window);
    glfwSwapBuffers (window);
    glfwPollEvents();
  }

  glfwTerminate ();
  return 0;
}
