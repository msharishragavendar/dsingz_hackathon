
import React, { useState } from 'react';
import { 
  PieChart, Pie, Cell, Tooltip, ResponsiveContainer,
  BarChart, Bar, XAxis, YAxis, CartesianGrid, Legend 
} from 'recharts';
import { 
  User, Briefcase, Mail, Calendar, 
  MapPin, Clock, Award, CheckCircle, 
  AlertCircle, XCircle 
} from 'lucide-react';

const COLORS = ['#10a37f', '#f59e0b', '#ef4444', '#3b82f6', '#8b5cf6'];
const RADIAN = Math.PI / 180;

const renderCustomizedLabel = ({ cx, cy, midAngle, innerRadius, outerRadius, percent, index }) => {
  const radius = innerRadius + (outerRadius - innerRadius) * 0.5;
  const x = cx + radius * Math.cos(-midAngle * RADIAN);
  const y = cy + radius * Math.sin(-midAngle * RADIAN);

  return (
    <text x={x} y={y} fill="white" textAnchor={x > cx ? 'start' : 'end'} dominantBaseline="central">
      {`${(percent * 100).toFixed(0)}%`}
    </text>
  );
};

const ProfileDashboard = ({ data }) => {
  if (!data) return null;

  const { basic_info, attendance_stats, skills, projects } = data;
  const [activeTab, setActiveTab] = useState('overview');

  // Prepare data for Pie Chart
  const attendanceData = [
    { name: 'Present', value: attendance_stats.present || 0 },
    { name: 'Late', value: attendance_stats.late || 0 },
    { name: 'Absent', value: attendance_stats.absent || 0 },
    { name: 'Leave', value: attendance_stats.leave || 0 },
    { name: 'WFH', value: attendance_stats.wfh || 0 },
  ].filter(item => item.value > 0);

  // Prepare data for Skills Chart
  const skillLevelMap = { expert: 3, intermediate: 2, beginner: 1, trainee: 1 };
  const skillsData = skills.slice(0, 7).map(s => ({
    name: s.technology_name,
    level: skillLevelMap[s.level?.toLowerCase()] || 1,
    levelName: s.level
  }));

  return (
    <div className="profile-dashboard animate-fade-in" style={{
      background: '#1a1a1a', 
      borderRadius: '12px', 
      overflow: 'hidden',
      border: '1px solid #333',
      marginTop: '16px'
    }}>
      
      {/* Header Section */}
      <div className="profile-header" style={{
        background: 'linear-gradient(135deg, #10a37f 0%, #0d8a6a 100%)',
        padding: '24px',
        display: 'flex',
        alignItems: 'center',
        gap: '20px',
        color: 'white'
      }}>
        <div className="profile-avatar" style={{
          width: '80px', height: '80px', borderRadius: '50%',
          border: '4px solid rgba(255,255,255,0.2)',
          background: '#fff', overflow: 'hidden',
          display: 'flex', alignItems: 'center', justifyContent: 'center'
        }}>
           {basic_info.profile_image ? (
             <img src={basic_info.profile_image} alt="Profile" style={{width:'100%', height:'100%', objectFit:'cover'}} />
           ) : (
             <User size={40} color="#10a37f" />
           )}
        </div>
        
        <div className="profile-info">
          <h2 style={{ fontSize: '24px', fontWeight: 'bold' }}>
            {basic_info.first_name} {basic_info.last_name}
          </h2>
          <div style={{ display: 'flex', gap: '16px', marginTop: '8px', fontSize: '14px', opacity: 0.9 }}>
            <span style={{ display: 'flex', alignItems: 'center', gap: '4px' }}>
              <Briefcase size={14} /> {basic_info.job_role}
            </span>
            <span style={{ display: 'flex', alignItems: 'center', gap: '4px' }}>
              <Mail size={14} /> {basic_info.official_email}
            </span>
            <span style={{ display: 'flex', alignItems: 'center', gap: '4px' }}>
              <Calendar size={14} /> Joined: {basic_info.date_of_joining?.split(' ')[0]}
            </span>
          </div>
        </div>
      </div>

      {/* Tabs */}
      <div className="dashboard-tabs" style={{
        display: 'flex', borderBottom: '1px solid #333', padding: '0 16px'
      }}>
        {['overview', 'attendance', 'skills', 'projects'].map(tab => (
          <button
            key={tab}
            onClick={() => setActiveTab(tab)}
            style={{
              padding: '12px 20px',
              background: 'transparent',
              border: 'none',
              borderBottom: activeTab === tab ? '2px solid #10a37f' : '2px solid transparent',
              color: activeTab === tab ? '#10a37f' : '#b3b3b3',
              cursor: 'pointer',
              fontWeight: 500,
              textTransform: 'capitalize'
            }}
          >
            {tab}
          </button>
        ))}
      </div>

      {/* Content Area */}
      <div className="dashboard-content" style={{ padding: '24px' }}>
        
        {/* OVERVIEW TAB */}
        {activeTab === 'overview' && (
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))', gap: '16px' }}>
            <StatCard 
              title="Attendance Rate" 
              value={`${attendance_stats.attendance_rate}%`} 
              icon={<CheckCircle size={20} color="#10a37f" />} 
              sub="Based on total working days"
            />
            <StatCard 
              title="Days Present" 
              value={attendance_stats.present} 
              icon={<Briefcase size={20} color="#3b82f6" />} 
              sub="On-site work"
            />
            <StatCard 
              title="Active Projects" 
              value={projects.length} 
              icon={<Award size={20} color="#f59e0b" />} 
              sub="Currently assigned"
            />
            <StatCard 
              title="Top Skill" 
              value={skills[0]?.technology_name || "N/A"} 
              icon={<Award size={20} color="#8b5cf6" />} 
              sub={skills[0]?.level || "No skills listed"}
            />
          </div>
        )}

        {/* ATTENDANCE TAB */}
        {activeTab === 'attendance' && (
          <div style={{ display: 'flex', flexWrap: 'wrap', gap: '24px' }}>
             <div style={{ flex: 1, minWidth: '300px', height: '300px' }}>
               <h3 style={{ marginBottom: '16px', color: '#fff' }}>Attendance Breakdown</h3>
               <ResponsiveContainer width="100%" height="100%">
                 <PieChart>
                   <Pie
                     data={attendanceData}
                     cx="50%"
                     cy="50%"
                     innerRadius={60}
                     outerRadius={80}
                     fill="#8884d8"
                     paddingAngle={5}
                     dataKey="value"
                     label
                   >
                     {attendanceData.map((entry, index) => (
                       <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                     ))}
                   </Pie>
                   <Tooltip 
                     contentStyle={{ backgroundColor: '#242424', border: '1px solid #333' }}
                     itemStyle={{ color: '#fff' }}
                   />
                   <Legend />
                 </PieChart>
               </ResponsiveContainer>
             </div>
             
             <div style={{ flex: 1, minWidth: '300px' }}>
                <h3 style={{ marginBottom: '16px', color: '#fff' }}>Summary Stats</h3>
                <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '12px' }}>
                   {Object.entries(attendance_stats).map(([k, v]) => {
                     if (k === 'total_days' || k === 'attendance_rate') return null;
                     return (
                        <div key={k} style={{ 
                          background: '#242424', padding: '12px', borderRadius: '8px',
                          display: 'flex', justifyContent: 'space-between', alignItems: 'center'
                        }}>
                          <span style={{ color: '#b3b3b3', textTransform: 'capitalize' }}>{k}</span>
                          <span style={{ fontWeight: 'bold', fontSize: '18px' }}>{v}</span>
                        </div>
                     )
                   })}
                </div>
             </div>
          </div>
        )}

        {/* SKILLS TAB */}
        {activeTab === 'skills' && (
           <div style={{ height: '350px' }}>
             <h3 style={{ marginBottom: '16px', color: '#fff' }}>Proficiency Levels</h3>
             {skillsData.length > 0 ? (
               <ResponsiveContainer width="100%" height="100%">
                 <BarChart data={skillsData} layout="vertical" margin={{ left: 40 }}>
                   <CartesianGrid strokeDasharray="3 3" stroke="#333" />
                   <XAxis type="number" domain={[0, 3]} tickCount={4} hide />
                   <YAxis dataKey="name" type="category" stroke="#b3b3b3" width={100} />
                   <Tooltip 
                      cursor={{fill: 'rgba(255,255,255,0.05)'}}
                      content={({ active, payload }) => {
                        if (active && payload && payload.length) {
                          const data = payload[0].payload;
                          return (
                            <div style={{ background: '#242424', padding: '8px', border: '1px solid #333', borderRadius: '4px' }}>
                              <p style={{ fontWeight: 'bold' }}>{data.name}</p>
                              <p style={{ color: '#10a37f' }}>{data.levelName}</p>
                            </div>
                          );
                        }
                        return null;
                      }}
                   />
                   <Bar dataKey="level" fill="#10a37f" radius={[0, 4, 4, 0]} barSize={20} />
                 </BarChart>
               </ResponsiveContainer>
             ) : (
                <p style={{ color: '#b3b3b3' }}>No skills recorded.</p>
             )}
           </div>
        )}

        {/* PROJECTS TAB */}
        {activeTab === 'projects' && (
           <div style={{ display: 'grid', gap: '16px' }}>
             {projects.length > 0 ? (
               projects.map((p, idx) => (
                 <div key={idx} style={{ 
                   background: '#242424', padding: '16px', borderRadius: '8px',
                   borderLeft: `4px solid ${p.project_status === 'Active' ? '#10a37f' : '#b3b3b3'}`
                 }}>
                   <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '8px' }}>
                     <h4 style={{ fontWeight: 'bold', fontSize: '16px' }}>{p.name}</h4>
                     <span style={{ 
                       padding: '4px 8px', borderRadius: '4px', fontSize: '12px',
                       background: p.project_status === 'Active' ? 'rgba(16, 163, 127, 0.2)' : 'rgba(255, 255, 255, 0.1)',
                       color: p.project_status === 'Active' ? '#10a37f' : '#b3b3b3'
                     }}>
                       {p.project_status}
                     </span>
                   </div>
                   <p style={{ color: '#b3b3b3', fontSize: '14px' }}>{p.description || "No description available."}</p>
                 </div>
               ))
             ) : (
               <p style={{ color: '#b3b3b3' }}>No projects assigned.</p>
             )}
           </div>
        )}
      </div>
    </div>
  );
};

// Helper Component for Stat Cards
const StatCard = ({ title, value, icon, sub }) => (
  <div style={{ 
    background: '#242424', padding: '16px', borderRadius: '8px',
    display: 'flex', flexDirection: 'column', gap: '8px'
  }}>
    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'start' }}>
      <span style={{ color: '#b3b3b3', fontSize: '13px' }}>{title}</span>
      {icon}
    </div>
    <div style={{ fontSize: '24px', fontWeight: 'bold' }}>{value}</div>
    {sub && <div style={{ fontSize: '12px', color: '#666' }}>{sub}</div>}
  </div>
);

export default ProfileDashboard;
