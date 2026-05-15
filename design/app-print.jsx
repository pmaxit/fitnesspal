// Print app — renders each phone screen on its own page, no canvas chrome.

const {
  IOSDevice,
  DashboardScreen, ActivityScreen, MealsScreen, HabitsScreen, ProfileScreen,
  FpTabBar,
} = window;

function ScreenInPhone({ screenId, theme }) {
  const Content = {
    dashboard: DashboardScreen,
    activity: ActivityScreen,
    meals: MealsScreen,
    habits: HabitsScreen,
    profile: ProfileScreen,
  }[screenId];

  return (
    <IOSDevice width={402} height={874} dark={theme !== 'light'}>
      <div className={`fp-app fp-theme-${theme === 'light' ? 'light' : 'dark'}`}>
        <div className="fp-screen">
          <Content/>
        </div>
        <FpTabBar active={screenId} onChange={() => {}}/>
      </div>
    </IOSDevice>
  );
}

function PrintApp() {
  const screens = [
    { id: 'dashboard', label: '01 · Dashboard', sub: 'AI body avatar with trajectory · daily rings · wellness insights' },
    { id: 'activity',  label: '02 · Activity',  sub: 'Chronological wellness timeline · day-score · trend' },
    { id: 'meals',     label: '03 · Meals',     sub: 'AI nutrition engine · macro rings · meal scoring · voice/photo log' },
    { id: 'habits',    label: '04 · Habits',    sub: 'Heatmap calendar · streaks · category breakdown' },
    { id: 'profile',   label: '05 · Profile',   sub: 'Goals · wellness score · device integrations · body metrics' },
  ];

  return (
    <div className="print-root">
      {/* Cover */}
      <section className="print-cover">
        <div className="cover-eyebrow">FitnessPal</div>
        <h1 className="cover-title">Holistic wellness, beautifully tracked.</h1>
        <p className="cover-sub">
          Five core mobile screens · iOS · dark theme · emerald accent · AI assistant integrated throughout
        </p>
        <div className="cover-grid">
          {screens.map((s, i) => (
            <div key={s.id} className="cover-thumb">
              <div className="cover-thumb-phone">
                <ScreenInPhone screenId={s.id} theme="dark"/>
              </div>
              <div className="cover-thumb-label">{s.label}</div>
            </div>
          ))}
        </div>
        <div className="cover-footer">May 2026 · v1.0 design exploration</div>
      </section>

      {/* One page per screen */}
      {screens.map(s => (
        <section key={s.id} className="print-page">
          <header className="print-header">
            <div className="print-eyebrow">FitnessPal · Mobile</div>
            <h2 className="print-title">{s.label}</h2>
            <p className="print-sub">{s.sub}</p>
          </header>
          <div className="print-stage">
            <ScreenInPhone screenId={s.id} theme="dark"/>
          </div>
        </section>
      ))}
    </div>
  );
}

window.PrintApp = PrintApp;
ReactDOM.createRoot(document.getElementById('root')).render(<PrintApp/>);

// Auto-print when ready: wait for fonts + layout + a small buffer.
(async () => {
  try { await document.fonts.ready; } catch {}
  // give React + image-less layout a beat to settle
  await new Promise(r => setTimeout(r, 800));
  window.print();
})();
