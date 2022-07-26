Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47EA9580BED
	for <lists+stable@lfdr.de>; Tue, 26 Jul 2022 08:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237690AbiGZGtJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jul 2022 02:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238066AbiGZGs5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jul 2022 02:48:57 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83A7021802
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 23:48:56 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id f65so12362947pgc.12
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 23:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mvRw6fulUaP8O3dznjo8joVXOVe2X5T+XiLidq7c/x4=;
        b=BxfeWrV7iOSCH2TJJXApIDhizWQF6RcUoK5viAadC3/iKlkkoOWbWhWHBH2t4yYtOp
         Xwqr53ImbyHocalvkFrHZDp61l8mK9DFdiJ5JpiopdL3vuNAd0Nfgd/zZ6sD0EweQttK
         Izzp8tcmtXPrHujsy0ZyraEV46MbYCBqOL2lFLAIndWRM3Gsas2pXhWEIlcHNck/FkRi
         8+wajHjQLIqXHB09Ote/IkX4gby8Hcgkajdd2YfaQ5koI/L4176rLkXzQQ2mR8XxgUz3
         aE6QCCMD7VgV+upVPCOviojeYI3XZKDiTr1q7nlOX0k1JkTyo1z/f921K2/7Yx/QwtgF
         LR3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mvRw6fulUaP8O3dznjo8joVXOVe2X5T+XiLidq7c/x4=;
        b=C/XCX+rTfX86KkMlPyeNbrQehU6vwoALdJAsQasTXqyjyZDZ0AEHpf5xZO+FgiDUy2
         TY5BW9OknmkOnjIGd7NcS7ibRqF52tXWqhCJuQKGZdLsbD90kzfSNSWcad6W+6/RYWom
         1+Ztd8VbRnWL4nreYhZBv1e9W2DefhIXRxkSyEzeb7/cMMwqUazumAXwKgrmHd/CZ5SL
         IWe5E9Gv2UTl5DAECWlBFhb0hxGzVx35VRHFfpZIcs64MxQ4x+O6bUeKPpHjduObUHOS
         /q0b4SbhTXX2tWmH/0VNy77I4gCtkfQUHuWTxFjxv82h9pkEuOok/AZt7HGdsvtcgwH7
         21NQ==
X-Gm-Message-State: AJIora9mA4jmqW2T/IsLaS8shsVxw1PuCQl89c4RByb+qdSTDts2FOpH
        om4fXpMaDizusRaaRzw3HY6dvTNINu/w3Y8K
X-Google-Smtp-Source: AGRyM1u0H+JhQeCeiWAGrmmb8xdFakEm9XNN7SksRPzh/kLh57lhzSL8k3sMhXw3sO5+4cWqxwTahA==
X-Received: by 2002:a63:c5:0:b0:40d:d290:24ef with SMTP id 188-20020a6300c5000000b0040dd29024efmr10464913pga.141.1658818134106;
        Mon, 25 Jul 2022 23:48:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h6-20020aa796c6000000b0052ad6d627a6sm10824915pfq.166.2022.07.25.23.48.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 23:48:53 -0700 (PDT)
