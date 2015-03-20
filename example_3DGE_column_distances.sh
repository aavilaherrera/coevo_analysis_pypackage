#!/bin/bash
# Example workflow for getting distances between alignment columns
# using structural models
#
#
# 3DGE - A2B2 heterocomplex

PDB='3DGE.pdb.gz'

CHAIN_L1='A'
#CHAIN_L2='B' #ignored for now
CHAIN_R1='C'
CHAIN_R2='D'

FA_L='HisKA.fa'
FA_R='RR.fa'

# map columns to alignment (note chain A has contacts with C and D) 
MAPL1="${FA_L%.fa}-${CHAIN_L1}.col_res_aa"
MAPR1="${FA_R%.fa}-${CHAIN_R1}.col_res_aa"
MAPR2="${FA_R%.fa}-${CHAIN_R2}.col_res_aa"

python map_column_to_resnum.py ${CHAIN_L1} ${PDB} ${FA_L} > ${MAPL1}
python map_column_to_resnum.py ${CHAIN_R1} ${PDB} ${FA_R} > ${MAPR1}
python map_column_to_resnum.py ${CHAIN_R2} ${PDB} ${FA_R} > ${MAPR2}

# get distances and map
DIST1="${PDB%.pdb*}.${CHAIN_L1}_${CHAIN_R1}.Cb.dist"
DIST2="${PDB%.pdb*}.${CHAIN_L1}_${CHAIN_R2}.Cb.dist"
MDIST="${PDB%.pdb*}.Cb.mindist"

python get_dists.py --chainL=${CHAIN_L1} --chainR=${CHAIN_R1} --mapL=${MAPL1} --mapR=${MAPR1} --dtype=Cb ${PDB} > ${DIST1}
python get_dists.py --chainL=${CHAIN_L1} --chainR=${CHAIN_R2} --mapL=${MAPL1} --mapR=${MAPR2} --dtype=Cb ${PDB} > ${DIST2}

python min_dists.py ${DIST1} ${DIST2} > ${MDIST}

