//go:build !ignore_autogenerated
// +build !ignore_autogenerated

/*
Copyright The cert-manager Authors.

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

// Code generated by deepcopy-gen. DO NOT EDIT.

package v1alpha1

import (
	runtime "k8s.io/apimachinery/pkg/runtime"
)

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *CAInjectorConfiguration) DeepCopyInto(out *CAInjectorConfiguration) {
	*out = *in
	out.TypeMeta = in.TypeMeta
	in.LeaderElectionConfig.DeepCopyInto(&out.LeaderElectionConfig)
	in.EnableDataSourceConfig.DeepCopyInto(&out.EnableDataSourceConfig)
	in.EnableInjectableConfig.DeepCopyInto(&out.EnableInjectableConfig)
	in.Logging.DeepCopyInto(&out.Logging)
	if in.FeatureGates != nil {
		in, out := &in.FeatureGates, &out.FeatureGates
		*out = make(map[string]bool, len(*in))
		for key, val := range *in {
			(*out)[key] = val
		}
	}
	return
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new CAInjectorConfiguration.
func (in *CAInjectorConfiguration) DeepCopy() *CAInjectorConfiguration {
	if in == nil {
		return nil
	}
	out := new(CAInjectorConfiguration)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyObject is an autogenerated deepcopy function, copying the receiver, creating a new runtime.Object.
func (in *CAInjectorConfiguration) DeepCopyObject() runtime.Object {
	if c := in.DeepCopy(); c != nil {
		return c
	}
	return nil
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *EnableDataSourceConfig) DeepCopyInto(out *EnableDataSourceConfig) {
	*out = *in
	if in.Certificates != nil {
		in, out := &in.Certificates, &out.Certificates
		*out = new(bool)
		**out = **in
	}
	return
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new EnableDataSourceConfig.
func (in *EnableDataSourceConfig) DeepCopy() *EnableDataSourceConfig {
	if in == nil {
		return nil
	}
	out := new(EnableDataSourceConfig)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *EnableInjectableConfig) DeepCopyInto(out *EnableInjectableConfig) {
	*out = *in
	if in.ValidatingWebhookConfigurations != nil {
		in, out := &in.ValidatingWebhookConfigurations, &out.ValidatingWebhookConfigurations
		*out = new(bool)
		**out = **in
	}
	if in.MutatingWebhookConfigurations != nil {
		in, out := &in.MutatingWebhookConfigurations, &out.MutatingWebhookConfigurations
		*out = new(bool)
		**out = **in
	}
	if in.CustomResourceDefinitions != nil {
		in, out := &in.CustomResourceDefinitions, &out.CustomResourceDefinitions
		*out = new(bool)
		**out = **in
	}
	if in.APIServices != nil {
		in, out := &in.APIServices, &out.APIServices
		*out = new(bool)
		**out = **in
	}
	return
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new EnableInjectableConfig.
func (in *EnableInjectableConfig) DeepCopy() *EnableInjectableConfig {
	if in == nil {
		return nil
	}
	out := new(EnableInjectableConfig)
	in.DeepCopyInto(out)
	return out
}
