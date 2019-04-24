#include<iostream>
#include <unistd.h>
#include <stdio.h>
#include <sys/socket.h>
#include <stdlib.h>
#include <netinet/in.h>
#include <string.h>
#include <arpa/inet.h>
#include <sstream>
#include <iomanip>

#include <sys/types.h>
#define PORT 80

class server
{
public:
  server();
  void checkHostName(int);
  void checkHostEntry(struct hostent*);
  void checkIPbuffer(char*);
  int determineProx(int);
  std::string packageCreator(int, int);
  int runServer();
private:

};
