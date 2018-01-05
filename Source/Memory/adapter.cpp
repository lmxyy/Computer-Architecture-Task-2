#include"env_iface.hpp"
#include"adapter.hpp"
#include<vector>

void Adapter::onRecv(std::uint8_t data)
{
	// TODO: Do something when you receive a byte from your CPU
	//
	// You can access the memory like this:
	//    env->ReadMemory(address)
	//    env->WriteMemory(address, data, mask)
	// where
	//   <address>: the address you want to read from / write to, must be aligned to 4 bytes
	//   <data>:    the data you want to write to the <address>
	//   <mask>:    (in range [0x0-0xf]) the bit <i> indicates that you want to write byte <i> of <data> to address <address>+i
	//              for example, if you want to write 0x2017 to address 0x1002, you can write
	//              env.WriteMemory(0x1000, 0x20170000, 0b1100)
	// NOTICE that the memory is little-endian
	//
	// You can also send data to your CPU by using:
	//    env->UARTSend(data)
	// where <data> can be a string or vector of bytes (uint8_t)

	static int cnt = 0,mask = 0; 
	static addr_t addr = 0; static data_t datum;
	static bool read_or_write = false; // false-read,true-write

	++cnt;
	
	switch (cnt)
	{
	
	case 1:
		addr = 0;
		read_or_write = ((data>>7)&1);
		for (int i = 6;i >= 0;--i)
			addr = addr<<1|((data>>i)&1);
		break;

	case 2:
		for (int i = 7;i >= 0;--i)
			addr = addr<<1|((data>>i)&1);
		break;

	case 3:
		for (int i = 7;i >= 0;--i)
			addr = addr<<1|((data>>i)&1);
		break;
		
	case 4:
		for (int i = 7;i >= 0;--i)
			addr = addr<<1|((data>>i)&1);
		break;

	case 5:
		addr = addr<<1|((data>>7)&1);
		if (read_or_write == false) // read
		{
			addr = (addr>>2)<<2;
			datum = env->ReadMemory(addr);
			std::vector <std::uint8_t> vec;
			for (int i = 0;i < 4;++i)
				vec.push_back(datum&((1<<8)-1)),datum >>= 8;
			env->UARTSend(vec);
			cnt = 0;
		}
		else
		{
			mask = 0;
			for (int i = 6;i > 2;--i)
				mask = mask<<1|((data>>i)&1);
			datum = 0;
			for (int i = 2;i >= 0;--i)
				datum = datum<<1|((data>>i)&1);
		}
		break;

	case 6:
		for (int i = 7;i > 2;--i)
			datum = datum<<1|((data>>i)&1);
		env->WriteMemory(addr,datum,mask);
		cnt = 0; break;
	}
}
