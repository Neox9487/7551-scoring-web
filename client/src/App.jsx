import React from 'react';
import { BrowserRouter as Router, Routes, Route, Link } from 'react-router-dom';
import ScoutingPage from './pages/ScoringPage';
import ScoreboardPage from './pages/ScoreboardPage';
import TeamDetailPage from './pages/TeamDetailPage';

function App() {
  return (
    <Router>
      <nav className="nav">
        <div className="nav-container">
          <Link to="/">
            <button className="nav-btn">場記 SCORING</button>
          </Link>
          <Link to="/scoreboard">
            <button className="nav-btn">記分板 LEADERBOARD</button>
          </Link>
        </div>
      </nav>

      <Routes>
        <Route path="/" element={<ScoutingPage />} />
        <Route path="/scoreboard" element={<ScoreboardPage />} />
        <Route path="/team/:teamId" element={<TeamDetailPage />} />
      </Routes>
    </Router>
  );
}

export default App;