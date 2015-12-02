import React from 'react';
import request from 'superagent'

class Light extends React.Component {

  constructor(props) {
    super(props);
    this.state = {}
    this._handleClickOn  = this._handleClickOn.bind(this);
    this._handleClickOff = this._handleClickOff.bind(this);
  }

  render() {
    return (
      <div className="light">
        <span>{this.props.description}</span>
        <a href="" onClick={this._handleClickOn}>On</a>
        <a href="" onClick={this._handleClickOff}>Off</a>
      </div>
    );
  }

  _handleClickOn(event) {
    event.preventDefault();
    event.stopPropagation();

    this.toggleState('on')
  }

  _handleClickOff(event) {
    event.preventDefault();
    event.stopPropagation();

    this.toggleState('off')
  }

  toggleState(state) {
    var body = {
      action: `components/${this.props.component}/${this.props.id}/${state}`,
      params: {}
    }
    request
      .post('http://192.168.0.55:8080/api/events/trigger')
      .set('Content-Type', 'application/json')
      .send(JSON.stringify(body))
      .end(function(err, res){})
  }
}

export default Light;
