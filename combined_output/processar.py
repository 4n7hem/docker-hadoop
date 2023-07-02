import pandas as pd

df = pd.DataFrame(pd.read_csv("combined_output.csv"))

df = df.sort_values(by=['sum(count)'], ascending=False)
print(df.head(52))