// FitnessPal — Avatar (stylized body + time-slider morph)
// Front-view silhouette with muscle/fat zones that brighten as the user
// scrubs forward through their projected transformation.

const { IconSparkles, IconChevR } = window;

// Time-slider states. progress 0 = today, 1 = 4wk, 2 = 12wk.
const AVATAR_STATES = [
  {
    key: 'today',
    label: 'Today',
    sub: 'Apr 14, 2026',
    metrics: { weight: 178, fat: 22, muscle: 138, recovery: 72, energy: 6.4 },
    // muscle group intensity (0–1)
    intensity: { chest: 0.35, delts: 0.30, biceps: 0.25, core: 0.20, quads: 0.30, calves: 0.25 },
    waistScale: 1.0,
    chestScale: 1.0,
    deltas: null,
  },
  {
    key: '4wk',
    label: '+4 wk',
    sub: 'May 12 · projected',
    metrics: { weight: 174, fat: 19, muscle: 141, recovery: 78, energy: 7.2 },
    intensity: { chest: 0.55, delts: 0.50, biceps: 0.45, core: 0.45, quads: 0.50, calves: 0.40 },
    waistScale: 0.97,
    chestScale: 1.01,
    deltas: { weight: -4, fat: -3, muscle: +3 },
  },
  {
    key: '12wk',
    label: '+12 wk',
    sub: 'Jul 7 · projected',
    metrics: { weight: 168, fat: 15, muscle: 146, recovery: 85, energy: 8.1 },
    intensity: { chest: 0.85, delts: 0.80, biceps: 0.78, core: 0.90, quads: 0.80, calves: 0.70 },
    waistScale: 0.92,
    chestScale: 1.03,
    deltas: { weight: -10, fat: -7, muscle: +8 },
  },
];

