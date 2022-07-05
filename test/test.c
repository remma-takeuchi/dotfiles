#include<stdio.h>

void testfunc(){
  printf("Hello World, %s\n", __FUNCTION__);
}

int main(int argc, char **argv)
{
  printf("Hello World, %s\n", __FUNCTION__);
  testfunc();
  return 0;
}

