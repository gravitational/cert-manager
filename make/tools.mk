# To make sure we use the right version of each tool, we put symlink in
# $(BINDIR)/tools, and the actual binaries are in $(BINDIR)/downloaded. When bumping
# the version of the tools, this symlink gets updated.

# Let's have $(BINDIR)/tools in front of the PATH so that we don't inavertedly
# pick up the wrong binary somewhere. Watch out, $(shell echo $$PATH) will
# still print the original PATH, since GNU make does not honor exported
# variables: https://stackoverflow.com/questions/54726457
export PATH := $(PWD)/$(BINDIR)/tools:$(PATH)

CTR=docker

TOOLS :=
TOOLS += helm=v3.11.1
TOOLS += kubectl=v1.26.0
TOOLS += kind=v0.17.0
TOOLS += controller-gen=v0.11.1
TOOLS += cosign=v1.12.1
TOOLS += cmrel=a1e2bad95be9688794fd0571c4c40e88cccf9173
TOOLS += release-notes=v0.14.0
TOOLS += goimports=v0.1.12
TOOLS += go-licenses=v1.5.0
TOOLS += gotestsum=v1.8.2
TOOLS += rclone=v1.59.2
TOOLS += trivy=v0.32.0
TOOLS += ytt=v0.43.0
TOOLS += yq=v4.27.5
TOOLS += crane=v0.11.0
TOOLS += ginkgo=$(shell awk '/ginkgo\/v2/ {print $$2}' go.mod)
TOOLS += ko=v0.12.0

# Version of Gateway API install bundle https://gateway-api.sigs.k8s.io/v1alpha2/guides/#installing-gateway-api
GATEWAY_API_VERSION=v0.5.1

K8S_CODEGEN_VERSION=v0.26.0

KUBEBUILDER_ASSETS_VERSION=1.26.0
TOOLS += etcd=$(KUBEBUILDER_ASSETS_VERSION)
TOOLS += kube-apiserver=$(KUBEBUILDER_ASSETS_VERSION)

VENDORED_GO_VERSION := 1.19.5

# When switching branches which use different versions of the tools, we
# need a way to re-trigger the symlinking from $(BINDIR)/downloaded to $(BINDIR)/tools.
$(BINDIR)/scratch/%_VERSION: FORCE | $(BINDIR)/scratch
	@test "$($*_VERSION)" == "$(shell cat $@ 2>/dev/null)" || echo $($*_VERSION) > $@

# The reason we don't use "go env GOOS" or "go env GOARCH" is that the "go"
# binary may not be available in the PATH yet when the Makefiles are
# evaluated. HOST_OS and HOST_ARCH only support Linux, *BSD and macOS (M1
# and Intel).
HOST_OS := $(shell uname -s | tr A-Z a-z)
HOST_ARCH = $(shell uname -m)

ifeq (x86_64, $(HOST_ARCH))
	HOST_ARCH = amd64
else ifeq (aarch64, $(HOST_ARCH))
	HOST_ARCH = arm64
endif

# --silent = don't print output like progress meters
# --show-error = but do print errors when they happen
# --fail = exit with a nonzero error code without the response from the server when there's an HTTP error
# --location = follow redirects from the server
# --retry = the number of times to retry a failed attempt to connect
# --retry-connrefused = retry even if the initial connection was refused
CURL = curl --silent --show-error --fail --location --retry 10 --retry-connrefused

# In Prow, the pod has the folder "$(BINDIR)/downloaded" mounted into the
# container. For some reason, even though the permissions are correct,
# binaries that are mounted with hostPath can't be executed. When in CI, we
# copy the binaries to work around that. Using $(LN) is only required when
# dealing with binaries. Other files and folders can be symlinked.
#
# Details on how "$(BINDIR)/downloaded" gets cached are available in the
# description of the PR https://github.com/jetstack/testing/pull/651.
#
# We use "printenv CI" instead of just "ifeq ($(CI),)" because otherwise we
# would get "warning: undefined variable 'CI'".
ifeq ($(shell printenv CI),)
LN := ln -f -s
else
LN := cp -f -r
endif

