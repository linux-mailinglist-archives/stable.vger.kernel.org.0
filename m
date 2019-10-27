Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D239E69F8
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 23:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727432AbfJ0W62 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 18:58:28 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53342 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727139AbfJ0W62 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Oct 2019 18:58:28 -0400
Received: by mail-wm1-f65.google.com with SMTP id n7so7509362wmc.3
        for <stable@vger.kernel.org>; Sun, 27 Oct 2019 15:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0C2oKLlUNiolTj4uFcLyPA2qE3ycWHI09Ql+V1AQLp8=;
        b=zO0+vbGbuewtU5M2VtH+q+ALtsPAd++yiiEe3HKZWKM7k/wxL1BIrAjE+sa2a4pbcF
         +T9nPlywJGkMLZjYlzvf+S1gxPU5oe3QcmsRVdqd4y+Shc6XaQ5ofhRu7sBBtw34Wlm/
         Pe+KulIbrFeso88FBXMJjmrawcIOJtd6CFwfhLXnUBa4ukJKNwbujNmsdoHJcAIdw50n
         PQV3ynER2lI14ebtUQFDv+psSEK8ZYjv1WcvEzCtNMOpxS8BIq4VAesq8T1xD9MjdQtM
         hZlRTJCkg/d9LwIl8hcbKegolBTE6G1XdmPzanCgNwe8HjY27MTcEZBBRT16RHqzhnao
         0rMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0C2oKLlUNiolTj4uFcLyPA2qE3ycWHI09Ql+V1AQLp8=;
        b=rjBvbPhcZGsAR5pYjefcXRz/5qMEc0M+3KWDsBa0ozBhQmY8w6EZD5+/rb9bZOqDuY
         asnhDUiQbRdRjJI/eAxgLorN0IVRXyDnKbDyEjf9JzmIUqwSZGukPMKvI/zkx5iIXMcA
         Ker2KzynOuW0ibrVu+3FZKA6vgD5KrYcMcgAdpvbnpanqs4Ve9NAGuHLotU1126xPsv/
         IzsgaFW2ijdoB9HfnY4HVI7mwhBsafCmqszUKfkQsvtmw1dwas1tVIrUeIc+WHSigD5l
         QmocIMGULuQc5h1pzKBtPMSsf66ZByEhJ9wKZAUbUvCvtLHePeVAbLfldqy3ZZfEcleE
         KhSw==
X-Gm-Message-State: APjAAAUxClyhdrgSKSsTnGGpV+1BG6T06f6Ve54giWgAGonyvxi49xdo
        QRgEk/1jEOfKMKWLcY9sQa5YeFHGv7Q=
X-Google-Smtp-Source: APXvYqxc9oMTTJCet+CX5gpvf6Tm7l3hq2FOcxyE2kQTWOx3en+HiyaX3Oxf3dsoSXGUDKYLTQDLFw==
X-Received: by 2002:a1c:39c1:: with SMTP id g184mr12966003wma.75.1572217100168;
        Sun, 27 Oct 2019 15:58:20 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o70sm10069633wme.29.2019.10.27.15.58.19
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Oct 2019 15:58:19 -0700 (PDT)
Message-ID: <5db6210b.1c69fb81.88f9c.26a1@mx.google.com>
Date:   Sun, 27 Oct 2019 15:58:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.150-120-gea1df089eebe
X-Kernelci-Report-Type: build
Subject: stable-rc/linux-4.14.y build: 201 builds: 64 failed, 137 passed,
 128 errors, 167 warnings (v4.14.150-120-gea1df089eebe)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y build: 201 builds: 64 failed, 137 passed, 128 errors=
, 167 warnings (v4.14.150-120-gea1df089eebe)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.150-120-gea1df089eebe/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.150-120-gea1df089eebe
Git Commit: ea1df089eebe2babf969ff53de3fefe3898c2362
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
    omega2p_defconfig: (gcc-8) FAIL
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
    vocore2_defconfig: (gcc-8) FAIL
    workpad_defconfig: (gcc-8) FAIL
    xilfpga_defconfig: (gcc-8) FAIL
    xway_defconfig: (gcc-8) FAIL

