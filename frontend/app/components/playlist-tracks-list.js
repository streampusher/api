import Ember from 'ember';

export default Ember.Component.extend({
  store: Ember.inject.service(),
  isEditingSettings: false,
  isEditing: false,
  isSelectingPlaylist: false,
  interpolatedPlaylistIdString: Ember.computed('interpolatedPlaylistId', function(){
    var selectedId = this.get('playlist').get('interpolatedPlaylistId');
    return selectedId.toString();
  }),
  positionDesc: ["position:asc"],
  sortedPlaylistTracks: Ember.computed.sort('playlist.playlistTracks', 'positionDesc'),
  actions: {
    reorderItems(groupModel, itemModels, draggedModel) {
      var draggedToIndex = itemModels.findIndex(function(element){ return element.id === draggedModel.id });

      draggedModel.set('position_position', draggedToIndex);
      this.set('playlist.playlistTracks', itemModels);
      return Ember.RSVP.all([draggedModel.save(), groupModel.save()]);
    },
    selectPlaylist: function(){
      this.toggleProperty('isSelectingPlaylist');
    },
    editPlaylist: function(){
      this.toggleProperty('isEditing');
    },
    cancelEditing: function(){
      this.toggleProperty('isEditing');
      if(this.playlist.get('isNew')){
        this.set('playlist', this.get('oldPlaylist'));
      }
    },
    editPlaylistSettings: function(){
      this.toggleProperty('isEditingSettings');
    },
    newPlaylist: function(){
      var store = this.get('store');
      var playlist = store.createRecord('playlist');
      this.set('oldPlaylist', this.get('playlist'));
      this.set('playlist', playlist);
      this.set('isEditing', true);
    },
    selectInterpolatedPlaylistId: function(playlistId) {
      var playlist = this.get('playlist');
      playlist.set('interpolatedPlaylistId', playlistId);
    },
    saveSettings: function() {
      var playlist = this.get('playlist');
      var onSuccess = () =>{
        this.set('isEditingSettings', false);
      };
      var onFail = () =>{
        console.log("playlist settings save failed");
      };
      playlist.save().then(onSuccess, onFail);
      //$("#edit-playlist-modal").modal("toggle");
    },
    save: function() {
      var playlist = this.get('playlist');
      var onSuccess = () =>{
        this.set('isEditing', false);
      };
      var onFail = () =>{
        console.log("playlist save failed");
      };
      playlist.save().then(onSuccess, onFail);
    }
  }
});