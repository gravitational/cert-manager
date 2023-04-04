# Copyright 2023 The cert-manager Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# LICENSE_YEAR is the value which will be substituted into licenses when they're generated
# It would be possible to make this more dynamic, but there's seemingly no need:
# https://stackoverflow.com/a/2391555/1615417
# As such, this is hardcoded to avoid needless complexity
LICENSE_YEAR=2022

# Creates the boilerplate header for YAML files, assumed to be the same as the one in
# shell scripts (hence the use of boilerplate.sh.txt)
$(BINDIR)/scratch/license.yaml: hack/boilerplate/boilerplate.sh.txt | $(BINDIR)/scratch
	sed -e "s/YEAR/$(LICENSE_YEAR)/g" < $< > $@

# The references LICENSES file is 1.4MB at the time of writing. Bundling it into every container image
# seems wasteful in terms of bytes stored and bytes transferred on the wire just to add a file
# which presumably nobody will ever read or care about. Instead, just add a little footnote pointing
# to the cert-manager repo in case anybody actually decides that they care.
$(BINDIR)/scratch/license-footnote.yaml: | $(BINDIR)/scratch
	@echo -e "# To view licenses for cert-manager dependencies, see the LICENSES file in the\n# cert-manager repo: https://github.com/cert-manager/cert-manager/blob/$(GITCOMMIT)/LICENSES" > $@

$(BINDIR)/scratch/cert-manager.license: $(BINDIR)/scratch/license.yaml $(BINDIR)/scratch/license-footnote.yaml | $(BINDIR)/scratch
	cat $^ > $@

$(BINDIR)/scratch/cert-manager.licenses_notice: $(BINDIR)/scratch/license-footnote.yaml | $(BINDIR)/scratch
	cp $< $@

LICENSES $(BINDIR)/scratch/LATEST-LICENSES: go.mod go.sum | $(NEEDS_GO-LICENSES)
	$(GO-LICENSES) csv ./...  > $@

cmd/%/LICENSES $(BINDIR)/scratch/LATEST-LICENSES-%: cmd/%/go.mod cmd/%/go.sum | $(NEEDS_GO-LICENSES)
	cd cmd/$* && $(GO-LICENSES) csv ./...  > ../../$@

test/%/LICENSES $(BINDIR)/scratch/LATEST-LICENSES-%-tests: test/%/go.mod test/%/go.sum | $(NEEDS_GO-LICENSES)
	cd test/$* && $(GO-LICENSES) csv ./...  > ../../$@
