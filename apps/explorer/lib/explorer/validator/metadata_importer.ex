defmodule Explorer.Validator.MetadataImporter do
  alias Explorer.Chain.Address
  alias Explorer.Validator.MetadataRetriever
  alias Explorer.Repo

  import Ecto.Query, only: [from: 2]

  def import_metadata(metadata_maps) do
    Repo.transaction(fn ->
      metadata_maps
      |> Enum.each(fn validator_changeset ->
        case Repo.get_by(Address.Name, address_hash: validator_changeset.address_hash, primary: true) do
          nil ->
            %Address.Name{}
            |> Address.Name.changeset(validator_changeset)
            |> Repo.insert()

          address_name ->
            from(an in Address.Name,
              update: [
                set: [
                  name: ^validator_changeset.name,
                  metadata: ^validator_changeset.metadata
                ]
              ],
              where: an.address_hash == ^validator_changeset.address_hash and an.primary == true
            )
            |> Repo.update_all([])
        end
      end)
    end)
  end
end