UC = $(shell echo '$1' | tr a-z A-Z)
LC = $(shell echo '$1' | tr A-Z a-z)

TOOL_NAMES :=

# for each item `xxx` in the TOOLS variable:
# - a $(XXX_VERSION) variable is generated
#     -> this variable contains the version of the tool
# - a $(NEEDS_XXX) variable is generated
#     -> this variable contains the target name for the tool,
#        which is the relative path of the binary, this target
#        should be used when adding the tool as a dependency to
#        your target, you can't use $(XXX) as a dependency because
#        make does not support an absolute path as a dependency
# - a $(XXX) variable is generated
#     -> this variable contains the absolute path of the binary,
#        the absolute path should be used when executing the binary
#        in targets or in scripts, because it is agnostic to the
#        working directory
# - an unversioned target $(BINDIR)/tools/xxx is generated that
#   creates a copy/ link to the corresponding versioned target:
#   $(BINDIR)/tools/xxx@$(XXX_VERSION)_$(HOST_OS)_$(HOST_ARCH)
define tool_defs
TOOL_NAMES += $1

$(call UC,$1)_VERSION ?= $2
NEEDS_$(call UC,$1) := $$(BINDIR)/tools/$1
$(call UC,$1) := $$(PWD)/$$(BINDIR)/tools/$1

$$(BINDIR)/tools/$1: $$(BINDIR)/scratch/$(call UC,$1)_VERSION | $$(BINDIR)/downloaded/tools/$1@$$($(call UC,$1)_VERSION)_$$(HOST_OS)_$$(HOST_ARCH) $$(BINDIR)/tools
	cd $$(dir $$@) && $$(LN) $$(patsubst $$(BINDIR)/%,../%,$$(word 1,$$|)) $$(notdir $$@)
endef

$(foreach TOOL,$(TOOLS),$(eval $(call tool_defs,$(word 1,$(subst =, ,$(TOOL))),$(word 2,$(subst =, ,$(TOOL))))))

TOOLS_PATHS := $(TOOL_NAMES:%=$(BINDIR)/tools/%)

######
# Go #
######

# $(NEEDS_GO) is a target that is set as an order-only prerequisite in
# any target that calls $(GO), e.g.:
#
#     $(BINDIR)/tools/crane: $(NEEDS_GO)
#         $(GO) build -o $(BINDIR)/tools/crane
#
# $(NEEDS_GO) is empty most of the time, except when running "make vendor-go"
# or when "make vendor-go" was previously run, in which case $(NEEDS_GO) is set
# to $(BINDIR)/tools/go, since $(BINDIR)/tools/go is a prerequisite of
# any target depending on Go when "make vendor-go" was run.
NEEDS_GO := $(if $(findstring vendor-go,$(MAKECMDGOALS))$(shell [ -f $(BINDIR)/tools/go ] && echo yes), $(BINDIR)/tools/go,)
ifeq ($(NEEDS_GO),)
GO := go
else
export GOROOT := $(PWD)/$(BINDIR)/tools/goroot
export PATH := $(PWD)/$(BINDIR)/tools/goroot/bin:$(PATH)
GO := $(PWD)/$(BINDIR)/tools/go
endif

GOBUILD := CGO_ENABLED=$(CGO_ENABLED) GOMAXPROCS=$(GOBUILDPROCS) $(GO) build
GOTEST := CGO_ENABLED=$(CGO_ENABLED) $(GO) test

# overwrite $(GOTESTSUM) and add CGO_ENABLED variable
GOTESTSUM := CGO_ENABLED=$(CGO_ENABLED) $(GOTESTSUM)

.PHONY: vendor-go
## By default, this Makefile uses the system's Go. You can use a "vendored"
## version of Go that will get downloaded by running this command once. To
## disable vendoring, run "make unvendor-go". When vendoring is enabled,
## you will want to set the following:
##
##     export PATH="$PWD/$(BINDIR)/tools:$PATH"
##     export GOROOT="$PWD/$(BINDIR)/tools/goroot"
vendor-go: $(BINDIR)/tools/go

.PHONY: unvendor-go
unvendor-go: $(BINDIR)/tools/go
	rm -rf $(BINDIR)/tools/go $(BINDIR)/tools/goroot

