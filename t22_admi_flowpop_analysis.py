"""
t22_admi_flowpop (행정동 유동인구) 테이블 - 결측치 / 이상치 / 고유값 분석
==========================================================================
사용법:
  1) CSV 파일: python t22_admi_flowpop_analysis.py --csv data.csv
  2) DB 연결:  python t22_admi_flowpop_analysis.py --db "postgresql://user:pw@host/db"
"""

import argparse
import sys
import warnings
import numpy as np
import pandas as pd

warnings.filterwarnings("ignore")

# ── 컬럼 정의 ──────────────────────────────────────────────────────────
COLUMNS = {
    "ADMI_CD":   {"dtype": "BIGINT",  "desc": "행정동 코드"},
    "CTY_NM":    {"dtype": "VARCHAR", "desc": "시군구명"},
    "ADMI_NM":   {"dtype": "VARCHAR", "desc": "행정동명"},
    "TIME_CD":   {"dtype": "BIGINT",  "desc": "시간대 코드"},
    "FORN_GB":   {"dtype": "VARCHAR", "desc": "내외국인 구분"},
    "M_10_CNT":  {"dtype": "DOUBLE",  "desc": "남성 10대 유동인구"},
    "M_15_CNT":  {"dtype": "DOUBLE",  "desc": "남성 15~19세 유동인구"},
    "M_20_CNT":  {"dtype": "DOUBLE",  "desc": "남성 20대 유동인구"},
    "M_25_CNT":  {"dtype": "DOUBLE",  "desc": "남성 25~29세 유동인구"},
    "M_30_CNT":  {"dtype": "DOUBLE",  "desc": "남성 30대 유동인구"},
    "M_35_CNT":  {"dtype": "DOUBLE",  "desc": "남성 35~39세 유동인구"},
    "M_40_CNT":  {"dtype": "DOUBLE",  "desc": "남성 40대 유동인구"},
    "M_45_CNT":  {"dtype": "DOUBLE",  "desc": "남성 45~49세 유동인구"},
    "M_50_CNT":  {"dtype": "DOUBLE",  "desc": "남성 50대 유동인구"},
    "M_55_CNT":  {"dtype": "DOUBLE",  "desc": "남성 55~59세 유동인구"},
    "M_60_CNT":  {"dtype": "DOUBLE",  "desc": "남성 60대 유동인구"},
    "M_65_CNT":  {"dtype": "DOUBLE",  "desc": "남성 65~69세 유동인구"},
    "M_70_CNT":  {"dtype": "DOUBLE",  "desc": "남성 70대 이상 유동인구"},
    "F_10_CNT":  {"dtype": "DOUBLE",  "desc": "여성 10대 유동인구"},
    "F_15_CNT":  {"dtype": "DOUBLE",  "desc": "여성 15~19세 유동인구"},
    "F_20_CNT":  {"dtype": "DOUBLE",  "desc": "여성 20대 유동인구"},
    "F_25_CNT":  {"dtype": "DOUBLE",  "desc": "여성 25~29세 유동인구"},
    "F_30_CNT":  {"dtype": "DOUBLE",  "desc": "여성 30대 유동인구"},
    "F_35_CNT":  {"dtype": "DOUBLE",  "desc": "여성 35~39세 유동인구"},
    "F_40_CNT":  {"dtype": "DOUBLE",  "desc": "여성 40대 유동인구"},
    "F_45_CNT":  {"dtype": "DOUBLE",  "desc": "여성 45~49세 유동인구"},
    "F_50_CNT":  {"dtype": "DOUBLE",  "desc": "여성 50대 유동인구"},
    "F_55_CNT":  {"dtype": "DOUBLE",  "desc": "여성 55~59세 유동인구"},
    "F_60_CNT":  {"dtype": "DOUBLE",  "desc": "여성 60대 유동인구"},
    "F_65_CNT":  {"dtype": "DOUBLE",  "desc": "여성 65~69세 유동인구"},
    "F_70_CNT":  {"dtype": "DOUBLE",  "desc": "여성 70대 이상 유동인구"},
    "ETL_YMD":   {"dtype": "BIGINT",  "desc": "기준일자"},
}

NUMERIC_COLS = [c for c, v in COLUMNS.items() if v["dtype"] == "DOUBLE"]
BIGINT_COLS  = [c for c, v in COLUMNS.items() if v["dtype"] == "BIGINT"]
VARCHAR_COLS = [c for c, v in COLUMNS.items() if v["dtype"] == "VARCHAR"]

TABLE_NAME = "t22_admi_flowpop"


# ── 데이터 로드 ───────────────────────────────────────────────────────
def load_data(args):
    if args.csv:
        df = pd.read_csv(args.csv, low_memory=False)
    elif args.db:
        from sqlalchemy import create_engine
        engine = create_engine(args.db)
        df = pd.read_sql_table(TABLE_NAME, engine)
    else:
        print("ERROR: --csv 또는 --db 옵션을 지정하세요.")
        sys.exit(1)

    # 컬럼명 대문자 통일
    df.columns = [c.upper() for c in df.columns]
    return df


