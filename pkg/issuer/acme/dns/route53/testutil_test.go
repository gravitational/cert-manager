// +skip_license_check

/*
This file contains portions of code directly taken from the 'xenolf/lego' project.
A copy of the license for this code can be found in the file named LICENSE in
this directory.
*/

package route53

import (
	"bytes"
	"fmt"
	"io"
	"net/http"
	"net/http/httptest"
	"testing"
	"time"

	"github.com/stretchr/testify/require"
)

// MockResponse represents a predefined response used by a mock server
type MockResponse struct {
	StatusCode     int
	Body           string
	ReqHasValues   []string
	ReqHasNoValues []string
	ReqAction      string
	Wait           <-chan struct{}
}

// MockResponseMap maps request paths to responses
type MockResponseMap map[string]MockResponse

func newMockServer(t *testing.T, responses MockResponseMap) *httptest.Server {
	ts := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		path := r.URL.Path
		resp, ok := responses[r.Method+" "+path]
		if !ok {
			msg := fmt.Sprintf("Request not found in response map: %s %s", r.Method, path)
			require.FailNow(t, msg)
		}
		reqBody, err := io.ReadAll(r.Body)
		if err != nil {
			msg := fmt.Sprintf("Invalid request: %s", err)
			require.FailNow(t, msg)
		}
		for _, v := range resp.ReqHasValues {
			if !bytes.Contains(reqBody, []byte("<Value>&#34;"+v+"&#34;</Value>")) {
				msg := fmt.Sprintf("Request missing required value: %s", v)
				require.FailNow(t, msg)
			}
		}
		for _, v := range resp.ReqHasNoValues {
			if bytes.Contains(reqBody, []byte("<Value>&#34;"+v+"&#34;</Value>")) {
				msg := fmt.Sprintf("Request contains excluded value: %s", v)
				require.FailNow(t, msg)
			}
		}
		if resp.ReqAction != "" && !bytes.Contains(reqBody, []byte("<Action>"+resp.ReqAction+"</Action>")) {
			msg := fmt.Sprintf("Request missing action: %s", resp.ReqAction)
			require.FailNow(t, msg)
		}

		if resp.Wait != nil {
			<-resp.Wait
		}

		w.Header().Set("Content-Type", "application/xml")
		w.Header().Set("X-Amzn-Requestid", "SOMEREQUESTID")
		w.WriteHeader(resp.StatusCode)
		_, _ = w.Write([]byte(resp.Body))
	}))

	time.Sleep(100 * time.Millisecond)
	return ts
}
