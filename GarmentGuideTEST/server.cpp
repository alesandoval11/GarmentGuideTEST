#include "server.h"

using namespace std;
int initial_distance = 0;
bool initial = false;
int ratios = 0;

server::server(){
    server_fd = 0;
    new_socket = 0;
}
void server::setInitial(){
    initial = false;
}
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

int server::determineProx(int heuristic_distance){

    if(!initial){
        initial_distance = heuristic_distance;
        ratios = initial_distance/5;
        initial = true;
        return 0;
    }
    else{
        if(heuristic_distance>initial_distance){
            return 0;
        }
        else{
            int closeness = initial_distance - heuristic_distance;
            int prox = closeness/ratios;
            return prox;
        }
        
    }
}

string server::packageCreator(double angle, int prox){
    
    ostringstream oss;
    oss << std::setfill('0') << std::setw(3) << (int)angle;
    string angle_post =  oss.str();
    string proximity = to_string(prox);
    string message = angle_post + proximity;
    //cout << "message: " << message << endl;
    return message;
    
}

int server::establishConnection()
{
    // start of create connection
    cout << "starting" << endl;
    const int opt = 1;
    int addrlen = sizeof(address);
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
    cout << "before new socket" << endl;
   if ((new_socket = accept(server_fd, (struct sockaddr *)&address,
                      (socklen_t*)&addrlen))<0)
   {
            cout << "Accept failed" << endl;
   }
    cout << "in establish connection" << new_socket << endl;
    // end createConnection

    return new_socket;
}

int server::sendPackage(int proximity, double angle, int socket){
    // start of send
    string packet = packageCreator(angle, determineProx(proximity));
    //cout << packet <<endl;
    char packetCharArr[packet.size() + 1];
    strcpy(packetCharArr, packet.c_str());
    cout << "Packet contents: " << packet.c_str() << endl;
    //valread = read( new_socket , buffer, 1024);
    //printf("%s\n",buffer )
    int count = 0;
    while(count < 1){
        sleep(1);
        //cout << "hello" << endl;
        int ret = send(socket, packet.c_str() , strlen(packetCharArr), 0);
        if(ret < 1){
            cout << errno << endl;
        }
        //cout << "socket value: " << new_socket << endl;
        count++;
    }
    // end send
    //send(new_socket , packetCharArr , strlen(packetCharArr) , 0 );
    //  printf("Hello message sent\n");

    return 0;
}
int server::closeConnection(int socket){
    cout << "Closing connection..."<< endl;
    int ret = shutdown(socket, SHUT_RDWR);
    if(ret < 0) cout << errno << endl;
    return 0;
}
