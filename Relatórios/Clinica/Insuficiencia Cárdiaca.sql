WITH LINTERN AS (
   SELECT HSP.HSP_NUM, 
          HSP.HSP_DTHRE,
          HSP.HSP_TRAT_INT
   FROM HSP 
   WHERE HSP.HSP_NUM <= 13 AND
         HSP.HSP_PAC = 161966
   ORDER BY HSP.HSP_NUM DESC
),
TOPTWO AS (
   SELECT HSP_NUM
   FROM (SELECT HSP_NUM, ROWNUM AS RN
         FROM LINTERN)
   WHERE RN <= 2
),
ADMTRAT AS(
   SELECT HSP_DTHRE
   FROM (SELECT HSP_DTHRE, 
                HSP_NUM, 
                HSP_TRAT_INT,
                ROWNUM AS RN
         FROM LINTERN
         WHERE HSP_TRAT_INT = 'T')
   WHERE RN <= 1 
)

SELECT PAC.PAC_REG,
       PAC.PAC_NOME,
       CTL.CTL_DTHR DTREGISTRO,  /* Data admissão =  Internamento */
       CTL.CTL_FC FREQCARD,      /* Registro do Paciente */
       CTL.CTL_RESP FREQRESP,
       CTL.CTL_TEMP TEMP,
       CTL.CTL_TAS PRESIS,
       CTL.CTL_TAD PREDIS,
       CTL.CTL_PAM PREMEDIA,
       CTL.CTL_GLIC GLICCAPILAR
FROM HSP
     
INNER JOIN PAC ON HSP.HSP_PAC = PAC.PAC_REG
     
INNER JOIN CTL ON PAC.PAC_REG = CTL.CTL_PAC AND HSP.HSP_NUM = CTL.CTL_HSP

WHERE HSP.HSP_PAC = 161966 AND
      HSP.HSP_NUM IN (SELECT HSP_NUM FROM TOPTWO)
 AND 
      CTL.CTL_DTHR <= (SELECT HSP_DTHRE + INTERVAL '48' HOUR FROM ADMTRAT)
ORDER BY CTL.CTL_DTHR ASC


union all


SELECT CEX.CEX_DESCR, 
       SMART.F_RESULTADO_RCL(RCL.RCL_TXT, CEX.CEX_DSC_COD, CEX.CEX_ATR_NUM),
       CEX.CEX_SMK_COD
FROM OSM
     INNER JOIN SMM ON (OSM.OSM_SERIE = SMM.SMM_OSM_SERIE) AND (OSM.OSM_NUM = SMM.SMM_OSM)
     INNER JOIN CEX ON (SMM.SMM_COD = CEX.CEX_SMK_COD) AND (SMM.SMM_TPCOD = CEX.CEX_SMK_TIPO)
     INNER JOIN RCL ON (RCL.RCL_OSM_SERIE = OSM.OSM_SERIE) AND (RCL.RCL_OSM = OSM.OSM_NUM) AND (RCL.RCL_COD = SMM.SMM_COD)
WHERE SMM.SMM_HSP_NUM IN (SELECT HSP_NUM FROM LINTERN) AND 
      SMM.SMM_DT_RESULT <= (SELECT HSP_DTHRE + INTERVAL '48' HOUR FROM ADMTRAT) AND 
      SMM.SMM_EXEC <> 'C' AND 
      OSM.OSM_PAC = 161966 AND
      SMART.F_RESULTADO_RCL(RCL.RCL_TXT, CEX.CEX_DSC_COD, CEX.CEX_ATR_NUM) <> '?' AND 
      SMM.SMM_COD IN ('3697', '3888', '3801', '7042', '30163', '3858') 