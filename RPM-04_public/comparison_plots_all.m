% Copyright (c) 2018 Robert Bosch GmbH
% All rights reserved.
% This source code is licensed under the MIT license found in the
% LICENSE file in the root directory of this source tree.
% @author: Christoph Zimmer 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% comparison_plots_all('intermediate_5_alpha099/','intermediate_5_alpha08/','intermediate_5_alpha05/','intermediate_5_alpha001/','opt-all_','rand-all_','intermediate_5_alpha',{'0001','0005','001','005','01','02','03','04','05','06','07','08','09','095','099'},5)
%
function comparison_plots_all(subfolder1,subfolder2,subfolder3,subfolder4,name1,name2,  subfolder00,namelist,repeats_max)
addpath( genpath('.'), genpath('./../SPI-Toolbox/') )

fig1 = figure('position', [100, 100, 1500+100, 300+100] ) ;

subplot(2,8,[1 2 9 10 ])
comp_plot_par1(subfolder1,subfolder2,name1,name2,   repeats_max)

subplot(2,8,[3 4 11 12 ])
comp_plot_par2(subfolder1,subfolder2, name1,name2,   repeats_max)

subplot(2,8,[5 6 13 14 ])
comp_plot_par3(subfolder1,subfolder2,subfolder3,subfolder4,name1,repeats_max)

subplot(2,8,[7 8 15 16 ])
comp_plot_par4(   subfolder00,namelist,repeats_max)




set(fig1,'Units','Inches');pos = get(fig1,'Position');
set(fig1,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3)- 0, pos(4)-0])
print('-loose',fig1,['output/figures/','RPM-model'],'-dpdf','-r0');
end