import numpy as np
import pandas as pd
from concurrent.futures import ThreadPoolExecutor, TimeoutError

# Add optiprofiler to the system path
import os
import sys
sys.path.append(os.path.join(os.path.dirname(__file__), 'optiprofiler'))

# Add problems to the system path
cwd = os.path.dirname(os.path.abspath(__file__))
sys.path.append(os.path.join(cwd, 'optiprofiler', 'problems'))
from problems.s2mpj.s2mpj_tools import s2mpj_load

# Set the timeout (seconds) for each problem to be loaded
timeout = 10

cwd = os.path.dirname(os.path.abspath(__file__))
filename = os.path.join(cwd, 'optiprofiler', 'problems', 's2mpj', 'src', 'list_of_python_problems')
file = open(filename, 'r')
# Collect the names of the problems from the file
problem_names = [file.strip().replace('.py', '') for file in file.readlines() if file.strip() and not file.startswith('#')]
file.close()

# Exclude some problems
problem_exclude = [
    'SPARCO10LS' 'SPARCO10' 'SPARCO11LS' 'SPARCO11' 'SPARCO12LS' 'SPARCO12' 'SPARCO2LS' 'SPARCO2' 'SPARCO3LS' 'SPARCO3' 'SPARCO5LS' 'SPARCO5' 'SPARCO7LS' 'SPARCO7' 'SPARCO8LS' 'SPARCO8' 'SPARCO9LS' 'SPARCO9' 'ROSSIMP3_mp']
problem_names = [name for name in problem_names if name not in problem_exclude]

# List all known feasibility problems
known_feasibility = []

# To store all the feasibility problems including the known ones and the new ones
feasibility = []

# To store all the 'time out' problems
timeout_problems = []

# Find problems that are parametric
filename = os.path.join(cwd, 'list_of_parametric_problems_with_parameters_python.txt')
# Scan each line, each line only has one problem name, which ends before the first comma
# Give the rest to problem_argins
# In txt file, each line looks like:
# ALJAZZAF,3,100,1000,10000
# or
# TRAINF,{1.5}{2}{11,51,101,01,501,1001,5001,10001}
# ALJAZZAF and TRAINF are problem names
# Then let argins be the rest after the problem name if the problem name is found
with open(filename, 'r') as file:
    para_problem_names = []
    problem_argins = []
    for line in file:
        if line.strip() and not line.startswith('#'):
            parts = [x.strip() for x in line.split(',')]
            para_problem_names.append(parts[0])
            problem_argins.append(parts[1:])

saving_path = cwd

# Define the class logger
class Logger(object):
    def __init__(self, logfile):
        self.terminal = sys.__stdout__
        self.log = logfile
    def write(self, message):
        self.terminal.write(message)
        self.log.write(message)
    def flush(self):
        self.terminal.flush()
        self.log.flush()

# Record the log from terminal
log_file = open(os.path.join(saving_path, 'log_python.txt'), 'w')
sys.stdout = Logger(log_file)
sys.stderr = Logger(log_file)

