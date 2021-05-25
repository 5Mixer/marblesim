package ;

import kha.math.FastMatrix3;
import kha.graphics2.Graphics;
import kha.math.Vector2;

class Camera {
    public var position:Vector2 = new Vector2();
    var movementSpeed = 10;
    public function new() {

    }
    inline function getTransform() {
        return FastMatrix3.translation(-position.x, -position.y);
    }
    inline public function transform(g:Graphics) {
        g.pushTransformation(g.transformation.multmat(getTransform()));
    }
    inline public function endTransform(g:Graphics) {
        g.popTransformation();
    }
    public function screenToWorld(screenPoint:Vector2) {
        return getTransform().inverse().multvec(screenPoint.fast());
    }
    public function moveUp() {
        position.y -= movementSpeed;
    }
    public function moveDown() {
        position.y += movementSpeed;
    }
    public function moveLeft() {
        position.x -= movementSpeed;
    }
    public function moveRight() {
        position.x += movementSpeed;
    }
}