% Copyright (c) 2018 Robert Bosch GmbH
% All rights reserved.
% This source code is licensed under the MIT license found in the
% LICENSE file in the root directory of this source tree.
% @author: Christoph Zimmer 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y = random_new_point(explModel,healthModel,~,xIn,intermediate_steps,~,~,~,ran,safetyalpha)
y = [];
kk = 1;
lbounds = [ max(1000, xIn(end,1) - 10 * intermediate_steps), max(0,xIn(end,5) - 5 * intermediate_steps)  ]; 
ubounds = [ min(4000, xIn(end,1) + 40 * intermediate_steps)  ,  min(60,xIn(end,5) + 5 * intermediate_steps) ];
% ubounds = [ min(4000, xIn(end,1) + 10 * intermediate_steps)  ,  min(60,xIn(end,5) + 5 * intermediate_steps) ];
lbounds = [ 1000,0];
ubounds = [4000,60];

global RANDOMSEED
while isempty(y)  & kk <= 1000
    rng(  RANDOMSEED * ( 1e5 * length(explModel.x) + kk )   );
    kk = kk + 1;
    %disp(kk);
    rr1 = lbounds + (ubounds-lbounds).*rand(1,2);
    hc = health_constr(  healthModel,xIn,rr1,intermediate_steps,ran,safetyalpha  );
    if  hc<=0
        y = [ y ; rr1 ];
    end
end
%******** No safe point found - go back to initial rectangle ***********
if isempty(y)
    disp('no safe point found -> go back to initial rectangle');
    y = [2200,24] + [600,12].*rand(1,2);
end    
%
end