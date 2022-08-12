import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form"]

  pick() {
    this.formTarget.requestSubmit()

    let results = document.getElementById("results")
    results.innerHTML = ""
  }
}
