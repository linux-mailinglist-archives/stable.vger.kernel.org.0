Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A32AB5EE0
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 10:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728952AbfIRIQD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 04:16:03 -0400
Received: from mail-wm1-f44.google.com ([209.85.128.44]:51168 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729487AbfIRIQC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Sep 2019 04:16:02 -0400
Received: by mail-wm1-f44.google.com with SMTP id 5so1438826wmg.0
        for <stable@vger.kernel.org>; Wed, 18 Sep 2019 01:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RMNW0GcMGiFVYsQj7bHntLQc0aLK5bC01kQ5O06gLLk=;
        b=UK3k8PoHqvfauYZ79L8x/nUIuEnmkNOvsKRF1R9ocOsAmP24T1JjrpxxoiCr9Rtd7S
         n94aFqCZMjIVBvsTZ4nuZzSrkSwzciCC/wAq0BcpW0PRmoz1DZbWgvn3Eqi0J/8u1eW0
         uWYrVZRGQaz4K/gq2N8rwJ8DUufC48uHpGuc1Vm9Yx90z4Rl+cjy1+5dsEG402AqJt76
         Th+qlRT2Z4jlDI7tNeEqlpXLe3/LSOXgiTQQCky/vHrxt3zPIgDQzPJENjgKRBxxx8AT
         CVpMPZvHjTG5pbCjdPHHdKV8/+RRYwW8gr+Aqm6KPKZJysLLXa+W/9DEDZxcVWs/QTtD
         tcFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RMNW0GcMGiFVYsQj7bHntLQc0aLK5bC01kQ5O06gLLk=;
        b=Qbym3nhyvxf66QCqMGCJ1lRB+9pSF9+N61lY+5BwxY8sNSQe/87yZCWpFnXEGi/yCj
         C3f9f3YHtSNZzUwZr5n20aGWVBCJPi74t+caHcboGWGvN1KnzffGIFLvUtqR3xdi13uH
         2q7bkN5rTwe8M+KYMAZUJRYODYNi7k1YpvxAEkamnjYwG7w4JZKpD7rMj4u4EgPfu+Dx
         UtyfdNtMAUn+NQpMh01DtX3O4bckw0pXBKmJnGJEg/II7DrgC6WyFbCo54YLPoKk3Z5h
         WGhnZ1pFhQY//tkl8kUwIiGtOmpyg7hl/wskxDLT5CRM98SDkGtURTB0WD2ALBUoX2Ov
         xvpw==
X-Gm-Message-State: APjAAAVhvOUEis0fbo8I/5HZs7ebX5Nm8Zp25GJpcpUEB5vXiBoTXqgd
        nM2LJMd5uSDjWX1b9l6TFyndcT00JU4dOw==
X-Google-Smtp-Source: APXvYqxuLEBLHn+f8BGnj0tGPcKaj/xa9Q9j0hOtobe+0wXc2O6DwNatZpChsai/fo2+/Tui5g9wMQ==
X-Received: by 2002:a05:600c:2153:: with SMTP id v19mr1754568wml.146.1568794555600;
        Wed, 18 Sep 2019 01:15:55 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f66sm1935121wmg.2.2019.09.18.01.15.53
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Sep 2019 01:15:53 -0700 (PDT)
Message-ID: <5d81e7b9.1c69fb81.1a2e8.7db5@mx.google.com>
Date:   Wed, 18 Sep 2019 01:15:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.73-51-gddb7a3337506
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: build
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y build: 206 builds: 62 failed, 144 passed,
 124 errors, 64 warnings (v4.19.73-51-gddb7a3337506)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y build: 206 builds: 62 failed, 144 passed, 124 errors=
, 64 warnings (v4.19.73-51-gddb7a3337506)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.73-51-gddb7a3337506/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.73-51-gddb7a3337506
Git Commit: ddb7a3337506cd5de6d52906c5291fcd90b955d2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 7 unique architectures

Build Failures Detected:

arc:
    axs103_defconfig: (gcc-8) FAIL
    axs103_smp_defconfig: (gcc-8) FAIL
    haps_hs_defconfig: (gcc-8) FAIL
    haps_hs_smp_defconfig: (gcc-8) FAIL
    hsdk_defconfig: (gcc-8) FAIL
    nsim_hs_defconfig: (gcc-8) FAIL
    nsim_hs_smp_defconfig: (gcc-8) FAIL
    nsimosci_hs_defconfig: (gcc-8) FAIL
    nsimosci_hs_smp_defconfig: (gcc-8) FAIL

mips:
    32r2el_defconfig: (gcc-8) FAIL
    ar7_defconfig: (gcc-8) FAIL
    ath25_defconfig: (gcc-8) FAIL
    ath79_defconfig: (gcc-8) FAIL
    bcm47xx_defconfig: (gcc-8) FAIL
    bigsur_defconfig: (gcc-8) FAIL
    capcella_defconfig: (gcc-8) FAIL
    cavium_octeon_defconfig: (gcc-8) FAIL
    cobalt_defconfig: (gcc-8) FAIL
    decstation_defconfig: (gcc-8) FAIL
    e55_defconfig: (gcc-8) FAIL
    fuloong2e_defconfig: (gcc-8) FAIL
    gpr_defconfig: (gcc-8) FAIL
    ip22_defconfig: (gcc-8) FAIL
    ip27_defconfig: (gcc-8) FAIL
    ip28_defconfig: (gcc-8) FAIL
    ip32_defconfig: (gcc-8) FAIL
    jazz_defconfig: (gcc-8) FAIL
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
    workpad_defconfig: (gcc-8) FAIL
    xway_defconfig: (gcc-8) FAIL

riscv:
    defconfig: (gcc-8) FAIL

Errors and Warnings Detected:

arc:
    axs103_defconfig (gcc-8): 2 errors, 1 warning
    axs103_smp_defconfig (gcc-8): 2 errors, 1 warning
    haps_hs_defconfig (gcc-8): 2 errors, 1 warning
    haps_hs_smp_defconfig (gcc-8): 2 errors, 1 warning
    hsdk_defconfig (gcc-8): 2 errors, 1 warning
    nsim_hs_defconfig (gcc-8): 2 errors, 1 warning
    nsim_hs_smp_defconfig (gcc-8): 2 errors, 1 warning
    nsimosci_hs_defconfig (gcc-8): 2 errors, 1 warning
    nsimosci_hs_smp_defconfig (gcc-8): 2 errors, 1 warning

arm64:

arm:

i386:

mips:
    32r2el_defconfig (gcc-8): 2 errors, 1 warning
    ar7_defconfig (gcc-8): 2 errors, 1 warning
    ath25_defconfig (gcc-8): 2 errors, 1 warning
    ath79_defconfig (gcc-8): 2 errors, 1 warning
    bcm47xx_defconfig (gcc-8): 2 errors, 1 warning
    bigsur_defconfig (gcc-8): 2 errors, 1 warning
    capcella_defconfig (gcc-8): 2 errors, 1 warning
    cavium_octeon_defconfig (gcc-8): 2 errors, 1 warning
    cobalt_defconfig (gcc-8): 2 errors, 1 warning
    decstation_defconfig (gcc-8): 2 errors, 1 warning
    e55_defconfig (gcc-8): 2 errors, 1 warning
    fuloong2e_defconfig (gcc-8): 2 errors, 1 warning
    gpr_defconfig (gcc-8): 2 errors, 1 warning
    ip22_defconfig (gcc-8): 2 errors, 1 warning
    ip27_defconfig (gcc-8): 2 errors, 1 warning
    ip28_defconfig (gcc-8): 2 errors, 1 warning
    ip32_defconfig (gcc-8): 2 errors, 1 warning
    jazz_defconfig (gcc-8): 2 errors, 1 warning
    lemote2f_defconfig (gcc-8): 2 errors, 1 warning
    loongson1b_defconfig (gcc-8): 2 errors, 1 warning
    loongson1c_defconfig (gcc-8): 2 errors, 1 warning
    loongson3_defconfig (gcc-8): 2 errors, 2 warnings
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
    workpad_defconfig (gcc-8): 2 errors, 1 warning
    xway_defconfig (gcc-8): 2 errors, 1 warning

riscv:
    defconfig (gcc-8): 2 errors, 1 warning

x86_64:
    tinyconfig (gcc-8): 1 warning

Errors summary:

    62   kernel/module.c:3828:2: error: implicit declaration of function 'm=
odule_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-fu=
nction-declaration]
    62   kernel/module.c:2187:2: error: implicit declaration of function 'd=
