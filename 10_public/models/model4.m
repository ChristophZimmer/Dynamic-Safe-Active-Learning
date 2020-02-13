% Copyright (c) 2018 Robert Bosch GmbH
% All rights reserved.
% This source code is licensed under the MIT license found in the
% LICENSE file in the root directory of this source tree.
% @author: Christoph Zimmer 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y = model4(x,noise)
zw1 = model4_base(x(1:2));
if x(1)==x(3)
    x(3) = 1.001 * x(3);
end
zw2 = ( model4_base([x(1),x(2)])-model4_base([x(3),x(2)]) )/(x(1)-x(3));
if x(2) == x(4)
    x(4) = 1.001 * x(4);
end
zw3 = ( model4_base([x(1),x(2)])-model4_base([x(1),x(4)]) )/(x(2)-x(4));
y = zw1 + zw2 + zw3 + ( noise * randn(length(zw1),1)   );
end