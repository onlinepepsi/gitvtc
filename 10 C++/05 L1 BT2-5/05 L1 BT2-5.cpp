#include <iostream>
using namespace std;
int main()
{
	int total = 0;
	for (int i = 0; i < 101; i++) {
		if (i % 2 == 1)total += i;
	}
	cout << "Tong = " << total << endl;
	
}