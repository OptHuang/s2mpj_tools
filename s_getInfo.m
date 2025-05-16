function s_getInfo()
%S_GETINFO Get information about all problems in the problem set "S2MPJ".

    % Set the timeout (seconds) for each problem to be loaded
    timeout = 50;

    % Add paths (the parent directory of the current directory)
    current_path = fileparts(mfilename('fullpath'));
    filename = [current_path, '/optiprofiler/problems/s2mpj/src/list_of_matlab_problems'];
    fid = fopen(filename, 'r');
    if fid == -1
        error('Cannot open file: %s', filename);
    end
    problem_names = textscan(fid, '%s');
    fclose(fid);
    problem_names = problem_names{1};

    % Exclude some problems
    problem_exclude = {'SPARCO10LS.m'; 'SPARCO10.m'; 'SPARCO11LS.m'; 'SPARCO11.m'; 'SPARCO12LS.m'; 'SPARCO12.m'; 'SPARCO2LS.m'; 'SPARCO2.m'; 'SPARCO3LS.m'; 'SPARCO3.m'; 'SPARCO5LS.m'; 'SPARCO5.m'; 'SPARCO7LS.m'; 'SPARCO7.m'; 'SPARCO8LS.m'; 'SPARCO8.m'; 'SPARCO9LS.m'; 'SPARCO9.m'; 'ROSSIMP3_mp.m'};
    problem_names = setdiff(problem_names, problem_exclude);

    % List all known feasibility problems
    known_feasibility = {...
        'AIRCRFTA', 'ARGAUSS', 'ARGLALE', 'ARGLBLE', 'ARGTRIG', 'ARTIF', 'BARDNE', 'BAmL1SP', 'BEALENE', 'BENNETT5', 'BIGGS6NE', 'BOOTH', 'BOXBOD', 'BRATU2D', 'BRATU2DT', 'BRATU3D', 'BROWNBSNE', 'BROWNDENE', 'BROYDN3D', 'CBRATU2D', 'CBRATU3D', 'CHANDHEQ', 'CHANDHEU', 'CHEMRCTA', 'CHWIRUT2', 'CLUSTER', 'COOLHANS', 'CUBENE', 'CYCLIC3', 'CYCLOOCF', 'CYCLOOCT', 'DANIWOOD', 'DANWOOD', 'DECONVBNE', 'DENSCHNBNE', 'DENSCHNDNE', 'DENSCHNFNE', 'DEVGLA1NE', 'DEVGLA2NE', 'DIAMON2D', 'DIAMON3D', 'DMN15102', 'DMN15103', 'DMN15332', 'DMN15333', 'DMN37142', 'DMN37143', 'DRCAVTY1', 'DRCAVTY2', 'DRCAVTY3', 'ECKERLE4', 'EGGCRATENE', 'EIGENA', 'EIGENB', 'ELATVIDUNE', 'ENGVAL2NE', 'ENSO', 'ERRINROSNE', 'ERRINRSMNE', 'EXP2NE', 'EXTROSNBNE', 'FLOSP2HH', 'FLOSP2HL', 'FLOSP2HM', 'FLOSP2TH', 'FLOSP2TL', 'FLOSP2TM', 'FREURONE', 'GENROSEBNE', 'GOTTFR', 'GROWTH', 'GULFNE', 'HAHN1', 'HATFLDANE', 'HATFLDBNE', 'HATFLDCNE', 'HATFLDDNE', 'HATFLDENE', 'HATFLDF', 'HATFLDFLNE', 'HATFLDG', 'HELIXNE', 'HIMMELBA', 'HIMMELBC', 'HIMMELBD', 'HIMMELBFNE', 'HS1NE', 'HS25NE', 'HS2NE', 'HYDCAR20', 'HYDCAR6', 'HYPCIR', 'INTEGREQ', 'INTEQNE', 'KOEBHELBNE', 'KOWOSBNE', 'KSS', 'LANCZOS1', 'LANCZOS2', 'LANCZOS3', 'LEVYMONE', 'LEVYMONE10', 'LEVYMONE5', 'LEVYMONE6', 'LEVYMONE7', 'LEVYMONE8', 'LEVYMONE9', 'LIARWHDNE', 'LINVERSENE', 'LSC1', 'LSC2', 'LUKSAN11', 'LUKSAN12', 'LUKSAN13', 'LUKSAN14', 'LUKSAN17', 'LUKSAN21', 'LUKSAN22', 'MANCINONE', 'METHANB8', 'METHANL8', 'MEYER3NE', 'MGH09', 'MGH10', 'MISRA1A', 'MISRA1B', 'MISRA1C', 'MISRA1D', 'MODBEALENE', 'MSQRTA', 'MSQRTB', 'MUONSINE', 'NELSON', 'NONSCOMPNE', 'NYSTROM5', 'OSBORNE1', 'OSBORNE2', 'OSCIGRNE', 'OSCIPANE', 'PALMER1ANE', 'PALMER1BNE', 'PALMER1ENE', 'PALMER1NE', 'PALMER2ANE', 'PALMER2BNE', 'PALMER2ENE', 'PALMER3ANE', 'PALMER3BNE', 'PALMER3ENE', 'PALMER4ANE', 'PALMER4BNE', 'PALMER4ENE', 'PALMER5ANE', 'PALMER5BNE', 'PALMER5ENE', 'PALMER6ANE', 'PALMER6ENE', 'PALMER7ANE', 'PALMER7ENE', 'PALMER8ANE', 'PALMER8ENE', 'PENLT1NE', 'PENLT2NE', 'POROUS1', 'POROUS2', 'POWELLBS', 'POWELLSQ', 'POWERSUMNE', 'PRICE3NE', 'PRICE4NE', 'QINGNE', 'QR3D', 'RAT42', 'RAT43', 'RECIPE', 'REPEAT', 'RES', 'ROSSIMP1NE', 'ROSZMAN1', 'RSNBRNE', 'SANTA', 'SEMICN2U', 'SEMICON1', 'SEMICON2', 'SPECANNE', 'SSBRYBNDNE', 'SSINE', 'THURBER', 'TQUARTICNE', 'VANDERM1', 'VANDERM2', 'VANDERM3', 'VANDERM4', 'VARDIMNE', 'VESUVIA', 'VESUVIO', 'VESUVIOU', 'VIBRBEAMNE', 'WATSONNE', 'WAYSEA1NE', 'WAYSEA2NE', 'YATP1CNE', 'YATP2CNE', 'YFITNE', 'ZANGWIL3', 'n10FOLDTR'...
    };

    % To store all the feasibility problems including the known ones and the new ones
    feasibility = {};

    % To store all the 'time out' problems
    timeout_problems = {};

    % Find problems that are parametric
    path_file = [current_path, '/list_of_parametric_problems_with_parameters.txt'];
    fid = fopen(path_file, 'r');
    if fid == -1
        error('Cannot open file: %s', path_file);
    end

    % Scan each line, each line only has one problem name, which ends before the first comma
    % Give the rest to problem_argins
    % In txt file, each line looks like:
    % ALJAZZAF,3,100,1000,10000
    % or
    % TRAINF,{1.5}{2}{11,51,101,01,501,1001,5001,10001}
    % ALJAZZAF and TRAINF are problem names
    % Then let argins be the rest after the problem name if the problem name is found
    para_problem_names = {};
    problem_argins = {};
    i_line = 1;
    % Read file line by line
    while true
        line = fgetl(fid);
        if line == -1  % End of file
            break;
        end
        
        comma_pos = strfind(line, ',');
        problem_name = line(1:comma_pos(1) - 1);  % Use first comma if multiple exist
        para_problem_names{i_line} = problem_name;
        problem_argins{i_line} = line(comma_pos(1) + 1:end);
        
        i_line = i_line + 1;
    end
    fclose(fid);

    % Saving path
    saving_path = current_path;

    % Initialize the structure to store data
    probinfo = cell(length(problem_names) + 1, 39);
    probinfo{1, 1} = 'name';
    probinfo{1, 2} = 'ptype';
    probinfo{1, 3} = 'xtype';
    probinfo{1, 4} = 'dim';
    probinfo{1, 5} = 'mb';
    probinfo{1, 6} = 'ml';
    probinfo{1, 7} = 'mu';
    probinfo{1, 8} = 'mcon';
    probinfo{1, 9} = 'mlcon';
    probinfo{1, 10} = 'mnlcon';
    probinfo{1, 11} = 'm_ub';
    probinfo{1, 12} = 'm_eq';
    probinfo{1, 13} = 'm_linear_ub';
    probinfo{1, 14} = 'm_linear_eq';
    probinfo{1, 15} = 'm_nonlinear_ub';
    probinfo{1, 16} = 'm_nonlinear_eq';
    probinfo{1, 17} = 'f0';
    probinfo{1, 18} = 'isfeasibility';
    probinfo{1, 19} = 'isgrad';
    probinfo{1, 20} = 'ishess';
    probinfo{1, 21} = 'isjcub';
    probinfo{1, 22} = 'isjceq';
    probinfo{1, 23} = 'ishcub';
    probinfo{1, 24} = 'ishceq';
    probinfo{1, 25} = 'argins';
    probinfo{1, 26} = 'dims';
    probinfo{1, 27} = 'mbs';
    probinfo{1, 28} = 'mls';
    probinfo{1, 29} = 'mus';
    probinfo{1, 30} = 'mcons';
    probinfo{1, 31} = 'mlcons';
    probinfo{1, 32} = 'mnlcons';
    probinfo{1, 33} = 'm_ubs';
    probinfo{1, 34} = 'm_eqs';
    probinfo{1, 35} = 'm_linear_ubs';
    probinfo{1, 36} = 'm_linear_eqs';
    probinfo{1, 37} = 'm_nonlinear_ubs';
    probinfo{1, 38} = 'm_nonlinear_eqs';
    probinfo{1, 39} = 'f0s';

    pool = gcp();

    % Record the log
    diary([saving_path, '/log.txt']);

    for i_problem = 2:length(problem_names) + 1

        tmp = cell(1, 39);

        problem_name = problem_names{i_problem - 1};
        problem_name = strrep(problem_name, '.m', '');  % Remove the .m extension
        

        % Try to load the problem and ignore all the errors and messages
        fprintf('\nLoading problem %i: %s\n', i_problem - 1, problem_name);

        try
            % Use parfeval to load the problem. If it takes too long, then cancel it
            f = parfeval(pool, @get_init_info, 1, problem_name, known_feasibility);
            [idx, info_init] = fetchNext(f, timeout);
            if isempty(idx)
                cancel(f);
                timeout_problems = [timeout_problems, problem_name];
                fprintf('Timeout loading problem %i: %s\n', i_problem - 1, problem_name);
                probinfo(i_problem, :) = [];
                continue
            end
            fprintf('Problem %s loaded successfully\n\n', problem_name);
        catch
            tmp{1} = [problem_name, ' (error loading)'];
            fprintf('Error loading problem %i: %s\n', i_problem - 1, problem_name);
            probinfo(i_problem, :) = tmp;
            continue
        end

        % Record the information
        tmp(1:24) = info_init;

        if info_init{18} == 1
            feasibility = [feasibility, problem_name];
        end

        % argins, dims, mbs, mls, mus, mcons, mlcons, mnlcons, m_ubs, m_eqs, m_linear_ubs, m_linear_eqs, m_nonlinear_ubs, m_nonlinear_eqs, f0s
        [tmp{25}, tmp{26}, tmp{27}, tmp{28}, tmp{29}, tmp{30}, tmp{31}, tmp{32}, tmp{33}, tmp{34}, tmp{35}, tmp{36}, tmp{37}, tmp{38}, tmp{39}] = check_args(pool, timeout, problem_name, para_problem_names, problem_argins);

        probinfo(i_problem, :) = tmp;
    end

    % Remove the empty rows
    probinfo = probinfo(~cellfun('isempty', probinfo(:, 1)), :);

    % Save 'feasibility' to txt file in the format of a cell array in MATLAB so that we can copy and paste it to MATLAB
    fid = fopen([saving_path, '/feasibility.txt'], 'w');
    if fid == -1
        error('Cannot open file: %s', 'feasibility.txt');
    end
    fprintf(fid, '{');
    for i = 1:length(feasibility)
        fprintf(fid, '''%s''', feasibility{i});
        if i < length(feasibility)
            fprintf(fid, ', ');
        end
    end
    fprintf(fid, '}');
    fclose(fid);

    % Save 'timeout_problems' to txt file in the format of a cell array in MATLAB so that we can copy and paste it to MATLAB
    fid = fopen([saving_path, '/timeout_problems.txt'], 'w');
    if fid == -1
        error('Cannot open file: %s', 'timeout_problems.txt');
    end
    fprintf(fid, '{');
    for i = 1:length(timeout_problems)
        fprintf(fid, '''%s''', timeout_problems{i});
        if i < length(timeout_problems)
            fprintf(fid, ', ');
        end
    end
    fprintf(fid, '}');
    fclose(fid);

    % Save the data to a .mat file in the saving path
    save([saving_path, '/probinfo.mat'], 'probinfo');
    % Save the data to a .csv file in the saving path
    % Convert all the elements in probinfo(:, end-3:) to strings
    for i_row = 2:size(probinfo, 1)
        for i_col = 25:39
            % NOTE: we need to convert the cell array to a string. If we do not do this, the cell array will be saved as a cell array in the .csv file (multiple columns)
            if isnumeric(probinfo{i_row, i_col})
                probinfo{i_row, i_col} = num2str(probinfo{i_row, i_col});
            elseif iscell(probinfo{i_row, i_col})
                info_tmp = '';
                % e.g., if it is cell(1,3), then use '{}' to wrap the elements
                for i = 1:length(probinfo{i_row, i_col})
                    str = num2str(probinfo{i_row, i_col}{i});
                    info_tmp = [info_tmp, '{', str, '}'];
                end
                probinfo{i_row, i_col} = info_tmp;
            end
        end
    end
    T = cell2table(probinfo(2:end, :), 'VariableNames', probinfo(1, :));
    writetable(T, [saving_path, '/probinfo.csv']);
    % Save the data to a .txt file in the saving path
    fid = fopen([saving_path, '/probinfo.txt'], 'w');
    if fid == -1
        error('Cannot open file: %s', 'probinfo.txt');
    end
    for i_row = 1:size(probinfo, 1)
        for i_col = 1:size(probinfo, 2)
            % Define the width of each column
            if i_col == 17 || i_col == 18
                space_col = 40;
            else
                space_col = max(cellfun(@length, probinfo(:, i_col))) + 2;
            end
            if ischar(probinfo{i_row, i_col})
                fprintf(fid, '%-*s', space_col, probinfo{i_row, i_col});
            elseif isintegervector(probinfo{i_row, i_col}) && length(probinfo{i_row, i_col}) == 1
                fprintf(fid, '%-*d', space_col, probinfo{i_row, i_col});
            elseif isintegervector(probinfo{i_row, i_col})
                % Insert a comma between each element of the vector
                cellStr = arrayfun(@num2str, probinfo{i_row, i_col}, 'UniformOutput', false);
                str = strjoin(cellStr, ',');
                fprintf(fid, '%-*s', space_col, str);
            else
                fprintf(fid, '%-*f', space_col, probinfo{i_row, i_col});
            end
        end
        fprintf(fid, '\n');
    end
    fclose(fid); 
    
    fprintf('Task completed\n');

    diary off;
