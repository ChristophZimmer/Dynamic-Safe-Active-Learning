% Copyright (c) 2018 Robert Bosch GmbH
% All rights reserved.
% This source code is licensed under the MIT license found in the
% LICENSE file in the root directory of this source tree.
% @author: Christoph Zimmer 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y = model4health_base(x)
y =  (x(:,1)-5).^2  -  (x(:,1)-5).*(x(:,2)-5) +   (x(:,2)-5).^2  ;
end


