#include <iostream>
using namespace std;

__global__ void add(int a, int b, int *c){
    *c = a + b;
};

int main(void){
    int c;
    int *c2;
    cudaMalloc((void**)&c2,sizeof(int));
    add<<<1,1>>>(2,7,c2);
    cudaMemcpy(&c,c2,sizeof(int),cudaMemcpyDeviceToHost);
    cout<< "2+7 =" << c <<endl;
    cudaFree(c2);

    return 0;
}