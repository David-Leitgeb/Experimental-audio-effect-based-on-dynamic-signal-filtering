function [out, FilterConditions] = freqFilter(In, Fs, Param, ModBandParam, ModParam)
% Funkce provádějící kmitočtovou filtraci signálu
% Vstupem této funkce jsou následující parametry:
%   1) In – vstupní signál, který má být filtrován,
%   2) Fs – vzorkovací kmitočet,
%   3) Param – parametry nastavené uživatelem v GUI,
%   4) ModBandParam – struktura obsahující parametry modulace daného pásma,
%   5) ModParam – struktura obsahující společné parametry modulace všech
%      pásem.
% Výstupem je filtrovaný signál a vnitřní stavy filtrů.

% Semestrální práce
% Bc. David Leitgeb
% zimní semestr 2023/2024

% Prvním krokem je předpočítání hodnot použitých dále ve funkci.
    sqrt2 = sqrt(2);
    K = zeros(length(In), 1);
    V0 = 10^(Param.FilterGain / 20);
    sqrt2V0 = sqrt(2 * V0);

    % Vzhledem ke zpracování signálu po jednotlivých vzorcích je zde
    % provedena alokace matic obsahujících mezní kmitočet filtru v daném
    % momentě a hodnotu výstupního signálu v každém kanálu.
    fcMod = zeros(length(In), 1);
    out = zeros(size(In));
    FilterConditions = Param.FilterConditions;

    for n=1:length(In)
        % Nejprve je vypočtena aktuální hodnota mezního kmitočtu filtru,
        % která zohledňuje modulaci pomocí LFO.
        fcMod(n, 1) = Param.FilterCutoff + (ModParam.CutoffRange * (ModBandParam.LFO1Cutoff / 100) * ModParam.LFO1Signal(n)) + (ModParam.CutoffRange * (ModBandParam.LFO2Cutoff / 100) * ModParam.LFO2Signal(n));
        % Ošetření rozsahu.
        if fcMod(n, 1) < 10
            fcMod(n, 1) = 10;
        elseif fcMod(n, 1) > 22000
            fcMod(n, 1) = 22000;
        end

        K(n, 1) = tan(pi * fcMod(n, 1) / Fs);
    end

    % Následuje výpočet koeficientů pro uživatelem zvolený typ filtru.
    % Vzhledem k modulaci mezního kmitočtu je filtrace prováděna po
    % jednotlivých vzorcích. Použité návrhové vzorce byly upraveny tak, aby
    % zbytečně nedocházelo k výpočtu stejných hodnot.
    switch Param.FilterType
        case {'HP'} % HIGH-PASS
            for n=1:length(In)
                K2 = K(n, 1) * K(n, 1);

                % V případě horní a dolní propusti je možné provést změnu
                % řádu filtru.
                if Param.FilterOrder == '1'
                    den = 1 / (K(n, 1) + 1);

                    b0 = 1 * den;
                    b1 = -1 * den;
                    b2 = 0;
                    a1 = (K(n, 1) - 1) * den;
                    a2 = 0;
                else
                    den = 1 / (K2 * Param.FilterQ + K(n, 1) + Param.FilterQ);

                    b0 = Param.FilterQ * den;
                    b1 = (-2 * Param.FilterQ) * den;
                    b2 = Param.FilterQ * den;
                    a1 = (2 * Param.FilterQ * (K2 - 1)) * den;
                    a2 = (K2 * Param.FilterQ - K(n, 1) + Param.FilterQ) * den;
                end

                % Vypočtené koeficienty jsou zde uloženy dohromady a poté
                % předány Matlab funkci filter.
                b = [b0 b1 b2];
                a = [1 a1 a2];

                % Jelikož je filtrace prováděna po jednotlivých vzorcích
                % a efekt zpracovává dva kanály, funkce filter je zde
                % volána dvakrát, vždy s jinými vnitřními stavy filtru pro
                % každý z kanálů.
                [out(n, 1), FilterConditions(:, 1)] = filter(b, a, In(n, 1), FilterConditions(:, 1));
                [out(n, 2), FilterConditions(:, 2)] = filter(b, a, In(n, 2), FilterConditions(:, 2));
            end
        case {'LS'} % LOW-SHELVING
            for n=1:length(In)
                K2 = K(n, 1) * K(n, 1);
                denBoost = 1 / (1 + sqrt2 * K(n, 1) + K2);
                denCut = 1 / (V0 + sqrt2V0 * K(n, 1) + K2);

                if Param.FilterGain >= 0
                	b0 = (1 + sqrt2V0 * K(n, 1) + V0 * K2) * denBoost;
                	b1 = (2 * (V0 * K2 - 1)) * denBoost;
                	b2 = (1 - sqrt2V0 * K(n, 1) + V0 * K2) * denBoost;
                	a1 = (2 * (K2 - 1)) * denBoost;
                	a2 = (1 - sqrt2 * K(n, 1) + K2) * denBoost;
                else
                	b0 = (V0 * (1 + sqrt2 * K(n, 1) + K2)) * denCut;
                	b1 = (2 * V0 * (K2 - 1)) * denCut;
                	b2 = (V0 * (1 - sqrt2 * K(n, 1) + K2)) * denCut;
                	a1 = (2 * (K2 - V0)) * denCut;
                	a2 = (V0 - sqrt2V0 * K(n, 1) + K2) * denCut;
                end

                b = [b0 b1 b2];
                a = [1 a1 a2];

                [out(n, 1), FilterConditions(:, 1)] = filter(b, a, In(n, 1), FilterConditions(:, 1));
                [out(n, 2), FilterConditions(:, 2)] = filter(b, a, In(n, 2), FilterConditions(:, 2));
            end
        case {'BP'} % BANDPASS
            for n=1:length(In)
                K2 = K(n, 1) * K(n, 1);
                den = 1 / (K2 * Param.FilterQ + K(n, 1) + Param.FilterQ);

                b0 = K(n, 1) * den;
                b1 = 0;
                b2 = -K(n, 1) * den;
                a1 = (2*Param.FilterQ*(K(n, 1)^2 - 1)) * den;
                a2 = (K(n, 1)^2*Param.FilterQ-K(n, 1)+Param.FilterQ) * den;

                b = [b0 b1 b2];
                a = [1 a1 a2];

                [out(n, 1), FilterConditions(:, 1)] = filter(b, a, In(n, 1), FilterConditions(:, 1));
                [out(n, 2), FilterConditions(:, 2)] = filter(b, a, In(n, 2), FilterConditions(:, 2));
            end
        case {'BR'} % BANDREJECT
            for n=1:length(In)
                K2 = K(n, 1) * K(n, 1);
                den = 1 / (K2 * Param.FilterQ + K(n, 1) + Param.FilterQ);

                b0 = (Param.FilterQ * (1 + K2)) * den;
                b1 = (2 * Param.FilterQ * (K2 - 1)) * den;
                b2 = (Param.FilterQ * (1 + K2)) * den;
                a1 = (2*Param.FilterQ*(K2 - 1)) * den;
                a2 = (K2 * Param.FilterQ - K(n, 1) + Param.FilterQ) * den;

                b = [b0 b1 b2];
                a = [1 a1 a2];

                [out(n, 1), FilterConditions(:, 1)] = filter(b, a, In(n, 1), FilterConditions(:, 1));
                [out(n, 2), FilterConditions(:, 2)] = filter(b, a, In(n, 2), FilterConditions(:, 2));
            end
        case {'P'} % PEAK
            for n=1:length(In)
                K2 = K(n, 1) * K(n, 1);
	            denBoost = 1 / ((1 + (1 / Param.FilterQ) * K(n, 1) + K2));
	            denCut = 1 / ((1 + (1 / (V0 * Param.FilterQ)) * K(n, 1) + K2));

                if Param.FilterGain >= 0
		            b0 = (1 + (V0 / Param.FilterQ) * K(n, 1) + K2) * denBoost;
		            b1 = (2 * (K2 - 1)) * denBoost;
		            b2 = (1 - (V0 / Param.FilterQ) * K(n, 1) + K2) * denBoost;
		            a1 = (2 * (K2 - 1)) * denBoost;
		            a2 = (1 - (1 / Param.FilterQ) * K(n, 1) + K2) * denBoost;
                else
		            b0 = (1 + (1 / Param.FilterQ) * K(n, 1) + K2) * denCut;
		            b1 = (2 * (K2 - 1)) * denCut;
		            b2 = (1 - (1 / Param.FilterQ) * K(n, 1) + K2) * denCut;
		            a1 = (2 * (K2 - 1)) * denCut;
		            a2 = (1 - (1 / (V0 * Param.FilterQ)) * K(n, 1) + K2) * denCut;
                end

                b = [b0 b1 b2];
                a = [1 a1 a2];

                [out(n, 1), FilterConditions(:, 1)] = filter(b, a, In(n, 1), FilterConditions(:, 1));
                [out(n, 2), FilterConditions(:, 2)] = filter(b, a, In(n, 2), FilterConditions(:, 2));
            end
        case {'HS'} % HIGH-SHELVING
            for n=1:length(In)
            K2 = K(n, 1) * K(n, 1);
            denBoost = 1 / (1 + sqrt2 * K(n, 1) + K2);
            denCut = 1 / (1 + sqrt2V0 * K(n, 1) + V0 * K2);

            if Param.FilterGain >= 0
		        b0 = (V0 + sqrt2V0 * K(n, 1) + K2) * denBoost;
		        b1 = (2 * (K2 - V0)) * denBoost;
		        b2 = (V0 - sqrt2V0 * K(n, 1) + K2) * denBoost;
		        a1 = (2 * (K2 - 1)) * denBoost;
		        a2 = (1 - sqrt2 * K(n, 1) + K2) * denBoost;
            else
		        b0 = (V0 * (1 + sqrt2 * K(n, 1) + K2)) * denCut;
		        b1 = (2 * V0 * (K2 - 1)) * denCut;
		        b2 = (V0 * (1 - sqrt2 * K(n, 1) + K2)) * denCut;
		        a1 = (2 * (V0 * K2 - 1)) * denCut;
		        a2 = (1 - sqrt2V0 * K(n, 1) + V0 * K2) * denCut;
            end

            b = [b0 b1 b2];
            a = [1 a1 a2];

            [out(n, 1), FilterConditions(:, 1)] = filter(b, a, In(n, 1), FilterConditions(:, 1));
            [out(n, 2), FilterConditions(:, 2)] = filter(b, a, In(n, 2), FilterConditions(:, 2));
            end
        case {'LP'} % LOW-PASS
            for n=1:length(In)
                K2 = K(n, 1) * K(n, 1);

                if Param.FilterOrder == '1'
                    den = 1 / (K(n, 1) + 1);

                    b0 = K(n, 1) * den;
                    b1 = K(n, 1) * den;
                    b2 = 0;
                    a1 = (K(n, 1) - 1) * den;
                    a2 = 0;
                else
                    den = 1 / (K2 * Param.FilterQ + K(n, 1) + Param.FilterQ);

                    b0 = (K2 * Param.FilterQ) * den;
                    b1 = (2 * K2 * Param.FilterQ) * den;
                    b2 = (K2 * Param.FilterQ) * den;
                    a1 = (2 * Param.FilterQ * (K2 - 1)) * den;
                    a2 = (K2 * Param.FilterQ - K(n, 1) + Param.FilterQ) * den;
                end

                b = [b0 b1 b2];
                a = [1 a1 a2];

                [out(n, 1), FilterConditions(:, 1)] = filter(b, a, In(n, 1), FilterConditions(:, 1));
                [out(n, 2), FilterConditions(:, 2)] = filter(b, a, In(n, 2), FilterConditions(:, 2));
            end
        case {'None'} % NONE
            out = In;
    end
end