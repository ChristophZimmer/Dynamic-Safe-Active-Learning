% Copyright (c) 2018 Robert Bosch GmbH
% All rights reserved.
% This source code is licensed under the MIT license found in the
% LICENSE file in the root directory of this source tree.
% @author: Christoph Zimmer 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [explModel,healthModel] = learn_models(xIn,yIn,yInhealth) 
   %specifiy further options here as explModel object:
   % start values for hyperparameters:    [ 1.5, 1.5, 1.5, 1.5, 1.0, .5];
   % hyperparameter training:  [false, false, false, false ,false,false];
   % user defined mean:  0;
   % user defined standard deviation:  1;
   explModel = gp( explModel , xIn ,  yIn );
   %
   %specifiy further options here as healthModel object:
   % start values for hyperparameters: [ 1.5, 1.5, 1.5, 1.5 ,2, .05  ];
   % hyperparameter training: [false, false, false, false,false,false];
   %healthModel = asc_general_mod( healthModel , xIn ,  yInhealth );
   % user defined mean: -2;
   % user defined standard deviation:  1;
   healthModel = gp(healthModel , xIn,yInhealth );
end