// SVG body parts — simple stylized silhouette, front view.
function BodySVG({ state }) {
  const i = state.intensity;
  // Soft glow color (emerald)
  const glow = (a) => `rgba(16, 185, 129, ${a})`;
  const w = state.waistScale;
  const c = state.chestScale;

  return (
    <svg
      viewBox="0 0 220 380"
      width="100%" height="100%"
      style={{ maxHeight: 260, display: 'block' }}
    >
      <defs>
        <radialGradient id="body-shade" cx="50%" cy="35%" r="65%">
          <stop offset="0%" stopColor="var(--avatar-body)" stopOpacity="0.5"/>
          <stop offset="100%" stopColor="var(--avatar-body)" stopOpacity="1"/>
        </radialGradient>
        <radialGradient id="muscle-glow">
          <stop offset="0%" stopColor="#10b981" stopOpacity="0.85"/>
          <stop offset="60%" stopColor="#10b981" stopOpacity="0.20"/>
          <stop offset="100%" stopColor="#10b981" stopOpacity="0"/>
        </radialGradient>
        <linearGradient id="topology" x1="0" x2="0" y1="0" y2="1">
          <stop offset="0%" stopColor="rgba(16,185,129,0.0)"/>
          <stop offset="50%" stopColor="rgba(16,185,129,0.35)"/>
          <stop offset="100%" stopColor="rgba(16,185,129,0.0)"/>
        </linearGradient>
        <filter id="soft" x="-50%" y="-50%" width="200%" height="200%">
          <feGaussianBlur stdDeviation="4"/>
        </filter>
      </defs>

      {/* ─── Body silhouette ─── */}
      <g style={{ transition: 'transform 0.6s var(--ds-ease)' }}>
        {/* head */}
        <ellipse cx="110" cy="34" rx="22" ry="26" fill="url(#body-shade)" stroke="var(--avatar-body-stroke)" strokeWidth="1"/>
        {/* neck */}
        <path d="M 99 56 L 99 72 L 121 72 L 121 56 Z" fill="url(#body-shade)" stroke="var(--avatar-body-stroke)" strokeWidth="1"/>

        {/* torso (with waist scale) */}
        <g style={{
          transformOrigin: '110px 150px',
          transform: `scaleX(${w})`,
          transition: 'transform 0.6s var(--ds-ease)',
        }}>
          <path
            d="
              M 70 78
              Q 50 84 48 100
              Q 46 120 52 145
              Q 56 175 62 200
              Q 68 218 75 230
              L 145 230
              Q 152 218 158 200
              Q 164 175 168 145
              Q 174 120 172 100
              Q 170 84 150 78
              Q 130 70 110 70
              Q 90 70 70 78 Z
            "
            fill="url(#body-shade)"
            stroke="var(--avatar-body-stroke)" strokeWidth="1.2"
          />
          {/* center line */}
          <line x1="110" y1="82" x2="110" y2="225" stroke="var(--avatar-body-stroke)" strokeWidth="0.6" opacity="0.5"/>
        </g>

        {/* arms - left */}
        <path
          d="M 50 92 Q 38 110 36 140 Q 36 170 42 200 Q 46 220 48 232 L 60 232 Q 60 220 58 200 Q 56 170 54 145 Q 56 120 60 100 Z"
          fill="url(#body-shade)"
          stroke="var(--avatar-body-stroke)" strokeWidth="1"
        />
        {/* arms - right */}
        <path
          d="M 170 92 Q 182 110 184 140 Q 184 170 178 200 Q 174 220 172 232 L 160 232 Q 160 220 162 200 Q 164 170 166 145 Q 164 120 160 100 Z"
          fill="url(#body-shade)"
          stroke="var(--avatar-body-stroke)" strokeWidth="1"
        />

        {/* legs */}
        <path
          d="M 75 230 Q 70 270 72 310 Q 74 340 80 360 L 102 360 Q 104 340 106 310 Q 108 270 107 230 Z"
          fill="url(#body-shade)" stroke="var(--avatar-body-stroke)" strokeWidth="1"
        />
        <path
          d="M 113 230 Q 112 270 114 310 Q 116 340 118 360 L 140 360 Q 146 340 148 310 Q 150 270 145 230 Z"
          fill="url(#body-shade)" stroke="var(--avatar-body-stroke)" strokeWidth="1"
        />
      </g>

      {/* ─── Muscle/zone glows (radial blobs that brighten with progress) ─── */}
      <g filter="url(#soft)" style={{ transition: 'opacity 0.6s var(--ds-ease)' }}>
        {/* Chest (left + right pec) */}
        <ellipse cx="92" cy="105" rx="22" ry="14" fill="url(#muscle-glow)" opacity={i.chest}/>
        <ellipse cx="128" cy="105" rx="22" ry="14" fill="url(#muscle-glow)" opacity={i.chest}/>
        {/* Delts */}
        <ellipse cx="62" cy="95" rx="14" ry="11" fill="url(#muscle-glow)" opacity={i.delts}/>
        <ellipse cx="158" cy="95" rx="14" ry="11" fill="url(#muscle-glow)" opacity={i.delts}/>
        {/* Biceps */}
        <ellipse cx="48" cy="135" rx="10" ry="18" fill="url(#muscle-glow)" opacity={i.biceps}/>
        <ellipse cx="172" cy="135" rx="10" ry="18" fill="url(#muscle-glow)" opacity={i.biceps}/>
        {/* Core / abs */}
        <ellipse cx="110" cy="155" rx="16" ry="22" fill="url(#muscle-glow)" opacity={i.core}/>
        <ellipse cx="110" cy="190" rx="14" ry="14" fill="url(#muscle-glow)" opacity={i.core * 0.9}/>
        {/* Quads */}
        <ellipse cx="90" cy="265" rx="14" ry="22" fill="url(#muscle-glow)" opacity={i.quads}/>
        <ellipse cx="130" cy="265" rx="14" ry="22" fill="url(#muscle-glow)" opacity={i.quads}/>
        {/* Calves */}
        <ellipse cx="90" cy="330" rx="11" ry="16" fill="url(#muscle-glow)" opacity={i.calves}/>
        <ellipse cx="130" cy="330" rx="11" ry="16" fill="url(#muscle-glow)" opacity={i.calves}/>
      </g>

      {/* ─── Definition lines (topology) ─── */}
      <g stroke="url(#topology)" fill="none" strokeWidth="0.8" style={{ opacity: 0.5 + i.core * 0.5, transition: 'opacity 0.6s var(--ds-ease)' }}>
        {/* pec line */}
        <path d="M 88 118 Q 110 122 132 118"/>
        {/* ab segmentation */}
        <line x1="92" y1="145" x2="128" y2="145"/>
        <line x1="94" y1="165" x2="126" y2="165"/>
        <line x1="96" y1="185" x2="124" y2="185"/>
        {/* obliques V */}
        <path d="M 80 195 Q 110 210 140 195"/>
      </g>

      {/* ─── Floating dot points (anchors for labels) ─── */}
      <g>
        <circle cx="62" cy="135" r="3" fill="#10b981"/>
        <circle cx="62" cy="135" r="6" fill="none" stroke="#10b981" strokeWidth="1" opacity="0.4"/>

        <circle cx="110" cy="170" r="3" fill="#10b981"/>
        <circle cx="110" cy="170" r="6" fill="none" stroke="#10b981" strokeWidth="1" opacity="0.4"/>

        <circle cx="158" cy="95" r="3" fill="#10b981"/>
        <circle cx="158" cy="95" r="6" fill="none" stroke="#10b981" strokeWidth="1" opacity="0.4"/>

        <circle cx="130" cy="285" r="3" fill="#10b981"/>
        <circle cx="130" cy="285" r="6" fill="none" stroke="#10b981" strokeWidth="1" opacity="0.4"/>
      </g>
    </svg>
  );
}

