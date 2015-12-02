import alt              from '../alt'
import ComponentActions from '../actions/components'

class LightStore {
  constructor() {
    this.bindListeners({
      onLoadComponents:     ComponentActions.LOAD_COMPONENTS,
      onReceivedComponents: ComponentActions.RECEIVED_COMPONENTS,
      onError:              ComponentActions.ERROR
    })

    // State
    this.loading = true;
    this.error   = null;
    this.lights  = [];
  }

  onLoadComponents() {
    this.loading = true;
  }

  onReceivedComponents(components) {
    this.loading = false;
    this.error   = null;
    let lights = []
    lights = lights.concat(components.lifx);
    lights = lights.concat(components.kaku);
    lights = lights.concat(components.blokker);
    this.lights = lights;
  }

  onError(error) {
    this.loading = false;
    this.error   = error;
  }

  getState() {
    lights: this.lights;

  }
}
export default alt.createStore(LightStore, 'LightStore');
