---@meta

---Called every tick
---@alias on_tick fun()

---Called once when the server starts or when plugins are being reloaded
---@alias on_init fun()

---Called for every network message the server sends
---The client_id is the client that will receive the message
---and data is the raw data that is being sent
---@alias on_server_message fun(client_id: integer, data: string, flags: integer)
