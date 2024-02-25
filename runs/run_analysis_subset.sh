#!/bin/bash
set -Eeuo pipefail

# DATASET="/mnt/tank3/dolma-v1_5/*/*"
# DATA_NAME="dolma-v1_5"
# OUT_DIR="/mnt/tank3/results/"

DATASET="subset_duplicated.json.gz"
DATA_NAME="c4_0000_test2"
OUT_DIR="analysis2/"
TEXT_AND_URL_OVERLAPS="./wimbd/text_and_url_overlaps"

# if [ -z "$TEXT_AND_URL_OVERLAPS" ]; then
#     echo "hello"
# else
#     echo "bye"
# fi

# exit

# Summary
# ./bin/wimbd stats $DATASET --json | jq > $OUT_DIR/summary_$DATA_NAME.json

# Top-k
for n in 1 2
do  
    # echo $n
    # echo ${n}_${DATA_NAME}
    ./bin/wimbd topk $DATASET -n $n -k 20 --out $OUT_DIR/top${n}_${DATA_NAME}.jsonl
done

for n in 3 5 10
do
    ./bin/wimbd topk $DATASET -n $n -k 20 --out $OUT_DIR/top${n}_${DATA_NAME}.jsonl
done

./bin/wimbd topk $DATASET -n 100 -k 20 --out $OUT_DIR/top100_$DATA_NAME.jsonl

# Unique n-grmas
./bin/wimbd unique $DATASET -n 1


# Bot-k
./bin/wimbd botk $DATASET -n 1 -k 10000 --out ${OUT_DIR}/bot-1_c4.jsonl


# see how to get this to run
# Duplicates
# bash $TEXT_AND_URL_OVERLAPS/run_analysis.sh text_datasets.json data/benchmark url


# Length dist
./wimbd/sentence_lengths/run.sh $DATASET > $OUT_DIR/length_dist_$DATA_NAME.jsonl


# Domains distribution per token
bash wimbd/url_per_tok_counts/run.sh $DATASET > $OUT_DIR/url_tok_$DATA_NAME.jsonl


# # Domains distribution
bash wimbd/url_counts/run.sh $DATASET > $OUT_DIR/url_$DATA_NAME.jsonl


# # Scheme distribution
bash ./wimbd/scheme_counts/run.sh $DATASET > $OUT_DIR/scheme_$DATA_NAME.jsonl


# # High level domain
bash ./wimbd/high_level_domain_counts/run.sh $OUT_DIR/url_$DATA_NAME.jsonl > $OUT_DIR/high_level_domain_$DATA_NAME.jsonl


# # PII
s
# cannot work yet
# Profanity Taxonomy
# bash wimbd/profanity/run.sh $DATASET > /mnt/tank3/results/profanity_taxonomy_$DATA_NAME.jsonl

# cannot work yet
# Profanity Model
# bash wimbd/profanity/run.sh $DATASET > /mnt/tank3/results/profanity_model_$DATA_NAME.jsonl
