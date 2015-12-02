import request from 'superagent'

class HomeMonClient {

  static getComponents(success, failure) {
    let hostname = window.location.hostname;

    request
      .get(`//${hostname}:8085/api/components`)
      .end( (err, res) => {
        if(res && res.status == 200) {
          success(res.body)
        } else {
          failure(`Failed to get component: ${err}`)
        }
      });
  }

  static triggerEvent(actionAndParams, success, failure) {
    let hostname = window.location.hostname;

    request
      .post(`//${hostname}:8085/api/events/trigger`)
      .set('Content-Type', 'application/json')
      .send(JSON.stringify(actionAndParams))
      .end( (err, res) => {
        if(res && res.status == 202) {
          success()
        } else {
          failure(`Failed to trigger event: ${err}`)
        }
      });
  }
}

export default HomeMonClient;