Message-ID: <62df8e55.1c69fb81.cf53a.10e4@mx.google.com>
Date:   Mon, 25 Jul 2022 23:48:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v5.15.57-176-gda50e215b6b1a
Subject: stable-rc/queue/5.15 build: 177 builds: 11 failed, 166 passed,
 28 errors, 7363 warnings (v5.15.57-176-gda50e215b6b1a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 build: 177 builds: 11 failed, 166 passed, 28 errors, 7=
363 warnings (v5.15.57-176-gda50e215b6b1a)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F5.1=
5/kernel/v5.15.57-176-gda50e215b6b1a/

Tree: stable-rc
Branch: queue/5.15
Git Describe: v5.15.57-176-gda50e215b6b1a
Git Commit: da50e215b6b1a70e2b251ce5d6e37068c880340a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 7 unique architectures

Build Failures Detected:

arm:
    rpc_defconfig: (gcc-10) FAIL

i386:
    allnoconfig: (gcc-10) FAIL
    i386_defconfig: (gcc-10) FAIL
    tinyconfig: (gcc-10) FAIL

mips:
    decstation_64_defconfig: (gcc-10) FAIL
    ip27_defconfig: (gcc-10) FAIL
    ip28_defconfig: (gcc-10) FAIL

x86_64:
    allnoconfig: (gcc-10) FAIL
    tinyconfig: (gcc-10) FAIL
    x86_64_defconfig: (gcc-10) FAIL
    x86_64_defconfig+x86-chromebook: (gcc-10) FAIL

Errors and Warnings Detected:

arc:
    tinyconfig (gcc-10): 1 warning

arm64:

arm:
    rpc_defconfig (gcc-10): 4 errors

i386:
    allnoconfig (gcc-10): 2 errors, 754 warnings
    i386_defconfig (gcc-10): 2 errors, 1536 warnings
    tinyconfig (gcc-10): 2 errors, 802 warnings

mips:
    32r2el_defconfig (gcc-10): 1 warning
    bigsur_defconfig (gcc-10): 1 error
    cavium_octeon_defconfig (gcc-10): 1 error
    decstation_64_defconfig (gcc-10): 1 error
    fuloong2e_defconfig (gcc-10): 1 error
    ip32_defconfig (gcc-10): 1 error
    lemote2f_defconfig (gcc-10): 1 error, 1 warning
    loongson2k_defconfig (gcc-10): 1 error, 1 warning
    loongson3_defconfig (gcc-10): 1 error
    nlm_xlp_defconfig (gcc-10): 1 error
    rm200_defconfig (gcc-10): 1 warning
    sb1250_swarm_defconfig (gcc-10): 1 error

riscv:

x86_64:
    allnoconfig (gcc-10): 2 errors, 850 warnings
    tinyconfig (gcc-10): 2 errors, 880 warnings
    x86_64_defconfig (gcc-10): 2 errors, 1584 warnings
    x86_64_defconfig+x86-chromebook (gcc-10): 2 errors, 952 warnings

Errors summary:

    10   expr: syntax error: unexpected argument =E2=80=980xffffffff8000000=
0=E2=80=99
    7    arch/x86/mm/extable.c:203:2: error: duplicate case value
    7    arch/x86/mm/extable.c:200:2: error: duplicate case value
    2    arm-linux-gnueabihf-gcc: error: unrecognized -march target: armv3m
    2    arm-linux-gnueabihf-gcc: error: missing argument to =E2=80=98-marc=
h=3D=E2=80=99

Warnings summary:

    3679  arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_=
FAULT_MCE_SAFE" redefined
    3679  arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_=
DEFAULT_MCE_SAFE" redefined
    2    net/mac80211/mlme.c:4377:1: warning: the frame size of 1200 bytes =
is larger than 1024 bytes [-Wframe-larger-than=3D]
    1    drivers/block/paride/bpck.c:32: warning: "PC" redefined
    1    arch/mips/boot/dts/img/boston.dts:128.19-178.5: Warning (pci_devic=
e_reg): /pci@14000000/pci2_root@0,0,0: PCI unit address format error, expec=
ted "0,0"
    1    arch/arc/Makefile:26: ** WARNING ** CONFIG_ARC_TUNE_MCPU flag '' i=
s unknown, fallback to ''

Section mismatches summary:

    1    WARNING: modpost: vmlinux.o(___ksymtab_gpl+ixp4xx_irq_init+0x0): S=
ection mismatch in reference from the variable __ksymtab_ixp4xx_irq_init to=
 the function .init.text:ixp4xx_irq_init()
    1    WARNING: modpost: vmlinux.o(___ksymtab+prom_init_numa_memory+0x0):=
 Section mismatch in reference from the variable __ksymtab_prom_init_numa_m=
emory to the function .init.text:prom_init_numa_memory()

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
32r2el_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    arch/mips/boot/dts/img/boston.dts:128.19-178.5: Warning (pci_device_reg=
): /pci@14000000/pci2_root@0,0,0: PCI unit address format error, expected "=
0,0"

---------------------------------------------------------------------------=
-----
allnoconfig (i386, gcc-10) =E2=80=94 FAIL, 2 errors, 754 warnings, 0 sectio=
n mismatches

Errors:
    arch/x86/mm/extable.c:200:2: error: duplicate case value
    arch/x86/mm/extable.c:203:2: error: duplicate case value

Warnings:
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined

---------------------------------------------------------------------------=
-----
allnoconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
allnoconfig (x86_64, gcc-10) =E2=80=94 FAIL, 2 errors, 850 warnings, 0 sect=
ion mismatches

Errors:
    arch/x86/mm/extable.c:200:2: error: duplicate case value
    arch/x86/mm/extable.c:203:2: error: duplicate case value

Warnings:
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined

---------------------------------------------------------------------------=
-----
am200epdkit_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
ar7_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
aspeed_g4_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
aspeed_g5_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
assabet_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
at91_dt_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

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
axm55xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
axs103_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
axs103_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
badge4_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
bcm2835_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

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
bigsur_defconfig (mips, gcc-10) =E2=80=94 PASS, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
bmips_stb_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-10) =E2=80=94 PASS, 1 error, 0 warnings,=
 0 section mismatches

