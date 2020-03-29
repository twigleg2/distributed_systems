import React from 'react';
import './App.css';
import './stats.css';

import history from './history.js'

import Temperatures from './Temperatures.js';
import Violations from './Violations.js';

class App extends React.Component {

  state = {
    format: "F",
    temperatures: [],
    violations: [],
  }

  render() {
    return (
      <div className="App">
        <h1>Current Temperature</h1>
        <p>current temperature goes here</p>
        <button onClick={() => history.push('/profile')}>Profile Information</button>
        <br/>
        <div className="stats">
          <Temperatures></Temperatures>
          <Violations></Violations>
          </div>
      </div>
    )
  }
}

export default App;