Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED5459632C
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 21:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236885AbiHPTcB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 15:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236768AbiHPTcA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 15:32:00 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA360870AC
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 12:31:56 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d20so10171586pfq.5
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 12:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=28ycXnYC182R+uRK69QspbxEDw6qyP7YcJltTmUumAg=;
        b=T14Rq+crW/+MKZgHqqo6ZACsuNKl2jPnohD7HBy+mYN8ReXt52QT+OgpifL/BT/P5m
         rmZmwTzhs0pSx5/mA3Nyxk1EnWjhmVOp1AfUmAllxT79qRMH7I269C+WugJhPwzABKlk
         +OSkHC7YH8n7jKJfMu1MtakwWWqsekwS8T3RWMNrPpQbXnueLt6xEl1tSCTE0M9JcUas
         CKV1Mr1/eAe5ltLTTT1t9EV24iAVdAfLcWSe2J2x6+5IKj0mJBRnmT2cSZXVlzM6xBPH
         HrA6naN3XZ1GjfensQRliM+ULezCvlHsYSWmgUrTHLJ5Hd3V4xJ95JqT+FYx/XK/9NDf
         E7XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=28ycXnYC182R+uRK69QspbxEDw6qyP7YcJltTmUumAg=;
        b=boxqMSx0ni23ssgDoO6duU9BMN5GNryQLfkXXU4GvyR8gP/bF8GJx2/9/DeZy0kig6
         v1SLxmPCXdhxhquNry3lZbgnCVQt4wl9KtC7qoBf5Xm6OFk1Fd455Dgmj+MHYWkCdmvF
         R8mRIvxD9DysoHwpafdoaYNX2rbPlYiTntYOzm3t0HxoUWxmXuzV6KwUNt4TpE6DaIgY
         fT1oGt/yGWGVAzL/o7O+B5qYkP8DNR3ERQz/83eRViggeVq3aU8ec35S0jTMm6AbIYvR
         aZmwLR0spKeMjPQGtIFf58t+tR24ZzYqo/UjGczV6CmD0oKqH1gvqEmLui8WXZR05/6A
         s1hQ==
X-Gm-Message-State: ACgBeo0VomFtI53MkZo8fCTb2LmCptwqzKho76FJx6gZwFsOc1bI7nZf
        NzvYoGCiIlNmt9J2cvg4EWoNM7t8cOIP2uhi
X-Google-Smtp-Source: AA6agR4dUlW5T32uTlJpALr/azJoiZ/H8gIYmG+BYlmm08HUN6Yf6yOmd5Z5Skk4pLZs5RiLQYSMEA==
X-Received: by 2002:a63:e054:0:b0:41d:6628:10b3 with SMTP id n20-20020a63e054000000b0041d662810b3mr18530910pgj.506.1660678314771;
        Tue, 16 Aug 2022 12:31:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p6-20020a170902780600b0016efa52d428sm9429448pll.218.2022.08.16.12.31.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 12:31:54 -0700 (PDT)
Message-ID: <62fbf0aa.170a0220.a5027.0841@mx.google.com>
Date:   Tue, 16 Aug 2022 12:31:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v4.9.325-63-g2ae8452db3fed
Subject: stable-rc/queue/4.9 build: 183 builds: 50 failed, 133 passed,
 61 errors, 34 warnings (v4.9.325-63-g2ae8452db3fed)
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

stable-rc/queue/4.9 build: 183 builds: 50 failed, 133 passed, 61 errors, 34=
 warnings (v4.9.325-63-g2ae8452db3fed)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F4.9=
/kernel/v4.9.325-63-g2ae8452db3fed/

Tree: stable-rc
Branch: queue/4.9
Git Describe: v4.9.325-63-g2ae8452db3fed
Git Commit: 2ae8452db3fed6ebd4e8ce7f9004c56c15e7bbe3
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 6 unique architectures

Build Failures Detected:

arm:
    acs5k_defconfig: (gcc-10) FAIL
    at91_dt_defconfig: (gcc-10) FAIL
    cm_x2xx_defconfig: (gcc-10) FAIL
    dove_defconfig: (gcc-10) FAIL
    ebsa110_defconfig: (gcc-10) FAIL
    exynos_defconfig: (gcc-10) FAIL
    footbridge_defconfig: (gcc-10) FAIL
    imx_v6_v7_defconfig: (gcc-10) FAIL
    integrator_defconfig: (gcc-10) FAIL
    iop13xx_defconfig: (gcc-10) FAIL
    iop32x_defconfig: (gcc-10) FAIL
    iop33x_defconfig: (gcc-10) FAIL
    ixp4xx_defconfig: (gcc-10) FAIL
    keystone_defconfig: (gcc-10) FAIL
    ks8695_defconfig: (gcc-10) FAIL
    lpd270_defconfig: (gcc-10) FAIL
    mainstone_defconfig: (gcc-10) FAIL
    mmp2_defconfig: (gcc-10) FAIL
    multi_v5_defconfig: (gcc-10) FAIL
    mv78xx0_defconfig: (gcc-10) FAIL
    mvebu_v5_defconfig: (gcc-10) FAIL
    mvebu_v7_defconfig: (gcc-10) FAIL
    netwinder_defconfig: (gcc-10) FAIL
    nhk8815_defconfig: (gcc-10) FAIL
    omap1_defconfig: (gcc-10) FAIL
    orion5x_defconfig: (gcc-10) FAIL
    pcm027_defconfig: (gcc-10) FAIL
    pleb_defconfig: (gcc-10) FAIL
    pxa168_defconfig: (gcc-10) FAIL
    pxa255-idp_defconfig: (gcc-10) FAIL
    pxa3xx_defconfig: (gcc-10) FAIL
    pxa910_defconfig: (gcc-10) FAIL
    pxa_defconfig: (gcc-10) FAIL
    raumfeld_defconfig: (gcc-10) FAIL
    realview_defconfig: (gcc-10) FAIL
    shmobile_defconfig: (gcc-10) FAIL
    socfpga_defconfig: (gcc-10) FAIL
    spear13xx_defconfig: (gcc-10) FAIL
    spear3xx_defconfig: (gcc-10) FAIL
    spear6xx_defconfig: (gcc-10) FAIL
    sunxi_defconfig: (gcc-10) FAIL
    tegra_defconfig: (gcc-10) FAIL
    u8500_defconfig: (gcc-10) FAIL
    versatile_defconfig: (gcc-10) FAIL
    vexpress_defconfig: (gcc-10) FAIL
    viper_defconfig: (gcc-10) FAIL
    vt8500_v6_v7_defconfig: (gcc-10) FAIL

mips:
    ip27_defconfig: (gcc-10) FAIL
    ip28_defconfig: (gcc-10) FAIL
    malta_qemu_32r6_defconfig: (gcc-10) FAIL

Errors and Warnings Detected:

arc:

arm64:

arm:
    acs5k_defconfig (gcc-10): 1 error
    at91_dt_defconfig (gcc-10): 2 errors
    cm_x2xx_defconfig (gcc-10): 1 error
    dove_defconfig (gcc-10): 1 error
    ebsa110_defconfig (gcc-10): 9 errors
    exynos_defconfig (gcc-10): 1 error
    footbridge_defconfig (gcc-10): 1 error
    imx_v6_v7_defconfig (gcc-10): 3 errors
    integrator_defconfig (gcc-10): 1 error
    iop13xx_defconfig (gcc-10): 1 error
    iop32x_defconfig (gcc-10): 1 error
    iop33x_defconfig (gcc-10): 1 error
    ixp4xx_defconfig (gcc-10): 1 error
    keystone_defconfig (gcc-10): 1 error
    ks8695_defconfig (gcc-10): 1 error
    lpd270_defconfig (gcc-10): 1 error
    mainstone_defconfig (gcc-10): 1 error
    mini2440_defconfig (gcc-10): 1 warning
    mmp2_defconfig (gcc-10): 1 error
    multi_v5_defconfig (gcc-10): 2 errors
    mv78xx0_defconfig (gcc-10): 1 error
    mvebu_v5_defconfig (gcc-10): 1 error
    mvebu_v7_defconfig (gcc-10): 1 error
    netwinder_defconfig (gcc-10): 1 error
    nhk8815_defconfig (gcc-10): 1 error
    omap1_defconfig (gcc-10): 1 error, 1 warning
    orion5x_defconfig (gcc-10): 1 error
    pcm027_defconfig (gcc-10): 1 error
    pleb_defconfig (gcc-10): 1 error
    pxa168_defconfig (gcc-10): 1 error
    pxa255-idp_defconfig (gcc-10): 1 error
    pxa3xx_defconfig (gcc-10): 1 error
    pxa910_defconfig (gcc-10): 1 error
    pxa_defconfig (gcc-10): 1 error
    raumfeld_defconfig (gcc-10): 1 error
    realview_defconfig (gcc-10): 1 error
    s3c2410_defconfig (gcc-10): 1 warning
    shmobile_defconfig (gcc-10): 2 errors
    socfpga_defconfig (gcc-10): 1 error
    spear13xx_defconfig (gcc-10): 1 error
    spear3xx_defconfig (gcc-10): 1 error
    spear6xx_defconfig (gcc-10): 1 error
    sunxi_defconfig (gcc-10): 1 error
    tegra_defconfig (gcc-10): 2 errors
    u8500_defconfig (gcc-10): 1 error
    versatile_defconfig (gcc-10): 1 error
    vexpress_defconfig (gcc-10): 1 error
    viper_defconfig (gcc-10): 1 error
    vt8500_v6_v7_defconfig (gcc-10): 1 error

