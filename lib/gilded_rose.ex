defmodule GildedRose do
  # Example
  # update_quality([%Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 9, quality: 1}])
  # => [%Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 8, quality: 3}]

  def update_quality(items) do
    Enum.map(items, &update_item/1)
  end

  def update_item(item) do
    item =
      if item.name != "Aged Brie" && item.name != "Backstage passes to a TAFKAL80ETC concert" do
        if item.quality > 0 do
          if item.name != "Sulfuras, Hand of Ragnaros" do
            %{item | quality: item.quality - 1}
          else
            item
          end
        else
          item
        end
      else
        if item.quality < 50 do
          item = %{item | quality: item.quality + 1}

          if item.name == "Backstage passes to a TAFKAL80ETC concert" do
            cond do
              item.sell_in < 11 and item.sell_in >= 6 ->
                increment_item_value_if_quality_less_than_threshold(item, 50, 1)

              item.sell_in < 6 and item.sell_in > 0 ->
                increment_item_value_if_quality_less_than_threshold(item, 50, 2)

              true ->
                item
            end
          else
            item
          end
        else
          item
        end
      end

    item =
      cond do
        item.name != "Sulfuras, Hand of Ragnaros" ->
          %{item | sell_in: item.sell_in - 1}

        true ->
          item
      end

    cond do
      item.sell_in < 0 ->
        cond do
          item.name != "Aged Brie" ->
            cond do
              item.name != "Backstage passes to a TAFKAL80ETC concert" ->
                cond do
                  item.quality > 0 ->
                    cond do
                      item.name != "Sulfuras, Hand of Ragnaros" ->
                        %{item | quality: item.quality - 1}

                      true ->
                        item
                    end

                  true ->
                    item
                end

              true ->
                %{item | quality: item.quality - item.quality}
            end

          true ->
            increment_item_value_if_quality_less_than_threshold(item, 50, 1)
        end

      true ->
        item
    end
  end

  defp increment_item_value_if_quality_less_than_threshold(item, quality_threshold, increment_value) do
    if item.quality < quality_threshold do
      %{item | quality: item.quality + increment_value}
    else
      item
    end
  end
end
