import React        from 'react';
import EventActions from '../actions/events'

class Scene extends React.Component {

  constructor(props) {
    super(props);
    this.state = {}
    this._handleClick = this._handleClick.bind(this);
  }

  render() {
    return (
      <div className="scene sidebar-row">
        <span className="text">{this.props.description}</span>
        <div className="mod-button-group">
          <a href="" onClick={this._handleClick}>Trigger</a>
        </div>
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
    EventActions.triggerEvent(body)
  }
}

export default Scene;
