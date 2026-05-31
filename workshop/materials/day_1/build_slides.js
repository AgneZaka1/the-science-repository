// Generates Day 1 PowerPoint from day_one_slides.md (parsed, not re-typed).
const fs = require("fs");
const path = require("path");
const pptxgen = require("pptxgenjs");

const DIR = __dirname;
const MD = path.join(DIR, "day_one_slides.md");
const IMG = path.resolve(DIR, "../../../workshop_info/overall_structure.png");
const OUT = path.join(DIR, "Day_1_Foundations_and_Setup.pptx");

// ---------- palette ----------
const INK = "1C2B3A";       // dark slate (titles)
const ACCENT = "0E7C7B";    // teal (primary accent)
const TEAL_BG = "E7F1F0";   // key panel
const CODE_BG = "F1F4F7";   // mono panel
const CODE_TX = "243748";   // mono text
const GREEN = "2E7D5B", GREEN_BG = "E7F2EC";
const AMBER = "9C5A00", AMBER_BG = "FBF0DA";
const GRAY_BG = "EDF0F3", GRAY_TX = "5A6B7B";
const MUTED = "7C8A99";
const WHITE = "FFFFFF";

const F_TITLE = "Georgia";
const F_BODY = "Calibri";
const F_MONO = "Consolas";

// ---------- parse markdown ----------
const raw = fs.readFileSync(MD, "utf8");
const sections = raw.split(/\n---\n/);

