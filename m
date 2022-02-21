Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95C194BD480
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 05:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235136AbiBUDz6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Feb 2022 22:55:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238715AbiBUDz4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Feb 2022 22:55:56 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AECDF51E66
        for <stable@vger.kernel.org>; Sun, 20 Feb 2022 19:55:31 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id y11so7595885pfa.6
        for <stable@vger.kernel.org>; Sun, 20 Feb 2022 19:55:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gzlZAkPhL1DzIqkylIJ6BneBDvh6z/7HMtDCMcU4fIE=;
        b=130cOkBnTjFIRnsI8rPYN9NhxXjEImzCx6fGxahnFFUoWlgTUXZP6GXT5kTN0/W9+N
         D7Gk8dAiK/NwLJ7UqqrT2Yy2XAssngB4SPpd8zgrpKNfORnGx7j27PJFBiZeR5Zfarxj
         TV1FblF6i+rvCQGEQSqgszKfJl5h/QOVCIl9MKCXIdCAvyrfkNI7nZN8HSece83nvuAW
         u7Mp84ebzc24xytf1OIcBCBZeq9THKHWH/pzdQ4jm0vx9tkomqF+xYlx+C9GeEKtB7AR
         GkWgcXxJiioBX8mlyriIxkfVxQRkGQWRgpic8CT8dy/oHgJDG4AwvQmUzAEEsPVpnLm+
         VHSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gzlZAkPhL1DzIqkylIJ6BneBDvh6z/7HMtDCMcU4fIE=;
        b=indXimhDySAxyQRXln1DeV8wzTI3RYcoI7MwGNBBNs0sGOFhRhpr1O5eOWmxIZUCzs
         y0xug8xBf9t51d3MOY3M8sJ/oUiDul5PK/BRE+D9J/v6RGviRU1TwhodzVIS8QeowN9J
         OPz5h/s1zQkOheS3V6U8AMeLy3Lyhph/o2HBWKAuet16zf/5iRS2JBYx54Stn1sTD3KJ
         ZlM/iPRTyagMokB3cSCb2mP/1mHvJt7InOlVHMfiZbG47DTok0xPe3+/tWk+lMyIhpQs
         lFyPufliPpgY+0x0ktZC+tRARBHwmh+t53jtEY6/mgltdmK04EZiBK9rZDS/9lYmCBD5
         45Kg==
X-Gm-Message-State: AOAM532No9aEXbBgRPdtYHIz5jiKxSnPdGJnIbuq/eY0OEHpq2Xk/vQr
        CFIdQ1pY4DVpa0v6DyfITHRlcIAZyaVSH/pt
X-Google-Smtp-Source: ABdhPJx+fTu0X59i+xIJ3rfbkUWU2noGgyMFSgOST+2VFzOVKiwaEr2GjpLV0kdd/+ncB3t0PUkbUg==
X-Received: by 2002:a05:6a00:1592:b0:4e0:529c:9770 with SMTP id u18-20020a056a00159200b004e0529c9770mr18285088pfk.54.1645415730410;
        Sun, 20 Feb 2022 19:55:30 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j9sm9566014pfj.13.2022.02.20.19.55.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Feb 2022 19:55:30 -0800 (PST)
Message-ID: <62130d32.1c69fb81.81162.ac61@mx.google.com>
Date:   Sun, 20 Feb 2022 19:55:30 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.101-96-g683a16ca38ef
Subject: stable-rc/queue/5.10 build: 164 builds: 125 failed, 39 passed,
 126 errors, 6 warnings (v5.10.101-96-g683a16ca38ef)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 build: 164 builds: 125 failed, 39 passed, 126 errors, =
6 warnings (v5.10.101-96-g683a16ca38ef)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F5.1=
0/kernel/v5.10.101-96-g683a16ca38ef/

Tree: stable-rc
Branch: queue/5.10
Git Describe: v5.10.101-96-g683a16ca38ef
Git Commit: 683a16ca38ef0307a1b025bae4e4bd8304c27956
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 7 unique architectures

Build Failures Detected:

arc:
    axs103_defconfig: (gcc-10) FAIL
    axs103_smp_defconfig: (gcc-10) FAIL
    haps_hs_defconfig: (gcc-10) FAIL
    haps_hs_smp_defconfig: (gcc-10) FAIL
    hsdk_defconfig: (gcc-10) FAIL
    nsimosci_hs_defconfig: (gcc-10) FAIL
    nsimosci_hs_smp_defconfig: (gcc-10) FAIL
    vdk_hs38_defconfig: (gcc-10) FAIL
    vdk_hs38_smp_defconfig: (gcc-10) FAIL

arm64:
    defconfig: (gcc-10) FAIL

arm:
    assabet_defconfig: (gcc-10) FAIL
    axm55xx_defconfig: (gcc-10) FAIL
    badge4_defconfig: (gcc-10) FAIL
    bcm2835_defconfig: (gcc-10) FAIL
    cerfcube_defconfig: (gcc-10) FAIL
    cm_x300_defconfig: (gcc-10) FAIL
    colibri_pxa270_defconfig: (gcc-10) FAIL
    colibri_pxa300_defconfig: (gcc-10) FAIL
    corgi_defconfig: (gcc-10) FAIL
    davinci_all_defconfig: (gcc-10) FAIL
    dove_defconfig: (gcc-10) FAIL
    ebsa110_defconfig: (gcc-10) FAIL
    ep93xx_defconfig: (gcc-10) FAIL
    eseries_pxa_defconfig: (gcc-10) FAIL
    exynos_defconfig: (gcc-10) FAIL
    ezx_defconfig: (gcc-10) FAIL
    footbridge_defconfig: (gcc-10) FAIL
    h3600_defconfig: (gcc-10) FAIL
    hisi_defconfig: (gcc-10) FAIL
    imote2_defconfig: (gcc-10) FAIL
    imx_v4_v5_defconfig: (gcc-10) FAIL
    imx_v6_v7_defconfig: (gcc-10) FAIL
    integrator_defconfig: (gcc-10) FAIL
    iop32x_defconfig: (gcc-10) FAIL
    ixp4xx_defconfig: (gcc-10) FAIL
    keystone_defconfig: (gcc-10) FAIL
    lart_defconfig: (gcc-10) FAIL
    lpc32xx_defconfig: (gcc-10) FAIL
    lpd270_defconfig: (gcc-10) FAIL
    lubbock_defconfig: (gcc-10) FAIL
    mainstone_defconfig: (gcc-10) FAIL
    mmp2_defconfig: (gcc-10) FAIL
    mps2_defconfig: (gcc-10) FAIL
    multi_v5_defconfig: (gcc-10) FAIL
    mv78xx0_defconfig: (gcc-10) FAIL
    mvebu_v5_defconfig: (gcc-10) FAIL
    mxs_defconfig: (gcc-10) FAIL
    neponset_defconfig: (gcc-10) FAIL
    netwinder_defconfig: (gcc-10) FAIL
    nhk8815_defconfig: (gcc-10) FAIL
    omap1_defconfig: (gcc-10) FAIL
    omap2plus_defconfig: (gcc-10) FAIL
    orion5x_defconfig: (gcc-10) FAIL
    pcm027_defconfig: (gcc-10) FAIL
    pleb_defconfig: (gcc-10) FAIL
    pxa168_defconfig: (gcc-10) FAIL
    pxa3xx_defconfig: (gcc-10) FAIL
    pxa910_defconfig: (gcc-10) FAIL
    pxa_defconfig: (gcc-10) FAIL
    qcom_defconfig: (gcc-10) FAIL
    realview_defconfig: (gcc-10) FAIL
    rpc_defconfig: (gcc-10) FAIL
    s3c2410_defconfig: (gcc-10) FAIL
    sama5_defconfig: (gcc-10) FAIL
    shannon_defconfig: (gcc-10) FAIL
    shmobile_defconfig: (gcc-10) FAIL
    simpad_defconfig: (gcc-10) FAIL
    socfpga_defconfig: (gcc-10) FAIL
    sunxi_defconfig: (gcc-10) FAIL
    tango4_defconfig: (gcc-10) FAIL
    tegra_defconfig: (gcc-10) FAIL
    trizeps4_defconfig: (gcc-10) FAIL
    versatile_defconfig: (gcc-10) FAIL
    vexpress_defconfig: (gcc-10) FAIL
    viper_defconfig: (gcc-10) FAIL
    vt8500_v6_v7_defconfig: (gcc-10) FAIL
    xcep_defconfig: (gcc-10) FAIL
    zeus_defconfig: (gcc-10) FAIL

