defmodule TeamRecruitWeb.NotificationChannel do
  use TeamRecruitWeb, :channel

  def join("notification:" <> user_id, _payload, socket) do
    if authorized?(user_id, socket) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (notification:lobby).
  def handle_in("notificatio:new", payload, socket) do
    IO.puts "test"
    broadcast! "notification:" <> payload, "new", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(user_id, %{assigns: user}) do
    true
  end
end
