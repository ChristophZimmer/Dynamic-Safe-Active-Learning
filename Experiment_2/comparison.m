% Copyright (c) 2018 Robert Bosch GmbH
% All rights reserved.
% This source code is licensed under the MIT license found in the
% LICENSE file in the root directory of this source tree.
% @author: Christoph Zimmer 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% comparison_plots('intermediate_5_alpha040/','intermediate_5_alpha040/','opt-all_','rand-all_',25,'steps5-alpha040')
%  comparison_plots_alphadependence('intermediate_5_alpha',{'005','010','020','030','040','050','060','070','080','090','095','099'},25)

alphavalues = [ 0.99, 0.95, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3, 0.2, 0.1, 0.05, 0.01, 0.005, 0.001, 0.0005, 0.0001 ];

for jj = 1 : length(alphavalues)
    clc
    diary on
    for ii = 6 : 10
        run_all('find_new_point',  ii,[num2str(ii),'opt-all_'],  'all', 'obj_func2' , 5 , alphavalues(jj)  );
        run_all('random_new_point',  ii,[num2str(ii),'rand-all_'],  'all', 'obj_func2', 5 , alphavalues(jj)  );
    end
    str = ['intermediate_5_alpha',strrep( num2str( alphavalues(jj) ), '.','') ];
    mkdir( ['output/',str] );
    movefile( 'output/*.csv', ['output/',str,'/'] )
    diary(['output/',str,'2.txt'])
end

