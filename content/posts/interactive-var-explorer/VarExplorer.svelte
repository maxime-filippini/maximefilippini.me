<script lang="ts">
  // Interactive Value-at-Risk explorer: daily returns with 1% volatility, under
  // a Normal or a fat-tailed Student-t distribution (scaled to the same volatility).

  type Dist = "normal" | "student";

  let confidence = $state(0.99);
  let dist = $state<Dist>("normal");
  let width = $state(640);
  let hoverX = $state<number | null>(null);

  const SIGMA = 1; // daily volatility, in %
  const DF = 4; // Student-t degrees of freedom
  // Plotted range, in %.
  const X_MIN = -6;
  const X_MAX = 6;
  // Integration range: much wider than the plot so fat tails aren't truncated.
  const CALC_MIN = -40;
  const CALC_MAX = 40;
  const STEP = 0.01;
  const height = 280;
  const margin = { top: 16, right: 16, bottom: 32, left: 16 };

  function gammaLn(z: number): number {
    // Lanczos approximation
    const g = 7;
    const c = [
      0.99999999999980993, 676.5203681218851, -1259.1392167224028, 771.32342877765313,
      -176.61502916214059, 12.507343278686905, -0.13857109526572012, 9.9843695780195716e-6,
      1.5056327351493116e-7,
    ];
    if (z < 0.5) return Math.log(Math.PI / Math.sin(Math.PI * z)) - gammaLn(1 - z);
    z -= 1;
    let x = c[0];
    for (let i = 1; i < g + 2; i++) x += c[i] / (z + i);
    const t = z + g + 0.5;
    return 0.5 * Math.log(2 * Math.PI) + (z + 0.5) * Math.log(t) - t + Math.log(x);
  }

  function density(x: number, d: Dist): number {
    if (d === "normal") return Math.exp(-0.5 * (x / SIGMA) ** 2) / (SIGMA * Math.sqrt(2 * Math.PI));
    // Student-t rescaled so its standard deviation equals SIGMA
    const s = SIGMA * Math.sqrt((DF - 2) / DF);
    const t = x / s;
    const logC = gammaLn((DF + 1) / 2) - gammaLn(DF / 2) - 0.5 * Math.log(DF * Math.PI);
    return Math.exp(logC - ((DF + 1) / 2) * Math.log(1 + (t * t) / DF)) / s;
  }

  /** Density, cumulative probability, VaR and Expected Shortfall on a grid. */
  function model(d: Dist, c: number) {
    const n = Math.round((CALC_MAX - CALC_MIN) / STEP) + 1;
    const step = STEP;
    const xs = Array.from({ length: n }, (_, i) => CALC_MIN + i * step);
    const ys = xs.map((x) => density(x, d));
    const cdf = [0];
    for (let i = 1; i < n; i++) cdf.push(cdf[i - 1] + ((ys[i] + ys[i - 1]) / 2) * step);
    const total = cdf[n - 1];
    const p = cdf.map((v) => v / total);

    // Quantile at 1 - c, interpolated between grid points.
    const alpha = 1 - c;
    const k = p.findIndex((v) => v >= alpha);
    const q = xs[k - 1] + ((alpha - p[k - 1]) / (p[k] - p[k - 1])) * step;

    // Expected Shortfall: mean return conditional on being below the quantile.
    let num = 0;
    let den = 0;
    for (let i = 0; i < n && xs[i] <= q; i++) {
      num += xs[i] * ys[i] * step;
      den += ys[i] * step;
    }
    // Points inside the plotted range (every 5th grid point is plenty to draw).
    const plotted = xs.flatMap((x, i) => (x >= X_MIN && x <= X_MAX && i % 5 === 0 ? [i] : []));
    return { xs, ys, p, plotted, varValue: -q, es: -num / den };
  }

  const m = $derived(model(dist, confidence));
  const yMax = $derived(Math.max(...m.plotted.map((i) => m.ys[i])) * 1.08);
  const innerW = $derived(width - margin.left - margin.right);
  const innerH = height - margin.top - margin.bottom;

  const sx = (x: number) => margin.left + ((x - X_MIN) / (X_MAX - X_MIN)) * innerW;
  const sy = (y: number) => margin.top + innerH - (y / yMax) * innerH;

  const linePath = $derived(
    m.plotted.map((i, k) => `${k ? "L" : "M"}${sx(m.xs[i])},${sy(m.ys[i])}`).join(""),
  );
  const bodyArea = $derived(`${linePath}L${sx(X_MAX)},${sy(0)}L${sx(X_MIN)},${sy(0)}Z`);
  const tailArea = $derived.by(() => {
    const pts = m.plotted.flatMap((i) => (m.xs[i] <= -m.varValue ? [`${sx(m.xs[i])},${sy(m.ys[i])}`] : []));
    return `M${sx(X_MIN)},${sy(0)}L${pts.join("L")}L${sx(-m.varValue)},${sy(0)}Z`;
  });

  const ticks = [-6, -4, -2, 0, 2, 4, 6];

  const hover = $derived.by(() => {
    if (hoverX === null || hoverX < X_MIN || hoverX > X_MAX) return null;
    const i = Math.round((hoverX - CALC_MIN) / STEP);
    return { x: m.xs[i], y: m.ys[i], p: m.p[i] };
  });

  function onMove(e: PointerEvent) {
    const rect = (e.currentTarget as SVGElement).getBoundingClientRect();
    const px = e.clientX - rect.left;
    hoverX = X_MIN + ((px - margin.left) / innerW) * (X_MAX - X_MIN);
  }

  const fmt = (v: number) => `${v.toFixed(2)}%`;
  const tableLevels = [0.95, 0.975, 0.99, 0.995];
