Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCEA61EC093
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 19:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbgFBRAQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 13:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725969AbgFBRAQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jun 2020 13:00:16 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1E6DC05BD1E
        for <stable@vger.kernel.org>; Tue,  2 Jun 2020 10:00:14 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id d6so1754143pjs.3
        for <stable@vger.kernel.org>; Tue, 02 Jun 2020 10:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SB08qjE50591DJcTcyJN+X1Uh3BNhMjIh8vs6Kdt8rw=;
        b=AjzjQGT6AA5ld+TjUD1NPyA9nxAFJ46zJB1mt3wf/jJdREcGN4TrgQul5zaweSJPr7
         db8AqVmwUFoqVRfnhKTsO0oPgPqp/Gxt+PyJHDaGSthgxkLbU3I2ROlQ+/fj5Ff/DV7u
         0I3vNxplfDlGSqZTsN0/2iR8IS8C9HWmxBbfzYLe/G1xIGms2kRXEXGKkn0yRs5yW6aH
         VfHtt9ZXC00ltjcBfxtNozmS8rcNYenDCe005rV1bYc+hHqQv0MOZxpWeiSy2UQtsNiU
         xgb30JudhHlNvUpIOCTQVedkkDnSjmBWAhLItvXxe1vb4vYU2Jmde2Zbpxxgr29N25TW
         5PyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SB08qjE50591DJcTcyJN+X1Uh3BNhMjIh8vs6Kdt8rw=;
        b=fZcwGRi18Pt89ZNGFJlKsIfznun579tSCsmJX3483/qZkGPGq99b4O3mA2+pATMY/Y
         KEH22GBc2KqI2dgUaGyyUUO22jPSRKI8oO5HOmkHLIYBFobDsww8uop5TPcbZtSQFt2+
         yY61tkpKuYxLT56CI8+N+gvIw8CctGyuWYSsXs8Smhmi3AfZuTXTqWgxwRreCw9IYt5p
         rQ19ard1fvWlcH4Pua/gcj5bNeCkPo3lM9cA1iHU5tUCqPX7KkMrWLD83LO6nUadBXya
         Fxy3detmijGjeGtjdL2usdhLUsPDi12iRDFdyHDvmIkql8SKCshcg+6leoCH3QPNaiLO
         28DA==
X-Gm-Message-State: AOAM532sm+0pPovPEsiZtRWLs9ycQ0DP0zfNetJyUANI4qwlBY+/eif0
        1Vn7F2fzXaJUEuFUQzdzBwLeI7pzj4g=
X-Google-Smtp-Source: ABdhPJyPVv4b+BTXZ3TIvJIdjBrSsot1Huk4ue87jzP0imJWY9eo28wAnC+fhRj7tYBibKWza9USrQ==
X-Received: by 2002:a17:90b:796:: with SMTP id l22mr111699pjz.45.1591117212732;
        Tue, 02 Jun 2020 10:00:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 128sm2745156pfd.114.2020.06.02.10.00.10
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 10:00:11 -0700 (PDT)
Message-ID: <5ed6859b.1c69fb81.894e8.a016@mx.google.com>
Date:   Tue, 02 Jun 2020 10:00:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.225-60-g6915714f12d0
X-Kernelci-Report-Type: build
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y build: 168 builds: 92 failed, 76 passed,
 146 errors (v4.9.225-60-g6915714f12d0)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y build: 168 builds: 92 failed, 76 passed, 146 errors (=
v4.9.225-60-g6915714f12d0)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.225-60-g6915714f12d0/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.225-60-g6915714f12d0
Git Commit: 6915714f12d07947cc3e82cf34852597ff239b17
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 6 unique architectures

Build Failures Detected:

