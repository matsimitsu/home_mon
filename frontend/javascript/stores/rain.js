import alt              from '../alt'
import ComponentActions from '../actions/components'

class RainStore {
  constructor() {
    this.bindListeners({
      onLoadComponents:     ComponentActions.LOAD_COMPONENTS,
      onReceivedComponents: ComponentActions.RECEIVED_COMPONENTS,
      onError:              ComponentActions.ERROR
    })

    // State
    this.loading = true;
    this.error   = null;
    this.rain    = {};
  }

  onLoadComponents() {
    this.loading = true;
  }

  onReceivedComponents(components) {
    this.loading = false;
    this.error   = null;
    this.rain    = components.rain[0];
  }

  onError(error) {
    this.loading = false;
    this.error   = error;
  }

  getState() {
    return {
      rain: this.rain,
      loading: this.loading
    }
  }
}
export default alt.createStore(RainStore, 'RainStore');
