import React from 'react';
import './App.css';

import axios from 'axios';

class Temperatures extends React.Component{
    state = {
        temperatures: []
    }

    async componentDidMount() {
        const response = await axios.get("http://localhost:8080/sky/cloud/K5P6PzpMBd7bU7Z3ijAcao/temperature_store/temperatures");
        const data = await response.data;
        this.setState({temperatures: data.reverse()})
    }

    render() {
        return (
            this.state.temperatures.length === 0
            ?
            <div>There is no temperature history to display.</div>
            :
            <div>
                <h2>Temperature History</h2>
                <ul>
                    {this.state.temperatures.map(item => <li>{item.temperatureF}</li>)}
                </ul>
            </div>
        )
    }
}

export default Temperatures;