# Define a function to get information about a problem
def get_problem_info(problem_name, known_feasibility, problem_argins=None):

    print(f"Processing problem: {problem_name}")

    info_single = {
        'problem_name': problem_name,
        'ptype': 'unknown',
        'xtype': 'unknown',
        'dim': 'unknown',
        'mb': 'unknown',
        'ml': 'unknown',
        'mu': 'unknown',
        'mcon': 'unknown',
        'mlcon': 'unknown',
        'mnlcon': 'unknown',
        'm_ub': 'unknown',
        'm_eq': 'unknown',
        'm_linear_ub': 'unknown',
        'm_linear_eq': 'unknown',
        'm_nonlinear_ub': 'unknown',
        'm_nonlinear_eq': 'unknown',
        'f0': 0,
        'isfeasibility': 1,
        'isgrad': 0,
        'ishess': 0,
        'isjcub': 0,
        'isjceq': 0,
        'ishcub': 0,
        'ishceq': 0,
        'argins': '',
        'dims': '',
        'mbs': '',
        'mls': '',
        'mus': '',
        'mcons': '',
        'mlcons': '',
        'mnlcons': '',
        'm_ubs': '',
        'm_eqs': '',
        'm_linear_ubs': '',
        'm_linear_eqs': '',
        'm_nonlinear_ubs': '',
        'm_nonlinear_eqs': '',
        'f0s': ''}
    try:
        with ThreadPoolExecutor() as executor:
            future = executor.submit(s2mpj_load, problem_name)
            p = future.result(timeout=timeout)
    except TimeoutError:
        print(f"Timeout while loading problem {problem_name}.")
        timeout_problems.append(problem_name)
        print(f"Skipping problem {problem_name} due to timeout.")
        return info_single

    try:
        info_single['ptype'] = p.ptype
        info_single['xtype'] = 'r'
        info_single['dim'] = p.n
        info_single['mb'] = p.mb
        info_single['ml'] = sum(p.xl > -np.inf)
        info_single['mu'] = sum(p.xu < np.inf)
        info_single['mcon'] = p.mcon
        info_single['mlcon'] = p.mlcon
        info_single['mnlcon'] = p.mnlcon
        info_single['m_ub'] = p.m_linear_ub + p.m_nonlinear_ub
        info_single['m_eq'] = p.m_linear_eq + p.m_nonlinear_eq
        info_single['m_linear_ub'] = p.m_linear_ub
        info_single['m_linear_eq'] = p.m_linear_eq
        info_single['m_nonlinear_ub'] = p.m_nonlinear_ub
        info_single['m_nonlinear_eq'] = p.m_nonlinear_eq
    except Exception as e:
        print(f"Error while getting problem info for {problem_name}: {e}")
    
    if problem_name in known_feasibility:
        info_single['isfeasibility'] = 1
        info_single['f0'] = 0
        feasibility.append(problem_name)
    else:
        try:
            with ThreadPoolExecutor() as executor:
                future = executor.submit(p.fun, p.x0)
                f = future.result(timeout=timeout)
            if np.size(f) == 0 or np.isnan(f) or problem_name in known_feasibility:
                info_single['f0'] = 0
                info_single['isfeasibility'] = 1
                feasibility.append(problem_name)
            else:
                info_single['f0'] = f
                info_single['isfeasibility'] = 0
        except Exception as e:
            print(f"Error while evaluating function for {problem_name}: {e}")
            info_single['f0'] = 0
            info_single['isfeasibility'] = 1
            feasibility.append(problem_name)
    
    if problem_name in feasibility:
        info_single['isgrad'] = 1
        info_single['ishess'] = 1
    else:
        try:
            with ThreadPoolExecutor() as executor:
                future = executor.submit(p.grad, p.x0)
                g = future.result(timeout=timeout)
            if g.size == 0:
                info_single['isgrad'] = 0
            else:
                info_single['isgrad'] = 1
        except Exception as e:
            print(f"Error while evaluating gradient for {problem_name}: {e}")
            info_single['isgrad'] = 0
        try:
            with ThreadPoolExecutor() as executor:
                future = executor.submit(p.hess, p.x0)
                h = future.result(timeout=timeout)
            if h.size == 0:
                info_single['ishess'] = 0
            else:
                info_single['ishess'] = 1
        except Exception as e:
            print(f"Error while evaluating hessian for {problem_name}: {e}")
            info_single['ishess'] = 0
    
    try:
        with ThreadPoolExecutor() as executor:
            future = executor.submit(p.jcub, p.x0)
            jc = future.result(timeout=timeout)
        if jc.size == 0:
            info_single['isjcub'] = 0
        else:
            info_single['isjcub'] = 1
    except Exception as e:
        print(f"Error while evaluating jcub for {problem_name}: {e}")
        info_single['isjcub'] = 0
    
    try:
        with ThreadPoolExecutor() as executor:
            future = executor.submit(p.jceq, p.x0)
            jc = future.result(timeout=timeout)
        if jc.size == 0:
            info_single['isjceq'] = 0
        else:
            info_single['isjceq'] = 1
    except Exception as e:
        print(f"Error while evaluating jceq for {problem_name}: {e}")
        info_single['isjceq'] = 0
    
    try:
        with ThreadPoolExecutor() as executor:
            future = executor.submit(p.hcub, p.x0)
            hc = future.result(timeout=timeout)
        if len(hc) == 0:
            info_single['ishcub'] = 0
        else:
            info_single['ishcub'] = 1
    except Exception as e:
        print(f"Error while evaluating hcub for {problem_name}: {e}")
        info_single['ishcub'] = 0
    
    try:
        with ThreadPoolExecutor() as executor:
            future = executor.submit(p.hceq, p.x0)
            hc = future.result(timeout=timeout)
        if len(hc) == 0:
            info_single['ishceq'] = 0
        else:
            info_single['ishceq'] = 1
    except Exception as e:
        print(f"Error while evaluating hceq for {problem_name}: {e}")
        info_single['ishceq'] = 0

    if problem_argins is None:
        print(f"Finished processing problem {problem_name} without parameters.")
        return info_single

    # Collect additional information if the problem is parametric
    print(f"Processing parametric problem: {problem_name} with arguments {problem_argins}")
    # First handle two special cases:
    # NUFFIELD,{5.0}{10,20,30,40,100}
    # TRAINF,{1.5}{2}{11,51,101,201,501}
    if problem_name == 'NUFFIELD':
        fixed_argins = [5.0]
        variable_argins = [10, 20, 30, 40, 100]
    elif problem_name == 'TRAINF':
        fixed_argins = [1.5, 2]
        variable_argins = [11, 51, 101, 201, 501]
    else:
        fixed_argins = []
        variable_argins = problem_argins

    successful_args = []
    for arg in variable_argins:
        print(f"Processing argument: {arg} for problem: {problem_name}")
        try:
            with ThreadPoolExecutor() as executor:
                args = fixed_argins + [arg]
                future = executor.submit(s2mpj_load, problem_name, *args)
                p = future.result(timeout=timeout)
        except TimeoutError:
            print(f"Timeout while loading problem {problem_name} with arguments {fixed_argins + [arg]}.")
            timeout_problems.append(problem_name + f" with arg {arg}")
            continue

        successful_args.append(arg)
        info_single['dims'] += str(p.n) + ' '
        info_single['mbs'] += str(p.mb) + ' '
        info_single['mls'] += str(sum(p.xl > -np.inf)) + ' '
        info_single['mus'] += str(sum(p.xu < np.inf)) + ' '
        info_single['mcons'] += str(p.mcon) + ' '
        info_single['mlcons'] += str(p.mlcon) + ' '
        info_single['mnlcons'] += str(p.mnlcon) + ' '
        info_single['m_ubs'] += str(p.m_linear_ub + p.m_nonlinear_ub) + ' '
        info_single['m_eqs'] += str(p.m_linear_eq + p.m_nonlinear_eq) + ' '
        info_single['m_linear_ubs'] += str(p.m_linear_ub) + ' '
        info_single['m_linear_eqs'] += str(p.m_linear_eq) + ' '
        info_single['m_nonlinear_ubs'] += str(p.m_nonlinear_ub) + ' '
        info_single['m_nonlinear_eqs'] += str(p.m_nonlinear_eq) + ' '
        
        if problem_name in known_feasibility:
            info_single['f0s'] += '0 '
        else:
            try:
                f = p.fun(p.x0)
                if np.size(f) == 0 or np.isnan(f):
                    info_single['f0s'] += '0 '
                else:
                    info_single['f0s'] += str(f) + ' '
            except Exception as e:
                print(f"Error while evaluating function for {problem_name} with arguments {fixed_argins + [arg]}: {e}")
                info_single['f0s'] += '0 '

    if fixed_argins:
        info_single['argins'] = ''.join(['{' + str(fa) + '}' for fa in fixed_argins])
        info_single['argins'] += '{' + ' '.join(str(arg) for arg in successful_args) + '}'
    else:
        info_single['argins'] = ' '.join(str(arg) for arg in successful_args)

    info_single['dims'] = info_single['dims'].strip()
    info_single['mbs'] = info_single['mbs'].strip()
    info_single['mls'] = info_single['mls'].strip()
    info_single['mus'] = info_single['mus'].strip()
    info_single['mcons'] = info_single['mcons'].strip()
    info_single['mlcons'] = info_single['mlcons'].strip()
    info_single['mnlcons'] = info_single['mnlcons'].strip()
    info_single['m_ubs'] = info_single['m_ubs'].strip()
    info_single['m_eqs'] = info_single['m_eqs'].strip()
    info_single['m_linear_ubs'] = info_single['m_linear_ubs'].strip()
    info_single['m_linear_eqs'] = info_single['m_linear_eqs'].strip()
    info_single['m_nonlinear_ubs'] = info_single['m_nonlinear_ubs'].strip()
    info_single['m_nonlinear_eqs'] = info_single['m_nonlinear_eqs'].strip()
    info_single['f0s'] = info_single['f0s'].strip()

    print(f"Finished processing problem {problem_name} with parameters.")
    return info_single


# Save problem information into a csv file
results = []
for name in problem_names:
    if name in para_problem_names:
        index = para_problem_names.index(name)
        args = problem_argins[index] if index < len(problem_argins) else []
    else:
        args = None
    info = get_problem_info(name, known_feasibility, args)
    results.append(info)
df = pd.DataFrame(results)
df.to_csv(os.path.join(saving_path, 'probinfo_python.csv'), index=False)

# Save 'feasibility' to txt file in the one line format with space separated values
feasibility_file = os.path.join(saving_path, 'feasibility_python.txt')
with open(feasibility_file, 'w') as f:
    f.write(' '.join(feasibility))

# Save 'timeout_problems' to txt file in the one line format with space separated values
timeout_file = os.path.join(saving_path, 'timeout_problems_python.txt')
with open(timeout_file, 'w') as f:
    f.write(' '.join(timeout_problems))

print("Script completed successfully.")

# Close the log file
log_file.close()

sys.stdout = sys.__stdout__  # Reset stdout to default
sys.stderr = sys.__stderr__  # Reset stderr to default