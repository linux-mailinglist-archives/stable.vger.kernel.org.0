Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 137A4EE184
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 14:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbfKDNvG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 08:51:06 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38418 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727838AbfKDNvF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Nov 2019 08:51:05 -0500
Received: by mail-wr1-f67.google.com with SMTP id v9so17181144wrq.5
        for <stable@vger.kernel.org>; Mon, 04 Nov 2019 05:50:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GXmloimjSZbQzM0o0wO47+prPCTol+NiurvanPKHwHg=;
        b=mT1lh/YagF92yl0rE3ILsh0n6n/45j6H4IXxtkgF+bFfqVogukfxRIhCuqu7f6vf/1
         fn3Tycbm2mY5ZxMqiKD5X2faLJVUwTYvhMuYMS0RhxAUJSqUGWEtbCBlJwVfvGg9CS0T
         3LzZhcNjb/5FfhY7uja4TH4A6aYVdF7D+Yox0jk63mTs3D8yduvB+d51o08DMzHIhbeK
         TWZ8bCEK+gr+uBeRSetbY2Yuo/QjE6sUeXsHsvSRasfyf2Op+769nmuvbEtf7+ZfG+pf
         MARt/2Ty9axQ6HyBh9C8qMcnKIjib3GHegkxMDPpLyjV0hneiJzyUsomaLhwoivUQFb9
         A32Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GXmloimjSZbQzM0o0wO47+prPCTol+NiurvanPKHwHg=;
        b=dQHtkmbdZITKhYS0hXJb4Pxq/3CZ0eZXHhBb2KZSAIBTyvyHpg4EnoM3ENARX2RYsN
         IkQAqGgnsIJ5ds2Rm2nftYP3PZDY+tONcE6abeGsGyhNpjHydvdq8aPL3NekwNHnTJh9
         ZMlU5q+p6d4HXVGNKGrd/Vj+MjZY3QlEldV4KdWjbO4JKcrAR4K8AaAf4VQKQsuoXofn
         rOji/apsJSv09vwNenvICaXUxskmb5AQMihH9LvIOlb36wAxyQw57T1mLrcU7+hG4PDV
         2aCkVNQZAxah0cWq/NMGjMVIUdnEZcaVgUiXMXWs/Bjlz3DsD/AZZg+QaVfsk2TNsybR
         Rttg==
X-Gm-Message-State: APjAAAWOJGdWXQ0Lqtu1D0sEZMDp7iivuPlvLsyAfqO7YiXr1bXjcGsj
        qROUDYw7WafVZSaFxe0ZM6lTB2xyw6VPzA==
X-Google-Smtp-Source: APXvYqzHn6c+ZtDQh4CxgK6UYjmYniQKd1JMQdyqEJ7Vt+xfxb1KeF8sviAHdF5eRgLoMxl81tTYJg==
X-Received: by 2002:adf:9e92:: with SMTP id a18mr22771951wrf.34.1572875454870;
        Mon, 04 Nov 2019 05:50:54 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g184sm21381274wma.8.2019.11.04.05.50.53
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 05:50:54 -0800 (PST)
Message-ID: <5dc02cbe.1c69fb81.5af5b.90c8@mx.google.com>
Date:   Mon, 04 Nov 2019 05:50:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v4.19.81-145-g7d816e1d91b0
Subject: stable-rc/linux-4.19.y build: 206 builds: 78 failed, 128 passed,
 159 errors, 6 warnings (v4.19.81-145-g7d816e1d91b0)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y build: 206 builds: 78 failed, 128 passed, 159 errors=
, 6 warnings (v4.19.81-145-g7d816e1d91b0)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.81-145-g7d816e1d91b0/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.81-145-g7d816e1d91b0
Git Commit: 7d816e1d91b01911392b7f8f93a4a153b9af60d3
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 7 unique architectures

Build Failures Detected:

arc:
    hsdk_defconfig: (gcc-8) FAIL

arm64:
    allnoconfig: (gcc-8) FAIL
    defconfig: (gcc-8) FAIL
    tinyconfig: (gcc-8) FAIL

