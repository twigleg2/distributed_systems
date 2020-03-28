import React from 'react';
import logo from './logo.svg';
import './App.css';

class SPA extends React.Component {

  state = {
    temperatures: [],
  }

  async componentDidMount() {
    const response = await fetch("http://localhost:8080/sky/cloud/K5P6PzpMBd7bU7Z3ijAcao/temperature_store/temperatures");
    const json = await response.json();
    console.log(json);
  }

  render() {
    return ( <
      div > < /div>
    )
  }

}







// function App() {
//   return (
//     <div className="App">
//       <header className="App-header">
//         <img src={logo} className="App-logo" alt="logo" />
//         <p>
//           Edit <code>src/App.js</code> and save to reload.
//         </p>
//         <a
//           className="App-link"
//           href="https://reactjs.org"
//           target="_blank"
//           rel="noopener noreferrer"
//         >
//           Learn React
//         </a>
//       </header>
//     </div>
//   );
// }

export default SPA;