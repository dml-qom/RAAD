%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Optimization algorithm to estimate accuracies       %
% in a way that empirical disagreement probabilities  %
% be as close as possible to analytical probabilities %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function res = fine_optimization(R,P2,stepValue)
    curInd = 0;
    for i = 1:R
        cont = [P2(i, 1:i-1) P2(i,i+1:R)];
        mn = min(min(cont, 1-cont));
        mx = max(max(cont, 1-cont));
        vals = [0:stepValue:mn mx:stepValue:1];
        for ind = 1:numel(vals)
            curInd = curInd+1;
            temp(:,curInd) = zeros(R,1);
            temp(i,curInd) = vals(ind);
            for j = 1:R
                if (i~=j)
                    temp(j,curInd) = (P2(i,j)-temp(i,curInd))/(1-2*temp(i,curInd));
                end
            end
            err(curInd) = 0;
            for j=1:R
                for k=j+1:R
                    if ((j~=i) && (k~=i))
                        err(curInd) = err(curInd) + (temp(j,curInd)+temp(k,curInd)-2*temp(j,curInd)*temp(k,curInd)-P2(j,k))^2;
                    end
                end
            end
            err(curInd) = sqrt(err(curInd));
        end
    end

    [err, errInd] = sort(err);
    res = temp(:,errInd(1));