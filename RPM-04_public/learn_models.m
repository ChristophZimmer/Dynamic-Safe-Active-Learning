% Copyright (c) 2018 Robert Bosch GmbH
% All rights reserved.
% This source code is licensed under the MIT license found in the
% LICENSE file in the root directory of this source tree.
% @author: Christoph Zimmer 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [explModel,healthModel] = learn_models(xIn,yIn,yInhealth ) 
    %specifiy further options here as explModel object:
   % start values for hyperparameters:  [2.0440 2.8944  3.4799 1.7412 0.2092 1.2262 0.1892 1.0 1.00 1.0 1.0236 0.1962];
    % lower bounds for hyperparameters:   [0.5 0.5 0.5 0.5 0.05 0.5 0.05 1.0 1.0 1.0 1 0.05];
 % upper bounds for hyperparameters:   [5.0 5.0 5.0 5.0 2.00 2.5 2.50 1.0 1.0 1.0 1 0.50];
   % user defined mean:  0;
   % user defined standard deviation:    1;
     % optimization method of hyperparameters 'fmincon';
   % hyperparameter training:    [true, true, true, true, true,true,false, false, false,false,true,true];
 
   explModel = gp( explModel , xIn ,  yIn );
   %
   %%%%%%%%
   %
       %specifiy further options here as healthModel object:
   % start values for hyperparameters:   [2.0440 2.8944  3.4799 1.7412 0.2092 1.2262 0.1892 1.0 1.00 1.0 1.0236 0.1962];
    % lower bounds for hyperparameters:  [0.5 0.5 0.5 0.5 0.05 0.5 0.05 1.0 1.0 1.0 0.1 .1];
 % upper bounds for hyperparameters:  [1*[5.0 5.0 5.0 5.0 2.00 2.5 2.50], 1.0 1.0 1.0 5.0 .1];
     % optimization method of hyperparameters 'fmincon';
   % user defined mean: -2;
   % user defined standard deviation: 1;
   % hyperparameter training: [true, true, true, true, true,true,true,true,true,true,true,true];
 
   healthModel = gp( healthModel , xIn ,  yInhealth );
end






