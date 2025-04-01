defmodule GildedRose.TextTestFixture do
  def assorted_items do
    [
      %Item{name: "+5 Dexterity Vest", sell_in: 10, quality: 20},
      %Item{name: "Aged Brie", sell_in: 2, quality: 0},
      %Item{name: "Elixir of the Mongoose", sell_in: 5, quality: 7},
      %Item{name: "Sulfuras, Hand of Ragnaros", sell_in: 0, quality: 80},
      %Item{name: "Sulfuras, Hand of Ragnaros", sell_in: -1, quality: 80},
      %Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 15, quality: 20},
      %Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 10, quality: 49},
      %Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 5, quality: 49},
      # This Conjured item does not work properly yet
      %Item{name: "Conjured Mana Cake", sell_in: 3, quality: 6}
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
