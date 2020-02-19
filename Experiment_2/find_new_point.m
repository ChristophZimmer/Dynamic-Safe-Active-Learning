% Copyright (c) 2018 Robert Bosch GmbH
% All rights reserved.
% This source code is licensed under the MIT license found in the
% LICENSE file in the root directory of this source tree.
% @author: Christoph Zimmer 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y = find_new_point(explModel,healthModel,n_multistart,xIn,intermediate_steps,~,~,obj_choice,ran,safetyalpha)
obj_func = str2func( obj_choice );
options = optimset('FinDiffRelStep',0.01,'Algorithm','interior-point','AlwaysHonorConstraints','none','GradObj','off','TolFun',1e-15,'TolCon',1e-15,'GradConstr','off','MaxIter',100,'Display','off');  
%
lbounds = [ max(-5, xIn(end,1) - .5 * intermediate_steps),    max(-5,xIn(end,2) - .5 * intermediate_steps)  ]; 
ubounds = [ min(45, xIn(end,1) + .5 * intermediate_steps)  ,  min(45,xIn(end,2) + .5 * intermediate_steps) ];
%
grid1 = zeros(n_multistart,4);
grid2 = zeros(n_multistart,4);
parfor ii_multistart=1:n_multistart
    obj_func = str2func( obj_choice );
    xstart = [];kk=0;
    while isempty(xstart) & kk <= 2
        kk = kk + 1;
        rr1 =  lbounds + (ubounds-lbounds).*rand(1,2);
        hc = health_constr(healthModel,xIn,rr1,intermediate_steps,ran,safetyalpha);
        if hc <= 0 
            xstart = rr1;
        end
    end
    if isempty(xstart)
       grid1( ii_multistart , :) = [[0 0], 0 ,0 ];
       xstart =  lbounds + (ubounds-lbounds).*rand(1,2);
    else
       grid1( ii_multistart , :) = [xstart, obj_func(explModel,xIn,xstart,intermediate_steps) ,1 ];
    end
    [xnew,varopt,exitflag] = fmincon( @(x) obj_func(explModel,xIn,x,intermediate_steps), xstart,[],[],[],[],lbounds,ubounds, @(x) health_constr(healthModel,xIn,x,intermediate_steps,ran,safetyalpha), options);
    grid2(ii_multistart,:) = [xnew,varopt,exitflag];
end
grid = [grid1;grid2];
grid_feasible = grid(  grid(:,end) >=  1 ,: );
%
%
%
if isempty(grid_feasible)
    %%%%%%%%%%    -> go back to safe area
    disp('  Go back to safe area');
  %  lbounds = [ max(2, xIn(end,1) - .5 * intermediate_steps),  max(2,xIn(end,2) - .5 * intermediate_steps)  ]; 
  %  ubounds = [ min(6, xIn(end,1) + .5 * intermediate_steps),  min(6,xIn(end,2) + .5 * intermediate_steps) ];  
     lbounds = [ 2,2 ]; 
     ubounds = [ 6,6 ];  
    y = lbounds + (ubounds-lbounds).*rand(1,2);
else
    best = grid_feasible( grid_feasible(:,3) == min( grid_feasible(:,3) ),:);
    y = best(1,1:2);    
end
%
end