i386:
    allnoconfig (gcc-10): 3 warnings
    i386_defconfig (gcc-10): 3 warnings
    tinyconfig (gcc-10): 3 warnings

mips:
    mtx1_defconfig (gcc-10): 3 warnings

x86_64:
    allnoconfig (gcc-10): 5 warnings
    tinyconfig (gcc-10): 4 warnings
    x86_64_defconfig (gcc-10): 5 warnings
    x86_64_defconfig+x86-chromebook (gcc-10): 5 warnings

Errors summary:

    15   arm-linux-gnueabihf-ld: error: source object drivers/net/ethernet/=
smsc/built-in.o has EABI version 5, but target drivers/net/ethernet/built-i=
n.o has EABI version 0
    13   arm-linux-gnueabihf-ld: error: source object drivers/gpu/vga/built=
-in.o has EABI version 5, but target drivers/gpu/built-in.o has EABI versio=
n 0
    5    arm-linux-gnueabihf-ld: error: drivers/gpu/vga/built-in.o uses VFP=
 instructions, whereas drivers/gpu/built-in.o does not
    4    arm-linux-gnueabihf-ld: error: drivers/net/ethernet/smsc/built-in.=
o uses VFP instructions, whereas drivers/net/ethernet/built-in.o does not
    3    arm-linux-gnueabihf-ld: error: source object drivers/media/v4l2-co=
re/built-in.o has EABI version 5, but target drivers/media/built-in.o has E=
ABI version 0
    2    arm-linux-gnueabihf-ld: error: source object drivers/media/platfor=
m/built-in.o has EABI version 5, but target drivers/media/built-in.o has EA=
BI version 0
    2    arm-linux-gnueabihf-ld: error: drivers/net/ethernet/stmicro/built-=
in.o uses VFP instructions, whereas drivers/net/ethernet/built-in.o does not
    1    arm-linux-gnueabihf-ld: error: source object drivers/net/ethernet/=
via/built-in.o has EABI version 5, but target drivers/net/ethernet/built-in=
.o has EABI version 0
    1    arm-linux-gnueabihf-ld: error: source object drivers/net/ethernet/=
renesas/built-in.o has EABI version 5, but target drivers/net/ethernet/buil=
t-in.o has EABI version 0
    1    arm-linux-gnueabihf-ld: error: source object drivers/net/ethernet/=
marvell/built-in.o has EABI version 5, but target drivers/net/ethernet/buil=
t-in.o has EABI version 0
    1    arm-linux-gnueabihf-ld: error: source object drivers/net/ethernet/=
freescale/built-in.o has EABI version 5, but target drivers/net/ethernet/bu=
ilt-in.o has EABI version 0
    1    arm-linux-gnueabihf-ld: error: source object drivers/net/ethernet/=
cirrus/built-in.o has EABI version 5, but target drivers/net/ethernet/built=
-in.o has EABI version 0
    1    arm-linux-gnueabihf-ld: error: source object drivers/misc/vexpress=
-syscfg.o has EABI version 5, but target drivers/misc/built-in.o has EABI v=
ersion 0
    1    arm-linux-gnueabihf-ld: error: source object drivers/media/usb/bui=
lt-in.o has EABI version 5, but target drivers/media/built-in.o has EABI ve=
rsion 0
    1    arm-linux-gnueabihf-ld: error: source object drivers/media/rc/buil=
t-in.o has EABI version 5, but target drivers/media/built-in.o has EABI ver=
sion 0
    1    arm-linux-gnueabihf-ld: error: drivers/watchdog/built-in.o uses VF=
P instructions, whereas drivers/built-in.o does not
    1    arm-linux-gnueabihf-ld: error: drivers/tty/built-in.o uses VFP ins=
tructions, whereas drivers/built-in.o does not
    1    arm-linux-gnueabihf-ld: error: drivers/rtc/built-in.o uses VFP ins=
