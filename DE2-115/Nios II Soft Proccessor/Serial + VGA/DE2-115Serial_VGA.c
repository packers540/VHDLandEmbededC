void put_serial(unsigned char);
void adjustBrightness(unsigned char);
void adjustContrast(unsigned char);
void SendVGA(int, int, unsigned short);
unsigned short grey2RGB(unsigned char);

int main(void)
{
    //Address of serial controller on DE2-115
	volatile int* SERIAL_PORT_prt = (int*)0x10001010;

	unsigned int opcode, raw_serial_recv, z, x, y, count, pic_data_serial, slider_data_serial;
	unsigned char i, pic_data_serial_tst;
	signed char slider_data;
	unsigned short pic_data_RGB, test, original[239][320], overlay[239][320];

	count = 0;
	
	while(1)
	{	
		raw_serial_recv = *(SERIAL_PORT_prt);
		if(raw_serial_recv&0x0008000)
		{
			opcode = raw_serial_recv&0x000000FF;
			
			//Get Brightness Slider Value
			if ((char)opcode == 'a'){
				count = 0;
				while(count < 1){
					slider_data_serial = *(SERIAL_PORT_prt);
					if(slider_data_serial&0x0008000){
						slider_data = slider_data_serial&0xFF;
						adjustBrightness(slider_data);
						count = 1;
					}
				}
			}
			
			//Get Contrast Slider Value
			if ((char)opcode == 'f'){
				count = 0;
				while(count < 1){
					slider_data_serial = *(SERIAL_PORT_prt);
					if(slider_data_serial&0x0008000){
						slider_data = slider_data_serial&0xFF;
						adjustContrast(slider_data);
						count = 1;
					}
				}
			}
			
			//Load Test Image
			if ((char)opcode == 'b'){
				for (y = 0; y < 239; y++){
					for (x = 320; x > 0; x--)
					{
						count = 0;
						//Loop until an available pixel is in the serial buffer
						while(count < 1){
							pic_data_serial = *(SERIAL_PORT_prt);
							//If pixel available get serial data, convert to rgb, send to vga, store in array
							if(pic_data_serial&0x0008000){
								pic_data_serial_tst = pic_data_serial&0xFF;
								pic_data_RGB = grey2RGB(pic_data_serial_tst);
								SendVGA(x, y, pic_data_RGB);
								original[y][x] = pic_data_RGB;
								count = 1;
							}
						}
					}
				}
			}
			
			//Load Overlay  Image
			if ((char)opcode == 'c'){
				for (y = 0; y < 239; y++){
					for (x = 320; x > 0; x--)
					{
						count = 0;
						while(count < 1){
							pic_data_serial = *(SERIAL_PORT_prt);
							if(pic_data_serial&0x0008000){
								pic_data_serial_tst = pic_data_serial&0xFF;
								pic_data_RGB = grey2RGB(pic_data_serial_tst);
								SendVGA(x, y, pic_data_RGB);
								overlay[y][x] = pic_data_RGB;
								count = 1;
							}
						}		
					}
				}  
			}
			
			//Perform Overlay
			if ((char)opcode == 'o'){
				for (y = 0; y < 239; y++){
					for (x = 320; x > 0; x--)
					{	
						//If overlay image pixel is black overlay that pixel onto original 
						//at the same location
						if (overlay[y][x] == 0x0000){
							original[y][x] = 0x0000;
						}
						SendVGA(x, y, original[y][x]);
					}
				}	   
			}
		}			
	}
}

//Receiver integer value and send them to seven segment display
void put_serial(unsigned char c)
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

void SendVGA(int x, int y, unsigned short pixel_value)
{
	volatile short*pixel_buffer = (short*) 0x08000000;			//Pixel Buffer
	int offset;
	//location on screen is 18 bits with first 9 bits being for y and other 9 being for x
	offset = (y << 9) + x;
	*(pixel_buffer + offset) = pixel_value;

}