Errors:
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
ci20_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
cm_x300_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
cobalt_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
colibri_pxa270_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
collie_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
corgi_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
cu1000-neo_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
cu1830-neo_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
davinci_all_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
decstation_64_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings,=
 0 section mismatches

Errors:
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
decstation_r4k_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warning=
s, 0 section mismatches

---------------------------------------------------------------------------=
-----
defconfig (riscv, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
defconfig+arm64-chromebook (arm64, gcc-10) =E2=80=94 PASS, 0 errors, 0 warn=
ings, 0 section mismatches

---------------------------------------------------------------------------=
-----
dove_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
e55_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
ep93xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
fuloong2e_defconfig (mips, gcc-10) =E2=80=94 PASS, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99

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
gpr_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
h3600_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
h5000_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
hackkit_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
haps_hs_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
haps_hs_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
hisi_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
hsdk_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
i386_defconfig (i386, gcc-10) =E2=80=94 FAIL, 2 errors, 1536 warnings, 0 se=
ction mismatches

Errors:
    arch/x86/mm/extable.c:200:2: error: duplicate case value
    arch/x86/mm/extable.c:203:2: error: duplicate case value

Warnings:
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined

---------------------------------------------------------------------------=
-----
imote2_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
imx_v4_v5_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
integrator_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
iop32x_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
ip22_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

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
ip32_defconfig (mips, gcc-10) =E2=80=94 PASS, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99

---------------------------------------------------------------------------=
-----
ixp4xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(___ksymtab_gpl+ixp4xx_irq_init+0x0): Sectio=
n mismatch in reference from the variable __ksymtab_ixp4xx_irq_init to the =
function .init.text:ixp4xx_irq_init()

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
jmr3927_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
jornada720_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
keystone_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
lart_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-10) =E2=80=94 PASS, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99

Warnings:
    net/mac80211/mlme.c:4377:1: warning: the frame size of 1200 bytes is la=
rger than 1024 bytes [-Wframe-larger-than=3D]

---------------------------------------------------------------------------=
-----
loongson1b_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
loongson1c_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
loongson2k_defconfig (mips, gcc-10) =E2=80=94 PASS, 1 error, 1 warning, 0 s=
ection mismatches

Errors:
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99

Warnings:
    net/mac80211/mlme.c:4377:1: warning: the frame size of 1200 bytes is la=
rger than 1024 bytes [-Wframe-larger-than=3D]

---------------------------------------------------------------------------=
-----
loongson3_defconfig (mips, gcc-10) =E2=80=94 PASS, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99

Section mismatches:
    WARNING: modpost: vmlinux.o(___ksymtab+prom_init_numa_memory+0x0): Sect=
ion mismatch in reference from the variable __ksymtab_prom_init_numa_memory=
 to the function .init.text:prom_init_numa_memory()

---------------------------------------------------------------------------=
-----
lpc18xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
lpc32xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
lpd270_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
lubbock_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
magician_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
mainstone_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
malta_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
malta_qemu_32r6_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnin=
gs, 0 section mismatches

