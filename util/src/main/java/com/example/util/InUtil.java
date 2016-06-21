package com.example.common;

import com.ibm.icu.util.TimeZone;

// Minimum to break compilation if ICU is absent.
class InUtil {
    static {
        TimeZone.getTimeZone("UTC");
    }
}
