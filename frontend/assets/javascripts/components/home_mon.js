import React from 'react';

class HomeMon extends React.Component {

  constructor(props) {
    super(props);
    this.state = {messages: ''}
  }

  componentDidMount() {
    var component = this;
    var ws = new WebSocket("ws://localhost:8081");
    ws.onmessage = function (event) {
      var message = JSON.parse(event.data);
      component.setState({message: message.message})
    }
  }
  render() {
    return (
      <div>
        <h1>Woot!</h1>
        <p>{JSON.stringify(this.state.message)}</p>
      </div>
    );
  }
}


export default HomeMon;
