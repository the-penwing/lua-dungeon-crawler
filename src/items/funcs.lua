local function getItemById(itemId)
  for _, v in pairs(require('src.items.data')) do
    for _, itemData in pairs(v) do
      if itemData.id == itemId then
        return itemData
      end
    end
  end
  return nil
end

return getItemById
