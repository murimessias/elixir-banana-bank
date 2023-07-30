defmodule BananaBankWeb.UsersControllerTest do
  use BananaBankWeb.ConnCase

  alias BananaBank.Users
  alias Users.User

  describe "create/2" do
    test "succesfully creates an user", %{conn: conn} do
      params = %{
        cep: "12345678",
        email: "test@test.com",
        name: "Name Test",
        password: "123456"
      }

      response =
        conn
        |> post(~p"/api/users", params)
        |> json_response(:created)

      assert %{
               "message" => "User created successfully",
               "data" => %{
                 "id" => _id,
                 "cep" => "12345678",
                 "email" => "test@test.com",
                 "name" => "Name Test"
               }
             } = response
    end

    test "when there are invalid params, returns an error", %{conn: conn} do
      params = %{
        cep: "1234",
        email: "test@test.com",
        name: nil,
        password: "123456"
      }

      response =
        conn
        |> post(~p"/api/users", params)
        |> json_response(:bad_request)

      expected_response = %{
        "errors" => %{
          "cep" => ["should be at least 8 character(s)"],
          "name" => ["can't be blank"]
        }
      }

      assert response == expected_response
    end
  end

  describe "delete/2" do
    test "successfully deletes a user", %{conn: conn} do
      params = %{
        cep: "12345678",
        email: "test@test.com",
        name: "Name Test",
        password: "123456"
      }

      {:ok, %User{id: id}} = Users.create(params)

      response =
        conn
        |> delete(~p"/api/users/#{id}")
        |> json_response(:ok)

      expected_response = %{
        "message" => "User deleted successfully",
        "data" => %{
          "id" => id,
          "cep" => "12345678",
          "email" => "test@test.com",
          "name" => "Name Test"
        }
      }

      assert response == expected_response
    end
  end
end
