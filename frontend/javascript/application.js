import React                               from 'react';
import ReactDom                            from 'react-dom';
import { Router, Route, Link, IndexRoute } from 'react-router'
import { createHistory, useBasename }      from 'history'
import alt                                 from './alt'

import App                                 from './components/app';
import HomeMonClient                       from './api/home_mon_client';
import SceneStore                          from './stores/scene';
import Dashboard                           from './components/dashboard'
const history = useBasename(createHistory)({
  basename: '/'
})

ReactDom.render((
  <Router history={history}>
    <Route path="/" component={App}>
      <IndexRoute component={Dashboard} />
    </Route>
  </Router>
), document.getElementById('app'))