.PHONY: which-go
## Print the version and path of go which will be used for building and
## testing in Makefile commands. Vendored go will have a path in ./bin
which-go: |  $(NEEDS_GO)
	@$(GO) version
	@echo "go binary used for above version information: $(GO)"

# The "_" in "_go "prevents "go mod tidy" from trying to tidy the vendored
# goroot.
$(BINDIR)/tools/go: $(BINDIR)/downloaded/tools/_go-$(VENDORED_GO_VERSION)-$(HOST_OS)-$(HOST_ARCH)/goroot/bin/go $(BINDIR)/tools/goroot $(BINDIR)/scratch/VENDORED_GO_VERSION | $(BINDIR)/tools
	cd $(dir $@) && $(LN) $(patsubst $(BINDIR)/%,../%,$<) .
	@touch $@

$(BINDIR)/tools/goroot: $(BINDIR)/downloaded/tools/_go-$(VENDORED_GO_VERSION)-$(HOST_OS)-$(HOST_ARCH)/goroot $(BINDIR)/scratch/VENDORED_GO_VERSION | $(BINDIR)/tools
	@rm -rf $(BINDIR)/tools/goroot
	cd $(dir $@) && $(LN) $(patsubst $(BINDIR)/%,../%,$<) .
	@touch $@

$(BINDIR)/downloaded/tools/_go-$(VENDORED_GO_VERSION)-%/goroot $(BINDIR)/downloaded/tools/_go-$(VENDORED_GO_VERSION)-%/goroot/bin/go: $(BINDIR)/downloaded/tools/go-$(VENDORED_GO_VERSION)-%.tar.gz
	@mkdir -p $(dir $@)
	rm -rf $(BINDIR)/downloaded/tools/_go-$(VENDORED_GO_VERSION)-$*/goroot
	tar xzf $< -C $(BINDIR)/downloaded/tools/_go-$(VENDORED_GO_VERSION)-$*
	mv $(BINDIR)/downloaded/tools/_go-$(VENDORED_GO_VERSION)-$*/go $(BINDIR)/downloaded/tools/_go-$(VENDORED_GO_VERSION)-$*/goroot

$(BINDIR)/downloaded/tools/go-$(VENDORED_GO_VERSION)-%.tar.gz: | $(BINDIR)/downloaded/tools
	$(CURL) https://go.dev/dl/go$(VENDORED_GO_VERSION).$*.tar.gz -o $@

###################
# go dependencies #
###################

GO_DEPENDENCIES :=
GO_DEPENDENCIES += ginkgo=github.com/onsi/ginkgo/v2/ginkgo
GO_DEPENDENCIES += cmrel=github.com/cert-manager/release/cmd/cmrel
GO_DEPENDENCIES += release-notes=k8s.io/release/cmd/release-notes
GO_DEPENDENCIES += controller-gen=sigs.k8s.io/controller-tools/cmd/controller-gen
GO_DEPENDENCIES += goimports=golang.org/x/tools/cmd/goimports
GO_DEPENDENCIES += go-licenses=github.com/google/go-licenses
GO_DEPENDENCIES += gotestsum=gotest.tools/gotestsum
GO_DEPENDENCIES += crane=github.com/google/go-containerregistry/cmd/crane

define go_dependency
$$(BINDIR)/downloaded/tools/$1@$($(call UC,$1)_VERSION)_%: | $$(NEEDS_GO) $$(BINDIR)/downloaded/tools
	GOBIN=$$(PWD)/$$(dir $$@) $$(GO) install $2@$($(call UC,$1)_VERSION)
	@mv $$(PWD)/$$(dir $$@)/$1 $$@
endef

$(foreach GO_DEPENDENCY,$(GO_DEPENDENCIES),$(eval $(call go_dependency,$(word 1,$(subst =, ,$(GO_DEPENDENCY))),$(word 2,$(subst =, ,$(GO_DEPENDENCY))))))

########
# Helm #
########

