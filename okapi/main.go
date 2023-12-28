package main

import (
	"encoding/json"
	"fmt"
	"github.com/gorilla/handlers"
	"io/ioutil"
	"log"
	"net/http"
)

type Response struct {
	Data struct {
		NumOwners          interface{} `json:"numOwners"`
		PlatformFloorPrice struct {
			SpecifyFloorPrice struct {
				FloorPrice struct {
					Price float64 `json:"price"`
				} `json:"floorPrice"`
			} `json:"specifyFloorPrice"`
		} `json:"platformFloorPrice"`
	} `json:"data"`
}

func handler(w http.ResponseWriter, r *http.Request) {
	url := "https://www.okx.com/priapi/v1/nft/project/stats?urlName=bitmap"
	resp, err := http.Get(url)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer resp.Body.Close()

	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	var data Response
	err = json.Unmarshal(body, &data)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	numOwners, _ := data.Data.NumOwners.(string)
	price := data.Data.PlatformFloorPrice.SpecifyFloorPrice.FloorPrice.Price

	fmt.Fprintf(w, "%f,%s\n", price, numOwners)
}

func main() {
	http.HandleFunc("/bitmap", handler)
	log.Fatal(http.ListenAndServe(":42042", handlers.CORS(handlers.AllowedOrigins([]string{"*"}))(http.DefaultServeMux)))
}
