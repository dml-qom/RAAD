%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Convert the ranker lists to the opinion matrix O %
% Number of rows: number of rankers                %
% Number of columns: number of gene pairs          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [O,s,u] = convert2O(d)
  R = size(d,2);
  u = [];
  for i = 1:R
    u = [u;d{1,i}(:)];
  end
  u = unique(u);
  s = size(u,1);
  O = zeros(R, s*(s-1)/2);

  for k = 1:R
    n = 0;
    for i = 1:s-1
      for j = i+1:s
        n = n+1;
        fi = find(strcmp(d{1,k}(:),u(i)));
        fj = find(strcmp(d{1,k}(:),u(j)));
        if isempty(fi)
          fi = 0;    
        end
        if isempty(fj)
          fj = 0;    
        end  
        if (fi~=0 && fj~=0 && fi<fj)
          O(k,n) = 1;  
        elseif (fi~=0 && fj~=0 && fi>fj) 
          O(k,n) = 2;
        elseif (fi~=0 && fj==0)
          O(k,n) = 1;
        elseif (fi==0 && fj~=0)
          O(k,n) = 2; 
        elseif (fi==0 && fj==0)
          O(k,n) = 0;   
        end
      end
    end
  end