i386:
    i386_defconfig: (gcc-10) FAIL

mips:
    32r2el_defconfig: (gcc-10) FAIL
    bigsur_defconfig: (gcc-10) FAIL
    bmips_be_defconfig: (gcc-10) FAIL
    bmips_stb_defconfig: (gcc-10) FAIL
    capcella_defconfig: (gcc-10) FAIL
    cavium_octeon_defconfig: (gcc-10) FAIL
    ci20_defconfig: (gcc-10) FAIL
    cobalt_defconfig: (gcc-10) FAIL
    cu1000-neo_defconfig: (gcc-10) FAIL
    cu1830-neo_defconfig: (gcc-10) FAIL
    db1xxx_defconfig: (gcc-10) FAIL
    decstation_64_defconfig: (gcc-10) FAIL
    decstation_defconfig: (gcc-10) FAIL
    decstation_r4k_defconfig: (gcc-10) FAIL
    fuloong2e_defconfig: (gcc-10) FAIL
    gpr_defconfig: (gcc-10) FAIL
    ip27_defconfig: (gcc-10) FAIL
    ip28_defconfig: (gcc-10) FAIL
    ip32_defconfig: (gcc-10) FAIL
    jazz_defconfig: (gcc-10) FAIL
    jmr3927_defconfig: (gcc-10) FAIL
    lemote2f_defconfig: (gcc-10) FAIL
    loongson1b_defconfig: (gcc-10) FAIL
    loongson3_defconfig: (gcc-10) FAIL
    malta_defconfig: (gcc-10) FAIL
    malta_kvm_defconfig: (gcc-10) FAIL
    malta_kvm_guest_defconfig: (gcc-10) FAIL
    malta_qemu_32r6_defconfig: (gcc-10) FAIL
    maltaaprp_defconfig: (gcc-10) FAIL
    maltasmvp_defconfig: (gcc-10) FAIL
    maltasmvp_eva_defconfig: (gcc-10) FAIL
    maltaup_defconfig: (gcc-10) FAIL
    maltaup_xpa_defconfig: (gcc-10) FAIL
    mpc30x_defconfig: (gcc-10) FAIL
    mtx1_defconfig: (gcc-10) FAIL
    nlm_xlp_defconfig: (gcc-10) FAIL
    nlm_xlr_defconfig: (gcc-10) FAIL
    pistachio_defconfig: (gcc-10) FAIL
    rbtx49xx_defconfig: (gcc-10) FAIL
    sb1250_swarm_defconfig: (gcc-10) FAIL
    tb0219_defconfig: (gcc-10) FAIL
    tb0226_defconfig: (gcc-10) FAIL
    workpad_defconfig: (gcc-10) FAIL

riscv:
    defconfig: (gcc-10) FAIL
    rv32_defconfig: (gcc-10) FAIL

x86_64:
    x86_64_defconfig+x86-chromebook: (gcc-10) FAIL

Errors and Warnings Detected:

arc:
    axs103_defconfig (gcc-10): 1 error
    axs103_smp_defconfig (gcc-10): 1 error
    haps_hs_defconfig (gcc-10): 1 error
    haps_hs_smp_defconfig (gcc-10): 1 error
    hsdk_defconfig (gcc-10): 1 error
    nsimosci_hs_defconfig (gcc-10): 1 error
    nsimosci_hs_smp_defconfig (gcc-10): 1 error
    vdk_hs38_defconfig (gcc-10): 1 error
    vdk_hs38_smp_defconfig (gcc-10): 1 error

arm64:
    defconfig (gcc-10): 1 error, 1 warning

