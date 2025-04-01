% Compila o codigo MEX
mex read_table_mex.cpp

% cria matriz 3x3 de teste
A = [1 2 3; 4 5 6; 7 8 9];

% chama a funcao MEX
B = read_table_mex(A);

% mostra a matriz retornada
disp("Matriz retornada:");
disp(B);
