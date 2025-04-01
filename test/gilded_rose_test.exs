defmodule GildedRoseTest do
  use ExUnit.Case
  alias GildedRose.TextTestFixture

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
               %Item{name: "Conjured Mana Cake", sell_in: 2, quality: 4}
             ]
    end
  end

  describe "normal item" do
    setup do
      %{item: TextTestFixture.normal_item()}
    end

    test "sell_in decreases to 9", %{item: item} do
      assert [%Item{sell_in: updated_sell_in}] = GildedRose.update_quality([item])
      assert updated_sell_in == 9
    end

    test "decreases in quality by 1 after 1 day when sell_in > 0", %{item: item} do
      assert [%Item{quality: updated_quality}] = GildedRose.update_quality([%{item | sell_in: 5}])
      assert updated_quality == item.quality - 1
    end

    test "decreases in quality by 2 after 1 day when sell_in <= 0", %{item: item} do
      assert [%Item{quality: updated_quality}] = GildedRose.update_quality([%{item | sell_in: 0}])
      assert updated_quality == item.quality - 2
    end

    test "can not decrease in quality below 0", %{item: item} do
      mix_quality = 0
      assert [%Item{quality: updated_quality}] = GildedRose.update_quality([%{item | quality: 0}])
      assert updated_quality == mix_quality
    end
  end

  describe "aged brie" do
    setup do
      %{item: TextTestFixture.aged_brie_item()}
    end

    test "increases in quality by 1 after 1 day", %{item: item} do
      assert [%Item{quality: updated_quality}] = GildedRose.update_quality([%{item | sell_in: 5}])
      assert updated_quality == item.quality + 1
    end
  end

  describe "sulfuras" do
    setup do
      %{item: TextTestFixture.sulfuras_item()}
    end

    test "sell_in does not decrease", %{item: item} do
      assert [%Item{sell_in: updated_sell_in}] = GildedRose.update_quality([item])
      assert updated_sell_in == item.sell_in
    end

    test "quality remains at 80", %{item: item} do
      assert item.quality == 80
      assert [%Item{quality: 80}] = GildedRose.update_quality([item])
    end
  end

  describe "backstage passes" do
    setup do
      %{item: TextTestFixture.backstage_pass_item()}
    end

    test "increases in quality by 1 after 1 day when sell_in > 10", %{item: item} do
      assert [%Item{quality: updated_quality}] = GildedRose.update_quality([%{item | sell_in: 15}])
      assert updated_quality == item.quality + 1
    end

    test "increases in quality by 2 after 1 day when sell_in <= 10 and sell_in > 5", %{item: item} do
      assert [%Item{quality: updated_quality}] = GildedRose.update_quality([%{item | sell_in: 9}])
      assert updated_quality == item.quality + 2
    end

    test "increases in quality by 3 after 1 day when sell_in <= 5 and sell_in > 0", %{item: item} do
      assert [%Item{quality: updated_quality}] = GildedRose.update_quality([%{item | sell_in: 3}])
      assert updated_quality == item.quality + 3
    end

    test "quality drops to 0 after 1 day when sell_in <= 0", %{item: item} do
      assert [%Item{quality: updated_quality}] = GildedRose.update_quality([%{item | sell_in: 0}])
      assert updated_quality == 0
      assert [%Item{quality: updated_quality}] = GildedRose.update_quality([%{item | sell_in: -4}])
      assert updated_quality == 0
    end

    test "cannot have quality > 50", %{item: item} do
      max_quality = 50

      assert [%Item{quality: updated_quality}] =
               GildedRose.update_quality([%{item | quality: max_quality, sell_in: 15}])

      assert updated_quality == max_quality
    end
  end

  describe "conjured items" do
    setup do
      %{item: TextTestFixture.conjured_item()}
    end

    test "decreases in quality by 2 after 1 day when sell_in > 0", %{item: item} do
      assert [%Item{quality: updated_quality}] = GildedRose.update_quality([%{item | sell_in: 5}])
      assert updated_quality == item.quality - 2
    end

    test "decreases in quality by 4 after 1 day when sell_in <= 0", %{item: item} do
      assert [%Item{quality: updated_quality}] = GildedRose.update_quality([%{item | sell_in: 0}])
      assert updated_quality == item.quality - 4
      assert [%Item{quality: updated_quality}] = GildedRose.update_quality([%{item | sell_in: -2}])
      assert updated_quality == item.quality - 4
    end
  end
end
