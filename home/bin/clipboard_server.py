#!/usr/bin/env python3

from socketserver import TCPServer, StreamRequestHandler, BaseRequestHandler
import socket
import logging
import pyperclip


class Handler(BaseRequestHandler):

    # https://stackoverflow.com/questions/17667903/python-socket-receive-large-amount-of-data
    def recvall(self, sock):
        BUFF_SIZE = 4096 # 4 KiB
        data = b''
        while True:
            part = sock.recv(BUFF_SIZE)
            data += part
            if len(part) < BUFF_SIZE:
                # either 0 or end of data
                break
        return data

    def handle(self):

        self.data = self.recvall(self.request)
        # logging.info("From <%s>: %s" % (self.client_address, self.data))
        logging.info("From <{}>: {}...".format(self.client_address, self.data[:20]))
        # self.request.sendall(self.data.upper())

        self.text = self.data.decode("utf-8")
        pyperclip.copy(self.text)

    '''
    def handle(self):

        self.data = self.request.recv(1024)
        logging.info("From <%s>: %s" % (self.client_address, self.data))
        # self.request.sendall(self.data.upper())

        self.text = self.data.decode("utf-8")
        pyperclip.copy(self.text)
    '''

# https://gist.github.com/kylemanna/d193aaa6b33a89f649524ad27ce47c4b
class Server(TCPServer):
    # The constant would be better initialized by a systemd module
    SYSTEMD_FIRST_SOCKET_FD = 3

    def __init__(self, server_address, handler_cls):
        # Invoke base but omit bind/listen steps (performed by systemd
        # activation!)
        TCPServer.__init__(
            self, server_address, handler_cls, bind_and_activate=False)
        # Override socket
        self.socket = socket.fromfd(
            self.SYSTEMD_FIRST_SOCKET_FD, self.address_family, self.socket_type
        )


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    HOST, PORT = "localhost", 9999  # not really needed here
    server = Server((HOST, PORT), Handler)
    server.serve_forever()