tructions, whereas drivers/built-in.o does not
    1    arm-linux-gnueabihf-ld: error: drivers/parport/built-in.o uses VFP=
 instructions, whereas drivers/built-in.o does not
    1    arm-linux-gnueabihf-ld: error: drivers/net/built-in.o uses VFP ins=
tructions, whereas drivers/built-in.o does not
    1    arm-linux-gnueabihf-ld: error: drivers/hwmon/built-in.o uses VFP i=
nstructions, whereas drivers/built-in.o does not
    1    arm-linux-gnueabihf-ld: error: drivers/char/built-in.o uses VFP in=
structions, whereas drivers/built-in.o does not
    1    arm-linux-gnueabihf-ld: error: drivers/block/built-in.o uses VFP i=
nstructions, whereas drivers/built-in.o does not
    1    arm-linux-gnueabihf-ld: error: drivers/base/built-in.o uses VFP in=
structions, whereas drivers/built-in.o does not

Warnings summary:

    7    ld: warning: creating DT_TEXTREL in a PIE
    7    arch/x86/kernel/process.c:460: Warning: no instruction mnemonic su=
ffix given and no register operands; using default for `btr'
    4    ld: arch/x86/boot/compressed/head_64.o: warning: relocation in rea=
d-only section `.head.text'
    4    arch/x86/entry/entry_64.S:1565: Warning: no instruction mnemonic s=
uffix given and no register operands; using default for `sysret'
    3    ld: arch/x86/boot/compressed/head_32.o: warning: relocation in rea=
d-only section `.head.text'
    3    arch/x86/entry/entry_32.S:452: Warning: no instruction mnemonic su=
ffix given and no register operands; using default for `btr'
    2    sound/pci/echoaudio/echoaudio_dsp.c:647:9: warning: iteration 1073=
741824 invokes undefined behavior [-Waggressive-loop-optimizations]
    2    drivers/tty/serial/samsung.c:1782:34: warning: array =E2=80=98s3c2=
4xx_uart_dt_match=E2=80=99 assumed to have one element
    1    sound/pci/echoaudio/echoaudio_dsp.c:658:9: warning: iteration 1073=
741824 invokes undefined behavior [-Waggressive-loop-optimizations]
    1    drivers/gpio/gpio-omap.c:1135:34: warning: array =E2=80=98omap_gpi=
o_match=E2=80=99 assumed to have one element

Section mismatches summary:

    8    WARNING: modpost: Found 1 section mismatch(es).

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
acs5k_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    arm-linux-gnueabihf-ld: error: source object drivers/gpu/vga/built-in.o=
 has EABI version 5, but target drivers/gpu/built-in.o has EABI version 0

---------------------------------------------------------------------------=
-----
acs5k_tiny_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (i386, gcc-10) =E2=80=94 PASS, 0 errors, 3 warnings, 0 section =
mismatches

Warnings:
    arch/x86/entry/entry_32.S:452: Warning: no instruction mnemonic suffix =
given and no register operands; using default for `btr'
    ld: arch/x86/boot/compressed/head_32.o: warning: relocation in read-onl=
y section `.head.text'
    ld: warning: creating DT_TEXTREL in a PIE

---------------------------------------------------------------------------=
-----
allnoconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
allnoconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (x86_64, gcc-10) =E2=80=94 PASS, 0 errors, 5 warnings, 0 sectio=
n mismatches

Warnings:
    arch/x86/entry/entry_64.S:1565: Warning: no instruction mnemonic suffix=
 given and no register operands; using default for `sysret'
    arch/x86/kernel/process.c:460: Warning: no instruction mnemonic suffix =
given and no register operands; using default for `btr'
    arch/x86/kernel/process.c:460: Warning: no instruction mnemonic suffix =
given and no register operands; using default for `btr'
    ld: arch/x86/boot/compressed/head_64.o: warning: relocation in read-onl=
