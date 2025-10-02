import React, { useState } from 'react';
import axios from 'axios';

function App() {
  const [members, setMembers] = useState([]);
  const [formData, setFormData] = useState({ username: '', email: '', password: '', role: 'Member', phone: '' });

  const handleSignup = async () => {
    try {
      await axios.post('http://localhost:8000/api/signup/', formData);
      alert('Signup successful!');
      fetchMembers();
    } catch (error) {
      alert('Error: ' + error.message);
    }
  };

  const fetchMembers = async () => {
    try {
      const res = await axios.get('http://localhost:8000/api/members/');
      setMembers(res.data);
    } catch (error) {
      alert('Error fetching members');
    }
  };

  return (
    <div className="min-h-screen bg-gray-100 py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-md mx-auto bg-white rounded-lg shadow-md p-6">
        <h1 className="text-3xl font-bold text-center text-blue-600 mb-6">Church Management System</h1>
        <h2 className="text-xl font-semibold mb-4 text-gray-800">Signup New Member</h2>
        <input
          className="w-full p-2 mb-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
          placeholder="Username"
          value={formData.username}
          onChange={(e) => setFormData({...formData, username: e.target.value})}
        />
        <input
          className="w-full p-2 mb-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
          placeholder="Email"
          value={formData.email}
          onChange={(e) => setFormData({...formData, email: e.target.value})}
        />
        <input
          type="password"
          className="w-full p-2 mb-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
          placeholder="Password"
          value={formData.password}
          onChange={(e) => setFormData({...formData, password: e.target.value})}
        />
        <input
          className="w-full p-2 mb-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
          placeholder="Role (e.g., Pastor)"
          value={formData.role}
          onChange={(e) => setFormData({...formData, role: e.target.value})}
        />
        <input
          className="w-full p-2 mb-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
          placeholder="Phone"
          value={formData.phone}
          onChange={(e) => setFormData({...formData, phone: e.target.value})}
        />
        <button
          className="w-full bg-blue-600 text-white py-2 rounded-md hover:bg-blue-700 transition"
          onClick={handleSignup}
        >
          Signup
        </button>
        <button
          className="w-full mt-2 bg-gray-600 text-white py-2 rounded-md hover:bg-gray-700 transition"
          onClick={fetchMembers}
        >
          Load Members
        </button>
        <ul className="mt-4 space-y-2">
          {members.map((m) => (
            <li key={m.id} className="p-2 bg-gray-50 rounded-md">
              {m.user.username} - {m.role} ({m.phone})
            </li>
          ))}
        </ul>
      </div>
    </div>
  );
}

export default App;