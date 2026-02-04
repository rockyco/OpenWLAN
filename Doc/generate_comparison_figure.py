#!/usr/bin/env python3
# /// script
# requires-python = ">=3.9"
# dependencies = ["matplotlib", "numpy"]
# ///
"""Generate a 2x2 comparison figure: A2H_Coder (HLS) vs HDL Coder on Zynq-7020.

Produces Doc/resource_comparison.png for the README.
Data sourced from Doc/resource_comparison.md and cosim logs.

Usage: uv run Doc/generate_comparison_figure.py
"""

import pathlib

import matplotlib.pyplot as plt
import matplotlib.ticker as ticker
import numpy as np

# ---------------------------------------------------------------------------
# Data (hardcoded from verified post-implementation reports)
# ---------------------------------------------------------------------------
resources = ["LUT", "FF", "DSP", "BRAM\nTile", "Slice"]
a2h_counts = np.array([8220, 14019, 172, 17, 4258], dtype=float)
hdl_counts = np.array([31914, 76786, 112, 17.5, 13299], dtype=float)
available = np.array([53200, 106400, 220, 140, 13300], dtype=float)

a2h_pct = a2h_counts / available * 100
hdl_pct = hdl_counts / available * 100

# Efficiency ratios (HDL / HLS) - values > 1 mean HLS is more efficient
ratio_labels = ["LUT", "FF", "Slice", "BRAM", "DSP"]
ratios = np.array([31914 / 8220, 76786 / 14019, 13299 / 4258, 17.5 / 17, 112 / 172])

# CFO accuracy
cfo_labels = ["True\nValue", "A2H_Coder\n(HLS)", "HDL Coder"]
cfo_values = [10000, 9977, 9695]
cfo_errors = ["Reference", "0.23%", "3.05%"]

# ---------------------------------------------------------------------------
# Style constants
# ---------------------------------------------------------------------------
BLUE = "#2196F3"
ORANGE = "#FF9800"
GREEN = "#4CAF50"
RED = "#E53935"
GREY = "#9E9E9E"

plt.rcParams.update({
    "font.family": "sans-serif",
    "font.size": 11,
    "axes.titlesize": 13,
    "axes.titleweight": "bold",
    "axes.spines.top": False,
    "axes.spines.right": False,
})

fig, axes = plt.subplots(2, 2, figsize=(14, 10))
fig.suptitle(
    "OpenWLAN: A2H_Coder (HLS) vs HDL Coder on Zynq-7020",
    fontsize=16,
    fontweight="bold",
    y=0.97,
)

# ---------------------------------------------------------------------------
# Panel 1 (top-left): Absolute resource counts (log scale)
# ---------------------------------------------------------------------------
ax1 = axes[0, 0]
x = np.arange(len(resources))
w = 0.32

bars_a = ax1.bar(x - w / 2, a2h_counts, w, label="A2H_Coder (HLS)", color=BLUE, zorder=3)
bars_h = ax1.bar(x + w / 2, hdl_counts, w, label="HDL Coder", color=ORANGE, zorder=3)

ax1.set_yscale("log")
ax1.set_ylabel("Count (log scale)")
ax1.set_title("Resource Utilization - Absolute")
ax1.set_xticks(x)
ax1.set_xticklabels(resources)
ax1.legend(loc="upper right", framealpha=0.9)
ax1.yaxis.set_major_formatter(ticker.FuncFormatter(lambda v, _: f"{v:,.0f}"))
ax1.grid(axis="y", alpha=0.3, zorder=0)

# Value labels on bars
for bar_set in [bars_a, bars_h]:
    for bar in bar_set:
        h = bar.get_height()
        label = f"{h:,.0f}" if h == int(h) else f"{h:,.1f}"
        ax1.text(
            bar.get_x() + bar.get_width() / 2,
            h * 1.15,
            label,
            ha="center",
            va="bottom",
            fontsize=8,
            fontweight="bold",
        )

# ---------------------------------------------------------------------------
# Panel 2 (top-right): Utilization % of Zynq-7020
# ---------------------------------------------------------------------------
ax2 = axes[0, 1]
bars_a2 = ax2.bar(x - w / 2, a2h_pct, w, label="A2H_Coder (HLS)", color=BLUE, zorder=3)
bars_h2 = ax2.bar(x + w / 2, hdl_pct, w, label="HDL Coder", color=ORANGE, zorder=3)

