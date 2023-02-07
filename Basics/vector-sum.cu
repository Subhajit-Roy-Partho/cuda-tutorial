#include <iostream>
using namespace std;

#define N 1000

__global__ void add(int *a, int *b, int *c){
    int tid = blockIdx.x;
    if (tid<N)
        c[tid] = a[tid] + b[tid];
}

int main(void){
    int a[N],b[N],c[N];
    int *devA, *devB, *devC;

    cudaMalloc((void**)&devA,N*sizeof(int));
    cudaMalloc((void**)&devB,N*sizeof(int));
    cudaMalloc((void**)&devC,N*sizeof(int));

    for(int i=0;i<N;i++){
        a[i]=-i;
        b[i]=i*i;
    }

    cudaMemcpy(devA,a,N*sizeof(int),cudaMemcpyHostToDevice);
    cudaMemcpy(devB,b,N*sizeof(int),cudaMemcpyHostToDevice);

    add<<<N,1>>>(devA,devB,devC);

    cudaMemcpy(c,devC,N*sizeof(int),cudaMemcpyDeviceToHost);

    for(int i=0;i<N;i++) cout << a[i] << " + " << b[i] <<" = "<<c[i]<<endl;

    cudaFree(devA);
    cudaFree(devB);
    cudaFree(devC);

    return 0;
}