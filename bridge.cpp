#include <Python.h>
#include <arrayobject.h>
#include "CUDAkernel.cu"

static PyObject* Py_addWithCuda(PyObject* self, PyObject* args) {
    PyObject *a_obj, *b_obj;

    // 解析來自 Python 的參數
    if (!PyArg_ParseTuple(args, "OO", &a_obj, &b_obj))
        return NULL;

    // 轉換為 numpy arrays
    PyArrayObject *a_arr = (PyArrayObject*)PyArray_FROM_OTF(a_obj, NPY_INT, NPY_IN_ARRAY);
    PyArrayObject *b_arr = (PyArrayObject*)PyArray_FROM_OTF(b_obj, NPY_INT, NPY_IN_ARRAY);

    // 獲取數據指針
    int *a = (int*)PyArray_DATA(a_arr);
    int *b = (int*)PyArray_DATA(b_arr);

    int size = PyArray_SIZE(a_arr);
    int *c = (int*)malloc(size * sizeof(int));

    // 調用 CUDA 函數
    addWithCuda(c, a, b, size);

    // 轉換結果為 numpy array 以返回
    npy_intp dims[1] = {size};
    PyObject *c_arr = PyArray_SimpleNewFromData(1, dims, NPY_INT, c);
    PyArray_ENABLEFLAGS((PyArrayObject*)c_arr, NPY_ARRAY_OWNDATA);

    // 清理
    Py_DECREF(a_arr);
    Py_DECREF(b_arr);

    return c_arr;
}

static PyMethodDef MyMethods[] = {
    {"add_with_cuda", Py_addWithCuda, METH_VARARGS, "Add two arrays using CUDA"},
    {NULL, NULL, 0, NULL}
};

static struct PyModuleDef mymodule = {
    PyModuleDef_HEAD_INIT,
    "mycuda",
    NULL,
    -1,
    MyMethods
};

PyMODINIT_FUNC PyInit_mycuda(void) {
    import_array();
    return PyModule_Create(&mymodule);
}
