# UAI2023_Pairwise_CI_Testing

This repository contains the R-scripts that were used to generate the plots in the paper that will be submitte to UAI2023 (exact reference to follow). This repository does not constitute a package, it just consists of some scripts.

## Requirements
The R version should match the mentioned packages below. (We used R version 3.6.3 (2020-02-29) -- "Holding the Windsock").
Several packages and the there mentioned dependencies need to be installed in the respective R environment:

mvtnorm

energy

GeneralisedCovarianceMeasure: is only needed when using the Generalized Covariance Measure

At the moment, the user must do this for herself. We plan to do this in the future.

## Contact info

tom dot hochsprung at dlr dot de

## Scripts

The repository contains several scripts:

**main_code.R**:
This is the main script of the repository, here the user can change the parameters and the model generates the data.

**model_sigma_1.R**:
This is the model corresponding to Sigma^(1) in the paper.

**model_sigma_2.R**:
This is the model corresponding to Sigma^(2) in the paper.

**model_sigma_gcm.R**:
This is the model corresponding to the simulations regarding the Generalized Covariance Measure in the Appendix.

**execute_standard_test.R**:
This function executes the standard pairwise testing algorithm, see Section 3.1 in the paper.

**execute_novel_test.R**:
This function executes the novel pairwise testing algorithm, see Sections 3.2 and 3.3 in the paper.

**test_ci_by_par_cor.R**:
Tests (conditional) independence using the partial correlation and the t-distribution.

## License
You can redistribute and/or modify the code under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.

## Project status
The code was meant to provide a way of validating the generated plots in the original paper. As of now, no further developments are planned.
