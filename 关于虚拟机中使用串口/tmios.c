#include <stdio.h>
#include <termios.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

int CFSetupSerial(int fd, int nSpeed, unsigned char nData, char nParity, unsigned char nStop)
{
    struct termios newtio, oldtio;
    
    if(tcgetattr(fd, &oldtio)!=0) {
        printf("tcgetattr() failed:%s\n", strerror(errno));
        return -1;
    }
    bzero(&newtio,sizeof(newtio));
    newtio.c_cflag |= CLOCAL | CREAD;
    newtio.c_cflag &= ~CSIZE;
    
    switch(nData) {
        case 7: newtio.c_cflag |= CS7;
                break;
        case 8: newtio.c_cflag |= CS8;
                break;
    }
    
    switch(nParity) {
        case 'o':
        case 'O':
            newtio.c_cflag |= PARENB;
            newtio.c_cflag |= PARODD;
            newtio.c_iflag |= (INPCK | ISTRIP);
            break;
		case 'e':           
        case 'E':
            newtio.c_iflag |= (INPCK | ISTRIP);
            newtio.c_cflag |= PARENB;
            newtio.c_cflag &= ~PARODD;
            break;
        case 'n':           
        case 'N': 
            newtio.c_cflag &= ~PARENB;
            break;
    }
    
    switch (nSpeed) {
        case 9600:
            cfsetispeed(&newtio,B9600);
            cfsetospeed(&newtio,B9600);
            break;
        case 19200:
			cfsetispeed(&newtio, B19200);
			cfsetospeed(&newtio, B19200);
			break;
    	case 38400:
			cfsetispeed(&newtio, B38400);
			cfsetospeed(&newtio, B38400);
			break;			
        case 57600: 
            cfsetispeed(&newtio,B57600);
            cfsetospeed(&newtio,B57600);
            break;
        case 115200:    
            cfsetispeed(&newtio,B115200);
            cfsetospeed(&newtio,B115200);
            break;
        default:
            break;
    }
    
    
    if (nStop == 1) {
        newtio.c_cflag &= ~CSTOPB;
    } else if (nStop == 2) {
        newtio.c_cflag |= CSTOPB;
    }
  
    newtio.c_cc[VTIME] = 0;
    newtio.c_cc[VMIN] = 1;
      
    tcflush(fd, TCIFLUSH);
    if ((tcsetattr(fd,TCSANOW,&newtio)) != 0) {
        printf("COM set error:%s\n", strerror(errno));
        return -1;
    }
    return 0;
}

/*
    "ttyDev": "/dev/ttyS1",
    "ttyRate": 115200,
    "ttyData": 8,
    "ttyParity": "N",
    "ttyStopBits": 1
*/
int main(int argc, char *argv[])
{
    int fd, readn;
    char buf[1024];
    
    if ((fd = open("/dev/ttyS1", O_RDWR|O_NOCTTY)) < 0) {
        perror("open()");
        return -1;
    }
    
    if (CFSetupSerial(fd, 115200, 8, 'N', 1) < 0) {
        perror("CFSetupSerial()");
        return -1;
    }
    
    while ((readn = read(fd, buf, sizeof(buf))) < 0) {
        if (readn == EAGAIN || errno == EINTR) {
            continue;
        }
        break;
    }
    
    //do with buf...
}
