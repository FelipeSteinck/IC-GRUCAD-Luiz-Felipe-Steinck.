#include "mex.h"
#include "read_table_mex.h"
#include <iostream>

void readTable(const mxArray *input, mxArray **output) {
    // obtem dimensoes da matriz de entrada
    size_t rows = mxGetM(input);
    size_t cols = mxGetN(input);
    
    // verifica se a matriz 3x3
    if (rows != 3 || cols != 3) {
        mexErrMsgIdAndTxt("MATLAB:readTable:invalidSize",
                          "A matriz de entrada deve ser 3x3.");
    }

    //  ponteiro para os dados da matriz de entrada
    double *inputData = mxGetPr(input);

    // exibe os valores da matriz
    std::cout << "Matriz 3x3 recebida:" << std::endl;
    for (size_t i = 0; i < rows; ++i) {
        for (size_t j = 0; j < cols; ++j) {
            std::cout << inputData[j * rows + i] << " ";  // MATLAB usa col-major order
        }
        std::cout << std::endl;
    }

    // cria uma matriz de saida e copia os dados
    *output = mxCreateDoubleMatrix(rows, cols, mxREAL);
    double *outputData = mxGetPr(*output);
    std::copy(inputData, inputData + (rows * cols), outputData);
}

// funcao principal MEX
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
    if (nrhs != 1) {
        mexErrMsgIdAndTxt("MATLAB:readTable:invalidNumInputs",
                          "A função requer exatamente 1 entrada.");
    }
    if (nlhs > 1) {
        mexErrMsgIdAndTxt("MATLAB:readTable:invalidNumOutputs",
                          "A função retorna apenas 1 saída.");
    }

    // Processa a entrada e gera a saida
    readTable(prhs[0], &plhs[0]);
}
