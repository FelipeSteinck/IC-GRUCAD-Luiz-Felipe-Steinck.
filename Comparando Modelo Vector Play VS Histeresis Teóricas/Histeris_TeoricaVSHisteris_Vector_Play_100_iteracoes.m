% Par�metros principais
%N�mero de itera��es aumentado: Agora o c�digo executa 100 itera��es, e suavizar as varia��es e melhorar a precis�o da m�dia.
resistencia = 0.1;  % For�a de pinning
n_points = 100;  % Quantidade de pontos
campo_min = -1;  % Valor m�nimo do campo aplicado
campo_max = 1;   % Valor m�ximo do campo aplicado
n_iteracoes = 100;  % Aumentar o n�mero de itera��es para melhorar a precis�o

% Gerar os valores do campo aplicado
campo = linspace(campo_min, campo_max, n_points);

% Modelo te�rico de histerese
mag_teorica = tanh(5 * campo);  % Curva te�rica de histerese

% Inicializa a soma das curvas do Vector Play Model
soma_curvas = zeros(size(campo));

% Itera��es para melhorar a m�dia
for iter = 1:n_iteracoes
    % Inicializa o campo revers�vel para a itera��o
    campo_rev = zeros(size(campo));
    ultimo_rev = 0;  % Valor inicial
    
    % Ajuste no campo aplicado com pequenas varia��es suaves
    for j = 1:length(campo)
        delta_campo = campo(j) - ultimo_rev;
        
        % Varia��o agora proporcional ao campo aplicado para mais suavidade
        variacao = randn() * 0.05 * abs(campo(j));
        
        if abs(delta_campo) <= (resistencia + variacao)
            campo_rev(j) = ultimo_rev;
        else
            campo_rev(j) = campo(j) - (resistencia + variacao) * delta_campo / abs(delta_campo);
        end
        
        % Atualizar o valor anterior
        ultimo_rev = campo_rev(j);
    end
    
    % Somar as curvas de cada itera��o
    soma_curvas = soma_curvas + campo_rev;
end

% M�dia final
media_vector_play = soma_curvas / n_iteracoes;

% Plotando as curvas para compara��o
figure;
plot(campo, mag_teorica, 'r--', 'LineWidth', 2);  % Modelo Te�rico
hold on;
plot(campo, media_vector_play, 'b-', 'LineWidth', 2);  % M�dia Vector Play
xlabel('Campo Aplicado h');
ylabel('Magnetiza��o / Campo Revers�vel');
legend('Modelo Te�rico', 'M�dia Vector Play');
title('Aproxima��o do Vector Play Model ao Modelo Te�rico');
grid on;
