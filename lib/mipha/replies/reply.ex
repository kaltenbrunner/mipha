defmodule Mipha.Replies.Reply do
  @moduledoc false
  use Ecto.Schema
  import Ecto.{Changeset, Query}

  alias Mipha.{
    Topics.Topic,
    Replies.Reply,
    Accounts.User,
    Stars.Star
  }

  @type t :: %Reply{}

  schema "repies" do
    field :content, :string

    belongs_to :user, User
    belongs_to :topic, Topic
    belongs_to :parent, Reply, foreign_key: :parent_id

    has_many :children, Reply, foreign_key: :parent_id
    has_many :stars, Star

    timestamps()
  end

  @doc """
  Filters the topic by reply.
  """
  @spec by_topic(Ecto.Queryable.t(), Topic.t()) :: Ecto.Query.t()
  def by_topic(query \\ __MODULE__, %Topic{id: topic_id}),
    do: where(query, [..., r], r.topic_id == ^topic_id)

  @doc """
  Filters the parent by reply.
  """
  @spec by_parent(Ecto.Queryable.t(), t()) :: Ecto.Query.t()
  def by_parent(query \\ __MODULE__, %__MODULE__{id: parent_id}),
    do: where(query, [..., r], r.parent_id == ^parent_id)

  @doc """
  Filters reply by user.
  """
  @spec by_user(Ecto.Queryable.t(), User.t()) :: Ecto.Query.t()
  def by_user(query \\ __MODULE__, %User{id: user_id}),
    do: where(query, [..., r], r.user_id == ^user_id)

  @doc false
  def changeset(reply, attrs) do
    reply
    |> cast(attrs, [:topic_id, :user_id, :parent_id, :content])
    |> validate_required([:topic_id, :user_id, :parent_id, :content])
  end
end