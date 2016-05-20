import DS from 'ember-data';
import { validator, buildValidations } from 'ember-cp-validations';

const Validations = buildValidations({
  name: validator('presence', { presence: true, message: "cannot be blank", debounce: 500}),
});


export default DS.Model.extend(Validations, {
  name: DS.attr(),
  playlistTracks: DS.hasMany('playlist-track'),
  interpolatedPlaylistTrackIntervalCount: DS.attr(),
  interpolatedPlaylistTrackPlayCount: DS.attr(),
  interpolatedPlaylistId: DS.attr(),
  interpolatedPlaylistEnabled: DS.attr()
});
