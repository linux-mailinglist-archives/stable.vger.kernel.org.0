Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDA841EB2E2
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 03:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725801AbgFBBL0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 21:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgFBBL0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jun 2020 21:11:26 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 365FEC061A0E
        for <stable@vger.kernel.org>; Mon,  1 Jun 2020 18:11:25 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id n9so664247plk.1
        for <stable@vger.kernel.org>; Mon, 01 Jun 2020 18:11:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hWsEtWHQCdNFe/9oXURCZE1GmOrYoeDZ8muPcsDYYok=;
        b=CQN9/3nG+Ej7L/dlvN5pAvXQAXRME9UcvcrvtxXlolOXsEGYj8mGyyP8LNlo5A7Abu
         oVI/w2sd1nsqjgU4+RN1kJhwKrFmL3/bRhfALPtpezE+RDkjA4JSDAEPwNaNE5NNfJXc
         qBN/ul2lhNP6eCMA2IVYA9V9aqAklASxPdhm8PpmTwaBTrZvKfXR1r4g79p4FsH8eru4
         fYM+RrTAbGNWTMAEwlgWMshzzOOALb1tsB7JKZg8tr40ICIpweTm6IFaiBZmydHJXZs8
         wav5cIimzvOg6qd6Zd1RWAmHZDL9dXmlORtHnxI1TDyr/u+arJO1EFOueih40R8ruETC
         VuuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hWsEtWHQCdNFe/9oXURCZE1GmOrYoeDZ8muPcsDYYok=;
        b=ETnPyPGob+LG7BlXwzl8iOQtZsSLvpH9XH1p+k20bBpABGRKguGm8A5JOzQs2yfqh+
         XLl9NdWULuPtavlzEz4NSZ/RMY0pkmXOXVBQePsKMZ/jNKz9ydqSsrO1oNmpWa2iftmU
         X2UQcdhgiAt3/qQFKsRSw+Ghfh9QfDzurCjJCvdHddHsrf5Mfclru3SUgJwttVwt9Lpu
         fcSzKnBDCGbUlHGkfUlGA58WG5+qhqhXZ4gzAzljLRyICpAMe9nkr57h3Muhjln6zRBm
         7MOdQQm/Du2qVs0PGCOJeRaz/z2Nn6c4Q57d33mxEWR8x4AvUJy1Ujq7xHic6HWZPHKk
         5Q6g==
X-Gm-Message-State: AOAM532ZpKWV2IuJwyvINqRKFzMkyQigzRCDjjDVjJzzy77dLBuok0Fw
        5HcT6Y8Dqx3aPkQRULYN2jj1cd6a29s=
X-Google-Smtp-Source: ABdhPJwabo78uz7XaWdtQGTsmtpSqEh/3zCSgDiIx5tSZxYhC+4SCa3VFOa4Ykpabq1Vg1b9FnTV3g==
X-Received: by 2002:a17:90a:648b:: with SMTP id h11mr1026116pjj.59.1591060283271;
        Mon, 01 Jun 2020 18:11:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a85sm516573pfd.181.2020.06.01.18.11.22
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 18:11:22 -0700 (PDT)
Message-ID: <5ed5a73a.1c69fb81.c8510.23b3@mx.google.com>
Date:   Mon, 01 Jun 2020 18:11:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v4.9.225-62-gf7c3cc559c2e
Subject: stable-rc/linux-4.9.y build: 163 builds: 91 failed, 72 passed,
 131 errors (v4.9.225-62-gf7c3cc559c2e)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y build: 163 builds: 91 failed, 72 passed, 131 errors (=
v4.9.225-62-gf7c3cc559c2e)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.225-62-gf7c3cc559c2e/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.225-62-gf7c3cc559c2e
Git Commit: f7c3cc559c2e60aedae9799208fc8dd85211b971
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 5 unique architectures

Build Failures Detected:

