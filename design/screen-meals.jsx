// FitnessPal — Meals screen (AI nutrition engine)
const {
  FpHeader, FpRing,
  IconBell, IconSparkles, IconChevR, IconPlus, IconMic, IconCam, IconType,
  IconFilter, IconPlate, IconLeaf,
} = window;

function MealsScreen() {
  return (
    <>
      <FpHeader
        eyebrow="Today · 1,742 / 2,100 kcal"
        title="Meals"
        sub="3 meals logged · 28g protein under"
        actions={
          <>
            <button className="fp-iconbtn"><IconFilter size={18}/></button>
            <button className="fp-iconbtn"><IconSparkles size={18}/></button>
          </>
        }
      />

      <div className="fp-body">
        {/* MACRO RING SUMMARY */}
        <div className="fp-card" style={{ display: 'flex', gap: 16, alignItems: 'center' }}>
          <FpRing value={1742} max={2100} size={88} stroke={8}>
            <div style={{ textAlign: 'center', lineHeight: 1 }}>
              <div style={{ fontSize: 20, fontWeight: 800, letterSpacing: '-0.04em', color: 'var(--fg-1)' }}>1742</div>
              <div style={{ fontSize: 9, fontWeight: 700, color: 'var(--fg-3)', letterSpacing: '0.1em', textTransform: 'uppercase', marginTop: 2 }}>kcal</div>
            </div>
          </FpRing>
          <div style={{ flex: 1, display: 'flex', flexDirection: 'column', gap: 10 }}>
            {[
              ['Protein', 102, 130, 'var(--ds-accent)', 'g'],
              ['Carbs', 168, 240, '#f59e0b', 'g'],
              ['Fat', 58, 70, '#8b5cf6', 'g'],
            ].map(([l, v, m, c, u]) => (
              <div key={l}>
                <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 4 }}>
                  <span style={{ fontSize: 11, fontWeight: 700, color: 'var(--fg-2)', textTransform: 'uppercase', letterSpacing: '0.08em' }}>{l}</span>
                  <span style={{ fontSize: 11, fontWeight: 600, color: 'var(--fg-2)' }}>
                    <span style={{ color: 'var(--fg-1)', fontWeight: 700 }}>{v}</span>/{m}{u}
                  </span>
                </div>
                <div style={{ height: 4, borderRadius: 2, background: 'var(--bg-pill)', overflow: 'hidden' }}>
                  <div style={{
                    height: '100%', width: `${(v / m) * 100}%`,
                    background: c, borderRadius: 2,
                    boxShadow: `0 0 8px ${c}55`,
                  }}/>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* AI INSIGHT */}
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
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 11, fontWeight: 700, color: 'var(--ds-accent)', letterSpacing: '0.08em', textTransform: 'uppercase', marginBottom: 4 }}>
                Looking at your day
              </div>
              <div style={{ fontSize: 13, color: 'var(--fg-1)', lineHeight: 1.5 }}>
                You're sitting 28g protein under and fiber's a little soft.
                A simple swap at dinner — chicken or tofu over the salad — gets you there.
              </div>
            </div>
          </div>
        </div>

        {/* FEATURED MEAL — analyzed lunch */}
        <div className="fp-section"><h3>Just analyzed</h3></div>
        <div className="fp-meal-hero">
          <div className="fp-meal-photo">
            <div className="score">
              <span className="n">A−</span>
              <span className="l">Score</span>
            </div>
            <div style={{ display: 'flex', gap: 6 }}>
              <span className="tag">Lunch</span>
              <span className="tag">High fiber</span>
            </div>
          </div>
          <div className="fp-meal-body">
            <div className="fp-meal-title">Grilled chicken bowl</div>
            <div className="fp-meal-sub">Brown rice, avocado, roasted veg, tahini · 12:30p</div>

            <div className="fp-macro-row">
              <div className="fp-macro">
                <span className="n">610<span className="u">k</span></span>
                <span className="l">kcal</span>
                <div className="fp-macro-bar"><div className="fill" style={{ width: '60%' }}/></div>
              </div>
              <div className="fp-macro">
                <span className="n">44<span className="u">g</span></span>
                <span className="l">Protein</span>
                <div className="fp-macro-bar"><div className="fill" style={{ width: '78%' }}/></div>
              </div>
              <div className="fp-macro">
                <span className="n">58<span className="u">g</span></span>
                <span className="l">Carbs</span>
                <div className="fp-macro-bar"><div className="fill amber" style={{ width: '52%' }}/></div>
              </div>
              <div className="fp-macro">
                <span className="n">22<span className="u">g</span></span>
                <span className="l">Fat</span>
                <div className="fp-macro-bar"><div className="fill violet" style={{ width: '64%' }}/></div>
              </div>
            </div>

            {/* Sub-row of micros */}
            <div style={{
              marginTop: 12, paddingTop: 12,
              borderTop: '1px solid var(--border-subtle)',
              display: 'flex', justifyContent: 'space-between', gap: 8,
            }}>
              {[
                ['Fiber', '11g', 'good'],
                ['Sugar', '6g', 'good'],
                ['Sodium', '720mg', 'warn'],
                ['Iron', '18%', 'good'],
              ].map(([l, v, s]) => (
                <div key={l} style={{ display: 'flex', flexDirection: 'column', gap: 1 }}>
                  <span style={{ fontSize: 9, fontWeight: 700, color: 'var(--fg-3)', letterSpacing: '0.08em', textTransform: 'uppercase' }}>{l}</span>
                  <span style={{ fontSize: 13, fontWeight: 700, color: s === 'warn' ? 'var(--ds-warning)' : 'var(--fg-1)' }}>{v}</span>
                </div>
              ))}
            </div>

            {/* AI follow-up */}
            <div style={{
              marginTop: 14,
              padding: 10,
              background: 'var(--ds-accent-soft)',
              borderRadius: 10,
              fontSize: 12, color: 'var(--fg-1)', lineHeight: 1.5,
              display: 'flex', gap: 8,
            }}>
              <IconSparkles size={13} style={{ color: 'var(--ds-accent)', flexShrink: 0, marginTop: 1 }}/>
              <span>Solid post-workout meal — protein and carbs both landed in window. Sodium was the only thing on the warm side.</span>
            </div>
          </div>
        </div>

        {/* TODAY'S MEALS LIST */}
        <div className="fp-section"><h3>Today</h3></div>
        <div className="fp-card no-pad">
          {[
            { name: 'Greek yogurt bowl', meta: ['Breakfast', '8:12a', '28g protein'], cal: 420, bg: 'linear-gradient(135deg, #fef3c7, #fde68a)' },
            { name: 'Grilled chicken bowl', meta: ['Lunch', '12:30p', '44g protein'], cal: 610, bg: 'linear-gradient(135deg, #65a30d, #84cc16)' },
            { name: 'Apple + almond butter', meta: ['Snack', '3:10p', '6g protein'], cal: 240, bg: 'linear-gradient(135deg, #fb923c, #f97316)' },
            { name: 'Add dinner', meta: ['Suggested', '~7:00p', '~30g protein'], cal: 'add', bg: 'transparent', placeholder: true },
          ].map((m, i) => (
            <div key={i} className="fp-meal-row">
              <div className="fp-meal-row-icon" style={{
                background: m.placeholder ? 'var(--bg-pill)' : m.bg,
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                color: m.placeholder ? 'var(--fg-2)' : '#fff',
              }}>
                {m.placeholder ? <IconPlus size={20}/> : null}
              </div>
              <div className="fp-meal-row-body">
                <div className="fp-meal-row-title" style={m.placeholder ? { color: 'var(--fg-2)', fontWeight: 500 } : {}}>{m.name}</div>
                <div className="fp-meal-row-meta">
                  <span>{m.meta[0]}</span>
                  <span className="dot"/>
                  <span>{m.meta[1]}</span>
                  <span className="dot"/>
                  <span>{m.meta[2]}</span>
                </div>
              </div>
              {m.cal === 'add' ? (
                <span className="fp-pill accent" style={{ flexShrink: 0 }}>Suggest</span>
              ) : (
                <div className="fp-meal-row-cal">{m.cal}<span style={{ fontSize: 10, color: 'var(--fg-3)', fontWeight: 600, marginLeft: 2 }}>kcal</span></div>
              )}
            </div>
          ))}
        </div>

        {/* Meal capture mode hint */}
        <div className="fp-section"><h3>Log a meal</h3></div>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 10, padding: '0 16px' }}>
          {[
            { icon: <IconCam size={20}/>, label: 'Photo', sub: 'AI scan' },
            { icon: <IconMic size={20}/>, label: 'Voice', sub: 'Speak it' },
            { icon: <IconType size={20}/>, label: 'Type', sub: 'Manual' },
          ].map((c, i) => (
            <div key={i} className="fp-card" style={{
              margin: 0, padding: 14,
              display: 'flex', flexDirection: 'column', gap: 6,
              alignItems: 'flex-start', cursor: 'pointer',
            }}>
              <div style={{
                width: 32, height: 32, borderRadius: 10,
                background: 'var(--ds-accent-soft-2)', color: 'var(--ds-accent)',
                display: 'flex', alignItems: 'center', justifyContent: 'center',
              }}>{c.icon}</div>
              <div style={{ fontSize: 13, fontWeight: 700 }}>{c.label}</div>
              <div style={{ fontSize: 10, color: 'var(--fg-3)', letterSpacing: '0.05em', textTransform: 'uppercase', fontWeight: 600 }}>{c.sub}</div>
            </div>
          ))}
        </div>
      </div>

      {/* Floating capture button */}
      <button className="fp-fab" aria-label="Log meal with AI">
        <IconSparkles size={24}/>
      </button>
    </>
  );
}

window.MealsScreen = MealsScreen;