function FpAvatar() {
  const [stateIdx, setStateIdx] = React.useState(0);
  const state = AVATAR_STATES[stateIdx];

  // tab indicator left/width (3 equal tabs)
  const indicatorStyle = {
    left: `calc(${(stateIdx / 3) * 100}% + 3px)`,
    width: `calc(${100 / 3}% - 6px)`,
  };

  const fmtDelta = (n, suffix = '') =>
    n == null ? null :
    <span className="delta">{n > 0 ? '+' : ''}{n}{suffix}</span>;

  return (
    <div className="fp-avatar-wrap">
      {/* eyebrow + greeting */}
      <div style={{ display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between', marginBottom: 6 }}>
        <div>
          <div style={{
            fontSize: 10, fontWeight: 700, letterSpacing: '0.12em',
            textTransform: 'uppercase', color: 'var(--fg-3)', marginBottom: 4,
          }}>Your trajectory</div>
          <div style={{
            fontSize: 20, fontWeight: 800, letterSpacing: '-0.025em',
            color: 'var(--fg-1)', lineHeight: 1.1,
          }}>
            {state.label === 'Today'
              ? 'Where you are today'
              : state.label === '+4 wk'
                ? 'You in 4 weeks'
                : 'You in 12 weeks'}
          </div>
          <div style={{ fontSize: 11, color: 'var(--fg-2)', marginTop: 3 }}>
            {state.sub}
          </div>
        </div>
        <div className="fp-pill accent" style={{ alignSelf: 'flex-start' }}>
          <IconSparkles size={11}/> AI
        </div>
      </div>

      {/* avatar stage with floating metric chips */}
      <div className="fp-avatar-stage" style={{ marginTop: 4 }}>
        <div className="glow"/>
        <BodySVG state={state}/>

        {/* Floating metric — top-left (Muscle) */}
        <div className="fp-avatar-metric" style={{ left: 0, top: '30%', alignItems: 'flex-start' }}>
          <span className="lbl">Muscle</span>
          <span className="val">
            {state.metrics.muscle}<span style={{ fontSize: 10, color: 'var(--fg-3)', fontWeight: 600 }}>lb</span>
            {fmtDelta(state.deltas?.muscle, 'lb')}
          </span>
        </div>

        {/* Floating metric — top-right (Recovery) */}
        <div className="fp-avatar-metric" style={{ right: 0, top: '12%', alignItems: 'flex-end' }}>
          <span className="lbl">Recovery</span>
          <span className="val">
            {state.metrics.recovery}<span style={{ fontSize: 10, color: 'var(--fg-3)', fontWeight: 600 }}>%</span>
          </span>
        </div>

        {/* Floating metric — bottom-left (Body fat) */}
        <div className="fp-avatar-metric" style={{ left: 0, bottom: '20%', alignItems: 'flex-start' }}>
          <span className="lbl">Body fat</span>
          <span className="val">
            {state.metrics.fat}<span style={{ fontSize: 10, color: 'var(--fg-3)', fontWeight: 600 }}>%</span>
            {fmtDelta(state.deltas?.fat, '%')}
          </span>
        </div>

        {/* Floating metric — bottom-right (Weight) */}
        <div className="fp-avatar-metric" style={{ right: 0, bottom: '32%', alignItems: 'flex-end' }}>
          <span className="lbl">Weight</span>
          <span className="val">
            {state.metrics.weight}<span style={{ fontSize: 10, color: 'var(--fg-3)', fontWeight: 600 }}>lb</span>
            {fmtDelta(state.deltas?.weight, 'lb')}
          </span>
        </div>
      </div>

      {/* Time slider */}
      <div className="fp-time-slider">
        <div className="fp-time-tabs">
          <div className="fp-time-tab-indicator" style={indicatorStyle}/>
          {AVATAR_STATES.map((s, idx) => (
            <button
              key={s.key}
              className={`fp-time-tab ${stateIdx === idx ? 'active' : ''}`}
              onClick={() => setStateIdx(idx)}
            >
              {s.label}
            </button>
          ))}
        </div>

        <div className="fp-time-summary">
          {stateIdx === 0 ? (
            <span>Stay consistent to reach your goals — your body adapts daily.</span>
          ) : (
            <>
              <span>If you keep your habits steady…</span>
              <span className="delta">
                <IconSparkles size={11} style={{ marginRight: 3, verticalAlign: '-1px' }}/>
                88% confidence
              </span>
            </>
          )}
        </div>
      </div>
    </div>
  );
}

window.FpAvatar = FpAvatar;
