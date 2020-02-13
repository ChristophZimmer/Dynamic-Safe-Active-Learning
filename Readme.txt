% Copyright (c) 2018 Robert Bosch GmbH
% All rights reserved.
% This source code is licensed under the MIT license found in the
% LICENSE file in the root directory of this source tree.
% @author: Christoph Zimmer 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Dynamic Safe Active Learning
This is the companion code for the algorithm reported in the paper
 "Safe Active Learning for Time-Series Modeling with Gaussian Processes".
The paper can be found here http://papers.nips.cc/paper/7538-safe-active-learning-for-time-series-modeling-with-gaussian-processes
The code is only thought for reproducing results of the paper and for no other purpose. Please cite the above paper when reporting, reproducing or 
extending the results.



Purpose of the project

This software is a research prototype, solely developed for and published as part of the 
publication cited above. It will neither be maintained nor monitored in any way.



Requirements, how to build, test, install, use, etc.

The code is not stand alone. It needs a Gaussian Process module in addition and an MCMC sampler. Once, the Gaussian Process
module is linked to the code in the functions (health_constr, learn_models, obj_func2), the code can reproduce the results of the above 
cited paper.



License

This code is open-sourced under the MIT license. See the
LICENSE file for details.




Each folder contains code for the corresponding example

As example, use folder 10_public for Example 1:
Run all code by comparison.m
Results are generated in output 

Important note: you need to add a gp trainer and predictor named gp() and gp_predict()


 