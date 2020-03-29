import React from 'react';
import {Router, Switch, Route} from 'react-router-dom';

import App from "./App";
import Profile from "./Profile";

import history from './history';

class Routes extends React.Component {
    render() {
        return (
            <Router history={history}>
                <Switch>
                    <Route path="/" exact component={App}></Route>
                    <Route path="/profile" component={Profile}></Route>
                </Switch>
            </Router>
        )
    }
}

export default Routes;