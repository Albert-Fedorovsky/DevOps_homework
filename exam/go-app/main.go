package main
import (
    "fmt"
    "net/http"
)
type msg string
func (m msg) ServeHTTP(resp http.ResponseWriter, req *http.Request) {
   fmt.Fprint(resp, m)
}
func main() {
    msgHandler := msg("<h1>Andersen DevOps cource</h1><h2>exam</h2><p>Hello world 2</p>")
    fmt.Println("Server is listening...")
    http.ListenAndServe("0.0.0.0:8181", msgHandler)
}