arm:
    assabet_defconfig (gcc-10): 1 error
    axm55xx_defconfig (gcc-10): 1 error
    badge4_defconfig (gcc-10): 1 error
    bcm2835_defconfig (gcc-10): 1 error
    cerfcube_defconfig (gcc-10): 1 error
    cm_x300_defconfig (gcc-10): 1 error
    colibri_pxa270_defconfig (gcc-10): 1 error
    colibri_pxa300_defconfig (gcc-10): 1 error
    corgi_defconfig (gcc-10): 1 error
    davinci_all_defconfig (gcc-10): 1 error
    dove_defconfig (gcc-10): 1 error
    ebsa110_defconfig (gcc-10): 1 error
    ep93xx_defconfig (gcc-10): 1 error
    eseries_pxa_defconfig (gcc-10): 1 error
    exynos_defconfig (gcc-10): 1 error
    ezx_defconfig (gcc-10): 1 error
    footbridge_defconfig (gcc-10): 1 error
    h3600_defconfig (gcc-10): 1 error
    hisi_defconfig (gcc-10): 1 error
    imote2_defconfig (gcc-10): 1 error
    imx_v4_v5_defconfig (gcc-10): 1 error
    imx_v6_v7_defconfig (gcc-10): 1 error
    integrator_defconfig (gcc-10): 1 error
    iop32x_defconfig (gcc-10): 1 error
    ixp4xx_defconfig (gcc-10): 1 error
    keystone_defconfig (gcc-10): 1 error
    lart_defconfig (gcc-10): 1 error
    lpc32xx_defconfig (gcc-10): 1 error
    lpd270_defconfig (gcc-10): 1 error
    lubbock_defconfig (gcc-10): 1 error
    mainstone_defconfig (gcc-10): 1 error
    mmp2_defconfig (gcc-10): 1 error
    mps2_defconfig (gcc-10): 1 error
    multi_v5_defconfig (gcc-10): 1 error
    mv78xx0_defconfig (gcc-10): 1 error
    mvebu_v5_defconfig (gcc-10): 1 error
    mxs_defconfig (gcc-10): 1 error
    neponset_defconfig (gcc-10): 1 error
    netwinder_defconfig (gcc-10): 1 error
    nhk8815_defconfig (gcc-10): 1 error
    omap1_defconfig (gcc-10): 1 error
    omap2plus_defconfig (gcc-10): 1 error
    orion5x_defconfig (gcc-10): 1 error
    pcm027_defconfig (gcc-10): 1 error
    pleb_defconfig (gcc-10): 1 error
    pxa168_defconfig (gcc-10): 1 error
    pxa3xx_defconfig (gcc-10): 1 error
    pxa910_defconfig (gcc-10): 1 error
    pxa_defconfig (gcc-10): 1 error
    qcom_defconfig (gcc-10): 1 error
    realview_defconfig (gcc-10): 1 error
    rpc_defconfig (gcc-10): 4 errors
    s3c2410_defconfig (gcc-10): 1 error
    sama5_defconfig (gcc-10): 1 error
    shannon_defconfig (gcc-10): 1 error
    shmobile_defconfig (gcc-10): 1 error
    simpad_defconfig (gcc-10): 1 error
    socfpga_defconfig (gcc-10): 1 error
    sunxi_defconfig (gcc-10): 1 error
    tango4_defconfig (gcc-10): 1 error
    tegra_defconfig (gcc-10): 1 error
    trizeps4_defconfig (gcc-10): 1 error
    versatile_defconfig (gcc-10): 1 error
    vexpress_defconfig (gcc-10): 1 error
    viper_defconfig (gcc-10): 1 error
    vt8500_v6_v7_defconfig (gcc-10): 1 error
    xcep_defconfig (gcc-10): 1 error
    zeus_defconfig (gcc-10): 1 error

i386:
    i386_defconfig (gcc-10): 1 error

