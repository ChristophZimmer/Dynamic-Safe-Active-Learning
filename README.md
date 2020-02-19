# Dynamic Safe Active Learning

This is the companion code for the algorithm reported in the paper "Safe
Active Learning for Time-Series Modeling with Gaussian Processes". The
paper can be found at
http://papers.nips.cc/paper/7538-safe-active-learning-for-time-series-modeling-with-gaussian-processes

Please cite the above paper when reporting, reproducing or extending the
results.

## Purpose of the project

This software is a research prototype, solely developed for and
published as part of the publication cited above. It will neither be
maintained nor monitored in any way.

## How to run the examples

Each folder in this repository contains code to reproduce the results of
the corresponding example of the paper cited above.

The code is not stand alone. It requires

* a Gaussian Process module providing a gp trainer and predictor named
  `gp()` and `gp_predict()`
* an MCMC sampler, which needs to be provided in the examples'
  `mcmc2.m`.

Once, the Gaussian Process module is linked to the code in the functions
`health_constr`, `learn_models`, and `obj_func2`, as well as the MCMC sampler, 
you can reproduce the results by running the file `comparison.m` in the 
example directory. Results will be generated in a directory named "output".

## License

This code is open-sourced under the MIT license. See the
[LICENSE](LICENSE.txt) file for details.
