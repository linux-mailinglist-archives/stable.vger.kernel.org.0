Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 226C81930C
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbfEITv3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 15:51:29 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:41968 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726704AbfEITv2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 May 2019 15:51:28 -0400
Received: by mail-wr1-f44.google.com with SMTP id d12so4642754wrm.8
        for <stable@vger.kernel.org>; Thu, 09 May 2019 12:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wteTlXODirZH6YIeN6GaPjVjl6BiOSGYoJ38qN/bRdc=;
        b=y8MOLGOGsmQE8DOVKPFJMANMNhXaQAL6Q0eoryimD6k0E9OiNijApnnqfjVUrKJybW
         DmhdLQBJlaGj6B5VFNq7c++z4k93H3KaVpWT4n9gA93QmqO0vLamHUBIKT/UcG2o7MBE
         UqxmSP8+0K2qlveHXZFIvcmAweR5HsvoPwkJ4YVsyvg1f8H9F7nBBSO44JGaVZMMFQWF
         C1ui42Jo1e9aGQAXIFmoJUUdGmzZkoBAG81jhNQaj8Q1Vt2cbTXbHm0Xis9giAseZ8Qe
         MpU/yLC/7SfFuT/1zA/aGYO4Z+1vhtqlsAVL+bQZd9VRlcX0l4210g6c/udrAX1K4FrP
         2PZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wteTlXODirZH6YIeN6GaPjVjl6BiOSGYoJ38qN/bRdc=;
        b=NdmfDlMDRXdAZEtswHZOTodW5V1EFQb1/1zCOQVRKGujrUFwVC7kM/+bGThZ5XoeLY
         Lhm/yESqJRuJhuePrY9zN0ap03gOvc0pfcWxOtzCICbaVz3wKPKdVI4ixOE/9/CTODPm
         p+7pgHi5IhYs0fgZHoThS6bkO+80MuAyQgJ7qi2JZQG13jNF/xveO3qQsab4tI4QzIp9
         sip88qYj1GHehuKOjMHhxnBU2/NebPDZIdzqhuLbEgzOOlLAFT2hbkQwcRQHncu0eGrx
         zURSN1Hj0F73uYmFQeXf93IYN3ac+46GNvjLBG/mKohs4GdbPh+8YtnniGohLv5aWKsU
         7qZw==
X-Gm-Message-State: APjAAAUc/EZXnIMvk1E/C9oQzwFBTQ5cVsjDhuf9/iB59C5KAfFFQ1r4
        XvjpuMIKZlrbC6upW2dSc+uYwkBx6R7lTw==
X-Google-Smtp-Source: APXvYqzy+XP1YHlhCPgUcM+Q/MsmUIHLr4HGQlhSwkwFA5uDrEHidodVC33b03EXFu8l1anAdwUaog==
X-Received: by 2002:adf:8068:: with SMTP id 95mr4411542wrk.174.1557431459717;
        Thu, 09 May 2019 12:50:59 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s3sm5023448wre.97.2019.05.09.12.50.58
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 12:50:58 -0700 (PDT)
Message-ID: <5cd484a2.1c69fb81.4d3c0.9924@mx.google.com>
Date:   Thu, 09 May 2019 12:50:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Kernel: v4.4.179-160-g2c68c4c9b112
Subject: stable-rc/linux-4.4.y build: 190 builds: 15 failed, 175 passed,
 37 errors, 3938 warnings (v4.4.179-160-g2c68c4c9b112)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y build: 190 builds: 15 failed, 175 passed, 37 errors, =
3938 warnings (v4.4.179-160-g2c68c4c9b112)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.179-160-g2c68c4c9b112/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.179-160-g2c68c4c9b112
Git Commit: 2c68c4c9b1128c52fd9915bf8529f31601fc81b6
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 6 unique architectures

Build Failures Detected:

arc:    arc-linux-gcc (ARC HS GNU/Linux glibc toolchain 2018.09-rc1) 8.2.1 =
20180814

    axs103_defconfig: FAIL
    axs103_smp_defconfig: FAIL
    nsim_hs_defconfig: FAIL
    nsim_hs_smp_defconfig: FAIL
    nsimosci_hs_defconfig: FAIL
    nsimosci_hs_smp_defconfig: FAIL

