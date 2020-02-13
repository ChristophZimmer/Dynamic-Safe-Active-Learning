% Copyright (c) 2018 Robert Bosch GmbH
% All rights reserved.
% This source code is licensed under the MIT license found in the
% LICENSE file in the root directory of this source tree.
% @author: Christoph Zimmer 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function evaluation(obj,obj2,xIn,func00,func01,n_test,ii_dsal,nameprefix,intermediate_steps )
func0 = str2func(func00);
func1 = str2func(func01);
%
%%% Number unsafe points
tab1 = zeros( size(xIn,1), 1);
for jj=1:size(xIn,1)
    tab1(jj) = func1( xIn(jj,:),0 );
end
n_bad_points = sum( tab1 < 0 );
%
%%%  Test wrt safe area
tab_test = [];
while length(tab_test)<=n_test
    rr1s = -5 + 50 * rand(1,1);
    rr5s = -5 + 50*rand(1,1);
    lbounds = [ max(-5, rr1s - .5 * intermediate_steps),    max(-5, rr5s - .5 * intermediate_steps)  ]; 
    ubounds = [ min(45, rr1s + .5 * intermediate_steps)  ,  min(45, rr5s + .5 * intermediate_steps) ];
    zw =  lbounds + (ubounds-lbounds) .* rand(1,2);
    rr1e = zw(1);
    rr5e = zw(2);
    %
    xIn = [ 4.1 4.1 4 4 ; rr1s rr5s  3.99 3.99 ]; 
    % 
    traj0 = create_ramp(xIn,[rr1e,rr5e],7);
    traj1 = traj0(end-4:end,:);
    for jj=1:5
        hc = func1(traj1(jj,:),0);
        if hc >= 0
            zw1 = func0( traj1(jj,:),0);
            zw2 = asc_general_predict( obj,traj1(jj,:) );
            tab_test = [tab_test; [traj1(jj,:),(zw1-zw2)^2 ]];
        end
    end            
end
rmse2 = sqrt( sum( tab_test(:,end))/length(tab_test(:,end))  );
%
%%% Print out to csv file
out = [ii_dsal,n_bad_points,000, rmse2];
if exist(['output/',nameprefix,'eval_tab1.csv'],'file')==2  
     abc = dlmread(['output/',nameprefix,'eval_tab1.csv']  ); 
else   
     abc = zeros(1,4);   
end     
abc2 = [abc;out];       
dlmwrite(  ['output/',nameprefix,'eval_tab1.csv'] ,abc2,'delimiter','\t' );  
%
%%%%%%%%%%%%%%%%  how much does safe area cover
tab_test2 = [];
while length(tab_test2)<=n_test
    rr1s = -5 + 50 * rand(1,1);
    rr5s = -5 + 50*rand(1,1);
    lbounds = [ max(-5, rr1s - .5 * intermediate_steps),    max(-5, rr5s - .5 * intermediate_steps)  ]; 
    ubounds = [ min(45, rr1s + .5 * intermediate_steps)  ,  min(45, rr5s + .5 * intermediate_steps) ];
    zw = lbounds + (ubounds-lbounds) .* rand(1,2);
    rr1e = zw(1);
    rr5e = zw(2);
    %
    xIn = [ 4.1 4.1 4 4 ; rr1s rr5s  3.99 3.99 ]; 
    % 
    traj0 = create_ramp(xIn,[rr1e,rr5e],7);
    traj1 = traj0(end-4:end,:);
    for jj=1:5
        hc = func1(traj1(jj,:),0);
        hcgp = asc_general_predict(obj2, traj1(jj,:) );
        tab_test2 = [tab_test2; [hc, hcgp]];
    end           
end
zw1 = sum(  tab_test2( tab_test2(:,1)>0 , 2) < 0   );
zw2 = sum(  tab_test2(  tab_test2(:,2)>0 , 1) < 0   );
zw3 = [ii_dsal,  sum( tab_test2(:,1)>0 ), sum(tab_test2(:,2)>0) , zw1 , zw2 ];
global healthcoverage
healthcoverage =[ healthcoverage; zw3];  
end