function parseSection(sec) {
  const lines = sec.split("\n");
  // find slide / break heading
  let hIdx = -1, isBreak = false, headingText = "", slideNum = null;
  for (let i = 0; i < lines.length; i++) {
    const m = lines[i].match(/^##\s+Slide\s+(\d+)\s*[—-]\s*(.*)$/);
    if (m) { hIdx = i; slideNum = parseInt(m[1], 10); headingText = m[2].trim(); break; }
    if (/^##\s+[☕🍽]/.test(lines[i])) { hIdx = i; isBreak = true; headingText = lines[i].replace(/^##\s+/, "").trim(); break; }
  }
  if (hIdx === -1) return null;

  let title = null, subtitle = null, visual = null;
  const blocks = []; const note = [];
  let curLabel = null, inFence = false, fenceLang = "", fenceBuf = [], mode = null;

  for (let i = hIdx + 1; i < lines.length; i++) {
    const line = lines[i];
    const fence = line.match(/^```(.*)$/);
    if (fence) {
      if (!inFence) { inFence = true; fenceLang = fence[1].trim(); fenceBuf = []; }
      else {
        inFence = false;
        blocks.push({ label: curLabel || "On slide", lang: fenceLang, text: fenceBuf.join("\n").replace(/\s+$/,"") });
      }
      continue;
    }
    if (inFence) { fenceBuf.push(line); continue; }

    const lm = line.match(/^\*\*(.+):\*\*\s*(.*)$/);
    if (lm) {
      let label = lm[1].replace(/\*/g, "").replace(/`/g, "").trim();
      const inline = lm[2].trim();
      if (/^Title$/i.test(label)) { title = inline; curLabel = null; continue; }
      if (/^Subtitle$/i.test(label)) { subtitle = inline; curLabel = null; continue; }
      if (/^Visual$/i.test(label)) { visual = inline.replace(/`/g, "").trim(); curLabel = null; continue; }
      if (/^Speaker note$/i.test(label)) { mode = "note"; curLabel = null; continue; }
      curLabel = label; mode = null; continue;
    }
    if (mode === "note") { if (line.trim()) note.push(line.trim()); }
  }

  return {
    slideNum, isBreak, headingText,
    title: title || headingText,
    subtitle, visual,
    blocks,
    note: note.join(" ").trim(),
  };
}

const slides = sections.map(parseSection).filter(Boolean);

// ---------- metadata helpers ----------
function partFor(n) {
  if (n <= 8) return "Part A · Framing & Expectations";
  if (n <= 19) return "Part B · GitHub First";
  if (n <= 26) return "Part C · R + RStudio";
  if (n <= 29) return "Part D · Environment Control (renv)";
  if (n <= 31) return "Part E · Documentation";
  if (n <= 39) return "Part F · Publishing";
  return "Part G · Wrap-up";
}
const STEP = { 12: 1, 13: 2, 15: 3, 16: 4, 21: 5, 22: 6, 29: 7, 38: 8 };
const OPTIONAL = new Set([23, 39]);

function blockStyle(label) {
  const l = (label || "").toLowerCase();
  if (l.includes("watch out")) return "warn";
  if (l === "check") return "check";
  if (l.includes("key")) return "key";
  if (l.startsWith("later")) return "later";
  return "mono";
}

// ---------- pptx setup ----------
const pres = new pptxgen();
pres.defineLayout({ name: "W", width: 13.333, height: 7.5 });
pres.layout = "W";
pres.author = "The Dataflow Company";
pres.title = "Day 1 — Foundations & Setup";

const PW = 13.333, PH = 7.5;
const MX = 0.7;
const CW = PW - 2 * MX;

function mkShadow() { return { type: "outer", color: "1C2B3A", blur: 7, offset: 3, angle: 135, opacity: 0.12 }; }

// estimate block height for a given font scale
function blockHeight(b, style, fs) {
  const nlines = b.text.split("\n").length;
  const lh = (fs * 1.32) / 72;
  if (style === "key") return Math.max(0.7, nlines * ((fs + 3) * 1.3) / 72 + 0.4);
  if (style === "mono") return nlines * lh + 0.32;
  // labeled (check/warn/later): label row + body
  return 0.34 + nlines * lh + 0.26;
}

function renderBlock(slide, b, style, x, y, w, fs, dark) {
  const nlines = b.text.split("\n").length;
  const lh = (fs * 1.32) / 72;
  if (style === "key") {
    const h = Math.max(0.7, nlines * ((fs + 3) * 1.3) / 72 + 0.4);
    slide.addShape(pres.shapes.ROUNDED_RECTANGLE, { x, y, w, h, fill: { color: TEAL_BG }, line: { type: "none" }, rectRadius: 0.06 });
    slide.addText(b.text, { x: x + 0.3, y, w: w - 0.6, h, fontFace: F_TITLE, italic: true, fontSize: fs + 3, color: ACCENT, align: "center", valign: "middle" });
    return h;
  }
  if (style === "mono") {
    const h = nlines * lh + 0.32;
    slide.addShape(pres.shapes.RECTANGLE, { x, y, w, h, fill: { color: CODE_BG }, line: { type: "none" } });
    slide.addShape(pres.shapes.RECTANGLE, { x, y, w: 0.07, h, fill: { color: ACCENT }, line: { type: "none" } });
    if (b.lang === "r" || b.lang === "bash") {
      slide.addText(b.lang.toUpperCase(), { x: x + w - 1.0, y: y + 0.04, w: 0.9, h: 0.22, fontFace: F_BODY, fontSize: 8, color: MUTED, align: "right", bold: true, charSpacing: 1 });
    }
    slide.addText(b.text, { x: x + 0.26, y: y + 0.16, w: w - 0.42, h: h - 0.32, fontFace: F_MONO, fontSize: fs, color: CODE_TX, align: "left", valign: "top", lineSpacingMultiple: 1.12 });
    return h;
  }
  // labeled
  const cfg = {
    check: { bar: GREEN, bg: GREEN_BG, tx: GREEN, label: "CHECK" },
    warn: { bar: AMBER, bg: AMBER_BG, tx: AMBER, label: "⚠  " + b.label.replace(/^[^A-Za-z]+/, "").toUpperCase() },
    later: { bar: GRAY_TX, bg: GRAY_BG, tx: GRAY_TX, label: b.label.replace(/^[^A-Za-z]+/, "").toUpperCase() },
  }[style];
  const h = 0.34 + nlines * lh + 0.26;
  slide.addShape(pres.shapes.RECTANGLE, { x, y, w, h, fill: { color: cfg.bg }, line: { type: "none" } });
  slide.addShape(pres.shapes.RECTANGLE, { x, y, w: 0.07, h, fill: { color: cfg.bar }, line: { type: "none" } });
  slide.addText(cfg.label, { x: x + 0.26, y: y + 0.08, w: w - 0.42, h: 0.26, fontFace: F_BODY, bold: true, fontSize: 10.5, color: cfg.tx, charSpacing: 1.5 });
  slide.addText(b.text, { x: x + 0.26, y: y + 0.36, w: w - 0.42, h: h - 0.5, fontFace: F_MONO, fontSize: fs - 1, color: CODE_TX, valign: "top", lineSpacingMultiple: 1.12 });
  return h;
}

// render a vertical stack of blocks into a column, auto-fitting font
function renderColumn(slide, items, x, y, w, availH, dark) {
  const baseFs = 13.5, floor = 8, gap = 0.16;
  const total = (fs) => items.reduce((a, it) => a + blockHeight(it.b, it.style, fs), 0) + gap * (items.length - 1);
  let fs = baseFs;
  while (fs > floor && total(fs) > availH) fs -= 0.25;
  let cy = y;
  for (const it of items) {
    const h = renderBlock(slide, it.b, it.style, x, cy, w, fs, dark);
    cy += h + gap;
  }
}

function addHeader(slide, s) {
  const kickerParts = [partFor(s.slideNum)];
  if (STEP[s.slideNum]) kickerParts.push("EXERCISE · STEP " + STEP[s.slideNum]);
  else if (OPTIONAL.has(s.slideNum)) kickerParts.push("OPTIONAL");
  slide.addText(kickerParts.join("    ·    ").toUpperCase(), {
    x: MX, y: 0.42, w: CW, h: 0.3, fontFace: F_BODY, bold: true, fontSize: 11, color: ACCENT, charSpacing: 1.5,
  });
  slide.addText(s.title, {
    x: MX, y: 0.74, w: CW, h: 0.95, fontFace: F_TITLE, bold: true, fontSize: 29, color: INK, valign: "top",
  });
  // footer
  slide.addText("The Science Repository  ·  Day 1", { x: MX, y: PH - 0.42, w: 6, h: 0.3, fontFace: F_BODY, fontSize: 9, color: MUTED });
  slide.addText(String(s.slideNum), { x: PW - MX - 1, y: PH - 0.42, w: 1, h: 0.3, fontFace: F_BODY, fontSize: 9, color: MUTED, align: "right" });
}

// ---------- per-slide rendering ----------
function renderTitleSlide(slide, s) {
  slide.background = { color: INK };
  slide.addShape(pres.shapes.RECTANGLE, { x: 0, y: 0, w: 0.28, h: PH, fill: { color: ACCENT }, line: { type: "none" } });
  slide.addText("WORKSHOP · DAY 1", { x: 1.0, y: 1.5, w: 11, h: 0.4, fontFace: F_BODY, bold: true, fontSize: 14, color: "8FD0CC", charSpacing: 2 });
  slide.addText(s.title, { x: 1.0, y: 2.0, w: 11.3, h: 1.2, fontFace: F_TITLE, bold: true, fontSize: 50, color: WHITE });
  if (s.subtitle) slide.addText(s.subtitle, { x: 1.02, y: 3.25, w: 11, h: 0.6, fontFace: F_BODY, fontSize: 20, color: "CFE0E0", italic: true });
  const onslide = s.blocks.find((b) => blockStyle(b.label) === "mono");
  if (onslide) {
    const nlines = onslide.text.split("\n").length;
    const h = nlines * 0.46 + 0.4;
    slide.addShape(pres.shapes.ROUNDED_RECTANGLE, { x: 1.0, y: 4.25, w: 9.5, h, fill: { color: "26384B" }, line: { type: "none" }, rectRadius: 0.06 });
    slide.addText(onslide.text, { x: 1.3, y: 4.25, w: 9.0, h, fontFace: F_MONO, fontSize: 16, color: "DCE7E7", valign: "middle", lineSpacingMultiple: 1.25 });
  }
  slide.addText("The Dataflow Company", { x: 1.0, y: PH - 0.7, w: 6, h: 0.3, fontFace: F_BODY, fontSize: 11, color: "6E8088" });
}

const stripEmoji = (t) => t.replace(/[\u{1F000}-\u{1FFFF}☀-➿️‍]/gu, "").replace(/\s{2,}/g, " ").trim();

function renderBreakSlide(slide, s) {
  slide.background = { color: INK };
  slide.addShape(pres.shapes.RECTANGLE, { x: 0, y: 0, w: 0.28, h: PH, fill: { color: ACCENT }, line: { type: "none" } });
  const heading = stripEmoji(s.headingText.replace(/\*/g, "").replace(/\s*\(end[^)]*\)/i, "")).replace(/^[—–-]\s*/, "").trim();
  const kicker = /lunch/i.test(heading) ? "BREAK · SESSION II ENDS" : "BREAK";
  slide.addText(kicker, { x: 1, y: 1.7, w: PW - 2, h: 0.4, fontFace: F_BODY, bold: true, fontSize: 14, color: "8FD0CC", align: "center", charSpacing: 2 });
  slide.addText(heading, { x: 1, y: 2.25, w: PW - 2, h: 0.9, fontFace: F_TITLE, bold: true, fontSize: 40, color: WHITE, align: "center" });
  const onslide = s.blocks.find((b) => blockStyle(b.label) === "mono");
  if (onslide) {
    slide.addShape(pres.shapes.ROUNDED_RECTANGLE, { x: 2.4, y: 3.55, w: PW - 4.8, h: 2.7, fill: { color: "26384B" }, line: { type: "none" }, rectRadius: 0.06 });
    slide.addText(onslide.text, { x: 2.7, y: 3.7, w: PW - 5.4, h: 2.4, fontFace: F_MONO, fontSize: 15, color: "DCE7E7", align: "left", valign: "middle", lineSpacingMultiple: 1.3 });
  }
}

function renderVisualSlide(slide, s) {
  addHeader(slide, s);
  // image preserve aspect
  const ow = 2788, oh = 1572;
  const maxW = CW, maxH = 4.6;
  let w = maxW, h = w * oh / ow;
  if (h > maxH) { h = maxH; w = h * ow / oh; }
  const x = (PW - w) / 2;
  slide.addImage({ path: IMG, x, y: 1.95, w, h });
}

function renderContentSlide(slide, s) {
  addHeader(slide, s);
  const top = 1.85, bottom = PH - 0.55;
  const availH = bottom - top;
  const items = s.blocks.map((b) => ({ b, style: blockStyle(b.label) }));
  renderColumn(slide, items, MX, top, CW, availH);
}

// ---------- build ----------
const top = 1.85, availH = (PH - 0.55) - 1.85;
for (const s of slides) {
  // Slide 22 is too dense for one slide — split into 1/2 (steps) and 2/2 (blockers).
  if (!s.isBreak && s.slideNum === 22) {
    const items = s.blocks.map((b) => ({ b, style: blockStyle(b.label) }));
    const steps = items.filter((it) => it.style === "mono");
    const helper = items.filter((it) => it.style !== "mono");
    const a = pres.addSlide(); a.background = { color: WHITE };
    addHeader(a, { ...s, title: s.title + "  (1 / 2)" });
    renderColumn(a, steps, MX, top, CW, availH);
    if (s.note) a.addNotes(s.note);
    const b = pres.addSlide(); b.background = { color: WHITE };
    addHeader(b, { ...s, title: s.title + "  (2 / 2)" });
    renderColumn(b, helper, MX, top, CW, availH);
    continue;
  }
  const slide = pres.addSlide();
  if (s.isBreak) renderBreakSlide(slide, s);
  else if (s.slideNum === 1) renderTitleSlide(slide, s);
  else if (s.visual) renderVisualSlide(slide, s);
  else { slide.background = { color: WHITE }; renderContentSlide(slide, s); }
  if (s.note) slide.addNotes(s.note);
}

pres.writeFile({ fileName: OUT }).then(() => {
  console.log("Wrote " + OUT + " (" + slides.length + " slides)");
});
