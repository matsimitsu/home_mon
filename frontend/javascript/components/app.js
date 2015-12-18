import connectToStores  from 'alt/utils/connectToStores';
import React            from 'react';
import Sidebar          from 'react-sidebar'
import SceneStore       from '../stores/scene';
import LightStore       from '../stores/light';
import RainStore        from '../stores/rain';
import ComponentActions from '../actions/components'
import Scene            from './scene';
import Light            from './light';

class App extends React.Component {

  constructor(props) {
    super(props);
    this.state = {sidebarOpen: false, sidebarDocked: false}
    this._handleSidebarOpen = this._handleSidebarOpen.bind(this);
    this._toggleOpen = this._toggleOpen.bind(this);
    this._handleReloadClick = this._handleReloadClick.bind(this);
  }

  _handleSidebarOpen(open) {
    this.setState({sidebarOpen: open});
  }

  static getStores() {
    return [SceneStore, LightStore];
  }

  static getPropsFromStores() {
    return {
      scenes: SceneStore.getState().scenes,
      lights: LightStore.getState().lights
    };
  }

  componentDidMount() {
    ComponentActions.loadComponents()
  }

  _handleReloadClick(ev) {
    ComponentActions.loadComponents()
    if (ev) { ev.preventDefault() }
  }

  _toggleOpen(ev) {
    this.setState({sidebarOpen: !this.state.sidebarOpen});
    if (ev) { ev.preventDefault() }
  }

  render() {
    let scenes = this.props.scenes.map((scene, i) => {
      return <Scene key={i} id={scene.id} description={scene.description || scene.name ||  scene.id} />
    });

    let lights = this.props.lights.map((light, i) => {
      return <Light key={i} component={light.component} id={light.id} description={light.description || light.name || light.id} />
    });

    let sidebarContent = (
      <div className="comp-sidebar">
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

    return (
      <div>
        <header className="comp-header">
          <a href="" onClick={this._toggleOpen} ><i className="material-icons">menu</i></a>
          <h1>HomeMon</h1>
          <a href="" onClick={this._handleReloadClick}><i className="material-icons">refresh</i></a>
        </header>
        <Sidebar
          sidebar={sidebarContent}
          open={this.state.sidebarOpen}
          docked={this.state.sidebarDocked}
          onSetOpen={this._handleSidebarOpen}
        >
          <div className="main-content">
            {this.props.children}
          </div>
        </Sidebar>
      </div>
    );
  }
}
export default connectToStores(App);
