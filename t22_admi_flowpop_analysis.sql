-- ============================================================================
-- t22_admi_flowpop (행정동 유동인구) — 결측치 / 이상치 / 고유값 분석 SQL
-- ============================================================================

-- ────────────────────────────────────────────────────────────────────────────
-- 1. 결측치 (Missing Values) 분석
-- ────────────────────────────────────────────────────────────────────────────
SELECT
    COUNT(*)                                                   AS 전체_건수,
    -- BIGINT
    SUM(CASE WHEN ADMI_CD   IS NULL THEN 1 ELSE 0 END)        AS ADMI_CD_결측,
    SUM(CASE WHEN TIME_CD   IS NULL THEN 1 ELSE 0 END)        AS TIME_CD_결측,
    SUM(CASE WHEN ETL_YMD   IS NULL THEN 1 ELSE 0 END)        AS ETL_YMD_결측,
    -- VARCHAR
    SUM(CASE WHEN CTY_NM    IS NULL OR TRIM(CTY_NM)='' THEN 1 ELSE 0 END)  AS CTY_NM_결측,
    SUM(CASE WHEN ADMI_NM   IS NULL OR TRIM(ADMI_NM)='' THEN 1 ELSE 0 END) AS ADMI_NM_결측,
    SUM(CASE WHEN FORN_GB   IS NULL OR TRIM(FORN_GB)='' THEN 1 ELSE 0 END) AS FORN_GB_결측,
    -- DOUBLE (남성)
    SUM(CASE WHEN M_10_CNT  IS NULL THEN 1 ELSE 0 END)        AS M_10_CNT_결측,
    SUM(CASE WHEN M_15_CNT  IS NULL THEN 1 ELSE 0 END)        AS M_15_CNT_결측,
    SUM(CASE WHEN M_20_CNT  IS NULL THEN 1 ELSE 0 END)        AS M_20_CNT_결측,
    SUM(CASE WHEN M_25_CNT  IS NULL THEN 1 ELSE 0 END)        AS M_25_CNT_결측,
    SUM(CASE WHEN M_30_CNT  IS NULL THEN 1 ELSE 0 END)        AS M_30_CNT_결측,
    SUM(CASE WHEN M_35_CNT  IS NULL THEN 1 ELSE 0 END)        AS M_35_CNT_결측,
    SUM(CASE WHEN M_40_CNT  IS NULL THEN 1 ELSE 0 END)        AS M_40_CNT_결측,
    SUM(CASE WHEN M_45_CNT  IS NULL THEN 1 ELSE 0 END)        AS M_45_CNT_결측,
    SUM(CASE WHEN M_50_CNT  IS NULL THEN 1 ELSE 0 END)        AS M_50_CNT_결측,
    SUM(CASE WHEN M_55_CNT  IS NULL THEN 1 ELSE 0 END)        AS M_55_CNT_결측,
    SUM(CASE WHEN M_60_CNT  IS NULL THEN 1 ELSE 0 END)        AS M_60_CNT_결측,
    SUM(CASE WHEN M_65_CNT  IS NULL THEN 1 ELSE 0 END)        AS M_65_CNT_결측,
    SUM(CASE WHEN M_70_CNT  IS NULL THEN 1 ELSE 0 END)        AS M_70_CNT_결측,
    -- DOUBLE (여성)
    SUM(CASE WHEN F_10_CNT  IS NULL THEN 1 ELSE 0 END)        AS F_10_CNT_결측,
    SUM(CASE WHEN F_15_CNT  IS NULL THEN 1 ELSE 0 END)        AS F_15_CNT_결측,
    SUM(CASE WHEN F_20_CNT  IS NULL THEN 1 ELSE 0 END)        AS F_20_CNT_결측,
    SUM(CASE WHEN F_25_CNT  IS NULL THEN 1 ELSE 0 END)        AS F_25_CNT_결측,
    SUM(CASE WHEN F_30_CNT  IS NULL THEN 1 ELSE 0 END)        AS F_30_CNT_결측,
    SUM(CASE WHEN F_35_CNT  IS NULL THEN 1 ELSE 0 END)        AS F_35_CNT_결측,
    SUM(CASE WHEN F_40_CNT  IS NULL THEN 1 ELSE 0 END)        AS F_40_CNT_결측,
    SUM(CASE WHEN F_45_CNT  IS NULL THEN 1 ELSE 0 END)        AS F_45_CNT_결측,
    SUM(CASE WHEN F_50_CNT  IS NULL THEN 1 ELSE 0 END)        AS F_50_CNT_결측,
    SUM(CASE WHEN F_55_CNT  IS NULL THEN 1 ELSE 0 END)        AS F_55_CNT_결측,
    SUM(CASE WHEN F_60_CNT  IS NULL THEN 1 ELSE 0 END)        AS F_60_CNT_결측,
    SUM(CASE WHEN F_65_CNT  IS NULL THEN 1 ELSE 0 END)        AS F_65_CNT_결측,
    SUM(CASE WHEN F_70_CNT  IS NULL THEN 1 ELSE 0 END)        AS F_70_CNT_결측