HELM_linux_amd64_SHA256SUM=0b1be96b66fab4770526f136f5f1a385a47c41923d33aab0dcb500e0f6c1bf7c
HELM_darwin_amd64_SHA256SUM=2548a90e5cc957ccc5016b47060665a9d2cd4d5b4d61dcc32f5de3144d103826
HELM_darwin_arm64_SHA256SUM=43d0198a7a2ea2639caafa81bb0596c97bee2d4e40df50b36202343eb4d5c46b

$(BINDIR)/downloaded/tools/helm@$(HELM_VERSION)_%: | $(BINDIR)/downloaded/tools
	$(CURL) https://get.helm.sh/helm-$(HELM_VERSION)-$(subst _,-,$*).tar.gz -o $@.tar.gz
	./hack/util/checkhash.sh $@.tar.gz $(HELM_$*_SHA256SUM)
	@# O writes the specified file to stdout
	tar xfO $@.tar.gz $(subst _,-,$*)/helm > $@
	chmod +x $@
	rm -f $@.tar.gz

###########
# kubectl #
###########

KUBECTL_linux_amd64_SHA256SUM=b6769d8ac6a0ed0f13b307d289dc092ad86180b08f5b5044af152808c04950ae
KUBECTL_darwin_amd64_SHA256SUM=be9dc0782a7b257d9cfd66b76f91081e80f57742f61e12cd29068b213ee48abc
KUBECTL_darwin_arm64_SHA256SUM=cc7542dfe67df1982ea457cc6e15c171e7ff604a93b41796a4f3fa66bd151f76

$(BINDIR)/downloaded/tools/kubectl@$(KUBECTL_VERSION)_%: | $(BINDIR)/downloaded/tools
	$(CURL) https://storage.googleapis.com/kubernetes-release/release/$(KUBECTL_VERSION)/bin/$(subst _,/,$*)/kubectl -o $@
	./hack/util/checkhash.sh $@ $(KUBECTL_$*_SHA256SUM)
	chmod +x $@

########
# kind #
########

KIND_linux_amd64_SHA256SUM=a8c045856db33f839908b6acb90dc8ec397253ffdaef7baf058f5a542e009b9c
KIND_darwin_amd64_SHA256SUM=a4e9f4cf18ec762934f4acd68752fe085bcded3a736258de0367085525180342
KIND_darwin_arm64_SHA256SUM=b9afee2707e711fb5d39049a361972f8c44ee7ce6145cafd0f7e4b47ceec1409

$(BINDIR)/downloaded/tools/kind@$(KIND_VERSION)_%: | $(BINDIR)/downloaded/tools $(BINDIR)/tools
	$(CURL) -sSfL https://github.com/kubernetes-sigs/kind/releases/download/$(KIND_VERSION)/kind-$(subst _,-,$*) -o $@
	./hack/util/checkhash.sh $@ $(KIND_$*_SHA256SUM)
	chmod +x $@

##########
# cosign #
##########

COSIGN_linux_amd64_SHA256SUM=b30fdc7d9aab246bc2f6a760ed8eff063bd37935389302c963c07018e5d48a12
COSIGN_darwin_amd64_SHA256SUM=87a7e93b1539d988fefe0d00fd5a5a0e02ef43f5f977c2a701170c502a17980d
COSIGN_darwin_arm64_SHA256SUM=41bc69dae9f06f58e8e61446907b7e53a4db41ef341b235172d3745c937f1777

# TODO: cosign also provides signatures on all of its binaries, but they can't be validated without already having cosign
# available! We could do something like "if system cosign is available, verify using that", but for now we'll skip
$(BINDIR)/downloaded/tools/cosign@$(COSIGN_VERSION)_%: | $(BINDIR)/downloaded/tools
	$(CURL) https://github.com/sigstore/cosign/releases/download/$(COSIGN_VERSION)/cosign-$(subst _,-,$*) -o $@
	./hack/util/checkhash.sh $@ $(COSIGN_$*_SHA256SUM)
	chmod +x $@

##########
# rclone #
##########

RCLONE_linux_amd64_SHA256SUM=81e7be456369f5957713463e3624023e9159c1cae756e807937046ebc9394383
RCLONE_darwin_amd64_SHA256SUM=d0a70241212198566028cd3154c418e35cbe73a6cd22c2d851341e88cb650cb7
RCLONE_darwin_arm64_SHA256SUM=8b98893fa34aa790ae23dd2417e8c9a200326c05feb26101dff09cda479aeb1f

