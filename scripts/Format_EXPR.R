# RNA-seq Data Processing
# File: Format_EXPR.R

# Parse command line arguments for input, output, and annotation directory paths.
args <- commandArgs(trailingOnly = TRUE)
input_dir <- args[1]
output_dir <- args[2]

# Data Reading
# Define the path to open EXPR.txt.gz file.
#path <- "C:/Users/sogol/OneDrive/Documents/BHK lab/Ravi/Ravi_Test/data/EXPR.txt.gz"
#expr <- read.csv(path, stringsAsFactors=FALSE , sep="\t" )

# Read the RNA-Seq data from the gct file.
expr <- read.csv(file.path(input_dir, "EXPR.txt.gz"), stringsAsFactors=FALSE , sep="\t" )

# Data Cleaning
# Convert column names: replace periods with hyphens.
new_colnames <- gsub("\\.", "-", colnames(expr))


# Remove trailing -T1 or -T2 from column names
new_colnames <- gsub("-T1$|-T2$", "", new_colnames)
colnames(expr) <- new_colnames

colnames(expr)

# Data Filtering
# Define the path for the 'cased_sequenced.csv' file
#file_path <- "C:/Users/sogol/OneDrive/Documents/BHK lab/Ravi/Ravi_Test/data/cased_sequenced.csv"

# Read the 'case' dataset
#case <- read.csv(file_path, sep = ";")
case = read.csv( file.path(output_dir, "cased_sequenced.csv") , sep=";" )


# Filter the 'expr' dataset to include only patients with expr value of 1 in the 'case' dataset
expr <- expr[ , case[case$expr %in% 1,]$patient]


# Check the range of data values
range(expr)

# Data Transformation
# Convert TPM data to log2-TPM for consistency with other data formats
expr <- log2(expr + 0.001)

# Check the updated range of data values
range(expr)

# Data Export
# Define the output path for the cleaned data.
#file_path <- "C:/Users/sogol/OneDrive/Documents/BHK lab/Ravi/Ravi_version2/data/EXPR.csv"

# Write the cleaned 'expr' dataset to a CSV file.
#write.csv(expr, file_path, row.names = TRUE)

write.table( expr , file=file.path(output_dir, "EXPR.csv") , row.names=TRUE )
