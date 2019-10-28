Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B164E6AA3
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 03:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729161AbfJ1CDr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 22:03:47 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34085 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727598AbfJ1CDr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Oct 2019 22:03:47 -0400
Received: by mail-wm1-f65.google.com with SMTP id v3so8466353wmh.1
        for <stable@vger.kernel.org>; Sun, 27 Oct 2019 19:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=p4BAZLBwpLlDNpmi0Znk8sPXgtDqanX7J7/7BAOFPXg=;
        b=2JcxGy3I6+onrR96ER8fZ+5wDE/qjYUr/ptyBtX9oUvrAYHovJM/HHI5mMuTcpst9K
         FYkEAdmRQ8T0jF1Xn+CL8JKR/miosBI8A4YYzU/BOap3sO4if9nTJ+GaMgDn5e7Urb82
         IorMxH/UrCw+1vUVk/7GO1qnR0KzKZlAPMRlaibnDOIaq9ULVvp81x1Fh+XY0D+TCmpr
         3iPmbWpJIHtZGBBnkGkhnVzzB6VKOuqRvO1ecSmfN+NKjcGbdUYpzebiivVljDtr/1SI
         1LGLrjnsh8GqUVsXTgaBOaSHJ6ALTFN2+jYRADKoERCNn/O0OqEIELIgiTNG1tKEyzFY
         Kclw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=p4BAZLBwpLlDNpmi0Znk8sPXgtDqanX7J7/7BAOFPXg=;
        b=UfOB4PMIq2NO5rjDZt4ZLmato++RxF/vOMY2fEQtoIoVCqOse8CafzRCW83F9gDgXw
         mXHSfrO9YIkj3UVLLVJyHuv6oJgYdfq/Db1fTcYGXbK2CJnOhZ6I0t3F0z83CO+8rpV+
         Kdi/2OpSbaqY7gUxDicLzSyA2uazt2xUdUm8ZjjMVCKUoftJ48e21x7m9w58BThZ4zxJ
         +r7HGQojxW0bsPPZlXw+BIXvEoLaFy5/uYnluiZGtr3UvfkrQu4+OzNE9UCnefm0zZc2
         lkEHGtY3hCzTtniaMrTvspPI9bkZ5gV27G2JTPizmMTDZFhFyADsvD2mrSWIMc5Ie6QH
         82Mg==
X-Gm-Message-State: APjAAAU/84G0yRhAC7T1fzQHqoaDRcHp3KppfST+iCZqkPQEOi/H+hcU
        eJl5uQ6dX0WV8SznF+eGYZ/EdlGiFa8=
X-Google-Smtp-Source: APXvYqyXLsF4cSx75o1gQrgz3ro9ghZPRb6v1ZOjj/mXwL+GgxFdqHvZHUSrtkwCp4R1rjuUiydPfw==
X-Received: by 2002:a1c:49d5:: with SMTP id w204mr14052672wma.111.1572228217688;
        Sun, 27 Oct 2019 19:03:37 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v11sm9149807wrw.97.2019.10.27.19.03.37
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Oct 2019 19:03:37 -0700 (PDT)
Message-ID: <5db64c79.1c69fb81.5ae66.e509@mx.google.com>
Date:   Sun, 27 Oct 2019 19:03:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.197-50-g55a89a78f76e
X-Kernelci-Report-Type: build
Subject: stable-rc/linux-4.9.y build: 197 builds: 62 failed, 135 passed,
 122 errors, 61 warnings (v4.9.197-50-g55a89a78f76e)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y build: 197 builds: 62 failed, 135 passed, 122 errors,=
 61 warnings (v4.9.197-50-g55a89a78f76e)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.197-50-g55a89a78f76e/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.197-50-g55a89a78f76e
Git Commit: 55a89a78f76e92ca9b2045c8dac71ff64e0eb03d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 6 unique architectures

Build Failures Detected:

mips:
    32r2el_defconfig: (gcc-8) FAIL
    allnoconfig: (gcc-8) FAIL
    ar7_defconfig: (gcc-8) FAIL
    ath25_defconfig: (gcc-8) FAIL
    ath79_defconfig: (gcc-8) FAIL
    bcm47xx_defconfig: (gcc-8) FAIL
    bcm63xx_defconfig: (gcc-8) FAIL
    bigsur_defconfig: (gcc-8) FAIL
    bmips_be_defconfig: (gcc-8) FAIL
    bmips_stb_defconfig: (gcc-8) FAIL
    capcella_defconfig: (gcc-8) FAIL
    cavium_octeon_defconfig: (gcc-8) FAIL
    ci20_defconfig: (gcc-8) FAIL
    cobalt_defconfig: (gcc-8) FAIL
    db1xxx_defconfig: (gcc-8) FAIL
    decstation_defconfig: (gcc-8) FAIL
    e55_defconfig: (gcc-8) FAIL
    fuloong2e_defconfig: (gcc-8) FAIL
    gpr_defconfig: (gcc-8) FAIL
    ip22_defconfig: (gcc-8) FAIL
    ip27_defconfig: (gcc-8) FAIL
    ip28_defconfig: (gcc-8) FAIL
    ip32_defconfig: (gcc-8) FAIL
    jazz_defconfig: (gcc-8) FAIL
    jmr3927_defconfig: (gcc-8) FAIL
    lasat_defconfig: (gcc-8) FAIL
    lemote2f_defconfig: (gcc-8) FAIL
    loongson1b_defconfig: (gcc-8) FAIL
    loongson1c_defconfig: (gcc-8) FAIL
    loongson3_defconfig: (gcc-8) FAIL
    malta_defconfig: (gcc-8) FAIL
    malta_kvm_defconfig: (gcc-8) FAIL
    malta_kvm_guest_defconfig: (gcc-8) FAIL
    malta_qemu_32r6_defconfig: (gcc-8) FAIL
    maltaaprp_defconfig: (gcc-8) FAIL
    maltasmvp_defconfig: (gcc-8) FAIL
    maltasmvp_eva_defconfig: (gcc-8) FAIL
    maltaup_defconfig: (gcc-8) FAIL
    maltaup_xpa_defconfig: (gcc-8) FAIL
    markeins_defconfig: (gcc-8) FAIL
    mips_paravirt_defconfig: (gcc-8) FAIL
    mpc30x_defconfig: (gcc-8) FAIL
    msp71xx_defconfig: (gcc-8) FAIL
    mtx1_defconfig: (gcc-8) FAIL
    nlm_xlp_defconfig: (gcc-8) FAIL
    nlm_xlr_defconfig: (gcc-8) FAIL
    pic32mzda_defconfig: (gcc-8) FAIL
    pistachio_defconfig: (gcc-8) FAIL
    pnx8335_stb225_defconfig: (gcc-8) FAIL
    qi_lb60_defconfig: (gcc-8) FAIL
    rb532_defconfig: (gcc-8) FAIL
    rbtx49xx_defconfig: (gcc-8) FAIL
    rm200_defconfig: (gcc-8) FAIL
    rt305x_defconfig: (gcc-8) FAIL
    sb1250_swarm_defconfig: (gcc-8) FAIL
    tb0219_defconfig: (gcc-8) FAIL
    tb0226_defconfig: (gcc-8) FAIL
    tb0287_defconfig: (gcc-8) FAIL
    tinyconfig: (gcc-8) FAIL
    workpad_defconfig: (gcc-8) FAIL
    xilfpga_defconfig: (gcc-8) FAIL
    xway_defconfig: (gcc-8) FAIL

Errors and Warnings Detected:

arc:

arm64:

arm:

i386:

mips:
    allnoconfig (gcc-8): 2 errors, 1 warning
    ar7_defconfig (gcc-8): 2 errors, 1 warning
    ath25_defconfig (gcc-8): 2 errors, 1 warning
    ath79_defconfig (gcc-8): 2 errors, 1 warning
    bcm47xx_defconfig (gcc-8): 2 errors, 1 warning
    bcm63xx_defconfig (gcc-8): 2 errors, 1 warning
    bigsur_defconfig (gcc-8): 2 errors, 1 warning
    bmips_be_defconfig (gcc-8): 2 errors, 1 warning
    bmips_stb_defconfig (gcc-8): 2 errors, 1 warning
    capcella_defconfig (gcc-8): 2 errors, 1 warning
    cavium_octeon_defconfig (gcc-8): 2 errors, 1 warning
    ci20_defconfig (gcc-8): 2 errors, 1 warning
    cobalt_defconfig (gcc-8): 2 errors, 1 warning
    db1xxx_defconfig (gcc-8): 2 errors, 1 warning
    decstation_defconfig (gcc-8): 2 errors, 1 warning
    e55_defconfig (gcc-8): 2 errors, 1 warning
    fuloong2e_defconfig (gcc-8): 2 errors, 1 warning
    gpr_defconfig (gcc-8): 2 errors, 1 warning
    ip22_defconfig (gcc-8): 2 errors, 1 warning
    ip27_defconfig (gcc-8): 2 errors, 1 warning
    ip28_defconfig (gcc-8): 2 errors, 1 warning
    ip32_defconfig (gcc-8): 2 errors, 1 warning
    jazz_defconfig (gcc-8): 2 errors, 1 warning
    jmr3927_defconfig (gcc-8): 2 errors, 1 warning
    lasat_defconfig (gcc-8): 2 errors, 1 warning
    lemote2f_defconfig (gcc-8): 2 errors, 1 warning
    loongson1b_defconfig (gcc-8): 2 errors, 1 warning
    loongson1c_defconfig (gcc-8): 2 errors, 1 warning
    loongson3_defconfig (gcc-8): 2 errors, 1 warning
    malta_defconfig (gcc-8): 2 errors, 1 warning
    malta_kvm_defconfig (gcc-8): 2 errors, 1 warning
    malta_kvm_guest_defconfig (gcc-8): 2 errors, 1 warning
    malta_qemu_32r6_defconfig (gcc-8): 2 errors, 1 warning
    maltaaprp_defconfig (gcc-8): 2 errors, 1 warning
    maltasmvp_defconfig (gcc-8): 2 errors, 1 warning
    maltasmvp_eva_defconfig (gcc-8): 2 errors, 1 warning
    maltaup_defconfig (gcc-8): 2 errors, 1 warning
    maltaup_xpa_defconfig (gcc-8): 2 errors, 1 warning
    markeins_defconfig (gcc-8): 2 errors, 1 warning
    mips_paravirt_defconfig (gcc-8): 2 errors, 1 warning
    mpc30x_defconfig (gcc-8): 2 errors, 1 warning
    msp71xx_defconfig (gcc-8): 2 errors, 1 warning
    mtx1_defconfig (gcc-8): 2 errors, 1 warning
    nlm_xlp_defconfig (gcc-8): 2 errors, 1 warning
    nlm_xlr_defconfig (gcc-8): 2 errors, 1 warning
    pic32mzda_defconfig (gcc-8): 2 errors, 1 warning
    pistachio_defconfig (gcc-8): 2 errors, 1 warning
    pnx8335_stb225_defconfig (gcc-8): 2 errors, 1 warning
    qi_lb60_defconfig (gcc-8): 2 errors, 1 warning
    rb532_defconfig (gcc-8): 2 errors, 1 warning
    rbtx49xx_defconfig (gcc-8): 2 errors, 1 warning
    rm200_defconfig (gcc-8): 2 errors, 1 warning
    rt305x_defconfig (gcc-8): 2 errors, 1 warning
    sb1250_swarm_defconfig (gcc-8): 2 errors, 1 warning
    tb0219_defconfig (gcc-8): 2 errors, 1 warning
    tb0226_defconfig (gcc-8): 2 errors, 1 warning
    tb0287_defconfig (gcc-8): 2 errors, 1 warning
    tinyconfig (gcc-8): 2 errors, 1 warning
    workpad_defconfig (gcc-8): 2 errors, 1 warning
    xilfpga_defconfig (gcc-8): 2 errors, 1 warning
    xway_defconfig (gcc-8): 2 errors, 1 warning

