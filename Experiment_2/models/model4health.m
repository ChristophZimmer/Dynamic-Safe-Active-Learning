% Copyright (c) 2018 Robert Bosch GmbH
% All rights reserved.
% This source code is licensed under the MIT license found in the
% LICENSE file in the root directory of this source tree.
% @author: Christoph Zimmer 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y = model4health(x,noise2)
zw1 = model4health_base(x(1:2));
if x(1)==x(3)
    x(3) = 1.001 * x(3);
end
zw2 = ( model4health_base([x(1),x(2)])-model4health_base([x(3),x(2)]) )/(x(1)-x(3));
if x(2)==x(4)
    x(4) = 1.001 * x(4);
end
zw3 = ( model4health_base([x(1),x(2)])-model4health_base([x(1),x(4)]) )/(x(2)-x(4));
y0 = zw1 - abs(zw2) - abs(zw3) ;
y =   - 0.005 .* y0 + 1 +  noise2 * randn(length(zw1),1);
end


