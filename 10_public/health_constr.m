% Copyright (c) 2018 Robert Bosch GmbH
% All rights reserved.
% This source code is licensed under the MIT license found in the
% LICENSE file in the root directory of this source tree.
% @author: Christoph Zimmer 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [cleq,ceq] = health_constr(obj,xIn,xnew,intermediate_steps,ran,safetyalpha)
   ceq = [];
   xnew_ramp = create_ramp(xIn,xnew,intermediate_steps);
   [mu,~,~,~,K] = gp_predict( obj, xnew_ramp(:,:),[0,1,0]   );
   %
   cleq1 = mcmc(mu,K,10000,ran);
   cleq = - cleq1 + (1-safetyalpha)  ;  
end