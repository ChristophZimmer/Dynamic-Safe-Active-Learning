% Copyright (c) 2018 Robert Bosch GmbH
% All rights reserved.
% This source code is licensed under the MIT license found in the
% LICENSE file in the root directory of this source tree.
% @author: Christoph Zimmer 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y = create_ramp(xIn,xend,intermediate_steps)
zw1 = 1:1:intermediate_steps;
tau = zeros( intermediate_steps, 2 );
%xs = [1000,0] + ([4000,60]-[1000,0]).*rand(1,2);   %xx
%xIn = repmat(  [ xs(1), xs(1),xs(1),xs(1),xs(2),xs(2),xs(2), .7,.7,.7] , 3,1);   %xx
for jj=1:intermediate_steps
    tau(jj,:) = xIn(end,[1,5]) + zw1(jj)/intermediate_steps * (xend - xIn(end,[1,5]));
end 
xIn =  [ xIn ; [tau(:,1) ,  zeros(length(tau(:,1)),3),  tau(:,2),  zeros(length(tau(:,1)),5)+0.7 ]  ]; 
pastinputblock = zeros(length(tau(:,1)),3) ;
for jj=1:length(tau(:,1))
        pastinputblock(jj,1) = xIn(end-1-intermediate_steps+jj,1);
        pastinputblock(jj,2) = xIn(end-2-intermediate_steps+jj,1);
        pastinputblock(jj,3) = xIn(end-3-intermediate_steps+jj,1);
        pastinputblock(jj,4) = xIn(end-1-intermediate_steps+jj,5);
        pastinputblock(jj,5) = xIn(end-3-intermediate_steps+jj,5);
end
y =  [tau(:,1), pastinputblock(:,1:3), tau(:,2), pastinputblock(:,4:5), zeros(length(tau(:,1)),3)+0.7 ];

%%%%%%%%%%%%%%%%%
% rng( size(xIn,1)*100 );
% rr1 = 1000 + 3000 * rand(1,1);
%     rr2bounds = [ rr1 - 10 * 1, rr1 + 40 * 1 ]; 
%     rr2 = rr2bounds(1) + (rr2bounds(2)-rr2bounds(1))*rand(1,1);
%     rr3bounds = [ rr2 - 10 * 1, rr2 + 40 * 1 ]; 
%     rr3 = rr3bounds(1) + (rr3bounds(2)-rr3bounds(1))*rand(1,1);
%     rr4bounds = [ rr3 - 10 * 1, rr3 + 40 * 1 ]; 
%     rr4 = rr4bounds(1) + (rr4bounds(2)-rr4bounds(1))*rand(1,1);
%     
%     rr5 = 0 + 60*rand(1,1);
%     rr6bounds = [ max(0,rr5 - 5 * 1), rr5 + 5 * 1 ]; 
%     rr6 = rr6bounds(1) + (rr6bounds(2)-rr6bounds(1))*rand(1,1);
%     rr7bounds = [ max(0,rr6 - 5 * 2), rr6 + 5 * 2];
%     rr7 = rr7bounds(1) + (rr7bounds(2)-rr7bounds(1))*rand(1,1);
%     point = [ rr1, rr2, rr3, rr4, rr5 rr6, rr7, 0.7,0.7,0.7];
%     y = point;
    
    %%%%%%%%%%%%%%%%%  geht noch
%   %rng( size(xIn,1)*100 );
%     rr1 = xend(1);
%     rr2bounds = [ rr1 - 10 * 1, rr1 + 40 * 1 ]; 
%     rr2 = rr2bounds(1) + (rr2bounds(2)-rr2bounds(1))*rand(1,1);
%     rr3bounds = [ rr2 - 10 * 1, rr2 + 40 * 1 ]; 
%     rr3 = rr3bounds(1) + (rr3bounds(2)-rr3bounds(1))*rand(1,1);
%     rr4bounds = [ rr3 - 10 * 1, rr3 + 40 * 1 ]; 
%     rr4 = rr4bounds(1) + (rr4bounds(2)-rr4bounds(1))*rand(1,1);
%     
%     rr5 = xend(2);
%     rr6bounds = [ max(0,rr5 - 5 * 1), rr5 + 5 * 1 ]; 
%     rr6 = rr6bounds(1) + (rr6bounds(2)-rr6bounds(1))*rand(1,1);
%     rr7bounds = [ max(0,rr6 - 5 * 2), rr6 + 5 * 2];
%     rr7 = rr7bounds(1) + (rr7bounds(2)-rr7bounds(1))*rand(1,1);
%     point = [ rr1, rr2, rr3, rr4, rr5 rr6, rr7, 0.7,0.7,0.7];
%     y = point;
    
%         %%%%%%%%%%%%%%%%%  geht nicht
%      rr1 = xend(1);
%      rr11bounds = [ max(1000,rr1 - 10 * 8) , min( rr1 + 40 * 8, 4000) ]; 
%      rr11 = rr11bounds(1) + (rr11bounds(2)-rr11bounds(1))*rand(1,1);
%      rr5 = xend(2);
%      rr55bounds = [ max(0, rr5 - 5 * 8), min(60, rr5 + 5 * 8 ) ]; 
%      rr55 = rr55bounds(1) + (rr55bounds(2)-rr55bounds(1))*rand(1,1);
%      
%      zw1 = 1:1:8;
%      tau = zeros( 8, 2 );
%      for jj=1:8
%           tau(jj,:) = [rr11,rr55] + zw1(jj)/8 * (xend - [rr11,rr55]);
%      end 
%      y = [
%       tau(4,1), tau(3,1), tau(2,1), tau(1,1), tau(4,2), tau(3,2), tau(1,2), 0.7, 0.7, 0.7 ;
%       tau(5,1), tau(4,1), tau(3,1), tau(2,1), tau(5,2), tau(4,2), tau(2,2), 0.7, 0.7, 0.7 ;
%       tau(6,1), tau(5,1), tau(4,1), tau(3,1), tau(6,2), tau(5,2), tau(3,2), 0.7, 0.7, 0.7 ;
%       tau(7,1), tau(6,1), tau(5,1), tau(4,1), tau(7,2), tau(6,2), tau(4,2), 0.7, 0.7, 0.7 ;
%       tau(8,1), tau(7,1), tau(6,1), tau(5,1), tau(8,2), tau(7,2), tau(5,2), 0.7, 0.7, 0.7 
%      ];
%     % y= y(end,:);
%     
end




 
  
    
    
    