defmodule GildedRose.TextTestFixture do
  def normal_item, do: %Item{name: "+5 Dexterity Vest", sell_in: 10, quality: 20}
  def aged_brie_item, do: %Item{name: "Aged Brie", sell_in: 2, quality: 0}
  def sulfuras_item, do: %Item{name: "Sulfuras, Hand of Ragnaros", sell_in: 0, quality: 80}
  def backstage_pass_item, do: %Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 15, quality: 20}
  def conjured_item, do: %Item{name: "Conjured Mana Cake", sell_in: 3, quality: 6}

  def assorted_items do
    [
      normal_item(),
      aged_brie_item(),
      %Item{name: "Elixir of the Mongoose", sell_in: 5, quality: 7},
      sulfuras_item(),
      %Item{name: "Sulfuras, Hand of Ragnaros", sell_in: -1, quality: 80},
      backstage_pass_item(),
      %Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 10, quality: 49},
      %Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 5, quality: 49},
      # This Conjured item does not work properly yet
      conjured_item()
    ]
  end

  def run() do
    IO.puts("OMGHAI!")

    items = assorted_items()

    %{report_lines: report_lines} =
      Enum.reduce(0..1, %{items: items, report_lines: []}, fn day,
                                                              %{
                                                                items: items,
                                                                report_lines: report_lines
                                                              } ->
        report_lines = report_lines ++ ["-------- day #{day} --------"]
        report_lines = report_lines ++ ["name, sellIn, quality"]

        report_lines =
          report_lines ++
            [Enum.map(items, fn item -> "#{item.name}, #{item.sell_in}, #{item.quality}" end)]

        report_lines = report_lines ++ [""]

        %{
          items: GildedRose.update_quality(items),
          report_lines: List.flatten(report_lines)
        }
      end)

    IO.puts(Enum.join(report_lines, "\n"))
  end
end
