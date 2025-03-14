/*
Produção por Convênio - Relatório Mensal
Este relatório fornece uma visão detalhada da posição de faturamento mensal, permitindo a verificação dos valores produzidos em cada unidade hospitalar, categorizados por convênio.
*/

SELECT CNV.CNV_NOME,
       SUM(SMM.SMM_VLR) AS FATURAMENTO,
       RIGHT('0' + CONVERT(VARCHAR, DATEPART(MM, OSM.OSM_DTHR)), 2) +'/'+ CONVERT(VARCHAR, DATEPART(YYYY, OSM.OSM_DTHR)) AS COMPETENCIA
       

FROM OSM
     INNER JOIN CNV ON (OSM.OSM_CNV = CNV.CNV_COD)
     INNER JOIN SMM ON (OSM.OSM_SERIE = SMM.SMM_OSM_SERIE) AND (OSM.OSM_NUM = SMM.SMM_OSM)

WHERE OSM.OSM_DTHR >=  :DATA_INICIO AND --Filtro de data para trazer apenas um recorte
      OSM.OSM_DTHR <=  :DATA_FIM AND
      SMM.SMM_TIPO_FATURA = 'E' AND
      SMM.SMM_EXEC <> 'C'  AND
      SMM.SMM_SFAT <> 'C' AND 
      SMM.SMM_PACOTE IN (NULL, 'P') 

GROUP BY CNV.CNV_NOME, DATEPART(YYYY, OSM.OSM_DTHR), DATEPART(MM, OSM.OSM_DTHR)
HAVING (SUM(SMM.SMM_VLR))>0
ORDER BY CNV.CNV_NOME ASC, DATEPART(YYYY, OSM.OSM_DTHR) ASC, DATEPART(MM, OSM.OSM_DTHR) ASC
