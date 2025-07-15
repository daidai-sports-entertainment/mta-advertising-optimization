# generate_preview.py
import pandas as pd

CSV_PATH = "datasets/turnstile_analytics_processed.csv"   
ROWS     = 10                                          

df = pd.read_csv(CSV_PATH, nrows=ROWS)
# markdown
print(f"### Preview of `{CSV_PATH}` (first {ROWS} rows)\n")
print(df.to_markdown(index=False))
