module github.com/cert-manager/cert-manager

go 1.18

require (
	github.com/Azure/azure-sdk-for-go v56.3.0+incompatible
	github.com/Azure/go-autorest/autorest v0.11.20
	github.com/Azure/go-autorest/autorest/adal v0.9.15
	github.com/Azure/go-autorest/autorest/to v0.4.0
	github.com/Venafi/vcert/v4 v4.14.3
	github.com/akamai/AkamaiOPEN-edgegrid-golang v1.1.1
	github.com/aws/aws-sdk-go v1.40.21
	github.com/cloudflare/cloudflare-go v0.20.0
	github.com/cpu/goacmedns v0.1.1
	github.com/digitalocean/godo v1.65.0
	github.com/go-ldap/ldap/v3 v3.4.2
	github.com/go-logr/logr v1.2.3
	github.com/google/gnostic v0.6.9
	github.com/google/gofuzz v1.2.0
	github.com/hashicorp/vault/api v1.1.1
	github.com/hashicorp/vault/sdk v0.2.1
	github.com/kr/pretty v0.3.0
	github.com/miekg/dns v1.1.47
	github.com/mitchellh/go-homedir v1.1.0
	github.com/munnerz/crd-schema-fuzz v1.0.0
	github.com/onsi/ginkgo/v2 v2.4.0
	github.com/onsi/gomega v1.23.0
	github.com/pavel-v-chernykh/keystore-go/v4 v4.2.0
	github.com/pkg/errors v0.9.1
	github.com/prometheus/client_golang v1.14.0
	github.com/segmentio/encoding v0.3.3
	github.com/sergi/go-diff v1.2.0
	github.com/spf13/cobra v1.6.1
	github.com/spf13/pflag v1.0.5
	github.com/stretchr/testify v1.8.1
	golang.org/x/crypto v0.5.0
	golang.org/x/oauth2 v0.0.0-20220223155221-ee480838109b
	golang.org/x/sync v0.1.0
	gomodules.xyz/jsonpatch/v2 v2.2.0
	google.golang.org/api v0.62.0
	helm.sh/helm/v3 v3.11.1
	k8s.io/api v0.26.0
	k8s.io/apiextensions-apiserver v0.26.0
	k8s.io/apimachinery v0.26.0
	k8s.io/apiserver v0.26.0
	k8s.io/cli-runtime v0.26.0
	k8s.io/client-go v0.26.0
	k8s.io/code-generator v0.26.0
	k8s.io/component-base v0.26.0
	k8s.io/klog/v2 v2.80.1
	k8s.io/kube-aggregator v0.24.2
	k8s.io/kube-openapi v0.0.0-20221012153701-172d655c2280
	k8s.io/kubectl v0.26.0
	k8s.io/utils v0.0.0-20221107191617-1a15be271d1d
	sigs.k8s.io/controller-runtime v0.12.1
	sigs.k8s.io/controller-tools v0.9.2
	sigs.k8s.io/gateway-api v0.5.0
	sigs.k8s.io/structured-merge-diff/v4 v4.2.3
	sigs.k8s.io/yaml v1.3.0
	software.sslmate.com/src/go-pkcs12 v0.0.0-20210415151418-c5206de65a78
)

