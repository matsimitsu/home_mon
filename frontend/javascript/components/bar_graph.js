import React        from 'react';
import EventActions from '../actions/events';
import moment       from 'moment';

class BarGraph extends React.Component {

  constructor(props) {
    super(props);
    this.state = {}
  }

  render() {
    let elements = this.props.data.map( (point, i) => {
      let height    = 1;
      let time      = moment(point.ts, 'YYYY-MM-DD HH:mm:ss Z');
      let className = "";

      // If we have a count and max > 0, use it to calculate percentage
      if(point.count > 0) {
        height = Math.round((point.count / this.props.max) * 100);
      }

      return <div key={i} className={className} style={{height: `${height}%`}}>&nbsp;</div>
    });

    return (
      <div className="mod-graph">
        {elements}
      </div>
    );
  }

}

export default BarGraph;
