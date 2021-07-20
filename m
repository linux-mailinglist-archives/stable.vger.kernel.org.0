Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 688253CF1BB
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 03:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237790AbhGTBN0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 21:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238703AbhGTA7T (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 20:59:19 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34335C061768
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 18:39:44 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id k20so21070512pgg.7
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 18:39:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=w9lQi+PALO7nTW/0FYvNiPUfDdJLZNZfLqvr9apScOE=;
        b=WjGR9VtoyLky7n70eqDIcNxTKCHRZONapWd7VGYuvuj3ciGTvalylgn4LupuDQfiCe
         x1ldTBkDY/3i3y8xmyJW94dFARcXjszZSXla8tWx+nl7tzbG8YzlGNojNpjQoX0a1mNS
         xgiK/I49uQn5IuOAVUyrj6/AfaIktQX3sjm5v9ccGOnw5zblhYqZIJ8bO3ZCKhVGmjY7
         kpFtgzO9vrIAD2LEn+bb5tJ5tNJlYnd+y4O8ZcsIO+9SQyBnrfLlbKTsYxsqZ3ANP9Z/
         absfPOH51NsTH30tIV3o3N3Zf9wCo8kKFgtmZA4sreak6Fggle/2EhNnllPhHcBn4VD8
         eHbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=w9lQi+PALO7nTW/0FYvNiPUfDdJLZNZfLqvr9apScOE=;
        b=YtcosMaB9AKJYdWn4C0rmMeVSluwX+PqOzHwtVcrexI7dtmx32lj0QUCPFYvsm+Jpv
         JZc8J0ZMK3FhIymL5A+MVhzmu2nicFbt7DCv4u9Bus+hjMOERLkcFLm9zEvuIDvctut+
         Q2krV4xlRp7oRcfvnMoSo4YUktoC2OlV6ToXK3IDwARJPqYonYVfdiIcuClOWBcK4uX1
         t3Kl0yPcCUGZM3nBdyGoLb2PqUJXJg8hnykNh7OeU2e4r9O+8kHOUbl2riXKMT0ZsYzJ
         u3qPDRJlaQoa/dEUjp9IdjwLJmPEFY6HIAXD6jDVYh172LGjrndKUPBRjM4hqUmSWrCN
         Xgxg==
X-Gm-Message-State: AOAM530a5gOUg+SFp+S9FmK3C5sIlM2GxwHjWQIYar1E1SfAC/0GKO86
        uErrYq8NfOSnfiDN0hhk5avvimfxxRWadg==
X-Google-Smtp-Source: ABdhPJw73a3mpbOrHsLOFkRccz3mGeyi3gOVHNPGyVL3baC49u4wtSqDaq+wnKAVsYcGMGW8ZMDmsA==
X-Received: by 2002:a62:6101:0:b029:326:3166:8b0b with SMTP id v1-20020a6261010000b029032631668b0bmr29257952pfb.4.1626745183040;
        Mon, 19 Jul 2021 18:39:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g141sm21378985pfb.210.2021.07.19.18.39.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 18:39:42 -0700 (PDT)
Message-ID: <60f6295e.1c69fb81.c74d7.09c2@mx.google.com>
Date:   Mon, 19 Jul 2021 18:39:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v5.12.18-288-g58aca573864e0
X-Kernelci-Branch: queue/5.12
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.12 build: 175 builds: 0 failed, 175 passed,
 143 warnings (v5.12.18-288-g58aca573864e0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 build: 175 builds: 0 failed, 175 passed, 143 warnings =
(v5.12.18-288-g58aca573864e0)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F5.1=
2/kernel/v5.12.18-288-g58aca573864e0/

Tree: stable-rc
Branch: queue/5.12
Git Describe: v5.12.18-288-g58aca573864e0
Git Commit: 58aca573864e0d161a818b1933c51ff06da1accc
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 6 unique architectures

Warnings Detected:

arc:
    axs103_defconfig (gcc-8): 1 warning
    axs103_smp_defconfig (gcc-8): 1 warning
    haps_hs_defconfig (gcc-8): 1 warning
    haps_hs_smp_defconfig (gcc-8): 1 warning
    hsdk_defconfig (gcc-8): 1 warning
    nsimosci_hs_defconfig (gcc-8): 1 warning
    nsimosci_hs_smp_defconfig (gcc-8): 1 warning
    vdk_hs38_defconfig (gcc-8): 1 warning
    vdk_hs38_smp_defconfig (gcc-8): 1 warning

arm:
    assabet_defconfig (gcc-8): 1 warning
    at91_dt_defconfig (gcc-8): 1 warning
    axm55xx_defconfig (gcc-8): 1 warning
    badge4_defconfig (gcc-8): 1 warning
    bcm2835_defconfig (gcc-8): 1 warning
    cerfcube_defconfig (gcc-8): 1 warning
    cm_x300_defconfig (gcc-8): 1 warning
    colibri_pxa270_defconfig (gcc-8): 1 warning
    colibri_pxa300_defconfig (gcc-8): 1 warning
    corgi_defconfig (gcc-8): 1 warning
    davinci_all_defconfig (gcc-8): 1 warning
    dove_defconfig (gcc-8): 1 warning
    ep93xx_defconfig (gcc-8): 1 warning
    eseries_pxa_defconfig (gcc-8): 1 warning
    exynos_defconfig (gcc-8): 1 warning
    ezx_defconfig (gcc-8): 1 warning
    footbridge_defconfig (gcc-8): 1 warning
    h3600_defconfig (gcc-8): 1 warning
    hisi_defconfig (gcc-8): 1 warning
    imote2_defconfig (gcc-8): 1 warning
    imx_v4_v5_defconfig (gcc-8): 1 warning
    imx_v6_v7_defconfig (gcc-8): 1 warning
    integrator_defconfig (gcc-8): 1 warning
    iop32x_defconfig (gcc-8): 1 warning
    ixp4xx_defconfig (gcc-8): 1 warning
    keystone_defconfig (gcc-8): 1 warning
    lart_defconfig (gcc-8): 1 warning
    lpc32xx_defconfig (gcc-8): 1 warning
    lpd270_defconfig (gcc-8): 1 warning
    lubbock_defconfig (gcc-8): 1 warning
    magician_defconfig (gcc-8): 1 warning
    mainstone_defconfig (gcc-8): 1 warning
    mini2440_defconfig (gcc-8): 1 warning
    mmp2_defconfig (gcc-8): 1 warning
    mps2_defconfig (gcc-8): 1 warning
    multi_v5_defconfig (gcc-8): 1 warning
    multi_v7_defconfig (gcc-8): 1 warning
    mvebu_v5_defconfig (gcc-8): 1 warning
    mvebu_v7_defconfig (gcc-8): 1 warning
    mxs_defconfig (gcc-8): 1 warning
    neponset_defconfig (gcc-8): 1 warning
    netwinder_defconfig (gcc-8): 1 warning
    nhk8815_defconfig (gcc-8): 1 warning
    omap1_defconfig (gcc-8): 2 warnings
    omap2plus_defconfig (gcc-8): 1 warning
    orion5x_defconfig (gcc-8): 1 warning
    pcm027_defconfig (gcc-8): 1 warning
    pleb_defconfig (gcc-8): 1 warning
    pxa168_defconfig (gcc-8): 1 warning
    pxa255-idp_defconfig (gcc-8): 1 warning
    pxa3xx_defconfig (gcc-8): 1 warning
    pxa910_defconfig (gcc-8): 1 warning
    pxa_defconfig (gcc-8): 1 warning
    qcom_defconfig (gcc-8): 1 warning
    realview_defconfig (gcc-8): 1 warning
    rpc_defconfig (gcc-8): 1 warning
    s3c2410_defconfig (gcc-8): 1 warning
    sama5_defconfig (gcc-8): 1 warning
    shannon_defconfig (gcc-8): 1 warning
    shmobile_defconfig (gcc-8): 1 warning
    simpad_defconfig (gcc-8): 1 warning
    socfpga_defconfig (gcc-8): 1 warning
    spear13xx_defconfig (gcc-8): 1 warning
    spitz_defconfig (gcc-8): 1 warning
    tegra_defconfig (gcc-8): 1 warning
    trizeps4_defconfig (gcc-8): 1 warning
    u8500_defconfig (gcc-8): 1 warning
    versatile_defconfig (gcc-8): 1 warning
    vexpress_defconfig (gcc-8): 1 warning
    viper_defconfig (gcc-8): 1 warning
    vt8500_v6_v7_defconfig (gcc-8): 1 warning
    xcep_defconfig (gcc-8): 1 warning
    zeus_defconfig (gcc-8): 1 warning

i386:
    i386_defconfig (gcc-8): 1 warning

mips:
    32r2el_defconfig (gcc-8): 2 warnings
    bigsur_defconfig (gcc-8): 1 warning
    bmips_be_defconfig (gcc-8): 1 warning
    bmips_stb_defconfig (gcc-8): 1 warning
    capcella_defconfig (gcc-8): 1 warning
    cavium_octeon_defconfig (gcc-8): 1 warning
    ci20_defconfig (gcc-8): 1 warning
    cobalt_defconfig (gcc-8): 1 warning
    cu1000-neo_defconfig (gcc-8): 1 warning
    cu1830-neo_defconfig (gcc-8): 1 warning
    db1xxx_defconfig (gcc-8): 1 warning
    decstation_64_defconfig (gcc-8): 1 warning
    decstation_defconfig (gcc-8): 1 warning
    decstation_r4k_defconfig (gcc-8): 1 warning
    fuloong2e_defconfig (gcc-8): 1 warning
    gpr_defconfig (gcc-8): 1 warning
    ip22_defconfig (gcc-8): 1 warning
    ip32_defconfig (gcc-8): 1 warning
    jazz_defconfig (gcc-8): 1 warning
    jmr3927_defconfig (gcc-8): 1 warning
    lemote2f_defconfig (gcc-8): 1 warning
    loongson1b_defconfig (gcc-8): 1 warning
    loongson1c_defconfig (gcc-8): 1 warning
    loongson3_defconfig (gcc-8): 1 warning
    malta_defconfig (gcc-8): 1 warning
    malta_kvm_defconfig (gcc-8): 1 warning
    malta_kvm_guest_defconfig (gcc-8): 1 warning
    malta_qemu_32r6_defconfig (gcc-8): 1 warning
    maltaaprp_defconfig (gcc-8): 1 warning
    maltasmvp_defconfig (gcc-8): 1 warning
    maltasmvp_eva_defconfig (gcc-8): 1 warning
    maltaup_defconfig (gcc-8): 1 warning
    maltaup_xpa_defconfig (gcc-8): 1 warning
    mpc30x_defconfig (gcc-8): 1 warning
    mtx1_defconfig (gcc-8): 1 warning
    nlm_xlp_defconfig (gcc-8): 1 warning
    nlm_xlr_defconfig (gcc-8): 1 warning
    pistachio_defconfig (gcc-8): 1 warning
    rbtx49xx_defconfig (gcc-8): 1 warning
    rm200_defconfig (gcc-8): 2 warnings
    sb1250_swarm_defconfig (gcc-8): 1 warning
    tb0219_defconfig (gcc-8): 1 warning
    tb0226_defconfig (gcc-8): 1 warning
    tb0287_defconfig (gcc-8): 1 warning
    workpad_defconfig (gcc-8): 1 warning

riscv:
    defconfig (gcc-8): 1 warning
    rv32_defconfig (gcc-8): 7 warnings

x86_64:
    allnoconfig (gcc-8): 1 warning
    tinyconfig (gcc-8): 1 warning
    x86_64_defconfig (gcc-8): 1 warning
    x86_64_defconfig+x86-chromebook (gcc-8): 1 warning


Warnings summary:

    132  fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined =
but not used [-Wunused-label]
    2    kernel/static_call.c:153:18: warning: unused variable =E2=80=98mod=
=E2=80=99 [-Wunused-variable]
    2    <stdin>:830:2: warning: #warning syscall fstat64 not implemented [=
-Wcpp]
    2    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [=
-Wcpp]
    2    <stdin>:1127:2: warning: #warning syscall fstatat64 not implemente=
d [-Wcpp]
    1    drivers/block/paride/bpck.c:32: warning: "PC" redefined
    1    arch/arm/mach-omap1/board-ams-delta.c:462:12: warning: =E2=80=98am=
s_delta_camera_power=E2=80=99 defined but not used [-Wunused-function]
    1    WARNING: modpost: Symbol info of vmlinux is missing. Unresolved sy=
mbol check will be entirely skipped.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
32r2el_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sect=
ion mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]
    WARNING: modpost: Symbol info of vmlinux is missing. Unresolved symbol =
