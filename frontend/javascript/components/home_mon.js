import React from 'react';
import request from 'superagent'
import Scene from './scene'
import Light from './light'

class HomeMon extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      scenes: [],
      lights: []
    }
  }

  componentDidMount() {
    var component = this;
    request
      .get('http://192.168.0.55:8080/api/components')
      .end(function(err, res){
        var lights = [];
        lights = lights.concat(res.body.lifx|| []);
        lights = lights.concat(res.body.kaku || []);

        component.setState({
          scenes: res.body.scene,
          lights: lights
        })
      })
  }
  render() {
    var scenes = this.state.scenes.map((scene, i) => {
      return <Scene key={i} id={scene.id} description={scene.description || scene.id} />
    });

    console.log(this.state.lights)
    var lights = this.state.lights.map((light, i) => {
      return <Light key={i} component={light.component} id={light.id} description={light.description || light.id} />
    });
    return (
      <div>
        <div className="comp-scenes">
          <h2>Scenes</h2>
          {scenes}
        </div>
        <div className="comp-lights">
          <h2>Lights</h2>
          {lights}
        </div>
      </div>
    );
  }
}


export default HomeMon;