mips:    mips-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0

    bigsur_defconfig: FAIL
    decstation_defconfig: FAIL
    ip27_defconfig: FAIL
    ip28_defconfig: FAIL
    jmr3927_defconfig: FAIL
    malta_kvm_guest_defconfig: FAIL
    nlm_xlr_defconfig: FAIL
    sb1250_swarm_defconfig: FAIL
    sead3micro_defconfig: FAIL

Errors and Warnings Detected:

arc:    arc-linux-gcc (ARC HS GNU/Linux glibc toolchain 2018.09-rc1) 8.2.1 =
20180814

    allnoconfig: 679 warnings
    axs103_defconfig: 3 warnings
    axs103_smp_defconfig: 3 warnings
    nsim_hs_defconfig: 3 warnings
    nsim_hs_smp_defconfig: 3 warnings
    nsimosci_hs_defconfig: 3 warnings
    nsimosci_hs_smp_defconfig: 3 warnings
    tinyconfig: 683 warnings
    vdk_hs38_defconfig: 20 warnings
    vdk_hs38_smp_defconfig: 21 warnings

arm64:    aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0

    tinyconfig: 1 warning

arm:    arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0

    clps711x_defconfig: 1 warning
    davinci_all_defconfig: 1 warning
    lpc32xx_defconfig: 1 warning
    multi_v7_defconfig: 1 warning
    mxs_defconfig: 1 warning
    omap2plus_defconfig: 1 warning

mips:    mips-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0

    allnoconfig: 49 warnings
    ar7_defconfig: 49 warnings
    ath79_defconfig: 49 warnings
    bcm47xx_defconfig: 49 warnings
    bcm63xx_defconfig: 49 warnings
    bigsur_defconfig: 16 errors, 5 warnings
    bmips_be_defconfig: 49 warnings
    bmips_stb_defconfig: 49 warnings
    capcella_defconfig: 49 warnings
    cavium_octeon_defconfig: 49 warnings
    ci20_defconfig: 49 warnings
    cobalt_defconfig: 49 warnings
    db1xxx_defconfig: 49 warnings
    decstation_defconfig: 1 error
    e55_defconfig: 49 warnings
    fuloong2e_defconfig: 49 warnings
    gpr_defconfig: 49 warnings
    ip22_defconfig: 49 warnings
    ip32_defconfig: 49 warnings
    jazz_defconfig: 49 warnings
    jmr3927_defconfig: 1 error
    lasat_defconfig: 49 warnings
    lemote2f_defconfig: 49 warnings
    loongson3_defconfig: 49 warnings
    ls1b_defconfig: 49 warnings
    malta_defconfig: 49 warnings
    malta_kvm_defconfig: 49 warnings
    malta_qemu_32r6_defconfig: 49 warnings
    maltaaprp_defconfig: 49 warnings
    maltasmvp_defconfig: 49 warnings
    maltasmvp_eva_defconfig: 49 warnings
    maltaup_defconfig: 49 warnings
    maltaup_xpa_defconfig: 49 warnings
    markeins_defconfig: 49 warnings
    mips_paravirt_defconfig: 49 warnings
    mpc30x_defconfig: 49 warnings
    msp71xx_defconfig: 49 warnings
    mtx1_defconfig: 49 warnings
    nlm_xlp_defconfig: 49 warnings
    nlm_xlr_defconfig: 1 error, 1 warning
    pistachio_defconfig: 49 warnings
    pnx8335_stb225_defconfig: 49 warnings
    qi_lb60_defconfig: 49 warnings
    rb532_defconfig: 49 warnings
    rbtx49xx_defconfig: 49 warnings
    rm200_defconfig: 49 warnings
    rt305x_defconfig: 49 warnings
    sb1250_swarm_defconfig: 16 errors, 5 warnings
    sead3_defconfig: 49 warnings
    sead3micro_defconfig: 2 errors
    tb0219_defconfig: 49 warnings
    tb0226_defconfig: 49 warnings
    tb0287_defconfig: 49 warnings
    tinyconfig: 49 warnings
    workpad_defconfig: 49 warnings
    xilfpga_defconfig: 49 warnings
    xway_defconfig: 49 warnings