end

function info_init = get_init_info(problem_name, known_feasibility)

    % Note that, since we are loading problems from S2MPJ, we should pay attention that problems in S2MPJ need to be 'set up'. Thus, if you set up one problem inside one pool, you will fail to use its methods in another pool!

    info_init = cell(1, 24);
    info_init{1} = problem_name;

    % Load the problem
    p = s2mpj_load(problem_name);

    try
        info_init{2} = p.ptype;
    catch
        info_init{2} = 'unknown';
    end

    try
        info_init{3} = p.xtype;
    catch
        % All problems in S2MPJ are real-valued problems (if we remember correctly).
        info_init{3} = 'r';
    end

    % dim
    try
        info_init{4} = p.n;
    catch
        info_init{4} = 'unknown';
    end

    % ml
    try
        info_init{6} = sum(~isinf(-p.xl));
    catch
        info_init{6} = 'unknown';
    end

    % mu
    try
        info_init{7} = sum(~isinf(p.xu));
    catch
        info_init{7} = 'unknown';
    end

    % mb
    try
        info_init{5} = p.mb;
    catch
        info_init{5} = 'unknown';
    end

    % m_linear_ub
    try
        info_init{13} = p.m_linear_ub;
    catch
        info_init{13} = 'unknown';
    end

    % m_linear_eq
    try
        info_init{14} = p.m_linear_eq;
    catch
        info_init{14} = 'unknown';
    end

    % m_nonlinear_ub
    try
        info_init{15} = p.m_nonlinear_ub;
    catch
        info_init{15} = 'unknown';
    end

    % m_nonlinear_eq
    try
        info_init{16} = p.m_nonlinear_eq;
    catch
        info_init{16} = 'unknown';
    end

    % mcon
    try
        info_init{8} = p.mcon;
    catch
        info_init{8} = 'unknown';
    end

    % mlcon
    try
        info_init{9} = p.mlcon;
    catch
        info_init{9} = 'unknown';
    end

    % mnlcon
    try
        info_init{10} = p.mnlcon;
    catch
        info_init{10} = 'unknown';
    end

    % m_ub
    try
        info_init{11} = p.m_linear_ub + p.m_nonlinear_ub;
    catch
        info_init{11} = 'unknown';
    end

    % m_eq
    try
        info_init{12} = p.m_linear_eq + p.m_nonlinear_eq;
    catch
        info_init{12} = 'unknown';
    end

    % f0 and isfeasibility
    try
        info_init{17} = p.fun(p.x0);
        if isempty(info_init{17}) || ismember(problem_name, known_feasibility)
            info_init{17} = 0;
            info_init{18} = 1;
        else
            info_init{18} = 0;
        end
    catch
        info_init{17} = 0;
        info_init{18} = 1;
    end

    % isgrad, ishess, isjcub, isjceq, ishcub, ishceq
    try
        g = p.grad(p.x0);
        if ~isempty(g)
            info_init{19} = 1;
        else
            info_init{19} = 0;
        end
    catch
        info_init{19} = 0;
    end
    try
        h = p.hess(p.x0);
        if ~isempty(h)
            info_init{20} = 1;
        else
            info_init{20} = 0;
        end
    catch
        info_init{20} = 0;
    end
    try
        J = p.jcub(p.x0);
        if ~isempty(J)
            info_init{21} = 1;
        else
            info_init{21} = 0;
        end
    catch
        info_init{21} = 0;
    end
    try
        J = p.jceq(p.x0);
        if ~isempty(J)
            info_init{22} = 1;
        else
            info_init{22} = 0;
        end
    catch
        info_init{22} = 0;
    end
    try
        H = p.hcub(p.x0);
        if ~isempty(H)
            info_init{23} = 1;
        else
            info_init{23} = 0;
        end
    catch
        info_init{23} = 0;
    end
    try
        H = p.hceq(p.x0);
        if ~isempty(H)
            info_init{24} = 1;
        else
            info_init{24} = 0;
        end
    catch
        info_init{24} = 0;
    end
