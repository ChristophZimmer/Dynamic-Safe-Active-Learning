% Copyright (c) 2018 Robert Bosch GmbH
% All rights reserved.
% This source code is licensed under the MIT license found in the
% LICENSE file in the root directory of this source tree.
% @author: Christoph Zimmer 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function run_all(inf_crit_choice,rsd,nameprefix,health_const_choice,obj_choice,m_steps,safetyalpha)
%
close all
addpath( genpath('.'), genpath('./../SPI-Toolbox/') )
delete( strcat('output/',nameprefix,'*.csv') )
warning('off', 'gp:chol_failed')


% Algorithm parameters to play around with
number_initial_samples = 10;  %must be >1 as first is start point of trajectory
n_dsal_samples = 150;  % for now uneven number please because of subplot routine
intermediate_steps = m_steps;

n_multistart = 10;
n_plot = 100;
global RANDOMSEED;
RANDOMSEED = rsd;
global BigTable
BigTable = [ 0, zeros(1,21) ];
global places
places = zeros(intermediate_steps,intermediate_steps);
for i=1:intermediate_steps
    for j=1:intermediate_steps
        places(i,j) = abs(i-j)+1;
    end
end
randomseed = rsd;
rng(randomseed);

noise = 1;
noise2 = 0.01;



ran = mvnrnd( zeros(intermediate_steps,1), diag(ones(intermediate_steps,1)) , 10000);
global healthcoverage 
healthcoverage = [];

model_choice = 'model4';
n_col_plot = 6;
n_rows_plot = ceil(n_dsal_samples/n_col_plot);
modelhealth_choice = strcat(model_choice,'health');
model = str2func(model_choice);
modelhealth = str2func(modelhealth_choice);
inf_crit = str2func(inf_crit_choice);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   Initialization  %%%%
%%%%%%%%%%%%%%%%%%%%%%  
%%%%   Initial safe trajectories  %%%%%%%
xIn = [ 4 4 3.99 3.99 ; 4.1 4.1 4 4]; 
yIn = [ model( xIn(1,:),noise ) ; model( xIn(2,:),noise ) ];
yInhealth = [ modelhealth( xIn(1,:),noise ) ; modelhealth( xIn(2,:),noise ) ];
%
for ii = 1:number_initial_samples
    lbounds = [ max(2, xIn(end,1) - .5 * intermediate_steps),  max(2,xIn(end,2) - .5 * intermediate_steps)  ]; 
    ubounds = [ min(6, xIn(end,1) + .5 * intermediate_steps),  min(6,xIn(end,2) + .5 * intermediate_steps) ];
    rr1 = lbounds + (ubounds-lbounds).*rand(1,2);
    xIn = [xIn ; create_ramp(xIn, rr1,intermediate_steps) ];
    yIn = [ yIn; zeros(intermediate_steps,1) ];
    yInhealth = [yInhealth; zeros(intermediate_steps,1)  ];
    for jj=1:intermediate_steps
        yIn( end-intermediate_steps+jj) = model( xIn(end-intermediate_steps+jj,:),noise);
        yInhealth( end-intermediate_steps+jj) = modelhealth( xIn(end-intermediate_steps+jj,:),noise2);
    end
end

%%%%%%%%% learn models initially
% learn
[explModel,healthModel] = learn_models(xIn,yIn,yInhealth);
% evaluate RMSE 
evaluation(explModel,healthModel,xIn,model_choice,modelhealth_choice,5000, 0 ,nameprefix,intermediate_steps)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  Iteration DSAL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for ii_dsal=1:n_dsal_samples
    disp(['*****',' Seed = ',num2str(RANDOMSEED) , ';   iter = ', num2str(ii_dsal),';  ',datestr( datetime ) ])
    % choose new point 
    xnew = inf_crit(explModel,healthModel,n_multistart,xIn,intermediate_steps,nameprefix,health_const_choice,obj_choice,ran,safetyalpha);
    xIn = [xIn ; create_ramp(xIn, xnew,intermediate_steps) ];
    %
    %%%%% Perform measurements %%%%%
    yIn = [ yIn; zeros(intermediate_steps,1) ];
    yInhealth = [yInhealth; zeros(intermediate_steps,1)  ];
    for jj=1:intermediate_steps
        yIn( end-intermediate_steps+jj) = model( xIn(end-intermediate_steps+jj,:),noise);
        yInhealth( end-intermediate_steps+jj) = modelhealth( xIn(end-intermediate_steps+jj,:),noise2);
    end
    %
    % update models
    [explModel,healthModel] = learn_models( xIn , yIn , yInhealth );
    %
    %%%%%%%%%%%%% Evaluation of RMSE and health coverage  %%%%%%%%%%%%%%%
    %
    if mod(ii_dsal,2)==0
        evaluation(explModel,healthModel,xIn,model_choice,modelhealth_choice,5000,ii_dsal ,nameprefix,intermediate_steps)
    end
    %
end
%
dlmwrite(  ['output/',nameprefix,'x_train.csv'] ,[ xIn, yIn , yInhealth],'delimiter','\t' );
dlmwrite(  ['output/',nameprefix,'health_coverage.csv'] ,healthcoverage,'delimiter','\t' );
%
%
end
 