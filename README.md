This repository is used to collect useful information about ``S2MPJ``, which is a modern realization of the famous optimization problem collection ``CUTEst``.

Specifically, we will generate an Excel file containing following information for each problem in ``S2MPJ``:
- ``name``: the name of the problem
- ``p_type``: the type of the problem, which can be ``u`` (unconstrained), ``b`` (bound-constrained), ``l`` (linearly constrained), ``n`` (nonlinearly constrained)
- ``x_type``: the type of the variables, which can be ``r`` (real), ``i`` (integer), ``b`` (binary)
- ``dim``: the dimension of the problem
- ``mb``: the total number of bound constraints
- ``ml``: the number of lower bound constraints
- ``mu``: the number of upper bound constraints
- ``m_con``: the total number of linear and nonlinear constraints
- ``m_linear``: the total number of linear constraints
- ``m_nonlinear``: the total number of nonlinear constraints
- ``m_ub``: the number of linear and nonlinear inequality constraints
- ``m_eq``: the number of linear and nonlinear equality constraints
- ``m_linear_ub``: the number of linear inequality constraints
- ``m_linear_eq``: the number of linear equality constraints
- ``m_nonlinear_ub``: the number of nonlinear inequality constraints
- ``m_nonlinear_eq``: the number of nonlinear equality constraints
- ``f0``: the value of the objective function at the initial guess
- ``isgrad``: whether the gradient is provided
- ``ishess``: whether the Hessian is provided
- ``isJcub``: whether the Jacobian of the nonlinear inequality constraints is provided
- ``isJceq``: whether the Jacobian of the nonlinear equality constraints is provided
- ``isHcub``: whether the Hessian of the Lagrangian of the nonlinear inequality constraints is provided
- ``isHceq``: whether the Hessian of the Lagrangian of the nonlinear equality constraints is provided
- ``argins``: the extra arguments that can be passed to parametrized problem of S2mPJ that will change the dimension or other properties of the problem. If the problem only accepts a single argument, 'argins' will be stored as a vector, e.g., [1,2,3]. If the problem accepts multiple arguments, 'argins' will be stored as a cell array, e.g., {2}{10,100}.
- ``dims``: all the possible dimensions of the parametrized problem of S2MPJ after passing the extra arguments.
- ``mbs``: all the possible number of bound constraints of the parametrized problem of S2MPJ after passing the extra arguments.
- ``mls``: all the possible number of lower bound constraints of the parametrized problem of S2MPJ after passing the extra arguments.
- ``mus``: all the possible number of upper bound constraints of the parametrized problem of S2MPJ after passing the extra arguments.
- ``m_cons``: all the possible number of linear and nonlinear constraints of the parametrized problem of S2MPJ after passing the extra arguments.
- ``m_linears``: all the possible number of linear constraints of the parametrized problem of S2MPJ after passing the extra arguments.
- ``m_nonlinears``: all the possible number of nonlinear constraints of the parametrized problem of S2MPJ after passing the extra arguments.
- ``m_ubs``: all the possible number of linear and nonlinear inequality constraints of the parametrized problem of S2MPJ after passing the extra arguments.
- ``m_eqs``: all the possible number of linear and nonlinear equality constraints of the parametrized problem of S2MPJ after passing the extra arguments.
- ``m_linear_ubs``: all the possible number of linear inequality constraints of the parametrized problem of S2MPJ after passing the extra arguments.
- ``m_linear_eqs``: all the possible number of linear equality constraints of the parametrized problem of S2MPJ after passing the extra arguments.
- ``m_nonlinear_ubs``: all the possible number of nonlinear inequality constraints of the parametrized problem of S2MPJ after passing the extra arguments.
- ``m_nonlinear_eqs``: all the possible number of nonlinear equality constraints of the parametrized problem of S2MPJ after passing the extra arguments.
- ``f0s``: all the possible values of the objective function at the initial guess of the parametrized problem of S2MPJ after passing the extra arguments.
