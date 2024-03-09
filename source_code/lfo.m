function [lfoSignal, lfoPhase, noiseIndex, noiseValue] = lfo(Fs, Param)
% Funkce generující signál nízkofrekvenčího oscilátoru
% Vstupem této funkce je vzorkovací kmitočet a struktura obsahující
% parametry daného nízkofrekvenčního oscilátoru.
% Výstupem je čtveřice parametrů:
%   1) výstupní signál LFO,
%   2) fáze signálu LFO, která je jedním z parametrů na vstupu (udržení
%      spojitosti signálu,
%   3) noiseIndex a 4) noiseValue souvisí s průběhem S&H a také slouží
%      k udržení spojitosti tohoto typu signálu.

% Semestrální práce
% Bc. David Leitgeb
% zimní semestr 2023/2024

    % Alokace matice výsledného signálu
    lfoSignal = zeros(Param.bufferLength, 1);
    % Proměnné ze struktury jsou uloženy do lokálních proměnných, jelikož
    % bude jejich hodnota dále upravována.
    lfoPhase = Param.phase;
    noiseIndex = Param.noiseIndex;
    noiseValue = Param.noiseValue;

    for n=1:Param.bufferLength
        % Podle typu synchronizace je určena hodnota kmitočtu.
        switch Param.rateType
            case {'Hz'}
                f = Param.fHz;
            case {'Sync'}
                % Výpočet kmitočtu podle délky zvolené noty a nastaveného
                % BPM
                switch Param.fSync
                    case {'1'}
                        f = 1 / (4 * (60 / Param.BPM) * 1);
                    case {'1/2'}
                        f = 1 / (4 * (60 / Param.BPM) * 1/2);
                    case {'1/4'}
                        f = 1 / (4 * (60 / Param.BPM) * 1/4);
                    case {'1/8'}
                        f = 1 / (4 * (60 / Param.BPM) * 1/8);
                    case {'1/16'}
                        f = 1 / (4 * (60 / Param.BPM) * 1/16);
                    case {'1/32'}
                        f = 1 / (4 * (60 / Param.BPM) * 1/32);
                    otherwise
                        f = 0;
                 end
            otherwise
                f = 0;
        end

        % Výpočet výsledného signálu podle zvoleného průběhu.
        switch Param.shape
            case {'SIN'}
                lfoSignal(n) = (Param.depth / 100) * sin(2 * pi * lfoPhase);
            case {'TRI'}
                lfoSignal(n) = (Param.depth / 100) * sawtooth(2 * pi * lfoPhase, 1/2);
            case {'SQR'}
                lfoSignal(n) = (Param.depth / 100) * square(2 * pi * lfoPhase);
            case {'SAW'}
                lfoSignal(n) = (Param.depth / 100) * sawtooth(2 * pi * lfoPhase);
            case {'S&H'}
                % Výpočet počtu vzorků, po který má být držena stejná
                % hodnota signálu.
                holdTime = round(Fs/f);
                % Na konci daného časového intervalu dojde k vygenerování
                % nové náhodné hodnoty v rozsahu od -1 do 1.
                if mod(noiseIndex, holdTime) == 0
                    noiseValue = ((-1) + (1 - (-1)) * rand);
                    noiseIndex = noiseIndex + 1;
                else
                    noiseIndex = noiseIndex + 1;
                end
                lfoSignal(n) = (Param.depth / 100) * noiseValue;
            otherwise
                lfoSignal = zeros(Param.bufferLength, 1);
        end
        % Aktualizace údaje o fázi oscilátoru, tento parametr využívají
        % všechny oscilátory kromě S&H, proto je její výpočet až zde na
        % konci.
        lfoPhase = lfoPhase + f * (1 / Fs);
        if lfoPhase >= 1
            lfoPhase = lfoPhase - 1;
        end
    end
end