Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2631412C
	for <lists+stable@lfdr.de>; Sun,  5 May 2019 18:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727295AbfEEQqd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 May 2019 12:46:33 -0400
Received: from mail-wr1-f54.google.com ([209.85.221.54]:40976 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726524AbfEEQqc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 May 2019 12:46:32 -0400
Received: by mail-wr1-f54.google.com with SMTP id c12so14181434wrt.8
        for <stable@vger.kernel.org>; Sun, 05 May 2019 09:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wKXXmHwvj04mLUzX9HhPCwBV4cpK89yKycvLQrfm+hI=;
        b=taMotJNVRM3Y6K5w/izhg1xWcsm1kcBPRFlXKA2ewPv4OZZXug7MUsBgjcZM8/0ty1
         KwZIRuZxUo6KOMHEhy6+T8LXy6Bo1vRPXCcCcR+Es71QRZWxG3bQDgKePOEjJ4XvlxHS
         lnxOe/3A4NW3imP766sIg2lEOgvUsqjIF2EWDKlIYMD6k0zSM0UvDuMOGWfsdYNHxF4i
         b7XEJt40fAzQ6/IEvgCxj+WgXcxiC6/WKP/1QM88FW2jFtSvMv1wpL/usRNMOZpBLnip
         pzWoj4Zz1HLfL8+vbPUCRc9/TEHqMBP3KI7bDYHp64BzS3Vja3vv7rPoU6scakau2DeN
         r8GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wKXXmHwvj04mLUzX9HhPCwBV4cpK89yKycvLQrfm+hI=;
        b=Gq98XqeL92bSITTaHfcK+X0wy82C8NmCh4ojJ5cAnMNSxJ8lfwpzGnREjqKEKADjFu
         GgzJ0dCvAl4tsfD/pBkRO60ox2vmM+NExwgf0Recv9b5j79Cj+MZbWRY48QDt6RBj+Tv
         DikOMns6e+mnzPUK11fz2sNnysvHN3xx17ePEtPlQMP2QoZH6rTFP9qzP4S1aKWlLqvS
         e8/4Tp6knexyKnMLQjDc5gfrK+NMD+Rq3N8GB3cHK0mSze3KMO5hORu14NcLK/re4kZ0
         TvxUnxRn+T6rZ+WVcV2c1nObjEXElIuEtdGCIcEswwpsdlxjgOt2sUFFVvVik8iBipJg
         8pYw==
X-Gm-Message-State: APjAAAVXADB3gEBswEJ4H/50rAQOCLLuxoeFEUD7Et336JzfjLQ81RLT
        480mngghXR0IwpDnbLiKzalLum5D6M0=
X-Google-Smtp-Source: APXvYqxicd4nt8TBDVYWwsPONlkK+O5rfi4SR+kY/eevNIPDkLw3gOp5ucqestOOot77PTIo/1xCWQ==
X-Received: by 2002:adf:dd43:: with SMTP id u3mr5535871wrm.302.1557074763028;
        Sun, 05 May 2019 09:46:03 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id d3sm15560560wmf.46.2019.05.05.09.46.01
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 09:46:02 -0700 (PDT)
Message-ID: <5ccf134a.1c69fb81.7061b.56ee@mx.google.com>
Date:   Sun, 05 May 2019 09:46:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.179-120-g2f22b9644d76
X-Kernelci-Report-Type: build
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y build: 190 builds: 11 failed, 179 passed,
 42 errors, 4434 warnings (v4.4.179-120-g2f22b9644d76)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y build: 190 builds: 11 failed, 179 passed, 42 errors, =
4434 warnings (v4.4.179-120-g2f22b9644d76)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.179-120-g2f22b9644d76/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.179-120-g2f22b9644d76
Git Commit: 2f22b9644d760c16024b9ca6b22901e67d61787f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 6 unique architectures

Build Failures Detected:

arc:    arc-linux-gcc (ARCv2 ISA Linux uClibc toolchain 2017.09) 7.1.1 2017=
0710

    axs103_defconfig: FAIL
    axs103_smp_defconfig: FAIL
    nsim_hs_defconfig: FAIL
    nsim_hs_smp_defconfig: FAIL
    nsimosci_hs_defconfig: FAIL
    nsimosci_hs_smp_defconfig: FAIL

mips:    mips-linux-gnu-gcc (Debian 7.3.0-28) 7.3.0

    bigsur_defconfig: FAIL
    decstation_defconfig: FAIL
    jmr3927_defconfig: FAIL
    sb1250_swarm_defconfig: FAIL
    sead3micro_defconfig: FAIL

Errors and Warnings Detected:

arc:    arc-linux-gcc (ARCv2 ISA Linux uClibc toolchain 2017.09) 7.1.1 2017=
0710

    allnoconfig: 678 warnings
    axs103_defconfig: 20 warnings
    axs103_smp_defconfig: 21 warnings
    nsim_hs_defconfig: 8 warnings
    nsim_hs_smp_defconfig: 9 warnings
    nsimosci_hs_defconfig: 9 warnings
    nsimosci_hs_smp_defconfig: 10 warnings
    tinyconfig: 682 warnings
    vdk_hs38_defconfig: 21 warnings
    vdk_hs38_smp_defconfig: 22 warnings

arm:    arm-linux-gnueabihf-gcc (Debian 7.4.0-1) 7.4.0

    clps711x_defconfig: 1 warning
    davinci_all_defconfig: 1 warning
    lpc32xx_defconfig: 1 warning
    mxs_defconfig: 1 warning

mips:    mips-linux-gnu-gcc (Debian 7.3.0-28) 7.3.0

    allnoconfig: 49 warnings
    ar7_defconfig: 49 warnings
    ath79_defconfig: 49 warnings
    bcm47xx_defconfig: 49 warnings
    bcm63xx_defconfig: 49 warnings
    bigsur_defconfig: 16 errors, 54 warnings
    bmips_be_defconfig: 49 warnings
    bmips_stb_defconfig: 49 warnings
    capcella_defconfig: 49 warnings
    cavium_octeon_defconfig: 49 warnings
    ci20_defconfig: 49 warnings
    cobalt_defconfig: 49 warnings
    db1xxx_defconfig: 49 warnings
    decstation_defconfig: 4 errors, 49 warnings
    e55_defconfig: 49 warnings
    fuloong2e_defconfig: 49 warnings
    gpr_defconfig: 49 warnings
    ip22_defconfig: 49 warnings
    ip27_defconfig: 49 warnings
    ip28_defconfig: 49 warnings
    ip32_defconfig: 49 warnings
    jazz_defconfig: 49 warnings
    jmr3927_defconfig: 4 errors, 49 warnings
    lasat_defconfig: 49 warnings
    lemote2f_defconfig: 49 warnings
    loongson3_defconfig: 49 warnings
    ls1b_defconfig: 49 warnings
    malta_defconfig: 49 warnings
    malta_kvm_defconfig: 49 warnings
    malta_kvm_guest_defconfig: 49 warnings
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
    nlm_xlr_defconfig: 49 warnings
    pistachio_defconfig: 49 warnings
    pnx8335_stb225_defconfig: 49 warnings
    qi_lb60_defconfig: 49 warnings
    rb532_defconfig: 49 warnings
    rbtx49xx_defconfig: 49 warnings
    rm200_defconfig: 49 warnings
    rt305x_defconfig: 49 warnings
    sb1250_swarm_defconfig: 16 errors, 54 warnings
    sead3_defconfig: 49 warnings
    sead3micro_defconfig: 2 errors, 49 warnings
    tb0219_defconfig: 49 warnings
    tb0226_defconfig: 49 warnings
    tb0287_defconfig: 49 warnings
    tinyconfig: 49 warnings
    workpad_defconfig: 49 warnings
    xilfpga_defconfig: 49 warnings
    xway_defconfig: 49 warnings

Errors summary:

    4    cc1: error: '-march=3Dr3900' requires '-mfp32'
    4    cc1: error: '-march=3Dr3000' requires '-mfp32'
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
    1    arch/mips/kernel/genex.S:271: Error: branch to a symbol in another=
 ISA mode
    1    arch/mips/kernel/genex.S:152: Error: branch to a symbol in another=
 ISA mode

Warnings summary:

    2580  arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean exp=
ression [-Wbool-operation]
    705  arc-linux-gcc: warning: '-mno-mpy' is deprecated
    670  cc1: warning: '-mno-mpy' is deprecated
    360  arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expr=
ession [-Wbool-operation]
    36   fs/ext4/ext4_jbd2.h:411:1: warning: control reaches end of non-voi=
d function [-Wreturn-type]
    10   kernel/sched/core.c:3089:1: warning: control reaches end of non-vo=
id function [-Wreturn-type]
    8    warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOT=
LB_XEN && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (C=
AVIUM_OCTEON_SOC || MACH_LOONGSON64 && CPU_LOONGSON3 || NLM_XLP_BOARD || NL=
M_XLR_BOARD)
    8    net/ipv4/tcp_input.c:4251:49: warning: array subscript is above ar=
ray bounds [-Warray-bounds]
    8    net/core/ethtool.c:260:1: warning: control reaches end of non-void=
 function [-Wreturn-type]
    8    include/linux/sunrpc/svc_xprt.h:174:1: warning: control reaches en=
d of non-void function [-Wreturn-type]
    8    arch/arc/include/asm/elf.h:58:29: warning: integer overflow in exp=
ression [-Woverflow]
    7    warning: (ARC) selects HAVE_FUTEX_CMPXCHG which has unmet direct d=
ependencies (FUTEX)
    6    fs/posix_acl.c:34:1: warning: control reaches end of non-void func=
tion [-Wreturn-type]
    4    lib/cpumask.c:178:1: warning: control reaches end of non-void func=
tion [-Wreturn-type]
    4    drivers/base/regmap/regmap-mmio.c:86:1: warning: control reaches e=
nd of non-void function [-Wreturn-type]
    4    block/cfq-iosched.c:3783:1: warning: control reaches end of non-vo=
id function [-Wreturn-type]
    2    cc1: all warnings being treated as errors
    2    arch/arc/kernel/unwind.c:186:14: warning: 'unw_hdr_alloc' defined =
but not used [-Wunused-function]
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
acs5k_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
acs5k_tiny_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
allnoconfig (arc, gcc-7) =E2=80=94 PASS, 0 errors, 678 warnings, 0 section =
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

---------------------------------------------------------------------------=
-----
allnoconfig (i386, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
allnoconfig (arm64, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (x86_64, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings, 0 section =
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
am200epdkit_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
ar7_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings, 0 sectio=
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
assabet_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
at91_dt_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
ath79_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings, 0 sect=
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
axm55xx_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
axs103_defconfig (arc, gcc-7) =E2=80=94 FAIL, 0 errors, 20 warnings, 0 sect=
ion mismatches

Warnings:
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    kernel/sched/core.c:3089:1: warning: control reaches end of non-void fu=
nction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:411:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:411:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:411:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    drivers/base/regmap/regmap-mmio.c:86:1: warning: control reaches end of=
 non-void function [-Wreturn-type]
    block/cfq-iosched.c:3783:1: warning: control reaches end of non-void fu=
nction [-Wreturn-type]
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
    fs/ext4/ext4_jbd2.h:411:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    arch/arc/include/asm/elf.h:58:29: warning: integer overflow in expressi=
on [-Woverflow]
    fs/posix_acl.c:34:1: warning: control reaches end of non-void function =
[-Wreturn-type]
    net/core/ethtool.c:260:1: warning: control reaches end of non-void func=
tion [-Wreturn-type]
    net/ipv4/tcp_input.c:4251:49: warning: array subscript is above array b=
ounds [-Warray-bounds]
    include/linux/sunrpc/svc_xprt.h:174:1: warning: control reaches end of =
non-void function [-Wreturn-type]

---------------------------------------------------------------------------=
-----
axs103_smp_defconfig (arc, gcc-7) =E2=80=94 FAIL, 0 errors, 21 warnings, 0 =
section mismatches

Warnings:
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
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
    fs/ext4/ext4_jbd2.h:411:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:411:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    drivers/base/regmap/regmap-mmio.c:86:1: warning: control reaches end of=
 non-void function [-Wreturn-type]
    net/core/ethtool.c:260:1: warning: control reaches end of non-void func=
tion [-Wreturn-type]
    net/ipv4/tcp_input.c:4251:49: warning: array subscript is above array b=
ounds [-Warray-bounds]
    arch/arc/include/asm/elf.h:58:29: warning: integer overflow in expressi=
on [-Woverflow]
    fs/posix_acl.c:34:1: warning: control reaches end of non-void function =
[-Wreturn-type]
    lib/cpumask.c:178:1: warning: control reaches end of non-void function =
[-Wreturn-type]
    include/linux/sunrpc/svc_xprt.h:174:1: warning: control reaches end of =
non-void function [-Wreturn-type]

---------------------------------------------------------------------------=
-----
badge4_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
bcm2835_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
bcm47xx_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings, 0 se=
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
bcm63xx_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings, 0 se=
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
bcm_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
bigsur_defconfig (mips, gcc-7) =E2=80=94 FAIL, 16 errors, 54 warnings, 0 se=
ction mismatches

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
bmips_be_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings, 0 s=
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
bmips_stb_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings, 0 =
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
capcella_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings, 0 s=
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
cavium_octeon_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings=
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
cerfcube_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
ci20_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings, 0 secti=
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
clps711x_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    arch/arm/mach-clps711x/board-autcpu12.c:163:26: warning: duplicate 'con=
st' declaration specifier [-Wduplicate-decl-specifier]

---------------------------------------------------------------------------=
-----
cm_x2xx_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
cm_x300_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
cns3420vb_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
cobalt_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings, 0 sec=
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
colibri_pxa270_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
collie_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
corgi_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
davinci_all_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    arch/arm/mach-davinci/da8xx-dt.c:23:34: warning: duplicate 'const' decl=
aration specifier [-Wduplicate-decl-specifier]

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings, 0 sec=
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
decstation_defconfig (mips, gcc-7) =E2=80=94 FAIL, 4 errors, 49 warnings, 0=
 section mismatches

Errors:
    cc1: error: '-march=3Dr3000' requires '-mfp32'
    cc1: error: '-march=3Dr3000' requires '-mfp32'
    cc1: error: '-march=3Dr3000' requires '-mfp32'
    cc1: error: '-march=3Dr3000' requires '-mfp32'

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
defconfig (arm64, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
dove_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
e55_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings, 0 sectio=
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
ebsa110_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
efm32_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
em_x270_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
ep93xx_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
fuloong2e_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings, 0 =
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
gpr_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings, 0 sectio=
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
h3600_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
h5000_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
hackkit_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
hisi_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
i386_defconfig (i386, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
imote2_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
imx_v4_v5_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
imx_v6_v7_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
integrator_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
iop13xx_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
iop32x_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
iop33x_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
ip22_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings, 0 secti=
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
ip27_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings, 0 secti=
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
ip28_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings, 0 secti=
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
ip32_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings, 0 secti=
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
ixp4xx_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings, 0 secti=
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
jmr3927_defconfig (mips, gcc-7) =E2=80=94 FAIL, 4 errors, 49 warnings, 0 se=
ction mismatches

Errors:
    cc1: error: '-march=3Dr3900' requires '-mfp32'
    cc1: error: '-march=3Dr3900' requires '-mfp32'
    cc1: error: '-march=3Dr3900' requires '-mfp32'
    cc1: error: '-march=3Dr3900' requires '-mfp32'

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
jornada720_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
keystone_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
ks8695_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
lart_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
lasat_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings, 0 sect=
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
lemote2f_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings, 0 s=
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
loongson3_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings, 0 =
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
lpc18xx_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
lpc32xx_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    arch/arm/mach-lpc32xx/phy3250.c:215:36: warning: duplicate 'const' decl=
aration specifier [-Wduplicate-decl-specifier]

---------------------------------------------------------------------------=
-----
lpd270_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
ls1b_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings, 0 secti=
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
lubbock_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
magician_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
mainstone_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
malta_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings, 0 sect=
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
malta_kvm_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings, 0 =
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
malta_kvm_guest_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnin=
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
malta_qemu_32r6_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnin=
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
maltaaprp_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings, 0 =
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
maltasmvp_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings, 0 =
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
maltasmvp_eva_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings=
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
maltaup_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings, 0 se=
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
maltaup_xpa_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings, =
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
markeins_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings, 0 s=
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
mini2440_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
mips_paravirt_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings=
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
mmp2_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
moxart_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
mpc30x_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings, 0 sec=
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
msp71xx_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings, 0 se=
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
mtx1_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings, 0 secti=
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
multi_v5_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
mv78xx0_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
mvebu_v5_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
mvebu_v7_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
mxs_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    arch/arm/mach-mxs/mach-mxs.c:285:26: warning: duplicate 'const' declara=
tion specifier [-Wduplicate-decl-specifier]

---------------------------------------------------------------------------=
-----
neponset_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
netwinder_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
netx_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
nhk8815_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings, 0 se=
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
nlm_xlr_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings, 0 se=
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
nsim_hs_defconfig (arc, gcc-7) =E2=80=94 FAIL, 0 errors, 8 warnings, 0 sect=
ion mismatches

Warnings:
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    kernel/sched/core.c:3089:1: warning: control reaches end of non-void fu=
nction [-Wreturn-type]
    net/core/ethtool.c:260:1: warning: control reaches end of non-void func=
tion [-Wreturn-type]
    arch/arc/include/asm/elf.h:58:29: warning: integer overflow in expressi=
on [-Woverflow]
    net/ipv4/tcp_input.c:4251:49: warning: array subscript is above array b=
ounds [-Warray-bounds]
    include/linux/sunrpc/svc_xprt.h:174:1: warning: control reaches end of =
non-void function [-Wreturn-type]

---------------------------------------------------------------------------=
-----
nsim_hs_smp_defconfig (arc, gcc-7) =E2=80=94 FAIL, 0 errors, 9 warnings, 0 =
section mismatches

Warnings:
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    kernel/sched/core.c:3089:1: warning: control reaches end of non-void fu=
nction [-Wreturn-type]
    arch/arc/include/asm/elf.h:58:29: warning: integer overflow in expressi=
on [-Woverflow]
    net/core/ethtool.c:260:1: warning: control reaches end of non-void func=
tion [-Wreturn-type]
    lib/cpumask.c:178:1: warning: control reaches end of non-void function =
[-Wreturn-type]
    net/ipv4/tcp_input.c:4251:49: warning: array subscript is above array b=
ounds [-Warray-bounds]
    include/linux/sunrpc/svc_xprt.h:174:1: warning: control reaches end of =
non-void function [-Wreturn-type]

---------------------------------------------------------------------------=
-----
nsimosci_hs_defconfig (arc, gcc-7) =E2=80=94 FAIL, 0 errors, 9 warnings, 0 =
section mismatches

Warnings:
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    kernel/sched/core.c:3089:1: warning: control reaches end of non-void fu=
nction [-Wreturn-type]
    net/core/ethtool.c:260:1: warning: control reaches end of non-void func=
tion [-Wreturn-type]
    net/ipv4/tcp_input.c:4251:49: warning: array subscript is above array b=
ounds [-Warray-bounds]
    arch/arc/include/asm/elf.h:58:29: warning: integer overflow in expressi=
on [-Woverflow]
    fs/posix_acl.c:34:1: warning: control reaches end of non-void function =
[-Wreturn-type]
    include/linux/sunrpc/svc_xprt.h:174:1: warning: control reaches end of =
non-void function [-Wreturn-type]

---------------------------------------------------------------------------=
-----
nsimosci_hs_smp_defconfig (arc, gcc-7) =E2=80=94 FAIL, 0 errors, 10 warning=
s, 0 section mismatches

Warnings:
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    kernel/sched/core.c:3089:1: warning: control reaches end of non-void fu=
nction [-Wreturn-type]
    net/core/ethtool.c:260:1: warning: control reaches end of non-void func=
tion [-Wreturn-type]
    net/ipv4/tcp_input.c:4251:49: warning: array subscript is above array b=
ounds [-Warray-bounds]
    arch/arc/include/asm/elf.h:58:29: warning: integer overflow in expressi=
on [-Woverflow]
    fs/posix_acl.c:34:1: warning: control reaches end of non-void function =
[-Wreturn-type]
    lib/cpumask.c:178:1: warning: control reaches end of non-void function =
[-Wreturn-type]
    include/linux/sunrpc/svc_xprt.h:174:1: warning: control reaches end of =
non-void function [-Wreturn-type]

---------------------------------------------------------------------------=
-----
nuc910_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
nuc950_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
nuc960_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
omap1_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
orion5x_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
palmz72_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
pcm027_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
pistachio_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings, 0 =
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
pleb_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
pnx8335_stb225_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warning=
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
prima2_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
pxa168_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
pxa255-idp_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
pxa3xx_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
pxa910_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
qcom_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
qi_lb60_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings, 0 se=
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
raumfeld_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
rb532_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings, 0 sect=
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
rbtx49xx_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings, 0 s=
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
realview-smp_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
realview_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings, 0 sect=
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
rpc_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings, 0 sec=
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
s3c2410_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
s3c6400_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
s5pv210_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
sama5_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
sb1250_swarm_defconfig (mips, gcc-7) =E2=80=94 FAIL, 16 errors, 54 warnings=
, 0 section mismatches

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
sead3_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings, 0 sect=
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
sead3micro_defconfig (mips, gcc-7) =E2=80=94 FAIL, 2 errors, 49 warnings, 0=
 section mismatches

Errors:
    arch/mips/kernel/genex.S:152: Error: branch to a symbol in another ISA =
mode
    arch/mips/kernel/genex.S:271: Error: branch to a symbol in another ISA =
mode

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
shannon_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
shmobile_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
simpad_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
socfpga_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
spear13xx_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
spear3xx_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
spear6xx_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
spitz_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
stm32_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
sunxi_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
tb0219_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings, 0 sec=
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
tb0226_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings, 0 sec=
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
tb0287_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings, 0 sec=
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
tct_hammer_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
tegra_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
tinyconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings, 0 section m=
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
tinyconfig (arc, gcc-7) =E2=80=94 PASS, 0 errors, 682 warnings, 0 section m=
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
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-linux-gcc: warning: '-mno-mpy' is deprecated
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

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
tinyconfig (arm64, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
tinyconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
tinyconfig (i386, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
trizeps4_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
u300_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
u8500_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
vdk_hs38_defconfig (arc, gcc-7) =E2=80=94 PASS, 0 errors, 21 warnings, 0 se=
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
    net/core/ethtool.c:260:1: warning: control reaches end of non-void func=
tion [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:411:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:411:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:411:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    net/ipv4/tcp_input.c:4251:49: warning: array subscript is above array b=
ounds [-Warray-bounds]
    include/linux/sunrpc/svc_xprt.h:174:1: warning: control reaches end of =
non-void function [-Wreturn-type]
    arch/arc/include/asm/elf.h:58:29: warning: integer overflow in expressi=
on [-Woverflow]
    fs/posix_acl.c:34:1: warning: control reaches end of non-void function =
[-Wreturn-type]

---------------------------------------------------------------------------=
-----
vdk_hs38_smp_defconfig (arc, gcc-7) =E2=80=94 PASS, 0 errors, 22 warnings, =
0 section mismatches

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
    fs/ext4/ext4_jbd2.h:411:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    net/core/ethtool.c:260:1: warning: control reaches end of non-void func=
tion [-Wreturn-type]
    arch/arc/include/asm/elf.h:58:29: warning: integer overflow in expressi=
on [-Woverflow]
    fs/posix_acl.c:34:1: warning: control reaches end of non-void function =
[-Wreturn-type]
    lib/cpumask.c:178:1: warning: control reaches end of non-void function =
[-Wreturn-type]
    net/ipv4/tcp_input.c:4251:49: warning: array subscript is above array b=
ounds [-Warray-bounds]
    include/linux/sunrpc/svc_xprt.h:174:1: warning: control reaches end of =
non-void function [-Wreturn-type]

---------------------------------------------------------------------------=
-----
versatile_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
vexpress_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
vf610m4_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
viper_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
vt8500_v6_v7_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
workpad_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings, 0 se=
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
x86_64_defconfig (x86_64, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
xcep_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
xilfpga_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings, 0 se=
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
xway_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 49 warnings, 0 secti=
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
zeus_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
zx_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---
For more info write to <info@kernelci.org>
