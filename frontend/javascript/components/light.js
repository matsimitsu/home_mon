import React        from 'react';
import EventActions from '../actions/events'

class Light extends React.Component {

  constructor(props) {
    super(props);
    this.state = {}
    this._handleClickOn  = this._handleClickOn.bind(this);
    this._handleClickOff = this._handleClickOff.bind(this);
  }

  render() {
    return (
      <div className="light sidebar-row">
        <span className="text">{this.props.description}</span>
        <div className="mod-button-group">
          <a href="" onClick={this._handleClickOn}>On</a>
          <a href="" onClick={this._handleClickOff}>Off</a>
        </div>
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
    EventActions.triggerEvent(body)
  }
}

export default Light;
