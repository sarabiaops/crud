CREATE OR REPLACE FUNCTION create_purchase_with_items(purchase_data JSON, items_data JSONB[])
RETURNS void AS $$
DECLARE
    new_purchase_id integer;
    purchase_type integer;
BEGIN
    -- Determine the numerical value for the purchase type
    purchase_type := (purchase_data->>'type')::integer;

    -- Insert the purchase
    INSERT INTO purchases (storage_id, type, active)
    VALUES (
        NULLIF((purchase_data->>'storage_id')::integer, 0), -- Convert '0' to NULL for nullable field
        purchase_type,
        (purchase_data->>'active')::boolean
    ) RETURNING id INTO new_purchase_id;

    -- Insert purchase items
    FOR i IN 1 .. array_length(items_data, 1)
    LOOP
        INSERT INTO purchase_items (purchase_id, product_id, qty, unitary_price, active)
        VALUES (
            new_purchase_id,
            (items_data[i]->>'product_id')::integer,
            (items_data[i]->>'qty')::integer,
            (items_data[i]->>'unitary_price')::numeric,
            (items_data[i]->>'active')::boolean
        );
    END LOOP;
END;
$$ LANGUAGE plpgsql;