Errors summary:

    2    include/linux/swiotlb.h:96:21: error: 'enum dma_data_direction' de=
clared inside parameter list will not be visible outside of this definition=
 or declaration [-Werror]
    2    include/linux/swiotlb.h:92:26: error: 'enum dma_data_direction' de=
clared inside parameter list will not be visible outside of this definition=
 or declaration [-Werror]
    2    include/linux/swiotlb.h:87:27: error: 'enum dma_data_direction' de=
clared inside parameter list will not be visible outside of this definition=
 or declaration [-Werror]
    2    include/linux/swiotlb.h:83:13: error: 'enum dma_data_direction' de=
clared inside parameter list will not be visible outside of this definition=
 or declaration [-Werror]
    2    include/linux/swiotlb.h:79:9: error: 'enum dma_data_direction' dec=
lared inside parameter list will not be visible outside of this definition =
or declaration [-Werror]
    2    include/linux/swiotlb.h:75:14: error: 'enum dma_data_direction' de=
clared inside parameter list will not be visible outside of this definition=
 or declaration [-Werror]
    2    include/linux/swiotlb.h:70:29: error: 'enum dma_data_direction' de=
clared inside parameter list will not be visible outside of this definition=
 or declaration [-Werror]
    2    include/linux/swiotlb.h:67:13: error: 'enum dma_data_direction' de=
clared inside parameter list will not be visible outside of this definition=
 or declaration [-Werror]
    2    include/linux/swiotlb.h:65:63: error: 'struct page' declared insid=
e parameter list will not be visible outside of this definition or declarat=
ion [-Werror]
    2    include/linux/swiotlb.h:53:27: error: 'enum dma_data_direction' de=
clared inside parameter list will not be visible outside of this definition=
 or declaration [-Werror]
    2    include/linux/swiotlb.h:49:28: error: 'enum dma_data_direction' de=
clared inside parameter list will not be visible outside of this definition=
 or declaration [-Werror]
    2    include/linux/swiotlb.h:45:13: error: 'enum dma_data_direction' de=
clared inside parameter list will not be visible outside of this definition=
 or declaration [-Werror]
    2    include/linux/swiotlb.h:113:20: error: expected '=3D', ',', ';', '=
asm' or '__attribute__' before 'swiotlb_free'
    2    include/linux/swiotlb.h:104:24: error: 'enum dma_data_direction' d=
eclared inside parameter list will not be visible outside of this definitio=
n or declaration [-Werror]
    2    include/linux/swiotlb.h:100:29: error: 'enum dma_data_direction' d=
eclared inside parameter list will not be visible outside of this definitio=
n or declaration [-Werror]
    2    arch/mips/sibyte/common/dma.c:11:13: error: expected '=3D', ',', '=
;', 'asm' or '__attribute__' before 'plat_swiotlb_setup'
    1    cc1: error: '-march=3Dr3900' requires '-mfp32'
    1    cc1: error: '-march=3Dr3000' requires '-mfp32'
    1    arch/mips/kernel/genex.S:271: Error: branch to a symbol in another=
 ISA mode
    1    arch/mips/kernel/genex.S:152: Error: branch to a symbol in another=
 ISA mode
    1    arch/mips/include/asm/netlogic/xlr/fmn.h:304:22: error: bitwise co=
mparison always evaluates to false [-Werror=3Dtautological-compare]

Warnings summary:

    2193  arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean exp=
ression [-Wbool-operation]
    707  arc-linux-gcc: warning: '-mno-mpy' is deprecated
    670  cc1: warning: '-mno-mpy' is deprecated
    306  arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expr=
ession [-Wbool-operation]
    18   fs/ext4/ext4_jbd2.h:411:1: warning: control reaches end of non-voi=