y section `.head.text'
    ld: warning: creating DT_TEXTREL in a PIE

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
at91_dt_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    arm-linux-gnueabihf-ld: error: source object drivers/media/v4l2-core/bu=
ilt-in.o has EABI version 5, but target drivers/media/built-in.o has EABI v=
ersion 0
    arm-linux-gnueabihf-ld: error: source object drivers/media/platform/bui=
lt-in.o has EABI version 5, but target drivers/media/built-in.o has EABI ve=
rsion 0

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
bigsur_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
bmips_stb_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

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
cm_x2xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    arm-linux-gnueabihf-ld: error: source object drivers/gpu/vga/built-in.o=
 has EABI version 5, but target drivers/gpu/built-in.o has EABI version 0

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
davinci_all_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
defconfig+arm64-chromebook (arm64, gcc-10) =E2=80=94 PASS, 0 errors, 0 warn=
ings, 0 section mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
dove_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    arm-linux-gnueabihf-ld: error: source object drivers/gpu/vga/built-in.o=
 has EABI version 5, but target drivers/gpu/built-in.o has EABI version 0

---------------------------------------------------------------------------=
-----
e55_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
ebsa110_defconfig (arm, gcc-10) =E2=80=94 FAIL, 9 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    arm-linux-gnueabihf-ld: error: drivers/tty/built-in.o uses VFP instruct=
ions, whereas drivers/built-in.o does not
    arm-linux-gnueabihf-ld: error: drivers/char/built-in.o uses VFP instruc=
tions, whereas drivers/built-in.o does not
    arm-linux-gnueabihf-ld: error: drivers/parport/built-in.o uses VFP inst=
ructions, whereas drivers/built-in.o does not
    arm-linux-gnueabihf-ld: error: drivers/base/built-in.o uses VFP instruc=
tions, whereas drivers/built-in.o does not
    arm-linux-gnueabihf-ld: error: drivers/block/built-in.o uses VFP instru=
ctions, whereas drivers/built-in.o does not
    arm-linux-gnueabihf-ld: error: drivers/net/built-in.o uses VFP instruct=
ions, whereas drivers/built-in.o does not
    arm-linux-gnueabihf-ld: error: drivers/rtc/built-in.o uses VFP instruct=
ions, whereas drivers/built-in.o does not
    arm-linux-gnueabihf-ld: error: drivers/hwmon/built-in.o uses VFP instru=
ctions, whereas drivers/built-in.o does not
    arm-linux-gnueabihf-ld: error: drivers/watchdog/built-in.o uses VFP ins=
tructions, whereas drivers/built-in.o does not

---------------------------------------------------------------------------=
-----
efm32_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
em_x270_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arm-linux-gnueabihf-ld: error: source object drivers/net/ethernet/smsc/=
built-in.o has EABI version 5, but target drivers/net/ethernet/built-in.o h=
as EABI version 0

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    arm-linux-gnueabihf-ld: error: drivers/gpu/vga/built-in.o uses VFP inst=
ructions, whereas drivers/gpu/built-in.o does not

---------------------------------------------------------------------------=
-----
fuloong2e_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

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
hisi_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
i386_defconfig (i386, gcc-10) =E2=80=94 PASS, 0 errors, 3 warnings, 0 secti=
on mismatches

Warnings:
    arch/x86/entry/entry_32.S:452: Warning: no instruction mnemonic suffix =
given and no register operands; using default for `btr'
    ld: arch/x86/boot/compressed/head_32.o: warning: relocation in read-onl=
