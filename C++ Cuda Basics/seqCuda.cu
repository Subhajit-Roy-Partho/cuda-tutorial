#include <iostream>
#include <thrust/reduce.h> // Thrust is an advance api.
#include <thrust/sequence.h>
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>

using namespace std;

int main(){
    const int N=5e4;
    thrust::device_vector<int> a(N); //array created
    thrust::sequence(a.begin(),a.end(),0);
    
}