class server
{
public:
  server();
  void checkHostName(int);
  void checkHostEntry(struct hostent*);
  void checkIPbuffer(char*);
  int runServer();
private:

};
