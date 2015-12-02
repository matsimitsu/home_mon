import alt              from '../alt'
import ComponentActions from '../actions/components'

class SceneStore {
  constructor() {
    this.bindListeners({
      onLoadComponents:     ComponentActions.LOAD_COMPONENTS,
      onReceivedComponents: ComponentActions.RECEIVED_COMPONENTS,
      onError:              ComponentActions.ERROR
    })

    // State
    this.loading = true;
    this.error   = null;
    this.scenes  = [];
  }

  onLoadComponents() {
    this.loading = true;
  }

  onReceivedComponents(components) {
    this.loading = false;
    this.error   = null;
    this.scenes = components.scene;
  }

  onError(error) {
    this.loading = false;
    this.error   = error;
  }

  getState() {
    scenes: this.scenes;

  }
}
export default alt.createStore(SceneStore, 'SceneStore');
