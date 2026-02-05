// Module 0: Prefilter (bandpass FIR) - Phase 6 (fixed-point)
// @CSR: 1.0
// @FSM_REQUIRED: NO
// @FP-CORR: 51-tap FIR -> hls::FIR IP required (>16 taps)
// @FP-SYMCOEFF: Symmetric Type I (25 pairs + center = 26 unique)
#ifndef MODULE0_PREFILTER_HPP
#define MODULE0_PREFILTER_HPP

#include "../common_types_opt.hpp"
#include <hls_fir.h>

namespace m0 {

static const int FIR_NUM_TAPS_M0 = 51;

// FIR config for hls::FIR IP
struct fir_config : hls::ip_fir::params_t {
    enum {
        num_coeffs    = FIR_NUM_TAPS_M0,
        coeff_width   = 16,
        input_width   = 16,
        output_width  = 32,
        coeff_structure = hls::ip_fir::symmetric,
        output_rounding_mode = hls::ip_fir::truncate_lsbs,
        sample_period = 1,
        num_paths     = 1,
        num_channels  = 1
    };
};

// Filter coefficients (full array for shift-register implementation)
extern const coeff_t filter_coeffs[FIR_NUM_TAPS_M0];

} // namespace m0

void module0_prefilter(
    hls::stream<complex_t>& data_in,
    hls::stream<complex_t>& data_out,
    hls::stream<index_t>& filteredLen_out,
    int num_samples
);

#endif // MODULE0_PREFILTER_HPP
