#include "server.h"
#include<iostream>
#include <unistd.h>
#include <stdio.h>
#include <sys/socket.h>
#include <stdlib.h>
#include <netinet/in.h>
#include <string.h>
#include <arpa/inet.h>

#include <sys/types.h>
#define PORT 80

using namespace std;

server::server(){}

// Returns hostname for the local computer
void server::checkHostName(int hostname)
{
    if (hostname == -1)
    {
        perror("gethostname");
        exit(1);
    }
}

// Returns host information corresponding to host name
void server::checkHostEntry(struct hostent * hostentry)
{
    if (hostentry == NULL)
    {
        perror("gethostbyname");
        exit(1);
    }
}

// Converts space-delimited IPv4 addresses
// to dotted-decimal format
void server::checkIPbuffer(char *IPbuffer)
{
    if (NULL == IPbuffer)
    {
        perror("inet_ntoa");
        exit(1);
    }
}
int server::runServer()
{
    cout << "starting" << endl;
    int server_fd, new_socket, valread;
    struct sockaddr_in address;
    const int opt = 1;
    int addrlen = sizeof(address);
    char buffer[1024] = {0};
    char *hello = "Hello from server";
    cout << "Socket" << endl;

    int x = server_fd = socket(AF_INET, SOCK_STREAM, 0);
    if(x < 0)
    {
      cout << "Socket failed"<< endl;
    }

    if (setsockopt(server_fd, SOL_SOCKET,   SO_REUSEPORT ,
&opt, sizeof(int)))
    {
        cout << "Setsockopt PORT failed" << endl;
    }
    // Forcefully attaching socket to the port 80

    if (setsockopt(server_fd, SOL_SOCKET,   SO_REUSEADDR,
&opt, sizeof(int)))
    {
        cout << "Setsockopt ADDR failed" << endl;
    }

    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons( PORT );

    if( ::bind((int)server_fd, (struct sockaddr *)&address, sizeof(address))<0){
      cout << "Bind failed" << endl;

    }
    if (listen(server_fd, 5) < 0)
    {
        cout << "Listen failed" << endl;

    }
  /*if ((new_socket = accept(server_fd, (struct sockaddr *)&address,
                      (socklen_t*)&addrlen))<0)
   {
            cout << "Accept failed" << endl;
   }*/
   cout << "asdf" << endl;
    //valread = read( new_socket , buffer, 1024);
    //printf("%s\n",buffer );
    //send(new_socket , hello , strlen(hello) , 0 );
  //  printf("Hello message sent\n");


    return 0;
}
