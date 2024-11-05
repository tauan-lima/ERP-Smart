SELECT EMP.EMP_NOME_FANTASIA, 
       EMP.EMP_CGC,
       CONCAT(EMP.EMP_COMP,' ', EMP.EMP_END_NUM),
       CDE.CDE_NOME, 
       EMP.EMP_CEP,
       EMP.EMP_FONE,
       CONVERT(VARCHAR,NFS.NFS_DT_VCTO,103), 
       SUM(SMM.SMM_QT),
       SMK.SMK_NOME,
       SMM.SMM_VLR, 
       SMM.SMM_VLR *  SUM(SMM.SMM_QT),
       EMP.EMP_IRRF_PADRAO,
       EMP.EMP_INSS_PADRAO,
       EMP.EMP_ISS_PADRAO,
       EMP.EMP_PIS_PADRAO,
       EMP.EMP_COFINS_PADRAO,
       EMP.EMP_CSSL_PADRAO
      
       
FROM NFS
     INNER JOIN EMP ON (NFS.NFS_EMP_COD = EMP.EMP_COD)
     INNER JOIN FAT ON (NFS.NFS_SERIE = FAT.FAT_NFS_SERIE) AND (NFS.NFS_TIPO = FAT.FAT_NFS_TIPO) AND (NFS.NFS_NUMERO = FAT.FAT_NFS_NUMERO)
     INNER JOIN SMM ON (FAT.FAT_SERIE = SMM.SMM_FAT_SERIE) AND (FAT.FAT_NUM =SMM.SMM_FAT)
     INNER JOIN SMK ON (SMM.SMM_COD = SMK.SMK_COD) AND (SMM.SMM_TPCOD = SMK.SMK_TIPO)
     LEFT JOIN CDE ON (EMP.EMP_CDE_COD = CDE.CDE_COD)

WHERE NFS.NFS_TIPO = 'NS' AND 
      NFS.NFS_SERIE = 'U' 

GROUP BY EMP.EMP_NOME_FANTASIA, 
       EMP.EMP_CGC,
       CONCAT(EMP.EMP_COMP,' ', EMP.EMP_END_NUM),
       CDE.CDE_NOME, 
       EMP.EMP_CEP,
       EMP.EMP_FONE,
       CONVERT(VARCHAR,NFS.NFS_DT_VCTO,103),
       SMM.SMM_COD,
       SMK.SMK_NOME,
       SMM.SMM_VLR,
       EMP.EMP_IRRF_PADRAO,
       EMP.EMP_INSS_PADRAO,
       EMP.EMP_ISS_PADRAO,
       EMP.EMP_PIS_PADRAO,
       EMP.EMP_COFINS_PADRAO,
       EMP.EMP_CSSL_PADRAO