# ── 1. 결측치 분석 ────────────────────────────────────────────────────
def analyze_missing(df):
    print("\n" + "=" * 80)
    print("1. 결측치 (Missing Values) 분석")
    print("=" * 80)

    total_rows = len(df)
    print(f"\n전체 레코드 수: {total_rows:,}\n")

    results = []
    for col in COLUMNS:
        if col not in df.columns:
            results.append({
                "컬럼": col,
                "설명": COLUMNS[col]["desc"],
                "결측 수": "컬럼 없음",
                "결측 비율(%)": "-",
                "비결측 수": "-",
            })
            continue
        null_cnt = df[col].isna().sum()
        # 빈 문자열도 결측으로 처리 (VARCHAR)
        if COLUMNS[col]["dtype"] == "VARCHAR":
            null_cnt += (df[col].astype(str).str.strip() == "").sum() - df[col].isna().sum()
            null_cnt = max(null_cnt, 0)
        results.append({
            "컬럼": col,
            "설명": COLUMNS[col]["desc"],
            "결측 수": f"{int(null_cnt):,}",
            "결측 비율(%)": f"{null_cnt / total_rows * 100:.2f}",
            "비결측 수": f"{int(total_rows - null_cnt):,}",
        })

    result_df = pd.DataFrame(results)
    print(result_df.to_string(index=False))

    # 결측치가 있는 컬럼 요약
    missing_cols = [r for r in results if r["결측 수"] not in ("0", "컬럼 없음")]
    print(f"\n▶ 결측치가 존재하는 컬럼 수: {len(missing_cols)} / {len(COLUMNS)}")
    if missing_cols:
        for m in missing_cols:
            print(f"  - {m['컬럼']} ({m['설명']}): {m['결측 수']}건 ({m['결측 비율(%)']}%)")
    else:
        print("  → 결측치 없음 (모든 컬럼 완전)")

    return result_df


# ── 2. 이상치 분석 (IQR 방식 + 음수 검증) ─────────────────────────────
def analyze_outliers(df):
    print("\n" + "=" * 80)
    print("2. 이상치 (Outliers) 분석 — IQR 방식 (Q1-1.5*IQR ~ Q3+1.5*IQR)")
    print("=" * 80)

    results = []
    for col in NUMERIC_COLS:
        if col not in df.columns:
            continue
        s = df[col].dropna()
        if s.empty:
            continue

        q1 = s.quantile(0.25)
        q3 = s.quantile(0.75)
        iqr = q3 - q1
        lower = q1 - 1.5 * iqr
        upper = q3 + 1.5 * iqr
        outlier_mask = (s < lower) | (s > upper)
        outlier_cnt = outlier_mask.sum()
        negative_cnt = (s < 0).sum()

        results.append({
            "컬럼": col,
            "설명": COLUMNS[col]["desc"],
            "최솟값": f"{s.min():.2f}",
            "Q1": f"{q1:.2f}",
            "중앙값": f"{s.median():.2f}",
            "Q3": f"{q3:.2f}",
            "최댓값": f"{s.max():.2f}",
            "IQR": f"{iqr:.2f}",
            "하한": f"{lower:.2f}",
            "상한": f"{upper:.2f}",
            "이상치 수": f"{int(outlier_cnt):,}",
            "이상치 비율(%)": f"{outlier_cnt / len(s) * 100:.2f}",
            "음수 건수": int(negative_cnt),
        })

    if results:
        result_df = pd.DataFrame(results)
        print(f"\n{'─' * 40} 수치형(DOUBLE) 컬럼 {'─' * 40}")
        print(result_df.to_string(index=False))

        # 이상치 요약
        outlier_cols = [r for r in results if r["이상치 수"] != "0"]
        print(f"\n▶ 이상치가 존재하는 컬럼 수: {len(outlier_cols)} / {len(results)}")
        for o in outlier_cols:
            print(f"  - {o['컬럼']} ({o['설명']}): {o['이상치 수']}건 ({o['이상치 비율(%)']}%)")

        # 음수 검증 (유동인구는 음수가 될 수 없음)
        neg_cols = [r for r in results if r["음수 건수"] > 0]
        if neg_cols:
            print(f"\n⚠ 음수 값이 존재하는 컬럼 (유동인구는 0 이상이어야 함):")
            for n in neg_cols:
                print(f"  - {n['컬럼']}: {n['음수 건수']}건")
        else:
            print("\n  → 음수 값 없음 (정상)")
    else:
        print("\n  분석 대상 수치형 컬럼이 없습니다.")

    # BIGINT 컬럼 이상치
    print(f"\n{'─' * 40} 정수형(BIGINT) 컬럼 {'─' * 40}")
    for col in BIGINT_COLS:
        if col not in df.columns:
            continue
        s = df[col].dropna()
        if s.empty:
            continue
        print(f"\n  [{col}] {COLUMNS[col]['desc']}")
        print(f"    최솟값: {int(s.min()):,}  |  최댓값: {int(s.max()):,}  "
              f"|  고유값 수: {s.nunique():,}  |  결측: {df[col].isna().sum():,}")
        if col == "ADMI_CD":
            # 행정동 코드 자릿수 검증 (보통 10자리)
            digit_counts = s.astype(str).str.len().value_counts().sort_index()
            print(f"    자릿수 분포: {dict(digit_counts)}")
        elif col == "TIME_CD":
            print(f"    고유 시간대: {sorted(s.unique().tolist())}")
        elif col == "ETL_YMD":
            print(f"    기준일자 범위: {int(s.min())} ~ {int(s.max())}")


