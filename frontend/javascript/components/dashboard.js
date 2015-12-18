import connectToStores  from 'alt/utils/connectToStores';
import React            from 'react';
import RainStore        from '../stores/rain';
import MetricStore      from '../stores/metric';
import TrainStore       from '../stores/train';
import PresenceStore    from '../stores/presence';
import Rain             from './rain';
import Metric           from './metric';
import Train            from './train';
import Presence         from './presence';

class Dashboard extends React.Component {

  constructor(props) {
    super(props);
    this.state = {}
  }

  static getStores() {
    return [RainStore, MetricStore, TrainStore, PresenceStore];
  }

  static getPropsFromStores() {
    let trainStore    = TrainStore.getState();
    let rainStore     = RainStore.getState();
    let metricStore   = MetricStore.getState();
    let presenceStore = PresenceStore.getState();
    let loading       = trainStore.loading || rainStore.loading || metricStore.loading || presenceStore.loading;

    return {
      loading:    loading,
      rain:       rainStore.rain,
      metrics:    metricStore.metrics,
      departures: trainStore.departures,
      devices:    presenceStore.devices
    };
  }

  render() {
    if (this.props.loading) {
      return (
        <div className="comp-loading">Loading</div>
      );
    } else {
      return (
        <div className="comp-dashboard">
          <Rain rain={this.props.rain} />
          <Presence devices={this.props.devices} />
          <Train departures={this.props.departures} />
          <Metric gradientFrom="#7bdb00" gradientTo="#00aa22" className="electricity" name="Electricity" icon="flash_on" data={this.props.metrics.electricity.history} />
          <Metric gradientFrom="#ff7106" gradientTo="#c71c13" className="gas" name="Gas" icon="invert_colors" data={this.props.metrics.gas.history} />
          <Metric gradientFrom="#2f97f8" gradientTo="#002cc0" className="water" name="Water" icon="grain" data={this.props.metrics.water.history} />
        </div>
      );
    }
  }
}

export default connectToStores(Dashboard);
