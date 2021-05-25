enum TileType {
    Marble;
    Empty;
    Square;
    Slope(rotation:TileRotation);
    Spring(rotation:SpringDirection);
}