arm:
    acs5k_defconfig: (gcc-8) FAIL
    acs5k_tiny_defconfig: (gcc-8) FAIL
    am200epdkit_defconfig: (gcc-8) FAIL
    aspeed_g4_defconfig: (gcc-8) FAIL
    assabet_defconfig: (gcc-8) FAIL
    at91_dt_defconfig: (gcc-8) FAIL
    axm55xx_defconfig: (gcc-8) FAIL
    badge4_defconfig: (gcc-8) FAIL
    cerfcube_defconfig: (gcc-8) FAIL
    clps711x_defconfig: (gcc-8) FAIL
    cm_x2xx_defconfig: (gcc-8) FAIL
    cm_x300_defconfig: (gcc-8) FAIL
    cns3420vb_defconfig: (gcc-8) FAIL
    colibri_pxa270_defconfig: (gcc-8) FAIL
    colibri_pxa300_defconfig: (gcc-8) FAIL
    corgi_defconfig: (gcc-8) FAIL
    ebsa110_defconfig: (gcc-8) FAIL
    em_x270_defconfig: (gcc-8) FAIL
    ep93xx_defconfig: (gcc-8) FAIL
    eseries_pxa_defconfig: (gcc-8) FAIL
    exynos_defconfig: (gcc-8) FAIL
    ezx_defconfig: (gcc-8) FAIL
    footbridge_defconfig: (gcc-8) FAIL
    h3600_defconfig: (gcc-8) FAIL
    h5000_defconfig: (gcc-8) FAIL
    hackkit_defconfig: (gcc-8) FAIL
    hisi_defconfig: (gcc-8) FAIL
    imote2_defconfig: (gcc-8) FAIL
    imx_v4_v5_defconfig: (gcc-8) FAIL
    imx_v6_v7_defconfig: (gcc-8) FAIL
    integrator_defconfig: (gcc-8) FAIL
    iop32x_defconfig: (gcc-8) FAIL
    iop33x_defconfig: (gcc-8) FAIL
    jornada720_defconfig: (gcc-8) FAIL
    keystone_defconfig: (gcc-8) FAIL
    lpc32xx_defconfig: (gcc-8) FAIL
    lpd270_defconfig: (gcc-8) FAIL
    lubbock_defconfig: (gcc-8) FAIL
    magician_defconfig: (gcc-8) FAIL
    mainstone_defconfig: (gcc-8) FAIL
    mini2440_defconfig: (gcc-8) FAIL
    mmp2_defconfig: (gcc-8) FAIL
    moxart_defconfig: (gcc-8) FAIL
    multi_v4t_defconfig: (gcc-8) FAIL
    multi_v7_defconfig: (gcc-8) FAIL
    mv78xx0_defconfig: (gcc-8) FAIL
    mvebu_v5_defconfig: (gcc-8) FAIL
    mvebu_v7_defconfig: (gcc-8) FAIL
    mxs_defconfig: (gcc-8) FAIL
    neponset_defconfig: (gcc-8) FAIL
    netwinder_defconfig: (gcc-8) FAIL
    netx_defconfig: (gcc-8) FAIL
    nhk8815_defconfig: (gcc-8) FAIL
    nuc910_defconfig: (gcc-8) FAIL
    nuc950_defconfig: (gcc-8) FAIL
    nuc960_defconfig: (gcc-8) FAIL
    omap1_defconfig: (gcc-8) FAIL
    omap2plus_defconfig: (gcc-8) FAIL
    orion5x_defconfig: (gcc-8) FAIL
    palmz72_defconfig: (gcc-8) FAIL
    pleb_defconfig: (gcc-8) FAIL
    prima2_defconfig: (gcc-8) FAIL
    pxa168_defconfig: (gcc-8) FAIL
    pxa255-idp_defconfig: (gcc-8) FAIL
    pxa3xx_defconfig: (gcc-8) FAIL
    pxa_defconfig: (gcc-8) FAIL
    qcom_defconfig: (gcc-8) FAIL
    raumfeld_defconfig: (gcc-8) FAIL
    rpc_defconfig: (gcc-8) FAIL
    s3c6400_defconfig: (gcc-8) FAIL
    s5pv210_defconfig: (gcc-8) FAIL
    sama5_defconfig: (gcc-8) FAIL
    shannon_defconfig: (gcc-8) FAIL
    shmobile_defconfig: (gcc-8) FAIL
    simpad_defconfig: (gcc-8) FAIL
    socfpga_defconfig: (gcc-8) FAIL
    spear13xx_defconfig: (gcc-8) FAIL
    spear3xx_defconfig: (gcc-8) FAIL
    spear6xx_defconfig: (gcc-8) FAIL
    spitz_defconfig: (gcc-8) FAIL
    sunxi_defconfig: (gcc-8) FAIL
    tct_hammer_defconfig: (gcc-8) FAIL
    tegra_defconfig: (gcc-8) FAIL
    trizeps4_defconfig: (gcc-8) FAIL
    u300_defconfig: (gcc-8) FAIL
    u8500_defconfig: (gcc-8) FAIL
    vexpress_defconfig: (gcc-8) FAIL
    viper_defconfig: (gcc-8) FAIL
    vt8500_v6_v7_defconfig: (gcc-8) FAIL
    xcep_defconfig: (gcc-8) FAIL
    zeus_defconfig: (gcc-8) FAIL
    zx_defconfig: (gcc-8) FAIL

