defmodule GildedRose do
  @moduledoc """
  Update item quantities and sell_in at the **end** of every day.

  # Example
  # update_quality([%Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 9, quality: 1}])
  # => [%Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 8, quality: 3}]
  """

  # @type item :: Item.t()
  @type item :: struct()

  @item_categories [:aged_brie, :backstage_pass, :conjured_item, :normal, :sulfuras]
  @type item_category :: unquote(Enum.reduce(@item_categories, &{:|, [], [&1, &2]}))

  @default_min_quality 0
  @default_max_quality 50

  def infer_item_category(item) do
    downcased_name = String.downcase(item.name)

    cond do
      String.contains?(downcased_name, "aged brie") -> :aged_brie
      String.contains?(downcased_name, "sulfuras") -> :sulfuras
      String.contains?(downcased_name, "backstage pass") -> :backstage_pass
      String.contains?(downcased_name, "conjured") -> :conjured
      true -> :normal
    end
  end

  def update_quality(items) do
    Enum.map(items, fn item ->
      item_category = infer_item_category(item)
      update_item(item_category, item)
    end)
  end

  def update_item(:normal, item) do
    increment_by = if item.sell_in <= 0, do: -2, else: -1

    item
    |> increment_item_value_if_quality_less_than_threshold(increment_by)
    |> decrement_sell_in()
  end

  def update_item(:aged_brie, item) do
    item
    |> increment_item_value_if_quality_less_than_threshold(1)
    |> decrement_sell_in()
  end

  def update_item(:backstage_pass, %{sell_in: sell_in} = item) when sell_in > 0 do
    increment_by =
      cond do
        item.sell_in < 11 and item.sell_in >= 6 -> 2
        item.sell_in < 6 and item.sell_in > 0 -> 3
        true -> 1
      end

    item
    |> increment_item_value_if_quality_less_than_threshold(increment_by)
    |> decrement_sell_in()
  end

  def update_item(:backstage_pass, %{sell_in: sell_in} = item) when sell_in <= 0 do
    %{item | quality: 0}
    |> decrement_sell_in()
  end

  def update_item(:sulfuras, item) do
    item
  end

  def update_item(:conjured, item) do
    increment_by = if item.sell_in > 0, do: -2, else: -4

    item
    |> increment_item_value_if_quality_less_than_threshold(increment_by)
    |> decrement_sell_in()
  end

  defp increment_item_value_if_quality_less_than_threshold(item, increment_value, opts \\ []) do
    max_quality = Keyword.get(opts, :max_quality, @default_max_quality)
    min_quality = Keyword.get(opts, :min_quality, @default_min_quality)

    new_quality =
      (item.quality + increment_value)
      |> min(max_quality)
      |> max(min_quality)

    %{item | quality: new_quality}
  end

  defp decrement_sell_in(item, diff \\ -1) do
    %{item | sell_in: item.sell_in + diff}
  end
end
