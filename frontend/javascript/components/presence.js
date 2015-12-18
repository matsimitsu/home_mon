import React  from 'react';
import moment from 'moment';

class Presence extends React.Component {

  constructor(props) {
    super(props);
    this.state = {}
  }

  render() {
    let deviceRows = this.props.devices.map( (device, i) => {
      let last_seen_at = "Unknown"
      if (device.last_seen_at) {
        last_seen_at = moment.utc(device.last_seen_at, 'YYYY-MM-DD HH:mm:ss').local().fromNow()
      }

      return <tr key={i}><td>{device.name}</td><td>{last_seen_at}</td></tr>
    })

    return (
      <div className="comp-presence">
        <h2>Presence</h2>
        <div className="content">
          <table className="devices">
            <thead>
              <tr>
                <th className="name">Name</th>
                <th className="last-seen">Last seen</th>
              </tr>
            </thead>
            <tbody>
              {deviceRows}
            </tbody>
          </table>
        </div>
      </div>
    );
  }

}

export default Presence;