y section `.head.text'
    ld: warning: creating DT_TEXTREL in a PIE

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
imx_v6_v7_defconfig (arm, gcc-10) =E2=80=94 FAIL, 3 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    arm-linux-gnueabihf-ld: error: source object drivers/net/ethernet/cirru=
s/built-in.o has EABI version 5, but target drivers/net/ethernet/built-in.o=
 has EABI version 0
    arm-linux-gnueabihf-ld: error: source object drivers/net/ethernet/frees=
cale/built-in.o has EABI version 5, but target drivers/net/ethernet/built-i=
n.o has EABI version 0
    arm-linux-gnueabihf-ld: error: source object drivers/net/ethernet/smsc/=
built-in.o has EABI version 5, but target drivers/net/ethernet/built-in.o h=
as EABI version 0

---------------------------------------------------------------------------=
-----
integrator_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    arm-linux-gnueabihf-ld: error: source object drivers/gpu/vga/built-in.o=
 has EABI version 5, but target drivers/gpu/built-in.o has EABI version 0

---------------------------------------------------------------------------=
-----
iop13xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    arm-linux-gnueabihf-ld: error: drivers/gpu/vga/built-in.o uses VFP inst=
ructions, whereas drivers/gpu/built-in.o does not

---------------------------------------------------------------------------=
-----
iop32x_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arm-linux-gnueabihf-ld: error: drivers/gpu/vga/built-in.o uses VFP inst=
ructions, whereas drivers/gpu/built-in.o does not

---------------------------------------------------------------------------=
-----
iop33x_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arm-linux-gnueabihf-ld: error: drivers/gpu/vga/built-in.o uses VFP inst=
ructions, whereas drivers/gpu/built-in.o does not

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
ip32_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
ixp4xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arm-linux-gnueabihf-ld: error: source object drivers/gpu/vga/built-in.o=
 has EABI version 5, but target drivers/gpu/built-in.o has EABI version 0

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
keystone_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    arm-linux-gnueabihf-ld: error: source object drivers/gpu/vga/built-in.o=
 has EABI version 5, but target drivers/gpu/built-in.o has EABI version 0

---------------------------------------------------------------------------=
-----
ks8695_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arm-linux-gnueabihf-ld: error: source object drivers/gpu/vga/built-in.o=
 has EABI version 5, but target drivers/gpu/built-in.o has EABI version 0

---------------------------------------------------------------------------=
-----
lart_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
lasat_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

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
loongson3_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

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
lpd270_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arm-linux-gnueabihf-ld: error: drivers/net/ethernet/smsc/built-in.o use=
s VFP instructions, whereas drivers/net/ethernet/built-in.o does not

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
mainstone_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    arm-linux-gnueabihf-ld: error: drivers/net/ethernet/smsc/built-in.o use=
s VFP instructions, whereas drivers/net/ethernet/built-in.o does not

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
malta_kvm_guest_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnin=
gs, 0 section mismatches

---------------------------------------------------------------------------=
-----
malta_qemu_32r6_defconfig (mips, gcc-10) =E2=80=94 FAIL, 0 errors, 0 warnin=
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
markeins_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    drivers/tty/serial/samsung.c:1782:34: warning: array =E2=80=98s3c24xx_u=
art_dt_match=E2=80=99 assumed to have one element

---------------------------------------------------------------------------=
-----
mips_paravirt_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
mmp2_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    arm-linux-gnueabihf-ld: error: source object drivers/net/ethernet/smsc/=
built-in.o has EABI version 5, but target drivers/net/ethernet/built-in.o h=
as EABI version 0

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
msp71xx_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
mtx1_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 3 warnings, 0 secti=
on mismatches

Warnings:
    sound/pci/echoaudio/echoaudio_dsp.c:647:9: warning: iteration 107374182=
4 invokes undefined behavior [-Waggressive-loop-optimizations]
    sound/pci/echoaudio/echoaudio_dsp.c:658:9: warning: iteration 107374182=
4 invokes undefined behavior [-Waggressive-loop-optimizations]
    sound/pci/echoaudio/echoaudio_dsp.c:647:9: warning: iteration 107374182=
4 invokes undefined behavior [-Waggressive-loop-optimizations]

---------------------------------------------------------------------------=
-----
multi_v4t_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
multi_v5_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    arm-linux-gnueabihf-ld: error: source object drivers/media/v4l2-core/bu=
ilt-in.o has EABI version 5, but target drivers/media/built-in.o has EABI v=
ersion 0
    arm-linux-gnueabihf-ld: error: source object drivers/media/platform/bui=
lt-in.o has EABI version 5, but target drivers/media/built-in.o has EABI ve=
rsion 0

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
mv78xx0_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    arm-linux-gnueabihf-ld: error: source object drivers/gpu/vga/built-in.o=
 has EABI version 5, but target drivers/gpu/built-in.o has EABI version 0

---------------------------------------------------------------------------=
-----
mvebu_v5_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    arm-linux-gnueabihf-ld: error: source object drivers/gpu/vga/built-in.o=
 has EABI version 5, but target drivers/gpu/built-in.o has EABI version 0

---------------------------------------------------------------------------=
-----
mvebu_v7_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    arm-linux-gnueabihf-ld: error: source object drivers/gpu/vga/built-in.o=
 has EABI version 5, but target drivers/gpu/built-in.o has EABI version 0

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
netwinder_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    arm-linux-gnueabihf-ld: error: drivers/gpu/vga/built-in.o uses VFP inst=
ructions, whereas drivers/gpu/built-in.o does not

---------------------------------------------------------------------------=
-----
netx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
nhk8815_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    arm-linux-gnueabihf-ld: error: source object drivers/net/ethernet/smsc/=
built-in.o has EABI version 5, but target drivers/net/ethernet/built-in.o h=
as EABI version 0

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
nsim_hs_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
nsim_hs_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

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
nuc910_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
nuc950_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
nuc960_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
omap1_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    arm-linux-gnueabihf-ld: error: source object drivers/net/ethernet/smsc/=
built-in.o has EABI version 5, but target drivers/net/ethernet/built-in.o h=
as EABI version 0

Warnings:
    drivers/gpio/gpio-omap.c:1135:34: warning: array =E2=80=98omap_gpio_mat=
ch=E2=80=99 assumed to have one element

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
orion5x_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    arm-linux-gnueabihf-ld: error: source object drivers/net/ethernet/marve=
ll/built-in.o has EABI version 5, but target drivers/net/ethernet/built-in.=
o has EABI version 0

---------------------------------------------------------------------------=
-----
palmz72_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
pcm027_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arm-linux-gnueabihf-ld: error: source object drivers/net/ethernet/smsc/=
built-in.o has EABI version 5, but target drivers/net/ethernet/built-in.o h=
as EABI version 0

---------------------------------------------------------------------------=
-----
pic32mzda_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
pleb_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    arm-linux-gnueabihf-ld: error: drivers/net/ethernet/smsc/built-in.o use=
s VFP instructions, whereas drivers/net/ethernet/built-in.o does not

---------------------------------------------------------------------------=
-----
prima2_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
pxa168_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arm-linux-gnueabihf-ld: error: source object drivers/net/ethernet/smsc/=
built-in.o has EABI version 5, but target drivers/net/ethernet/built-in.o h=
as EABI version 0

---------------------------------------------------------------------------=
-----
pxa255-idp_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    arm-linux-gnueabihf-ld: error: drivers/net/ethernet/smsc/built-in.o use=
s VFP instructions, whereas drivers/net/ethernet/built-in.o does not

---------------------------------------------------------------------------=
-----
pxa3xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arm-linux-gnueabihf-ld: error: source object drivers/net/ethernet/smsc/=
built-in.o has EABI version 5, but target drivers/net/ethernet/built-in.o h=
as EABI version 0

---------------------------------------------------------------------------=
-----
pxa910_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arm-linux-gnueabihf-ld: error: source object drivers/net/ethernet/smsc/=
built-in.o has EABI version 5, but target drivers/net/ethernet/built-in.o h=
as EABI version 0

---------------------------------------------------------------------------=
-----
pxa_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section =
mismatches

Errors:
    arm-linux-gnueabihf-ld: error: source object drivers/gpu/vga/built-in.o=
 has EABI version 5, but target drivers/gpu/built-in.o has EABI version 0

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
raumfeld_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    arm-linux-gnueabihf-ld: error: source object drivers/net/ethernet/smsc/=
built-in.o has EABI version 5, but target drivers/net/ethernet/built-in.o h=
as EABI version 0

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
realview_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    arm-linux-gnueabihf-ld: error: source object drivers/net/ethernet/smsc/=
built-in.o has EABI version 5, but target drivers/net/ethernet/built-in.o h=
as EABI version 0

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
s3c2410_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    drivers/tty/serial/samsung.c:1782:34: warning: array =E2=80=98s3c24xx_u=
art_dt_match=E2=80=99 assumed to have one element

---------------------------------------------------------------------------=
-----
s3c6400_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
s5pv210_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
sama5_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
sb1250_swarm_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
shannon_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
shmobile_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    arm-linux-gnueabihf-ld: error: source object drivers/net/ethernet/renes=
as/built-in.o has EABI version 5, but target drivers/net/ethernet/built-in.=
o has EABI version 0
    arm-linux-gnueabihf-ld: error: source object drivers/net/ethernet/smsc/=
built-in.o has EABI version 5, but target drivers/net/ethernet/built-in.o h=
as EABI version 0

---------------------------------------------------------------------------=
-----
simpad_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
socfpga_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    arm-linux-gnueabihf-ld: error: source object drivers/gpu/vga/built-in.o=
 has EABI version 5, but target drivers/gpu/built-in.o has EABI version 0

---------------------------------------------------------------------------=
-----
spear13xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    arm-linux-gnueabihf-ld: error: source object drivers/gpu/vga/built-in.o=
 has EABI version 5, but target drivers/gpu/built-in.o has EABI version 0

---------------------------------------------------------------------------=
-----
spear3xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    arm-linux-gnueabihf-ld: error: drivers/net/ethernet/stmicro/built-in.o =
uses VFP instructions, whereas drivers/net/ethernet/built-in.o does not

---------------------------------------------------------------------------=
-----
spear6xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    arm-linux-gnueabihf-ld: error: drivers/net/ethernet/stmicro/built-in.o =
uses VFP instructions, whereas drivers/net/ethernet/built-in.o does not

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
sunxi_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    arm-linux-gnueabihf-ld: error: source object drivers/media/rc/built-in.=
o has EABI version 5, but target drivers/media/built-in.o has EABI version 0

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
tegra_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    arm-linux-gnueabihf-ld: error: source object drivers/media/v4l2-core/bu=
ilt-in.o has EABI version 5, but target drivers/media/built-in.o has EABI v=
ersion 0
    arm-linux-gnueabihf-ld: error: source object drivers/media/usb/built-in=
.o has EABI version 5, but target drivers/media/built-in.o has EABI version=
 0

---------------------------------------------------------------------------=
-----
tinyconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-10) =E2=80=94 PASS, 0 errors, 4 warnings, 0 section=
 mismatches

Warnings:
    arch/x86/entry/entry_64.S:1565: Warning: no instruction mnemonic suffix=
 given and no register operands; using default for `sysret'
    arch/x86/kernel/process.c:460: Warning: no instruction mnemonic suffix =