d function [-Wreturn-type]
    8    warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOT=
LB_XEN && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (C=
AVIUM_OCTEON_SOC || MACH_LOONGSON64 && CPU_LOONGSON3 || NLM_XLP_BOARD || NL=
M_XLR_BOARD)
    7    warning: (ARC) selects HAVE_FUTEX_CMPXCHG which has unmet direct d=
ependencies (FUTEX)
    4    kernel/sched/core.c:3089:1: warning: control reaches end of non-vo=
id function [-Wreturn-type]
    3    cc1: all warnings being treated as errors
    2    net/core/ethtool.c:260:1: warning: control reaches end of non-void=
 function [-Wreturn-type]
    2    include/linux/sunrpc/svc_xprt.h:174:1: warning: control reaches en=
d of non-void function [-Wreturn-type]
    2    fs/posix_acl.c:34:1: warning: control reaches end of non-void func=
tion [-Wreturn-type]
    2    drivers/mfd/omap-usb-tll.c:88:53: warning: overflow in conversion =
from 'int' to 'u8' {aka 'unsigned char'} changes value from 'i * 256 + 2070=
' to '22' [-Woverflow]
    2    drivers/base/regmap/regmap-mmio.c:86:1: warning: control reaches e=
nd of non-void function [-Wreturn-type]
    2    block/cfq-iosched.c:3783:1: warning: control reaches end of non-vo=
id function [-Wreturn-type]
    2    arch/arc/kernel/unwind.c:186:14: warning: 'unw_hdr_alloc' defined =
but not used [-Wunused-function]
    2    arch/arc/include/asm/elf.h:58:29: warning: integer overflow in exp=
ression of type 'int' results in '-1073741824' [-Woverflow]
    1    lib/cpumask.c:178:1: warning: control reaches end of non-void func=
tion [-Wreturn-type]
    1    arch/arm64/kernel/vdso.c:118:6: warning: 'memcmp' reading 4 bytes =
from a region of size 1 [-Wstringop-overflow=3D]
    1    arch/arm/mach-mxs/mach-mxs.c:285:26: warning: duplicate 'const' de=
claration specifier [-Wduplicate-decl-specifier]
    1    arch/arm/mach-lpc32xx/phy3250.c:215:36: warning: duplicate 'const'=
 declaration specifier [-Wduplicate-decl-specifier]
    1    arch/arm/mach-davinci/da8xx-dt.c:23:34: warning: duplicate 'const'=
 declaration specifier [-Wduplicate-decl-specifier]
    1    arch/arm/mach-clps711x/board-autcpu12.c:163:26: warning: duplicate=
 'const' declaration specifier [-Wduplicate-decl-specifier]

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

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
allnoconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 679 warnings, 0 section =
mismatches

Warnings:
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    warning: (ARC) selects HAVE_FUTEX_CMPXCHG which has unmet direct depend=
encies (FUTEX)
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    warning: (ARC) selects HAVE_FUTEX_CMPXCHG which has unmet direct depend=
encies (FUTEX)
    warning: (ARC) selects HAVE_FUTEX_CMPXCHG which has unmet direct depend=
encies (FUTEX)
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    kernel/sched/core.c:3089:1: warning: control reaches end of non-void fu=
nction [-Wreturn-type]
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated

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
allnoconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings, 0 section =
mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

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
am200epdkit_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
ar7_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings, 0 sectio=
n mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

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
ath79_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings, 0 sect=
ion mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
axm55xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
axs103_defconfig (arc, gcc-8) =E2=80=94 FAIL, 0 errors, 3 warnings, 0 secti=
on mismatches

Warnings:
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated

---------------------------------------------------------------------------=
-----
axs103_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 0 errors, 3 warnings, 0 s=
ection mismatches

Warnings:
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated

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
bcm47xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings, 0 se=
ction mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
bcm63xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings, 0 se=
ction mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
bcm_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
bigsur_defconfig (mips, gcc-8) =E2=80=94 FAIL, 16 errors, 5 warnings, 0 sec=
tion mismatches

