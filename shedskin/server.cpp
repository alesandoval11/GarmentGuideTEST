#include "builtin.hpp"
#include "socket.hpp"
#include "time.hpp"
#include "server.hpp"

namespace __server__ {

str *const_0, *const_1, *const_2, *const_3, *const_4;


__socket__::socket *clientsocket;
tuple2<str *, __ss_int> *address;
str *__name__;



void *sendMsg(str *message) {
    
    print2(NULL,0,1, const_0);
    clientsocket->send(__str(message), 0);
    return NULL;
}

str *recvMsg() {
    str *input;

    print2(NULL,0,1, const_1);
    input = clientsocket->recv(1024, 0);
    //input = input->decode();
    return input;
}

tuple2<__socket__::socket *, tuple2<str *, __ss_int> *> *createSocket() {
    __socket__::socket *s;

    s = (new __socket__::socket(__socket__::__ss_AF_INET, __socket__::__ss_SOCK_STREAM, 0));
    s->bind((new tuple2<str *, __ss_int>(2,__socket__::gethostname(),80)));
    s->listen(5);
    print2(NULL,0,1, __socket__::gethostbyname(__socket__::gethostname()));
    print2(NULL,0,1, __socket__::gethostname());
    return s->accept();
}

void *__ss_main() {
    str *receive;
    tuple2<__socket__::socket *, tuple2<str *, __ss_int> *> *__0;

    __0 = createSocket();
    clientsocket = __0->__getfirst__();
    address = __0->__getsecond__();

    while (___bool(clientsocket)) {
        __time__::sleep(1);
        sendMsg(const_2);
        receive = recvMsg();
        if ((len(receive)!=0)) {
            print2(NULL,0,1, receive);
            sendMsg(const_3);
            print2(NULL,0,1, const_4);
        }
    }
    return NULL;
}

void __init() {
    const_0 = new str("Sending Message: ");
    const_1 = new str("Receiving Message: ");
    const_2 = new str("hello");
    const_3 = new str("Confirmed");
    const_4 = new str("confirmation send");

    __name__ = new str("__main__");

    __ss_main();
}

} // module namespace

int main(int, char **) {
    __shedskin__::__init();
    __socket__::__init();
    __time__::__init();
    __shedskin__::__start(__server__::__init);
}
