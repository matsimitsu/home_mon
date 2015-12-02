import alt              from '../alt'
import ComponentActions from '../actions/components'

class TrainStore {
  constructor() {
    this.bindListeners({
      onLoadComponents:     ComponentActions.LOAD_COMPONENTS,
      onReceivedComponents: ComponentActions.RECEIVED_COMPONENTS,
      onError:              ComponentActions.ERROR
    })

    // State
    this.loading    = true;
    this.error      = null;
    this.departures = [];
  }

  onLoadComponents() {
    this.loading = true;
  }

  onReceivedComponents(components) {
    this.loading    = false;
    this.error      = null;
    this.departures = components.train[0].departures;
  }

  onError(error) {
    this.loading = false;
    this.error   = error;
  }

  getState() {
    return {
      departures: this.departures,
      loading: this.loading
    }
  }
}
export default alt.createStore(TrainStore, 'TrainStore');
