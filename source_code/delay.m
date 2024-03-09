function [out, circularBuffer, dpw] = delay(In, Fs, Param, ModBandParam, ModParam)
% Funkce fungující jako efekt se zpožďovací linkou
% Vstupem této funkce jsou následující parametry:
%   1) In – vstupní signál, který má být zpracován,
%   2) Fs – vzorkovací kmitočet,
%   3) Param – parametry nastavené uživatelem v GUI,
%   4) ModBandParam – struktura obsahující parametry modulace daného pásma,
%   5) ModParam – struktura obsahující společné parametry modulace všech
%      pásem.
% Výstupem je zpracovaný signál, kruhový buffer daného pásma a index zápisu
% do kruhového bufferu.

% Semestrální práce
% Bc. David Leitgeb
% zimní semestr 2023/2024

    % Přepsání parametrů struktury do lokálních proměnných, se kterými je
    % dále pracováno:
    circularBuffer = Param.Buffer;
    dpw = Param.Dpw;
    % Nejprve je provedeno zjištění délky vstupní a kruhové vyrovnávací
    % paměti.
    inputBufferLength = length(In);
    circularBufferLength = length(circularBuffer);

    % Zpracování probíhá po vzorcích, proto alokace matice pro výstupní
    % signál.
    out = zeros(size(In));
    for n = 1:inputBufferLength

        % Modulace uživatelem nastaveného zpoždění pomocí LFO
        delayModulated = Param.Delay + (ModParam.DelayRange * (ModBandParam.LFO1Delay / 100) * ModParam.LFO1Signal(n)) + (ModParam.DelayRange * (ModBandParam.LFO2Delay / 100) *  ModParam.LFO2Signal(n));

        % Ošetření zpoždění menšího než 1 ms.
        if delayModulated < 1
            delayModulated = 1;
        end

        % DPR – výpočet pozice čtení z kruhového bufferu (vyrovnávací
        % paměti)
        dpr = mod(dpw - delayModulated * 10^(-3) * Fs + circularBufferLength - 3, circularBufferLength);

        % Lineární interpolace:
        fraction = dpr - floor(dpr);
        previousSample = floor(dpr);
        % Ošetření korektního indexu obou interpolovaných vzorků:
        if previousSample == 0
            previousSample = 1;
        end
        if previousSample + 1 > circularBufferLength
            nextSample = 1;
        else
            nextSample = previousSample + 1;
        end

        % Vyčtení zpožděného signálu z kruhového bufferu.
        delaySignal = fraction * circularBuffer(nextSample, :) + (1 - fraction) * circularBuffer(previousSample, :);

        % Smíchání větví podle schématu zapojení.
        out(n, :) = (Param.Feedforward / 100) * In(n, :) + delaySignal;
        feedbackSignal = In(n, :) + (Param.Feedback / 100) * delaySignal;

        % Zapsání signálu zpětné vazby zpět do kruhového bufferu.
        circularBuffer(dpw, :) = feedbackSignal;

        % Změna indexu zápisu do kruhového bufferu.
        dpw = dpw + 1;
        if dpw > circularBufferLength
            dpw = 1;
        end
    end
end