Errors Detected:

arc:

arm64:

arm:
    acs5k_defconfig (gcc-8): 1 error
    acs5k_tiny_defconfig (gcc-8): 1 error
    am200epdkit_defconfig (gcc-8): 1 error
    aspeed_g4_defconfig (gcc-8): 1 error
    assabet_defconfig (gcc-8): 1 error
    at91_dt_defconfig (gcc-8): 9 errors
    axm55xx_defconfig (gcc-8): 2 errors
    badge4_defconfig (gcc-8): 1 error
    cerfcube_defconfig (gcc-8): 1 error
    clps711x_defconfig (gcc-8): 1 error
    cm_x2xx_defconfig (gcc-8): 1 error
    cm_x300_defconfig (gcc-8): 1 error
    cns3420vb_defconfig (gcc-8): 1 error
    colibri_pxa270_defconfig (gcc-8): 1 error
    colibri_pxa300_defconfig (gcc-8): 1 error
    corgi_defconfig (gcc-8): 1 error
    ebsa110_defconfig (gcc-8): 1 error
    em_x270_defconfig (gcc-8): 1 error
    ep93xx_defconfig (gcc-8): 1 error
    eseries_pxa_defconfig (gcc-8): 1 error
    exynos_defconfig (gcc-8): 2 errors
    ezx_defconfig (gcc-8): 1 error
    footbridge_defconfig (gcc-8): 1 error
    h3600_defconfig (gcc-8): 1 error
    h5000_defconfig (gcc-8): 1 error
    hackkit_defconfig (gcc-8): 1 error
    hisi_defconfig (gcc-8): 2 errors
    imote2_defconfig (gcc-8): 1 error
    imx_v4_v5_defconfig (gcc-8): 1 error
    imx_v6_v7_defconfig (gcc-8): 2 errors
    integrator_defconfig (gcc-8): 1 error
    iop32x_defconfig (gcc-8): 1 error
    iop33x_defconfig (gcc-8): 1 error
    jornada720_defconfig (gcc-8): 1 error
    keystone_defconfig (gcc-8): 2 errors
    lpc32xx_defconfig (gcc-8): 1 error
    lpd270_defconfig (gcc-8): 1 error
    lubbock_defconfig (gcc-8): 1 error
    magician_defconfig (gcc-8): 1 error
    mainstone_defconfig (gcc-8): 1 error
    mini2440_defconfig (gcc-8): 1 error
    mmp2_defconfig (gcc-8): 3 errors
    moxart_defconfig (gcc-8): 1 error
    multi_v4t_defconfig (gcc-8): 1 error
    multi_v7_defconfig (gcc-8): 2 errors
    mv78xx0_defconfig (gcc-8): 1 error
    mvebu_v5_defconfig (gcc-8): 1 error
    mvebu_v7_defconfig (gcc-8): 2 errors
    mxs_defconfig (gcc-8): 1 error
    neponset_defconfig (gcc-8): 1 error
    netwinder_defconfig (gcc-8): 1 error
    netx_defconfig (gcc-8): 1 error
    nhk8815_defconfig (gcc-8): 1 error
    nuc910_defconfig (gcc-8): 1 error
    nuc950_defconfig (gcc-8): 1 error
    nuc960_defconfig (gcc-8): 9 errors
    omap1_defconfig (gcc-8): 1 error
    omap2plus_defconfig (gcc-8): 2 errors
    orion5x_defconfig (gcc-8): 1 error
    palmz72_defconfig (gcc-8): 1 error
    pleb_defconfig (gcc-8): 1 error
    prima2_defconfig (gcc-8): 6 errors
    pxa168_defconfig (gcc-8): 1 error
    pxa255-idp_defconfig (gcc-8): 1 error
    pxa3xx_defconfig (gcc-8): 1 error
    pxa_defconfig (gcc-8): 1 error
    qcom_defconfig (gcc-8): 2 errors
    raumfeld_defconfig (gcc-8): 1 error
    rpc_defconfig (gcc-8): 1 error
    s3c6400_defconfig (gcc-8): 1 error
    s5pv210_defconfig (gcc-8): 3 errors
    sama5_defconfig (gcc-8): 3 errors
    shannon_defconfig (gcc-8): 1 error
    shmobile_defconfig (gcc-8): 2 errors
    simpad_defconfig (gcc-8): 1 error
    socfpga_defconfig (gcc-8): 2 errors
    spear13xx_defconfig (gcc-8): 2 errors
    spear3xx_defconfig (gcc-8): 1 error
    spear6xx_defconfig (gcc-8): 9 errors
    spitz_defconfig (gcc-8): 1 error
    sunxi_defconfig (gcc-8): 2 errors
    tct_hammer_defconfig (gcc-8): 1 error
    tegra_defconfig (gcc-8): 2 errors
    trizeps4_defconfig (gcc-8): 1 error
    u300_defconfig (gcc-8): 1 error
    u8500_defconfig (gcc-8): 2 errors
    vexpress_defconfig (gcc-8): 2 errors
    viper_defconfig (gcc-8): 1 error
    vt8500_v6_v7_defconfig (gcc-8): 3 errors
    xcep_defconfig (gcc-8): 1 error
    zeus_defconfig (gcc-8): 1 error
    zx_defconfig (gcc-8): 2 errors

