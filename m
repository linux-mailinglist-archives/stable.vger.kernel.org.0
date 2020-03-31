Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDBB319957B
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 13:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730436AbgCaLnZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 07:43:25 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46710 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730426AbgCaLnY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Mar 2020 07:43:24 -0400
Received: by mail-pl1-f196.google.com with SMTP id s23so8014584plq.13
        for <stable@vger.kernel.org>; Tue, 31 Mar 2020 04:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1ceZImnA7PmjDH5wTHc38uUFXKmMP+RjG4SiQDsZpoU=;
        b=YMNJsa2O8ICQrN+izyF9bNKfCvTSol2hjKGUyGLo8b98KNnm3TQp8gWgy9ySVStbUr
         HmRPq8FDfx2WjXj8qGisB+r81QS5fnO7izjmWX0zW4SUA0m5Ai09+VWU/Q11s3AdvBW1
         S2o/h6HMGmKgCI4Npb4vZBDNhxBeHOrOvfrzHkTuZ1Sg9pNgh5Cwk4pIrxbHT+8DlK9f
         Fcqd/UcfpjdeOp6z6xn0lUKm3sP9Qy7dtiaaQJCroFvRoYgq2D55z5FpKGrkuaKjgBhG
         NxcxCzu39mYFaONv/UQwyT9oC5efwC9Am4Z9nDQZbzIBLd2KfdTXZTgi+cq8uxpIz1/N
         s2Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1ceZImnA7PmjDH5wTHc38uUFXKmMP+RjG4SiQDsZpoU=;
        b=Ve2bulGFSzf3IC/oA8SDxZdwBmrQZCLwvdKpuNvd1RIHfGg6tjj4bJQESD9fSHUiJH
         pCSHGL0gcTCk0yrZI1RFaH7SrcEEChTMp5hgdrUa4SBOOoBOy+PMNcoDSAcKo/rslIA3
         7yjTFRxNc0YPKCYvP4o0CvrZmeSpJgkLPhwMNoLSJvAE9+DGZJkMubUKOBgc1fA+3yB/
         Ux30cL2sSU2dc4lojLcL4Zdz58y1niidFOaZNviQKaC3+0gpXLV/xs0Mod9eE4VORjAm
         /+zZJnfdGj7Ip9uQQ4WQtTNPlLwjb1DlEsEt9yDtvda1fC+JbnDofPO8WEsbhqdH9KgF
         I0sw==
X-Gm-Message-State: AGi0PuZrbg2HwNtu2+lQl9grLmHLFczR/puTf9DO353sAFwI/VPJLIs+
        hUtP3CFSjaBlyelk3ZvBmvEToqQ4+x8=
X-Google-Smtp-Source: APiQypKzQgjRWkP7H0aWjw3MS3LA+mmKFHgQaBrAFo3y+Iz4c1VhCfYojrqwzE4ADbzKkdnZRNdPfA==
X-Received: by 2002:a17:90a:208:: with SMTP id c8mr3459975pjc.153.1585655002920;
        Tue, 31 Mar 2020 04:43:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i17sm12442817pfo.103.2020.03.31.04.43.22
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2020 04:43:22 -0700 (PDT)
Message-ID: <5e832cda.1c69fb81.384fa.7eb5@mx.google.com>
Date:   Tue, 31 Mar 2020 04:43:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.28-156-gad8c851af8dd
X-Kernelci-Report-Type: build
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.4.y build: 200 builds: 1 failed, 199 passed, 1 error,
 107 warnings (v5.4.28-156-gad8c851af8dd)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y build: 200 builds: 1 failed, 199 passed, 1 error, 107=
 warnings (v5.4.28-156-gad8c851af8dd)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.28-156-gad8c851af8dd/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.28-156-gad8c851af8dd
Git Commit: ad8c851af8dd71602e714ada9fd2bb8526ef36b1
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 7 unique architectures

Build Failure Detected:

mips:
    ip27_defconfig: (gcc-8) FAIL

Errors and Warnings Detected:

