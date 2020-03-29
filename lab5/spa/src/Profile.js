import React from 'react';
import './Profile.css';

import axios from 'axios';

class Profile extends React.Component {
    state = {
        profile: null,
        new_name: "",
        new_location: "",
        new_SMS_number: "",
        new_threshold: ""

    }

    async componentDidMount() {
        const URL = "http://localhost:8080/sky/cloud/K5P6PzpMBd7bU7Z3ijAcao/sensor_profile/get_profile_data";
        const response = await axios.get(URL);
        const data = await response.data;
        this.setState({profile: data})
        console.log(data);
    }

    handleClick = async () => {
        const URL = "http://localhost:8080/sky/event/K5P6PzpMBd7bU7Z3ijAcao/1/sensor/profile_updated";
        const obj = {
            name: this.state.new_name,
            location: this.state.new_location,
            SMS_number: this.state.new_SMS_number,
            threshold: this.state.new_threshold,
        }
        const response = await axios.post(URL,obj);
        window.location.reload(false);
    }

    handleChange = (e) => {
        this.setState({[e.target.name]: e.target.value});
    }

    render() {
        return (
            this.state.profile === null
            ?
            <div>Loading...</div>
            :
            <div className="Profile">
                <h1>Current Profile Information</h1>

                <div>
                    <b>Name:</b> {this.state.profile.name}
                    <input
                        type="text"
                        placeholder="Enter a new name?"
                        value={this.state.new_name}
                        name="new_name"
                        onChange={this.handleChange}
                    />
                </div>
                <div>
                    <b>Location:</b> {this.state.profile.location}
                    <input
                        type="text"
                        placeholder="Enter a new location?"
                        value={this.state.new_location}
                        name="new_location"
                        onChange={this.handleChange}
                    />
                </div>
                <div>
                    <b>Phone Number to Notify:</b> {this.state.profile.SMS_number.slice(1)}
                    <input
                        type="text"
                        placeholder="Enter a new number?"
                        value={this.state.new_SMS_number}
                        name="new_SMS_number"
                        onChange={this.handleChange}
                    />
                </div>
                <div>
                    <b>Temperature Violation Threshold:</b> {this.state.profile.threshold}
                    <input
                        type="text"
                        placeholder="Enter a new threshold?"
                        value={this.state.new_threshold}
                        name="new_threshold"
                        onChange={this.handleChange}
                    />
                </div>
                <button onClick={this.handleClick}>Submit changes</button>
            </div>
        )
    }
}

export default Profile;