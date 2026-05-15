// FitnessPal — Activity screen (chronological timeline)
const {
  FpHeader,
  IconBell, IconFilter, IconSparkles, IconDumbbell, IconRun, IconPlate, IconDrop,
  IconBed, IconSmile, IconPill, IconNote, IconTrend, IconHeart,
} = window;

function ActivityScreen() {
  const [view, setView] = React.useState('day');

  const items = [
    {
      time: '6:42a', tone: 'muted',
      icon: <IconBed size={14}/>, color: '#8b5cf6',
      title: 'Slept 7h 34m',
      meta: 'Quality 88%',
      body: 'Deep sleep peaked at 2:10a · woke once around 4:50a',
      stats: [['7h 34m', 'Total'], ['88', 'Quality'], ['54', 'Avg HR']],
      ai: null,
    },
    {
      time: '7:05a',
      icon: <IconHeart size={14}/>, color: '#ef4444',
      title: 'Morning resting HR',
      meta: '54 bpm',
      body: null,
      stats: null,
      ai: 'Resting HR trending down — recovery is improving.',
    },
    {
      time: '8:12a',
      icon: <IconPlate size={14}/>, color: '#f59e0b',
      title: 'Breakfast logged',
      meta: '420 kcal',
      body: 'Greek yogurt bowl with berries, almonds, oats',
      stats: [['28g', 'Protein'], ['52g', 'Carbs'], ['14g', 'Fat']],
      ai: null,
      photo: 'linear-gradient(135deg, #fef3c7, #fde68a, #d97706)',
    },
    {
      time: '9:30a',
      icon: <IconDrop size={14}/>, color: '#06b6d4',
      title: 'Water · 16 oz',
      meta: '2 of 8',
      body: null,
      stats: null,
      ai: null,
    },
    {
      time: '11:15a',
      icon: <IconRun size={14}/>, color: 'var(--ds-accent)',
      title: '2.4 mile run',
      meta: '21 min · zone 3',
      body: 'Negative split · best 5K pace this month',
      stats: [['21:08', 'Time'], ['8:47', 'Pace'], ['284', 'kcal']],
      ai: 'Strongest run in 3 weeks. Cool-down stretch logged — nice form.',
    },
    {
      time: '12:30p',
      icon: <IconPlate size={14}/>, color: '#f59e0b',
      title: 'Lunch logged',
      meta: '610 kcal',
      body: 'Grilled chicken bowl, brown rice, avocado, tahini',
      stats: [['44g', 'Protein'], ['58g', 'Carbs'], ['22g', 'Fat']],
      ai: null,
      photo: 'linear-gradient(135deg, #65a30d, #84cc16, #ca8a04)',
    },
    {
      time: '1:45p', tone: 'amber',
      icon: <IconSparkles size={14}/>, color: 'var(--ds-warning)',
      title: 'Protein intake low',
      meta: '−18g vs goal',
      body: 'You\'re trending under at this point in the day.',
      stats: null,
      ai: 'Add a protein source at your next meal — chicken, tempeh, or a shake works.',
    },
    {
      time: '3:20p',
      icon: <IconPill size={14}/>, color: '#8b5cf6',
      title: 'Creatine · 5g',
      meta: 'supplement',
      body: null,
      stats: null,
      ai: null,
    },
    {
      time: '6:00p',
      icon: <IconDumbbell size={14}/>, color: 'var(--ds-accent)',
      title: 'Push day · 48 min',
      meta: '6 exercises · 312 kcal',
      body: 'Chest, shoulders, triceps · 2 PRs',
      stats: [['48m', 'Time'], ['312', 'kcal'], ['142', 'Avg HR']],
      ai: null,
    },
  ];

  return (
    <>
      <FpHeader
        eyebrow="Tuesday · 14"
        title="Timeline"
        sub="14 events · 1,742 kcal in · 596 out"
        actions={
          <>
            <button className="fp-iconbtn"><IconFilter size={18}/></button>
            <button className="fp-iconbtn"><IconBell size={18}/></button>
          </>
        }
      />

      <div className="fp-body">
        {/* day/week/month toggle */}
        <div className="fp-day-tabs">
          {['day', 'week', 'month'].map(v => (
            <button key={v} className={`fp-day-tab ${view === v ? 'active' : ''}`} onClick={() => setView(v)}>
              {v[0].toUpperCase() + v.slice(1)}
            </button>
          ))}
        </div>

        {/* SMART SUMMARY */}
        <div className="fp-card" style={{ marginTop: 12 }}>
          <div style={{ display: 'flex', gap: 14, alignItems: 'center' }}>
            <div style={{
              width: 50, height: 50, borderRadius: '50%',
              border: '4px solid var(--ds-accent)',
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              fontWeight: 800, fontSize: 16, letterSpacing: '-0.02em',
              boxShadow: 'inset 0 0 0 8px rgba(16,185,129,0.08), 0 0 18px var(--ds-accent-glow)',
              flexShrink: 0,
            }}>
              87
            </div>
            <div style={{ flex: 1, minWidth: 0 }}>
              <div className="fp-stat-lbl" style={{ marginBottom: 2 }}>Day score</div>
              <div style={{ fontSize: 13, fontWeight: 500, color: 'var(--fg-1)', lineHeight: 1.4 }}>
                Strong day — sleep, training, and protein all on target. Hydration is the only soft spot.
              </div>
            </div>
          </div>
          <div style={{
            marginTop: 12, paddingTop: 12,
            borderTop: '1px solid var(--border-subtle)',
            display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 8,
          }}>
            {[
              ['Sleep', '88', 'up'],
              ['Train', '92', 'up'],
              ['Food', '74', null],
              ['Hydr', '62', 'down'],
            ].map(([l, v, t]) => (
              <div key={l}>
                <div style={{ fontSize: 9, fontWeight: 700, color: 'var(--fg-3)', letterSpacing: '0.1em', textTransform: 'uppercase' }}>{l}</div>
                <div style={{ fontSize: 16, fontWeight: 800, letterSpacing: '-0.025em',
                  color: t === 'down' ? 'var(--ds-warning)' : t === 'up' ? 'var(--ds-accent)' : 'var(--fg-1)' }}>{v}</div>
              </div>
            ))}
          </div>
        </div>

        {/* TIMELINE */}
        <div className="fp-section"><h3>Today</h3></div>
        <div className="fp-tl">
          <div className="fp-tl-spine"/>
          {items.map((it, i) => (
            <div key={i} className="fp-tl-item">
              <div className="fp-tl-time">{it.time}</div>
              <div className={`fp-tl-dot ${it.tone || ''}`}/>
              <div className="fp-tl-card">
                <div className="fp-tl-card-hd">
                  <div className="fp-tl-card-icon" style={{
                    background: `${it.color === 'var(--ds-accent)' ? 'var(--ds-accent-soft-2)' : it.color + '22'}`,
                    color: it.color,
                  }}>{it.icon}</div>
                  <div className="fp-tl-card-title">{it.title}</div>
                  {it.meta && <div className="fp-tl-card-meta">{it.meta}</div>}
                </div>
                {it.photo && (
                  <div style={{
                    height: 100, borderRadius: 8, marginBottom: 8,
                    background: it.photo,
                  }}/>
                )}
                {it.body && <div className="fp-tl-card-body">{it.body}</div>}
                {it.stats && (
                  <div className="fp-tl-card-stats">
                    {it.stats.map(([n, l], j) => (
                      <div key={j} className="fp-tl-card-stat">
                        <span className="n">{n}</span>
                        <span className="l">{l}</span>
                      </div>
                    ))}
                  </div>
                )}
                {it.ai && (
                  <div className="fp-tl-ai">
                    <IconSparkles size={12} className="sparkle"/>
                    <span>{it.ai}</span>
                  </div>
                )}
              </div>
            </div>
          ))}
        </div>

        {/* End-of-day analytics */}
        <div className="fp-section"><h3>Trend · last 7 days</h3></div>
        <div className="fp-card">
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-end', height: 80, gap: 6 }}>
            {[68, 74, 81, 72, 88, 76, 87].map((v, i) => (
              <div key={i} style={{
                flex: 1,
                height: `${v}%`,
                background: i === 6 ? 'var(--ds-accent)' : 'var(--bg-pill)',
                borderRadius: 6,
                position: 'relative',
                boxShadow: i === 6 ? '0 0 16px var(--ds-accent-glow)' : 'none',
              }}>
                {i === 6 && (
                  <div style={{
                    position: 'absolute', top: -18, left: '50%', transform: 'translateX(-50%)',
                    fontSize: 10, fontWeight: 700, color: 'var(--ds-accent)',
                  }}>87</div>
                )}
              </div>
            ))}
          </div>
          <div style={{ display: 'flex', justifyContent: 'space-between', marginTop: 8 }}>
            {['M','T','W','T','F','S','S'].map((d, i) => (
              <div key={i} style={{ flex: 1, textAlign: 'center', fontSize: 10, fontWeight: 700, color: i === 6 ? 'var(--ds-accent)' : 'var(--fg-3)', letterSpacing: '0.08em' }}>{d}</div>
            ))}
          </div>
        </div>
      </div>
    </>
  );
}

window.ActivityScreen = ActivityScreen;