arm:
    aspeed_g4_defconfig: (gcc-8) FAIL
    aspeed_g5_defconfig: (gcc-8) FAIL
    at91_dt_defconfig: (gcc-8) FAIL
    bcm2835_defconfig: (gcc-8) FAIL
    colibri_pxa300_defconfig: (gcc-8) FAIL
    corgi_defconfig: (gcc-8) FAIL
    davinci_all_defconfig: (gcc-8) FAIL
    ebsa110_defconfig: (gcc-8) FAIL
    ep93xx_defconfig: (gcc-8) FAIL
    exynos_defconfig: (gcc-8) FAIL
    ezx_defconfig: (gcc-8) FAIL
    gemini_defconfig: (gcc-8) FAIL
    hisi_defconfig: (gcc-8) FAIL
    imote2_defconfig: (gcc-8) FAIL
    imx_v6_v7_defconfig: (gcc-8) FAIL
    iop13xx_defconfig: (gcc-8) FAIL
    iop32x_defconfig: (gcc-8) FAIL
    iop33x_defconfig: (gcc-8) FAIL
    keystone_defconfig: (gcc-8) FAIL
    lpc32xx_defconfig: (gcc-8) FAIL
    lpd270_defconfig: (gcc-8) FAIL
    multi_v5_defconfig: (gcc-8) FAIL
    multi_v7_defconfig: (gcc-8) FAIL
    mvebu_v7_defconfig: (gcc-8) FAIL
    netx_defconfig: (gcc-8) FAIL
    omap1_defconfig: (gcc-8) FAIL
    omap2plus_defconfig: (gcc-8) FAIL
    oxnas_v6_defconfig: (gcc-8) FAIL
    raumfeld_defconfig: (gcc-8) FAIL
    rpc_defconfig: (gcc-8) FAIL
    s3c2410_defconfig: (gcc-8) FAIL
    s5pv210_defconfig: (gcc-8) FAIL
    sama5_defconfig: (gcc-8) FAIL
    shmobile_defconfig: (gcc-8) FAIL
    socfpga_defconfig: (gcc-8) FAIL
    spear13xx_defconfig: (gcc-8) FAIL
    spitz_defconfig: (gcc-8) FAIL
    tegra_defconfig: (gcc-8) FAIL
    u8500_defconfig: (gcc-8) FAIL
    vt8500_v6_v7_defconfig: (gcc-8) FAIL

i386:
    i386_defconfig: (gcc-8) FAIL

mips:
    32r2el_defconfig: (gcc-8) FAIL
    bcm47xx_defconfig: (gcc-8) FAIL
    bigsur_defconfig: (gcc-8) FAIL
    bmips_be_defconfig: (gcc-8) FAIL
    bmips_stb_defconfig: (gcc-8) FAIL
    cavium_octeon_defconfig: (gcc-8) FAIL
    db1xxx_defconfig: (gcc-8) FAIL
    decstation_defconfig: (gcc-8) FAIL
    gcw0_defconfig: (gcc-8) FAIL
    ip22_defconfig: (gcc-8) FAIL
    ip27_defconfig: (gcc-8) FAIL
    ip32_defconfig: (gcc-8) FAIL
    jazz_defconfig: (gcc-8) FAIL
    lemote2f_defconfig: (gcc-8) FAIL
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
    mtx1_defconfig: (gcc-8) FAIL
    nlm_xlp_defconfig: (gcc-8) FAIL
    nlm_xlr_defconfig: (gcc-8) FAIL
    pistachio_defconfig: (gcc-8) FAIL
    rm200_defconfig: (gcc-8) FAIL

riscv:
    defconfig: (gcc-8) FAIL

x86_64:
    x86_64_defconfig: (gcc-8) FAIL

Errors and Warnings Detected:

arc:
    hsdk_defconfig (gcc-8): 2 errors

arm64:
    allnoconfig (gcc-8): 1 error
    defconfig (gcc-8): 1 error
    tinyconfig (gcc-8): 1 error

arm:
    aspeed_g4_defconfig (gcc-8): 2 errors
    aspeed_g5_defconfig (gcc-8): 2 errors
    at91_dt_defconfig (gcc-8): 2 errors
    bcm2835_defconfig (gcc-8): 2 errors
    colibri_pxa300_defconfig (gcc-8): 5 errors
    corgi_defconfig (gcc-8): 2 errors
    davinci_all_defconfig (gcc-8): 2 errors
    ebsa110_defconfig (gcc-8): 2 errors
    ep93xx_defconfig (gcc-8): 5 errors
    exynos_defconfig (gcc-8): 2 errors
    ezx_defconfig (gcc-8): 2 errors
    gemini_defconfig (gcc-8): 2 errors
    hisi_defconfig (gcc-8): 2 errors
    imote2_defconfig (gcc-8): 2 errors
    imx_v6_v7_defconfig (gcc-8): 2 errors
    iop13xx_defconfig (gcc-8): 2 errors
    iop32x_defconfig (gcc-8): 2 errors
    iop33x_defconfig (gcc-8): 2 errors
    keystone_defconfig (gcc-8): 2 errors
    lpc32xx_defconfig (gcc-8): 2 errors
    lpd270_defconfig (gcc-8): 2 errors
    multi_v5_defconfig (gcc-8): 2 errors
    multi_v7_defconfig (gcc-8): 2 errors
    mvebu_v7_defconfig (gcc-8): 2 errors
    netx_defconfig (gcc-8): 2 errors
    omap1_defconfig (gcc-8): 2 errors
    omap2plus_defconfig (gcc-8): 2 errors
    oxnas_v6_defconfig (gcc-8): 2 errors
    raumfeld_defconfig (gcc-8): 2 errors
    rpc_defconfig (gcc-8): 2 errors
    s3c2410_defconfig (gcc-8): 2 errors
    s5pv210_defconfig (gcc-8): 2 errors
    sama5_defconfig (gcc-8): 2 errors
    shmobile_defconfig (gcc-8): 2 errors
    socfpga_defconfig (gcc-8): 2 errors
    spear13xx_defconfig (gcc-8): 2 errors
    spitz_defconfig (gcc-8): 2 errors
    tegra_defconfig (gcc-8): 2 errors
    u8500_defconfig (gcc-8): 2 errors
    vt8500_v6_v7_defconfig (gcc-8): 2 errors

