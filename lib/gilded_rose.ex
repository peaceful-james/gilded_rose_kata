defmodule GildedRose do
  # Example
  # update_quality([%Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 9, quality: 1}])
  # => [%Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 8, quality: 3}]

  def update_quality(items) do
    Enum.map(items, &update_item/1)
  end

  @min_quality 0
  @max_quality 50
  def update_item(%{name: "Aged Brie"} = item) do
    item
    |> increment_item_value_if_quality_less_than_threshold(1)
    |> decrement_sell_in()
  end

  def update_item(%{name: "Backstage passes to a TAFKAL80ETC concert", quality: quality, sell_in: sell_in} = item)
      when sell_in > 0 do
    increment_by =
      cond do
        quality >= @max_quality -> 0
        item.sell_in < 11 and item.sell_in >= 6 -> 2
        item.sell_in < 6 and item.sell_in > 0 -> 3
        true -> 1
      end

    item
    |> increment_item_value_if_quality_less_than_threshold(increment_by)
    |> decrement_sell_in()
  end

  def update_item(%{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: sell_in} = item)
      when sell_in <= 0 do
    %{item | quality: 0}
    |> decrement_sell_in()
  end

  def update_item(%{name: "Sulfuras, Hand of Ragnaros"} = item) do
    item
  end

  def update_item(%{name: "Conjured Mana Cake"} = item) do
    item
    |> increment_item_value_if_quality_less_than_threshold(-1)
    |> decrement_sell_in()
  end

  def update_item(item) do
    increment_by = if item.sell_in <= 0, do: -2, else: -1

    item
    |> increment_item_value_if_quality_less_than_threshold(increment_by)
    |> decrement_sell_in()
  end

  defp increment_item_value_if_quality_less_than_threshold(item, increment_value, opts \\ []) do
    max_quality = Keyword.get(opts, :max_quality, @max_quality)
    min_quality = Keyword.get(opts, :min_quality, @min_quality)

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
