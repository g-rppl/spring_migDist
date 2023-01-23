data{
  int<lower=0> Nind; // number of individuals
  int<lower=0> Nocc; // number of occasions
  int<lower=0> Nsp;  // number of species
  array[Nind,Nocc] int<lower=1, upper=4> y; // detection history matrix
  array[Nind] int<lower=1, upper=Nsp>   sp; // species index
  array[Nind] int<lower=0, upper=1>    tag; // tag type index
  
  // Weather data
  matrix[Nind,Nocc] u_l;
  matrix[Nind,Nocc] u_q;
  matrix[Nind,Nocc] v_l;
  matrix[Nind,Nocc] v_q;
  matrix[Nind,Nocc] pc_z;
  matrix[Nind,Nocc] h_z;
  matrix[Nind,Nocc] r;
}

parameters{
  vector<lower=0, upper=1>[Nsp] mean_psi; // mean departure prob. per species
  vector<lower=0, upper=1>[Nsp] mean_chi; // mean prob. for offshore flight per species
  real<lower=0, upper=1>        pX_A;     // mean detection prob. offshore (ACT)
  real<lower=0, upper=1>        pC_A;     // mean detection prob. onshore (ACT)
  
  // Slope parameters
  vector[Nsp] b_u1_l;
  vector[Nsp] b_u1_q;
  vector[Nsp] b_v1_l;
  vector[Nsp] b_v1_q;
  vector[Nsp] b_p1;
  vector[Nsp] b_h1;
  real b_r1;
  real b_u2_l;
  real b_u2_q;
  real b_v2_l;
  real b_v2_q;
  real<upper=0> eps1; // constrain detection prob. to be lower in NTQB
  real<upper=0> eps2;
}

transformed parameters{
  matrix[Nind,Nocc-1] psi; // departure probability
  matrix[Nind,Nocc-1] chi; // probability for offshore flight
  vector[Nsp]   mu1;       // intercept psi
  vector[Nsp]   mu2;       // intercept chi
  vector[Nind]   pX;       // detection probability offshore
  vector[Nind]   pC;       // detection probability onshore
  real mu_pX;              // intercept pX
  real mu_pC;              // intercept pC
  array[4,Nind,Nocc-1] simplex[4] ps; // state-transition matrix
  array[4,Nind,Nocc-1] simplex[4] po; // observation matrix
  
  // CONSTRAINTS
  // Logit transformations
  for (s in 1:Nsp){
    mu1[s] = logit(mean_psi[s]);
    mu2[s] = logit(mean_chi[s]);
  }
  mu_pX = logit(pX_A);
  mu_pC = logit(pC_A);
  
  // Linear models
  for (i in 1:Nind){
    for (t in 1:(Nocc-1)){
      psi[i,t] = inv_logit(mu1[sp[i]] 
      + b_u1_l[sp[i]]*u_l[i,t]  + b_u1_q[sp[i]]*u_q[i,t]
      + b_v1_l[sp[i]]*v_l[i,t]  + b_v1_q[sp[i]]*v_q[i,t] 
      + b_p1[sp[i]]  *pc_z[i,t] + b_h1[sp[i]]  *h_z[i,t] 
      + b_r1         *r[i,t]);
      chi[i,t] = inv_logit(mu2[sp[i]] 
      + b_u2_l*u_l[i,t] + b_u2_q*u_q[i,t] 
      + b_v2_l*v_l[i,t] + b_v2_q*v_q[i,t]);
    }
    pX[i] = inv_logit(mu_pX + eps1*tag[i]);
    pC[i] = inv_logit(mu_pC + eps2*tag[i]);
  }
  
  // Define state-transition and observation matrices
  for (i in 1:Nind){
    for (t in 1:(Nocc-1)){
      // Define probabilities of state S(t+1) given S(t)
      ps[1,i,t,1] = 1-psi[i,t];
      ps[1,i,t,2] = psi[i,t]*chi[i,t];
      ps[1,i,t,3] = psi[i,t]*(1-chi[i,t]);
      ps[1,i,t,4] = 0;
      ps[2,i,t,1] = 0;
      ps[2,i,t,2] = 0;
      ps[2,i,t,3] = 0;
      ps[2,i,t,4] = 1;
      ps[3,i,t,1] = 0;
      ps[3,i,t,2] = 0;
      ps[3,i,t,3] = 0;
      ps[3,i,t,4] = 1;
      ps[4,i,t,1] = 0;
      ps[4,i,t,2] = 0;
      ps[4,i,t,3] = 0;
      ps[4,i,t,4] = 1;

      // Define probabilities of O(t) given S(t)
      po[1,i,t,1] = 1;
      po[1,i,t,2] = 0;
      po[1,i,t,3] = 0;
      po[1,i,t,4] = 0;
      po[2,i,t,1] = 0;
      po[2,i,t,2] = pX[i];
      po[2,i,t,3] = 0;
      po[2,i,t,4] = 1-pX[i];
      po[3,i,t,1] = 0;
      po[3,i,t,2] = 0;
      po[3,i,t,3] = pC[i];
      po[3,i,t,4] = 1-pC[i];
      po[4,i,t,1] = 0;
      po[4,i,t,2] = 0;
      po[4,i,t,3] = 0;
      po[4,i,t,4] = 1;
    }
  }
}

model{
  array[4] real acc; // accumulator
  array[Nocc,4] real gam; // forward values
  
  // PRIORS
  b_u1_l ~ normal(0, 10);
  b_u1_q ~ normal(0, 10);
  b_v1_l ~ normal(0, 10);
  b_v1_q ~ normal(0, 10);
  b_p1   ~ normal(0, 5);
  b_h1   ~ normal(0, 5);
  b_r1   ~ normal(0, 5);
  b_u2_l ~ normal(0, 10);
  b_u2_q ~ normal(0, 10);
  b_v2_l ~ normal(0, 10);
  b_v2_q ~ normal(0, 10);

  // LIKELIHOOD
  // Forward algorithm derived from Stan
  // user's guide and reference manual
  for (i in 1:Nind){
    // Make sure that all individuals are in state 1 at t=1
    gam[1,1] = 1;
    gam[1,2] = 0;
    gam[1,3] = 0;
    gam[1,4] = 0;
    
    for (t in 2:Nocc){
      for (k in 1:4){   // current state (t)
        for (j in 1:4){ // previous state (t-1)
          acc[j] = gam[t-1,j] * ps[j,i,t-1,k]
                   * po[k, i, t-1, y[i,t]];
        }
        gam[t,k] = sum(acc);
      }
    }
    target += log(sum(gam[Nocc]));
  }
}

generated quantities{
  array[Nind,Nocc] int<lower=1, upper=4> z; // latent state
  int  Noff; // number of offshore flights
  real Nrel; // proportion of offshore flights

  // Generate z[]
  for (i in 1:Nind){
    z[i,1] = 1;
    for (t in 2:Nocc){
      z[i,t] = categorical_rng(ps[z[i,t-1], i, t-1]);
    }
  }

  // Count offshore flights
  Noff = 0;
  for (i in 1:Nind){
    for (t in 1:Nocc){
      if (z[i,t] == 2){
        Noff += 1;
      }
    }
  }
  Nrel = Noff*1.0 / Nind;

  // Calculate detection probabilities for NTQB tags
  real pX_N = inv_logit(mu_pX + eps1);
  real pC_N = inv_logit(mu_pC + eps2);
}
