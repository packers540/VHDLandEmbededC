void put_serial(volatile int*, int);

int main(void)
{
    //Address of serial controller on DE2-115
	volatile int* SERIAL_PORT_prt = (int*)0x10001010;

	int data,i;

	while(1)
	{
		data = *(SERIAL_PORT_prt);
		if(data&0x0008000)
		{
			data = data&0x000000FF;
			put_serial(SERIAL_PORT_prt, data&0xFF);
		}
	}
}

//Receiver integer value and send them to seven segment display
void put_serial(volatile int* SERIAL_PORT_prt, int c)
{
//Address of seven segment display on DE2-115
volatile int* Seg = (int*) 0x10000020;

//Set seven segment display led values based on received integer
switch(c){
	case 0: *(Seg) = 0x0000003F;
			break;
	case 1: *(Seg) = 0x00000006;
			break;
	case 2: *(Seg) = 0x0000005B;
			break;
	case 3: *(Seg) = 0x0000004F;
			break;
	case 4: *(Seg) = 0x00000066;
			break;
	case 5: *(Seg) = 0x0000006D;
			break;
	case 6: *(Seg) = 0x0000007D;
			break;
	case 7: *(Seg) = 0x00000007;
			break;
	case 8: *(Seg) = 0x0000007F;
			break;
	case 9: *(Seg) = 0x00000067;
			break;
    }
}