i386:
    i386_defconfig (gcc-8): 2 errors

mips:
    32r2el_defconfig (gcc-8): 2 errors
    bcm47xx_defconfig (gcc-8): 2 errors
    bigsur_defconfig (gcc-8): 2 errors
    bmips_be_defconfig (gcc-8): 2 errors
    bmips_stb_defconfig (gcc-8): 2 errors
    cavium_octeon_defconfig (gcc-8): 2 errors
    db1xxx_defconfig (gcc-8): 2 errors
    decstation_defconfig (gcc-8): 2 errors
    gcw0_defconfig (gcc-8): 2 errors
    ip22_defconfig (gcc-8): 2 errors
    ip27_defconfig (gcc-8): 2 errors
    ip32_defconfig (gcc-8): 2 errors
    jazz_defconfig (gcc-8): 2 errors
    lemote2f_defconfig (gcc-8): 2 errors, 1 warning
    loongson3_defconfig (gcc-8): 2 errors, 2 warnings
    malta_defconfig (gcc-8): 2 errors
    malta_kvm_defconfig (gcc-8): 2 errors
    malta_kvm_guest_defconfig (gcc-8): 2 errors
    malta_qemu_32r6_defconfig (gcc-8): 2 errors, 1 warning
    maltaaprp_defconfig (gcc-8): 2 errors
    maltasmvp_defconfig (gcc-8): 2 errors
    maltasmvp_eva_defconfig (gcc-8): 2 errors
    maltaup_defconfig (gcc-8): 2 errors
    maltaup_xpa_defconfig (gcc-8): 2 errors
    markeins_defconfig (gcc-8): 2 errors
    mips_paravirt_defconfig (gcc-8): 2 errors
    mtx1_defconfig (gcc-8): 2 errors
    nlm_xlp_defconfig (gcc-8): 2 errors, 1 warning
    nlm_xlr_defconfig (gcc-8): 2 errors
    pistachio_defconfig (gcc-8): 2 errors
    rm200_defconfig (gcc-8): 2 errors

riscv:
    defconfig (gcc-8): 2 errors

x86_64:
    tinyconfig (gcc-8): 1 warning
    x86_64_defconfig (gcc-8): 2 errors

Errors summary:

    75   net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared =
(first use in this function); did you mean 'alloc_netdev'?
    75   net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared =
(first use in this function); did you mean 'alloc_netdev'?
    3    arch/arm64/kernel/cpufeature.c:909:21: error: 'MIDR_HISI_TSV110' u=
ndeclared (first use in this function); did you mean 'GICR_ISACTIVER0'?
    2    net/ipv6/route.c:395:41: error: 'blackhole_netdev' undeclared (fir=
st use in this function); did you mean 'alloc_netdev'?
    2    net/ipv6/route.c:181:19: error: 'loopback_dev' undeclared (first u=
se in this function); did you mean 'loopback_net_ops'?
    2    net/ipv6/route.c:176:33: error: 'blackhole_netdev' undeclared (fir=
st use in this function); did you mean 'alloc_netdev'?

Warnings summary:

    3    net/core/rtnetlink.c:3160:1: warning: the frame size of 1312 bytes=
 is larger than 1024 bytes [-Wframe-larger-than=3D]
    1    {standard input}:131: Warning: macro instruction expanded into mul=