i386:

mips:

x86_64:

Errors summary:

    70   arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip=
]'
    18   arch/arm/vfp/vfphw.S:233: Error: bad instruction `stcleq p11,cr0,[=
r0],#32*4'
    18   arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldcleq p11,cr0,[=
r10],#32*4'
    6    arch/arm/lib/clear_user.S:44: Error: bad instruction `strbtne r2,[=
r0],#1'
    6    arch/arm/lib/clear_user.S:39: Error: bad instruction `strtpl r2,[r=
0],#4'
    3    arch/arm/vfp/vfphw.S:233: Error: bad instruction `stclne p11,cr0,[=
r0],#32*4'
    3    arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldclne p11,cr0,[=
r10],#32*4'
    3    arch/arm/vfp/vfphw.S:116: Error: bad instruction `stcleq p11,cr0,[=
r4],#32*4'
    3    arch/arm/lib/clear_user.S:42: Error: bad instruction `strtpl r2,[r=
0],#4'
    3    arch/arm/lib/clear_user.S:35: Error: bad instruction `strbtlt r2,[=
r0],#1'
    3    arch/arm/lib/clear_user.S:34: Error: bad instruction `strbtle r2,[=
r0],#1'
    3    arch/arm/lib/clear_user.S:33: Error: bad instruction `strbtal r2,[=
r0],#1'
    2    arch/arm/lib/clear_user.S:44: Error: bad instruction `strbne r2,[r=
0],#1'
    1    arch/arm/vfp/vfphw.S:116: Error: bad instruction `stclne p11,cr0,[=
r4],#32*4'
    1    arch/arm/lib/clear_user.S:35: Error: bad instruction `strblt r2,[r=
0],#1'
    1    arch/arm/lib/clear_user.S:34: Error: bad instruction `strble r2,[r=
0],#1'
    1    arch/arm/lib/clear_user.S:33: Error: bad instruction `strbal r2,[r=
0],#1'
    1    ./../include/linux/kconfig.h:4:10: fatal error: generated/autoconf=
