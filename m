Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D596D2009EA
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 15:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732695AbgFSNYK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 09:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732284AbgFSNYJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 09:24:09 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 256E8C06174E
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 06:24:09 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id a127so4409072pfa.12
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 06:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ePv4llE+vFMyLfn4uiyXImE3YwayU5F5aWM49gXAQ/s=;
        b=VgOf8NvZ4ZZlVtddVQv355DpM2/+CK8vewOHl4W2Cl7Ln9QsTFzQFQ8iIQpdjVh3Va
         FCw8ExkTFo5KACrX98oaAfYJNK1tQieoaNutgiCKdPRksukmIGTbCeZWSmTAVET1hyKY
         tBn4LY1x6pxYuFOarNTCPh42L91Wqei6UW4kCRsNPk57Q/fDfrKvMerhe28A+9qTTa0V
         moqldwMsTefW/4POB9fBiAPsKofUIqGRdyil5LZ9YkM1yfvp67QcLhInEi3z8xs2XrSe
         Py5ioCqgX2w9FYpjYcDjYPBBfffn8lRgnmA2LtNNj6nyU/fQ7sZITpR1vizIA60a6bB7
         kxwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ePv4llE+vFMyLfn4uiyXImE3YwayU5F5aWM49gXAQ/s=;
        b=PWhwhKL99KCHzYUTeleWTQgQnKiYzSwVdRpuBVwZEmYX/2Sq7ooYnCXgLq63OECoKa
         I3IOtw/mFNd5Qi/Sk1f+8NCp7Fn7ckmZCjA1mMeenIPxbCt53W3eFSFvGG11yzCtlQSt
         GTSUKiwHfOsJmR3kG5uO/2Pf6MBpQC401vqYsNF/iYNNXIlQCImqRxn4EF7EDq3/pBjV
         j7NpneUYPlUBAU6bwAPLTs8NtaLUKICizu8eUJDU+Zyb1VM5be5OPHrhytHyloOG0y2a
         rzVSWjyOst1UkCEck9iaCmVdppVhtl05dB6+1U0B9+KMvomf8J/uq35X7jQ5QgCOe49y
         ZVyA==
X-Gm-Message-State: AOAM532PdHOP+9Su5cjDrdq8oIP08+dB0PB4a3Wvg65ZZJrHsJHZhCwB
        h0MxKCP93cBpvOeiLNczL3wkRaoMxT8=
X-Google-Smtp-Source: ABdhPJylIhACMD9MCTOpJhMMUyiU2D84Caoc6zyxnVfu++/PgGMh6y+LUKSgLzghzCbHO/LHYf4LAg==
X-Received: by 2002:a62:7e8d:: with SMTP id z135mr7769559pfc.251.1592573047500;
        Fri, 19 Jun 2020 06:24:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y3sm6205178pff.37.2020.06.19.06.24.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2020 06:24:06 -0700 (PDT)