mips:
    32r2el_defconfig (gcc-10): 1 error
    bigsur_defconfig (gcc-10): 1 error
    bmips_be_defconfig (gcc-10): 1 error
    bmips_stb_defconfig (gcc-10): 1 error
    capcella_defconfig (gcc-10): 1 error
    cavium_octeon_defconfig (gcc-10): 1 error
    ci20_defconfig (gcc-10): 1 error
    cobalt_defconfig (gcc-10): 1 error
    cu1000-neo_defconfig (gcc-10): 1 error
    cu1830-neo_defconfig (gcc-10): 1 error
    db1xxx_defconfig (gcc-10): 1 error
    decstation_64_defconfig (gcc-10): 1 error, 1 warning
    decstation_defconfig (gcc-10): 1 error, 1 warning
    decstation_r4k_defconfig (gcc-10): 1 error, 1 warning
    fuloong2e_defconfig (gcc-10): 1 error
    gpr_defconfig (gcc-10): 1 error
    ip32_defconfig (gcc-10): 1 error
    jazz_defconfig (gcc-10): 1 error
    jmr3927_defconfig (gcc-10): 1 error
    lemote2f_defconfig (gcc-10): 1 error
    loongson1b_defconfig (gcc-10): 1 error
    loongson3_defconfig (gcc-10): 1 error
    malta_defconfig (gcc-10): 1 error
    malta_kvm_defconfig (gcc-10): 1 error
    malta_kvm_guest_defconfig (gcc-10): 1 error
    malta_qemu_32r6_defconfig (gcc-10): 1 error
    maltaaprp_defconfig (gcc-10): 1 error
    maltasmvp_defconfig (gcc-10): 1 error
    maltasmvp_eva_defconfig (gcc-10): 1 error
    maltaup_defconfig (gcc-10): 1 error
    maltaup_xpa_defconfig (gcc-10): 1 error
    mpc30x_defconfig (gcc-10): 1 error
    mtx1_defconfig (gcc-10): 1 error
    nlm_xlp_defconfig (gcc-10): 1 error
    nlm_xlr_defconfig (gcc-10): 1 error
    pistachio_defconfig (gcc-10): 1 error
    rbtx49xx_defconfig (gcc-10): 1 error
    sb1250_swarm_defconfig (gcc-10): 1 error
    tb0219_defconfig (gcc-10): 1 error
    tb0226_defconfig (gcc-10): 1 error
    workpad_defconfig (gcc-10): 1 error

riscv:
    defconfig (gcc-10): 1 error
    rv32_defconfig (gcc-10): 1 error, 2 warnings

x86_64:
    x86_64_defconfig+x86-chromebook (gcc-10): 1 error

Errors summary:

    113  fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99=
 has no member named =E2=80=98change_attr_type=E2=80=99
    9    fs/nfs/inode.c:1725:27: error: 'struct nfs_server' has no member n=
amed 'change_attr_type'
    2    arm-linux-gnueabihf-gcc: error: unrecognized -march target: armv3m
    2    arm-linux-gnueabihf-gcc: error: missing argument to =E2=80=98-marc=
h=3D=E2=80=99

Warnings summary:

    3    kernel/rcu/tasks.h:707:13: warning: =E2=80=98show_rcu_tasks_rude_g=
p_kthread=E2=80=99 defined but not used [-Wunused-function]
    1    drivers/tee/optee/core.c:726:6: warning: operation on =E2=80=98rc=
=E2=80=99 may be undefined [-Wsequence-point]
    1    <stdin>:830:2: warning: #warning syscall fstat64 not implemented [=
-Wcpp]
    1    <stdin>:1127:2: warning: #warning syscall fstatat64 not implemente=
d [-Wcpp]

Section mismatches summary:

    1    WARNING: modpost: vmlinux.o(.text+0xce9c): Section mismatch in ref=
erence from the function __arm_ioremap_pfn_caller() to the function .memini=
t.text:memblock_is_map_memory()
    1    WARNING: modpost: vmlinux.o(.text+0xcd38): Section mismatch in ref=
erence from the function __arm_ioremap_pfn_caller() to the function .memini=
t.text:memblock_is_map_memory()
    1    WARNING: modpost: vmlinux.o(.text+0xcb74): Section mismatch in ref=
erence from the function __arm_ioremap_pfn_caller() to the function .memini=
t.text:memblock_is_map_memory()
    1    WARNING: modpost: vmlinux.o(.text+0xcaa8): Section mismatch in ref=
