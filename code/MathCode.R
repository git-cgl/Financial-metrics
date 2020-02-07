### MV modelling: conceptually

Generalization of univariate GARCH models to the multivariate domain is a conceptually simple exercise: Given the stochastic process, $x_t, t=1,2,...T$ of financial returns with dimension $N \times 1$ and mean vector $\mu_t$, given the information set $I_{t-1}$:
  
  \begin{align} \label{eq:mgarch1}
x_t \left| I_{t - 1} \right. = \mu_t + \varepsilon_t
\end{align}

where the residuals of the process are modelled as:
  
  \begin{align} \label{eq:mgarch2}
\varepsilon_t = H_{t}^{1/2}z_t,
\end{align}

$H_t^{1/2}$ above is a $N\times N$ positive definite matrix such that $\bf{H_t}$
  is the __conditional covariance__ matrix of $\bf{x_t}$.

$\bf{z_t}$ is a $N\times 1$ i.i.d. N(0,1) series.

Now several techniques have been proposed that map the $H_t$ matrix into the multivariate plain:
  
  * VECH, BEKK, CCC-GARCH, DCC-GARCH, GOGARCH, etc.

* A large literature has developed that attempts to map $H_t$  into the multivariate space, 
+ But MV Volatility models typically suffer from curse of high dimensionality..
* Studying correlation between a large amount of series, implies a potentially very large set of unique bivariate correlation combinations.
+ This requires a parsimonious and effective means of isolating the conditional comovements.








## DCC Models

DCC models offer a simple and more parsimonious means of doing MV-vol modelling. In particular, it relaxes the constraint of a fixed correlation structure (assumed by the CCC model), to allow for estimates of time-varying correlation (see @engle2002 for the original paper).

The DCC model can be defined as:
  
  \begin{equation} \label{dcc}
H_t = D_t.R_t.D_t.
\end{equation}

Equation \ref{dcc} splits the varcovar matrix into identical diagonal matrices and an estimate of the time-varying correlation. Estimating $R_T$ requires it to be inverted at each estimated period, and thus a proxy equation is used (@engle2002):
  
  \begin{align}  \label{dcc2}
Q_{ij,t} &= \bar Q + a\left(z_{t - 1}z'_{t - 1} - \bar{Q} \right) + b\left( Q_{ij, t - 1} - \bar{Q} \right) \hfill \\ \notag
                            &= (1 - a - b)\bar{Q} + az_{t - 1}z'_{t - 1} + b.Q_{ij, t - 1} \notag
                            \end{align} 
                            
                            * Note the above equation is similar in form to a GARCH(1,1) process, with non-negative scalars $a$ and $b$, and with: 
                              + $Q_{ij, t}$  the unconditional (sample) variance estimate between series $i$ and $j$,
                            + $\bar{Q}$  the unconditional matrix of standardized residuals from each univariate pair estimate.} 

We next use eq. \ref{dcc2} to estimate $R_t$ as: 
  
  \begin{align}\label{eq:dcc3}
R_t &= diag(Q_t)^{-1/2}Q_t.diag(Q_t)^{-1/2}. 
\end{align}

Which has bivariate elements:
  
  \begin{align}
R_t &= \rho_{ij,t} = \frac{q_{i,j,t}}{\sqrt{q_{ii,t}.q_{jj,t}}} 
\end{align}


The resulting DCC model is then formulated as:
  \begin{align}
\varepsilon_t &\thicksim  N(0,D_t.R_t.D_t) \notag \\
D_t^2 &\thicksim \text{Univariate GARCH(1,1) processes $\forall$ (i,j), i $\ne$ j} \notag \\
z_t&=D_t^{-1}.\varepsilon_t \notag \\
Q_t &= \bar{Q}(1-a-b)+a(z_t'z_t)+b(Q_{t-1}) \notag \\
                        R_t &= Diag(Q_t^{-1}).Q_t.Diag({Q_t}^{-1}) \notag \\
                        \end{align}
                        
                        Next, the ADCC allows for leverage effects in the above (think GJR GARCH..)
                        
                        
                        \begin{align}
                        \varepsilon_t &\thicksim  N(0,D_t.R_t.D_t) \notag \\
                        D_t^2 &\thicksim \text{Univariate GARCH(1,1) processes $\forall$ (i,j), i $\ne$ j} \notag \\
                        z_t&=D_t^{-1}.\varepsilon_t \notag \\
                        Q_t &= \bar{Q}(1-a-b-G)+a(z_t'z_t)+b(Q_{t-1}) + G'z_t^{-} z_t'^{-}G\notag \\
R_t &= Diag(Q_t^{-1}).Q_t.Diag({Q_t}^{-1}) \notag \\
\end{align}



Now fitting these techniques to our earlier data implies a two-step approach:
  
  * Fitting univariate GARCH models to each of our VAR series' residuals: $\alpha_t = z_t - \mu_t$. The volatility approximation series so estimated, $h_t$, will then be used in step 2.
* These vol series are then standardized $$\eta_{i,t} = \frac{\hat{\alpha_{i,t}}}{\hat{\sigma_{i,t}}}$$ and used in fitting a DCC model for $\eta_t$.