arc:
    allnoconfig (gcc-8): 1 warning
    axs103_defconfig (gcc-8): 2 warnings
    axs103_smp_defconfig (gcc-8): 2 warnings
    haps_hs_defconfig (gcc-8): 2 warnings
    haps_hs_smp_defconfig (gcc-8): 2 warnings
    hsdk_defconfig (gcc-8): 2 warnings
    nsim_hs_defconfig (gcc-8): 2 warnings
    nsim_hs_smp_defconfig (gcc-8): 2 warnings
    nsimosci_hs_defconfig (gcc-8): 2 warnings
    nsimosci_hs_smp_defconfig (gcc-8): 2 warnings
    tinyconfig (gcc-8): 1 warning
    vdk_hs38_defconfig (gcc-8): 1 warning
    vdk_hs38_smp_defconfig (gcc-8): 1 warning

arm64:
    defconfig (gcc-8): 12 warnings

arm:
    am200epdkit_defconfig (gcc-8): 1 warning
    assabet_defconfig (gcc-8): 1 warning
    at91_dt_defconfig (gcc-8): 1 warning
    axm55xx_defconfig (gcc-8): 1 warning
    cm_x2xx_defconfig (gcc-8): 1 warning
    cm_x300_defconfig (gcc-8): 1 warning
    cns3420vb_defconfig (gcc-8): 1 warning
    colibri_pxa270_defconfig (gcc-8): 1 warning
    colibri_pxa300_defconfig (gcc-8): 1 warning
    collie_defconfig (gcc-8): 1 warning
    davinci_all_defconfig (gcc-8): 1 warning
    dove_defconfig (gcc-8): 1 warning
    em_x270_defconfig (gcc-8): 1 warning
    ep93xx_defconfig (gcc-8): 1 warning
    eseries_pxa_defconfig (gcc-8): 1 warning
    exynos_defconfig (gcc-8): 1 warning
    ezx_defconfig (gcc-8): 1 warning
    h3600_defconfig (gcc-8): 1 warning
    h5000_defconfig (gcc-8): 1 warning
    imote2_defconfig (gcc-8): 1 warning
    imx_v4_v5_defconfig (gcc-8): 1 warning
    imx_v6_v7_defconfig (gcc-8): 1 warning
    integrator_defconfig (gcc-8): 1 warning
    ixp4xx_defconfig (gcc-8): 1 warning
    keystone_defconfig (gcc-8): 1 warning
    lpc32xx_defconfig (gcc-8): 1 warning
    magician_defconfig (gcc-8): 1 warning
    milbeaut_m10v_defconfig (gcc-8): 1 warning
    mini2440_defconfig (gcc-8): 1 warning
    mmp2_defconfig (gcc-8): 1 warning
    multi_v5_defconfig (gcc-8): 1 warning
    multi_v7_defconfig (gcc-8): 1 warning
    mv78xx0_defconfig (gcc-8): 1 warning
    mvebu_v5_defconfig (gcc-8): 1 warning
    mvebu_v7_defconfig (gcc-8): 1 warning
    mxs_defconfig (gcc-8): 1 warning
    neponset_defconfig (gcc-8): 1 warning
    nhk8815_defconfig (gcc-8): 1 warning
    omap1_defconfig (gcc-8): 1 warning
    omap2plus_defconfig (gcc-8): 1 warning
    orion5x_defconfig (gcc-8): 1 warning
    oxnas_v6_defconfig (gcc-8): 1 warning
    palmz72_defconfig (gcc-8): 1 warning
    pcm027_defconfig (gcc-8): 1 warning
    prima2_defconfig (gcc-8): 1 warning
    pxa168_defconfig (gcc-8): 1 warning
    pxa3xx_defconfig (gcc-8): 1 warning
    pxa910_defconfig (gcc-8): 1 warning
    qcom_defconfig (gcc-8): 1 warning
    realview_defconfig (gcc-8): 1 warning
    s3c6400_defconfig (gcc-8): 1 warning
    s5pv210_defconfig (gcc-8): 1 warning
    sama5_defconfig (gcc-8): 1 warning
    shannon_defconfig (gcc-8): 1 warning
    spear13xx_defconfig (gcc-8): 1 warning
    sunxi_defconfig (gcc-8): 1 warning
    tango4_defconfig (gcc-8): 1 warning
    tegra_defconfig (gcc-8): 1 warning
    trizeps4_defconfig (gcc-8): 1 warning
    u300_defconfig (gcc-8): 1 warning
    u8500_defconfig (gcc-8): 1 warning
    versatile_defconfig (gcc-8): 1 warning
    vexpress_defconfig (gcc-8): 1 warning
    viper_defconfig (gcc-8): 1 warning
    xcep_defconfig (gcc-8): 1 warning
    zeus_defconfig (gcc-8): 1 warning