arm:
    acs5k_defconfig: (gcc-8) FAIL
    acs5k_tiny_defconfig: (gcc-8) FAIL
    am200epdkit_defconfig: (gcc-8) FAIL
    aspeed_g4_defconfig: (gcc-8) FAIL
    aspeed_g5_defconfig: (gcc-8) FAIL
    assabet_defconfig: (gcc-8) FAIL
    at91_dt_defconfig: (gcc-8) FAIL
    axm55xx_defconfig: (gcc-8) FAIL
    badge4_defconfig: (gcc-8) FAIL
    bcm2835_defconfig: (gcc-8) FAIL
    clps711x_defconfig: (gcc-8) FAIL
    cm_x2xx_defconfig: (gcc-8) FAIL
    cm_x300_defconfig: (gcc-8) FAIL
    colibri_pxa270_defconfig: (gcc-8) FAIL
    colibri_pxa300_defconfig: (gcc-8) FAIL
    collie_defconfig: (gcc-8) FAIL
    corgi_defconfig: (gcc-8) FAIL
    davinci_all_defconfig: (gcc-8) FAIL
    dove_defconfig: (gcc-8) FAIL
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
    iop13xx_defconfig: (gcc-8) FAIL
    iop32x_defconfig: (gcc-8) FAIL
    iop33x_defconfig: (gcc-8) FAIL
    ixp4xx_defconfig: (gcc-8) FAIL
    jornada720_defconfig: (gcc-8) FAIL
    keystone_defconfig: (gcc-8) FAIL
    ks8695_defconfig: (gcc-8) FAIL
    lart_defconfig: (gcc-8) FAIL
    lpc32xx_defconfig: (gcc-8) FAIL
    lpd270_defconfig: (gcc-8) FAIL
    lubbock_defconfig: (gcc-8) FAIL
    magician_defconfig: (gcc-8) FAIL
    mini2440_defconfig: (gcc-8) FAIL
    moxart_defconfig: (gcc-8) FAIL
    multi_v4t_defconfig: (gcc-8) FAIL
    multi_v7_defconfig: (gcc-8) FAIL
    mv78xx0_defconfig: (gcc-8) FAIL
    mvebu_v5_defconfig: (gcc-8) FAIL
    mvebu_v7_defconfig: (gcc-8) FAIL
    mxs_defconfig: (gcc-8) FAIL
    netwinder_defconfig: (gcc-8) FAIL
    netx_defconfig: (gcc-8) FAIL
    nhk8815_defconfig: (gcc-8) FAIL
    nuc910_defconfig: (gcc-8) FAIL
    nuc950_defconfig: (gcc-8) FAIL
    nuc960_defconfig: (gcc-8) FAIL
    omap2plus_defconfig: (gcc-8) FAIL
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
    raumfeld_defconfig: (gcc-8) FAIL
    realview_defconfig: (gcc-8) FAIL
    s3c6400_defconfig: (gcc-8) FAIL
    s5pv210_defconfig: (gcc-8) FAIL
    sama5_defconfig: (gcc-8) FAIL
    shannon_defconfig: (gcc-8) FAIL
    shmobile_defconfig: (gcc-8) FAIL
    simpad_defconfig: (gcc-8) FAIL
    socfpga_defconfig: (gcc-8) FAIL
    spear6xx_defconfig: (gcc-8) FAIL
    spitz_defconfig: (gcc-8) FAIL
    sunxi_defconfig: (gcc-8) FAIL
    tegra_defconfig: (gcc-8) FAIL
    trizeps4_defconfig: (gcc-8) FAIL
    u300_defconfig: (gcc-8) FAIL
    versatile_defconfig: (gcc-8) FAIL
    vexpress_defconfig: (gcc-8) FAIL
    viper_defconfig: (gcc-8) FAIL
    zeus_defconfig: (gcc-8) FAIL
    zx_defconfig: (gcc-8) FAIL

mips:
    32r2el_defconfig: (gcc-8) FAIL

Errors Detected:

arc:

arm64:

arm:
    acs5k_defconfig (gcc-8): 1 error
    acs5k_tiny_defconfig (gcc-8): 1 error
    am200epdkit_defconfig (gcc-8): 1 error
    aspeed_g4_defconfig (gcc-8): 1 error
    aspeed_g5_defconfig (gcc-8): 1 error
    assabet_defconfig (gcc-8): 1 error
    at91_dt_defconfig (gcc-8): 1 error
    axm55xx_defconfig (gcc-8): 4 errors
    badge4_defconfig (gcc-8): 1 error
    bcm2835_defconfig (gcc-8): 3 errors
    clps711x_defconfig (gcc-8): 1 error
    cm_x2xx_defconfig (gcc-8): 1 error
    cm_x300_defconfig (gcc-8): 9 errors
    colibri_pxa270_defconfig (gcc-8): 1 error
    colibri_pxa300_defconfig (gcc-8): 1 error
    collie_defconfig (gcc-8): 1 error
    corgi_defconfig (gcc-8): 1 error
    davinci_all_defconfig (gcc-8): 1 error
    dove_defconfig (gcc-8): 3 errors
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
    iop13xx_defconfig (gcc-8): 1 error
    iop32x_defconfig (gcc-8): 1 error
    iop33x_defconfig (gcc-8): 1 error
    ixp4xx_defconfig (gcc-8): 1 error
    jornada720_defconfig (gcc-8): 1 error
    keystone_defconfig (gcc-8): 2 errors
    ks8695_defconfig (gcc-8): 1 error
    lart_defconfig (gcc-8): 1 error
    lpc32xx_defconfig (gcc-8): 1 error
    lpd270_defconfig (gcc-8): 1 error
    lubbock_defconfig (gcc-8): 1 error
    magician_defconfig (gcc-8): 1 error
    mini2440_defconfig (gcc-8): 1 error
    moxart_defconfig (gcc-8): 1 error
    multi_v4t_defconfig (gcc-8): 9 errors
    multi_v7_defconfig (gcc-8): 2 errors
    mv78xx0_defconfig (gcc-8): 1 error
    mvebu_v5_defconfig (gcc-8): 1 error
    mvebu_v7_defconfig (gcc-8): 2 errors
    mxs_defconfig (gcc-8): 1 error
    netwinder_defconfig (gcc-8): 1 error
    netx_defconfig (gcc-8): 1 error
    nhk8815_defconfig (gcc-8): 1 error
    nuc910_defconfig (gcc-8): 1 error
    nuc950_defconfig (gcc-8): 1 error
    nuc960_defconfig (gcc-8): 1 error
    omap2plus_defconfig (gcc-8): 2 errors
    orion5x_defconfig (gcc-8): 1 error
    palmz72_defconfig (gcc-8): 1 error
    pcm027_defconfig (gcc-8): 1 error
    pleb_defconfig (gcc-8): 1 error
    prima2_defconfig (gcc-8): 1 error
    pxa168_defconfig (gcc-8): 1 error
    pxa255-idp_defconfig (gcc-8): 1 error
    pxa3xx_defconfig (gcc-8): 1 error
    pxa910_defconfig (gcc-8): 1 error
    pxa_defconfig (gcc-8): 1 error
    raumfeld_defconfig (gcc-8): 1 error
    realview_defconfig (gcc-8): 2 errors
    s3c6400_defconfig (gcc-8): 1 error
    s5pv210_defconfig (gcc-8): 3 errors
    sama5_defconfig (gcc-8): 3 errors
    shannon_defconfig (gcc-8): 1 error
    shmobile_defconfig (gcc-8): 2 errors
    simpad_defconfig (gcc-8): 1 error
    socfpga_defconfig (gcc-8): 2 errors
    spear6xx_defconfig (gcc-8): 1 error
    spitz_defconfig (gcc-8): 1 error
    sunxi_defconfig (gcc-8): 2 errors
    tegra_defconfig (gcc-8): 2 errors
    trizeps4_defconfig (gcc-8): 1 error
    u300_defconfig (gcc-8): 1 error
    versatile_defconfig (gcc-8): 1 error
    vexpress_defconfig (gcc-8): 2 errors
    viper_defconfig (gcc-8): 1 error
    zeus_defconfig (gcc-8): 1 error
    zx_defconfig (gcc-8): 2 errors

mips:

x86_64:

