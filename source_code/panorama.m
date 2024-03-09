function out = panorama(In, Pan, ModBandParam, ModParam)
% Funkce upravující vyvážení levého a pravého kanálu
% Vstupem této funkce jsou následující parametry:
%   1) In – vstupní signál, jehož vyvážení má být upraveno,
%   2) Pan – hodnota potenciometru upravující vyvážení,
%   3) ModBandParam – struktura obsahující parametry modulace daného pásma,
%   4) ModParam – struktura obsahující společné parametry modulace všech
%      pásem.
% Výstupem je signál s upraveným vyvážením levého a pravého kanálu.

% Semestrální práce
% Bc. David Leitgeb
% zimní semestr 2023/2024

    % Maximální hloubka modulace vyvážení kanálů, v této verzi uživatel
    % nemůže tuto hodnotu měnit jednotně pro oba nízkofrekvenční
    % oscilátory, ponecháno pouze pro případnou reimplementaci.
    modRange = 50;

    for n=1:length(In)
        % Modulace parametru panoramy nastavené na potenciometru
        panValueModulated = Pan + (modRange * (ModBandParam.LFO1Pan / 100) * ModParam.LFO1Signal(n)) + (modRange * (ModBandParam.LFO2Pan / 100) * ModParam.LFO2Signal(n));
        % Ošetření případů, ve kterých by se hodnota dostala mimo rozsah
        if panValueModulated < -50
            panValueModulated = -50;
        elseif panValueModulated > 50
            panValueModulated = 50;
        end

        % Převod na rozsah od 0 do 1:
        panValueModulated = ((panValueModulated / 50) + 1) / 2;
        % Úprava vyvážení jednotlivých kanálů:
        % LEVÝ KANÁL
        In(n, 1) = In(n, 1) * (1 - panValueModulated);
        % PRAVÝ KANÁL
        In(n, 2) = In(n, 2) * panValueModulated;
    end

    out = In;
end