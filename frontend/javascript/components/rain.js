import React        from 'react';
import EventActions from '../actions/events';
import BarGraph     from '../components/bar_graph'

class Rain extends React.Component {

  constructor(props) {
    super(props);
    this.state = {}
  }

  render() {
    let icon     = null;
    let forecast = this.props.rain.forecast || [];

    if (this.props.rain.rain_or_shine == 'shine') {
      icon = 'wb_sunny'
    } else {
      icon = 'wb_cloudy'
    }

    // Get the maximum count from the array, so we can calculate percentages.
    let max = 1;

    let graphData = forecast.map( (fc, i) => {
      return {ts: fc.ts, count: fc.mm}
    });

    return (
      <div className="comp-rain">
        <h2>Rain forecast</h2>
        <div className="content">
          <div className="icon"><i className="material-icons">{icon}</i></div>
          <div className="description">
            <BarGraph max="1" data={graphData} />
          </div>
        </div>
      </div>
    );
  }

}

export default Rain;
