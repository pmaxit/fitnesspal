// FitnessPal — Habits screen (calendar + heat list)
const {
  FpHeader,
  IconBell, IconSparkles, IconChevR, IconChevL, IconPlus, IconFlame, IconFilter,
  IconRefresh,
} = window;

function HabitsScreen() {
  const [tab, setTab] = React.useState('today');

  // Generate calendar — April 2026, day 14 = today
  // April 2026 starts on a Wednesday (apr 1 = wed)
  const weekday = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  const cells = [];
  // 2 empty leading cells (Mon, Tue)
  for (let i = 0; i < 2; i++) cells.push({ empty: true });
  // 30 days
  for (let d = 1; d <= 30; d++) {
    let lvl = 0;
    if (d <= 13) {
      // historical: spread of levels
      const r = (d * 1.7) % 1;
      lvl = r < 0.15 ? 0 : r < 0.35 ? 1 : r < 0.55 ? 2 : r < 0.8 ? 3 : 4;
    }
    cells.push({ day: d, level: lvl, today: d === 14 });
  }

  return (
    <>
      <FpHeader
        eyebrow="April 2026 · 7-day streak"
        title="Habits"
        sub="6 of 8 today · 87% consistency this month"
        actions={
          <>
            <button className="fp-iconbtn"><IconFilter size={18}/></button>
            <button className="fp-iconbtn accent"><IconPlus size={18}/></button>
          </>
        }
      />

      <div className="fp-body">
        {/* HERO: streak + month summary */}
        <div className="fp-card" style={{
          display: 'flex', alignItems: 'center', gap: 14,
          background: 'linear-gradient(135deg, rgba(245,158,11,0.10), rgba(16,185,129,0.06))',
          borderColor: 'rgba(245,158,11,0.25)',
        }}>
          <div style={{
            width: 60, height: 60, borderRadius: 16,
            background: 'rgba(245,158,11,0.18)',
            color: 'var(--ds-warning)',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            flexShrink: 0,
            boxShadow: '0 0 18px rgba(245,158,11,0.3)',
          }}>
            <IconFlame size={28}/>
          </div>
          <div style={{ flex: 1, minWidth: 0 }}>
            <div className="fp-stat-lbl" style={{ marginBottom: 2 }}>Current streak</div>
            <div style={{ fontSize: 28, fontWeight: 800, letterSpacing: '-0.04em', lineHeight: 1 }}>
              7 <span style={{ fontSize: 14, color: 'var(--fg-3)', fontWeight: 600 }}>days</span>
            </div>
            <div style={{ fontSize: 11, color: 'var(--fg-2)', marginTop: 4 }}>
              5 more to beat your record of 12
            </div>
          </div>
        </div>

        {/* CALENDAR */}
        <div className="fp-card">
          <div className="fp-card-hd">
            <span className="fp-card-title">April 2026</span>
            <div style={{ display: 'flex', gap: 4 }}>
              <button className="fp-iconbtn" style={{ width: 30, height: 30 }}><IconChevL size={14}/></button>
              <button className="fp-iconbtn" style={{ width: 30, height: 30 }}><IconChevR size={14}/></button>
            </div>
          </div>

          {/* habit dots legend */}
          <div style={{ display: 'flex', gap: 12, fontSize: 10, color: 'var(--fg-2)', marginBottom: 14, fontWeight: 600, flexWrap: 'wrap' }}>
            <span style={{ display: 'flex', alignItems: 'center', gap: 4 }}><span style={{ width: 10, height: 10, borderRadius: 3, background: 'var(--heat-1)' }}/> Light</span>
            <span style={{ display: 'flex', alignItems: 'center', gap: 4 }}><span style={{ width: 10, height: 10, borderRadius: 3, background: 'var(--heat-2)' }}/> Some</span>
            <span style={{ display: 'flex', alignItems: 'center', gap: 4 }}><span style={{ width: 10, height: 10, borderRadius: 3, background: 'var(--heat-3)' }}/> Most</span>
            <span style={{ display: 'flex', alignItems: 'center', gap: 4 }}><span style={{ width: 10, height: 10, borderRadius: 3, background: 'var(--heat-4)' }}/> All</span>
          </div>

          <div className="fp-cal" style={{ padding: 0 }}>
            <div className="fp-cal-hdr">
              {weekday.map((d, i) => <div key={i}>{d}</div>)}
            </div>
            <div className="fp-cal-grid">
              {cells.map((c, i) => {
                if (c.empty) return <div key={i} className="fp-cal-cell empty"/>;
                const cls = ['fp-cal-cell'];
                if (c.level > 0) cls.push(`l${c.level}`);
                if (c.today) cls.push('today');
                if (!c.today && c.day > 14) cls.push('empty');
                return <div key={i} className={cls.join(' ')}>{c.day}</div>;
              })}
            </div>
          </div>
        </div>

        {/* TODAY HABITS */}
        <div className="fp-section">
          <h3>Today · 6 of 8 done</h3>
          <a className="link" href="#">All <IconChevR size={12}/></a>
        </div>
        <div className="fp-card no-pad">
          {[
            { tag: 'fitness', title: '30 min cardio', meta: 'Run · 21 min logged', streak: 7, done: true },
            { tag: 'nutrition', title: 'Hit protein target', meta: '102 of 130g — 28g to go', streak: 4, done: false },
            { tag: 'water', title: 'Drink 8 glasses water', meta: '5 of 8', streak: 12, done: false },
            { tag: 'mind', title: '10 min meditation', meta: 'Morning · done', streak: 21, done: true },
            { tag: 'sleep', title: 'Bed by 10:30p', meta: 'Tonight\'s goal', streak: 3, done: false, pending: true },
            { tag: 'fitness', title: 'Hit 8,000 steps', meta: '6,420 today', streak: 9, done: false },
          ].map((h, i) => (
            <div key={i} className="fp-habit-row">
              <div className={`fp-habit-check ${h.done ? 'done' : ''}`}>
                {h.done && <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="3.5" strokeLinecap="round" strokeLinejoin="round"><polyline points="20 6 9 17 4 12"/></svg>}
              </div>
              <div className="fp-habit-body">
                <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                  <span className={`fp-habit-tag ${h.tag}`}/>
                  <span className="fp-habit-title">{h.title}</span>
                </div>
                <div className="fp-habit-meta">
                  <span>{h.meta}</span>
                </div>
              </div>
              {h.streak > 0 && (
                <span className="fp-habit-streak">
                  <IconFlame size={11}/> {h.streak}
                </span>
              )}
            </div>
          ))}
        </div>

        {/* AI INSIGHT */}
        <div className="fp-card" style={{
          background: 'linear-gradient(135deg, var(--ds-accent-soft), rgba(16,185,129,0.04))',
          borderColor: 'rgba(16,185,129,0.28)',
          marginTop: 4,
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
                Pattern · last 30 days
              </div>
              <div style={{ fontSize: 13, color: 'var(--fg-1)', lineHeight: 1.5 }}>
                You finish your habit list 86% of the time when you train in the morning. Tuesdays are your strongest day.
              </div>
            </div>
          </div>
        </div>

        {/* CATEGORY ANALYTICS */}
        <div className="fp-section"><h3>This week by category</h3></div>
        <div className="fp-card">
          {[
            { tag: 'fitness', label: 'Fitness', n: 5, of: 7 },
            { tag: 'nutrition', label: 'Nutrition', n: 6, of: 7 },
            { tag: 'water', label: 'Hydration', n: 4, of: 7 },
            { tag: 'mind', label: 'Mindfulness', n: 7, of: 7 },
            { tag: 'sleep', label: 'Sleep', n: 4, of: 7 },
          ].map((c, i) => (
            <div key={i} style={{
              display: 'flex', alignItems: 'center', gap: 12,
              padding: '8px 0',
              borderTop: i === 0 ? 'none' : '1px solid var(--border-subtle)',
            }}>
              <span className={`fp-habit-tag ${c.tag}`} style={{ width: 10, height: 10 }}/>
              <span style={{ flex: 1, fontSize: 13, fontWeight: 600 }}>{c.label}</span>
              <div style={{ width: 90, height: 4, borderRadius: 2, background: 'var(--bg-pill)', overflow: 'hidden' }}>
                <div style={{
                  width: `${(c.n / c.of) * 100}%`, height: '100%',
                  background: c.n === c.of ? 'var(--ds-accent)' : 'var(--fg-2)',
                  borderRadius: 2,
                  boxShadow: c.n === c.of ? '0 0 8px var(--ds-accent-glow)' : 'none',
                }}/>
              </div>
              <span style={{ fontSize: 12, fontWeight: 700, fontVariantNumeric: 'tabular-nums', color: 'var(--fg-2)', minWidth: 28, textAlign: 'right' }}>
                {c.n}<span style={{ color: 'var(--fg-3)' }}>/{c.of}</span>
              </span>
            </div>
          ))}
        </div>
      </div>
    </>
  );
}

window.HabitsScreen = HabitsScreen;
