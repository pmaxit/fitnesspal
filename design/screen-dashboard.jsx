// FitnessPal — Dashboard screen
const {
  FpHeader, FpRing, FpAvatar,
  IconBell, IconSparkles, IconChevR, IconFlame, IconDrop, IconHeart,
  IconBolt, IconTrend, IconDumbbell, IconRun, IconSmile, IconPlate, IconTarget,
} = window;

function DashboardScreen() {
  return (
    <>
      <FpHeader
        eyebrow="Good morning"
        title="Hi, Maya"
        sub="Tuesday · April 14 · steady week so far"
        actions={
          <>
            <button className="fp-iconbtn"><IconSparkles size={18}/></button>
            <button className="fp-iconbtn"><IconBell size={18}/></button>
          </>
        }
      />

      <div className="fp-body">
        {/* ───── AVATAR HERO ───── */}
        <FpAvatar/>

        {/* ───── DAILY SUMMARY — 4 stat tiles ───── */}
        <div className="fp-section" style={{ paddingTop: 8 }}>
          <h3>Today's rings</h3>
          <a className="link" href="#">View all <IconChevR size={12}/></a>
        </div>

        <div style={{ padding: '0 16px', display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 'var(--density-card-gap)', marginBottom: 'var(--density-card-gap)' }}>
          {/* Calories */}
          <div className="fp-card" style={{ margin: 0, display: 'flex', gap: 12, alignItems: 'center' }}>
            <FpRing value={1430} max={2100} size={56} stroke={5}/>
            <div style={{ flex: 1, minWidth: 0 }}>
              <div className="fp-stat-lbl">Calories</div>
              <div style={{ fontSize: 18, fontWeight: 800, letterSpacing: '-0.025em' }}>1,430</div>
              <div className="fp-stat-sub">of 2,100 kcal</div>
            </div>
          </div>

          {/* Water */}
          <div className="fp-card" style={{ margin: 0, display: 'flex', gap: 12, alignItems: 'center' }}>
            <FpRing value={5} max={8} size={56} stroke={5} color="#06b6d4"/>
            <div style={{ flex: 1, minWidth: 0 }}>
              <div className="fp-stat-lbl">Water</div>
              <div style={{ fontSize: 18, fontWeight: 800, letterSpacing: '-0.025em' }}>5/8 <span style={{ fontSize: 12, color: 'var(--fg-3)', fontWeight: 600 }}>glasses</span></div>
              <div className="fp-stat-sub">3 to go</div>
            </div>
          </div>

          {/* Habits */}
          <div className="fp-card" style={{ margin: 0, display: 'flex', gap: 12, alignItems: 'center' }}>
            <FpRing value={6} max={8} size={56} stroke={5}/>
            <div style={{ flex: 1, minWidth: 0 }}>
              <div className="fp-stat-lbl">Habits</div>
              <div style={{ fontSize: 18, fontWeight: 800, letterSpacing: '-0.025em' }}>6/8</div>
              <div className="fp-stat-sub up">75% complete</div>
            </div>
          </div>

          {/* Mood */}
          <div className="fp-card" style={{ margin: 0, display: 'flex', gap: 12, alignItems: 'center' }}>
            <div style={{
              width: 56, height: 56, borderRadius: 16,
              background: 'var(--ds-accent-soft)', color: 'var(--ds-accent)',
              display: 'flex', alignItems: 'center', justifyContent: 'center',
            }}>
              <IconSmile size={26}/>
            </div>
            <div style={{ flex: 1, minWidth: 0 }}>
              <div className="fp-stat-lbl">Energy</div>
              <div style={{ fontSize: 18, fontWeight: 800, letterSpacing: '-0.025em' }}>7.2<span style={{ fontSize: 12, color: 'var(--fg-3)', fontWeight: 600 }}>/10</span></div>
              <div className="fp-stat-sub up">↑ from yesterday</div>
            </div>
          </div>
        </div>

        {/* ───── AI INSIGHT ───── */}
        <div className="fp-section"><h3>Wellness insight</h3></div>
        <div className="fp-card" style={{
          background: 'linear-gradient(135deg, var(--ds-accent-soft), rgba(16,185,129,0.04))',
          borderColor: 'rgba(16,185,129,0.28)',
        }}>
          <div style={{ display: 'flex', gap: 10, alignItems: 'flex-start' }}>
            <div style={{
              width: 30, height: 30, borderRadius: 8,
              background: 'var(--ds-accent)', color: '#fff',
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              flexShrink: 0, boxShadow: '0 4px 12px var(--ds-accent-glow)',
            }}>
              <IconSparkles size={16}/>
            </div>
            <div style={{ flex: 1, minWidth: 0 }}>
              <div style={{ fontSize: 11, fontWeight: 700, color: 'var(--ds-accent)', letterSpacing: '0.08em', textTransform: 'uppercase', marginBottom: 4 }}>
                Pattern noticed
              </div>
              <div style={{ fontSize: 14, fontWeight: 500, color: 'var(--fg-1)', lineHeight: 1.5 }}>
                You've slept 7.4 hours on average this week — your recovery is up <b>+12%</b>.
                You usually train harder on days like this.
              </div>
              <div style={{ display: 'flex', gap: 6, marginTop: 10 }}>
                <button className="fp-pill" style={{ border: '1px solid var(--ds-accent)', color: 'var(--ds-accent)', cursor: 'pointer' }}>
                  Plan a workout
                </button>
                <button className="fp-pill" style={{ cursor: 'pointer' }}>Dismiss</button>
              </div>
            </div>
          </div>
        </div>

        {/* ───── TODAY'S RECOMMENDATIONS ───── */}
        <div className="fp-section">
          <h3>Today's recommendations</h3>
          <a className="link" href="#">See all <IconChevR size={12}/></a>
        </div>

        <div className="fp-card no-pad">
          {[
            {
              icon: <IconDumbbell size={18}/>,
              tone: 'accent',
              title: 'Push day workout',
              sub: '45 min · chest, shoulders, triceps',
              tag: 'Recommended',
            },
            {
              icon: <IconPlate size={18}/>,
              tone: 'warning',
              title: 'Add 28g protein at lunch',
              sub: 'You\'re trending 18g under today',
              tag: 'Macro nudge',
            },
            {
              icon: <IconDrop size={18}/>,
              tone: 'info',
              title: 'Hydrate — next 2 hours',
              sub: 'Skipped your 11am water reminder',
              tag: 'Reminder',
            },
          ].map((r, i) => (
            <div key={i} className="fp-meal-row" style={{ cursor: 'pointer' }}>
              <div className="fp-meal-row-icon" style={{
                background: r.tone === 'accent' ? 'var(--ds-accent-soft-2)'
                  : r.tone === 'warning' ? 'rgba(245,158,11,0.15)'
                  : 'rgba(6,182,212,0.15)',
                color: r.tone === 'accent' ? 'var(--ds-accent)'
                  : r.tone === 'warning' ? 'var(--ds-warning)'
                  : '#06b6d4',
                display: 'flex', alignItems: 'center', justifyContent: 'center',
              }}>{r.icon}</div>
              <div className="fp-meal-row-body">
                <div className="fp-meal-row-title">{r.title}</div>
                <div className="fp-meal-row-meta"><span>{r.sub}</span></div>
              </div>
              <IconChevR size={16} style={{ color: 'var(--fg-3)' }}/>
            </div>
          ))}
        </div>

        {/* ───── WEEKLY SPARKLINE / BMI ───── */}
        <div className="fp-section"><h3>BMI progress</h3></div>
        <div className="fp-card">
          <div style={{ display: 'flex', alignItems: 'flex-end', justifyContent: 'space-between', marginBottom: 12 }}>
            <div>
              <div style={{ fontSize: 28, fontWeight: 800, letterSpacing: '-0.04em', lineHeight: 1 }}>
                23.4
              </div>
              <div style={{ fontSize: 12, color: 'var(--fg-2)', marginTop: 4, fontWeight: 500 }}>
                <span style={{ color: 'var(--ds-accent)', fontWeight: 700 }}>Healthy</span> · down 0.4 in 2 wks
              </div>
            </div>
            <div className="fp-pill accent"><IconTrend size={11}/> On track</div>
          </div>

          {/* BMI scale band */}
          <div style={{ marginTop: 8 }}>
            <div style={{
              position: 'relative',
              height: 8, borderRadius: 4,
              background: 'linear-gradient(90deg, #3b82f6 0%, #10b981 30%, #10b981 60%, #f59e0b 75%, #ef4444 100%)',
              opacity: 0.4,
            }}>
              {/* marker */}
              <div style={{
                position: 'absolute',
                left: '40%', top: -3,
                width: 14, height: 14, borderRadius: '50%',
                background: '#fff', border: '3px solid var(--ds-accent)',
                transform: 'translateX(-50%)',
                boxShadow: '0 2px 8px rgba(16,185,129,0.5)',
              }}/>
            </div>
            <div style={{
              display: 'flex', justifyContent: 'space-between',
              fontSize: 9, fontWeight: 700, color: 'var(--fg-3)',
              marginTop: 6, letterSpacing: '0.08em', textTransform: 'uppercase',
            }}>
              <span>Under</span><span>Healthy</span><span>Over</span><span>High</span>
            </div>
          </div>
        </div>

        {/* ───── SWIPEABLE CARDS HINT ───── */}
        <div className="fp-section"><h3>Quick log</h3></div>
        <div style={{ display: 'flex', gap: 10, padding: '0 16px 8px', overflowX: 'auto', scrollbarWidth: 'none' }}>
          {[
            { icon: <IconRun size={18}/>, label: 'Workout', color: 'var(--ds-accent)' },
            { icon: <IconPlate size={18}/>, label: 'Meal', color: '#f59e0b' },
            { icon: <IconDrop size={18}/>, label: 'Water', color: '#06b6d4' },
            { icon: <IconHeart size={18}/>, label: 'Mood', color: '#ef4444' },
            { icon: <IconBolt size={18}/>, label: 'Energy', color: '#8b5cf6' },
          ].map((c, i) => (
            <div key={i} style={{
              flex: '0 0 76px', height: 80,
              borderRadius: 14,
              background: 'var(--bg-card)',
              border: '1px solid var(--border)',
              display: 'flex', flexDirection: 'column',
              alignItems: 'center', justifyContent: 'center', gap: 6,
              cursor: 'pointer',
            }}>
              <div style={{
                width: 30, height: 30, borderRadius: 10,
                background: `${c.color}1a`,
                color: c.color,
                display: 'flex', alignItems: 'center', justifyContent: 'center',
              }}>{c.icon}</div>
              <span style={{ fontSize: 10, fontWeight: 600, color: 'var(--fg-2)' }}>{c.label}</span>
            </div>
          ))}
        </div>
      </div>
    </>
  );
}

window.DashboardScreen = DashboardScreen;
