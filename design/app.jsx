// FitnessPal — main app
// Renders the design canvas with each screen inside an iOS device frame,
// + Tweaks panel for theme + density.

const {
  DesignCanvas, DCSection, DCArtboard,
  IOSDevice,
  TweaksPanel, useTweaks, TweakSection, TweakRadio, TweakToggle,
  DashboardScreen, ActivityScreen, MealsScreen, HabitsScreen, ProfileScreen,
  FpTabBar,
  IconMoon, IconSun,
} = window;

const TWEAK_DEFAULTS = /*EDITMODE-BEGIN*/{
  "theme": "dark",
  "density": "default"
}/*EDITMODE-END*/;

function ScreenInPhone({ screenId, theme, density }) {
  const [activeTab, setActiveTab] = React.useState(screenId);

  // when the artboard's screenId changes (it doesn't, but for clarity), reset
  React.useEffect(() => setActiveTab(screenId), [screenId]);

  // pick which content to render based on activeTab
  const Content = {
    dashboard: DashboardScreen,
    activity: ActivityScreen,
    meals: MealsScreen,
    habits: HabitsScreen,
    profile: ProfileScreen,
  }[activeTab] || DashboardScreen;

  const themeClass = theme === 'light' ? 'fp-theme-light' : 'fp-theme-dark';
  const densityClass =
    density === 'compact' ? 'fp-density-compact'
    : density === 'comfortable' ? 'fp-density-comfortable'
    : '';

  return (
    <IOSDevice width={402} height={874} dark={theme !== 'light'}>
      <div className={`fp-app ${themeClass} ${densityClass}`}>
        <div className="fp-screen">
          <Content/>
        </div>
        <FpTabBar active={activeTab} onChange={setActiveTab}/>
      </div>
    </IOSDevice>
  );
}

function App() {
  const [t, setT] = useTweaks(TWEAK_DEFAULTS);

  const screens = [
    { id: 'dashboard', label: '01 · Dashboard', sub: 'AI-powered home with body avatar trajectory' },
    { id: 'activity',  label: '02 · Activity',  sub: 'Chronological wellness timeline' },
    { id: 'meals',     label: '03 · Meals',     sub: 'AI nutrition engine + macro analysis' },
    { id: 'habits',    label: '04 · Habits',    sub: 'Calendar streaks + category tracking' },
    { id: 'profile',   label: '05 · Profile',   sub: 'Goals, integrations, wellness score' },
  ];

  return (
    <>
      <DesignCanvas
        title="FitnessPal · Mobile"
        subtitle="iOS · 5 core screens · dark/light · AI assistant integrated throughout"
      >
        <DCSection
          id="screens"
          title="Core screens"
          subtitle="Bottom-tab nav · tap a tab inside any phone to navigate, or click expand to view fullscreen"
        >
          {screens.map(s => (
            <DCArtboard
              key={s.id}
              id={s.id}
              label={s.label}
              width={430}
              height={930}
              data-screen-label={s.label}
            >
              <ScreenInPhone screenId={s.id} theme={t.theme} density={t.density}/>
            </DCArtboard>
          ))}
        </DCSection>
      </DesignCanvas>

      <TweaksPanel title="Tweaks">
        <TweakSection label="Theme">
          <TweakRadio
            label="Appearance"
            value={t.theme}
            onChange={(v) => setT('theme', v)}
            options={[
              { label: 'Dark', value: 'dark' },
              { label: 'Light', value: 'light' },
            ]}
          />
        </TweakSection>
        <TweakSection label="Density">
          <TweakRadio
            label="Card spacing"
            value={t.density}
            onChange={(v) => setT('density', v)}
            options={[
              { label: 'Compact', value: 'compact' },
              { label: 'Default', value: 'default' },
              { label: 'Comfy', value: 'comfortable' },
            ]}
          />
        </TweakSection>
      </TweaksPanel>
    </>
  );
}

window.App = App;
ReactDOM.createRoot(document.getElementById('root')).render(<App/>);
