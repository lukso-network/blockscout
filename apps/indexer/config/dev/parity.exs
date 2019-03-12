use Mix.Config
config :indexer,
  block_interval: :timer.seconds(5),
  json_rpc_named_arguments: [
    transport: EthereumJSONRPC.HTTP,
    transport_options: [
      http: EthereumJSONRPC.HTTP.HTTPoison,
      url: System.get_env("ETHEREUM_JSONRPC_HTTP_URL") || "http://35.189.66.64:8545",
      method_to_url: [
        eth_getBalance: System.get_env("ETHEREUM_JSONRPC_TRACE_URL") || "http://35.189.66.64:8545",
        trace_block: System.get_env("ETHEREUM_JSONRPC_TRACE_URL") || "http://35.189.66.64:8545",
        trace_replayTransaction: System.get_env("ETHEREUM_JSONRPC_TRACE_URL") || "http://35.189.66.64:8545"
      ],
      http_options: [recv_timeout: :timer.minutes(1), timeout: :timer.minutes(1), hackney: [pool: :ethereum_jsonrpc]]
    ],
    variant: EthereumJSONRPC.Parity
  ],
  subscribe_named_arguments: [
    transport: EthereumJSONRPC.WebSocket,
    transport_options: [
      web_socket: EthereumJSONRPC.WebSocket.WebSocketClient,
      url: System.get_env("ETHEREUM_JSONRPC_WS_URL") || "ws://35.189.66.64:8546"
    ]
  ]