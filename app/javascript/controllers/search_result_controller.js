import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["resultsBlock", "forms"]

  pick(event) {
    event.preventDefault()

    // Submete form para selecionar o resultado (escolher o card)
    let form = this.formsTargets.find(el => el.id === event.params.formId)
    form.requestSubmit()

    // Apaga lista de resultados da tela
    this.resultsBlockTarget.innerHTML = ""
  }
}