tiple instructions
    1    arch/mips/configs/loongson3_defconfig:55:warning: symbol value 'm'=
 invalid for HOTPLUG_PCI_SHPC
    1    .config:1007:warning: override: UNWINDER_GUESS changes choice state

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
32r2el_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

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
allnoconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
allnoconfig (arm64, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section m=
ismatches

Errors:
    arch/arm64/kernel/cpufeature.c:909:21: error: 'MIDR_HISI_TSV110' undecl=
ared (first use in this function); did you mean 'GICR_ISACTIVER0'?

---------------------------------------------------------------------------=
-----
allnoconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
allnoconfig (riscv, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

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
ar7_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
aspeed_g4_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
aspeed_g5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
assabet_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
at91_dt_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

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
bcm2835_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
bcm47xx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
bcm63xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
bigsur_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
bmips_stb_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings,=
 0 section mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
ci20_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

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
cobalt_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
colibri_pxa270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm, gcc-8) =E2=80=94 FAIL, 5 errors, 0 warnings,=
 0 section mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/route.c:176:33: error: 'blackhole_netdev' undeclared (first us=
e in this function); did you mean 'alloc_netdev'?
    net/ipv6/route.c:181:19: error: 'loopback_dev' undeclared (first use in=
 this function); did you mean 'loopback_net_ops'?
    net/ipv6/route.c:395:41: error: 'blackhole_netdev' undeclared (first us=
e in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
collie_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
corgi_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
davinci_all_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 =
section mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 =
section mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
defconfig (riscv, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 section mi=
smatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section mis=
matches

Errors:
    arch/arm64/kernel/cpufeature.c:909:21: error: 'MIDR_HISI_TSV110' undecl=
ared (first use in this function); did you mean 'GICR_ISACTIVER0'?

---------------------------------------------------------------------------=
-----
dove_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
e55_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
ebsa110_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

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
ep93xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 5 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/route.c:176:33: error: 'blackhole_netdev' undeclared (first us=
e in this function); did you mean 'alloc_netdev'?
    net/ipv6/route.c:181:19: error: 'loopback_dev' undeclared (first use in=
 this function); did you mean 'loopback_net_ops'?
    net/ipv6/route.c:395:41: error: 'blackhole_netdev' undeclared (first us=
e in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 section =
mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
fuloong2e_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
gcw0_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
gemini_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
gpr_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

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
haps_hs_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
haps_hs_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
hisi_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 section=
 mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
hsdk_defconfig (arc, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 section=
 mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
i386_defconfig (i386, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
imote2_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
imx_v4_v5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
imx_v6_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
integrator_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
iop13xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
iop32x_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
iop33x_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
ip22_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
ip27_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
ip28_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
ip32_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
ixp4xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
jmr3927_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
jornada720_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
keystone_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

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
lasat_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

Warnings:
    net/core/rtnetlink.c:3160:1: warning: the frame size of 1312 bytes is l=
arger than 1024 bytes [-Wframe-larger-than=3D]

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
loongson3_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 2 warnings, 0 s=
ection mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

Warnings:
    arch/mips/configs/loongson3_defconfig:55:warning: symbol value 'm' inva=
lid for HOTPLUG_PCI_SHPC
    net/core/rtnetlink.c:3160:1: warning: the frame size of 1312 bytes is l=
arger than 1024 bytes [-Wframe-larger-than=3D]

---------------------------------------------------------------------------=
-----
lpc18xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
lpc32xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
lpd270_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

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
malta_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
malta_kvm_guest_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warning=
s, 0 section mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
malta_qemu_32r6_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning=
, 0 section mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

Warnings:
    {standard input}:131: Warning: macro instruction expanded into multiple=
 instructions

---------------------------------------------------------------------------=
-----
maltaaprp_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
maltasmvp_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings,=
 0 section mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
maltaup_xpa_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0=
 section mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
markeins_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
mips_paravirt_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings,=
 0 section mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

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
mtx1_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
multi_v4t_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
multi_v5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

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
mvebu_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

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
netx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 section=
 mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
nhk8815_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

Warnings:
    net/core/rtnetlink.c:3160:1: warning: the frame size of 1312 bytes is l=
arger than 1024 bytes [-Wframe-larger-than=3D]

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

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
omap1_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
omega2p_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
orion5x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
oxnas_v6_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

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
pic32mzda_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
pistachio_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
pleb_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
pnx8335_stb225_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

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
qi_lb60_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
raumfeld_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

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
realview_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
rpc_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 section =
mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
s3c2410_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
s3c6400_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
s5pv210_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
sama5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
sb1250_swarm_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, =
0 section mismatches

---------------------------------------------------------------------------=
-----
shannon_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
shmobile_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
simpad_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
socfpga_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
spear13xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

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
spitz_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

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
tango4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
tb0219_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

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
tct_hammer_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
tegra_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
tinyconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    .config:1007:warning: override: UNWINDER_GUESS changes choice state

---------------------------------------------------------------------------=
-----
tinyconfig (arm64, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section mi=
smatches

Errors:
    arch/arm64/kernel/cpufeature.c:909:21: error: 'MIDR_HISI_TSV110' undecl=
ared (first use in this function); did you mean 'GICR_ISACTIVER0'?

---------------------------------------------------------------------------=
-----
tinyconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
tinyconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
tinyconfig (riscv, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

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
u8500_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

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
vocore2_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
vt8500_v6_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0=
 section mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
workpad_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
x86_64_defconfig (x86_64, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
xcep_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
xway_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

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