erence from the function __arm_ioremap_pfn_caller() to the function .memini=
t.text:memblock_is_map_memory()
    1    WARNING: modpost: vmlinux.o(.text+0xc8ec): Section mismatch in ref=
erence from the function __arm_ioremap_pfn_caller() to the function .memini=
t.text:memblock_is_map_memory()
    1    WARNING: modpost: vmlinux.o(.text+0x7670): Section mismatch in ref=
erence from the function __arm_ioremap_pfn_caller() to the function .memini=
t.text:memblock_is_map_memory()

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
32r2el_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
allnoconfig (i386, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
allnoconfig (x86_64, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
am200epdkit_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
aspeed_g4_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
assabet_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
ath25_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
ath79_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
axm55xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
axs103_defconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: 'struct nfs_server' has no member named =
'change_attr_type'

---------------------------------------------------------------------------=
-----
axs103_smp_defconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: 'struct nfs_server' has no member named =
'change_attr_type'

---------------------------------------------------------------------------=
-----
badge4_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xcd38): Section mismatch in referenc=
e from the function __arm_ioremap_pfn_caller() to the function .meminit.tex=
t:memblock_is_map_memory()

---------------------------------------------------------------------------=
-----
bcm2835_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
bcm47xx_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
bcm63xx_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
bigsur_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
bmips_stb_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings,=
 0 section mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0x7670): Section mismatch in referenc=
e from the function __arm_ioremap_pfn_caller() to the function .meminit.tex=
t:memblock_is_map_memory()

---------------------------------------------------------------------------=
-----
ci20_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
cm_x300_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
cobalt_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
colibri_pxa270_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings,=
 0 section mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings,=
 0 section mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
corgi_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
cu1000-neo_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 =
section mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
cu1830-neo_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 =
section mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
davinci_all_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 =
section mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
decstation_64_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, =
0 section mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

Warnings:
    kernel/rcu/tasks.h:707:13: warning: =E2=80=98show_rcu_tasks_rude_gp_kth=
read=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 s=
ection mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

Warnings:
    kernel/rcu/tasks.h:707:13: warning: =E2=80=98show_rcu_tasks_rude_gp_kth=
read=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
decstation_r4k_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning,=
 0 section mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

Warnings:
    kernel/rcu/tasks.h:707:13: warning: =E2=80=98show_rcu_tasks_rude_gp_kth=
read=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mis=
matches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

Warnings:
    drivers/tee/optee/core.c:726:6: warning: operation on =E2=80=98rc=E2=80=
=99 may be undefined [-Wsequence-point]

---------------------------------------------------------------------------=
-----
defconfig (riscv, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section mi=
smatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
dove_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
e55_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
ebsa110_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
ep93xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 =
section mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section =
mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
fuloong2e_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
gcw0_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
gemini_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
gpr_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
h3600_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
h5000_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
hackkit_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xce9c): Section mismatch in referenc=
e from the function __arm_ioremap_pfn_caller() to the function .meminit.tex=
t:memblock_is_map_memory()

---------------------------------------------------------------------------=
-----
haps_hs_defconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: 'struct nfs_server' has no member named =
'change_attr_type'

---------------------------------------------------------------------------=
-----
haps_hs_smp_defconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 =
section mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: 'struct nfs_server' has no member named =
'change_attr_type'

---------------------------------------------------------------------------=
-----
hisi_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
hsdk_defconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: 'struct nfs_server' has no member named =
'change_attr_type'

---------------------------------------------------------------------------=
-----
i386_defconfig (i386, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
imote2_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
imx_v4_v5_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
imx_v6_v7_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
integrator_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
iop32x_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
ip27_defconfig (mips, gcc-10) =E2=80=94 FAIL, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
ip28_defconfig (mips, gcc-10) =E2=80=94 FAIL, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
ip32_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
ixp4xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
jmr3927_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
jornada720_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xcaa8): Section mismatch in referenc=
e from the function __arm_ioremap_pfn_caller() to the function .meminit.tex=
t:memblock_is_map_memory()

