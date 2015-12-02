import alt           from '../alt';
import HomeMonClient from '../api/home_mon_client'

class ComponentActions {
  constructor() {
    this.generateActions('receivedComponents', 'error');
  }

  loadComponents() {
    this.dispatch();

    HomeMonClient.getComponents( (components => {
       this.actions.receivedComponents(components);
     }).bind(this), ( error => {
       this.actions.error(error);
     }).bind(this));
  }
}

export default alt.createActions(ComponentActions);