check will be entirely skipped.

---------------------------------------------------------------------------=
-----
allnoconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
allnoconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    kernel/static_call.c:153:18: warning: unused variable =E2=80=98mod=E2=
=80=99 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
allnoconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
am200epdkit_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
ar7_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

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
assabet_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
at91_dt_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

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
axm55xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
axs103_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
axs103_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
badge4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
bcm2835_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

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
bigsur_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
bmips_stb_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, =
0 section mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
ci20_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
cm_x300_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
cobalt_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
colibri_pxa270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, =
0 section mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, =
0 section mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
collie_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
corgi_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
cu1000-neo_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
cu1830-neo_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
davinci_all_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
decstation_64_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, =
0 section mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
decstation_r4k_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning,=
 0 section mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
defconfig (riscv, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mis=
matches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
dove_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
e55_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
ep93xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
fuloong2e_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
gcw0_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
gemini_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
gpr_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
h3600_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

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
haps_hs_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
haps_hs_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
hisi_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
hsdk_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
i386_defconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
imote2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
imx_v4_v5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
imx_v6_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
integrator_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
iop32x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
ip22_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
ip32_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
ixp4xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
jmr3927_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
jornada720_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
keystone_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
lart_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
loongson1b_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
loongson1c_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
loongson3_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
lpc18xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
lpc32xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
lpd270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
lubbock_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
magician_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
mainstone_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
malta_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
malta_kvm_guest_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning=
, 0 section mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
malta_qemu_32r6_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning=
, 0 section mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
maltaaprp_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
maltasmvp_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, =
0 section mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
maltaup_xpa_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 =
section mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
milbeaut_m10v_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, =
0 section mismatches

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
mmp2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
moxart_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
mpc30x_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
mps2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
mtx1_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
multi_v4t_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
multi_v5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
mvebu_v5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
mvebu_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
mxs_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
neponset_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
netwinder_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
nhk8815_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
nommu_k210_defconfig (riscv, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
nommu_k210_sdcard_defconfig (riscv, gcc-8) =E2=80=94 PASS, 0 errors, 0 warn=
ings, 0 section mismatches

---------------------------------------------------------------------------=
-----
nsimosci_hs_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
nsimosci_hs_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning,=
 0 section mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
omap1_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sectio=
n mismatches

Warnings:
    arch/arm/mach-omap1/board-ams-delta.c:462:12: warning: =E2=80=98ams_del=
ta_camera_power=E2=80=99 defined but not used [-Wunused-function]
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
omega2p_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
orion5x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
oxnas_v6_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
palmz72_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
pcm027_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
pic32mzda_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
pistachio_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
pleb_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
pxa168_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
pxa255-idp_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
pxa3xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
pxa910_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
pxa_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
qcom_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
qi_lb60_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
rb532_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
rbtx49xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
realview_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 secti=
on mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]
    drivers/block/paride/bpck.c:32: warning: "PC" redefined

---------------------------------------------------------------------------=
-----
rpc_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
rs90_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
rv32_defconfig (riscv, gcc-8) =E2=80=94 PASS, 0 errors, 7 warnings, 0 secti=
on mismatches

Warnings:
    <stdin>:830:2: warning: #warning syscall fstat64 not implemented [-Wcpp]
    <stdin>:1127:2: warning: #warning syscall fstatat64 not implemented [-W=
cpp]
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]
    <stdin>:830:2: warning: #warning syscall fstat64 not implemented [-Wcpp]
    <stdin>:1127:2: warning: #warning syscall fstatat64 not implemented [-W=
cpp]
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
s3c2410_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

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
sama5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
sb1250_swarm_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0=
 section mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
shannon_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
shmobile_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
simpad_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
socfpga_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
spear13xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

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
spitz_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
stm32_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
tb0219_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
tb0226_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
tb0287_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
tct_hammer_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
tegra_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
tinyconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    kernel/static_call.c:153:18: warning: unused variable =E2=80=98mod=E2=
=80=99 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
tinyconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
trizeps4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
u8500_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
vdk_hs38_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
vdk_hs38_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 =
section mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
versatile_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
vexpress_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
vf610m4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
viper_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
vocore2_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
vt8500_v6_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 =
section mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
workpad_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
x86_64_defconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
x86_64_defconfig+x86-chromebook (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 1=
 warning, 0 section mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
xcep_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---------------------------------------------------------------------------=
-----
zeus_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    fs/nfs/read.c:388:1: warning: label =E2=80=98out=E2=80=99 defined but n=
ot used [-Wunused-label]

---
For more info write to <info@kernelci.org>