$(BINDIR)/downloaded/tools/rclone@$(RCLONE_VERSION)_%: | $(BINDIR)/downloaded/tools
	$(eval OS_AND_ARCH := $(subst darwin,osx,$*))
	$(CURL) https://github.com/rclone/rclone/releases/download/$(RCLONE_VERSION)/rclone-$(RCLONE_VERSION)-$(subst _,-,$(OS_AND_ARCH)).zip -o $@.zip
	./hack/util/checkhash.sh $@.zip $(RCLONE_$*_SHA256SUM)
	@# -p writes to stdout, the second file arg specifies the sole file we
	@# want to extract
	unzip -p $@.zip rclone-$(RCLONE_VERSION)-$(subst _,-,$(OS_AND_ARCH))/rclone > $@
	chmod +x $@
	rm -f $@.zip

#########
# trivy #
#########

TRIVY_linux_amd64_SHA256SUM=e6e1c4767881ab1e40da5f3bb499b1c9176892021c7cb209405078fc096d94d8
TRIVY_darwin_amd64_SHA256SUM=1cc8b2301f696b71c488d99c917a21a191ab26e1c093287c20112e8bb517ac4c
TRIVY_darwin_arm64_SHA256SUM=41a3d4c12cd227cf95db6b30144b85e571541f587837f2f3814e2339dd81a21a

$(BINDIR)/downloaded/tools/trivy@$(TRIVY_VERSION)_%: | $(BINDIR)/downloaded/tools
	$(eval OS_AND_ARCH := $(subst darwin,macOS,$*))
	$(eval OS_AND_ARCH := $(subst linux,Linux,$(OS_AND_ARCH)))
	$(eval OS_AND_ARCH := $(subst arm64,ARM64,$(OS_AND_ARCH)))
	$(eval OS_AND_ARCH := $(subst amd64,64bit,$(OS_AND_ARCH)))

	$(CURL) https://github.com/aquasecurity/trivy/releases/download/$(TRIVY_VERSION)/trivy_$(patsubst v%,%,$(TRIVY_VERSION))_$(subst _,-,$(OS_AND_ARCH)).tar.gz -o $@.tar.gz
	./hack/util/checkhash.sh $@.tar.gz $(TRIVY_$*_SHA256SUM)
	tar xfO $@.tar.gz trivy > $@
	chmod +x $@
	rm $@.tar.gz

#######
# ytt #
#######

YTT_linux_amd64_SHA256SUM=29e647beeacbcc2be5f2f481e405c73bcd6d7563bd229ff924a7997b6f2edd5f
YTT_darwin_amd64_SHA256SUM=579012ac80cc0d55c3a6dde2dfc0ff5bf8a4f74c775295be99faf691cc18595e
YTT_darwin_arm64_SHA256SUM=bd8781e76e833c848ecc80580b3588b4ce8f38d8697802ec83c07aae7cf7a66f

$(BINDIR)/downloaded/tools/ytt@$(YTT_VERSION)_%: | $(BINDIR)/downloaded/tools
	$(CURL) -sSfL https://github.com/vmware-tanzu/carvel-ytt/releases/download/$(YTT_VERSION)/ytt-$(subst _,-,$*) -o $@
	./hack/util/checkhash.sh $@ $(YTT_$*_SHA256SUM)
	chmod +x $@

######
# yq #
######

YQ_linux_amd64_SHA256SUM=9a54846e81720ae22814941905cd3b056ebdffb76bf09acffa30f5e90b22d615
YQ_darwin_amd64_SHA256SUM=79a55533b683c5eabdc35b00336aa4c107d7d719db0639a31892fc35d1436cdc
YQ_darwin_arm64_SHA256SUM=40547a5049f15a1103268fd871baaa34a31ad30136ee27a829cf697737f392be

