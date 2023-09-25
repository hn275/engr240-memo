package main

import (
	"fmt"
	"log"
	"net/http"
	"net/url"
	"sync"
)

const (
	API_TOKEN   string = "my-api-key"
	ONC                = "https://data.oceannetworks.ca/api"
	DDosCounter        = 1000
)

type ONCData struct {
	Location   string      `json:"location"`
	Deployment interface{} `json:"deployment"`
}

func main() {
	p := map[string]string{
		"token": API_TOKEN,
	}

	var mut sync.Mutex
	var wg sync.WaitGroup
	var requestOK uint16

	for i := 0; i < DDosCounter; i++ {
		go func(m *sync.Mutex, wg *sync.WaitGroup) {
			wg.Add(1)
			defer wg.Done()

			url := makeUrl("/locations", p)
			r, err := http.NewRequest(http.MethodGet, url, nil)
			if err != nil {
				log.Fatal(err)
			}

			cx := http.Client{}
			rsp, err := cx.Do(r)
			if err != nil {
				log.Fatal(err)
			}
			defer rsp.Body.Close()

			if rsp.StatusCode == http.StatusOK {
				m.Lock()
				requestOK++
				m.Unlock()

			}
		}(&mut, &wg)
	}

	wg.Wait()
	log.Printf("Made %d requests, returned %d on success\n", DDosCounter, requestOK)
}

func makeUrl(s string, params map[string]string) string {
	u := make(url.Values)
	for k, v := range params {
		u.Add(k, v)
	}
	return fmt.Sprintf("%s%s?%s", ONC, s, u.Encode())
}
