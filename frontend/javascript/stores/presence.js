import alt              from '../alt'
import ComponentActions from '../actions/components'

class PresenceStore {
  constructor() {
    this.bindListeners({
      onLoadComponents:     ComponentActions.LOAD_COMPONENTS,
      onReceivedComponents: ComponentActions.RECEIVED_COMPONENTS,
      onError:              ComponentActions.ERROR
    })

    // State
    this.loading = true;
    this.error   = null;
    this.devices = [];
  }

  onLoadComponents() {
    this.loading = true;
  }

  onReceivedComponents(components) {
    this.loading = false;
    this.error   = null;
    this.devices = components.presence[0].devices || [];
  }

  onError(error) {
    this.loading = false;
    this.error   = error;
  }

  getState() {
    return {
      devices: this.devices,
      loading: this.loading
    }
  }
}
export default alt.createStore(PresenceStore, 'PresenceStore');