$(BINDIR)/downloaded/tools/yq@$(YQ_VERSION)_%: | $(BINDIR)/downloaded/tools
	$(CURL) https://github.com/mikefarah/yq/releases/download/$(YQ_VERSION)/yq_$* -o $@
	./hack/util/checkhash.sh $@ $(YQ_$*_SHA256SUM)
	chmod +x $@

######
# ko #
######

KO_linux_amd64_SHA256SUM=05aa77182fa7c55386bd2a210fd41298542726f33bbfc9c549add3a66f7b90ad
KO_darwin_amd64_SHA256SUM=8679d0d74fc75f24e044649c6a961dad0a3ef03bedbdece35e2f3f29eb7876af
KO_darwin_arm64_SHA256SUM=cfef98db8ad0e1edaa483fa5c6af89eb573a8434abd372b510b89005575de702

$(BINDIR)/downloaded/tools/ko@$(KO_VERSION)_%: | $(BINDIR)/downloaded/tools
	$(eval OS_AND_ARCH := $(subst darwin,Darwin,$*))
	$(eval OS_AND_ARCH := $(subst linux,Linux,$(OS_AND_ARCH)))
	$(eval OS_AND_ARCH := $(subst amd64,x86_64,$(OS_AND_ARCH)))

	$(CURL) https://github.com/ko-build/ko/releases/download/$(KO_VERSION)/ko_$(patsubst v%,%,$(KO_VERSION))_$(OS_AND_ARCH).tar.gz -o $@.tar.gz
	./hack/util/checkhash.sh $@.tar.gz $(KO_$*_SHA256SUM)
	tar xfO $@.tar.gz ko > $@
	chmod +x $@
	rm $@.tar.gz

#####################
# k8s codegen tools #
#####################

K8S_CODEGEN_TOOLS := client-gen conversion-gen deepcopy-gen defaulter-gen informer-gen lister-gen
K8S_CODEGEN_TOOLS_PATHS := $(K8S_CODEGEN_TOOLS:%=$(BINDIR)/tools/%)
K8S_CODEGEN_TOOLS_DOWNLOADS := $(K8S_CODEGEN_TOOLS:%=$(BINDIR)/downloaded/tools/%@$(K8S_CODEGEN_VERSION))

.PHONY: k8s-codegen-tools
k8s-codegen-tools: $(K8S_CODEGEN_TOOLS_PATHS)

$(K8S_CODEGEN_TOOLS_PATHS): $(BINDIR)/tools/%-gen: $(BINDIR)/scratch/K8S_CODEGEN_VERSION | $(BINDIR)/downloaded/tools/%-gen@$(K8S_CODEGEN_VERSION) $(BINDIR)/tools
	cd $(dir $@) && $(LN) $(patsubst $(BINDIR)/%,../%,$(word 1,$|)) $(notdir $@)

$(K8S_CODEGEN_TOOLS_DOWNLOADS): $(BINDIR)/downloaded/tools/%-gen@$(K8S_CODEGEN_VERSION): $(NEEDS_GO) | $(BINDIR)/downloaded/tools
	GOBIN=$(PWD)/$(dir $@) $(GO) install k8s.io/code-generator/cmd/$(notdir $@)
	@mv $(subst @$(K8S_CODEGEN_VERSION),,$@) $@

############################
# kubebuilder-tools assets #
# kube-apiserver / etcd    #
# The SHAs for the same version of kubebuilder tools can change as new versions are published for changes merged to https://github.com/kubernetes-sigs/kubebuilder/tree/tools-releases #
# You can use ./hack/latest-kubebuilder-shas.sh <version> to get latest SHAs for a particular version of kubebuilder tools #
############################

KUBEBUILDER_TOOLS_linux_amd64_SHA256SUM=e4aa555f4f23f031f89128aaf8eae60e305e1f4fadec2db5731b2415d1a8957d
KUBEBUILDER_TOOLS_darwin_amd64_SHA256SUM=7ff8022a4022e76d2e7450db97232c0be77567064d8c116100d910e9b7b510d1
KUBEBUILDER_TOOLS_darwin_arm64_SHA256SUM=9483d95d1f53907b9bbe9deb0642b7731c5aa122a4598b5759fa77c50102b797