require (
	cloud.google.com/go v0.99.0 // indirect
	github.com/Azure/go-ansiterm v0.0.0-20210617225240-d185dfc1b5a1 // indirect
	github.com/Azure/go-autorest v14.2.0+incompatible // indirect
	github.com/Azure/go-autorest/autorest/date v0.3.0 // indirect
	github.com/Azure/go-autorest/autorest/validation v0.3.1 // indirect
	github.com/Azure/go-autorest/logger v0.2.1 // indirect
	github.com/Azure/go-autorest/tracing v0.6.0 // indirect
	github.com/Azure/go-ntlmssp v0.0.0-20200615164410-66371956d46c // indirect
	github.com/BurntSushi/toml v1.2.1 // indirect
	github.com/MakeNowJust/heredoc v1.0.0 // indirect
	github.com/Masterminds/goutils v1.1.1 // indirect
	github.com/Masterminds/semver/v3 v3.2.0 // indirect
	github.com/Masterminds/sprig/v3 v3.2.3 // indirect
	github.com/Masterminds/squirrel v1.5.3 // indirect
	github.com/NYTimes/gziphandler v1.1.1 // indirect
	github.com/antlr/antlr4/runtime/Go/antlr v1.4.10 // indirect
	github.com/asaskevich/govalidator v0.0.0-20200428143746-21a406dcc535 // indirect
	github.com/beorn7/perks v1.0.1 // indirect
	github.com/blang/semver/v4 v4.0.0 // indirect
	github.com/cenkalti/backoff/v3 v3.0.0 // indirect
	github.com/cenkalti/backoff/v4 v4.1.3 // indirect
	github.com/cespare/xxhash/v2 v2.1.2 // indirect
	github.com/chai2010/gettext-go v1.0.2 // indirect
	github.com/containerd/containerd v1.6.18 // indirect
	github.com/coreos/go-semver v0.3.0 // indirect
	github.com/coreos/go-systemd/v22 v22.3.2 // indirect
	github.com/cpuguy83/go-md2man/v2 v2.0.2 // indirect
	github.com/cyphar/filepath-securejoin v0.2.3 // indirect
	github.com/davecgh/go-spew v1.1.1 // indirect
	github.com/docker/cli v20.10.21+incompatible // indirect
	github.com/docker/distribution v2.8.1+incompatible // indirect
	github.com/docker/docker v20.10.24+incompatible // indirect
	github.com/docker/docker-credential-helpers v0.7.0 // indirect
	github.com/docker/go-connections v0.4.0 // indirect
	github.com/docker/go-metrics v0.0.1 // indirect
	github.com/docker/go-units v0.4.0 // indirect
	github.com/emicklei/go-restful/v3 v3.9.0 // indirect
	github.com/evanphx/json-patch v5.6.0+incompatible // indirect
	github.com/exponent-io/jsonpath v0.0.0-20151013193312-d6023ce2651d // indirect
	github.com/fatih/camelcase v1.0.0 // indirect
	github.com/fatih/color v1.13.0 // indirect
	github.com/felixge/httpsnoop v1.0.3 // indirect
	github.com/frankban/quicktest v1.11.3 // indirect
	github.com/fsnotify/fsnotify v1.6.0 // indirect
	github.com/go-asn1-ber/asn1-ber v1.5.1 // indirect
	github.com/go-errors/errors v1.0.1 // indirect
	github.com/go-gorp/gorp/v3 v3.0.2 // indirect
	github.com/go-openapi/jsonpointer v0.19.5 // indirect
	github.com/go-openapi/jsonreference v0.20.0 // indirect
	github.com/go-openapi/swag v0.19.14 // indirect
	github.com/go-task/slim-sprig v0.0.0-20210107165309-348f09dbbbc0 // indirect
	github.com/gobuffalo/flect v0.2.5 // indirect
	github.com/gobwas/glob v0.2.3 // indirect
	github.com/gogo/protobuf v1.3.2 // indirect
	github.com/golang-jwt/jwt/v4 v4.0.0 // indirect
	github.com/golang/groupcache v0.0.0-20210331224755-41bb18bfe9da // indirect
	github.com/golang/protobuf v1.5.2 // indirect
	github.com/golang/snappy v0.0.3 // indirect
	github.com/google/btree v1.0.1 // indirect
	github.com/google/cel-go v0.12.5 // indirect
	github.com/google/go-cmp v0.5.9 // indirect
	github.com/google/go-querystring v1.0.0 // indirect
	github.com/google/pprof v0.0.0-20210720184732-4bb14d4b1be1 // indirect
	github.com/google/shlex v0.0.0-20191202100458-e7afc7fbc510 // indirect
	github.com/google/uuid v1.3.0 // indirect
	github.com/googleapis/gax-go/v2 v2.1.1 // indirect
	github.com/gorilla/mux v1.8.0 // indirect
	github.com/gosuri/uitable v0.0.4 // indirect
	github.com/gregjones/httpcache v0.0.0-20180305231024-9cad4c3443a7 // indirect
	github.com/grpc-ecosystem/go-grpc-prometheus v1.2.0 // indirect
	github.com/grpc-ecosystem/grpc-gateway v1.16.0 // indirect
	github.com/hashicorp/errwrap v1.1.0 // indirect
	github.com/hashicorp/go-cleanhttp v0.5.2 // indirect
	github.com/hashicorp/go-multierror v1.1.1 // indirect
	github.com/hashicorp/go-retryablehttp v0.6.6 // indirect
	github.com/hashicorp/go-rootcerts v1.0.2 // indirect
	github.com/hashicorp/go-sockaddr v1.0.2 // indirect
	github.com/hashicorp/hcl v1.0.0 // indirect
	github.com/huandu/xstrings v1.3.3 // indirect
	github.com/imdario/mergo v0.3.12 // indirect
	github.com/inconshreveable/mousetrap v1.0.1 // indirect
	github.com/jmespath/go-jmespath v0.4.0 // indirect
	github.com/jmoiron/sqlx v1.3.5 // indirect
	github.com/josharian/intern v1.0.0 // indirect
	github.com/json-iterator/go v1.1.12 // indirect
	github.com/klauspost/compress v1.15.9 // indirect
	github.com/kr/text v0.2.0 // indirect
	github.com/lann/builder v0.0.0-20180802200727-47ae307949d0 // indirect
	github.com/lann/ps v0.0.0-20150810152359-62de8c46ede0 // indirect
	github.com/lib/pq v1.10.7 // indirect
	github.com/liggitt/tabwriter v0.0.0-20181228230101-89fcab3d43de // indirect
	github.com/mailru/easyjson v0.7.6 // indirect
	github.com/mattn/go-colorable v0.1.12 // indirect
	github.com/mattn/go-isatty v0.0.14 // indirect
	github.com/mattn/go-runewidth v0.0.9 // indirect
	github.com/matttproud/golang_protobuf_extensions v1.0.4 // indirect
	github.com/mitchellh/copystructure v1.2.0 // indirect
	github.com/mitchellh/go-wordwrap v1.0.0 // indirect
	github.com/mitchellh/mapstructure v1.4.3 // indirect
	github.com/mitchellh/reflectwalk v1.0.2 // indirect
	github.com/moby/locker v1.0.1 // indirect
	github.com/moby/spdystream v0.2.0 // indirect
	github.com/moby/sys/mountinfo v0.6.2 // indirect
	github.com/moby/term v0.0.0-20221205130635-1aeaba878587 // indirect
	github.com/modern-go/concurrent v0.0.0-20180306012644-bacd9c7ef1dd // indirect
	github.com/modern-go/reflect2 v1.0.2 // indirect
	github.com/monochromegane/go-gitignore v0.0.0-20200626010858-205db1a8cc00 // indirect
	github.com/morikuni/aec v1.0.0 // indirect
	github.com/munnerz/goautoneg v0.0.0-20191010083416-a7dc8b61c822 // indirect
	github.com/opencontainers/go-digest v1.0.0 // indirect
	github.com/opencontainers/image-spec v1.1.0-rc2 // indirect
	github.com/patrickmn/go-cache v2.1.0+incompatible // indirect
	github.com/peterbourgon/diskv v2.0.1+incompatible // indirect
	github.com/pierrec/lz4 v2.5.2+incompatible // indirect
	github.com/pmezard/go-difflib v1.0.0 // indirect
	github.com/prometheus/client_model v0.3.0 // indirect
	github.com/prometheus/common v0.37.0 // indirect
	github.com/prometheus/procfs v0.8.0 // indirect
	github.com/rogpeppe/go-internal v1.8.0 // indirect
	github.com/rubenv/sql-migrate v1.2.0 // indirect
	github.com/russross/blackfriday/v2 v2.1.0 // indirect
	github.com/ryanuber/go-glob v1.0.0 // indirect
	github.com/segmentio/asm v1.1.3 // indirect
	github.com/shopspring/decimal v1.2.0 // indirect
	github.com/sirupsen/logrus v1.9.0 // indirect
	github.com/spf13/cast v1.4.1 // indirect
	github.com/stoewer/go-strcase v1.2.0 // indirect
	github.com/stretchr/objx v0.5.0 // indirect
	github.com/xeipuuv/gojsonpointer v0.0.0-20180127040702-4e3ac2762d5f // indirect
	github.com/xeipuuv/gojsonreference v0.0.0-20180127040603-bd5ef7bd5415 // indirect
	github.com/xeipuuv/gojsonschema v1.2.0 // indirect
	github.com/xlab/treeprint v1.1.0 // indirect
	go.etcd.io/etcd/api/v3 v3.5.5 // indirect
	go.etcd.io/etcd/client/pkg/v3 v3.5.5 // indirect
	go.etcd.io/etcd/client/v3 v3.5.5 // indirect
	go.opencensus.io v0.23.0 // indirect
	go.opentelemetry.io/contrib v0.20.0 // indirect
	go.opentelemetry.io/contrib/instrumentation/google.golang.org/grpc/otelgrpc v0.35.0 // indirect
	go.opentelemetry.io/contrib/instrumentation/net/http/otelhttp v0.35.0 // indirect
	go.opentelemetry.io/otel v1.10.0 // indirect
	go.opentelemetry.io/otel/exporters/otlp/internal/retry v1.10.0 // indirect
	go.opentelemetry.io/otel/exporters/otlp/otlptrace v1.10.0 // indirect
	go.opentelemetry.io/otel/exporters/otlp/otlptrace/otlptracegrpc v1.10.0 // indirect
	go.opentelemetry.io/otel/metric v0.31.0 // indirect
	go.opentelemetry.io/otel/sdk v1.10.0 // indirect
	go.opentelemetry.io/otel/trace v1.10.0 // indirect
	go.opentelemetry.io/proto/otlp v0.19.0 // indirect
	go.starlark.net v0.0.0-20200306205701-8dd3e2ee1dd5 // indirect
	go.uber.org/atomic v1.7.0 // indirect
	go.uber.org/multierr v1.6.0 // indirect
	go.uber.org/zap v1.19.1 // indirect
	golang.org/x/mod v0.6.0 // indirect
	golang.org/x/net v0.7.0 // indirect
	golang.org/x/sys v0.5.0 // indirect
	golang.org/x/term v0.5.0 // indirect
	golang.org/x/text v0.7.0 // indirect
	golang.org/x/time v0.0.0-20220210224613-90d013bbcef8 // indirect
	golang.org/x/tools v0.2.0 // indirect
	google.golang.org/appengine v1.6.7 // indirect
	google.golang.org/genproto v0.0.0-20220802133213-ce4fa296bf78 // indirect
	google.golang.org/grpc v1.49.0 // indirect
	google.golang.org/protobuf v1.28.1 // indirect
	gopkg.in/inf.v0 v0.9.1 // indirect
	gopkg.in/ini.v1 v1.66.2 // indirect
	gopkg.in/natefinch/lumberjack.v2 v2.0.0 // indirect
	gopkg.in/square/go-jose.v2 v2.5.1 // indirect
	gopkg.in/yaml.v2 v2.4.0 // indirect
	gopkg.in/yaml.v3 v3.0.1 // indirect
	k8s.io/gengo v0.0.0-20220902162205-c0856e24416d // indirect
	k8s.io/kms v0.26.0 // indirect
	oras.land/oras-go v1.2.2 // indirect
	sigs.k8s.io/apiserver-network-proxy/konnectivity-client v0.0.33 // indirect
	sigs.k8s.io/json v0.0.0-20220713155537-f223a00ba0e2 // indirect
	sigs.k8s.io/kustomize/api v0.12.1 // indirect
	sigs.k8s.io/kustomize/kyaml v0.13.9 // indirect
)

