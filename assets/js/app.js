import "phoenix_html"
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"
import { draggable } from "./draggable"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")

let Hooks = {}

Hooks.Activity = {
  mounted() {
    this.el.addEventListener("mouseover", e => {
      const {date, total} = e.currentTarget.dataset
      document.getElementById("activity-total").innerHTML = `${date} (${total} hours)`
    })
  },
}

Hooks.Draggable = {
  mounted() {
    draggable(this.el)
  }
}

let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}, hooks: Hooks})

topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

liveSocket.connect()

window.liveSocket = liveSocket

