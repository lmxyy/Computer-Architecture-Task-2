#include<cstring>
#include<iomanip>
#include<cstdio>
#include<cstdlib>
#include<algorithm>
#include<iostream>
#include<fstream>
using namespace std;

typedef long long ll;
const int NSIZE = 8;

inline ll convert(ll num)
{
	ll a[4] = {0,0,0,0},ret = 0;
	for (int i = 0;i < 4;++i,num >>= 8)
		a[i] = num&((1<<8)-1);
	for (int i = 0;i < 4;++i)
		ret = (ret<<8)|a[i];
	return ret;
}

int main(int argc,char *argv[])
{
    if (argc == 1||argc > 2)
    {
        cerr << "Please input an binary file." << endl;
        return 0;
    }
    ifstream ifile(argv[1],ios::in|ios::binary);
    if (!ifile)
    {
        cerr << "Cannot open file." << endl;
        return 0;
    }
    int head = ifile.tellg(),tail = (ifile.seekg(0,ios::end)).tellg();
    ifile.seekg(0,ios::beg);
    int N = (tail-head)/4;
    while (N--)
    {
        ll num = 0; int now = 0;
        for (int k = 0;k < 4;++k)
        {
            unsigned char c; ifile >> c;
            for (int i = 0;i < NSIZE;++i)
                num |= ((c&(1<<i))>0)<<(now++);
        }
        cout.width(8); cout.fill('0');
        cout << hex << convert(num) << endl;
    }
    return 0;
}
