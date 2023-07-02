import pandas as pd

df = pd.DataFrame(pd.read_csv("combined_tokens.csv"))

df = df.sort_values(by=['sum(count)'], ascending=False)
df.head(52).to_csv("saida2.csv", header=True, encoding="utf8")