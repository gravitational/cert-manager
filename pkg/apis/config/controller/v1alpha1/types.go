/*
Copyright 2021 The cert-manager Authors.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package v1alpha1

import (
	"time"

	"k8s.io/component-base/logs"

	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

type ControllerConfiguration struct {
	metav1.TypeMeta `json:",inline"`

	// Optional apiserver host address to connect to. If not specified,
	// autoconfiguration will be attempted
	APIServerHost string `json:"apiServerHost,omitempty"`

	// Paths to a kubeconfig. Only required if out-of-cluster.
	KubeConfig string `json:"kubeConfig,omitempty"`

	// Indicates the maximum queries-per-second requests to the Kubernetes apiserver
	// TODO: floats are not recommended. Maybe we should use resource.Quantity? https://kubernetes.io/docs/reference/kubernetes-api/common-definitions/quantity/
	KubernetesAPIQPS *float32 `json:"kubernetesAPIQPS,omitempty"`

	// The maximum burst queries-per-second of requests sent to the Kubernetes apiserver
	KubernetesAPIBurst *int32 `json:"kubernetesAPIBurst,omitempty"`

	// Namespace to store resources owned by cluster scoped resources such as ClusterIssuer in.
	ClusterResourceNamespace string `json:"clusterResourceNamespace,omitempty"`

	// If set, this limits the scope of cert-manager to a single namespace and
	// ClusterIssuers are disabled. If not specified, all namespaces will be
	// watched"
	Namespace string `json:"namespace,omitempty"`

	// If true, cert-manager will perform leader election between instances to
	// ensure no more than one instance of cert-manager operates at a time
	LeaderElect *bool `json:"leaderElect,omitempty"`

	//Namespace used to perform leader election. Only used if leader election is enabled
	LeaderElectionNamespace string `json:"leaderElectionNamespace,omitempty"`

	// The duration that non-leader candidates will wait after observing a leadership
	// renewal until attempting to acquire leadership of a led but unrenewed leader
	// slot. This is effectively the maximum duration that a leader can be stopped
	// before it is replaced by another candidate. This is only applicable if leader
	// election is enabled.
	LeaderElectionLeaseDuration time.Duration `json:"leaderElectionLeaseDuration,omitempty"`

	// The interval between attempts by the acting master to renew a leadership slot
	// before it stops leading. This must be less than or equal to the lease duration.
	// This is only applicable if leader election is enabled.
	LeaderElectionRenewDeadline time.Duration `json:"leaderElectionRenewDeadline,omitempty"`

	// The duration the clients should wait between attempting acquisition and renewal
	// of a leadership. This is only applicable if leader election is enabled.
	LeaderElectionRetryPeriod time.Duration `json:"leaderElectionRetryPeriod,omitempty"`

	// A list of controllers to enable.
	// ['*'] enables all controllers,
	// ['foo'] enables only the foo controller
	// ['*', '-foo'] disables the controller named foo.
	Controllers []string `json:"controllers,omitempty"`

	// The Docker image to use to solve ACME HTTP01 challenges. You most likely
	// will not need to change this parameter unless you are testing a new
	// feature or developing cert-manager.
	ACMEHTTP01SolverImage string `json:"acmeHTTP01SolverImage,omitempty"`

	// Defines the resource request CPU size when spawning new ACME HTTP01
	// challenge solver pods.
	ACMEHTTP01SolverResourceRequestCPU string `json:"acmeHTTP01SolverResourceRequestCPU,omitempty"`

	//Defines the resource request Memory size when spawning new ACME HTTP01
	//challenge solver pods.
	ACMEHTTP01SolverResourceRequestMemory string `json:"acmeHTTP01SolverResourceRequestMemory,omitempty"`

	//Defines the resource limits CPU size when spawning new ACME HTTP01
	//challenge solver pods.
	ACMEHTTP01SolverResourceLimitsCPU string `json:"acmeHTTP01SolverResourceLimitsCPU,omitempty"`

	// Defines the resource limits Memory size when spawning new ACME HTTP01
	// challenge solver pods.
	ACMEHTTP01SolverResourceLimitsMemory string `json:"acmeHTTP01SolverResourceLimitsMemory,omitempty"`

	// Defines the ability to run the http01 solver as root for troubleshooting
	// issues
	ACMEHTTP01SolverRunAsNonRoot *bool `json:"acmeHTTP01SolverRunAsNonRoot,omitempty"`

	// A list of comma separated dns server endpoints used for
	// ACME HTTP01 check requests. This should be a list containing host and
	// port, for example ["8.8.8.8:53","8.8.4.4:53"]
	// Allows specifying a list of custom nameservers to perform HTTP01 checks on.
	ACMEHTTP01SolverNameservers []string `json:"acmeHTTP01SolverNameservers,omitempty"`

	// Whether a cluster-issuer may make use of ambient credentials for issuers.
	// 'Ambient Credentials' are credentials drawn from the environment, metadata
	// services, or local files which are not explicitly configured in the
	// ClusterIssuer API object. When this flag is enabled, the following sources
	// for credentials are also used: AWS - All sources the Go SDK defaults to,
	// notably including any EC2 IAM roles available via instance metadata.
	ClusterIssuerAmbientCredentials *bool `json:"clusterIssuerAmbientCredentials,omitempty"`

	// Whether an issuer may make use of ambient credentials. 'Ambient
	// Credentials' are credentials drawn from the environment, metadata services,
	// or local files which are not explicitly configured in the Issuer API
	// object. When this flag is enabled, the following sources for
	// credentials are also used: AWS - All sources the Go SDK defaults to,
	// notably including any EC2 IAM roles available via instance metadata.
	IssuerAmbientCredentials *bool `json:"issuerAmbientCredentials,omitempty"`

	// Default issuer/certificates details consumed by ingress-shim
	// Name of the Issuer to use when the tls is requested but issuer name is
	// not specified on the ingress resource.
	DefaultIssuerName string `json:"defaultIssuerName,omitempty"`

	// Kind of the Issuer to use when the TLS is requested but issuer kind is not
	// specified on the ingress resource.
	DefaultIssuerKind string `json:"defaultIssuerKind,omitempty"`

	// Group of the Issuer to use when the TLS is requested but issuer group is
	// not specified on the ingress resource.
	DefaultIssuerGroup string `json:"defaultIssuerGroup,omitempty"`

	// The annotation consumed by the ingress-shim controller to indicate a ingress
	// is requesting a certificate
	DefaultAutoCertificateAnnotations []string `json:"defaultAutoCertificateAnnotations,omitempty"`

	// Each nameserver can be either the IP address and port of a standard
	// recursive DNS server, or the endpoint to an RFC 8484 DNS over HTTPS
	// endpoint. For example, the following values are valid:
	//  - "8.8.8.8:53" (Standard DNS)
	//  - "https://1.1.1.1/dns-query" (DNS over HTTPS)
	DNS01RecursiveNameservers []string `json:"dns01RecursiveNameservers,omitempty"`

	// When true, cert-manager will only ever query the configured DNS resolvers
	// to perform the ACME DNS01 self check. This is useful in DNS constrained
	// environments, where access to authoritative nameservers is restricted.
	// Enabling this option could cause the DNS01 self check to take longer
	// due to caching performed by the recursive nameservers.
	DNS01RecursiveNameserversOnly *bool `json:"dns01RecursiveNameserversOnly,omitempty"`

	// Whether to set the certificate resource as an owner of secret where the
	// tls certificate is stored. When this flag is enabled, the secret will be
	// automatically removed when the certificate resource is deleted.
	EnableCertificateOwnerRef *bool `json:"enableCertificateOwnerRef,omitempty"`

	// The number of concurrent workers for each controller.
	NumberOfConcurrentWorkers *int32 `json:"numberOfConcurrentWorkers,omitempty"`

	// The maximum number of challenges that can be scheduled as 'processing' at once.
	MaxConcurrentChallenges *int32 `json:"maxConcurrentChallenges,omitempty"`

	// The host and port that the metrics endpoint should listen on.
	MetricsListenAddress string `json:"metricsListenAddress,omitempty"`

	// The host and port address, separated by a ':', that the healthz server
	// should listen on.
	HealthzListenAddress string `json:"healthzListenAddress,omitempty"`

	// Leader election healthz checks within this timeout period after the lease
	// expires will still return healthy.
	HealthzLeaderElectionTimeout time.Duration `json:"healthzLeaderElectionTimeout,omitempty"`

	// The host and port that Go profiler should listen on, i.e localhost:6060.
	// Ensure that profiler is not exposed on a public address. Profiler will be
	// served at /debug/pprof.
	PprofAddress string `json:"pprofAddress,omitempty"`
	// Enable profiling for controller.
	EnablePprof *bool `json:"enablePprof"`

	// https://pkg.go.dev/k8s.io/component-base@v0.27.3/logs/api/v1#LoggingConfiguration
	Logging *logs.Options `json:"logging,omitempty"`

	// The duration the controller should wait between a propagation check. Despite
	// the name, this flag is used to configure the wait period for both DNS01 and
	// HTTP01 challenge propagation checks. For DNS01 challenges the propagation
	// check verifies that a TXT record with the challenge token has been created.
	// For HTTP01 challenges the propagation check verifies that the challenge
	// token is served at the challenge URL. This should be a valid duration
	// string, for example 180s or 1h
	DNS01CheckRetryPeriod time.Duration `json:"dns01CheckRetryPeriod,omitempty"`

	// Specify which annotations should/shouldn't be copied from Certificate to
	// CertificateRequest and Order, as well as from CertificateSigningRequest to
	// Order, by passing a list of annotation key prefixes. A prefix starting with
	// a dash(-) specifies an annotation that shouldn't be copied. Example:
	// '*,-kubectl.kuberenetes.io/'- all annotations will be copied apart from the
	// ones where the key is prefixed with 'kubectl.kubernetes.io/'.
	CopiedAnnotationPrefixes []string `json:"copiedAnnotationPrefixes,omitempty"`

	// featureGates is a map of feature names to bools that enable or disable experimental
	// features.
	// Default: nil
	// +optional
	FeatureGates map[string]bool `json:"featureGates,omitempty"`
}