Message-ID: <5eecbc76.1c69fb81.4a031.2c02@mx.google.com>
Date:   Fri, 19 Jun 2020 06:24:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.126-297-gb5864ea3e33d
Subject: stable-rc/linux-4.19.y build: 166 builds: 47 failed, 119 passed,
 48 errors, 4 warnings (v4.19.126-297-gb5864ea3e33d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y build: 166 builds: 47 failed, 119 passed, 48 errors,=
 4 warnings (v4.19.126-297-gb5864ea3e33d)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.126-297-gb5864ea3e33d/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.126-297-gb5864ea3e33d
Git Commit: b5864ea3e33dee09980084ac6edf45acad95075d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 7 unique architectures

Build Failures Detected:

mips:
    32r2el_defconfig: (gcc-8) FAIL
    ar7_defconfig: (gcc-8) FAIL
    ath25_defconfig: (gcc-8) FAIL
    ath79_defconfig: (gcc-8) FAIL
    bcm47xx_defconfig: (gcc-8) FAIL
    bcm63xx_defconfig: (gcc-8) FAIL
    bmips_be_defconfig: (gcc-8) FAIL
    bmips_stb_defconfig: (gcc-8) FAIL
    capcella_defconfig: (gcc-8) FAIL
    ci20_defconfig: (gcc-8) FAIL
    db1xxx_defconfig: (gcc-8) FAIL
    decstation_defconfig: (gcc-8) FAIL
    e55_defconfig: (gcc-8) FAIL
    fuloong2e_defconfig: (gcc-8) FAIL
    gcw0_defconfig: (gcc-8) FAIL
    gpr_defconfig: (gcc-8) FAIL
    ip28_defconfig: (gcc-8) FAIL
    ip32_defconfig: (gcc-8) FAIL
    jazz_defconfig: (gcc-8) FAIL
    jmr3927_defconfig: (gcc-8) FAIL
    lasat_defconfig: (gcc-8) FAIL
    lemote2f_defconfig: (gcc-8) FAIL
    loongson1b_defconfig: (gcc-8) FAIL
    loongson1c_defconfig: (gcc-8) FAIL
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
    mpc30x_defconfig: (gcc-8) FAIL
    mtx1_defconfig: (gcc-8) FAIL
    pic32mzda_defconfig: (gcc-8) FAIL
    pistachio_defconfig: (gcc-8) FAIL
    pnx8335_stb225_defconfig: (gcc-8) FAIL
    qi_lb60_defconfig: (gcc-8) FAIL
    rb532_defconfig: (gcc-8) FAIL
    rt305x_defconfig: (gcc-8) FAIL
    tb0219_defconfig: (gcc-8) FAIL
    tb0226_defconfig: (gcc-8) FAIL
    tb0287_defconfig: (gcc-8) FAIL
    tinyconfig: (gcc-8) FAIL
    vocore2_defconfig: (gcc-8) FAIL

Errors and Warnings Detected:

arc:

arm64:

arm:
    multi_v7_defconfig (gcc-8): 1 warning

i386:

mips:
    32r2el_defconfig (gcc-8): 1 error
    ar7_defconfig (gcc-8): 1 error
    ath25_defconfig (gcc-8): 1 error
    ath79_defconfig (gcc-8): 1 error
    bcm47xx_defconfig (gcc-8): 1 error
    bcm63xx_defconfig (gcc-8): 1 error
    bmips_be_defconfig (gcc-8): 1 error
    bmips_stb_defconfig (gcc-8): 2 errors
    capcella_defconfig (gcc-8): 1 error
    ci20_defconfig (gcc-8): 1 error
    db1xxx_defconfig (gcc-8): 1 error
    decstation_defconfig (gcc-8): 1 error
    e55_defconfig (gcc-8): 1 error
    fuloong2e_defconfig (gcc-8): 1 error
    gcw0_defconfig (gcc-8): 1 error
    gpr_defconfig (gcc-8): 1 error
    ip28_defconfig (gcc-8): 1 error
    ip32_defconfig (gcc-8): 1 error
    jazz_defconfig (gcc-8): 1 error
    jmr3927_defconfig (gcc-8): 1 error
    lasat_defconfig (gcc-8): 1 error
    lemote2f_defconfig (gcc-8): 1 error
    loongson1b_defconfig (gcc-8): 1 error
    loongson1c_defconfig (gcc-8): 1 error
    loongson3_defconfig (gcc-8): 2 warnings
    malta_defconfig (gcc-8): 1 error
    malta_kvm_defconfig (gcc-8): 1 error
    malta_kvm_guest_defconfig (gcc-8): 1 error
    malta_qemu_32r6_defconfig (gcc-8): 1 error
    maltaaprp_defconfig (gcc-8): 1 error
    maltasmvp_defconfig (gcc-8): 1 error
    maltasmvp_eva_defconfig (gcc-8): 1 error
    maltaup_defconfig (gcc-8): 1 error
    maltaup_xpa_defconfig (gcc-8): 1 error
    markeins_defconfig (gcc-8): 1 error
    mpc30x_defconfig (gcc-8): 1 error
    mtx1_defconfig (gcc-8): 1 error
    pic32mzda_defconfig (gcc-8): 1 error
    pistachio_defconfig (gcc-8): 1 error
    pnx8335_stb225_defconfig (gcc-8): 1 error
    qi_lb60_defconfig (gcc-8): 1 error
    rb532_defconfig (gcc-8): 1 error
    rt305x_defconfig (gcc-8): 1 error
    tb0219_defconfig (gcc-8): 1 error
    tb0226_defconfig (gcc-8): 1 error
    tb0287_defconfig (gcc-8): 1 error
    tinyconfig (gcc-8): 1 error
    vocore2_defconfig (gcc-8): 1 error

riscv:

x86_64:
    tinyconfig (gcc-8): 1 warning

Errors summary:

    47   arch/mips/mm/dma-noncoherent.c:59:7: error: =E2=80=98CPU_LOONGSON2=
EF=E2=80=99 undeclared (first use in this function); did you mean =E2=80=98=
CPU_LOONGSON2=E2=80=99?
    1    arch/mips/kernel/time.c:44:29: error: =E2=80=98struct cpufreq_freq=
s=E2=80=99 has no member named =E2=80=98policy=E2=80=99

Warnings summary:

    1    net/core/rtnetlink.c:3190:1: warning: the frame size of 1312 bytes=
 is larger than 1024 bytes [-Wframe-larger-than=3D]
    1    arch/mips/configs/loongson3_defconfig:55:warning: symbol value 'm'=
 invalid for HOTPLUG_PCI_SHPC
    1    arch/arm/boot/dts/sun8i-h3-beelink-x2.dtb: Warning (clocks_propert=
y): /wifi_pwrseq: Missing property '#clock-cells' in node /soc/rtc@1f00000 =
or bad phandle (referred from clocks[0])
    1    .config:1010:warning: override: UNWINDER_GUESS changes choice state

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
32r2el_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/mips/mm/dma-noncoherent.c:59:7: error: =E2=80=98CPU_LOONGSON2EF=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98CPU_L=
OONGSON2=E2=80=99?

---------------------------------------------------------------------------=
-----
allnoconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
allnoconfig (riscv, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
am200epdkit_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
ar7_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section =
mismatches

Errors:
    arch/mips/mm/dma-noncoherent.c:59:7: error: =E2=80=98CPU_LOONGSON2EF=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98CPU_L=
OONGSON2=E2=80=99?

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
ath25_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/mips/mm/dma-noncoherent.c:59:7: error: =E2=80=98CPU_LOONGSON2EF=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98CPU_L=
OONGSON2=E2=80=99?

---------------------------------------------------------------------------=
-----
ath79_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/mips/mm/dma-noncoherent.c:59:7: error: =E2=80=98CPU_LOONGSON2EF=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98CPU_L=
OONGSON2=E2=80=99?

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
bcm2835_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
bcm47xx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    arch/mips/mm/dma-noncoherent.c:59:7: error: =E2=80=98CPU_LOONGSON2EF=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98CPU_L=
OONGSON2=E2=80=99?

---------------------------------------------------------------------------=
-----
bcm63xx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    arch/mips/mm/dma-noncoherent.c:59:7: error: =E2=80=98CPU_LOONGSON2EF=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98CPU_L=
OONGSON2=E2=80=99?

---------------------------------------------------------------------------=
-----
bigsur_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/mips/mm/dma-noncoherent.c:59:7: error: =E2=80=98CPU_LOONGSON2EF=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98CPU_L=
OONGSON2=E2=80=99?

---------------------------------------------------------------------------=
-----
bmips_stb_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    arch/mips/mm/dma-noncoherent.c:59:7: error: =E2=80=98CPU_LOONGSON2EF=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98CPU_L=
OONGSON2=E2=80=99?
    arch/mips/kernel/time.c:44:29: error: =E2=80=98struct cpufreq_freqs=E2=
=80=99 has no member named =E2=80=98policy=E2=80=99

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/mips/mm/dma-noncoherent.c:59:7: error: =E2=80=98CPU_LOONGSON2EF=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98CPU_L=
OONGSON2=E2=80=99?

---------------------------------------------------------------------------=
-----
ci20_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    arch/mips/mm/dma-noncoherent.c:59:7: error: =E2=80=98CPU_LOONGSON2EF=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98CPU_L=
OONGSON2=E2=80=99?

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
colibri_pxa270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

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
db1xxx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/mips/mm/dma-noncoherent.c:59:7: error: =E2=80=98CPU_LOONGSON2EF=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98CPU_L=
OONGSON2=E2=80=99?

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    arch/mips/mm/dma-noncoherent.c:59:7: error: =E2=80=98CPU_LOONGSON2EF=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98CPU_L=
OONGSON2=E2=80=99?

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
e55_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section =
mismatches

Errors:
    arch/mips/mm/dma-noncoherent.c:59:7: error: =E2=80=98CPU_LOONGSON2EF=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98CPU_L=
OONGSON2=E2=80=99?

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
ezx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
fuloong2e_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    arch/mips/mm/dma-noncoherent.c:59:7: error: =E2=80=98CPU_LOONGSON2EF=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98CPU_L=
OONGSON2=E2=80=99?

---------------------------------------------------------------------------=
-----
gcw0_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    arch/mips/mm/dma-noncoherent.c:59:7: error: =E2=80=98CPU_LOONGSON2EF=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98CPU_L=
OONGSON2=E2=80=99?

---------------------------------------------------------------------------=
-----
gpr_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section =
mismatches

Errors:
    arch/mips/mm/dma-noncoherent.c:59:7: error: =E2=80=98CPU_LOONGSON2EF=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98CPU_L=
OONGSON2=E2=80=99?

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
hsdk_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

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
integrator_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
iop13xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
iop33x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
ip27_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
ip28_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    arch/mips/mm/dma-noncoherent.c:59:7: error: =E2=80=98CPU_LOONGSON2EF=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98CPU_L=
OONGSON2=E2=80=99?

---------------------------------------------------------------------------=
-----
ip32_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    arch/mips/mm/dma-noncoherent.c:59:7: error: =E2=80=98CPU_LOONGSON2EF=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98CPU_L=
OONGSON2=E2=80=99?

---------------------------------------------------------------------------=
-----
ixp4xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    arch/mips/mm/dma-noncoherent.c:59:7: error: =E2=80=98CPU_LOONGSON2EF=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98CPU_L=
OONGSON2=E2=80=99?

---------------------------------------------------------------------------=
-----
jmr3927_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    arch/mips/mm/dma-noncoherent.c:59:7: error: =E2=80=98CPU_LOONGSON2EF=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98CPU_L=
OONGSON2=E2=80=99?

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
lasat_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/mips/mm/dma-noncoherent.c:59:7: error: =E2=80=98CPU_LOONGSON2EF=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98CPU_L=
OONGSON2=E2=80=99?

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/mips/mm/dma-noncoherent.c:59:7: error: =E2=80=98CPU_LOONGSON2EF=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98CPU_L=
OONGSON2=E2=80=99?

---------------------------------------------------------------------------=
-----
loongson1b_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    arch/mips/mm/dma-noncoherent.c:59:7: error: =E2=80=98CPU_LOONGSON2EF=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98CPU_L=
OONGSON2=E2=80=99?

---------------------------------------------------------------------------=
-----
loongson1c_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    arch/mips/mm/dma-noncoherent.c:59:7: error: =E2=80=98CPU_LOONGSON2EF=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98CPU_L=
OONGSON2=E2=80=99?

---------------------------------------------------------------------------=
-----
loongson3_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 s=
ection mismatches

Warnings:
    arch/mips/configs/loongson3_defconfig:55:warning: symbol value 'm' inva=
lid for HOTPLUG_PCI_SHPC
    net/core/rtnetlink.c:3190:1: warning: the frame size of 1312 bytes is l=
arger than 1024 bytes [-Wframe-larger-than=3D]

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
mainstone_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
malta_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/mips/mm/dma-noncoherent.c:59:7: error: =E2=80=98CPU_LOONGSON2EF=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98CPU_L=
OONGSON2=E2=80=99?

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    arch/mips/mm/dma-noncoherent.c:59:7: error: =E2=80=98CPU_LOONGSON2EF=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98CPU_L=
OONGSON2=E2=80=99?

---------------------------------------------------------------------------=
-----
malta_kvm_guest_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings=
, 0 section mismatches

Errors:
    arch/mips/mm/dma-noncoherent.c:59:7: error: =E2=80=98CPU_LOONGSON2EF=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98CPU_L=
OONGSON2=E2=80=99?

---------------------------------------------------------------------------=
-----
malta_qemu_32r6_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings=
, 0 section mismatches

Errors:
    arch/mips/mm/dma-noncoherent.c:59:7: error: =E2=80=98CPU_LOONGSON2EF=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98CPU_L=
OONGSON2=E2=80=99?

---------------------------------------------------------------------------=
-----
maltaaprp_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    arch/mips/mm/dma-noncoherent.c:59:7: error: =E2=80=98CPU_LOONGSON2EF=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98CPU_L=
OONGSON2=E2=80=99?

---------------------------------------------------------------------------=
-----
maltasmvp_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    arch/mips/mm/dma-noncoherent.c:59:7: error: =E2=80=98CPU_LOONGSON2EF=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98CPU_L=
OONGSON2=E2=80=99?

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, =
0 section mismatches

Errors:
    arch/mips/mm/dma-noncoherent.c:59:7: error: =E2=80=98CPU_LOONGSON2EF=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98CPU_L=
OONGSON2=E2=80=99?

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    arch/mips/mm/dma-noncoherent.c:59:7: error: =E2=80=98CPU_LOONGSON2EF=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98CPU_L=
OONGSON2=E2=80=99?

---------------------------------------------------------------------------=
-----
maltaup_xpa_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 =
section mismatches

Errors:
    arch/mips/mm/dma-noncoherent.c:59:7: error: =E2=80=98CPU_LOONGSON2EF=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98CPU_L=
OONGSON2=E2=80=99?

---------------------------------------------------------------------------=
-----
markeins_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/mips/mm/dma-noncoherent.c:59:7: error: =E2=80=98CPU_LOONGSON2EF=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98CPU_L=
OONGSON2=E2=80=99?

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
mips_paravirt_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

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
mpc30x_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/mips/mm/dma-noncoherent.c:59:7: error: =E2=80=98CPU_LOONGSON2EF=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98CPU_L=
OONGSON2=E2=80=99?

---------------------------------------------------------------------------=
-----
mps2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
mtx1_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    arch/mips/mm/dma-noncoherent.c:59:7: error: =E2=80=98CPU_LOONGSON2EF=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98CPU_L=
OONGSON2=E2=80=99?

---------------------------------------------------------------------------=
-----
multi_v4t_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    arch/arm/boot/dts/sun8i-h3-beelink-x2.dtb: Warning (clocks_property): /=
wifi_pwrseq: Missing property '#clock-cells' in node /soc/rtc@1f00000 or ba=
d phandle (referred from clocks[0])

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
nsim_hs_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
nsim_hs_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
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
omap1_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

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
pic32mzda_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    arch/mips/mm/dma-noncoherent.c:59:7: error: =E2=80=98CPU_LOONGSON2EF=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98CPU_L=
OONGSON2=E2=80=99?

---------------------------------------------------------------------------=
-----
pistachio_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    arch/mips/mm/dma-noncoherent.c:59:7: error: =E2=80=98CPU_LOONGSON2EF=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98CPU_L=
OONGSON2=E2=80=99?

---------------------------------------------------------------------------=
-----
pleb_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
pnx8335_stb225_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings,=
 0 section mismatches

Errors:
    arch/mips/mm/dma-noncoherent.c:59:7: error: =E2=80=98CPU_LOONGSON2EF=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98CPU_L=
OONGSON2=E2=80=99?

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
qi_lb60_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    arch/mips/mm/dma-noncoherent.c:59:7: error: =E2=80=98CPU_LOONGSON2EF=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98CPU_L=
OONGSON2=E2=80=99?

---------------------------------------------------------------------------=
-----
raumfeld_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
rb532_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/mips/mm/dma-noncoherent.c:59:7: error: =E2=80=98CPU_LOONGSON2EF=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98CPU_L=
OONGSON2=E2=80=99?

---------------------------------------------------------------------------=
-----
realview_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
rpc_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/mips/mm/dma-noncoherent.c:59:7: error: =E2=80=98CPU_LOONGSON2EF=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98CPU_L=
OONGSON2=E2=80=99?

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
sb1250_swarm_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, =
0 section mismatches

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
tb0219_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/mips/mm/dma-noncoherent.c:59:7: error: =E2=80=98CPU_LOONGSON2EF=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98CPU_L=
OONGSON2=E2=80=99?

---------------------------------------------------------------------------=
-----
tb0226_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/mips/mm/dma-noncoherent.c:59:7: error: =E2=80=98CPU_LOONGSON2EF=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98CPU_L=
OONGSON2=E2=80=99?

---------------------------------------------------------------------------=
-----
tb0287_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/mips/mm/dma-noncoherent.c:59:7: error: =E2=80=98CPU_LOONGSON2EF=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98CPU_L=
OONGSON2=E2=80=99?

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
tinyconfig (riscv, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
tinyconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    .config:1010:warning: override: UNWINDER_GUESS changes choice state

---------------------------------------------------------------------------=
-----
tinyconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section mis=
matches

Errors:
    arch/mips/mm/dma-noncoherent.c:59:7: error: =E2=80=98CPU_LOONGSON2EF=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98CPU_L=
OONGSON2=E2=80=99?

---------------------------------------------------------------------------=
-----
tinyconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

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
vocore2_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    arch/mips/mm/dma-noncoherent.c:59:7: error: =E2=80=98CPU_LOONGSON2EF=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98CPU_L=
OONGSON2=E2=80=99?

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
zeus_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
zx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---
For more info write to <info@kernelci.org>