FROM t22_admi_flowpop;


-- 결측 비율 (%) 포함 — 세로 형태
SELECT '전체'      AS 구분, COUNT(*)                       AS 건수, NULL AS 결측비율 FROM t22_admi_flowpop
UNION ALL SELECT 'ADMI_CD',  SUM(CASE WHEN ADMI_CD  IS NULL THEN 1 ELSE 0 END), ROUND(SUM(CASE WHEN ADMI_CD  IS NULL THEN 1 ELSE 0 END)*100.0/COUNT(*),2) FROM t22_admi_flowpop
UNION ALL SELECT 'CTY_NM',   SUM(CASE WHEN CTY_NM   IS NULL OR TRIM(CTY_NM)='' THEN 1 ELSE 0 END), ROUND(SUM(CASE WHEN CTY_NM   IS NULL OR TRIM(CTY_NM)='' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) FROM t22_admi_flowpop
UNION ALL SELECT 'ADMI_NM',  SUM(CASE WHEN ADMI_NM  IS NULL OR TRIM(ADMI_NM)='' THEN 1 ELSE 0 END), ROUND(SUM(CASE WHEN ADMI_NM  IS NULL OR TRIM(ADMI_NM)='' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) FROM t22_admi_flowpop
UNION ALL SELECT 'TIME_CD',  SUM(CASE WHEN TIME_CD  IS NULL THEN 1 ELSE 0 END), ROUND(SUM(CASE WHEN TIME_CD  IS NULL THEN 1 ELSE 0 END)*100.0/COUNT(*),2) FROM t22_admi_flowpop
UNION ALL SELECT 'FORN_GB',  SUM(CASE WHEN FORN_GB  IS NULL OR TRIM(FORN_GB)='' THEN 1 ELSE 0 END), ROUND(SUM(CASE WHEN FORN_GB  IS NULL OR TRIM(FORN_GB)='' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) FROM t22_admi_flowpop
UNION ALL SELECT 'M_10_CNT', SUM(CASE WHEN M_10_CNT IS NULL THEN 1 ELSE 0 END), ROUND(SUM(CASE WHEN M_10_CNT IS NULL THEN 1 ELSE 0 END)*100.0/COUNT(*),2) FROM t22_admi_flowpop
UNION ALL SELECT 'M_15_CNT', SUM(CASE WHEN M_15_CNT IS NULL THEN 1 ELSE 0 END), ROUND(SUM(CASE WHEN M_15_CNT IS NULL THEN 1 ELSE 0 END)*100.0/COUNT(*),2) FROM t22_admi_flowpop
UNION ALL SELECT 'M_20_CNT', SUM(CASE WHEN M_20_CNT IS NULL THEN 1 ELSE 0 END), ROUND(SUM(CASE WHEN M_20_CNT IS NULL THEN 1 ELSE 0 END)*100.0/COUNT(*),2) FROM t22_admi_flowpop
UNION ALL SELECT 'ETL_YMD',  SUM(CASE WHEN ETL_YMD  IS NULL THEN 1 ELSE 0 END), ROUND(SUM(CASE WHEN ETL_YMD  IS NULL THEN 1 ELSE 0 END)*100.0/COUNT(*),2) FROM t22_admi_flowpop;


-- ────────────────────────────────────────────────────────────────────────────
-- 2. 이상치 (Outliers) 분석 — IQR 방식
--    유동인구 컬럼(DOUBLE)에 대해 Q1, Q3, IQR, 상한/하한, 이상치 건수
-- ────────────────────────────────────────────────────────────────────────────

-- 예시: M_10_CNT (모든 DOUBLE 컬럼에 동일 패턴 적용)
WITH stats AS (
    SELECT
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY M_10_CNT) AS q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY M_10_CNT) AS q3
    FROM t22_admi_flowpop
    WHERE M_10_CNT IS NOT NULL
)
SELECT
    'M_10_CNT'                                              AS 컬럼,
    MIN(t.M_10_CNT)                                         AS 최솟값,
    s.q1                                                    AS Q1,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY t.M_10_CNT) AS 중앙값,
    s.q3                                                    AS Q3,
    MAX(t.M_10_CNT)                                         AS 최댓값,
    (s.q3 - s.q1)                                           AS IQR,
    s.q1 - 1.5 * (s.q3 - s.q1)                             AS 하한,
    s.q3 + 1.5 * (s.q3 - s.q1)                             AS 상한,
    SUM(CASE WHEN t.M_10_CNT < s.q1 - 1.5*(s.q3-s.q1)
              OR  t.M_10_CNT > s.q3 + 1.5*(s.q3-s.q1)
         THEN 1 ELSE 0 END)                                AS 이상치_건수,
    ROUND(SUM(CASE WHEN t.M_10_CNT < s.q1 - 1.5*(s.q3-s.q1)
                    OR  t.M_10_CNT > s.q3 + 1.5*(s.q3-s.q1)
              THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2)    AS 이상치_비율,
    SUM(CASE WHEN t.M_10_CNT < 0 THEN 1 ELSE 0 END)       AS 음수_건수
FROM t22_admi_flowpop t, stats s
WHERE t.M_10_CNT IS NOT NULL
GROUP BY s.q1, s.q3;


-- ── 전체 DOUBLE 컬럼 이상치 일괄 분석 (UNION ALL 방식) ──
-- 아래 패턴을 26개 유동인구 컬럼에 반복 적용

WITH base AS (
    SELECT 'M_10_CNT' AS col_nm, M_10_CNT AS val FROM t22_admi_flowpop WHERE M_10_CNT IS NOT NULL
    UNION ALL SELECT 'M_15_CNT', M_15_CNT FROM t22_admi_flowpop WHERE M_15_CNT IS NOT NULL
    UNION ALL SELECT 'M_20_CNT', M_20_CNT FROM t22_admi_flowpop WHERE M_20_CNT IS NOT NULL
    UNION ALL SELECT 'M_25_CNT', M_25_CNT FROM t22_admi_flowpop WHERE M_25_CNT IS NOT NULL
    UNION ALL SELECT 'M_30_CNT', M_30_CNT FROM t22_admi_flowpop WHERE M_30_CNT IS NOT NULL
    UNION ALL SELECT 'M_35_CNT', M_35_CNT FROM t22_admi_flowpop WHERE M_35_CNT IS NOT NULL
    UNION ALL SELECT 'M_40_CNT', M_40_CNT FROM t22_admi_flowpop WHERE M_40_CNT IS NOT NULL
    UNION ALL SELECT 'M_45_CNT', M_45_CNT FROM t22_admi_flowpop WHERE M_45_CNT IS NOT NULL
    UNION ALL SELECT 'M_50_CNT', M_50_CNT FROM t22_admi_flowpop WHERE M_50_CNT IS NOT NULL
    UNION ALL SELECT 'M_55_CNT', M_55_CNT FROM t22_admi_flowpop WHERE M_55_CNT IS NOT NULL
    UNION ALL SELECT 'M_60_CNT', M_60_CNT FROM t22_admi_flowpop WHERE M_60_CNT IS NOT NULL
    UNION ALL SELECT 'M_65_CNT', M_65_CNT FROM t22_admi_flowpop WHERE M_65_CNT IS NOT NULL
    UNION ALL SELECT 'M_70_CNT', M_70_CNT FROM t22_admi_flowpop WHERE M_70_CNT IS NOT NULL
    UNION ALL SELECT 'F_10_CNT', F_10_CNT FROM t22_admi_flowpop WHERE F_10_CNT IS NOT NULL
    UNION ALL SELECT 'F_15_CNT', F_15_CNT FROM t22_admi_flowpop WHERE F_15_CNT IS NOT NULL
    UNION ALL SELECT 'F_20_CNT', F_20_CNT FROM t22_admi_flowpop WHERE F_20_CNT IS NOT NULL
    UNION ALL SELECT 'F_25_CNT', F_25_CNT FROM t22_admi_flowpop WHERE F_25_CNT IS NOT NULL
    UNION ALL SELECT 'F_30_CNT', F_30_CNT FROM t22_admi_flowpop WHERE F_30_CNT IS NOT NULL
    UNION ALL SELECT 'F_35_CNT', F_35_CNT FROM t22_admi_flowpop WHERE F_35_CNT IS NOT NULL
    UNION ALL SELECT 'F_40_CNT', F_40_CNT FROM t22_admi_flowpop WHERE F_40_CNT IS NOT NULL
    UNION ALL SELECT 'F_45_CNT', F_45_CNT FROM t22_admi_flowpop WHERE F_45_CNT IS NOT NULL
    UNION ALL SELECT 'F_50_CNT', F_50_CNT FROM t22_admi_flowpop WHERE F_50_CNT IS NOT NULL
    UNION ALL SELECT 'F_55_CNT', F_55_CNT FROM t22_admi_flowpop WHERE F_55_CNT IS NOT NULL
    UNION ALL SELECT 'F_60_CNT', F_60_CNT FROM t22_admi_flowpop WHERE F_60_CNT IS NOT NULL
    UNION ALL SELECT 'F_65_CNT', F_65_CNT FROM t22_admi_flowpop WHERE F_65_CNT IS NOT NULL
    UNION ALL SELECT 'F_70_CNT', F_70_CNT FROM t22_admi_flowpop WHERE F_70_CNT IS NOT NULL
),
stats AS (
    SELECT
        col_nm,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY val) AS q1,
        PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY val) AS median_val,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY val) AS q3,
        MIN(val) AS min_val,
        MAX(val) AS max_val,
        COUNT(*) AS cnt
    FROM base
    GROUP BY col_nm
)
SELECT
    s.col_nm                                           AS 컬럼,
    s.cnt                                              AS 건수,
    ROUND(s.min_val, 2)                                AS 최솟값,
    ROUND(s.q1, 2)                                     AS Q1,
    ROUND(s.median_val, 2)                             AS 중앙값,
    ROUND(s.q3, 2)                                     AS Q3,
    ROUND(s.max_val, 2)                                AS 최댓값,
    ROUND(s.q3 - s.q1, 2)                              AS IQR,
    ROUND(s.q1 - 1.5 * (s.q3 - s.q1), 2)              AS 하한,
    ROUND(s.q3 + 1.5 * (s.q3 - s.q1), 2)              AS 상한,
    (SELECT COUNT(*) FROM base b
     WHERE b.col_nm = s.col_nm
       AND (b.val < s.q1 - 1.5*(s.q3-s.q1) OR b.val > s.q3 + 1.5*(s.q3-s.q1))
    )                                                  AS 이상치_건수,
    ROUND((SELECT COUNT(*) FROM base b
           WHERE b.col_nm = s.col_nm
             AND (b.val < s.q1 - 1.5*(s.q3-s.q1) OR b.val > s.q3 + 1.5*(s.q3-s.q1))
          ) * 100.0 / s.cnt, 2)                        AS 이상치_비율,
    (SELECT COUNT(*) FROM base b
     WHERE b.col_nm = s.col_nm AND b.val < 0
    )                                                  AS 음수_건수