given and no register operands; using default for `btr'
    ld: arch/x86/boot/compressed/head_64.o: warning: relocation in read-onl=
y section `.head.text'
    ld: warning: creating DT_TEXTREL in a PIE

---------------------------------------------------------------------------=
-----
tinyconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
tinyconfig (i386, gcc-10) =E2=80=94 PASS, 0 errors, 3 warnings, 0 section m=
ismatches

Warnings:
    arch/x86/entry/entry_32.S:452: Warning: no instruction mnemonic suffix =
given and no register operands; using default for `btr'
    ld: arch/x86/boot/compressed/head_32.o: warning: relocation in read-onl=
y section `.head.text'
    ld: warning: creating DT_TEXTREL in a PIE

---------------------------------------------------------------------------=
-----
trizeps4_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
u300_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
u8500_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    arm-linux-gnueabihf-ld: error: source object drivers/net/ethernet/smsc/=
built-in.o has EABI version 5, but target drivers/net/ethernet/built-in.o h=
as EABI version 0

---------------------------------------------------------------------------=
-----
vdk_hs38_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, =
0 section mismatches

---------------------------------------------------------------------------=
-----
versatile_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    arm-linux-gnueabihf-ld: error: source object drivers/net/ethernet/smsc/=
built-in.o has EABI version 5, but target drivers/net/ethernet/built-in.o h=
as EABI version 0