isable_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-dec=
laration]

Warnings summary:

    62   cc1: some warnings being treated as errors
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
32r2el_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

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
allnoconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

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
ar7_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section =
mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

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
assabet_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
at91_dt_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
ath25_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ath79_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
axm55xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
axs103_defconfig (arc, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
axs103_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 se=
ction mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

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
bcm47xx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
bcm63xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
bigsur_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

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
capcella_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, =
0 section mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

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
cobalt_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

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
davinci_all_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 s=
ection mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
defconfig (riscv, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section mis=
matches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

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
e55_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section =
mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

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
fuloong2e_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 se=
ction mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

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
gpr_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section =
mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

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
haps_hs_defconfig (arc, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
haps_hs_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 s=
ection mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
hisi_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
hsdk_defconfig (arc, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section =
mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

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
ip22_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ip27_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ip28_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ip32_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ixp4xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

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
lasat_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
loongson1b_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 s=
ection mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
loongson1c_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 s=
ection mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
loongson3_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 2 warnings, 0 s=
ection mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    arch/mips/configs/loongson3_defconfig:55:warning: symbol value 'm' inva=
lid for HOTPLUG_PCI_SHPC
    cc1: some warnings being treated as errors

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
lpd270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

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
malta_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 se=
ction mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
malta_kvm_guest_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning=
, 0 section mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
malta_qemu_32r6_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning=
, 0 section mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
maltaaprp_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 se=
ction mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
maltasmvp_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 se=
ction mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, =
0 section mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
maltaup_xpa_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 =
section mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
markeins_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
mips_paravirt_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, =
0 section mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

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
mpc30x_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mps2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
msp71xx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mtx1_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
multi_v4t_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
multi_v5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

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
netx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
nhk8815_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nsim_hs_defconfig (arc, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nsim_hs_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 s=
ection mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nsimosci_hs_defconfig (arc, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 s=
ection mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nsimosci_hs_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning,=
 0 section mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

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
omap2plus_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

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
oxnas_v6_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

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
pic32mzda_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 se=
ction mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pistachio_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 se=
ction mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pleb_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
pnx8335_stb225_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning,=
 0 section mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

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
qi_lb60_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
raumfeld_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
rb532_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
rbtx49xx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
realview_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
rpc_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

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
sb1250_swarm_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0=
 section mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

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
tango4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
tb0219_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tb0226_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tb0287_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

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
tinyconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    .config:1007:warning: override: UNWINDER_GUESS changes choice state

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
u8500_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

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
vt8500_v6_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
workpad_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

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
xway_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    kernel/module.c:2187:2: error: implicit declaration of function 'disabl=
e_ro_nx'; did you mean 'disable_irq'? [-Werror=3Dimplicit-function-declarat=
ion]
    kernel/module.c:3828:2: error: implicit declaration of function 'module=
_disable_nx'; did you mean 'module_disable_ro'? [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    cc1: some warnings being treated as errors

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
