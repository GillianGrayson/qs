clear all;
addpath('../routines/matlab')

N = 100;
alpha = 0.5;
n_seeds = 50;

lpn_type = -1;
lpn_log_deltas = [-6.0, -5.0, -4.0]';
Ts = [1, 2, 5]';

is_scaled = 1;

path = 'E:/YandexDisk/Work/os_lnd/draft/mbl/2/figures/lndham/lambda/100_100';

fig = figure;

for log_delta_id = 1:size(lpn_log_deltas, 1)
    fig = figure;
    
    if is_scaled == 1    
        x = [-5:.01:5];
        y = normpdf(x,0,1);
        h = plot(x, y, 'LineWidth', 5)
        legend(h, sprintf('Normal Distribution'));
        hold all;
    end
    
    for T_id = 1:size(Ts, 1)
        fn = sprintf('%s/lambda_N(%d)_numSeeds(%d)_alpha(%0.4f)_T(%0.4f)_lpn(%d_%0.4f).csv', ...
            path, ...
            N, ...
            n_seeds, ...
            alpha, ...
            Ts(T_id), ...
            lpn_type, ...
            lpn_log_deltas(log_delta_id));
        
        data = importdata(fn);
        lambdas = data(:);
        
        if is_scaled == 1
            mean_lambdas = mean(lambdas);
            std_lambdas = std(lambdas);
            lambdas = (lambdas - mean_lambdas) / std(lambdas);
        end
        
        pdf.x_num_bins = 50;
        pdf.x_label = '$\lambda$';
        if is_scaled == 1
            pdf.x_label = '$\bar{\lambda}$';
        end
        pdf.x_bin_s = min(lambdas);
        pdf.x_bin_f = max(lambdas);
        pdf = pdf_1d_setup(pdf);
        pdf = pdf_1d_update(pdf, lambdas);
        pdf = pdf_1d_release(pdf);
        h = plot(pdf.x_bin_centers, pdf.pdf, 'LineWidth', 2);
        legend(h, sprintf('$\\tau=%d$', Ts(T_id)))
        legend(gca,'off');
        legend('Interpreter', 'latex');
        set(gca, 'FontSize', 30);
        xlabel(pdf.x_label, 'Interpreter', 'latex');
        set(gca, 'FontSize', 30);
        ylabel('$PDF$', 'Interpreter', 'latex');
        hold all;
    end
    fn_fig = sprintf('%s/density_lambda_N(%d)_numSeeds(%d)_alpha(%0.4f)_lpn(%d_%0.4f)', ...
        path, ...
        N, ...
        n_seeds, ...
        alpha, ...
        lpn_type, ...
        lpn_log_deltas(log_delta_id));
    if is_scaled == 1
        fn_fig = sprintf('%s_scaled', fn_fig);
    end
    save_fig(fig, fn_fig);
end