Errors summary:

    71   arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip=
]'
    15   arch/arm/vfp/vfphw.S:233: Error: bad instruction `stcleq p11,cr0,[=
r0],#32*4'
    15   arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldcleq p11,cr0,[=
r10],#32*4'
    4    arch/arm/vfp/vfphw.S:233: Error: bad instruction `stclne p11,cr0,[=
r0],#32*4'
    4    arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldclne p11,cr0,[=
r10],#32*4'
    4    arch/arm/lib/clear_user.S:44: Error: bad instruction `strbtne r2,[=
r0],#1'
    4    arch/arm/lib/clear_user.S:39: Error: bad instruction `strtpl r2,[r=
0],#4'
    3    arch/arm/vfp/vfphw.S:116: Error: bad instruction `stcleq p11,cr0,[=
r4],#32*4'
    2    arch/arm/lib/clear_user.S:42: Error: bad instruction `strtpl r2,[r=
0],#4'
    2    arch/arm/lib/clear_user.S:35: Error: bad instruction `strbtlt r2,[=
r0],#1'
    2    arch/arm/lib/clear_user.S:34: Error: bad instruction `strbtle r2,[=
r0],#1'
    2    arch/arm/lib/clear_user.S:33: Error: bad instruction `strbtal r2,[=
r0],#1'
    1    arch/arm/vfp/vfphw.S:116: Error: bad instruction `stclne p11,cr0,[=
r4],#32*4'
    1    arch/arm/kvm/hyp/vfp.S:54: Error: bad instruction `ldcleq p11,cr0,=
[r0],#32*4'
    1    arch/arm/kvm/hyp/vfp.S:45: Error: bad instruction `stcleq p11,cr0,=
[r0],#32*4'


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
allnoconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
allnoconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
allnoconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
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
aspeed_g5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
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
at91_dt_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
ath25_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
ath79_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
axm55xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 4 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldcleq p11,cr0,[r10],=
#32*4'
    arch/arm/vfp/vfphw.S:233: Error: bad instruction `stcleq p11,cr0,[r0],#=
32*4'
    arch/arm/kvm/hyp/vfp.S:45: Error: bad instruction `stcleq p11,cr0,[r0],=
#32*4'
    arch/arm/kvm/hyp/vfp.S:54: Error: bad instruction `ldcleq p11,cr0,[r0],=
#32*4'

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
bcm2835_defconfig (arm, gcc-8) =E2=80=94 FAIL, 3 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    arch/arm/vfp/vfphw.S:116: Error: bad instruction `stclne p11,cr0,[r4],#=
32*4'
    arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldclne p11,cr0,[r10],=
#32*4'
    arch/arm/vfp/vfphw.S:233: Error: bad instruction `stclne p11,cr0,[r0],#=
32*4'

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
bmips_be_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
bmips_stb_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

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
cm_x300_defconfig (arm, gcc-8) =E2=80=94 FAIL, 9 errors, 0 warnings, 0 sect=
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
collie_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

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
davinci_all_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 s=
ection mismatches

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
dove_defconfig (arm, gcc-8) =E2=80=94 FAIL, 3 errors, 0 warnings, 0 section=
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
iop13xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

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
ixp4xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

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
ks8695_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
lart_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section =
mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

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
mps2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

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
multi_v4t_defconfig (arm, gcc-8) =E2=80=94 FAIL, 9 errors, 0 warnings, 0 se=
ction mismatches

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
nlm_xlp_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

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
nsimosci_hs_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

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
nuc960_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

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
pcm027_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

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
prima2_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

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
pxa910_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
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
realview_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldclne p11,cr0,[r10],=
#32*4'
    arch/arm/vfp/vfphw.S:233: Error: bad instruction `stclne p11,cr0,[r0],#=
32*4'

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

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
shannon_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

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
spear6xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

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
tegra_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldcleq p11,cr0,[r10],=
#32*4'
    arch/arm/vfp/vfphw.S:233: Error: bad instruction `stcleq p11,cr0,[r0],#=
32*4'

---------------------------------------------------------------------------=
-----
tinyconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
tinyconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
tinyconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

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
vdk_hs38_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
vdk_hs38_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
versatile_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

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
workpad_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
x86_64_defconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

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
zebu_hs_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

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
