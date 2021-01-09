# Helpdesk

To start the application:

Setup the project with` mix setup`

Start Phoenix endpoint with `mix phx.server` or, to get a shell, start it with `iex -S mix phx.server`

See the resources in lib/helpdesk/accounts/resources and lib/helpdesk/tickets/resources. Addtionally, see the API for each context in `lib/helpdesk/accounts/api.ex` and `lib/helpdesk/tickets/api.ex`

To "log in" set a `user-id` header. You can browse the database for that information, or run this in the terminal to get a list of users: `Helpdesk.Accounts.Api.read!(Helpdesk.Accounts.User)`. For what a user should/shouldn't be able to see, look at the policies in each resource.

To use the graphql, visit http://localhost:4000/playground. There is an area for setting headers in the bottom left

To use the json api, I recommend using insomnia or postman. The routes are available are defined in each resource. For resources in the accounts API, they are prefixed with `/accounts` and the tickets API is prefixed with `/tickets`. A good one to try first might be just hitting http://localhost:4000/tickets/tickets

Additionally, there is a rudimentary Live View set up on which I am testing some experimental integrations with Ash and Phoenix.

See the documentation/project for more information on Ash: ash-project/ash
