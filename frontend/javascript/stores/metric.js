import alt              from '../alt'
import ComponentActions from '../actions/components'

class MetricStore {
  constructor() {
    this.bindListeners({
      onLoadComponents:     ComponentActions.LOAD_COMPONENTS,
      onReceivedComponents: ComponentActions.RECEIVED_COMPONENTS,
      onError:              ComponentActions.ERROR
    })

    // State
    this.loading = true;
    this.error   = null;
    this.metrics = {};
  }

  onLoadComponents() {
    this.loading = true;
  }

  onReceivedComponents(components) {
    this.loading = false;
    this.error   = null;
    this.metrics = {};
    for (var metric of components.metric) {
      this.metrics[metric.id] = metric
    }
  }

  onError(error) {
    this.loading = false;
    this.error   = error;
  }

  getState() {
    return {
      metrics: this.metrics,
      loading: this.loading
    }
  }
}
export default alt.createStore(MetricStore, 'MetricStore');
