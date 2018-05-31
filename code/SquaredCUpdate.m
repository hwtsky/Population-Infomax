function [C, objhistory] = SquaredCUpdate(C, X, param)

    [KX, SampleNum] = size(X);
    KA = KX;
    % ---------------------------------------------------------------------
    MaxIter = param.MaxIter;
    mu = param.mu;
    eta = param.eta;
    beta = param.beta;
    nuInit = param.nuInit;
    nuFinal = param.nuFinal;
    tao = param.tao;
    Jmax = param.Jmax;

    %% --------------------------------------------------------------------
    C = GramSchmidtOrthC(C')'; % a Gram-Schmidt orthonormalization process for row vectors of matrix C
    
    F = 1./(1 + exp(-beta*(C'*X) + mu));
    gd = sqrt(eta)*beta*sqrt(F).*(1 - F);%
    
    Lgd = mean(log(gd + eps), 2);
    obj = - sum(Lgd);%

    C2 = C*C'; 
    Omg = .5*beta*(1-3*F);
    dQ = -(1/SampleNum)*C2*(X*Omg');% Multiplied by C2 can accelerate convergence.
    
    %% ----------------------------------------------------------------
    objhistory = [];%
    nu_t = nuInit;
    
    t_start = clock;
    for t = 1:MaxIter
        %% ----------------------------------------------------------------
        
        dC = dQ - C*dQ'*C;%
        
        nu_t = max([nu_t, nuFinal]);

        dc2 = sqrt(sum(dC.*dC,1));
        dcmean = mean(dc2);
        
        dC = dC/(dcmean + eps);% 
        
        if t == 1
            JT = 3*Jmax;% for the convenience of adaptive to quickly find a right initial nu
        else
            JT = Jmax;
        end


        obj0 = obj;%
        
        for j = 1:JT 
            
            Cj = C - nu_t*dC;
            
            Cj = GramSchmidtOrthC(Cj')';

            F = 1./(1 + exp(-beta*(Cj'*X) + mu));
            gd = sqrt(eta)*beta*sqrt(F).*(1 - F);%

            Lgd = mean(log(gd + eps), 2);
            obj = - sum(Lgd);%
            
            if j < JT
                if (obj - obj0) >= 0%
                    nu_t = tao*nu_t;
                else
                    break;
                end
            end
        end
        
        C = Cj;% 
        
        %% ----------------------------------------------------------------

        C2 = C*C'; 
        Omg = .5*beta*(1-3*F);
        dQ = -(1/SampleNum)*C2*(X*Omg');% Multiplied by C2 can accelerate convergence.
        
        DObj = obj - obj0;
        % -----------------------------------------------------------------
            
        objhistory = [objhistory; obj];%
        e_time = etime(clock, t_start)/60;
        
        fprintf('[%d/%d]: obj = %.3f, DObj = %.2e, j = %d, nu_t = %.2e, KA = %d, elapsed time = %.3fm\n',...
            t, MaxIter, obj, DObj, j, nu_t, KA, e_time);
        
    end
    
    %----------------------------------------------------------------------
end