</script>

<figure class="viz not-prose my-8">
  <div class="flex flex-wrap items-end gap-6 mb-4 text-sm">
    <label class="flex flex-col gap-1">
      <span>Confidence level: <strong>{(confidence * 100).toFixed(1)}%</strong></span>
      <input type="range" class="range range-xs w-56" min="0.9" max="0.995" step="0.005" bind:value={confidence} />
    </label>
    <fieldset class="flex gap-4">
      <legend class="sr-only">Distribution</legend>
      <label class="flex items-center gap-2">
        <input type="radio" class="radio radio-xs" value="normal" bind:group={dist} /> Normal
      </label>
      <label class="flex items-center gap-2">
        <input type="radio" class="radio radio-xs" value="student" bind:group={dist} /> Student-t (ν = {DF})
      </label>
    </fieldset>
  </div>

  <div class="grid grid-cols-2 gap-px bg-base-300 border border-base-300 mb-4">
    <div class="bg-base-100 p-4">
      <p class="text-xs muted">Value-at-Risk</p>
      <p class="text-2xl font-bold">{fmt(m.varValue)}</p>
    </div>
    <div class="bg-base-100 p-4">
      <p class="text-xs muted">Expected Shortfall</p>
      <p class="text-2xl font-bold">{fmt(m.es)}</p>
    </div>
  </div>

  <div class="relative" bind:clientWidth={width}>
    <svg
      {width}
      {height}
      role="img"
      aria-label={`Distribution of daily returns. ${(confidence * 100).toFixed(1)}% VaR is ${fmt(m.varValue)}.`}
      onpointermove={onMove}
      onpointerleave={() => (hoverX = null)}
    >
      {#each ticks as t (t)}
        <line class="grid" x1={sx(t)} x2={sx(t)} y1={margin.top} y2={sy(0)} />
        <text class="tick" x={sx(t)} y={height - 10} text-anchor="middle">{t}%</text>
      {/each}
      <path class="body-area" d={bodyArea} />
      <path class="tail-area" d={tailArea} />
      <path class="line" d={linePath} />
      <line class="var-line" x1={sx(-m.varValue)} x2={sx(-m.varValue)} y1={margin.top} y2={sy(0)} />
      <text class="label" x={sx(-m.varValue) - 6} y={margin.top + 12} text-anchor="end">−VaR</text>
      <line class="axis" x1={margin.left} x2={width - margin.right} y1={sy(0)} y2={sy(0)} />
      {#if hover}
        <line class="crosshair" x1={sx(hover.x)} x2={sx(hover.x)} y1={margin.top} y2={sy(0)} />
        <circle class="dot" cx={sx(hover.x)} cy={sy(hover.y)} r="4" />
      {/if}
    </svg>
    {#if hover}
      <div
        class="tooltip-box"
        style:left={`${hover.x < 0 ? sx(hover.x) - 190 : sx(hover.x) + 12}px`}
        style:top={`${margin.top}px`}
      >
        <p>Return: <strong>{fmt(hover.x)}</strong></p>
        <p>P(return ≤ this): <strong>{(hover.p * 100).toFixed(2)}%</strong></p>
      </div>
    {/if}
  </div>

  <figcaption class="flex flex-wrap gap-4 text-xs mt-2">
    <span class="flex items-center gap-2"><span class="key key-body"></span> Daily return distribution</span>
    <span class="flex items-center gap-2"><span class="key key-tail"></span> Loss tail beyond VaR ({((1 - confidence) * 100).toFixed(1)}%)</span>
  </figcaption>

  <details class="mt-3 text-xs">
    <summary class="cursor-pointer muted">Show as a table</summary>
    <table class="table table-xs mt-2">
      <thead><tr><th>Confidence</th><th>VaR (Normal)</th><th>VaR (Student-t)</th><th>ES (Normal)</th><th>ES (Student-t)</th></tr></thead>
      <tbody>
        {#each tableLevels as c (c)}
          {@const n = model("normal", c)}
          {@const s = model("student", c)}
          <tr><td>{(c * 100).toFixed(1)}%</td><td>{fmt(n.varValue)}</td><td>{fmt(s.varValue)}</td><td>{fmt(n.es)}</td><td>{fmt(s.es)}</td></tr>
        {/each}
      </tbody>
    </table>
  </details>
</figure>

<style>
  .viz {
    --series-1: #2a78d6;
    --series-2: #eb6834;
    --ink-muted: color-mix(in oklch, var(--color-base-content) 60%, transparent);
    --hairline: var(--color-base-300);
  }
  :global([data-theme="black"]) .viz {
    --series-1: #3987e5;
    --series-2: #d95926;
  }
  svg {
    display: block;
    overflow: visible;
    touch-action: pan-y;
  }
  .muted {
    color: var(--ink-muted);
  }
  .grid {
    stroke: var(--hairline);
    stroke-width: 1;
  }
  .axis {
    stroke: var(--ink-muted);
    stroke-width: 1;
  }
  .tick,
  .label {
    fill: var(--ink-muted);
    font-size: 11px;
  }
  .line {
    fill: none;
    stroke: var(--series-1);
    stroke-width: 2;
    stroke-linejoin: round;
  }
  .body-area {
    fill: var(--series-1);
    opacity: 0.1;
  }
  .tail-area {
    fill: var(--series-2);
    opacity: 0.85;
  }
  .var-line {
    stroke: var(--series-2);
    stroke-width: 2;
  }
  .crosshair {
    stroke: var(--ink-muted);
    stroke-width: 1;
  }
  .dot {
    fill: var(--series-1);
    stroke: var(--color-base-100);
    stroke-width: 2;
  }
  .tooltip-box {
    position: absolute;
    pointer-events: none;
    width: 178px;
    padding: 0.5rem 0.75rem;
    font-size: 0.75rem;
    background: var(--color-base-100);
    border: 1px solid var(--color-base-300);
  }
  .key {
    display: inline-block;
    width: 14px;
    height: 10px;
  }
  .key-body {
    border-top: 2px solid var(--series-1);
    background: color-mix(in oklch, var(--series-1) 10%, transparent);
  }
  .key-tail {
    background: var(--series-2);
  }
</style>
