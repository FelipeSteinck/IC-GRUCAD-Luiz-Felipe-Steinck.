% Parâmetros principais
%Número de iterações aumentado: Agora o código executa 100 iterações, e suavizar as variações e melhorar a precisão da média.
resistencia = 0.1;  % Força de pinning
n_points = 100;  % Quantidade de pontos
campo_min = -1;  % Valor mínimo do campo aplicado
campo_max = 1;   % Valor máximo do campo aplicado
n_iteracoes = 100;  % Aumentar o número de iterações para melhorar a precisão

% Gerar os valores do campo aplicado
campo = linspace(campo_min, campo_max, n_points);

% Modelo teórico de histerese
mag_teorica = tanh(5 * campo);  % Curva teórica de histerese

% Inicializa a soma das curvas do Vector Play Model
soma_curvas = zeros(size(campo));

% Iterações para melhorar a média
for iter = 1:n_iteracoes
    % Inicializa o campo reversível para a iteração
    campo_rev = zeros(size(campo));
    ultimo_rev = 0;  % Valor inicial
    
    % Ajuste no campo aplicado com pequenas variações suaves
    for j = 1:length(campo)
        delta_campo = campo(j) - ultimo_rev;
        
        % Variação agora proporcional ao campo aplicado para mais suavidade
        variacao = randn() * 0.05 * abs(campo(j));
        
        if abs(delta_campo) <= (resistencia + variacao)
            campo_rev(j) = ultimo_rev;
        else
            campo_rev(j) = campo(j) - (resistencia + variacao) * delta_campo / abs(delta_campo);
        end
        
        % Atualizar o valor anterior
        ultimo_rev = campo_rev(j);
    end
    
    % Somar as curvas de cada iteração
    soma_curvas = soma_curvas + campo_rev;
end

% Média final
media_vector_play = soma_curvas / n_iteracoes;

% Plotando as curvas para comparação
figure;
plot(campo, mag_teorica, 'r--', 'LineWidth', 2);  % Modelo Teórico
hold on;
plot(campo, media_vector_play, 'b-', 'LineWidth', 2);  % Média Vector Play
xlabel('Campo Aplicado h');
ylabel('Magnetização / Campo Reversível');
legend('Modelo Teórico', 'Média Vector Play');
title('Aproximação do Vector Play Model ao Modelo Teórico');
grid on;
