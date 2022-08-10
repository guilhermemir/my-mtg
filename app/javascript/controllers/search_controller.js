import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "results"]

  connect() { console.log("search controller connected") }

  pick() {
    console.log("pick called")
    this.formTarget.requestSubmit()

    let results = document.getElementById("results")
    results.innerHTML = ""
  }
}
