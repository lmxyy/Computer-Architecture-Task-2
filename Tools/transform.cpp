#include<iomanip>
#include<algorithm>
#include<cstring>
#include<iostream>
#include<cstdio>
#include<cstdlib>
using namespace std;

typedef long long ll;
const ll ORI_OP = 13;

inline ll tfm_ori(ll inst)
{
	ll rs = (inst>>21)&((1<<5)-1),rt = (inst>>16)&((1<<5)-1);
	ll imm = (inst&((1<<12)-1)),ret = imm<<20;
	ret += (rs<<15); ret += (6<<12); ret += (rt<<7); ret += 19;
	return ret;
}

int main()
{
	freopen("mips.in","r",stdin);
	freopen("riscv.in","w",stdout);
	ll inst;
	while (cin >> hex >> inst)
	{
		cerr << inst << endl;
		ll res = 0;
		switch (inst>>26)
		{
		case ORI_OP: res = tfm_ori(inst); break;
		}
		cout.width(8); cout.fill('0');
		cout << hex << res << endl;
	}
	return 0;
}
