defmodule Feedbacksys do
  alias Feedbacksys.{Feedback, Customer, Ftype}

  def hello do
    main_menu()
  end

  # Main
  def main_menu do
    IO.puts("╭───────────────────────────────────╮\n"<>
            "│          Feedback System          │\n"<>
            "╰───────────────────────────────────╯\n"<>
            "      (1) Log in                     \n"<>
            "      (2) Create Account             \n"<>
            "      (3) View Feedbacks as guest    \n"<>
            "      (4) Admin                      \n"<>
            "      (5) Exit                       \n")

    option = IO.gets("What do you want to do: ")
    |> String.to_integer()
    option(option)

  end

  defp option(1), do: login()

  defp option(2), do: create_account()

  defp option(3) do
    Feedback.get_all_feedbacks()
    main_menu()
  end

  defp option(4), do: System.halt(0)

  defp option(5), do: System.halt(0)

  defp option(_) do
    IO.puts("Invalid option")
    main_menu()
  end


  #Log in code
  def login do
    email =
      input("Email: ")
      |> get_customer_by_email()

    case email do
      nil ->
        IO.puts("User not found.")
      customer ->
        attempt_login(customer)
    end
  end

  defp get_customer_by_email(email) do
    Customer.get_customer_by_email(email)
  end

  defp attempt_login(nil) do
    IO.puts("User not found.")
  end

  defp attempt_login(%Customer{} = customer) do
    password = input("Password: ")
    if password == customer.password do
      IO.puts("Login successful.")
      customer_page(customer)
    else
      IO.puts("Invalid password.")
    end
  end

  #Create account
  def create_account do
    IO.puts("Enter user details:")
    case get_user_params() do
      {:ok, user_params} ->
        case Customer.add_customer(user_params) do
          {:ok, _user} ->
            IO.puts("User created successfully.")
          _ ->
            IO.puts("Failed to add customer")
        end
      {:error, error} ->
        IO.puts("Error: #{error}")
    end
  end

  defp get_user_params do
    name = IO.gets("Name: ")
    username = IO.gets("Username: ")
    email = IO.gets("Email: ")
    password = IO.gets("Password: ")
    confirm_pass = IO.gets("Confirm Password: ")

    if password == confirm_pass && String.match?(email, ~r/@/) do
      {:ok, %{name: name, username: username, email: email, password: password}}
    else
      {:error, "Invalid user parameters"}
    end
  end

  #creating a feedback
  def create_feedback(id) do
    IO.puts("╭───────────────────────────────────╮")
    IO.puts("│          Add a feedback           │")
    IO.puts("╰───────────────────────────────────╯")
    feedback_data = get_feedback_data(id)
    Feedback.add_feedback(feedback_data)
  end

  defp get_feedback_data(id) do
    IO.puts("Select what to provide feedback on.")
    Ftype.get_all_types()
    type = input("Enter option\n  ")|>String.to_integer()
    caption = input("Caption:\n  ")
    rate = input("Rate (0-5):\n  ")|>String.to_integer()
    comment = input("Comment:\n  ")

    current_time_utc = DateTime.utc_now()
    current_time_philippine = Timex.shift(current_time_utc, hours: 8)

    %{rating: rate,
    caption: caption,
    comments: comment,
    timestamp: current_time_philippine,
    updated_at: current_time_philippine,
    responsestatus: "Not Responded ⓧ",
    customer_id: id,
    feedback_type_id: type
    }
  end

  # Customer_page
  def customer_page(customer) do
    IO.puts("╭───────────────────────────────────╮")
    IO.puts("│          Feedback System          │")
    IO.puts("╰───────────────────────────────────╯")
    IO.puts("      Hi #{customer.username}")
    IO.puts("               Menu:               ")
    IO.puts("      (1) Add Feedback             ")
    IO.puts("      (2) View All Feedbacks       ")
    IO.puts("      (3) View All my Feedbacks    ")
    IO.puts("      (4) Edit Feedback            ")
    IO.puts("      (5) Edit Customer Details    ")
    IO.puts("      (6) Delete Feedback          ")
    IO.puts("      (7) Log out                  ")
    IO.puts("                                   ")

    option = input("What do you want to do: ") |> String.to_integer()
    option(option, customer)
  end

  defp option(1, customer) do
    create_feedback(customer.id)
    |>customer_page()
  end

  defp option(2, customer) do
    Feedback.get_all_feedbacks()
    customer_page(customer)
  end

  defp option(3 , customer) do
    create_feedback(customer.id)
    |>customer_page()
  end

  defp option(4, customer) do
    create_feedback(customer.id)
    |>customer_page()
  end

  defp option(5, customer) do
    Feedback.get_feedbacks_by_customer(customer.id)
    customer_page(customer)
  end

  defp option(6, _customer), do: main_menu()

  defp option(_,customer) do
    IO.puts("Invalid option")
    customer_page(customer)
  end





  defp input(prompt) do
    IO.gets(prompt)
    |> String.trim
  end
end