Errors:
    include/linux/swiotlb.h:45:13: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:49:28: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:53:27: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:67:13: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:65:63: error: 'struct page' declared inside par=
ameter list will not be visible outside of this definition or declaration [=
-Werror]
    include/linux/swiotlb.h:70:29: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:75:14: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:79:9: error: 'enum dma_data_direction' declared=
 inside parameter list will not be visible outside of this definition or de=
claration [-Werror]
    include/linux/swiotlb.h:83:13: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:87:27: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:92:26: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:96:21: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:100:29: error: 'enum dma_data_direction' declar=
ed inside parameter list will not be visible outside of this definition or =
declaration [-Werror]
    include/linux/swiotlb.h:104:24: error: 'enum dma_data_direction' declar=
ed inside parameter list will not be visible outside of this definition or =
declaration [-Werror]
    include/linux/swiotlb.h:113:20: error: expected '=3D', ',', ';', 'asm' =
or '__attribute__' before 'swiotlb_free'
    arch/mips/sibyte/common/dma.c:11:13: error: expected '=3D', ',', ';', '=
asm' or '__attribute__' before 'plat_swiotlb_setup'

Warnings:
    warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XE=
N && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM=
_OCTEON_SOC || MACH_LOONGSON64 && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR=
_BOARD)
    warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XE=
N && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM=
_OCTEON_SOC || MACH_LOONGSON64 && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR=
_BOARD)
    warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XE=
N && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM=
_OCTEON_SOC || MACH_LOONGSON64 && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR=
_BOARD)
    warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XE=
N && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM=
_OCTEON_SOC || MACH_LOONGSON64 && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR=
_BOARD)
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings, 0 s=
ection mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
bmips_stb_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings, 0 =
section mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings, 0 s=
ection mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings=
, 0 section mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
ci20_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings, 0 secti=
on mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
clps711x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    arch/arm/mach-clps711x/board-autcpu12.c:163:26: warning: duplicate 'con=
st' declaration specifier [-Wduplicate-decl-specifier]

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
cobalt_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings, 0 sec=
tion mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

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
davinci_all_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    arch/arm/mach-davinci/da8xx-dt.c:23:34: warning: duplicate 'const' decl=
aration specifier [-Wduplicate-decl-specifier]

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings, 0 sec=
tion mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    cc1: error: '-march=3Dr3000' requires '-mfp32'

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
e55_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings, 0 sectio=
n mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

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
fuloong2e_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings, 0 =
section mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
gpr_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings, 0 sectio=
n mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

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
ip22_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings, 0 secti=
on mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
ip27_defconfig (mips, gcc-8) =E2=80=94 FAIL, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
ip28_defconfig (mips, gcc-8) =E2=80=94 FAIL, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
ip32_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings, 0 secti=
on mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
ixp4xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings, 0 secti=
on mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
jmr3927_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    cc1: error: '-march=3Dr3900' requires '-mfp32'

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
lasat_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings, 0 sect=
ion mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings, 0 s=
ection mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
loongson3_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings, 0 =
section mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
lpc18xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
lpc32xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    arch/arm/mach-lpc32xx/phy3250.c:215:36: warning: duplicate 'const' decl=
aration specifier [-Wduplicate-decl-specifier]

---------------------------------------------------------------------------=
-----
lpd270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
ls1b_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings, 0 secti=
on mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

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
malta_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings, 0 sect=
ion mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings, 0 =
section mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
malta_kvm_guest_defconfig (mips, gcc-8) =E2=80=94 FAIL, 0 errors, 0 warning=
s, 0 section mismatches