end

function info_arg = get_arg_info(problem_name, arg)

    % Same note as in `get_init_info`

    info_arg = struct();

    % Load the problem
    if iscell(arg)
        p = s2mpj_load(problem_name, arg{:});
    else
        p = s2mpj_load(problem_name, arg);
    end

    info_arg.n = p.n;
    info_arg.ml = sum(~isinf(-p.xl));
    info_arg.mu = sum(~isinf(p.xu));
    info_arg.m_linear_ub = p.m_linear_ub;
    info_arg.m_linear_eq = p.m_linear_eq;
    info_arg.m_nonlinear_ub = p.m_nonlinear_ub;
    info_arg.m_nonlinear_eq = p.m_nonlinear_eq;
    info_arg.mb = p.mb;
    info_arg.mcon = p.mcon;
    info_arg.mlcon = p.mlcon;
    info_arg.mnlcon = p.mnlcon;
    info_arg.m_ub = p.m_linear_ub + p.m_nonlinear_ub;
    info_arg.m_eq = p.m_linear_eq + p.m_nonlinear_eq;
    info_arg.f0 = p.fun(p.x0);
end

function [argins, dims, mbs, mls, mus, mcons, mlcons, mnlcons, m_ubs, m_eqs, m_linear_ubs, m_linear_eqs, m_nonlinear_ubs, m_nonlinear_eqs, f0s] = check_args(pool, timeout, problem_name, para_problem_names, problem_argins)
    % Try to find all possible dimensions of each problem in S2MPJ

    argins = [];
    dims = [];
    mbs = [];
    mls = [];
    mus = [];
    mcons = [];
    mlcons = [];
    mnlcons = [];
    m_ubs = [];
    m_eqs = [];
    m_linear_ubs = [];
    m_linear_eqs = [];
    m_nonlinear_ubs = [];
    m_nonlinear_eqs = [];
    f0s = [];

    if ~ismember(problem_name, para_problem_names)
        return
    end

    % Find the index of the problem name in the list
    i_problem = find(strcmp(para_problem_names, problem_name));
    i_str = problem_argins{i_problem};
    % Convert the string to a cell array. There are two possible cases.
    % Case 1: 3,100,1000,10000, then convert to {3, 100, 1000, 10000}
    % Case 2: {1.5}{2}{11,51,101,01,501,1001,5001,10001}, then convert to a cell(1, n), where n is the number of '{' in the string

    if i_str(1) ~= '{'  % Case 1
        argins_tmp = str2num(i_str);
        len = length(argins_tmp);
    else    % Case 2
        % Find the number of '{' in the string
        n = length(strfind(i_str, '{'));
        % Initialize the cell array
        argins_tmp = cell(1, n);
        % Find the position of each '{' and '}'
        pos1 = strfind(i_str, '{');
        pos2 = strfind(i_str, '}');
        % Extract the string between each pair of '{' and '}'
        for i = 1:n
            truncate_str = i_str(pos1(i) + 1:pos2(i) - 1);
            % Convert the string to a cell array
            argins_tmp{i} = str2num(truncate_str);
        end
        argins_end = [];
        len = length(argins_tmp{n});
    end

    for i_arg = 1:len
        try
            if iscell(argins_tmp)
                arg = argins_tmp;
                arg{n} = arg{n}(i_arg);
                fprintf('\nLoading problem %s with argin %f\n', problem_name, arg{n});
            else
                arg = argins_tmp(i_arg);
                fprintf('\nLoading problem %s with argin %f\n', problem_name, arg);
            end
            
            f = parfeval(pool, @get_arg_info, 1, problem_name, arg);
            [idx, info_arg] = fetchNext(f, timeout);
            if isempty(idx)
                cancel(f);
                if iscell(arg)
                    fprintf('Timeout loading problem %s with argin %f\n', problem_name, arg{n});
                else
                    fprintf('Timeout loading problem %s with argin %f\n', problem_name, arg);
                end
                continue
            end

            dims = [dims, info_arg.n];
            mbs = [mbs, info_arg.mb];
            mls = [mls, info_arg.ml];
            mus = [mus, info_arg.mu];
            mcons = [mcons, info_arg.mcon];
            mlcons = [mlcons, info_arg.mlcon];
            mnlcons = [mnlcons, info_arg.mnlcon];
            m_ubs = [m_ubs, info_arg.m_ub];
            m_eqs = [m_eqs, info_arg.m_eq];
            m_linear_ubs = [m_linear_ubs, info_arg.m_linear_ub];
            m_linear_eqs = [m_linear_eqs, info_arg.m_linear_eq];
            m_nonlinear_ubs = [m_nonlinear_ubs, info_arg.m_nonlinear_ub];
            m_nonlinear_eqs = [m_nonlinear_eqs, info_arg.m_nonlinear_eq];
            f0s = [f0s, info_arg.f0];

            if iscell(arg)
                argins_end = [argins_end, arg{n}];
                argins = argins_tmp;
                argins{end} = argins_end;
            else
                argins = [argins, arg];
                fprintf('Problem %s with argin %f loaded successfully\n\n', problem_name, arg);
            end
        catch
            continue
        end
    end
end

function isis = isintegervector(x)
    
    isis = isreal(x) && isvector(x) && all(rem(x, 1) == 0);
    
    return
end    