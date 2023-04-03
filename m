Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 627826D454B
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 15:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231736AbjDCNJh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 09:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231553AbjDCNJg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 09:09:36 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE1C110CA
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 06:09:32 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id q102so27141000pjq.3
        for <stable@vger.kernel.org>; Mon, 03 Apr 2023 06:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680527372;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=bgIfZAEdpANQpYu3qCK1b0fopVa2KxmjxPx9q+1LaMQ=;
        b=KqL9h4X2A89I5somATthRHAevL5koSswfNx59kmZCFE6IMxBItw+KqlqzTNOuAt2/i
         0OTQNujwu7Z5axlP9Ltwv09iYUeuaS/m2ISyoNtHf5FE+n+4gKne+WKvWP4U9rNuoE5f
         k/aZ2xdEnm4hxERLNfpFsqjz+FJRxnCCUaGSg9n8oph4+pYWdAXGZBR9vx8GcEdvuYwM
         TSHqG/CiwNFPNUa/2MZkPSRYbBMmC3J9p2JcBtRyupY8dAPcRIg0mpjj3YHKHac3IDBo
         QWHrywFZ78Eij3fjjirJ67cxAeidmB0gukd5Zj6zDYijTo7511UqUGdexqBOK/DoiVrM
         OI6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680527372;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bgIfZAEdpANQpYu3qCK1b0fopVa2KxmjxPx9q+1LaMQ=;
        b=F4XVMPxObDPh2wmTR93j1H/gtyCBoAomwDpvT9arNnXSXUMINFUfLTh9ILoeumn4DY
         RWKu57g73hgonrq/gKS/JspwiBZ9FamMd66MI/AC7y3OMqmv3W0tZALKuUjpex/RwVTJ
         +RZbqWZ36RDeProOnyPv7x3cXDfiwBVPeDa7nN5vb85q6QEUm8V0gNx5jV7YWkxVjTwc
         kKsmz8c7TwD1yRdB9P6dZ8qg38LO9Kvi4ci/eDMgyZWRXJomjUXq+B3eMYE/3y9OuA0c
         2OfvSYmiDECvTILlmp4B/p5zbzBGQ0Vg7HvGKtI9Pvdx2/rzupsE2ohuKG099VqfGiJm
         kOOw==
X-Gm-Message-State: AAQBX9dE6cR9nRjuEJj4PftQTqJU6FvoT2op1w7Khw3Q9GhBIzwfjsgR
        XOYuYwh4lAQC2gKHEc43IpTA7G+z6mt17yEBtQ0=
X-Google-Smtp-Source: AKy350ZIK9V4lglxTohubYmrYbpOuTeiaLvcJOQmwU1Xlazj56LDPKMxJbP5pCbYAc12pLvGkRc0Og==
X-Received: by 2002:a17:902:e5c8:b0:19e:6eb0:a746 with SMTP id u8-20020a170902e5c800b0019e6eb0a746mr45954262plf.26.1680527370661;
        Mon, 03 Apr 2023 06:09:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p5-20020a170902eac500b0019928ce257dsm6616661pld.99.2023.04.03.06.09.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 06:09:30 -0700 (PDT)
Message-ID: <642ad00a.170a0220.722e.d345@mx.google.com>
Date:   Mon, 03 Apr 2023 06:09:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v5.15.105-90-g2aa39169cd26
Subject: stable-rc/linux-5.15.y build: 179 builds: 5 failed, 174 passed,
 74 errors, 7 warnings (v5.15.105-90-g2aa39169cd26)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.15.y build: 179 builds: 5 failed, 174 passed, 74 errors, =
7 warnings (v5.15.105-90-g2aa39169cd26)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.15.=
y/kernel/v5.15.105-90-g2aa39169cd26/

Tree: stable-rc
Branch: linux-5.15.y
Git Describe: v5.15.105-90-g2aa39169cd26
Git Commit: 2aa39169cd26a00c921a1bb4a7aac4d939fe94fe
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 7 unique architectures

Build Failures Detected:

arm64:
    defconfig: (gcc-10) FAIL
    defconfig+arm64-chromebook: (gcc-10) FAIL

mips:
    decstation_64_defconfig: (gcc-10) FAIL
    ip27_defconfig: (gcc-10) FAIL
    ip28_defconfig: (gcc-10) FAIL