Errors and Warnings Detected:

arc:

arm64:
    allnoconfig (gcc-8): 2 warnings
    defconfig (gcc-8): 1 warning
    tinyconfig (gcc-8): 2 warnings

arm:
    acs5k_defconfig (gcc-8): 1 warning
    acs5k_tiny_defconfig (gcc-8): 1 warning
    aspeed_g4_defconfig (gcc-8): 1 warning
    aspeed_g5_defconfig (gcc-8): 1 warning
    assabet_defconfig (gcc-8): 1 warning
    axm55xx_defconfig (gcc-8): 1 warning
    badge4_defconfig (gcc-8): 1 warning
    cerfcube_defconfig (gcc-8): 1 warning
    clps711x_defconfig (gcc-8): 1 warning
    cm_x300_defconfig (gcc-8): 1 warning
    cns3420vb_defconfig (gcc-8): 1 warning
    colibri_pxa270_defconfig (gcc-8): 1 warning
    colibri_pxa300_defconfig (gcc-8): 1 warning
    collie_defconfig (gcc-8): 1 warning
    corgi_defconfig (gcc-8): 1 warning
    davinci_all_defconfig (gcc-8): 1 warning
    dove_defconfig (gcc-8): 1 warning
    ebsa110_defconfig (gcc-8): 1 warning
    ep93xx_defconfig (gcc-8): 1 warning
    eseries_pxa_defconfig (gcc-8): 1 warning
    exynos_defconfig (gcc-8): 1 warning
    ezx_defconfig (gcc-8): 1 warning
    footbridge_defconfig (gcc-8): 1 warning
    gemini_defconfig (gcc-8): 1 warning
    h3600_defconfig (gcc-8): 1 warning
    hackkit_defconfig (gcc-8): 1 warning
    hisi_defconfig (gcc-8): 1 warning
    imote2_defconfig (gcc-8): 1 warning
    imx_v6_v7_defconfig (gcc-8): 1 warning
    integrator_defconfig (gcc-8): 1 warning
    iop13xx_defconfig (gcc-8): 1 warning
    iop32x_defconfig (gcc-8): 1 warning
    iop33x_defconfig (gcc-8): 1 warning
    ixp4xx_defconfig (gcc-8): 1 warning
    jornada720_defconfig (gcc-8): 1 warning
    keystone_defconfig (gcc-8): 1 warning
    ks8695_defconfig (gcc-8): 1 warning
    lart_defconfig (gcc-8): 1 warning
    lpd270_defconfig (gcc-8): 1 warning
    lubbock_defconfig (gcc-8): 1 warning
    magician_defconfig (gcc-8): 1 warning
    mainstone_defconfig (gcc-8): 1 warning
    mini2440_defconfig (gcc-8): 1 warning
    mmp2_defconfig (gcc-8): 1 warning
    moxart_defconfig (gcc-8): 1 warning
    multi_v4t_defconfig (gcc-8): 1 warning
    multi_v5_defconfig (gcc-8): 1 warning
    multi_v7_defconfig (gcc-8): 1 warning
    mv78xx0_defconfig (gcc-8): 1 warning
    mvebu_v5_defconfig (gcc-8): 1 warning
    mvebu_v7_defconfig (gcc-8): 1 warning
    mxs_defconfig (gcc-8): 1 warning
    neponset_defconfig (gcc-8): 1 warning
    netwinder_defconfig (gcc-8): 1 warning
    netx_defconfig (gcc-8): 1 warning
    nhk8815_defconfig (gcc-8): 1 warning
    nuc910_defconfig (gcc-8): 1 warning
    nuc950_defconfig (gcc-8): 1 warning
    nuc960_defconfig (gcc-8): 1 warning
    omap2plus_defconfig (gcc-8): 1 warning
    orion5x_defconfig (gcc-8): 1 warning
    palmz72_defconfig (gcc-8): 1 warning
    pcm027_defconfig (gcc-8): 1 warning
    prima2_defconfig (gcc-8): 1 warning
    pxa168_defconfig (gcc-8): 1 warning
    pxa255-idp_defconfig (gcc-8): 1 warning
    pxa3xx_defconfig (gcc-8): 1 warning
    pxa910_defconfig (gcc-8): 1 warning
    pxa_defconfig (gcc-8): 1 warning
    qcom_defconfig (gcc-8): 1 warning
    raumfeld_defconfig (gcc-8): 1 warning
    realview_defconfig (gcc-8): 1 warning
    rpc_defconfig (gcc-8): 1 warning
    s3c2410_defconfig (gcc-8): 1 warning
    s3c6400_defconfig (gcc-8): 1 warning
    s5pv210_defconfig (gcc-8): 1 warning
    sama5_defconfig (gcc-8): 1 warning
    shannon_defconfig (gcc-8): 1 warning
    simpad_defconfig (gcc-8): 1 warning
    socfpga_defconfig (gcc-8): 1 warning
    spear13xx_defconfig (gcc-8): 1 warning
    spear3xx_defconfig (gcc-8): 1 warning
    spear6xx_defconfig (gcc-8): 1 warning
    spitz_defconfig (gcc-8): 1 warning
    sunxi_defconfig (gcc-8): 1 warning
    tango4_defconfig (gcc-8): 1 warning
    tegra_defconfig (gcc-8): 1 warning
    trizeps4_defconfig (gcc-8): 1 warning
    u300_defconfig (gcc-8): 1 warning
    u8500_defconfig (gcc-8): 1 warning
    versatile_defconfig (gcc-8): 1 warning
    vexpress_defconfig (gcc-8): 1 warning
    vt8500_v6_v7_defconfig (gcc-8): 1 warning
    zeus_defconfig (gcc-8): 1 warning
    zx_defconfig (gcc-8): 1 warning

