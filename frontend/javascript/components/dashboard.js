import connectToStores  from 'alt/utils/connectToStores';
import React            from 'react';
import RainStore        from '../stores/rain';
import MetricStore      from '../stores/metric';
import TrainStore       from '../stores/train';
import Rain             from './rain';
import Metric           from './metric';
import Train            from './train';

class Dashboard extends React.Component {

  constructor(props) {
    super(props);
    this.state = {}
  }

  static getStores() {
    return [RainStore, MetricStore, TrainStore];
  }

  static getPropsFromStores() {
    let trainStore  = TrainStore.getState();
    let rainStore   = RainStore.getState();
    let metricStore = MetricStore.getState();
    let loading     = trainStore.loading || rainStore.loading || metricStore.loading;

    return {
      loading:    loading,
      rain:       rainStore.rain,
      metrics:    metricStore.metrics,
      departures: trainStore.departures
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
          <Train departures={this.props.departures} />
          <Metric className="electricity" name="Electricity" icon="flash_on" data={this.props.metrics.electricity.history} />
          <Metric className="gas" name="Gas" icon="invert_colors" data={this.props.metrics.gas.history} />
          <Metric className="water" name="Water" icon="grain" data={this.props.metrics.water.history} />
        </div>
      );
    }
  }
}

export default connectToStores(Dashboard);
