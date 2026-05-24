import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Add transition classes after rendering to trigger slide-in
    requestAnimationFrame(() => {
      this.element.classList.remove("translate-y-4", "opacity-0")
      this.element.classList.add("translate-y-0", "opacity-100")
    })

    // Automatically trigger closing animation after 3 seconds
    setTimeout(() => {
      this.close()
    }, 3000)
  }

  close() {
    this.element.classList.remove("translate-y-0", "opacity-100")
    this.element.classList.add("translate-y-2", "opacity-0")
    setTimeout(() => {
      this.element.remove()
    }, 300)
  }
}