i386:

mips:
    ip27_defconfig (gcc-8): 1 error

riscv:
    rv32_defconfig (gcc-8): 6 warnings

x86_64:
    tinyconfig (gcc-8): 1 warning

Errors summary:

    1    arch/mips/pci/pci-xtalk-bridge.c:287:9: error: =E2=80=98struct bri=
dge_irq_chip_data=E2=80=99 has no member named =E2=80=98nnasid=E2=80=99; di=
d you mean =E2=80=98nasid=E2=80=99?

Warnings summary:

    61   WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL
    24   <stdin>:1511:2: warning: #warning syscall clone3 not implemented [=
-Wcpp]
    5    drivers/video/fbdev/sa1100fb.c:975:21: warning: =E2=80=98sa1100fb_=
min_dma_period=E2=80=99 defined but not used [-Wunused-function]
    2    arch/arm64/boot/dts/exynos/exynos5433.dtsi:254.3-29: Warning (reg_=
format): /gpu@14ac0000:reg: property has invalid length (8 bytes) (#address=
-cells =3D=3D 2, #size-cells =3D=3D 2)
    2    <stdin>:830:2: warning: #warning syscall fstat64 not implemented [=
-Wcpp]
    2    <stdin>:1127:2: warning: #warning syscall fstatat64 not implemente=
d [-Wcpp]
    1    arch/arm64/boot/dts/exynos/exynos7.dtsi:83.3-29: Warning (reg_form=
at): /gpu@14ac0000:reg: property has invalid length (8 bytes) (#address-cel=
ls =3D=3D 2, #size-cells =3D=3D 2)
    1    arch/arm64/boot/dts/exynos/exynos7-espresso.dtb: Warning (spi_bus_=
reg): Failed prerequisite 'reg_format'
    1    arch/arm64/boot/dts/exynos/exynos7-espresso.dtb: Warning (pci_devi=
ce_bus_num): Failed prerequisite 'reg_format'
    1    arch/arm64/boot/dts/exynos/exynos7-espresso.dtb: Warning (i2c_bus_=
reg): Failed prerequisite 'reg_format'
    1    arch/arm64/boot/dts/exynos/exynos5433-tm2e.dtb: Warning (spi_bus_r=
eg): Failed prerequisite 'reg_format'
    1    arch/arm64/boot/dts/exynos/exynos5433-tm2e.dtb: Warning (pci_devic=
e_bus_num): Failed prerequisite 'reg_format'
    1    arch/arm64/boot/dts/exynos/exynos5433-tm2e.dtb: Warning (i2c_bus_r=
eg): Failed prerequisite 'reg_format'
    1    arch/arm64/boot/dts/exynos/exynos5433-tm2.dtb: Warning (spi_bus_re=
g): Failed prerequisite 'reg_format'
    1    arch/arm64/boot/dts/exynos/exynos5433-tm2.dtb: Warning (pci_device=
_bus_num): Failed prerequisite 'reg_format'
    1    arch/arm64/boot/dts/exynos/exynos5433-tm2.dtb: Warning (i2c_bus_re=
g): Failed prerequisite 'reg_format'
    1    .config:1157:warning: override: UNWINDER_GUESS changes choice state

Section mismatches summary:

    1    WARNING: vmlinux.o(.text.unlikely+0x3598): Section mismatch in ref=
erence from the function pmax_setup_memory_region() to the function .init.t=
ext:add_memory_region()
    1    WARNING: vmlinux.o(.text.unlikely+0x321c): Section mismatch in ref=
erence from the function pmax_setup_memory_region() to the function .init.t=
ext:add_memory_region()

---
For more info write to <info@kernelci.org>
