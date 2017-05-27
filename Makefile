SEQ=test.fasta

all: metadata.csv $(SEQ).phy

metadata.csv: $(SEQ)
	@echo "Generating metadata file"
	./scripts/strip_data.sh $(SEQ) > metadata_tmp.csv
	./scripts/add_lat_long.py metadata_tmp.csv 2 > metadata.csv
	rm metadata_tmp.csv
	
$(SEQ).phy: $(SEQ).mask $(SEQ).model
	@echo "ML Tree"
	raxmlHPC-SSE3 -f a -p 42 -x 42 -# 100 -s $(SEQ).mask -m $(cat $(SEQ).model) -n $(SEQ).phy

$(SEQ).model: $(SEQ).mask
	@echo "Model Fitting"
	./prottest3/dist/prottest3 -i $(SEQ).mask -F -BIC > $(SEQ).model

$(SEQ).mask: $(SEQ).afa
	@echo "Masking"
	trimal -in $(SEQ).afa -out $(SEQ).mask -automated1

$(SEQ).afa: $(SEQ)_clean.faa
	@echo "Aligning"
	mafft-linsi --thread -1 $(SEQ)_clean.faa > $(SEQ).afa

$(SEQ)_clean.faa: $(SEQ)
	@echo "Cleaning Accessions"
	awk -F '_' '/^>/ {print $1}; !/^>/ {print}' $(SEQ) > $(SEQ)_clean.faa