# ── 3. 고유값 분석 ────────────────────────────────────────────────────
def analyze_unique(df):
    print("\n" + "=" * 80)
    print("3. 고유값 (Unique Values) 분석")
    print("=" * 80)

    total_rows = len(df)

    # 전체 컬럼 고유값 수
    print(f"\n{'─' * 40} 전체 컬럼 고유값 요약 {'─' * 40}\n")
    summary = []
    for col in COLUMNS:
        if col not in df.columns:
            continue
        nunique = df[col].nunique(dropna=True)
        summary.append({
            "컬럼": col,
            "설명": COLUMNS[col]["desc"],
            "타입": COLUMNS[col]["dtype"],
            "고유값 수": f"{nunique:,}",
            "고유값 비율(%)": f"{nunique / total_rows * 100:.2f}" if total_rows else "-",
        })
    print(pd.DataFrame(summary).to_string(index=False))

    # VARCHAR 컬럼 상세 (카테고리형)
    print(f"\n{'─' * 40} 범주형(VARCHAR) 컬럼 상세 {'─' * 40}")
    for col in VARCHAR_COLS:
        if col not in df.columns:
            continue
        vc = df[col].value_counts(dropna=False)
        print(f"\n  [{col}] {COLUMNS[col]['desc']}  (고유값: {df[col].nunique():,}개)")
        if df[col].nunique() <= 50:
            for val, cnt in vc.items():
                label = val if pd.notna(val) else "(NULL)"
                print(f"    {label:30s} : {cnt:>10,}건 ({cnt / total_rows * 100:6.2f}%)")
        else:
            print(f"    상위 20개:")
            for val, cnt in vc.head(20).items():
                label = val if pd.notna(val) else "(NULL)"
                print(f"    {label:30s} : {cnt:>10,}건 ({cnt / total_rows * 100:6.2f}%)")
            print(f"    ... 외 {df[col].nunique() - 20:,}개")

    # BIGINT 컬럼 상세
    print(f"\n{'─' * 40} 정수형(BIGINT) 컬럼 상세 {'─' * 40}")
    for col in BIGINT_COLS:
        if col not in df.columns:
            continue
        nunique = df[col].nunique()
        print(f"\n  [{col}] {COLUMNS[col]['desc']}  (고유값: {nunique:,}개)")
        if nunique <= 30:
            vc = df[col].value_counts(dropna=False).sort_index()
            for val, cnt in vc.items():
                label = str(int(val)) if pd.notna(val) else "(NULL)"
                print(f"    {label:>15s} : {cnt:>10,}건")
        else:
            print(f"    범위: {int(df[col].min()):,} ~ {int(df[col].max()):,}")
            # 상위/하위 5개
            vc = df[col].value_counts(dropna=False)
            print(f"    최빈값 Top 5:")
            for val, cnt in vc.head(5).items():
                label = str(int(val)) if pd.notna(val) else "(NULL)"
                print(f"      {label:>15s} : {cnt:>10,}건")

    # 수치형 컬럼 분포
    print(f"\n{'─' * 40} 수치형(DOUBLE) 컬럼 분포 {'─' * 40}\n")
    num_cols_in_df = [c for c in NUMERIC_COLS if c in df.columns]
    if num_cols_in_df:
        desc = df[num_cols_in_df].describe().T
        desc.columns = ["개수", "평균", "표준편차", "최소", "25%", "50%", "75%", "최대"]
        print(desc.to_string())


# ── 메인 ──────────────────────────────────────────────────────────────
def main():
    parser = argparse.ArgumentParser(description="t22_admi_flowpop 결측치/이상치/고유값 분석")
    parser.add_argument("--csv", help="CSV 파일 경로")
    parser.add_argument("--db", help="SQLAlchemy DB 연결 문자열")
    args = parser.parse_args()

    df = load_data(args)
    print(f"\n📊 t22_admi_flowpop 데이터 품질 분석 리포트")
    print(f"{'=' * 80}")
    print(f"총 레코드 수: {len(df):,}  |  컬럼 수: {len(df.columns)}")
    print(f"{'=' * 80}")

    analyze_missing(df)
    analyze_outliers(df)
    analyze_unique(df)

    print(f"\n{'=' * 80}")
    print("분석 완료.")
    print(f"{'=' * 80}\n")


if __name__ == "__main__":
    main()
