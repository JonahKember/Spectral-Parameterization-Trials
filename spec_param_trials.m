function fit = spec_param_trials(xs,params)
%% Short time Fourier transforms

window_length = round(params.window_length * params.samp_rate);
freqs = (params.samp_rate / 2) * linspace(0,1,(window_length / 2) + 1);

time_steps = window_length - (window_length*(params.window_overlap/100));
time_windows = window_length:time_steps:(n_samples - window_length);

% Run stft for each trial, track in the variable *stft_tensor* [Channel x Time-window x Frequency x Trial].
n_channels = size(xs,1);
n_windows = length(time_windows);
n_freqs = length(freqs);
n_trials = size(xs,3);

stft_tensor = zeros(n_channels,n_windows,n_freqs,n_trials);

for trial = 1:n_trials
    [stft, time_windows] = sprint_stft(xs(:,:,trial),params);
    stft_tensor(:,:,:,trial) = stft;
end

% Average across trials.
stft_tensor = mean(stft_tensor,4);

%% Spectral parameterization (FOOOF).

addpath(params.fooof_path)
params.verbose = 0;

fit = [];

fits_channel = cell(1,n_windows);
for window = 1:n_windows
    fits_channel{window} = fooof(freqs, squeeze(stft_tensor(1,window,:)), [freqs(1),freqs(end)], params,1);
end

% Pull dynamic changes in the fit power spectrums (aperiodic/periodic components, error, r-squared).
fit.time = time_windows';
fit.frequencies = fits_channel{1}.freqs;
fit.ap_exp = zeros(n_channels,n_windows);
fit.ap_off = zeros(n_channels,n_windows);
fit.per = zeros(n_channels,length(fits_channel{window}.fooofed_spectrum),n_windows);
fit.error = zeros(n_channels,n_windows);
fit.r_squared = zeros(n_channels,n_windows);

for channel = 1:n_channels
    fits_channel = cell(1,n_windows);
    
    for window = 1:n_windows
        fits_channel{window} = fooof(freqs, squeeze(stft_tensor(channel,window,:)), [freqs(1),freqs(end)], params,1);
    end
    
    for window = 1:n_windows
        fit.ap_off(channel,window) = fits_channel{window}.aperiodic_params(1);
        fit.ap_exp(channel,window) = fits_channel{window}.aperiodic_params(2);
        fit.per(channel,:,window) = fits_channel{window}.fooofed_spectrum;
        fit.error(channel,window) = fits_channel{window}.error;
        fit.r_squared(channel,window) = fits_channel{window}.r_squared;    
    end
end