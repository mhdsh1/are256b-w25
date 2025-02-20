*set working directory 
global path "C:\Users\mahdi\Dropbox\Courses\are256b-w25"
cd $path

* Load your dataset
import delimited "$path/data/broiler.csv", clear


browse

/*
"y" is per­capita real disposable income, 
"pchick" stands for "price of chicken", 
"pbeef" is "price of beef", 
"pcor" is "price of corn", 
"pf" is "price of chicken feed", 
"cpi" is "consumer price index", 
"qproda" is "aggregate production of chicken in pounds", 
"pop" is "population of the US", a
nd "meatex" is "exports of beef, veal, and pork in pounds".

*/


* OLS regressions
reg q pchick // short regression 
reg q pchick y pop cpi meatex pbeef // long regression 

/*

Recall the OVB formula:

OVB = \beta_long - \beta_short = \Sigma_j \Gamma_j Cov(W_j,X)/var(X)

let's see what explains the difference between the two betas 

*/
reg y pchick 
reg pop pchick
reg cpi pchick
reg meatex pchick
reg pbeef pchick


// we use pcor or pfeed as an instrument 

/*

Refresher on instruments, out good friend for demand estimation! 

1) Validity: cov(u,Z) = 0.

in demand estimation u are all the unobservable factors that affect the demand ... 
"demand-shifters", "taste", ...

2) Relvance: cov(X,Z) not 0.

instrument should affect the endogenuous variable 

3) Exclusion: Z has no direct link with Y.

Simply the fact that instrument should be "excluded exogenuous variable"

*/


* IV regression
ivregress 2sls q (pchick = pf) y pop cpi pbeef meatex
ivregress 2sls q (pchick = pf pcor) y pop cpi pbeef meatex

// lets do it ourself

* first stage 
reg pchick pcor pf y pop cpi meatex pbeef
predict xhat, xb
* Second stage regression
reg q xhat y pop cpi pbeef meatex



* multiple endogenous regressors: what if PBEEF is also endogenuous?\

// FS:

reg pbeef  pcor pf y pop cpi meatex pchick 

reg pchick pcor pf y pop cpi meatex pbeef



ivregress 2sls q (pchick pbeef = pf pcor) y pop cpi meatex



