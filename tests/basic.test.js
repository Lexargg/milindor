const assert = require('assert');

describe('Basic Tests', () => {
  it('should validate the structure of the continents', () => {
    const continents = require('../data/continents/elarion.json');
    assert(continents.name, 'Elarion');
    assert(continents.geography, 'Montagne maestose e valli incantate, ricche di minerali preziosi e flora rara.');
  });

  it('should validate the NPC mapping', () => {
    const mapping = require('../data/mapping_npc.json');
    assert(mapping.some(npc => npc.original_name === 'Aurion the Wise'), 'Aurion the Wise should exist in mapping');
  });

  it('should validate the missions structure', () => {
    const missions = require('../data/missions.json');
    assert(missions.length > 0, 'Missions should not be empty');
  });
});
