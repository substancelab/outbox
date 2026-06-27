import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tabs"
export default class extends Controller {
  static targets = ["tab", "panel"]

  connect() {
    this.showPanel(this.tabTargets[0])
  }

  show(event) {
    this.showPanel(event.currentTarget)
  }

  showPanel(activeTab) {
    this.tabTargets.forEach((tab) => {
      const panel = this.element.querySelector(tab.dataset.tabsPanel)
      const isActive = tab === activeTab

      tab.setAttribute("aria-selected", isActive)
      panel.classList.toggle("hidden", !isActive)
    })
  }
}
