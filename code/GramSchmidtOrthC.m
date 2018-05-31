function C = GramSchmidtOrthC(C)

KA = size(C, 2);

for i = 1:KA
    w = C(:,i);
    w = w/(sqrt(w'*w)+eps);
    if i < KA
        V = C(:,i+1:KA);
        C(:,i+1:KA) = V - w*(w'*V);
    end
    C(:,i) = w;
end

end

