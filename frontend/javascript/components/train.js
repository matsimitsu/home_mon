import React  from 'react';
import moment from 'moment';

class Train extends React.Component {

  constructor(props) {
    super(props);
    this.state = {}
  }

  render() {
    let departureRows = this.props.departures.map( (departure, i) => {
      let time = moment(departure.VertrekTijd)

      let via_or_remark = <td className="via">{departure.RouteTekst}</td>

      // If we have a delay, show that instead of the route
      if(departure.Opmerkingen && departure.Opmerkingen.Opmerking) {
        via_or_remark= <td className="delay">{departure.Opmerkingen.Opmerking}</td>
      }
      return (
        <tr key={i}>
          <td>{departure.VertrekSpoor}</td>
          <td>{time.format('HH:mm')}</td>
          <td className="delay">{(departure.VertrekVertragingTekst || "").replace(' min', '')}</td>
          <td>{departure.EindBestemming}</td>
          {via_or_remark}
        </tr>
      )
    })
    return (
      <div className="comp-train">
        <h2>Departures</h2>
        <div className="content">
          <table className="departures">
            <thead>
              <tr>
                <th>Tr.</th>
                <th>Time</th>
                <th>Delay</th>
                <th>Destination</th>
                <th>Via</th>
              </tr>
            </thead>
            <tbody>
              {departureRows}
            </tbody>
          </table>
        </div>
      </div>
    );
  }

}

export default Train;
