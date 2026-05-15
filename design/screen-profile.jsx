// FitnessPal — Profile screen (settings + wellness score + integrations)
const {
  FpHeader, FpRing,
  IconBell, IconSparkles, IconChevR, IconSettings, IconTarget, IconHeart,
  IconShield, IconDevice, IconBolt, IconPath, IconRefresh,
} = window;

function ProfileScreen() {
  return (
    <>
      <FpHeader
        title="Profile"
        sub="Maya Chen · joined Jan 2026"
        actions={<button className="fp-iconbtn"><IconSettings size={18}/></button>}
      />

      <div className="fp-body">
        {/* HERO with avatar + score */}
        <div className="fp-profile-hero">
          <div className="fp-profile-avatar">MC</div>
          <div style={{ flex: 1, minWidth: 0, position: 'relative', zIndex: 1 }}>
            <div className="fp-profile-name">Maya Chen</div>
            <div className="fp-profile-sub">28 · 5'7" · 178 lb · moderate activity</div>
            <div style={{ display: 'flex', gap: 6, marginTop: 8 }}>
              <span className="fp-pill accent">Lose 10 lb</span>
              <span className="fp-pill">Vegetarian</span>
            </div>
          </div>
        </div>

        {/* WELLNESS SCORE */}
        <div className="fp-card" style={{ display: 'flex', gap: 16, alignItems: 'center' }}>
          <FpRing value={84} size={88} stroke={8}>
            <div style={{ textAlign: 'center', lineHeight: 1 }}>
              <div style={{ fontSize: 26, fontWeight: 800, letterSpacing: '-0.04em' }}>84</div>
              <div style={{ fontSize: 9, fontWeight: 700, color: 'var(--fg-3)', letterSpacing: '0.1em', textTransform: 'uppercase', marginTop: 2 }}>Wellness</div>
            </div>
          </FpRing>
          <div style={{ flex: 1, minWidth: 0 }}>
            <div className="fp-stat-lbl">AI wellness score</div>
            <div style={{ fontSize: 13, color: 'var(--fg-1)', fontWeight: 500, lineHeight: 1.5, marginTop: 4 }}>
              You've been steady this month — sleep, training and hydration are all trending up.
            </div>
            <div style={{ display: 'flex', gap: 4, alignItems: 'center', marginTop: 8, fontSize: 11, color: 'var(--ds-accent)', fontWeight: 600 }}>
              <IconSparkles size={11}/> +6 from last month
            </div>
          </div>
        </div>

        {/* GOAL CARDS */}
        <div className="fp-section">
          <h3>Goals</h3>
          <a className="link" href="#">Edit <IconChevR size={12}/></a>
        </div>

        <div className="fp-card no-pad">
          {[
            { ic: <IconTarget size={16}/>, l: 'Goal weight', v: '168 lb', sub: '10 lb to go' },
            { ic: <IconBolt size={16}/>, l: 'Calorie target', v: '2,100 kcal', sub: '−400 kcal deficit' },
            { ic: <IconHeart size={16}/>, l: 'Activity level', v: 'Moderate', sub: '3–5 days/wk' },
            { ic: <IconRefresh size={16}/>, l: 'Sleep goal', v: '8 hr', sub: 'Avg 7h 24m' },
            { ic: <IconPath size={16}/>, l: 'Fitness experience', v: 'Intermediate', sub: '2+ yrs training' },
          ].map((r, i) => (
            <div key={i} className="fp-profile-row">
              <div className="fp-profile-row-icon">{r.ic}</div>
              <div style={{ flex: 1 }}>
                <div className="fp-profile-row-lbl">{r.l}</div>
                <div style={{ fontSize: 11, color: 'var(--fg-3)', marginTop: 1 }}>{r.sub}</div>
              </div>
              <div className="fp-profile-row-val">{r.v}</div>
              <IconChevR size={14} style={{ color: 'var(--fg-3)' }}/>
            </div>
          ))}
        </div>

        {/* BMI MINI */}
        <div className="fp-card">
          <div className="fp-card-hd">
            <span className="fp-card-title">Body metrics</span>
            <span className="fp-pill accent">Up to date</span>
          </div>

          <div style={{
            display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 12,
          }}>
            {[
              ['BMI', '23.4', 'Healthy'],
              ['Body fat', '22%', '−1.2% mo'],
              ['Resting HR', '54', 'bpm'],
            ].map(([l, v, s]) => (
              <div key={l} style={{
                padding: 12,
                borderRadius: 12,
                background: 'var(--bg-pill)',
                border: '1px solid var(--border-subtle)',
              }}>
                <div className="fp-stat-lbl" style={{ marginBottom: 4 }}>{l}</div>
                <div style={{ fontSize: 22, fontWeight: 800, letterSpacing: '-0.03em', lineHeight: 1 }}>{v}</div>
                <div style={{ fontSize: 10, color: 'var(--fg-3)', marginTop: 4, fontWeight: 500 }}>{s}</div>
              </div>
            ))}
          </div>
        </div>

        {/* INTEGRATIONS */}
        <div className="fp-section"><h3>Connected devices</h3></div>
        <div className="fp-card no-pad">
          {[
            { name: 'Apple Health', sub: 'Steps · sleep · HR', dot: 'var(--ds-accent)', linked: true, badge: 'A' },
            { name: 'WHOOP', sub: 'Recovery · strain', dot: 'var(--ds-accent)', linked: true, badge: 'W' },
            { name: 'Garmin', sub: 'Connect to sync runs', dot: 'var(--fg-disabled)', linked: false, badge: 'G' },
            { name: 'Fitbit', sub: 'Connect to sync', dot: 'var(--fg-disabled)', linked: false, badge: 'F' },
          ].map((d, i) => (
            <div key={i} className="fp-profile-row">
              <div style={{
                width: 34, height: 34, borderRadius: 10,
                background: d.linked ? 'var(--ds-accent-soft-2)' : 'var(--bg-pill)',
                color: d.linked ? 'var(--ds-accent)' : 'var(--fg-3)',
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                fontSize: 13, fontWeight: 800,
                flexShrink: 0,
              }}>{d.badge}</div>
              <div style={{ flex: 1 }}>
                <div className="fp-profile-row-lbl">{d.name}</div>
                <div style={{ fontSize: 11, color: 'var(--fg-3)', marginTop: 1 }}>{d.sub}</div>
              </div>
              {d.linked ? (
                <span className="fp-pill accent" style={{ fontSize: 10 }}>
                  <span style={{ width: 6, height: 6, borderRadius: '50%', background: 'var(--ds-accent)', display: 'inline-block' }}/>
                  Linked
                </span>
              ) : (
                <span style={{ fontSize: 12, color: 'var(--ds-accent)', fontWeight: 600 }}>Connect</span>
              )}
            </div>
          ))}
        </div>

        {/* SETTINGS */}
        <div className="fp-section"><h3>Settings</h3></div>
        <div className="fp-card no-pad">
          {[
            { ic: <IconBell size={16}/>, l: 'Notifications', v: 'On' },
            { ic: <IconShield size={16}/>, l: 'Privacy', v: null },
            { ic: <IconDevice size={16}/>, l: 'Widgets', v: '3 active' },
            { ic: <IconSparkles size={16}/>, l: 'AI preferences', v: 'Calm guide' },
          ].map((r, i) => (
            <div key={i} className="fp-profile-row">
              <div className="fp-profile-row-icon">{r.ic}</div>
              <div className="fp-profile-row-lbl">{r.l}</div>
              {r.v && <div className="fp-profile-row-val">{r.v}</div>}
              <IconChevR size={14} style={{ color: 'var(--fg-3)' }}/>
            </div>
          ))}
        </div>
      </div>
    </>
  );
}

window.ProfileScreen = ProfileScreen;
