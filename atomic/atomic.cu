#include <cuda.h>
#include <cuda_runtime.h>
#include <iostream>

// Simulate data on host (CPU)
float data_host[2][4] = { {5,5,5,5},
    {1.0f, 2.0f, 3.0f, 4.0f}};

__global__ void update_float4_atomic(float4* data, float4 value) {
  int idx = threadIdx.x + blockDim.x * blockIdx.x;

  if (idx < 2) { // Assuming the data array has size 4 (to match float4)
    atomicAdd(&data[idx].x, value.x);
    atomicAdd(&data[idx].y, value.y);
    atomicAdd(&data[idx].z, value.z);
    atomicAdd(&data[idx].w, value.w);
  }
}

int main() {
  // Allocate memory for data on device (GPU)
  float4* data_device;
  cudaMalloc(&data_device, 2*sizeof(float4));

  // Copy data from host to device
  cudaMemcpy(data_device, data_host, 2*sizeof(float4), cudaMemcpyHostToDevice);

  // Define update values
//   float4 update_value = make_float4(0.5f, 0.25f, 1.0f, 0.75f);
  float4 update_value;
    update_value.x = 0.5f;
    update_value.y = 0.25f;
    update_value.z = 1.0f;
    update_value.w = 0.75f;

  // Launch kernel for atomic update
  int threadsPerBlock = 256;
  update_float4_atomic<<<1, threadsPerBlock>>>(data_device, update_value);

  // Allocate memory for result on host
  float4* result_host = new float4[2];

  // Copy updated data back from device to host
  cudaMemcpy(result_host, data_device, 2*sizeof(float4), cudaMemcpyDeviceToHost);

  // Print the original data and the result (after atomic adds)
//   printf("Original data (host): (%.2f, %.2f, %.2f, %.2f)\n", data_host[0], data_host[1], data_host[2], data_host[3]);
    for(int i = 0; i < 2; i++){
        printf("Original data (host): (%.2f, %.2f, %.2f, %.2f)\n", data_host[i][0], data_host[i][1], data_host[i][2], data_host[i][3]);
    }
    for(int i = 0; i < 2; i++){
        printf("Updated data (host after atomic adds): (%.2f, %.2f, %.2f, %.2f)\n", result_host[i].x, result_host[i].y, result_host[i].z, result_host[i].w);
    }
//   printf("Updated data (host after atomic adds): (%.2f, %.2f, %.2f, %.2f)\n", result_host[0].x, result_host[0].y, result_host[0].z, result_host[0].w);

  // Free memory
  cudaFree(data_device);
  delete[] result_host;

  return 0;
}