$(BINDIR)/downloaded/tools/etcd@$(KUBEBUILDER_ASSETS_VERSION)_%: $(BINDIR)/downloaded/tools/kubebuilder_tools_$(KUBEBUILDER_ASSETS_VERSION)_%.tar.gz | $(BINDIR)/downloaded/tools
	./hack/util/checkhash.sh $< $(KUBEBUILDER_TOOLS_$*_SHA256SUM)
	@# O writes the specified file to stdout
	tar xfO $< kubebuilder/bin/etcd > $@ && chmod 775 $@

$(BINDIR)/downloaded/tools/kube-apiserver@$(KUBEBUILDER_ASSETS_VERSION)_%: $(BINDIR)/downloaded/tools/kubebuilder_tools_$(KUBEBUILDER_ASSETS_VERSION)_%.tar.gz | $(BINDIR)/downloaded/tools
	./hack/util/checkhash.sh $< $(KUBEBUILDER_TOOLS_$*_SHA256SUM)
	@# O writes the specified file to stdout
	tar xfO $< kubebuilder/bin/kube-apiserver > $@ && chmod 775 $@

$(BINDIR)/downloaded/tools/kubebuilder_tools_$(KUBEBUILDER_ASSETS_VERSION)_$(HOST_OS)_$(HOST_ARCH).tar.gz: | $(BINDIR)/downloaded/tools
	$(CURL) https://storage.googleapis.com/kubebuilder-tools/kubebuilder-tools-$(KUBEBUILDER_ASSETS_VERSION)-$(HOST_OS)-$(HOST_ARCH).tar.gz -o $@

##############
# gatewayapi #
##############

GATEWAY_API_SHA256SUM=b84972572a104012e7fbea5651a113ac872f6ffeb0b037b4505d664383c932a3

$(BINDIR)/downloaded/gateway-api-$(GATEWAY_API_VERSION).yaml: | $(BINDIR)/downloaded
	$(CURL) https://github.com/kubernetes-sigs/gateway-api/releases/download/$(GATEWAY_API_VERSION)/experimental-install.yaml -o $@
	./hack/util/checkhash.sh $(BINDIR)/downloaded/gateway-api-$(GATEWAY_API_VERSION).yaml $(GATEWAY_API_SHA256SUM)

#################
# Other Targets #
#################

$(BINDIR) $(BINDIR)/tools $(BINDIR)/downloaded $(BINDIR)/downloaded/tools:
	@mkdir -p $@

# Although we "vendor" most tools in $(BINDIR)/tools, we still require some binaries
# to be available on the system. The vendor-go MAKECMDGOALS trick prevents the
# check for the presence of Go when 'make vendor-go' is run.

# Gotcha warning: MAKECMDGOALS only contains what the _top level_ make invocation used, and doesn't look at target dependencies
# i.e. if we have a target "abc: vendor-go test" and run "make abc", we'll get an error
# about go being missing even though abc itself depends on vendor-go!
# That means we need to pass vendor-go at the top level if go is not installed (i.e. "make vendor-go abc")

MISSING=$(shell (command -v curl >/dev/null || echo curl) \
             && (command -v jq >/dev/null || echo jq) \
             && (command -v sha256sum >/dev/null || echo sha256sum) \
             && (command -v git >/dev/null || echo git) \
             && ([ -n "$(findstring vendor-go,$(MAKECMDGOALS),)" ] \
                || command -v $(GO) >/dev/null || echo "$(GO) (or run 'make vendor-go')") \
             && (command -v $(CTR) >/dev/null || echo "$(CTR) (or set CTR to a docker-compatible tool)"))
ifneq ($(MISSING),)
$(error Missing required tools: $(MISSING))
endif

.PHONY: tools
tools: $(TOOLS_PATHS) $(K8S_CODEGEN_TOOLS_PATHS) ## install all tools

.PHONY: update-kind-images
update-kind-images: $(BINDIR)/tools/crane
	CRANE=./$(BINDIR)/tools/crane ./hack/latest-kind-images.sh

.PHONY: update-base-images
update-base-images: $(BINDIR)/tools/crane
	CRANE=./$(BINDIR)/tools/crane ./hack/latest-base-images.sh
