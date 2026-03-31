ALTER TABLE Items.LuggageItem
ADD COLUMN weight DECIMAL(9, 4) DEFAULT 0.0;

ALTER TABLE Items.LuggageItem DROP COLUMN weight;

ALTER TABLE Items.LuggageItemType
ALTER COLUMN itemName TYPE VARCHAR(255);

ALTER TABLE Items.LuggageItemType
ADD CONSTRAINT length_check CHECK (length(itemname) > 0);