x86_64:

Errors summary:

    61   arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' =
undeclared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?
    61   arch/mips/include/asm/cpu-features.h:349:31: error: implicit decla=
ration of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-func=
tion-declaration]

Warnings summary:

    61   cc1: all warnings being treated as errors

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
32r2el_defconfig (mips, gcc-8) =E2=80=94 FAIL, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
acs5k_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
acs5k_tiny_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
allnoconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
allnoconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section mi=
smatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
allnoconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
am200epdkit_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
ar7_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section =
mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
aspeed_g4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
aspeed_g5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
assabet_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
at91_dt_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
ath25_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
ath79_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
axm55xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
axs103_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
axs103_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
badge4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
bcm2835_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
bcm47xx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
bcm63xx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
bigsur_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
bmips_stb_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 se=
ction mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, =
0 section mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
ci20_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
clps711x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
cm_x2xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
cm_x300_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
cns3420vb_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
cobalt_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
colibri_pxa270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
collie_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
corgi_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
davinci_all_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 s=
ection mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
dove_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
e55_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section =
mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
ebsa110_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
efm32_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
em_x270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
ep93xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
fuloong2e_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 se=
ction mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
gpr_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section =
mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
h3600_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
h5000_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
hackkit_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
hisi_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
i386_defconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
imote2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
imx_v4_v5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
imx_v6_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
integrator_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
iop13xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
iop32x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
iop33x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
ip22_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
ip27_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
ip28_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
ip32_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
ixp4xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
jmr3927_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
jornada720_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
keystone_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
ks8695_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
lart_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
lasat_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
loongson1b_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 s=
ection mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
loongson1c_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 s=
ection mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
loongson3_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 se=
ction mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
lpc18xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
lpc32xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
lpd270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
lubbock_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
magician_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
mainstone_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
malta_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 se=
ction mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
malta_kvm_guest_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning=
, 0 section mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
malta_qemu_32r6_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning=
, 0 section mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
maltaaprp_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 se=
ction mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
maltasmvp_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 se=
ction mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, =
0 section mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
maltaup_xpa_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 =
section mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
markeins_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
mips_paravirt_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, =
0 section mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
mmp2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
moxart_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
mpc30x_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
mps2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
msp71xx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
mtx1_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
multi_v4t_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
multi_v5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
mv78xx0_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
mvebu_v5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
mvebu_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
mxs_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
neponset_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
netwinder_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
netx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
nhk8815_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
nsim_hs_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
nsim_hs_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
nsimosci_hs_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
nsimosci_hs_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
nuc910_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
nuc950_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
nuc960_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
omap1_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
orion5x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
palmz72_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
pcm027_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
pic32mzda_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 se=
ction mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
pistachio_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 se=
ction mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
pleb_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
pnx8335_stb225_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning,=
 0 section mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
prima2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
pxa168_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
pxa255-idp_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
pxa3xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
pxa910_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
pxa_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
qcom_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
qi_lb60_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
raumfeld_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
rb532_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
rbtx49xx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
realview_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
rpc_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
s3c2410_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
s3c6400_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
s5pv210_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
sama5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
sb1250_swarm_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0=
 section mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
shannon_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
shmobile_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
simpad_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
socfpga_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
spear13xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
spear3xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
spear6xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
spitz_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
stm32_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
sunxi_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
tb0219_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
tb0226_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
tb0287_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
tct_hammer_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
tegra_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
tinyconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
tinyconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
tinyconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
tinyconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section mis=
matches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
tinyconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
trizeps4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
u300_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
u8500_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
vdk_hs38_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
vdk_hs38_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
versatile_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
vexpress_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
vf610m4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
viper_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
vt8500_v6_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
workpad_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
x86_64_defconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
xcep_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
xilfpga_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
xway_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
zebu_hs_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
zebu_hs_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
zeus_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
zx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---
For more info write to <info@kernelci.org>
