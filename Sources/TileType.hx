enum TileType {
    Marble;
    Empty;
    Square;
    InnerSlope(rotation:TileRotation);
    Slope(rotation:TileRotation);
    Spring(rotation:SpringDirection);
}