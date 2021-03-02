Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA0C732AEAF
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234810AbhCCABX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:01:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444326AbhCBClD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 21:41:03 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E926C061756
        for <stable@vger.kernel.org>; Mon,  1 Mar 2021 18:28:53 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id l7so8628921pfd.3
        for <stable@vger.kernel.org>; Mon, 01 Mar 2021 18:28:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sDjfA+k8uhi0la97biT5j2e5VH+tRPhdzmQepzRdz+s=;
        b=A4Z+4Y+/nm3fijBwX/VngCeVaFigPG8/C1RKgDmi7CBdmESSBMDyY7soTrSUyljzVs
         DGanf9jxJM3aowmtg4RVDMkDiYbdwv2vaI0ANmO1JTAdteVbNoLwLsS3CKWNF3eNDXWH
         im+fdTFc6VxIrl2l15FQS/CwxYWDpKGX9QAifG/qqNisq4Umk1Igj2bUfk4xcXKBdqTN
         D1pcJCEVa53sYsQ2sIB33Tk2drLtXbNgW2HUyNkJ6WvapB3NVlJyhXhQIROzShTCbtvE
         S5O7LLzEDDPikFlFIY5Mmp1vcvVFMVo0aCbp4R1EOMyCpCTLF3UKWkPITKObLNOaZ//4
         mW/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sDjfA+k8uhi0la97biT5j2e5VH+tRPhdzmQepzRdz+s=;
        b=trFskwzn2twXGTVQyNsxMSUNzaYfEOOrEXGp50Uvw9Plniu0xRQwNJCoizNh35Rb+l
         UZY4h9/Qy+HEVgMzdJPXN6FtS4KLQQhiHco3a28MdvwZkwGdSYvJ2C/pmp7faG0Qwiuf
         BHj+3QGA8JIestLmg1HtngxFSL0P0dP1drjG7EqtbGhyiI7eRgOnU0lmP7ThK2LGrvS9
         HahzJLlrIN8cl2b7CZHvkAvUv8l9f6JsbDWdPjsJ6UJrvPRiO31UhTK9joslTTOp72S9
         aNZ4/rROqQ7yhy0kfLb0gDAnfJAGI9sejRMQ3gxd5IF7cp3gQBXXFUpipHECr95NYp8X
         wxHw==
X-Gm-Message-State: AOAM5327iLM/TAZDGZqrE18DSf9UGZwrRRdn4I6iA4fgCmSWycUugJgr
        WxQ5CF6vraJtgPuOiAMKutBLQRh5rCFc4Q==
X-Google-Smtp-Source: ABdhPJxWbdBTt9nftcnr6PsGuH5+LKh6rjuo09lVBPLzWnqqPanIjYD5isdqbDXPGZTMbV9wt/JafQ==
X-Received: by 2002:a05:6a00:8d0:b029:1b6:3581:4f41 with SMTP id s16-20020a056a0008d0b02901b635814f41mr17365408pfu.56.1614652129976;
        Mon, 01 Mar 2021 18:28:49 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b7sm17742445pgh.37.2021.03.01.18.28.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 18:28:49 -0800 (PST)
