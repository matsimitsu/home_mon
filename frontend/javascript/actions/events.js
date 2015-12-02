import alt           from '../alt';
import HomeMonClient from '../api/home_mon_client'

class EventActions {
  constructor() {
    this.generateActions('sentEvent', 'error');
  }

  triggerEvent(params) {
    this.dispatch();
    HomeMonClient.triggerEvent(params, ( () => {
      this.actions.sentEvent();
    }).bind(this), ( error => {
      this.actions.error(error);
    }).bind(this));
  }
}

export default alt.createActions(EventActions);
