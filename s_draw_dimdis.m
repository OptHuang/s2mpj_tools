function s_draw_dimdis()
%S_DRAW_DIMDIST draw a hist picture about the distribution of dimension of S2MPJ

    maxdim = 50;
    numbs = zeros(1, maxdim);
    parfor dim = 1:maxdim
        list = s2mpj_select(struct('ptype', 'u', 'maxdim', dim, 'mindim', dim));
        numbs(dim) = length(list);
    end
    figure;
    bar(numbs);
    xlabel('Dimension');
    ylabel('Number of problems');
    title('Distribution of dimension of S2MPJ');
    grid on;
    axis([0 maxdim 0 50]);

end