Errors and Warnings Detected:

arc:
    tinyconfig (gcc-10): 1 warning

arm64:
    defconfig (gcc-10): 32 errors, 1 warning
    defconfig+arm64-chromebook (gcc-10): 32 errors, 1 warning

arm:

i386:

mips:
    32r2el_defconfig (gcc-10): 1 warning
    bigsur_defconfig (gcc-10): 1 error
    cavium_octeon_defconfig (gcc-10): 1 error
    decstation_64_defconfig (gcc-10): 1 error
    fuloong2e_defconfig (gcc-10): 1 error
    ip32_defconfig (gcc-10): 1 error
    lemote2f_defconfig (gcc-10): 1 error
    loongson2k_defconfig (gcc-10): 1 error
    loongson3_defconfig (gcc-10): 1 error
    nlm_xlp_defconfig (gcc-10): 1 error
    rm200_defconfig (gcc-10): 1 warning
    sb1250_swarm_defconfig (gcc-10): 1 error

riscv:

x86_64:
    x86_64_defconfig (gcc-10): 1 warning
    x86_64_defconfig+x86-chromebook (gcc-10): 1 warning

Errors summary:

    62   arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=
=98int (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm=
_one_reg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*=
)(struct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=
=80=98int (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long uns=
igned int *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    10   expr: syntax error: unexpected argument =E2=80=980xffffffff8000000=
0=E2=80=99
    2    arch/arm64/kvm/sys_regs.c:1671:36: error: initialization of =E2=80=
=98int (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm=
_one_reg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*=
)(struct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=
=80=98int (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long uns=
igned int *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]

Warnings summary:

    2    cc1: some warnings being treated as errors
    2    arch/x86/kernel/smp.o: warning: objtool: sysvec_reboot()+0x45: unr=
eachable instruction
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
allnoconfig (x86_64, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
allnoconfig (i386, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

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
defconfig (arm64, gcc-10) =E2=80=94 FAIL, 32 errors, 1 warning, 0 section m=
ismatches

Errors:
    arch/arm64/kvm/sys_regs.c:1671:36: error: initialization of =E2=80=98in=
t (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_=
reg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(str=
uct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98=
int (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned =
int *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
defconfig (riscv, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
defconfig+arm64-chromebook (arm64, gcc-10) =E2=80=94 FAIL, 32 errors, 1 war=
ning, 0 section mismatches

Errors:
    arch/arm64/kvm/sys_regs.c:1671:36: error: initialization of =E2=80=98in=
t (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_=
reg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(str=
uct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98=
int (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned =
int *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
    arch/arm64/kvm/sys_regs.c:999:41: error: initialization of =E2=80=98int=
 (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct kvm_one_r=
eg *, void *)=E2=80=99 from incompatible pointer type =E2=80=98int (*)(stru=
ct kvm_vcpu *, const struct sys_reg_desc *, u64 *)=E2=80=99 {aka =E2=80=98i=
nt (*)(struct kvm_vcpu *, const struct sys_reg_desc *, long long unsigned i=
nt *)=E2=80=99} [-Werror=3Dincompatible-pointer-types]

Warnings:
    cc1: some warnings being treated as errors

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
i386_defconfig (i386, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

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
imx_v6_v7_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
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
lemote2f_defconfig (mips, gcc-10) =E2=80=94 PASS, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99

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
loongson2k_defconfig (mips, gcc-10) =E2=80=94 PASS, 1 error, 0 warnings, 0 =
section mismatches

Errors:
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99

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
maltasmvp_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
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
nlm_xlr_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

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
tinyconfig (x86_64, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
tinyconfig (i386, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
tinyconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mis=
matches

Warnings:
    arch/arc/Makefile:26: ** WARNING ** CONFIG_ARC_TUNE_MCPU flag '' is unk=
nown, fallback to ''

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
x86_64_defconfig (x86_64, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    arch/x86/kernel/smp.o: warning: objtool: sysvec_reboot()+0x45: unreacha=
ble instruction

---------------------------------------------------------------------------=
-----
x86_64_defconfig+x86-chromebook (x86_64, gcc-10) =E2=80=94 PASS, 0 errors, =
1 warning, 0 section mismatches

Warnings:
    arch/x86/kernel/smp.o: warning: objtool: sysvec_reboot()+0x45: unreacha=
ble instruction

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
