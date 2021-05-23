enum TileType {
    Empty;
    Square;
    Slope(rotation:TileRotation);
    Spring(rotation:SpringDirection);
}