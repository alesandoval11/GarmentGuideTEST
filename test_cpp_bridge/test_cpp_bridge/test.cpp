#include "test.h"
#include "pythonheaders/Python.h"

A::A(int _i) : m_Int(_i) {}
int A::getInt() { 
	PyObject *pName, *pModule, *pFunc;
    PyObject *pArgs, *pValue;
    int i;

    Py_Initialize();
    //PyRun_SimpleString("import sys");
    //PyRun_SimpleString("sys.path.append(\".\")");
    pName = PyUnicode_FromString("helloworld");
    /* Error checking of pName left out */

    pModule = PyImport_Import(pName);
    Py_DECREF(pName);

    if (pModule != NULL) {
        pFunc = PyObject_GetAttrString(pModule, "multiply");
        /* pFunc is a new reference */

        if (pFunc && PyCallable_Check(pFunc)) {
            pArgs = PyTuple_New(2); // argc - 3
            for (i = 1; i < 3; ++i) { // argc - 3
                pValue = PyLong_FromLong(i*5);
                if (!pValue) {
                    Py_DECREF(pArgs);
                    Py_DECREF(pModule);
                    fprintf(stderr, "Cannot convert argument\n");
                    return 1;
                }
                /* pValue reference stolen here: */
                PyTuple_SetItem(pArgs, i, pValue);
            }
            pValue = PyObject_CallObject(pFunc, pArgs);
            Py_DECREF(pArgs);
            if (pValue != NULL) {
                printf("Result of call: %ld\n", PyLong_AS_LONG(pValue));
                Py_DECREF(pValue);
            }
            else {
                Py_DECREF(pFunc);
                Py_DECREF(pModule);
                PyErr_Print();
                fprintf(stderr,"Call failed\n");
                return 1;
            }
        }
        else {
            if (PyErr_Occurred())
                PyErr_Print();
            fprintf(stderr, "Cannot find function \"%s\"\n", "multiply");
        }
        Py_XDECREF(pFunc);
        Py_DECREF(pModule);
    }
    else {
        PyErr_Print();
        fprintf(stderr, "Failed to load \"%s\"\n", "helloworld");
        return 1;
    }
    Py_Finalize();
    return 0;
	return m_Int; 

}
