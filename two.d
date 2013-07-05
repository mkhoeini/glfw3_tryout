
import derelict.opengl3.gl;
import glfw3;
import std.exception;

void render(double time, GLFWwindow *window)
{
  int width, height;
  float ratio;

  glfwGetWindowSize(window, &width, &height);
  ratio = cast(float) width / height;

  glClear(GL_COLOR_BUFFER_BIT);

  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  glOrtho(-ratio, ratio, -1.0, 1.0, 1.0, -1.0);

  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();
  glRotatef(time * 50.0, 0, 1, 0);

  glBegin(GL_TRIANGLES);
  glColor3f(1.0, 0.0, 0.0);
  glVertex3f(-0.6f, -0.4f, 0.0);
  glColor3f(0.0, 1.0, 0.0);
  glVertex3f(0.6f, -0.4f, 0.0);
  glColor3f(0.0, 0.0, 1.0);
  glVertex3f(0.0, 0.6f, 0.0);
  glEnd();
}

void main()
{
  DerelictGL.load();
  enforce(glfwInit);
  scope(exit) glfwTerminate;

  glfwSetErrorCallback((e, d){
        import std.stdio;
        stderr.writefln("E(%d): %s", e, d);
      });

  GLFWwindow *window = glfwCreateWindow(640, 480, "Main Window", null, null);
  enforce(window);

  glfwMakeContextCurrent(window);

  glfwSetKeyCallback(window, (window, key, code, action, mods){
        if (key == GLFW_KEY_ESCAPE && action == GLFW_PRESS)
          glfwSetWindowShouldClose(window, GL_TRUE);
      });

  glfwSetWindowSizeCallback(window, (window, width, height){
        glViewport(0, 0, width, height);
      });

  while (!glfwWindowShouldClose(window))
  {
    render(glfwGetTime(), window);
    glfwSwapBuffers(window);
    glfwPollEvents();
  }
}