unsigned short grey2RGB(unsigned char greyScale)
{
	unsigned char temp_rb, temp_g;
	unsigned short RGB;
	
	//Converts greyscale to 5 bits for red and blue pixel values
	temp_rb = greyScale/8;
	
	//Converts greyscale to 6 bits for green pixel value
	temp_g = temp_rb * 2;
	
	//Concatinates red, green, and blue values
	RGB = (temp_rb << 11) + (temp_g << 5) + temp_rb;
	return RGB;
}

//Takes current screen and edits the brightness
void adjustBrightness(unsigned char value){
	volatile short*pixel_buffer = (short*) 0x08000000;			//Pixel Buffer
	int offset, x, y;
	unsigned short pixel_value;
	unsigned char greyscale_pixel;
	//location on screen is 18 bits with first 9 bits being for y and other 9 being for x
	
	for (y = 0; y < 239; y++){
		for (x = 320; x > 0; x--){
			offset = (y << 9) + x;
			
			//Get pixel
			pixel_value = *(pixel_buffer + offset);
			//Convert RGB to greyscale
			//Look at last 5 bits (blue value) and multiply by 8 to shift 3 bits
			//This makes it an 8 bit greyscale value with some data loss.
			//11111 becomes 11111000 if the conversion was perfect it would become 11111111.
			greyscale_pixel = (pixel_value&0x001F) * 8;
			
			//Limit greyscale value to max of 255
			if((greyscale_pixel * (value/127.0)) > 255)
				greyscale_pixel = 255;
			else
				greyscale_pixel = greyscale_pixel * (200.0/127.0);
			
			//Convert back to RGB
			pixel_value = grey2RGB(greyscale_pixel);
			
			//Output pixel
			*(pixel_buffer + offset) = pixel_value;
		}
	}
	
}

//Takes current screen and edits the contrast
void adjustContrast(unsigned char value){
	volatile short*pixel_buffer = (short*) 0x08000000;			//Pixel Buffer
	int i, x, y, offset, histogram [256], lookuptable[256];
	unsigned short pixel_value;
	unsigned char greyscale_pixel;
	 
	//initialize historgram with all zeros
    for (i = 0; i < 256; i++)
        histogram[i] = 0;

    //initialize lookup table with all zeros
    for (i = 0; i < 256; i++)
        lookuptable[i] = 0;
	
	//build histrogram from brightness adjusted image data
    for (y = 0; y < 239; y++){
		for (x = 320; x > 0; x--){
			offset = (y << 9) + x;
			
			//Get pixel
			pixel_value = *(pixel_buffer + offset);
			//Convert RGB to greyscale
			//Look at last 5 bits (blue value) and multiply by 8 to shift 3 bits
			//This makes it an 8 bit greyscale value with some data loss.
			//11111 becomes 11111000 if the conversion was perfect it would become 11111111.
			greyscale_pixel = (pixel_value&0x001F) * 8;
			
			//Create a histogram of speicfic pixel values 
			histogram[pixel_value] = histogram[pixel_value] + 1;
		}
	}
	
	//build lookup tabled from histogram data and skew data based on slider value
	for (i = 1; i < 256; i++)
        lookuptable[i] = ((lookuptable[i - 1] + histogram[i]) * (value/127.0));
	
	
	//Write adjust pixels to screen
	for (y = 0; y < 239; y++){
		for (x = 320; x > 0; x--){
			offset = (y << 9) + x;
			
			//Get pixel
			pixel_value = *(pixel_buffer + offset);
			//Convert RGB to greyscale
			//Look at last 5 bits (blue value) and multiply by 8 to shift 3 bits
			//This makes it an 8 bit greyscale value with some data loss.
			//11111 becomes 11111000 if the conversion was perfect it would become 11111111.
			greyscale_pixel = (pixel_value&0x001F) * 8;
			
			int temp = (lookuptable[pixel_value] *255) / (239*320);
			if (temp > 255)
				greyscale_pixel = 255;
			else if (temp < 1)
				greyscale_pixel = 0;
			else
				greyscale_pixel = temp;
			
			//Convert to RGB and write to screen
			*(pixel_buffer + offset) = grey2RGB(greyscale_pixel);
		}
	}
}
