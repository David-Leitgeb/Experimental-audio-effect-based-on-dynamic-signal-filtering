# Experimental audio effect based on dynamic signal filtering
Author: Bc. David Leitgeb

Contact: xleitg03@vutbr.cz

This repository contains supplementary material for the STUDENT EEICT 2024 paper: Experimental audio effect based on dynamic signal filtering

## Audio effect plug-in
This is the graphical interface of the audio effect plug-in developed in Matlab and its Audio Toolbox extension.
![Graphical interface of the audio effect plug-in](/graphic_examples/fig_gui.png)


## Graphic and audio examples
This section includes all of the examples prepared to showcase the functionality of the individual features of the audio effect plug-in. Most of them have both graphic and audio file form linked here, some are only in the form of audio files. Each example has description of the parameter settings used during its preparation.
### Frequency filters
Following examples showcase the seven implemented types of frequency filters. The input signal that was used for all the filter examples was [white noise](/audio_examples/aud_input_white_noise.wav).

![Frequency filter controls](/graphic_examples/fig_gui_filters.png)
- available parameters:
  - f<sub>C</sub> – cutoff frequency
  - Q – filter Q
  - f<sub>G</sub> – filter gain
  - filter order
#### Highpass
- parameters:
  - f<sub>C</sub> = 1 kHz
  - Q = 0,71
  - filter order = 2
- files:
  - [Frequency spectrum](/graphic_examples/frequency_filters/fig_results_HP.pdf)
  - [Audio file](/audio_examples/frequency_filters/aud_results_filter_HP.wav)
#### Low-shelving
- parameters:
  - f<sub>C</sub> = 1 kHz
  - Q = 0,71
  - f<sub>G</sub> = -15 dB
- files:
  - [Frequency spectrum](/graphic_examples/frequency_filters/fig_results_LS.pdf)
  - [Audio file](/audio_examples/frequency_filters/aud_results_filter_LS.wav)
#### Bandpass
- parameters:
  - f<sub>C</sub> = 1 kHz
  - Q = 10
- files:
  - [Frequency spectrum](/graphic_examples/frequency_filters/fig_results_BP.pdf)
  - [Audio file](/audio_examples/frequency_filters/aud_results_filter_BP.wav)
#### Bandreject
- parameters:
  - f<sub>C</sub> = 1 kHz
  - Q = 0,5
- files:
  - [Frequency spectrum](/graphic_examples/frequency_filters/fig_results_BR.pdf)
  - [Audio file](/audio_examples/frequency_filters/aud_results_filter_BR.wav)
#### Peak
- parameters:
  - f<sub>C</sub> = 1 kHz
  - Q = 18
  - f<sub>G</sub> = 15 dB
- files:
  - [Frequency spectrum](/graphic_examples/frequency_filters/fig_results_P.pdf)
  - [Audio file](/audio_examples/frequency_filters/aud_results_filter_P.wav)
#### High-shelving
- parameters:
  - f<sub>C</sub> = 1 kHz
  - Q = 0,71
  - f<sub>G</sub> = -15 dB
- files:
  - [Frequency spectrum](/graphic_examples/frequency_filters/fig_results_HS.pdf)
  - [Audio file](/audio_examples/frequency_filters/aud_results_filter_HS.wav)
#### Lowpass
- parameters:
  - f<sub>C</sub> = 1 kHz
  - filter order = 1
- files:
  - [Frequency spectrum](/graphic_examples/frequency_filters/fig_results_LP.pdf)
  - [Audio file](/audio_examples/frequency_filters/aud_results_filter_LP.wav)
### Delay line
![Delay line controls](/graphic_examples/fig_gui_delay_line.png)

- available parameters:
  - delay time
  - a<sub>FB</sub> – feedback
  - a<sub>FF</sub> – feedforward
#### Vibrato
input signal: [sine wave (1 kHz)](/audio_examples/aud_input_sine_1kHz.wav)
- parameters:
  - a<sub>FF</sub> and a<sub>FB</sub> = 0 %
  - modulation range = 3 ms
  - rate = 1/4 note
- files:
  - [Spectrogram](/graphic_examples/delay_line/fig_results_vibrato.pdf)
  - [Audio file](/audio_examples/delay_line/aud_results_vibrato.wav)
#### Comb filter
- parameters:
  - a<sub>FF</sub> = 100 %
  - a<sub>FB</sub> = 0 %
  - delay = 1 ms
- files:
  - input signal: [white noise](/audio_examples/aud_input_white_noise.wav)
  - [Frequency spectrum](/graphic_examples/delay_line/fig_results_comb_filter.pdf)
  - [Audio file](/audio_examples/delay_line/aud_results_comb_filter.wav)
