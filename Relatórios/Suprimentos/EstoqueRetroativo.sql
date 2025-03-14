SELECT
    GMM.GMM_NOME,
    MAT.MAT_COD,
    MAT.MAT_DESC_RESUMIDA,
    CASE WHEN MAT.MAT_IND_FRACIONADO = 'S' THEN MAT.MAT_UNM_COD_ENTRADA ELSE MAT.MAT_UNM_COD_SAIDA END AS UNIDADE,
    CASE WHEN MAT.MAT_IND_FRACIONADO = 'S' 
         THEN (SUM(MMA.MMA_QTD * MMA.MMA_TIPO_ES_FATOR * -1 ) + (SELECT SUM(ETQ.ETQ_QUANTIDADE) FROM ETQ WHERE ETQ.ETQ_MAT_COD = MAT.MAT_COD)) / MAT.MAT_FAT_CONV_S_V 
         ELSE SUM(MMA.MMA_QTD * MMA.MMA_TIPO_ES_FATOR * -1 ) + (SELECT SUM(ETQ.ETQ_QUANTIDADE) FROM ETQ WHERE ETQ.ETQ_MAT_COD = MAT.MAT_COD) END AS SALDO_INICIAL,
     ROUND ( sum ( mma_valor * mma_tipo_es_fator * -1 ), 10 ) + (SELECT ROUND(SUM( CASE WHEN etq.etq_cml_preco_medio is null THEN 0 ELSE etq.etq_cml_preco_medio END * etq.etq_quantidade ), 10 ) FROM ETQ WHERE ETQ.ETQ_MAT_COD = MAT.MAT_COD)
    
FROM
    MMA
    INNER JOIN MAT ON (MAT.MAT_COD = MMA.MMA_MAT_COD)
    INNER JOIN GMM ON (MAT.MAT_GMM_COD = GMM.GMM_COD)
WHERE
    MMA.MMA_DATA_MOV >= '2024-12-01 11:00:00' /* AND
    MAT.MAT_COD = '745264693' */
GROUP BY
    GMM.GMM_NOME,
    MAT.MAT_COD,
    MAT.MAT_DESC_RESUMIDA, 
    MAT.MAT_IND_FRACIONADO,
    MAT.MAT_UNM_COD_ENTRADA,
    MAT.MAT_UNM_COD_SAIDA,
    MAT.MAT_FAT_CONV_S_V 
HAVING (SUM(MMA.MMA_QTD * MMA.MMA_TIPO_ES_FATOR * -1 ) + (SELECT SUM(ETQ.ETQ_QUANTIDADE) FROM ETQ WHERE ETQ.ETQ_MAT_COD = MAT.MAT_COD)) > 0
ORDER BY
    GMM.GMM_NOME ASC,
    MAT.MAT_DESC_RESUMIDA ASC
