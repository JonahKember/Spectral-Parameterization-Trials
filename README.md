# Spectral-Parameterization-Trials
Function for estimating event-related changes in the aperiodic and periodic component of electrophysiological data.

This approach relies on two previously validated analyses, one for parameterizing the power spectrum of a stationary signal (__FOOOF__, developed by Donoghue et al., 2018), and one for parameterizing the power spectrum of a dynamic signal (__SPRiNT__, developed by Wilson et al., 2020). It integrates them and performs some  intermediate analyses steps so they can be applied to event-related data.

## Details
In short, this function:
1. Applies the Short-time Fourier transform portion of __SPRiNT__ to the time-series of each trial.
2. Averages each time-window across trials.
3. Fits the power spectrum of this trial-average using __FOOOF__.
4. Outputs dynamic changes in the spectrum parameters over time.

## Useage
__Input:__ [Channel x Sample x Trial]<br />
__Output:__ Structure containing event-related changes in the: <br />
- Aperiodic offset [Channel x Time-window]  <br />
- Aperiodic exponent [Channel x Time-window]  <br />
- Periodic component [Channel x Time-window x Frequency]

See __spec_param_trials_useage.m__ for an example. <br />
_Note:_ These approaches are typically implemented in different languages (__SPRiNT__ in matlab; __FOOOF__ in python). However, __FOOOF__ developers implemented a matlab wrapper, which is used here (https://github.com/fooof-tools/fooof_mat). 

## See also
__FOOOF__: https://github.com/fooof-tools/fooof   <br />
__SPRiNT__: https://github.com/lucwilson/SPRiNT