---------------------------------------------------------------------------=
-----
maltaaprp_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
maltaup_xpa_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, =
0 section mismatches

---------------------------------------------------------------------------=
-----
milbeaut_m10v_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
mmp2_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
moxart_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
mpc30x_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
mps2_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
mtx1_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
multi_v4t_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
multi_v5_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
mvebu_v5_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
mvebu_v7_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
mxs_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
neponset_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
netwinder_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
nhk8815_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-10) =E2=80=94 PASS, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99

---------------------------------------------------------------------------=
-----
nommu_k210_defconfig (riscv, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, =
0 section mismatches

---------------------------------------------------------------------------=
-----
nommu_k210_sdcard_defconfig (riscv, gcc-10) =E2=80=94 PASS, 0 errors, 0 war=
nings, 0 section mismatches

---------------------------------------------------------------------------=
-----
nsimosci_hs_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
nsimosci_hs_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warning=
s, 0 section mismatches

---------------------------------------------------------------------------=
-----
omap1_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
omega2p_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
orion5x_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
oxnas_v6_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
palmz72_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
pcm027_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
pic32mzda_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
pleb_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
pxa168_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
pxa255-idp_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
pxa3xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
pxa910_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
pxa_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
qcom_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

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
rbtx49xx_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
realview_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    drivers/block/paride/bpck.c:32: warning: "PC" redefined

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
rv32_defconfig (riscv, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
s3c2410_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

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
sama5_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
sama7_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
sb1250_swarm_defconfig (mips, gcc-10) =E2=80=94 PASS, 1 error, 0 warnings, =
0 section mismatches

Errors:
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99

---------------------------------------------------------------------------=
-----
shannon_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
shmobile_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
simpad_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
socfpga_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
spear13xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
spear3xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
spear6xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
spitz_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
stm32_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
sunxi_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
tb0219_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
tb0226_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
tb0287_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
tct_hammer_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
tegra_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
tinyconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mis=
matches

Warnings:
    arch/arc/Makefile:26: ** WARNING ** CONFIG_ARC_TUNE_MCPU flag '' is unk=
nown, fallback to ''

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-10) =E2=80=94 FAIL, 2 errors, 880 warnings, 0 secti=
on mismatches

Errors:
    arch/x86/mm/extable.c:200:2: error: duplicate case value
    arch/x86/mm/extable.c:203:2: error: duplicate case value

Warnings:
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined

---------------------------------------------------------------------------=
-----
tinyconfig (i386, gcc-10) =E2=80=94 FAIL, 2 errors, 802 warnings, 0 section=
 mismatches

Errors:
    arch/x86/mm/extable.c:200:2: error: duplicate case value
    arch/x86/mm/extable.c:203:2: error: duplicate case value

Warnings:
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined

---------------------------------------------------------------------------=
-----
trizeps4_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
u8500_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
vdk_hs38_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
vdk_hs38_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, =
0 section mismatches

---------------------------------------------------------------------------=
-----
versatile_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
vexpress_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
vf610m4_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
viper_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
vocore2_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
vt8500_v6_v7_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, =
0 section mismatches

---------------------------------------------------------------------------=
-----
workpad_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
x86_64_defconfig (x86_64, gcc-10) =E2=80=94 FAIL, 2 errors, 1584 warnings, =
0 section mismatches

Errors:
    arch/x86/mm/extable.c:200:2: error: duplicate case value
    arch/x86/mm/extable.c:203:2: error: duplicate case value

Warnings:
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined

---------------------------------------------------------------------------=
-----
x86_64_defconfig+x86-chromebook (x86_64, gcc-10) =E2=80=94 FAIL, 2 errors, =
952 warnings, 0 section mismatches

Errors:
    arch/x86/mm/extable.c:200:2: error: duplicate case value
    arch/x86/mm/extable.c:203:2: error: duplicate case value

Warnings:
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined

---------------------------------------------------------------------------=
-----
xcep_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
zeus_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---
For more info write to <info@kernelci.org>