i386:
    i386_defconfig (gcc-8): 1 warning

mips:
    32r2el_defconfig (gcc-8): 2 errors, 1 warning
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
    omega2p_defconfig (gcc-8): 2 errors, 1 warning
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
    vocore2_defconfig (gcc-8): 2 errors, 1 warning
    workpad_defconfig (gcc-8): 2 errors, 1 warning
    xilfpga_defconfig (gcc-8): 2 errors, 1 warning
    xway_defconfig (gcc-8): 2 errors, 1 warning

x86_64:
    tinyconfig (gcc-8): 1 warning
    x86_64_defconfig (gcc-8): 1 warning

Errors summary:

    64   arch/mips/include/asm/cpu-features.h:352:31: error: implicit decla=
ration of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-func=
tion-declaration]
    52   arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' =
undeclared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?
    12   arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' =
undeclared (first use in this function); did you mean 'HWCAP_LOONGSON_MMI'?

Warnings summary:

    98   fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitia=
lized in this function [-Wmaybe-uninitialized]
    64   cc1: all warnings being treated as errors
    2    arch/arm64/kernel/cpufeature.c:940:13: warning: 'cpu_copy_el2regs'=
 defined but not used [-Wunused-function]
    2    arch/arm64/kernel/cpufeature.c:802:13: warning: 'runs_at_el2' defi=
ned but not used [-Wunused-function]
    1    .config:1023:warning: override: UNWINDER_GUESS changes choice state

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
32r2el_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_MMI'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
acs5k_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
acs5k_tiny_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
allnoconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
allnoconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 section =
mismatches

Warnings:
    arch/arm64/kernel/cpufeature.c:940:13: warning: 'cpu_copy_el2regs' defi=
ned but not used [-Wunused-function]
    arch/arm64/kernel/cpufeature.c:802:13: warning: 'runs_at_el2' defined b=
