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
number_initial_samples = 25;  %must be >1 as first is start point of trajectory
n_dsal_samples = 250;  % for now uneven number please because of subplot routine
intermediate_steps = m_steps;

n_multistart = 25;
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
noise2 = .01;
plotQ = 0;



ran = mvnrnd( zeros(intermediate_steps,1), diag(ones(intermediate_steps,1)) , 10000);
global healthcoverage 
healthcoverage = [];

model_choice = 'prist_w_FIR_3step';
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
xIn = [ 
    2500 2500 2500 2500 30 30 30 0.7 0.7 0.7 ;
    2500 2500 2500 2500 30 30 30 0.7 0.7 0.7 ;
    2500 2500 2500 2500 30 30 30 0.7 0.7 0.7 
    %%%%
    ]; 
yIn = model( xIn ) + normrnd(0,noise);
yInhealth = modelhealth( xIn ) + normrnd(0,noise2);
%
for ii = 1:number_initial_samples
    lbounds = [ max(2200, xIn(end,1) - 10 * intermediate_steps), max(24,xIn(end,5) - 5 * intermediate_steps)  ]; 
    ubounds = [ min(2800, xIn(end,1) + 40 * intermediate_steps)  ,  min(36,xIn(end,5) + 5 * intermediate_steps) ];
    ubounds = [ min(2800, xIn(end,1) + 10 * intermediate_steps)  ,  min(36,xIn(end,5) + 5 * intermediate_steps) ];
    rr1 = lbounds + (ubounds-lbounds).*rand(1,2);
    xIn = [xIn ; create_ramp(xIn, rr1,intermediate_steps) ];
    yIn = [ yIn; zeros(intermediate_steps,1) ];
    yInhealth = [yInhealth; zeros(intermediate_steps,1)  ];
    for jj=1:intermediate_steps
        yIn( end-intermediate_steps+jj) = model( xIn(end-intermediate_steps+jj,:)) + normrnd(0,noise);
        yInhealth( end-intermediate_steps+jj) = modelhealth( xIn(end-intermediate_steps+jj,:)) + normrnd(0,noise2);
    end
end


    
    
 
if plotQ
   figure 
   subplot(  n_rows_plot  ,n_col_plot ,1)
   plot_model_2d( model_choice, modelhealth_choice ,500,[],[])
   plot(xIn(:,1),xIn(:,2),'--','Color','red' )
   plot( xIn(2:end,1), xIn(2:end,2), 'o' )
end


%%%%%%%%% learn models initially

xIn = xIn(3:end,:);
[explModel,healthModel] = learn_models(xIn(:,:),yIn,yInhealth );

evaluation(explModel,healthModel,xIn,model_choice,modelhealth_choice,10000, 0 ,nameprefix,intermediate_steps)

%if plotQ
%    subplot(   n_rows_plot   , n_col_plot ,2)
%    plot_model_2d([],[],  n_plot,explModel,healthModel)
%    plot(xIn(:,1),xIn(:,2),'--','Color','red' )
%   plot( xIn0(2:end,1), xIn0(2:end,2), 'o' )
%end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  Iteration DSAL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for ii_dsal=1:n_dsal_samples
    disp(['*****',' Seed = ',num2str(RANDOMSEED) , ';   iter = ', num2str(ii_dsal),';  ',datestr( datetime ) ])
    xnew = inf_crit(explModel,healthModel,n_multistart,xIn,intermediate_steps,nameprefix,health_const_choice,obj_choice,ran,safetyalpha);
    xIn = [xIn ; create_ramp(xIn, xnew,intermediate_steps) ];
    %
    %%%%% Measure %%%%%
    yIn = [ yIn; zeros(intermediate_steps,1) ];
    yInhealth = [yInhealth; zeros(intermediate_steps,1)  ];
    for jj=1:intermediate_steps
        yIn( end-intermediate_steps+jj) = model( xIn(end-intermediate_steps+jj,:)) + normrnd(0,noise);
        yInhealth( end-intermediate_steps+jj) = modelhealth( xIn(end-intermediate_steps+jj,:)) + normrnd(0,noise2);
    end
    %
    if mod( ii_dsal ,10) == 0
        %[explModel,healthModel] = learn_models( xIn(:,:) , yIn , yInhealth  );
        sta = number_initial_samples * intermediate_steps;
        [explModel,healthModel] = learn_models( xIn(sta:end,:) , yIn(sta:end,:) , yInhealth(sta:end,:)  );
    end
    %
%     if plotQ
%         subplot(   n_rows_plot   , n_col_plot, 1 ) ; drawnow % plot for first panel
%         plot(xIn(end-1:end,1),xIn(end-1:end,2),'Color','red' ); drawnow
%         plot( xIn(end,1), xIn(end,2), 'o' ); drawnow
%         subplot(   n_rows_plot   , n_col_plot , ii_dsal+2); drawnow  %plot for current panel
%         plot_model_2d(  [],[], n_plot,explModel,healthModel); drawnow
%         plot(xIn(:,1),xIn(:,2), 'Color','red' ) ; drawnow
%         plot( xIn(2:end,1), xIn(2:end,2), 'o' ); drawnow
%     end
    
    %%%%%%%%%%%%% Evaluation  %%%%%%%%%%%%%%%
    %
    if mod(ii_dsal,10)== 0
        evaluation(explModel,healthModel,xIn,model_choice,modelhealth_choice,10000,ii_dsal ,nameprefix,intermediate_steps)
    end
    %
end
%
dlmwrite(  ['output/',nameprefix,'x_train.csv'] ,[ xIn, yIn , yInhealth],'delimiter','\t' );
dlmwrite(  ['output/',nameprefix,'health_coverage.csv'] ,healthcoverage,'delimiter','\t' );
%
if plotQ
    abc = dlmread(['output/',nameprefix,'eval_tab1.csv']);
    figure
    plot( abc(2:end,1),abc(2:end,3) )
    xlabel('iteration')
    ylabel('RMSE')
end
%
end
 