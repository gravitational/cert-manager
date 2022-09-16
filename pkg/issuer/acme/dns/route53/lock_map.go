package route53

import "sync"

// lockMap is a concurrency-safe string-indexed map of mutexes.
// A lockMap does de-allocates memory for unused keys.
type lockMap struct {
	mu sync.Mutex
	m  map[string]*lockMapVal
}

type lockMapVal struct {
	mu sync.Mutex
	n  int
}

// Lock locks the lock map for a given key.
// Locking a given key has no effect on other keys.
func (l *lockMap) Lock(key string) {
	l.mu.Lock()
	if l.m == nil {
		l.m = make(map[string]*lockMapVal, 1)
	}
	v, ok := l.m[key]
	if !ok {
		v = &lockMapVal{}
		l.m[key] = v
	}
	v.n++
	l.mu.Unlock()
	v.mu.Lock()
}

// Unlock unlocks the lock map for a given key.
func (l *lockMap) Unlock(key string) {
	l.mu.Lock()
	v, ok := l.m[key]
	if ok && v.n <= 1 {
		delete(l.m, key)
	}
	l.mu.Unlock()
	if !ok {
		return
	}
	v.mu.Unlock()
}
