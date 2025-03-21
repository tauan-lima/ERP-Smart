CREATE VIEW DRE AS
SELECT ROUND(SUM((MAT.MAT_VLR_PM) + 
            HON.HON_VL1 + 
            HON.HON_VL2 + 
            HON.HON_VL4 + 
            HON.HON_VL6 + 
          ((HON.HON_PC1/100) * SMM.SMM_VLR) + 
          ((HON.HON_PC2/100) * SMM.SMM_VLR) + 
          ((HON.HON_PC4/100) * SMM.SMM_VLR) + 
          ((HON.HON_PC6/100) * SMM.SMM_VLR)),2) AS DRE_MAT_VLR,
        SMM.SMM_OSM_SERIE AS DRE_OSM_SERIE,
        SMM.SMM_OSM AS DRE_OSM
 
 
FROM SMM 
     INNER JOIN MAT ON (SMM.SMM_COD = MAT.MAT_SMK_COD) 
     INNER JOIN HON ON (SMM.SMM_HON_SEQ = HON.HON_SEQ)

WHERE SMM.SMM_EXEC <> 'C' AND
      SMM.SMM_OSM_SERIE > 123

GROUP BY SMM.SMM_OSM_SERIE,
         SMM.SMM_OSM