FROM stats s
ORDER BY s.col_nm;


-- ────────────────────────────────────────────────────────────────────────────
-- 3. 고유값 (Unique Values) 분석
-- ────────────────────────────────────────────────────────────────────────────

-- 3-1. 전체 컬럼 고유값 수
SELECT
    COUNT(DISTINCT ADMI_CD)   AS ADMI_CD_고유값,
    COUNT(DISTINCT CTY_NM)    AS CTY_NM_고유값,
    COUNT(DISTINCT ADMI_NM)   AS ADMI_NM_고유값,
    COUNT(DISTINCT TIME_CD)   AS TIME_CD_고유값,
    COUNT(DISTINCT FORN_GB)   AS FORN_GB_고유값,
    COUNT(DISTINCT ETL_YMD)   AS ETL_YMD_고유값,
    COUNT(DISTINCT M_10_CNT)  AS M_10_CNT_고유값,
    COUNT(DISTINCT M_20_CNT)  AS M_20_CNT_고유값,
    COUNT(DISTINCT F_10_CNT)  AS F_10_CNT_고유값,
    COUNT(DISTINCT F_20_CNT)  AS F_20_CNT_고유값
FROM t22_admi_flowpop;


-- 3-2. 범주형 컬럼 고유값 분포

-- CTY_NM (시군구명)
SELECT CTY_NM AS 시군구명, COUNT(*) AS 건수,
       ROUND(COUNT(*)*100.0 / (SELECT COUNT(*) FROM t22_admi_flowpop), 2) AS 비율
