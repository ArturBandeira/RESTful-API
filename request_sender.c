#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>         
#include <netdb.h>          
#include <netinet/in.h>     
#include <sys/socket.h>     
#include <arpa/inet.h>      
#include <openssl/evp.h>    

char *base64_encode(const char *input) {
    size_t in_len = strlen(input);
    size_t out_len = 4 * ((in_len + 2) / 3);
    unsigned char *out = malloc(out_len + 1);
    if (!out) return NULL;
    int written = EVP_EncodeBlock(out, (const unsigned char*)input, in_len);
    out[written] = '\0';
    return (char*)out;
}

int send_request(const char *host, const char *port,
                 const char *path, const char *user, const char *pass) {
    char credentials[256];
    snprintf(credentials, sizeof(credentials), "%s:%s", user, pass);

    char *token = base64_encode(credentials);
    if (!token) {
        fprintf(stderr, "Erro ao codificar credenciais\n");
        return -1;
    }

    char request[1024];
    int req_len = snprintf(request, sizeof(request),
        "GET %s HTTP/1.1\r\n"
        "Host: %s:%s\r\n"
        "Authorization: Basic %s\r\n"
        "Connection: close\r\n"
        "\r\n",
        path, host, port, token);
    free(token);

    struct hostent *server = gethostbyname(host);
    if (!server) {
        perror("gethostbyname");
        return -1;
    }

    int sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0) {
        perror("socket");
        return -1;
    }

    struct sockaddr_in serv_addr;
    memset(&serv_addr, 0, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    memcpy(&serv_addr.sin_addr.s_addr, server->h_addr, server->h_length);
    serv_addr.sin_port = htons(atoi(port));

    if (connect(sockfd, (struct sockaddr*)&serv_addr, sizeof(serv_addr)) < 0) {
        perror("connect");
        close(sockfd);
        return -1;
    }
    if (send(sockfd, request, req_len, 0) < 0) {
        perror("send");
        close(sockfd);
        return -1;
    }
    char buffer[4096];
    int bytes;
    while ((bytes = recv(sockfd, buffer, sizeof(buffer)-1, 0)) > 0) {
        buffer[bytes] = '\0';
        printf("%s", buffer);
    }
    if (bytes < 0) perror("recv");

    close(sockfd);
    return 0;
}
int main() {
    const char *host = "ip aqui"; //////////
    const char *port = "5000";
    const char *path = "/read/ler_clientes";
    const char *user = "admin";
    const char *pass = "senha_teste";

    while (1) {
        printf("=== Enviando requisição em %ld ===\n", time(NULL));
        if (send_request(host, port, path, user, pass) < 0) {
            fprintf(stderr, "Falha ao enviar requisição\n");
        }
        sleep(300);
    }

    return 0;
}
