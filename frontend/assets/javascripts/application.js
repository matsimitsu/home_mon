import React                   from 'react';
import ReactDom                from 'react-dom';
import { Router, Route, Link } from 'react-router'
import { createHistory, useBasename } from 'history'
import HomeMon   from './components/home_mon';

const history = useBasename(createHistory)({
  basename: '/'
})

ReactDom.render((
  <Router history={history}>
    <Route path="/" component={HomeMon}>
    </Route>
  </Router>
), document.getElementById('app'))