---------------------------------------------------------------------------=
-----
keystone_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
lart_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xcb74): Section mismatch in referenc=
e from the function __arm_ioremap_pfn_caller() to the function .meminit.tex=
t:memblock_is_map_memory()

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
loongson1b_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 =
section mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
loongson3_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
lpc18xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
lpc32xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
lpd270_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
lubbock_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
mainstone_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
malta_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
malta_kvm_guest_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warning=
s, 0 section mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
malta_qemu_32r6_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warning=
s, 0 section mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
maltaaprp_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
maltasmvp_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings,=
 0 section mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
maltaup_xpa_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0=
 section mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
milbeaut_m10v_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
mmp2_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
moxart_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
mpc30x_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
mps2_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
mtx1_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
multi_v4t_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
multi_v5_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
mv78xx0_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
mvebu_v5_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
mxs_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section =
mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
neponset_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
netwinder_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
nhk8815_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
nommu_k210_defconfig (riscv, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, =
0 section mismatches

---------------------------------------------------------------------------=
-----
nsimosci_hs_defconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 =
section mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: 'struct nfs_server' has no member named =
'change_attr_type'

---------------------------------------------------------------------------=
-----
nsimosci_hs_smp_defconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings=
, 0 section mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: 'struct nfs_server' has no member named =
'change_attr_type'

---------------------------------------------------------------------------=
-----
omap1_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
omega2p_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
orion5x_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
palmz72_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
pcm027_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
pic32mzda_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
pistachio_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
pleb_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xc8ec): Section mismatch in referenc=
e from the function __arm_ioremap_pfn_caller() to the function .meminit.tex=
t:memblock_is_map_memory()

---------------------------------------------------------------------------=
-----
prima2_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
pxa168_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
pxa3xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
pxa910_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
pxa_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section =
mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
qcom_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
qi_lb60_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
rb532_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
rbtx49xx_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
realview_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
rpc_defconfig (arm, gcc-10) =E2=80=94 FAIL, 4 errors, 0 warnings, 0 section=
 mismatches

Errors:
    arm-linux-gnueabihf-gcc: error: unrecognized -march target: armv3m
    arm-linux-gnueabihf-gcc: error: missing argument to =E2=80=98-march=3D=
=E2=80=99
    arm-linux-gnueabihf-gcc: error: unrecognized -march target: armv3m
    arm-linux-gnueabihf-gcc: error: missing argument to =E2=80=98-march=3D=
=E2=80=99

---------------------------------------------------------------------------=
-----
rs90_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
rv32_defconfig (riscv, gcc-10) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

Warnings:
    <stdin>:830:2: warning: #warning syscall fstat64 not implemented [-Wcpp]
    <stdin>:1127:2: warning: #warning syscall fstatat64 not implemented [-W=
cpp]

---------------------------------------------------------------------------=
-----
s3c2410_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
s3c6400_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
s5pv210_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
sama5_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
sb1250_swarm_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, =
0 section mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
shannon_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
shmobile_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
simpad_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
socfpga_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
spear3xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
stm32_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
sunxi_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
tango4_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
tb0219_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
tb0226_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
tegra_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
tinyconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
tinyconfig (i386, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
trizeps4_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
u300_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
vdk_hs38_defconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: 'struct nfs_server' has no member named =
'change_attr_type'

---------------------------------------------------------------------------=
-----
vdk_hs38_smp_defconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0=
 section mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: 'struct nfs_server' has no member named =
'change_attr_type'

---------------------------------------------------------------------------=
-----
versatile_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
vexpress_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
vf610m4_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
viper_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
vocore2_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
vt8500_v6_v7_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0=
 section mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
workpad_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
x86_64_defconfig+x86-chromebook (x86_64, gcc-10) =E2=80=94 FAIL, 1 error, 0=
 warnings, 0 section mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
xcep_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
zeus_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    fs/nfs/inode.c:1725:27: error: =E2=80=98struct nfs_server=E2=80=99 has =
no member named =E2=80=98change_attr_type=E2=80=99

---------------------------------------------------------------------------=
-----
zx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---
For more info write to <info@kernelci.org>
