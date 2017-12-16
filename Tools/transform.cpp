#include<iomanip>
#include<algorithm>
#include<cstring>
#include<iostream>
#include<cstdio>
#include<cstdlib>
using namespace std;

typedef long long ll;

const ll ANDI_OP = 12;
const ll ORI_OP = 13;
const ll XORI_OP = 14;
const ll LUI_OP = 15;
const ll SPECIAL_OP = 0;

const ll AND_OP = 36;
const ll OR_OP = 37;
const ll XOR_OP = 38;

inline ll tfm_and(ll inst)
{
	ll rs1 = (inst>>21)&((1<<5)-1),rs2 = (inst>>16)&((1<<5)-1),rt = (inst>>11)&((1<<5)-1),ret = 0;
	ret += (rs2<<20); ret += (rs1<<15); ret += (rt<<7); ret += (7<<12); ret += 51;
	return ret;
}

inline ll tfm_or(ll inst)
{
	ll rs1 = (inst>>21)&((1<<5)-1),rs2 = (inst>>16)&((1<<5)-1),rt = (inst>>11)&((1<<5)-1),ret = 0;
	ret += (rs2<<20); ret += (rs1<<15); ret += (rt<<7); ret += (6<<12); ret += 51;
	return ret;
}

inline ll tfm_xor(ll inst)
{
	ll rs1 = (inst>>21)&((1<<5)-1),rs2 = (inst>>16)&((1<<5)-1),rt = (inst>>11)&((1<<5)-1),ret = 0;
	ret += (rs2<<20); ret += (rs1<<15); ret += (rt<<7); ret += (4<<12); ret += 51;
	return ret;
}

inline ll tfm_andi(ll inst)
{
	ll rs = (inst>>21)&((1<<5)-1),rt = (inst>>16)&((1<<5)-1);
	ll imm = (inst&((1<<12)-1)),ret = imm<<20;
	ret += (rs<<15); ret += (7<<12); ret += (rt<<7); ret += 19;
	return ret;
}

inline ll tfm_ori(ll inst)
{
	ll rs = (inst>>21)&((1<<5)-1),rt = (inst>>16)&((1<<5)-1);
	ll imm = (inst&((1<<12)-1)),ret = imm<<20;
	ret += (rs<<15); ret += (6<<12); ret += (rt<<7); ret += 19;
	return ret;
}

inline ll tfm_xori(ll inst)
{
	ll rs = (inst>>21)&((1<<5)-1),rt = (inst>>16)&((1<<5)-1);
	ll imm = (inst&((1<<12)-1)),ret = imm<<20;
	ret += (rs<<15); ret += (4<<12); ret += (rt<<7); ret += 19;
	return ret;
}

inline ll tfm_lui(ll inst)
{
	ll rt = (inst>>16)&((1<<5)-1),imm = inst&((1<<16)-1),ret = 0;
	ret += imm<<12; ret += rt<<7; ret += 55;
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
		ll res;
		switch (inst>>26)
		{

		case SPECIAL_OP:
			switch (inst&((1<<6)-1))
			{
			case AND_OP: tfm_and(inst); break;
			case OR_OP: tfm_or(inst); break;
			case XOR_OP: tfm_xor(inst); break;
			default: res = 0;
			}
			break;
			
		case ANDI_OP: res = tfm_andi(inst); break;
		case ORI_OP: res = tfm_ori(inst); break;
		case XORI_OP: res = tfm_xori(inst); break;
		case LUI_OP: res = tfm_lui(inst); break;

		default: res = 0;
		}
		cout.width(8); cout.fill('0');
		cout << hex << res << endl;
	}
	return 0;
}
