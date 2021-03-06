import React        from 'react';
import EventActions from '../actions/events';
import LineGraph     from '../components/line_graph'

class Rain extends React.Component {

  constructor(props) {
    super(props);
    this.state = {}
  }

  render() {
    let data      = this.props.data || [];
    let icon      = this.props.icon;
    let className = `comp-metric ${this.props.className}`;
    let max       = Math.max.apply(Math,data.map((point) => {return point.value;}))

    let graphData = data.map( point => {
      return {ts: point.ts, count: point.value}
    });
    return (
      <div className={className}>
        <h2>{this.props.name}</h2>
        <div className="content">
          <div className="icon"><i className="material-icons">{icon}</i></div>
          <div className="description">
            <LineGraph height={50} className={this.props.className} max={max} data={graphData} gradientFrom={this.props.gradientFrom} gradientTo={this.props.gradientTo} />
          </div>
        </div>
      </div>
    );
  }

}

export default Rain;