FROM t22_admi_flowpop
GROUP BY CTY_NM
ORDER BY 건수 DESC;

-- ADMI_NM (행정동명)
SELECT ADMI_NM AS 행정동명, COUNT(*) AS 건수,
       ROUND(COUNT(*)*100.0 / (SELECT COUNT(*) FROM t22_admi_flowpop), 2) AS 비율
FROM t22_admi_flowpop
GROUP BY ADMI_NM
ORDER BY 건수 DESC;

-- FORN_GB (내외국인 구분)
SELECT FORN_GB AS 내외국인구분, COUNT(*) AS 건수,
       ROUND(COUNT(*)*100.0 / (SELECT COUNT(*) FROM t22_admi_flowpop), 2) AS 비율
FROM t22_admi_flowpop
GROUP BY FORN_GB
ORDER BY 건수 DESC;

-- TIME_CD (시간대 코드)
SELECT TIME_CD AS 시간대코드, COUNT(*) AS 건수,
       ROUND(COUNT(*)*100.0 / (SELECT COUNT(*) FROM t22_admi_flowpop), 2) AS 비율
FROM t22_admi_flowpop
GROUP BY TIME_CD
ORDER BY TIME_CD;

-- ETL_YMD (기준일자)
SELECT ETL_YMD AS 기준일자, COUNT(*) AS 건수
FROM t22_admi_flowpop
GROUP BY ETL_YMD
ORDER BY ETL_YMD;

-- ADMI_CD (행정동 코드)
SELECT ADMI_CD AS 행정동코드, COUNT(*) AS 건수
FROM t22_admi_flowpop
GROUP BY ADMI_CD
ORDER BY 건수 DESC
LIMIT 30;


-- 3-3. 복합 키 고유성 검증 (ADMI_CD + TIME_CD + FORN_GB + ETL_YMD)
SELECT
    COUNT(*) AS 전체_건수,
    COUNT(DISTINCT CONCAT(ADMI_CD, '_', TIME_CD, '_', FORN_GB, '_', ETL_YMD)) AS 복합키_고유값,
    CASE
        WHEN COUNT(*) = COUNT(DISTINCT CONCAT(ADMI_CD, '_', TIME_CD, '_', FORN_GB, '_', ETL_YMD))
        THEN 'PK 후보 가능 (중복 없음)'
        ELSE 'PK 후보 불가 (중복 존재)'
    END AS PK_검증결과
FROM t22_admi_flowpop;
