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
lbounds = [ max(-5, xIn(end,1) - .5 * intermediate_steps), max(-5,xIn(end,2) - .5 * intermediate_steps)  ]; 
ubounds = [ min(45, xIn(end,1) + .5 * intermediate_steps)  ,  min(45,xIn(end,2) + .5 * intermediate_steps) ];
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
    y = [2,2] + [4,4].*rand(1,2);
end    
%
end