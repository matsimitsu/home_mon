import React from 'react';
import request from 'superagent'

class Scene extends React.Component {

  constructor(props) {
    super(props);
    this.state = {}
    this._handleClick = this._handleClick.bind(this);
  }

  render() {
    return (
      <div className="scene">
        <span>{this.props.description}</span>
        <a href="" onClick={this._handleClick}>Trigger</a>
      </div>
    );
  }

  _handleClick(event) {
    event.preventDefault();
    event.stopPropagation();

    var body = {
      action: `components/scene/${this.props.id}/trigger`,
      params: {}
    }
    request
      .post('http://192.168.0.55:8080/api/events/trigger')
      .set('Content-Type', 'application/json')
      .send(JSON.stringify(body))
      .end(function(err, res){})
  }
}

export default Scene;
