SEQ=test.fas

all: $(SEQ)_metadata.csv $(SEQ).contree

$(SEQ)_metadata.csv: $(SEQ) ./scripts/strip_data.sh ./scripts/add_lat_long.py
	@echo "Generating metadata file"
	./scripts/strip_data.sh $(SEQ) > metadata_tmp.csv
	./scripts/add_lat_long.py metadata_tmp.csv 1 > metadata.csv
	-rm metadata_tmp.csv
	
$(SEQ).contree: $(SEQ).mask
	FastTree $(SEQ).mask > $(SEQ).contree
	#iqtree-omp -s $(SEQ).mask -alrt 0 -nt 2

$(SEQ).mask: $(SEQ).afa
	@echo "Masking"
	trimal -in $(SEQ).afa -out $(SEQ).mask -automated1

$(SEQ).afa: $(SEQ)_clean.faa
	@echo "Aligning"
	mafft-linsi --thread -1 $(SEQ)_clean.faa > $(SEQ).afa

$(SEQ)_clean.faa: $(SEQ)
	@echo "Cleaning Accessions"
	awk -F '_' '/^>/ {print $$1}; !/^>/ {print}' $(SEQ) > $(SEQ)_clean.faa

clean:
	-rm $(SEQ)_clean.faa $(SEQ).* metadata.csv

