#include "cuda_runtime.h"
#include "device_launch_parameters.h"

__global__ void addKernel(float *c, const float *a, const float *b)
{
    int i = threadIdx.x;
    c[i] = a[i] + b[i];
}

extern "C" void addWithCuda(float *c, const float *a, const float *b, int size)
{
    float *dev_a = 0;
    float *dev_b = 0;
    float *dev_c = 0;

    cudaMalloc((void**)&dev_a, size * sizeof(float));
    cudaMalloc((void**)&dev_b, size * sizeof(float));
    cudaMalloc((void**)&dev_c, size * sizeof(float));

    cudaMemcpy(dev_a, a, size * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(dev_b, b, size * sizeof(float), cudaMemcpyHostToDevice);

    addKernel<<<1, size>>>(dev_c, dev_a, dev_b);

    cudaMemcpy(c, dev_c, size * sizeof(float), cudaMemcpyDeviceToHost);

    cudaFree(dev_a);
    cudaFree(dev_b);
    cudaFree(dev_c);
}
