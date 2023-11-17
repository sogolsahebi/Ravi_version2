# Set the file path for the clinical merged data.

# Parse command line arguments for input, output, and annotation directory paths.
args <- commandArgs(trailingOnly = TRUE)
input_dir <- args[1]
output_dir <- args[2]


# Load the clinical merged data from the specified file path.
#path <- "C:/Users/sogol/OneDrive/Documents/BHK lab/Ravi/deleted repo/Ravi_version2/data/CLIN.txt"
#clin <- read.delim(path)

clin <- read.delim(file.path(input_dir, "CLIN.txt"))

# Extract unique patients and sort them.
patient <- sort(unique(clin$patient))

# Initialize a data frame for 'case' with the unique patients and default values
case <- as.data.frame(cbind(patient, rep(0, length(patient)), rep(0, length(patient)), rep(0, length(patient))))
colnames(case) <- c("patient", "snv", "cna", "expr")
rownames(case) <- patient

# Convert the case values to numeric.
case$snv <- as.numeric(as.character(case$snv))
case$cna <- as.numeric(as.character(case$cna))
case$expr <- as.numeric(as.character(case$expr))


# Load the RNA data
#path <- "C:/Users/sogol/OneDrive/Documents/BHK lab/Ravi/deleted repo/Ravi_version2/data/EXPR.txt.gz"
#expr <- read.csv(path, stringsAsFactors=FALSE , sep="\t" )

# Read the RNA-Seq data from the gct file.
expr <- read.csv(file.path(input_dir, "EXPR.txt.gz"), stringsAsFactors=FALSE , sep="\t" )

dim(expr)
colnames(expr)

# 1. Replace periods with hyphens
new_colnames <- gsub("\\.", "_", colnames(expr))
colnames(expr) <- new_colnames


# Check for any duplicate column names after renaming
duplicate_colnames <- colnames(expr)[duplicated(colnames(expr))]
print(duplicate_colnames)  # Should ideally print nothing if there are no duplicates

# Sort the row names of 'expr'
expr <- expr[sort(rownames(expr)),]

# Check the overlap of patient IDs between the 'expr' and 'clin' data
print(sum(colnames(expr) %in% clin$patient))

# Check the overlap of patient IDs between the 'case' and 'expr' data
sum(rownames(case) %in% colnames(expr))


# Update the 'expr' column in 'case' based on the presence of patient IDs in the 'expr' data
for(i in 1:nrow(case)) {
  if(rownames(case)[i] %in% colnames(expr)) {
    case$expr[i] = 1
  }
}

# Save the updated 'case' data frame to a CSV file
#path <- "C:/Users/sogol/OneDrive/Documents/BHK lab/Ravi/deleted repo/Ravi_version2/data/cased_sequenced.csv"
#write.table( case , path , quote=FALSE , sep=";" , col.names=TRUE , row.names=FALSE )

write.table( case , file=file.path(output_dir, "cased_sequenced.csv") , quote=FALSE , sep=";" , col.names=TRUE , row.names=FALSE )