ut not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
allnoconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
allnoconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section mi=
smatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
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
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
aspeed_g4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
aspeed_g5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
assabet_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
at91_dt_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
ath25_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
ath79_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
axm55xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

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
badge4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
bcm2835_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
bcm47xx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
bcm63xx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
bigsur_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_MMI'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_MMI'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
bmips_stb_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 se=
ction mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_MMI'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, =
0 section mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
ci20_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
clps711x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
cm_x2xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
cm_x300_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
cns3420vb_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
cobalt_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
colibri_pxa270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, =
0 section mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, =
0 section mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
collie_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
corgi_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
davinci_all_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 s=
ection mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mis=
matches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
dove_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
e55_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section =
mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
ebsa110_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

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
ep93xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
fuloong2e_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 se=
ction mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
gemini_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
gpr_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section =
mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
h3600_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
h5000_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
hackkit_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
haps_hs_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
haps_hs_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
hisi_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
hsdk_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
i386_defconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
imote2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
imx_v4_v5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
imx_v6_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
integrator_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
iop13xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
iop32x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
iop33x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
ip22_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
ip27_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_MMI'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
ip28_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
ip32_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
ixp4xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
jmr3927_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
jornada720_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
keystone_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
ks8695_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
lart_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
lasat_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
loongson1b_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 s=
ection mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
loongson1c_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 s=
ection mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
loongson3_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 se=
ction mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_MMI'?

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
lpd270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
lubbock_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
magician_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
mainstone_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
malta_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_MMI'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 se=
ction mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_MMI'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
malta_kvm_guest_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning=
, 0 section mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
malta_qemu_32r6_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning=
, 0 section mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
maltaaprp_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 se=
ction mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
maltasmvp_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 se=
ction mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, =
0 section mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
maltaup_xpa_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 =
section mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_MMI'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
markeins_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
mips_paravirt_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, =
0 section mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
mmp2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
moxart_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
mpc30x_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
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
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
mtx1_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
multi_v4t_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
multi_v5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
mv78xx0_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
mvebu_v5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
mvebu_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
mxs_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
neponset_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
netwinder_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
netx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
nhk8815_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_MMI'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_MMI'?

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
nuc910_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
nuc950_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
nuc960_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
omap1_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
omega2p_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
orion5x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
palmz72_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
pcm027_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
pic32mzda_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 se=
ction mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
pistachio_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 se=
ction mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_MMI'?

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
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
prima2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
pxa168_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
pxa255-idp_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
pxa3xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
pxa910_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
pxa_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
qcom_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
qi_lb60_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
raumfeld_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
rb532_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
rbtx49xx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
realview_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
rpc_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
s3c2410_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
s3c6400_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
s5pv210_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
sama5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
sb1250_swarm_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0=
 section mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
shannon_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
shmobile_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
simpad_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
socfpga_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
spear13xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
spear3xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
spear6xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
spitz_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
stm32_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
sunxi_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
tango4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
tb0219_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
tb0226_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
tb0287_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
tct_hammer_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
tegra_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
tinyconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
tinyconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 section m=
ismatches

Warnings:
    arch/arm64/kernel/cpufeature.c:940:13: warning: 'cpu_copy_el2regs' defi=
ned but not used [-Wunused-function]
    arch/arm64/kernel/cpufeature.c:802:13: warning: 'runs_at_el2' defined b=
ut not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    .config:1023:warning: override: UNWINDER_GUESS changes choice state

---------------------------------------------------------------------------=
-----
tinyconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section mis=
matches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
tinyconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
tinyconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
trizeps4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
u300_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
u8500_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

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
versatile_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
vexpress_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
viper_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
vocore2_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
vt8500_v6_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 =
section mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
workpad_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
x86_64_defconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
xcep_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
xilfpga_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
xway_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaratio=
n of function '__ase'; did you mean '__iget'? [-Werror=3Dimplicit-function-=
declaration]
    arch/mips/kernel/cpu-probe.c:2108:16: error: 'HWCAP_LOONGSON_CAM' undec=
lared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
zeus_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
zx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mi=
smatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---
For more info write to <info@kernelci.org>