ax2.axhline(100, color="red", linestyle="--", linewidth=1, alpha=0.7, label="100% capacity")
ax2.set_ylabel("Utilization (%)")
ax2.set_title("Utilization % of Zynq-7020")
ax2.set_xticks(x)
ax2.set_xticklabels(resources)
ax2.set_ylim(0, 115)
ax2.legend(loc="upper center", framealpha=0.9, fontsize=9)
ax2.grid(axis="y", alpha=0.3, zorder=0)

# Value labels
for bar_set in [bars_a2, bars_h2]:
    for bar in bar_set:
        h = bar.get_height()
        ax2.text(
            bar.get_x() + bar.get_width() / 2,
            h + 1.5,
            f"{h:.1f}%",
            ha="center",
            va="bottom",
            fontsize=8,
            fontweight="bold",
        )

# ---------------------------------------------------------------------------
# Panel 3 (bottom-left): CFO Estimation Accuracy
# ---------------------------------------------------------------------------
ax3 = axes[1, 0]
x3 = np.arange(len(cfo_labels))
colors3 = [GREY, BLUE, ORANGE]

bars3 = ax3.bar(x3, cfo_values, 0.5, color=colors3, zorder=3)
ax3.set_ylabel("Estimated CFO (Hz)")
ax3.set_title("CFO Estimation Accuracy")
ax3.set_xticks(x3)
ax3.set_xticklabels(cfo_labels)
ax3.set_ylim(9500, 10200)
ax3.grid(axis="y", alpha=0.3, zorder=0)

# Value and error labels
for i, (bar, val, err) in enumerate(zip(bars3, cfo_values, cfo_errors)):
    ax3.text(
        bar.get_x() + bar.get_width() / 2,
        val + 30,
        f"{val:,} Hz",
        ha="center",
        va="bottom",
        fontsize=10,
        fontweight="bold",
    )
    ax3.text(
        bar.get_x() + bar.get_width() / 2,
        val + 80,
        f"({err})",
        ha="center",
        va="bottom",
        fontsize=9,
        color="#555555",
    )

# Reference line at true value
ax3.axhline(10000, color=GREY, linestyle=":", linewidth=1, alpha=0.7)

# ---------------------------------------------------------------------------
# Panel 4 (bottom-right): Resource Efficiency Ratios (HDL/HLS)
# ---------------------------------------------------------------------------
ax4 = axes[1, 1]
y4 = np.arange(len(ratio_labels))
colors4 = [GREEN if r > 1.0 else RED for r in ratios]

bars4 = ax4.barh(y4, ratios, 0.5, color=colors4, zorder=3)
ax4.axvline(1.0, color="black", linestyle="-", linewidth=1.2, alpha=0.6)
ax4.set_xlabel("Ratio (HDL Coder / A2H_Coder)")
ax4.set_title("Resource Efficiency (HDL/HLS ratio)")
ax4.set_yticks(y4)
ax4.set_yticklabels(ratio_labels)
ax4.set_xlim(0, 6.5)
ax4.grid(axis="x", alpha=0.3, zorder=0)

# Value labels
for bar, ratio in zip(bars4, ratios):
    ax4.text(
        ratio + 0.1,
        bar.get_y() + bar.get_height() / 2,
        f"{ratio:.2f}x",
        ha="left",
        va="center",
        fontsize=10,
        fontweight="bold",
    )

# Legend annotation
ax4.text(
    5.5, -0.8,
    "Green = HLS more efficient\nRed = HDL Coder more efficient",
    fontsize=9,
    ha="center",
    style="italic",
    color="#555555",
)

# ---------------------------------------------------------------------------
# Save
# ---------------------------------------------------------------------------
fig.tight_layout(rect=[0, 0, 1, 0.94])

out_path = pathlib.Path(__file__).parent / "resource_comparison.png"
fig.savefig(out_path, dpi=150, bbox_inches="tight", facecolor="white")
print(f"Saved: {out_path}")
plt.close(fig)
