// Module 0: Pre-Filter Testbench - Phase 6 (fixed-point)
// TB001: Fill-Call-Read pattern
#include "module0_prefilter.hpp"
#include <cstdio>
#include <cmath>
#include <fstream>
#include <sstream>
#include <string>
#include <vector>

static std::string tv_path(const char* filename) {
    std::string base(__FILE__);
    size_t pos = base.rfind('/');
    if (pos != std::string::npos) base = base.substr(0, pos);
    else base = ".";
    return base + "/../test_vectors/" + filename;
}

struct tv_complex {
    double re, im;
};

static std::vector<tv_complex> load_complex_tv(const char* filename) {
    std::vector<tv_complex> data;
    std::string path = tv_path(filename);
    std::ifstream ifs(path);
    if (!ifs.is_open()) { printf("Cannot open %s\n", path.c_str()); return data; }
    std::string line;
    while (std::getline(ifs, line)) {
        if (line.empty() || line[0] == '%') continue;
        std::istringstream iss(line);
        double re, im;
        if (iss >> re >> im) { tv_complex c; c.re = re; c.im = im; data.push_back(c); }
    }
    return data;
}

int main() {
    std::vector<tv_complex> input_data = load_complex_tv("system_input.txt");
    std::vector<tv_complex> ref_output = load_complex_tv("m0_output.txt");

    if (input_data.empty() || ref_output.empty()) {
        printf("TEST FAILED: Cannot load test vectors\n");
        return 1;
    }

    int num_samples = (int)input_data.size();
    int expected_filtered_len = num_samples - NUM_TAPS + 1;
    printf("Module0 CSIM: num_samples=%d, expected_filtered=%d\n", num_samples, expected_filtered_len);

    // TB001: Fill
    hls::stream<complex_t> data_in("data_in");
    hls::stream<complex_t> data_out("data_out");
    hls::stream<index_t> filteredLen_out("filteredLen_out");

    for (int i = 0; i < num_samples; i++) {
        complex_t s;
        s.re = (data_t)input_data[i].re;
        s.im = (data_t)input_data[i].im;
        data_in.write(s);
    }

    // TB001: Call
    module0_prefilter(data_in, data_out, filteredLen_out, num_samples);

    // TB001: Read
    index_t filteredLen = filteredLen_out.read();
    printf("filteredLen: expected=%d, got=%d\n", expected_filtered_len, (int)filteredLen);

    double max_err = 0.0;
    int out_count = 0;
    while (!data_out.empty()) {
        complex_t sample = data_out.read();
        if (out_count < (int)ref_output.size()) {
            double err_re = (double)sample.re - ref_output[out_count].re;
            double err_im = (double)sample.im - ref_output[out_count].im;
            double err = std::sqrt(err_re * err_re + err_im * err_im);
            if (err > max_err) max_err = err;
        }
        out_count++;
    }

    printf("Output samples: %d (expected %d)\n", out_count, (int)ref_output.size());
    printf("Max mismatch: %.6e\n", max_err);

    // Phase 6 fixed-point: relaxed threshold for quantization error
    if (max_err < 5e-03 && out_count == (int)ref_output.size()) {
        printf("TEST PASSED\n"); return 0;
    } else {
        printf("TEST FAILED\n"); return 1;
    }
}
