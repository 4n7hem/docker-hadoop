import pandas as pd

df = pd.DataFrame(pd.read_csv("combined_output.csv"))

df = df.sort_values(by=['sum(count)'], ascending=False)
df.head(52).to_csv("saida1.csv", header=True, encoding="utf8")