#### Signal interpolation
- files:
  - input signal: [sine wave (1 kHz)](/audio_examples/aud_input_sine_1kHz.wav)
  - [Oscilloscope (no interpolation)](/graphic_examples/delay_line/fig_results_no_interpolation.pdf)
  - [Frequency spectrum (no interpolation)](/graphic_examples/delay_line/fig_results_no_interpolation_spectrum.pdf)
  - [Audio file (no interpolation)](/audio_examples/delay_line/aud_results_no_interpolation.wav)
  - [Oscilloscope (linear interpolation)](/graphic_examples/delay_line/fig_results_linear_interpolation.pdf)
  - [Frequency spectrum (linear interpolation)](/graphic_examples/delay_line/fig_results_linear_interpolation_spectrum.pdf)
  - [Audio file (linear interpolation)](/audio_examples//delay_line/aud_results_linear_interpolation.wav)
  
Following examples are audio only:
#### Chorus
- parameters:
  - a<sub>FF</sub> = 100 %
  - a<sub>FB</sub> = 0 %
  - modulation range = 10 ms
  - rate = 0,25 Hz
- files:
  - input signal: [guitar recording](/audio_examples/aud_input_guitar.wav)
  - [Audio file](/audio_examples//delay_line/aud_results_chorus.wav)
#### Flanger
- parameters:
  - a<sub>FF</sub> = 100 %
  - a<sub>FB</sub> = 95 %
  - modulation range = 1,5 ms
  - rate = 0,25 Hz
- files:
  - input signal: [guitar recording](/audio_examples/aud_input_guitar.wav)
  - [Audio file](/audio_examples//delay_line/aud_results_flanger.wav)

### Low-frequency oscillators
![LFO controls](/graphic_examples/fig_gui_lfo.png)
![LFO modulation controls](/graphic_examples/fig_gui_lfo_modulation.png)

- available parameters:
  - LFO shape
  - rate (Hz/note length)
  - time mode switch (Hz/sync)
  - depth
  - modulation depth

Tempo used for all of the following examples was 140 BPM.
#### Auto-Wah
- parameters:
  - modulated parameter: f<sub>C</sub>
  - f<sub>C</sub> = 3 kHz
  - modulation range = 1 kHz
  - rate = 1/4 note
- files:
  - input signal: [white noise](/audio_examples/aud_input_white_noise.wav)
  - [Spectrogram](/graphic_examples/low_frequency_oscillators/fig_results_auto_wah.pdf)
  - [Audio file](/audio_examples/low_frequency_oscillators/aud_results_lfo_auto_wah.wav)

#### Auto-Pan
- parameters:
  - modulated parameter: panorama
  - Pan(LFO1) = 100 %
  - rate = 1/4 note
- files:
  - input signal: [sine wave (55 Hz)](/audio_examples/aud_input_sine_55Hz.wav)
  - [Spectrogram](/graphic_examples/low_frequency_oscillators/fig_results_auto_pan.pdf)
  - [Audio file](/audio_examples/low_frequency_oscillators/aud_results_lfo_auto_pan.wav)
  
#### Triangle wave
- parameters:
  - modulated parameter: f<sub>C</sub>
  - f<sub>C</sub> = 3 kHz
  - modulation range = 1 kHz
  - rate = 1/8 note
- files:
  - input signal: [white noise](/audio_examples/aud_input_white_noise.wav)
  - [Spectrogram](/graphic_examples/low_frequency_oscillators/fig_results_lfo_triangle_wave.pdf)
  - [Audio file](/audio_examples/low_frequency_oscillators/aud_results_lfo_triangle_wave.wav)

#### Square wave
- parameters:
  - modulated parameter: f<sub>C</sub>
  - f<sub>C</sub> = 3 kHz
  - modulation range = 1 kHz
  - rate = 1/8 note
- files:
  - input signal: [white noise](/audio_examples/aud_input_white_noise.wav)
  - [Spectrogram](/graphic_examples/low_frequency_oscillators/fig_results_lfo_square_wave.pdf)
  - [Audio file](/audio_examples/low_frequency_oscillators/aud_results_lfo_square_wave.wav)
  
#### Saw wave
- parameters:
  - modulated parameter: f<sub>C</sub>
  - f<sub>C</sub> = 3 kHz
  - modulation range = 1 kHz
  - rate = 1/8 note
- files:
  - input signal: [white noise](/audio_examples/aud_input_white_noise.wav)
  - [Spectrogram](/graphic_examples/low_frequency_oscillators/fig_results_lfo_saw_wave.pdf)
  - [Audio file](/audio_examples/low_frequency_oscillators/aud_results_lfo_saw_wave.wav)
  
#### Sample&Hold
- parameters:
  - modulated parameter: f<sub>C</sub>
  - f<sub>C</sub> = 3 kHz
  - modulation range = 1 kHz
  - rate = 1/8 note
- files:
  - input signal: [white noise](/audio_examples/aud_input_white_noise.wav)
  - [Spectrogram](/graphic_examples/low_frequency_oscillators/fig_results_lfo_s&h.pdf)
  - [Audio file](/audio_examples/low_frequency_oscillators/aud_results_lfo_s&h_wave.wav)
    
### Musical signals
This section includes three more audio examples performed on musical signals (vocal, synth, percussion). All of the used input signals are from the Core Library included with Ableton Live.

#### Vocal
parameters:
![Vocal effect settings](/graphic_examples/fig_results_vocal_effect.png)
- files:
  - [Input signal](/audio_examples/aud_input_vocal.wav)
  - [Output signal](/audio_examples/aud_results_vocal_effect.wav)
    
#### Synth plucks and pad
parameters:
![Pluck and pad effect settings](/graphic_examples/fig_results_pluck_pad_effect.png)
- files:
  - [Input signal](/audio_examples/aud_input_pluck_pad.wav)
  - [Output signal](/audio_examples/aud_results_pluck_pad_effect.wav)
    
#### Percussion
parameters:
![Percussion effect settings](/graphic_examples/fig_results_percussion_effect.png)
- files:
  - [Input signal](/audio_examples/aud_input_percussion.wav)
  - [Output signal](/audio_examples/aud_results_percussion_effect.wav)
    
## Source code
Developed using:
- Matlab (version R2023b)
- Audio Toolbox extension (version 23.2)

In order to test the audio effect plug-in in Matlab, open [MultiBandModulator.m](/source_code/MultiBandModulator.m) and use the following command:
`audioTestBench(MultiBandModulator)`

[VST3 version](/source_code/MultiBandModulator.vst3) is also available in the folder containing the source code.

Note: comments in the source code are in Czech.
