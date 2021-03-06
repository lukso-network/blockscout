defmodule Indexer.Block.Realtime.ConsensusEnsurer do
  @moduledoc """
  Triggers a refetch if a given block doesn't have consensus.

  """

  alias Explorer.Chain
  alias Explorer.Chain.Hash
  alias Indexer.Block.Realtime.Fetcher

  def perform(%Hash{byte_count: unquote(Hash.Full.byte_count())} = block_hash, number, block_fetcher) do
    case Chain.hash_to_block(block_hash) do
      {:ok, %{consensus: true} = _block} ->
        :ignore

      _ ->
        # trigger refetch if consensus=false or block was not found
        Fetcher.fetch_and_import_block(number, block_fetcher, true)
    end

    :ok
  end
end
