defmodule GildedRoseTest do
  use ExUnit.Case
  alias GildedRose.TextTestFixture

  test "begin the journey of refactoring" do
    items = [%Item{name: "foo", sell_in: 0, quality: 0}]
    GildedRose.update_quality(items)
    %{name: firstItemName} = List.first(items)
    assert "fixme" == firstItemName
  end

  describe "bulk black-box test" do
    test "has not broken" do
      items = TextTestFixture.assorted_items()
      result = GildedRose.update_quality(items)

      assert result == [
               %Item{name: "+5 Dexterity Vest", sell_in: 9, quality: 19},
               %Item{name: "Aged Brie", sell_in: 1, quality: 1},
               %Item{name: "Elixir of the Mongoose", sell_in: 4, quality: 6},
               %Item{name: "Sulfuras, Hand of Ragnaros", sell_in: 0, quality: 80},
               %Item{name: "Sulfuras, Hand of Ragnaros", sell_in: -1, quality: 80},
               %Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 14, quality: 21},
               %Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 9, quality: 50},
               %Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 4, quality: 50},
               %Item{name: "Conjured Mana Cake", sell_in: 2, quality: 5}
             ]
    end
  end

  describe "normal item" do
    test "decreases in quality by 1 after 1 day when sell_in < 0"
    test "decreases in quality by 2 after 1 day when sell_in <= 0"
    test "cannot have quality > 50"
  end

  describe "aged brie" do
    test "increases in quality by 1 after 1 day"
  end

  describe "sulfuras" do
    test "quality remains at 80"
  end

  describe "backstage passes" do
    test "increases in quality by 1 after 1 day when sell_in > 10"
    test "increases in quality by 2 after 1 day when sell_in <= 10 and sell_in > 5"
    test "increases in quality by 3 after 1 day when sell_in <= 5 and sell_in > 0"
    test "quality drops to 0 after 1 day when sell_in <= 0"
  end

  describe "conjured items" do
    test "decreases in quality by 2 after 1 day when sell_in < 0"
    test "decreases in quality by 4 after 1 day when sell_in <= 0"
  end
end
