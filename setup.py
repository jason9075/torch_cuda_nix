from setuptools import setup, Extension
import numpy

module = Extension(
    "mycuda",
    sources=["PyCudaBridge.cpp", "CUDAkernel.cu"],
    include_dirs=[numpy.get_include(), "/usr/local/cuda/include"],
    library_dirs=["/usr/local/cuda/lib64"],
    libraries=["cudart"],
    extra_compile_args=["-std=c++11"],
)

setup(
    name="mycuda",
    version="1.0",
    description="Python package with CUDA extension",
    ext_modules=[module],
)