.h: No such file or directory


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
acs5k_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
acs5k_tiny_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
allnoconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
allnoconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
allnoconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
allnoconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
allnoconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
am200epdkit_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
aspeed_g4_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
assabet_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
at91_dt_defconfig (arm, gcc-8) =E2=80=94 FAIL, 9 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'
    arch/arm/lib/clear_user.S:33: Error: bad instruction `strbtal r2,[r0],#=
1'
    arch/arm/lib/clear_user.S:34: Error: bad instruction `strbtle r2,[r0],#=
1'
    arch/arm/lib/clear_user.S:35: Error: bad instruction `strbtlt r2,[r0],#=
1'
    arch/arm/lib/clear_user.S:39: Error: bad instruction `strtpl r2,[r0],#4'
    arch/arm/lib/clear_user.S:39: Error: bad instruction `strtpl r2,[r0],#4'
    arch/arm/lib/clear_user.S:42: Error: bad instruction `strtpl r2,[r0],#4'
    arch/arm/lib/clear_user.S:44: Error: bad instruction `strbtne r2,[r0],#=
1'
    arch/arm/lib/clear_user.S:44: Error: bad instruction `strbtne r2,[r0],#=
1'

---------------------------------------------------------------------------=
-----
ath79_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
axm55xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldcleq p11,cr0,[r10],=
#32*4'
    arch/arm/vfp/vfphw.S:233: Error: bad instruction `stcleq p11,cr0,[r0],#=
32*4'

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
badge4_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
bcm47xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
bcm63xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
bigsur_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
ci20_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
clps711x_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
cm_x2xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
cm_x300_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
cns3420vb_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
cobalt_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
colibri_pxa270_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, =
0 section mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, =
0 section mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
corgi_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
e55_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
ebsa110_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
efm32_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
em_x270_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
ep93xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldcleq p11,cr0,[r10],=
#32*4'
    arch/arm/vfp/vfphw.S:233: Error: bad instruction `stcleq p11,cr0,[r0],#=
32*4'

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section m=
ismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
fuloong2e_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
gpr_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
h3600_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
h5000_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
hackkit_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
hisi_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 section=
 mismatches

Errors:
    arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldcleq p11,cr0,[r10],=
#32*4'
    arch/arm/vfp/vfphw.S:233: Error: bad instruction `stcleq p11,cr0,[r0],#=
32*4'

---------------------------------------------------------------------------=
-----
i386_defconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
imote2_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
imx_v4_v5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
imx_v6_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldclne p11,cr0,[r10],=
#32*4'
    arch/arm/vfp/vfphw.S:233: Error: bad instruction `stclne p11,cr0,[r0],#=
32*4'

---------------------------------------------------------------------------=
-----
integrator_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
iop32x_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
iop33x_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
ip22_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
ip27_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
ip28_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
ip32_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
jmr3927_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
jornada720_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
keystone_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldcleq p11,cr0,[r10],=
#32*4'
    arch/arm/vfp/vfphw.S:233: Error: bad instruction `stcleq p11,cr0,[r0],#=
32*4'

---------------------------------------------------------------------------=
-----
lasat_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
loongson1b_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
loongson1c_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
loongson3_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
lpc18xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
lpc32xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
lpd270_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
lubbock_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
magician_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
mainstone_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
malta_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
malta_kvm_guest_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warning=
s, 0 section mismatches

---------------------------------------------------------------------------=
-----
malta_qemu_32r6_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warning=
s, 0 section mismatches

---------------------------------------------------------------------------=
-----
maltaaprp_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
maltasmvp_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
maltaup_xpa_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
markeins_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
mips_paravirt_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
mmp2_defconfig (arm, gcc-8) =E2=80=94 FAIL, 3 errors, 0 warnings, 0 section=
 mismatches

Errors:
    arch/arm/vfp/vfphw.S:116: Error: bad instruction `stcleq p11,cr0,[r4],#=
32*4'
    arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldcleq p11,cr0,[r10],=
