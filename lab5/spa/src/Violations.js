import React from 'react';
import './App.css';

import axios from 'axios';

class Violations extends React.Component{
    state = {
        violations: []
    }

    async componentDidMount() {
        const response = await axios.get("http://localhost:8080/sky/cloud/K5P6PzpMBd7bU7Z3ijAcao/temperature_store/threshold_violations");
        const data = await response.data;
        console.log("violation data", data)
        this.setState({violations: data.reverse()})
    }

    render() {
        return (
            this.state.violations.length === 0
            ?
            <div>There is no temperature threshold violation data to display.</div>
            :
            <div>
                <h2>Temperature Violation History</h2>
                <ul>
                    {this.state.violations.map(item => <li>{item.temperatureF}</li>)}
                </ul>
            </div>
        )
    }  
}

export default Violations;