---------------------------------------------------------------------------=
-----
vexpress_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    arm-linux-gnueabihf-ld: error: source object drivers/misc/vexpress-sysc=
fg.o has EABI version 5, but target drivers/misc/built-in.o has EABI versio=
n 0

---------------------------------------------------------------------------=
-----
vf610m4_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
viper_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    arm-linux-gnueabihf-ld: error: source object drivers/net/ethernet/smsc/=
built-in.o has EABI version 5, but target drivers/net/ethernet/built-in.o h=
as EABI version 0

---------------------------------------------------------------------------=
-----
vt8500_v6_v7_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0=
 section mismatches

Errors:
    arm-linux-gnueabihf-ld: error: source object drivers/net/ethernet/via/b=
uilt-in.o has EABI version 5, but target drivers/net/ethernet/built-in.o ha=
s EABI version 0

---------------------------------------------------------------------------=
-----
workpad_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
x86_64_defconfig (x86_64, gcc-10) =E2=80=94 PASS, 0 errors, 5 warnings, 0 s=
ection mismatches

Warnings:
    arch/x86/entry/entry_64.S:1565: Warning: no instruction mnemonic suffix=
 given and no register operands; using default for `sysret'
    arch/x86/kernel/process.c:460: Warning: no instruction mnemonic suffix =
given and no register operands; using default for `btr'
    arch/x86/kernel/process.c:460: Warning: no instruction mnemonic suffix =
given and no register operands; using default for `btr'
    ld: arch/x86/boot/compressed/head_64.o: warning: relocation in read-onl=
y section `.head.text'
    ld: warning: creating DT_TEXTREL in a PIE

---------------------------------------------------------------------------=
-----
x86_64_defconfig+x86-chromebook (x86_64, gcc-10) =E2=80=94 PASS, 0 errors, =
5 warnings, 0 section mismatches

Warnings:
    arch/x86/entry/entry_64.S:1565: Warning: no instruction mnemonic suffix=
 given and no register operands; using default for `sysret'
    arch/x86/kernel/process.c:460: Warning: no instruction mnemonic suffix =
given and no register operands; using default for `btr'
    arch/x86/kernel/process.c:460: Warning: no instruction mnemonic suffix =
given and no register operands; using default for `btr'
    ld: arch/x86/boot/compressed/head_64.o: warning: relocation in read-onl=
y section `.head.text'
    ld: warning: creating DT_TEXTREL in a PIE

---------------------------------------------------------------------------=
-----
xcep_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
xilfpga_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
zebu_hs_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
zebu_hs_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
zeus_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
zx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---
For more info write to <info@kernelci.org>
