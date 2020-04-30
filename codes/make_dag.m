%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Greedy algorithm to estimate the acyclic %
% subgraph with the highest sum of weights %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function newFoundMat = make_dag(FoundMat)
  dd = digraph(FoundMat);
  newFoundMat = digraph(zeros(size(FoundMat)));
  [mx,maxidx] = sort(dd.Edges.Weight,'descend');
  ddeden = dd.Edges.EndNodes;
  for n = 1:max(maxidx)   
    i = ddeden(maxidx(n),:);
    nfm = addedge(newFoundMat,i(1,1),i(1,2),mx(n));
    if (isdag(nfm))
      newFoundMat = nfm;
    end
  end
  newFoundMat = full(adjacency(newFoundMat));
  