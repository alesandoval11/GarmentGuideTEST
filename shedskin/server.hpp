#ifndef __SERVER_HPP
#define __SERVER_HPP

using namespace __shedskin__;
namespace __server__ {

extern str *const_0, *const_1, *const_2, *const_3, *const_4;



extern tuple2<str *, __ss_int> *address;
extern str *__name__;
extern __socket__::socket *clientsocket;


void *sendMsg(str *message);
str *recvMsg();
tuple2<__socket__::socket *, tuple2<str *, __ss_int> *> *createSocket();
void *__ss_main();

} // module namespace
#endif