Message-ID: <603da2e1.1c69fb81.8a752.9df5@mx.google.com>
Date:   Mon, 01 Mar 2021 18:28:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.258-134-g2d3a1aa101bd1
X-Kernelci-Report-Type: build
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 build: 197 builds: 129 failed, 68 passed,
 138 errors, 142 warnings (v4.9.258-134-g2d3a1aa101bd1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 build: 197 builds: 129 failed, 68 passed, 138 errors, 1=
42 warnings (v4.9.258-134-g2d3a1aa101bd1)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F4.9=
/kernel/v4.9.258-134-g2d3a1aa101bd1/

Tree: stable-rc
Branch: queue/4.9
Git Describe: v4.9.258-134-g2d3a1aa101bd1
Git Commit: 2d3a1aa101bd17b0d366f3b58e5bd3d27683d8ca
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 6 unique architectures

Build Failures Detected:

arc:
    allnoconfig: (gcc-8) FAIL
    axs103_defconfig: (gcc-8) FAIL
    axs103_smp_defconfig: (gcc-8) FAIL
    nsim_hs_defconfig: (gcc-8) FAIL
    nsim_hs_smp_defconfig: (gcc-8) FAIL
    nsimosci_hs_defconfig: (gcc-8) FAIL
    nsimosci_hs_smp_defconfig: (gcc-8) FAIL
    tinyconfig: (gcc-8) FAIL
    vdk_hs38_defconfig: (gcc-8) FAIL
    vdk_hs38_smp_defconfig: (gcc-8) FAIL
    zebu_hs_defconfig: (gcc-8) FAIL
    zebu_hs_smp_defconfig: (gcc-8) FAIL

arm64:
    allnoconfig: (gcc-8) FAIL
    tinyconfig: (gcc-8) FAIL

arm:
    acs5k_defconfig: (gcc-8) FAIL
    acs5k_tiny_defconfig: (gcc-8) FAIL
    allnoconfig: (gcc-8) FAIL
    am200epdkit_defconfig: (gcc-8) FAIL
    aspeed_g4_defconfig: (gcc-8) FAIL
    aspeed_g5_defconfig: (gcc-8) FAIL
    assabet_defconfig: (gcc-8) FAIL
    axm55xx_defconfig: (gcc-8) FAIL
    badge4_defconfig: (gcc-8) FAIL
    cerfcube_defconfig: (gcc-8) FAIL
    clps711x_defconfig: (gcc-8) FAIL
    cm_x2xx_defconfig: (gcc-8) FAIL
    cm_x300_defconfig: (gcc-8) FAIL
    cns3420vb_defconfig: (gcc-8) FAIL
    colibri_pxa270_defconfig: (gcc-8) FAIL
    collie_defconfig: (gcc-8) FAIL
    dove_defconfig: (gcc-8) FAIL
    efm32_defconfig: (gcc-8) FAIL
    em_x270_defconfig: (gcc-8) FAIL
    eseries_pxa_defconfig: (gcc-8) FAIL
    footbridge_defconfig: (gcc-8) FAIL
    h3600_defconfig: (gcc-8) FAIL
    h5000_defconfig: (gcc-8) FAIL
    hackkit_defconfig: (gcc-8) FAIL
    imx_v4_v5_defconfig: (gcc-8) FAIL
    integrator_defconfig: (gcc-8) FAIL
    ixp4xx_defconfig: (gcc-8) FAIL
    jornada720_defconfig: (gcc-8) FAIL
    ks8695_defconfig: (gcc-8) FAIL
    lart_defconfig: (gcc-8) FAIL
    lpc18xx_defconfig: (gcc-8) FAIL
    lubbock_defconfig: (gcc-8) FAIL
    magician_defconfig: (gcc-8) FAIL
    mainstone_defconfig: (gcc-8) FAIL
    mini2440_defconfig: (gcc-8) FAIL
    mmp2_defconfig: (gcc-8) FAIL
    moxart_defconfig: (gcc-8) FAIL
    mps2_defconfig: (gcc-8) FAIL
    multi_v4t_defconfig: (gcc-8) FAIL
    mv78xx0_defconfig: (gcc-8) FAIL
    mvebu_v5_defconfig: (gcc-8) FAIL
    mxs_defconfig: (gcc-8) FAIL
    neponset_defconfig: (gcc-8) FAIL
    netwinder_defconfig: (gcc-8) FAIL
    nhk8815_defconfig: (gcc-8) FAIL
    nuc910_defconfig: (gcc-8) FAIL
    nuc950_defconfig: (gcc-8) FAIL
    nuc960_defconfig: (gcc-8) FAIL
    orion5x_defconfig: (gcc-8) FAIL
    palmz72_defconfig: (gcc-8) FAIL
    pcm027_defconfig: (gcc-8) FAIL
    pleb_defconfig: (gcc-8) FAIL
    prima2_defconfig: (gcc-8) FAIL
    pxa168_defconfig: (gcc-8) FAIL
    pxa255-idp_defconfig: (gcc-8) FAIL
    pxa3xx_defconfig: (gcc-8) FAIL
    pxa910_defconfig: (gcc-8) FAIL
    pxa_defconfig: (gcc-8) FAIL
    qcom_defconfig: (gcc-8) FAIL
    realview_defconfig: (gcc-8) FAIL
    s3c6400_defconfig: (gcc-8) FAIL
    s5pv210_defconfig: (gcc-8) FAIL
    shannon_defconfig: (gcc-8) FAIL
    simpad_defconfig: (gcc-8) FAIL
    spear3xx_defconfig: (gcc-8) FAIL
    spear6xx_defconfig: (gcc-8) FAIL
    stm32_defconfig: (gcc-8) FAIL
    sunxi_defconfig: (gcc-8) FAIL
    tct_hammer_defconfig: (gcc-8) FAIL
    tinyconfig: (gcc-8) FAIL
    trizeps4_defconfig: (gcc-8) FAIL
    u300_defconfig: (gcc-8) FAIL
    versatile_defconfig: (gcc-8) FAIL
    vexpress_defconfig: (gcc-8) FAIL
    vf610m4_defconfig: (gcc-8) FAIL
    viper_defconfig: (gcc-8) FAIL
    xcep_defconfig: (gcc-8) FAIL
    zeus_defconfig: (gcc-8) FAIL
    zx_defconfig: (gcc-8) FAIL

i386:
    allnoconfig: (gcc-8) FAIL
    tinyconfig: (gcc-8) FAIL

mips:
    allnoconfig: (gcc-8) FAIL
    ar7_defconfig: (gcc-8) FAIL
    ath25_defconfig: (gcc-8) FAIL
    ath79_defconfig: (gcc-8) FAIL
    bcm63xx_defconfig: (gcc-8) FAIL
    capcella_defconfig: (gcc-8) FAIL
    ci20_defconfig: (gcc-8) FAIL
    cobalt_defconfig: (gcc-8) FAIL
    e55_defconfig: (gcc-8) FAIL
    fuloong2e_defconfig: (gcc-8) FAIL
    gpr_defconfig: (gcc-8) FAIL
    ip28_defconfig: (gcc-8) FAIL
    jmr3927_defconfig: (gcc-8) FAIL
    lasat_defconfig: (gcc-8) FAIL
    loongson1b_defconfig: (gcc-8) FAIL
    loongson1c_defconfig: (gcc-8) FAIL
    mpc30x_defconfig: (gcc-8) FAIL
    msp71xx_defconfig: (gcc-8) FAIL
    pic32mzda_defconfig: (gcc-8) FAIL
    pnx8335_stb225_defconfig: (gcc-8) FAIL
    qi_lb60_defconfig: (gcc-8) FAIL
    rb532_defconfig: (gcc-8) FAIL
    rbtx49xx_defconfig: (gcc-8) FAIL
    rt305x_defconfig: (gcc-8) FAIL
    sb1250_swarm_defconfig: (gcc-8) FAIL
    tb0219_defconfig: (gcc-8) FAIL
    tb0226_defconfig: (gcc-8) FAIL
    tb0287_defconfig: (gcc-8) FAIL
    tinyconfig: (gcc-8) FAIL
    workpad_defconfig: (gcc-8) FAIL
    xilfpga_defconfig: (gcc-8) FAIL
    xway_defconfig: (gcc-8) FAIL

x86_64:
    allnoconfig: (gcc-8) FAIL
    tinyconfig: (gcc-8) FAIL

Errors and Warnings Detected:

arc:
    allnoconfig (gcc-8): 1 error, 1 warning
    axs103_defconfig (gcc-8): 1 error, 1 warning
    axs103_smp_defconfig (gcc-8): 1 error, 1 warning
    nsim_hs_defconfig (gcc-8): 1 error, 1 warning
    nsim_hs_smp_defconfig (gcc-8): 1 error, 1 warning
    nsimosci_hs_defconfig (gcc-8): 1 error, 1 warning
    nsimosci_hs_smp_defconfig (gcc-8): 1 error, 1 warning
    tinyconfig (gcc-8): 1 error, 1 warning
    vdk_hs38_defconfig (gcc-8): 1 error, 1 warning
    vdk_hs38_smp_defconfig (gcc-8): 1 error, 1 warning
    zebu_hs_defconfig (gcc-8): 1 error, 1 warning
    zebu_hs_smp_defconfig (gcc-8): 2 errors, 2 warnings

arm64:
    allnoconfig (gcc-8): 1 error, 1 warning
    tinyconfig (gcc-8): 1 error, 1 warning

arm:
    acs5k_defconfig (gcc-8): 1 error, 1 warning
    acs5k_tiny_defconfig (gcc-8): 1 error, 1 warning
    allnoconfig (gcc-8): 1 error, 1 warning
    am200epdkit_defconfig (gcc-8): 1 error, 1 warning
    aspeed_g4_defconfig (gcc-8): 1 error, 1 warning
    aspeed_g5_defconfig (gcc-8): 1 error, 1 warning
    assabet_defconfig (gcc-8): 1 error, 1 warning
    at91_dt_defconfig (gcc-8): 1 warning
    axm55xx_defconfig (gcc-8): 1 error, 1 warning
    badge4_defconfig (gcc-8): 1 error, 1 warning
    cerfcube_defconfig (gcc-8): 1 error, 1 warning
    clps711x_defconfig (gcc-8): 1 error, 1 warning
    cm_x2xx_defconfig (gcc-8): 1 error, 1 warning
    cm_x300_defconfig (gcc-8): 1 error, 1 warning
    cns3420vb_defconfig (gcc-8): 1 error, 1 warning
    colibri_pxa270_defconfig (gcc-8): 1 error, 1 warning
    collie_defconfig (gcc-8): 1 error, 1 warning
    dove_defconfig (gcc-8): 1 error, 1 warning
    efm32_defconfig (gcc-8): 1 error, 1 warning
    em_x270_defconfig (gcc-8): 1 error, 1 warning
    eseries_pxa_defconfig (gcc-8): 1 error, 1 warning
    footbridge_defconfig (gcc-8): 1 error, 1 warning
    h3600_defconfig (gcc-8): 1 error, 1 warning
    h5000_defconfig (gcc-8): 1 error, 1 warning
    hackkit_defconfig (gcc-8): 1 error, 1 warning
    imx_v4_v5_defconfig (gcc-8): 1 error, 1 warning
    integrator_defconfig (gcc-8): 1 error, 1 warning
    ixp4xx_defconfig (gcc-8): 1 error, 1 warning
    jornada720_defconfig (gcc-8): 1 error, 1 warning
    ks8695_defconfig (gcc-8): 1 error, 1 warning
    lart_defconfig (gcc-8): 1 error, 1 warning
    lpc18xx_defconfig (gcc-8): 1 error, 1 warning
    lubbock_defconfig (gcc-8): 1 error, 1 warning
    magician_defconfig (gcc-8): 1 error, 1 warning
    mainstone_defconfig (gcc-8): 1 error, 1 warning
    mini2440_defconfig (gcc-8): 1 error, 1 warning
    mmp2_defconfig (gcc-8): 1 error, 1 warning
    moxart_defconfig (gcc-8): 1 error, 1 warning
    mps2_defconfig (gcc-8): 1 error, 1 warning
    multi_v4t_defconfig (gcc-8): 1 error, 1 warning
    multi_v5_defconfig (gcc-8): 1 warning
    multi_v7_defconfig (gcc-8): 1 warning
    mv78xx0_defconfig (gcc-8): 1 error, 1 warning
    mvebu_v5_defconfig (gcc-8): 1 error, 1 warning
    mxs_defconfig (gcc-8): 1 error, 1 warning
    neponset_defconfig (gcc-8): 1 error, 1 warning
    netwinder_defconfig (gcc-8): 1 error, 1 warning
    nhk8815_defconfig (gcc-8): 1 error, 1 warning
    nuc910_defconfig (gcc-8): 1 error, 1 warning
    nuc950_defconfig (gcc-8): 1 error, 1 warning
    nuc960_defconfig (gcc-8): 1 error, 1 warning
    orion5x_defconfig (gcc-8): 1 error, 1 warning
    palmz72_defconfig (gcc-8): 1 error, 1 warning
    pcm027_defconfig (gcc-8): 1 error, 1 warning
    pleb_defconfig (gcc-8): 1 error, 1 warning
    prima2_defconfig (gcc-8): 1 error, 1 warning
    pxa168_defconfig (gcc-8): 1 error, 1 warning
    pxa255-idp_defconfig (gcc-8): 1 error, 1 warning
    pxa3xx_defconfig (gcc-8): 1 error, 1 warning
    pxa910_defconfig (gcc-8): 1 error, 1 warning
    pxa_defconfig (gcc-8): 1 error, 1 warning
    qcom_defconfig (gcc-8): 1 error, 1 warning
    realview_defconfig (gcc-8): 1 error, 1 warning
    s3c6400_defconfig (gcc-8): 1 error, 1 warning
    s5pv210_defconfig (gcc-8): 1 error, 1 warning
    sama5_defconfig (gcc-8): 1 warning
    shannon_defconfig (gcc-8): 1 error, 1 warning
    simpad_defconfig (gcc-8): 1 error, 1 warning
    spear3xx_defconfig (gcc-8): 1 error, 1 warning
    spear6xx_defconfig (gcc-8): 1 error, 1 warning
    stm32_defconfig (gcc-8): 1 error, 1 warning
    sunxi_defconfig (gcc-8): 1 error, 1 warning
    tct_hammer_defconfig (gcc-8): 1 error, 1 warning
    tinyconfig (gcc-8): 1 error, 1 warning
    trizeps4_defconfig (gcc-8): 1 error, 1 warning
    u300_defconfig (gcc-8): 1 error, 1 warning
    versatile_defconfig (gcc-8): 1 error, 1 warning
    vexpress_defconfig (gcc-8): 1 error, 1 warning
    vf610m4_defconfig (gcc-8): 1 error, 1 warning
    viper_defconfig (gcc-8): 1 error, 1 warning
    xcep_defconfig (gcc-8): 1 error, 1 warning
    zeus_defconfig (gcc-8): 1 error, 1 warning
    zx_defconfig (gcc-8): 1 error, 1 warning

i386:
    allnoconfig (gcc-8): 1 error, 1 warning
    tinyconfig (gcc-8): 1 error, 1 warning

mips:
    allnoconfig (gcc-8): 1 error, 1 warning
    ar7_defconfig (gcc-8): 2 errors, 2 warnings
    ath25_defconfig (gcc-8): 1 error, 1 warning
    ath79_defconfig (gcc-8): 2 errors, 2 warnings
    bcm63xx_defconfig (gcc-8): 1 error, 1 warning
    capcella_defconfig (gcc-8): 1 error, 1 warning
    ci20_defconfig (gcc-8): 2 errors, 2 warnings
    cobalt_defconfig (gcc-8): 1 error, 1 warning
    e55_defconfig (gcc-8): 1 error, 1 warning
    fuloong2e_defconfig (gcc-8): 3 errors, 3 warnings
    gpr_defconfig (gcc-8): 1 error, 1 warning
    ip28_defconfig (gcc-8): 2 errors, 2 warnings
    jmr3927_defconfig (gcc-8): 1 error, 1 warning
    lasat_defconfig (gcc-8): 1 error, 1 warning
    loongson1b_defconfig (gcc-8): 1 error, 1 warning
    loongson1c_defconfig (gcc-8): 1 error, 1 warning
    mpc30x_defconfig (gcc-8): 2 errors, 2 warnings
    msp71xx_defconfig (gcc-8): 1 error, 1 warning
    pic32mzda_defconfig (gcc-8): 1 error, 1 warning
    pnx8335_stb225_defconfig (gcc-8): 1 error, 1 warning
    qi_lb60_defconfig (gcc-8): 1 error, 1 warning
    rb532_defconfig (gcc-8): 1 error, 1 warning
    rbtx49xx_defconfig (gcc-8): 1 error, 1 warning
    rt305x_defconfig (gcc-8): 1 error, 1 warning
    sb1250_swarm_defconfig (gcc-8): 2 errors, 2 warnings
    tb0219_defconfig (gcc-8): 1 error, 1 warning
    tb0226_defconfig (gcc-8): 1 error, 1 warning
    tb0287_defconfig (gcc-8): 1 error, 1 warning
    tinyconfig (gcc-8): 1 error, 1 warning
    workpad_defconfig (gcc-8): 1 error, 1 warning
    xilfpga_defconfig (gcc-8): 1 error, 1 warning
    xway_defconfig (gcc-8): 1 error, 1 warning

x86_64:
    allnoconfig (gcc-8): 1 error, 1 warning
    tinyconfig (gcc-8): 1 error, 1 warning

Errors summary:

    138  ./include/linux/icmpv6.h:69:2: error: implicit declaration of func=
tion =E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=
=80=99? [-Werror=3Dimplicit-function-declaration]

Warnings summary:

    135  cc1: some warnings being treated as errors
    4    drivers/mtd/nand/atmel_nand.c:2337:19: warning: unused variable =
=E2=80=98mtd=E2=80=99 [-Wunused-variable]
    3    cc1: all warnings being treated as errors

Section mismatches summary:

    2    WARNING: modpost: Found 1 section mismatch(es).

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
32r2el_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
acs5k_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
acs5k_tiny_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
allnoconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mis=
matches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
allnoconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mism=
atches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
allnoconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mism=
atches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
allnoconfig (x86_64, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
allnoconfig (arm64, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mi=
smatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
allnoconfig (i386, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mis=
matches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
am200epdkit_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ar7_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 2 warnings, 0 section=
 mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
aspeed_g4_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
aspeed_g5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
assabet_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
at91_dt_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    drivers/mtd/nand/atmel_nand.c:2337:19: warning: unused variable =E2=80=
=98mtd=E2=80=99 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
ath25_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ath79_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 2 warnings, 0 secti=
on mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
axm55xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
axs103_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
axs103_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
badge4_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
bcm2835_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
bcm47xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
bcm63xx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
bigsur_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
bmips_stb_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ci20_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 2 warnings, 0 sectio=
n mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
clps711x_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cm_x2xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cm_x300_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cns3420vb_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cobalt_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
colibri_pxa270_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0=
 section mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
collie_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

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
dove_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
e55_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ebsa110_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
efm32_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
em_x270_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ep93xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

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
footbridge_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
fuloong2e_defconfig (mips, gcc-8) =E2=80=94 FAIL, 3 errors, 3 warnings, 0 s=
ection mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors
    cc1: some warnings being treated as errors
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
gpr_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
h3600_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
h5000_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
hackkit_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

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
imx_v4_v5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
imx_v6_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
integrator_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

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
ip22_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
ip27_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
ip28_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 2 warnings, 0 sectio=
n mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
ip32_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
ixp4xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
jmr3927_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
jornada720_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
keystone_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
ks8695_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
lart_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
lasat_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
loongson1b_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
loongson1c_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
loongson3_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
lpc18xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

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
lubbock_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
magician_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mainstone_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

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
mini2440_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mips_paravirt_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
mmp2_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
moxart_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mpc30x_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 2 warnings, 0 sect=
ion mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mps2_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
msp71xx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mtx1_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
multi_v4t_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
multi_v5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    drivers/mtd/nand/atmel_nand.c:2337:19: warning: unused variable =E2=80=
=98mtd=E2=80=99 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    drivers/mtd/nand/atmel_nand.c:2337:19: warning: unused variable =E2=80=
=98mtd=E2=80=99 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
mv78xx0_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mvebu_v5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mvebu_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
mxs_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mi=
smatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
neponset_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
netwinder_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
netx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
nhk8815_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
nsim_hs_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nsim_hs_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nsimosci_hs_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nsimosci_hs_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, =
0 section mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nuc910_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nuc950_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nuc960_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

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
orion5x_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
palmz72_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pcm027_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pic32mzda_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pistachio_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
pleb_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pnx8335_stb225_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, =
0 section mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
prima2_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pxa168_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pxa255-idp_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pxa3xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pxa910_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pxa_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mi=
smatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
qcom_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
qi_lb60_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
raumfeld_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
rb532_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
rbtx49xx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
realview_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
rpc_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
s3c2410_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
s3c6400_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
s5pv210_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
sama5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    drivers/mtd/nand/atmel_nand.c:2337:19: warning: unused variable =E2=80=
=98mtd=E2=80=99 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
sb1250_swarm_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 2 warnings, =
0 section mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
shannon_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
shmobile_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
simpad_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

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
spear3xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
spear6xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
spitz_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
stm32_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
sunxi_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tb0219_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tb0226_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tb0287_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tct_hammer_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tegra_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
tinyconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mism=
atches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tinyconfig (arm64, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mis=
matches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tinyconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section misma=
tches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mi=
smatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tinyconfig (i386, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mism=
atches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tinyconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section misma=
tches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
trizeps4_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
u300_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
u8500_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
vdk_hs38_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
vdk_hs38_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 s=
ection mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
versatile_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
vexpress_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
vf610m4_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
viper_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
vt8500_v6_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
workpad_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
x86_64_defconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
xcep_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
xilfpga_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
xway_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
zebu_hs_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
zebu_hs_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 2 errors, 2 warnings, 0 =
section mismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
zeus_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
zx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mis=
matches

Errors:
    ./include/linux/icmpv6.h:69:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---
For more info write to <info@kernelci.org>