---------------------------------------------------------------------------=
-----
malta_qemu_32r6_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnin=
gs, 0 section mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
maltaaprp_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings, 0 =
section mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
maltasmvp_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings, 0 =
section mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings=
, 0 section mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings, 0 se=
ction mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
maltaup_xpa_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings, =
0 section mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
markeins_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings, 0 s=
ection mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
mips_paravirt_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings=
, 0 section mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

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
mpc30x_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings, 0 sec=
tion mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
msp71xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings, 0 se=
ction mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
mtx1_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings, 0 secti=
on mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
multi_v5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    drivers/mfd/omap-usb-tll.c:88:53: warning: overflow in conversion from =
'int' to 'u8' {aka 'unsigned char'} changes value from 'i * 256 + 2070' to =
'22' [-Woverflow]

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
mxs_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    arch/arm/mach-mxs/mach-mxs.c:285:26: warning: duplicate 'const' declara=
tion specifier [-Wduplicate-decl-specifier]

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
nlm_xlp_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings, 0 se=
ction mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    arch/mips/include/asm/netlogic/xlr/fmn.h:304:22: error: bitwise compari=
son always evaluates to false [-Werror=3Dtautological-compare]

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
nsim_hs_defconfig (arc, gcc-8) =E2=80=94 FAIL, 0 errors, 3 warnings, 0 sect=
ion mismatches

Warnings:
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated

---------------------------------------------------------------------------=
-----
nsim_hs_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 0 errors, 3 warnings, 0 =
section mismatches

Warnings:
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated

---------------------------------------------------------------------------=
-----
nsimosci_hs_defconfig (arc, gcc-8) =E2=80=94 FAIL, 0 errors, 3 warnings, 0 =
section mismatches

Warnings:
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated

---------------------------------------------------------------------------=
-----
nsimosci_hs_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 0 errors, 3 warnings=
, 0 section mismatches

Warnings:
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated

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
omap2plus_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    drivers/mfd/omap-usb-tll.c:88:53: warning: overflow in conversion from =
'int' to 'u8' {aka 'unsigned char'} changes value from 'i * 256 + 2070' to =
'22' [-Woverflow]

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
pistachio_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings, 0 =
section mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
pleb_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
pnx8335_stb225_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warning=
s, 0 section mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

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
qcom_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
qi_lb60_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings, 0 se=
ction mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
raumfeld_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
rb532_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings, 0 sect=
ion mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
rbtx49xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings, 0 s=
ection mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
realview-smp_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
realview_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings, 0 sect=
ion mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
rpc_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings, 0 sec=
tion mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

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
sb1250_swarm_defconfig (mips, gcc-8) =E2=80=94 FAIL, 16 errors, 5 warnings,=
 0 section mismatches

Errors:
    include/linux/swiotlb.h:45:13: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:49:28: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:53:27: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:67:13: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:65:63: error: 'struct page' declared inside par=
ameter list will not be visible outside of this definition or declaration [=
-Werror]
    include/linux/swiotlb.h:70:29: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:75:14: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:79:9: error: 'enum dma_data_direction' declared=
 inside parameter list will not be visible outside of this definition or de=
claration [-Werror]
    include/linux/swiotlb.h:83:13: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:87:27: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:92:26: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:96:21: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:100:29: error: 'enum dma_data_direction' declar=
ed inside parameter list will not be visible outside of this definition or =
declaration [-Werror]
    include/linux/swiotlb.h:104:24: error: 'enum dma_data_direction' declar=
ed inside parameter list will not be visible outside of this definition or =
declaration [-Werror]
    include/linux/swiotlb.h:113:20: error: expected '=3D', ',', ';', 'asm' =
or '__attribute__' before 'swiotlb_free'
    arch/mips/sibyte/common/dma.c:11:13: error: expected '=3D', ',', ';', '=
asm' or '__attribute__' before 'plat_swiotlb_setup'

Warnings:
    warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XE=
N && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM=
_OCTEON_SOC || MACH_LOONGSON64 && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR=
_BOARD)
    warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XE=
N && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM=
_OCTEON_SOC || MACH_LOONGSON64 && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR=
_BOARD)
    warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XE=
N && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM=
_OCTEON_SOC || MACH_LOONGSON64 && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR=
_BOARD)
    warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XE=
N && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM=
_OCTEON_SOC || MACH_LOONGSON64 && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR=
_BOARD)
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
sead3_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings, 0 sect=
ion mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
sead3micro_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 =
section mismatches

