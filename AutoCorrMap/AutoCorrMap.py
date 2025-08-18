#necessary libraries
import sys
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import warnings
warnings.filterwarnings("ignore")

#input file
input_file = sys.argv[1]
df=pd.read_csv(input_file, sep=",")


#isolation of numeric variables
corr = df.select_dtypes(include='number').corr()

#creation of the figure
fig, ax = plt.subplots(figsize=(15, 9))
sns.heatmap(corr, annot=True, linewidths=0.5, cmap="Spectral", ax=ax)
plt.tight_layout()
fig.savefig("CorrMap.png", dpi=300)