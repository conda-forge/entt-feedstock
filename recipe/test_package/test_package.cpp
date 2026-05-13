#include <cassert>

#include <entt/entity/registry.hpp>

struct position {
    float x;
    float y;
};

struct velocity {
    float dx;
    float dy;
};

int main() {
    entt::registry registry;
    const auto entity = registry.create();

    registry.emplace<position>(entity, 1.0F, 2.0F);
    registry.emplace<velocity>(entity, 0.5F, -1.0F);

    registry.view<position, const velocity>().each([](auto, position &pos, const velocity &vel) {
        pos.x += vel.dx;
        pos.y += vel.dy;
    });

    const auto &pos = registry.get<position>(entity);
    assert(pos.x == 1.5F);
    assert(pos.y == 1.0F);

    return 0;
}
