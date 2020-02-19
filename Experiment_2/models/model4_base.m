% Copyright (c) 2018 Robert Bosch GmbH
% All rights reserved.
% This source code is licensed under the MIT license found in the
% LICENSE file in the root directory of this source tree.
% @author: Christoph Zimmer 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y = model4_base(x)
y =  (x(:,1)-2).^2  -  (x(:,1)-2).*(x(:,2)-2) +   (x(:,2)-2).^2  ;
end