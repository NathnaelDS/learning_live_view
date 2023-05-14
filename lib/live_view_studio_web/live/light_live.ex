defmodule LiveViewStudioWeb.LightLive do
  use LiveViewStudioWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, brightness: 10, temp: "3000")
    {:ok, socket}
  end

  defp temp_color("3000"), do: "#F1C40D"
  defp temp_color("4000"), do: "#FEFF66"
  defp temp_color("5000"), do: "#99CCFF"

  def render(assigns) do
    ~H"""
    <h1>Front Porch Light</h1>
    <div id="light">
      <div class="meter">
        <span style={"width: #{@brightness}%; background: #{temp_color(@temp)}"}>
          <%= @brightness %>%
        </span>
      </div>
      <button phx-click="off">
        <img src="/images/light-off.svg" alt="">
      </button>
      <button phx-click="down">
        <img src="/images/down.svg" alt="">
      </button>
      <button phx-click="up">
        <img src="/images/up.svg" alt="">
      </button>
      <button phx-click="on">
        <img src="/images/light-on.svg" alt="">
      </button>
      <button phx-click="fire">
        <img src="/images/fire.svg" alt="">
      </button>
    </div>
    <form class="mt-4">
      <div class="temps flex gap-4">
        <%= for temp <- ["3000", "4000", "5000"] do %>
          <div>
            <input phx-change="change-temp" type="radio" id={temp} name="temp" value={temp} checked={@temp == temp} />
            <label for={temp}><%= temp %></label>
          </div>
        <% end %>
      </div>
    </form>
    <form phx-change="slide" class="mt-4">
        <input type="range" name="brightness" min="0" max="100" value={@brightness} phx-debounce="250">
    </form>
    """
  end

  def handle_event("change-temp", %{"temp" => temp}, socket) do
    # IO.inspect(params, label: "🍄")
    socket = assign(socket, temp: temp)

    {:noreply, socket}
  end

  def handle_event("on", _, socket) do
    socket = assign(socket, brightness: 100)
    {:noreply, socket}
  end

  def handle_event("off", _, socket) do
    socket = assign(socket, brightness: 0)
    {:noreply, socket}
  end

  def handle_event("slide", %{"brightness" => b}, socket) do
    {:noreply, assign(socket, brightness: b)}
  end

  def handle_event("down", _, socket) do
    socket = update(socket, :brightness, &max(&1 - 10, 0))
    {:noreply, socket}
  end

  def handle_event("up", _, socket) do
    socket = update(socket, :brightness, &min(&1 + 10, 100))
    {:noreply, socket}
  end

  def handle_event("fire", _, socket) do
    value = :rand.uniform(100)
    socket = assign(socket, brightness: value)
    {:noreply, socket}
  end
end
