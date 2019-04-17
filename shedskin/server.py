import socket
import time
 

def sendMsg(message):
    print("Sending Message: ")
    clientsocket.send(str(message))

def recvMsg():
    print("Receiving Message: ")
    input = clientsocket.recv(1024)
    input = input.decode('utf-8')
    return input

def createSocket():
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.bind((socket.gethostname(), 80))
    s.listen(5)

    #print current IP address
    print(socket.gethostbyname(socket.gethostname()))
    print(socket.gethostname())
    return s.accept()
    
def main():          
    global clientsocket
    global address
    clientsocket, address = createSocket()
    while clientsocket:
        time.sleep(1)
        sendMsg("hello")
        receive = recvMsg()
        if len(receive) != 0:
            print(receive)
            sendMsg("Confirmed")
            print("confirmation send")
        
        #clientsocket.close()





    # if len(inpt) != 0:
    #     print("Message Received:", inpt)
    #     print("Sending Confirmation")
    #     clientsocket.sendall(str("Confirmation"))
    #     num += 1
    #     time.sleep(1)

main()