Errors:
    arch/mips/kernel/genex.S:152: Error: branch to a symbol in another ISA =
mode
    arch/mips/kernel/genex.S:271: Error: branch to a symbol in another ISA =
mode

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
tb0219_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings, 0 sec=
tion mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
tb0226_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings, 0 sec=
tion mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
tb0287_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings, 0 sec=
tion mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

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
tinyconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mi=
smatches

Warnings:
    arch/arm64/kernel/vdso.c:118:6: warning: 'memcmp' reading 4 bytes from =
a region of size 1 [-Wstringop-overflow=3D]

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
tinyconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings, 0 section m=
ismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
tinyconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 683 warnings, 0 section m=
ismatches

Warnings:
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    warning: (ARC) selects HAVE_FUTEX_CMPXCHG which has unmet direct depend=
encies (FUTEX)
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    warning: (ARC) selects HAVE_FUTEX_CMPXCHG which has unmet direct depend=
encies (FUTEX)
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    warning: (ARC) selects HAVE_FUTEX_CMPXCHG which has unmet direct depend=
encies (FUTEX)
    warning: (ARC) selects HAVE_FUTEX_CMPXCHG which has unmet direct depend=
encies (FUTEX)
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    kernel/sched/core.c:3089:1: warning: control reaches end of non-void fu=
nction [-Wreturn-type]
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated

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
vdk_hs38_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 20 warnings, 0 se=
ction mismatches

Warnings:
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    arch/arc/kernel/unwind.c:186:14: warning: 'unw_hdr_alloc' defined but n=
ot used [-Wunused-function]
    kernel/sched/core.c:3089:1: warning: control reaches end of non-void fu=
nction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:411:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:411:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:411:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    block/cfq-iosched.c:3783:1: warning: control reaches end of non-void fu=
nction [-Wreturn-type]
    drivers/base/regmap/regmap-mmio.c:86:1: warning: control reaches end of=
 non-void function [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:411:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:411:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:411:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:411:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:411:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    net/core/ethtool.c:260:1: warning: control reaches end of non-void func=
tion [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:411:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    include/linux/sunrpc/svc_xprt.h:174:1: warning: control reaches end of =
non-void function [-Wreturn-type]
    arch/arc/include/asm/elf.h:58:29: warning: integer overflow in expressi=
on of type 'int' results in '-1073741824' [-Woverflow]
    fs/posix_acl.c:34:1: warning: control reaches end of non-void function =
[-Wreturn-type]

---------------------------------------------------------------------------=
-----
vdk_hs38_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 21 warnings, =
0 section mismatches

Warnings:
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    arch/arc/kernel/unwind.c:186:14: warning: 'unw_hdr_alloc' defined but n=
ot used [-Wunused-function]
    fs/ext4/ext4_jbd2.h:411:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:411:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    kernel/sched/core.c:3089:1: warning: control reaches end of non-void fu=
nction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:411:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:411:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:411:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:411:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    block/cfq-iosched.c:3783:1: warning: control reaches end of non-void fu=
nction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:411:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:411:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:411:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    drivers/base/regmap/regmap-mmio.c:86:1: warning: control reaches end of=
 non-void function [-Wreturn-type]
    net/core/ethtool.c:260:1: warning: control reaches end of non-void func=
tion [-Wreturn-type]
    include/linux/sunrpc/svc_xprt.h:174:1: warning: control reaches end of =
non-void function [-Wreturn-type]
    arch/arc/include/asm/elf.h:58:29: warning: integer overflow in expressi=
on of type 'int' results in '-1073741824' [-Woverflow]
    lib/cpumask.c:178:1: warning: control reaches end of non-void function =
[-Wreturn-type]
    fs/posix_acl.c:34:1: warning: control reaches end of non-void function =
[-Wreturn-type]

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
workpad_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings, 0 se=
ction mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

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
xilfpga_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings, 0 se=
ction mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
xway_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings, 0 secti=
on mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

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