#32*4'
    arch/arm/vfp/vfphw.S:233: Error: bad instruction `stcleq p11,cr0,[r0],#=
32*4'

---------------------------------------------------------------------------=
-----
moxart_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
mpc30x_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
msp71xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
mtx1_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
multi_v4t_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldcleq p11,cr0,[r10],=
#32*4'
    arch/arm/vfp/vfphw.S:233: Error: bad instruction `stcleq p11,cr0,[r0],#=
32*4'

---------------------------------------------------------------------------=
-----
mv78xx0_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
mvebu_v5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
mvebu_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldcleq p11,cr0,[r10],=
#32*4'
    arch/arm/vfp/vfphw.S:233: Error: bad instruction `stcleq p11,cr0,[r0],#=
32*4'

---------------------------------------------------------------------------=
-----
mxs_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section m=
ismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
neponset_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
netwinder_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
netx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section =
mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
nhk8815_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

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
nuc910_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
nuc950_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
nuc960_defconfig (arm, gcc-8) =E2=80=94 FAIL, 9 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'
    arch/arm/lib/clear_user.S:33: Error: bad instruction `strbtal r2,[r0],#=
1'
    arch/arm/lib/clear_user.S:34: Error: bad instruction `strbtle r2,[r0],#=
1'
    arch/arm/lib/clear_user.S:35: Error: bad instruction `strbtlt r2,[r0],#=
1'
    arch/arm/lib/clear_user.S:39: Error: bad instruction `strtpl r2,[r0],#4'
    arch/arm/lib/clear_user.S:39: Error: bad instruction `strtpl r2,[r0],#4'
    arch/arm/lib/clear_user.S:42: Error: bad instruction `strtpl r2,[r0],#4'
    arch/arm/lib/clear_user.S:44: Error: bad instruction `strbtne r2,[r0],#=
1'
    arch/arm/lib/clear_user.S:44: Error: bad instruction `strbtne r2,[r0],#=
1'

---------------------------------------------------------------------------=
-----
omap1_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldclne p11,cr0,[r10],=
#32*4'
    arch/arm/vfp/vfphw.S:233: Error: bad instruction `stclne p11,cr0,[r0],#=
32*4'

---------------------------------------------------------------------------=
-----
orion5x_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
palmz72_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
pic32mzda_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
pistachio_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
pleb_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section =
mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
pnx8335_stb225_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
prima2_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'
    arch/arm/lib/clear_user.S:33: Error: bad instruction `strbal r2,[r0],#1'
    arch/arm/lib/clear_user.S:34: Error: bad instruction `strble r2,[r0],#1'
    arch/arm/lib/clear_user.S:35: Error: bad instruction `strblt r2,[r0],#1'
    arch/arm/lib/clear_user.S:44: Error: bad instruction `strbne r2,[r0],#1'
    arch/arm/lib/clear_user.S:44: Error: bad instruction `strbne r2,[r0],#1'

---------------------------------------------------------------------------=
-----
pxa168_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
pxa255-idp_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
pxa3xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
pxa_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section m=
ismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
qcom_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 section=
 mismatches

Errors:
    arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldcleq p11,cr0,[r10],=
#32*4'
    arch/arm/vfp/vfphw.S:233: Error: bad instruction `stcleq p11,cr0,[r0],#=
32*4'

---------------------------------------------------------------------------=
-----
qi_lb60_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
raumfeld_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
rb532_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
rbtx49xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
rpc_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section m=
ismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
s3c6400_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
s5pv210_defconfig (arm, gcc-8) =E2=80=94 FAIL, 3 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    arch/arm/vfp/vfphw.S:116: Error: bad instruction `stcleq p11,cr0,[r4],#=
32*4'
    arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldcleq p11,cr0,[r10],=
#32*4'
    arch/arm/vfp/vfphw.S:233: Error: bad instruction `stcleq p11,cr0,[r0],#=
32*4'

---------------------------------------------------------------------------=
-----
sama5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 3 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/arm/vfp/vfphw.S:116: Error: bad instruction `stcleq p11,cr0,[r4],#=
32*4'
    arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldcleq p11,cr0,[r10],=
#32*4'
    arch/arm/vfp/vfphw.S:233: Error: bad instruction `stcleq p11,cr0,[r0],#=
32*4'

