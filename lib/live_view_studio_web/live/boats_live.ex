defmodule LiveViewStudioWeb.BoatsLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Boats
  import LiveViewStudioWeb.CustomComponents

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    type = params["type"] || ""
    prices = params["prices"] || [""]

    filter = %{type: type, prices: prices}

    boats = Boats.list_boats(filter)

    {:noreply, assign(socket, boats: boats, filter: filter)}
  end

  def render(assigns) do
    ~H"""
    <h1>Daily Boat Rentals</h1>

    <.badge
      label="edited"
      class="bg-blue-300 font-bold"
      id="status-filmed"
      phx-click="remove"
    />

    <.promo expiration={2}>
      Save 25% on rentals
      <:legal>
        <Heroicons.exclamation_circle /> Limit 1 per party
      </:legal>
    </.promo>

    <div id="boats">
      <.filter_form filter={@filter} />

      <div class="boats">
        <.boat :for={boat <- @boats} boat={boat} />
      </div>
    </div>

    <.promo>
      Hurry only 3 left
    </.promo>
    """
  end

  attr :boat, LiveViewStudio.Boats.Boat, required: true

  def boat(assigns) do
    ~H"""
    <div class="boat">
      <img src={@boat.image} />
      <div class="content">
        <div class="model">
          <%= @boat.model %>
        </div>
        <div class="details">
          <span class="price">
            <%= @boat.price %>
          </span>
          <span class="type">
            <%= @boat.type %>
          </span>
        </div>
      </div>
    </div>
    """
  end

  attr :filter, :map, required: true

  def filter_form(assigns) do
    ~H"""
    <form phx-change="filter">
      <div class="filters">
        <select name="type">
          <%= Phoenix.HTML.Form.options_for_select(
            type_options(),
            @filter.type
          ) %>
        </select>
        <div class="prices">
          <%= for price <- ["$", "$$", "$$$"] do %>
            <input
              type="checkbox"
              name="prices[]"
              value={price}
              id={price}
              checked={price in @filter.prices}
            />
            <label for={price}><%= price %></label>
          <% end %>
          <input type="hidden" name="prices[]" value="" />
        </div>
      </div>
    </form>
    """
  end

  def handle_event("filter", %{"type" => type, "prices" => prices}, socket) do
    params = %{type: type, prices: prices}
    socket = push_patch(socket, to: ~p"/boats?#{params}")

    {:noreply, socket}
  end

  defp type_options do
    [
      "All Types": "",
      Fishing: "fishing",
      Sporting: "sporting",
      Sailing: "sailing"
    ]
  end
end
