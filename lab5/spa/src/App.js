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
    current_temperature: 0,
  }

  getCurrentTemperature = (temperature) => {
    this.setState({current_temperature: temperature})
  }

  render() {
    return (
      <div className="App">
        <h1>Current Temperature</h1>
        <p>{this.state.current_temperature} F</p>
        <button onClick={() => history.push('/profile')}>Profile Information</button>
        <br/>
        <div className="stats">
          <Temperatures getCurrentTemperature={this.getCurrentTemperature}></Temperatures>
          <Violations></Violations>
          </div>
      </div>
    )
  }
}

export default App;