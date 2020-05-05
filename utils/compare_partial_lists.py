import pandas as pd
import numpy as np
from scipy.stats import kendalltau, spearmanr

def get_val(s, L):
    """ 
    Get the position of element s in list L.
    If the element is not available in the list, return 1 + maximum possible position.
    """
    if s in L:
        return L.index(s)
    return len(L)

def spearman_distance(list1, list2):
    """
    Spearman distance between two partial lists, list1 and list2.
    """
    dist = 0
    for s in set(list1 + list2):
        dist += np.abs(get_val(s, list1) - get_val(s, list2))        
    return dist

def kendall_distance(list1, list2, p=0):
    """
    Kendall distance between two partial lists, list1 and list2.
    If a pair (p,q) is available in one list but neither p nor q is in the other list, 
        the penalty p is added to the distance.
    """
    dist = 0
    S = set(list1 + list2)
    for s1 in S:
        for s2 in S - {s1}:
            if ((s1 not in list1) and (s2 not in list1)) or ((s1 not in list2) and (s2 not in list2)):
                dist += p
            else:
                v11 = get_val(s1, list1)
                v12 = get_val(s1, list2)
                v21 = get_val(s2, list1)
                v22 = get_val(s2, list2)
                if (v11-v21)*(v12-v22) < 0:
                    dist += 1
    return dist / 2 # each pair is considered twice

def spearman_correlation(list1, list2):
    return spearmanr(list1, list2).correlation

def kendall_correlation(list1, list2):
    return kendalltau(list1, list2).correlation