---------------------------------------------------------------------------=
-----
sb1250_swarm_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, =
0 section mismatches

---------------------------------------------------------------------------=
-----
shannon_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    ./../include/linux/kconfig.h:4:10: fatal error: generated/autoconf.h: N=
o such file or directory

---------------------------------------------------------------------------=
-----
shmobile_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldcleq p11,cr0,[r10],=
#32*4'
    arch/arm/vfp/vfphw.S:233: Error: bad instruction `stcleq p11,cr0,[r0],#=
32*4'

---------------------------------------------------------------------------=
-----
simpad_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
socfpga_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldcleq p11,cr0,[r10],=
#32*4'
    arch/arm/vfp/vfphw.S:233: Error: bad instruction `stcleq p11,cr0,[r0],#=
32*4'

---------------------------------------------------------------------------=
-----
spear13xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldcleq p11,cr0,[r10],=
#32*4'
    arch/arm/vfp/vfphw.S:233: Error: bad instruction `stcleq p11,cr0,[r0],#=
32*4'

---------------------------------------------------------------------------=
-----
spear3xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
spear6xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 9 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'
    arch/arm/lib/clear_user.S:33: Error: bad instruction `strbtal r2,[r0],#=
1'
    arch/arm/lib/clear_user.S:34: Error: bad instruction `strbtle r2,[r0],#=
1'
    arch/arm/lib/clear_user.S:35: Error: bad instruction `strbtlt r2,[r0],#=
1'
    arch/arm/lib/clear_user.S:39: Error: bad instruction `strtpl r2,[r0],#4'
    arch/arm/lib/clear_user.S:39: Error: bad instruction `strtpl r2,[r0],#4'
    arch/arm/lib/clear_user.S:42: Error: bad instruction `strtpl r2,[r0],#4'
    arch/arm/lib/clear_user.S:44: Error: bad instruction `strbtne r2,[r0],#=
1'
    arch/arm/lib/clear_user.S:44: Error: bad instruction `strbtne r2,[r0],#=
1'

---------------------------------------------------------------------------=
-----
spitz_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
stm32_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
sunxi_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldcleq p11,cr0,[r10],=
#32*4'
    arch/arm/vfp/vfphw.S:233: Error: bad instruction `stcleq p11,cr0,[r0],#=
32*4'

---------------------------------------------------------------------------=
-----
tb0226_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
tb0287_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
tct_hammer_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
tegra_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldcleq p11,cr0,[r10],=
#32*4'
    arch/arm/vfp/vfphw.S:233: Error: bad instruction `stcleq p11,cr0,[r0],#=
32*4'

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
tinyconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
tinyconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
tinyconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
trizeps4_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
u300_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section =
mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
u8500_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldcleq p11,cr0,[r10],=
#32*4'
    arch/arm/vfp/vfphw.S:233: Error: bad instruction `stcleq p11,cr0,[r0],#=
32*4'

---------------------------------------------------------------------------=
-----
vdk_hs38_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
vexpress_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldcleq p11,cr0,[r10],=
#32*4'
    arch/arm/vfp/vfphw.S:233: Error: bad instruction `stcleq p11,cr0,[r0],#=
32*4'

---------------------------------------------------------------------------=
-----
vf610m4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
viper_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
vt8500_v6_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 3 errors, 0 warnings, 0=
 section mismatches

Errors:
    arch/arm/vfp/vfphw.S:116: Error: bad instruction `stclne p11,cr0,[r4],#=
32*4'
    arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldclne p11,cr0,[r10],=
#32*4'
    arch/arm/vfp/vfphw.S:233: Error: bad instruction `stclne p11,cr0,[r0],#=
32*4'

---------------------------------------------------------------------------=
-----
workpad_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
x86_64_defconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
xcep_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section =
mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
xilfpga_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
xway_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
zebu_hs_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
zeus_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section =
mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
zx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 section m=
ismatches

Errors:
    arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldcleq p11,cr0,[r10],=
#32*4'
    arch/arm/vfp/vfphw.S:233: Error: bad instruction `stcleq p11,cr0,[r0],#=
32*4'

---
For more info write to <info@kernelci.org>
