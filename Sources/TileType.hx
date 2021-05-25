enum TileType {
    Marble;
    Empty;
    Square;
    InnerSlope(rotation:TileRotation);
    OuterSlope(rotation:TileRotation);
    Slope(rotation:TileRotation);
    Spring(rotation:SpringDirection);
}