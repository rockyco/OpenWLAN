// Module 0: Pre-Filter (51-tap FIR) - Phase 6 (fixed-point)
// @CSR: 1.0
// @FSM_REQUIRED: NO
// @FP-CORR: 51-tap FIR -> hls::FIR IP required (>16 taps)
// @FP-SYMCOEFF: Symmetric Type I - pre-add for 49% DSP savings
//
// FIR lowpass applied to complex input. Real-only coefficients
// -> two independent real FIR operations (re and im channels).
// Symmetric pre-add: x[k]+x[N-1-k] before multiply reduces DSP by ~50%.
#include "module0_prefilter.hpp"

namespace m0 {

const coeff_t filter_coeffs[FIR_NUM_TAPS_M0] = {
    #include "filter_coeffs.inc"
};

} // namespace m0

void module0_prefilter(
    hls::stream<complex_t>& data_in,
    hls::stream<complex_t>& data_out,
    hls::stream<index_t>& filteredLen_out,
    int num_samples
) {
    // P14: interfaces auto-inferred

    const int filteredLen = num_samples - m0::FIR_NUM_TAPS_M0 + 1;
    const int L = m0::FIR_NUM_TAPS_M0; // 51

    // Shift registers for complex FIR
    data_t shift_re[m0::FIR_NUM_TAPS_M0];
    data_t shift_im[m0::FIR_NUM_TAPS_M0];
    #pragma HLS ARRAY_PARTITION variable=shift_re complete
    #pragma HLS ARRAY_PARTITION variable=shift_im complete

    INIT_SHIFT: for (int i = 0; i < L; i++) {
        shift_re[i] = 0;
        shift_im[i] = 0;
    }

    int out_count = 0;

    PREFILTER_LOOP: for (int n = 0; n < num_samples; n++) {
        #pragma HLS PIPELINE II=1

        complex_t sample = data_in.read();

        // Shift register update
        SHIFT: for (int k = L - 1; k > 0; k--) {
            shift_re[k] = shift_re[k-1];
            shift_im[k] = shift_im[k-1];
        }
        shift_re[0] = sample.re;
        shift_im[0] = sample.im;

        // FP-SYMCOEFF: Symmetric pre-add FIR
        // h[k] == h[N-1-k], so (x[k]+x[N-1-k])*h[k] saves one multiply per pair
        accum_t acc_re = 0;
        accum_t acc_im = 0;

        // 25 symmetric pairs
        SYM_MAC: for (int k = 0; k < L / 2; k++) {
            data_t sum_re = shift_re[k] + shift_re[L - 1 - k];
            data_t sum_im = shift_im[k] + shift_im[L - 1 - k];
            acc_re += m0::filter_coeffs[k] * sum_re;
            acc_im += m0::filter_coeffs[k] * sum_im;
        }
        // Center tap (k=25 for 51-tap)
        acc_re += m0::filter_coeffs[L / 2] * shift_re[L / 2];
        acc_im += m0::filter_coeffs[L / 2] * shift_im[L / 2];

        if (out_count < filteredLen) {
            complex_t out_sample;
            out_sample.re = (data_t)acc_re;
            out_sample.im = (data_t)acc_im;
            data_out.write(out_sample);
            out_count++;
        }
    }

    filteredLen_out.write((index_t)filteredLen);
}