replace (
	// We depend on go-restful because it's a k8s dependency.
	// v2 of go-restful has a critical CVE which we're not affected by and which k8s have fixed upstream but won't backport to the 1.24 release branch
	// We manually patch the version here so that we don't get awful security ratings from vuln scanners like trivy.
	github.com/emicklei/go-restful => github.com/emicklei/go-restful/v3 v3.8.0

	github.com/miekg/dns v1.1.41 => github.com/miekg/dns v1.1.34

	go.opentelemetry.io/contrib => go.opentelemetry.io/contrib v0.20.0
	go.opentelemetry.io/contrib/instrumentation/google.golang.org/grpc/otelgrpc => go.opentelemetry.io/contrib/instrumentation/google.golang.org/grpc/otelgrpc v0.20.0
	go.opentelemetry.io/contrib/instrumentation/net/http/otelhttp => go.opentelemetry.io/contrib/instrumentation/net/http/otelhttp v0.20.0
	go.opentelemetry.io/otel => go.opentelemetry.io/otel v0.20.0
	go.opentelemetry.io/otel/exporters/otlp => go.opentelemetry.io/otel/exporters/otlp v0.20.0
	go.opentelemetry.io/otel/metric => go.opentelemetry.io/otel/metric v0.20.0
	go.opentelemetry.io/otel/oteltest => go.opentelemetry.io/otel/oteltest v0.20.0
	go.opentelemetry.io/otel/sdk => go.opentelemetry.io/otel/sdk v0.20.0
	go.opentelemetry.io/otel/sdk/export/metric => go.opentelemetry.io/otel/sdk/export/metric v0.20.0
	go.opentelemetry.io/otel/sdk/metric => go.opentelemetry.io/otel/sdk/metric v0.20.0
	go.opentelemetry.io/otel/trace => go.opentelemetry.io/otel/trace v0.20.0
	go.opentelemetry.io/proto/otlp => go.opentelemetry.io/proto/otlp v0.7.0

	// Update gengo to ensure we have the --trim-path-prefix feature in code-generator tools.
	k8s.io/gengo => k8s.io/gengo v0.0.0-20211115164449-b448ea381d54
)
