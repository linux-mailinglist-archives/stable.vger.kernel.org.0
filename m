Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 173666BAFBE
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 12:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231608AbjCOL4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 07:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231563AbjCOL4c (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 07:56:32 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3635882359
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 04:56:26 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id p20so19686308plw.13
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 04:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678881385;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=TqWfVAO08tosPTPf4+fZGArayP1eLbQNxBp9q6Fv7L4=;
        b=FjugD71rLw7inhej5Wz2wR8C67wAr9bCwgDJ8GUPwh1wAW6mWhrlxKA+yN8Yd4iCbW
         40rlNpZ0x+OPzNTmaC1GlqqYczum1QTrByzvOWKQ8SZvXrUTeHY5ROnZ4MI1b0mw2Vc+
         IjsmIhUAo8P+7bBG8W+B00/K8EPiDdowMK6ZM6/4PmAwVXWsEM/c6FXD5v/4kiqf/6uR
         gFKIxAARK3fH33ddTvXKJR9Uu4r+/kfrlmLsn3EsorJ8RieE5JlYmrrUo7u9NL+W9UR3
         W1JNGtJJ9Vc80bU1YDd5VIZPtLfiZrIzs3T/JTsmvNibS+eZbduWKndeQLxHUIkjjugm
         hKHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678881385;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TqWfVAO08tosPTPf4+fZGArayP1eLbQNxBp9q6Fv7L4=;
        b=C6hKsLm9UQO7ysZ/9ywsCuCJUlD/b3YBHQCoxUEyGMlw3vb+vX5fahfmZ9ef4Fy8rZ
         DYJL6thjOyQf5ATGBDMK8rk+2FJ2t2sdXBLOxbiQ7bfcwlV+fiBGSDigdUO3UxwuwSv1
         EIaDcTVkydLzDjZSjXUlK3dNE8W1piWHCWmJQwVc1LkPglTJMCmzaiwA45704kdCqjkx
         5WykboD6NZgYXwvYAJ+df8FAiHykp47p25u1hpavJIq8U8hPOyEFAqPlpsQbOGVnGchF
         Ml7tA/5RqdDDacnnUJGu997NWuQqNEnL5Bwyqg4I5N20MJmIvUhrrhtGBjbSHVYRj0O2
         /KkA==
X-Gm-Message-State: AO0yUKUWgZVg3FXhYqRWtuQdb8QpCssSpvz4V5C99IWvp94ypFPt/yf0
        1RDrgOy8D5o46wTTF0X1hG+X/uGBe2SO+iE8aLZXLs8v
X-Google-Smtp-Source: AK7set9vRbHTOrZ1XzpflnIxWQlSw/apEJDW9jnDKpF3dAZzIbRZmeDpBNbZuC7eu/9xXog9nIBNRw==
X-Received: by 2002:a05:6a20:258c:b0:cd:11e3:4105 with SMTP id k12-20020a056a20258c00b000cd11e34105mr41102976pzd.27.1678881384819;
        Wed, 15 Mar 2023 04:56:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c21-20020aa78815000000b00625037cf695sm3376100pfo.86.2023.03.15.04.56.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 04:56:24 -0700 (PDT)
Message-ID: <6411b268.a70a0220.4a776.6eee@mx.google.com>
Date:   Wed, 15 Mar 2023 04:56:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.276-47-gcb91edfa52f0
X-Kernelci-Report-Type: build
Subject: stable-rc/linux-4.19.y build: 198 builds: 24 failed, 174 passed,
 36 errors, 39 warnings (v4.19.276-47-gcb91edfa52f0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y build: 198 builds: 24 failed, 174 passed, 36 errors,=
 39 warnings (v4.19.276-47-gcb91edfa52f0)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.276-47-gcb91edfa52f0/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.276-47-gcb91edfa52f0
Git Commit: cb91edfa52f0b1a9fca6342d158744cd1d673a57
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 7 unique architectures

Build Failures Detected:

arm64:
    defconfig: (gcc-10) FAIL
    defconfig+arm64-chromebook: (gcc-10) FAIL

arm:
    axm55xx_defconfig: (gcc-10) FAIL
    cns3420vb_defconfig: (gcc-10) FAIL
    davinci_all_defconfig: (gcc-10) FAIL
    exynos_defconfig: (gcc-10) FAIL
    multi_v5_defconfig: (gcc-10) FAIL
    multi_v7_defconfig: (gcc-10) FAIL
    s5pv210_defconfig: (gcc-10) FAIL
    sama5_defconfig: (gcc-10) FAIL
    sunxi_defconfig: (gcc-10) FAIL
    zx_defconfig: (gcc-10) FAIL

mips:
    32r2el_defconfig: (gcc-10) FAIL
    ci20_defconfig: (gcc-10) FAIL
    db1xxx_defconfig: (gcc-10) FAIL
    ip27_defconfig: (gcc-10) FAIL
    ip28_defconfig: (gcc-10) FAIL
    loongson3_defconfig: (gcc-10) FAIL
    omega2p_defconfig: (gcc-10) FAIL
    sb1250_swarm_defconfig: (gcc-10) FAIL
    vocore2_defconfig: (gcc-10) FAIL

riscv:
    allnoconfig: (gcc-10) FAIL
    defconfig: (gcc-10) FAIL
    tinyconfig: (gcc-10) FAIL

Errors and Warnings Detected:

arc:

arm64:
    defconfig (gcc-10): 2 errors, 1 warning
    defconfig+arm64-chromebook (gcc-10): 2 errors, 1 warning

arm:
    axm55xx_defconfig (gcc-10): 2 errors, 1 warning
    cns3420vb_defconfig (gcc-10): 2 errors, 1 warning
    davinci_all_defconfig (gcc-10): 2 errors, 1 warning
    multi_v5_defconfig (gcc-10): 2 errors, 1 warning
    omap1_defconfig (gcc-10): 1 warning
    s5pv210_defconfig (gcc-10): 2 errors, 1 warning
    sama5_defconfig (gcc-10): 2 errors, 1 warning
    sunxi_defconfig (gcc-10): 2 errors, 1 warning
    zx_defconfig (gcc-10): 2 errors, 1 warning

i386:
    allnoconfig (gcc-10): 2 warnings
    i386_defconfig (gcc-10): 2 warnings
    tinyconfig (gcc-10): 2 warnings

mips:
    32r2el_defconfig (gcc-10): 2 errors, 1 warning
    ci20_defconfig (gcc-10): 2 errors, 1 warning
    db1xxx_defconfig (gcc-10): 2 errors, 1 warning
    lemote2f_defconfig (gcc-10): 1 warning
    loongson3_defconfig (gcc-10): 2 errors, 1 warning
    malta_qemu_32r6_defconfig (gcc-10): 1 warning
    mtx1_defconfig (gcc-10): 3 warnings
    nlm_xlp_defconfig (gcc-10): 1 warning
    omega2p_defconfig (gcc-10): 2 errors, 1 warning
    sb1250_swarm_defconfig (gcc-10): 2 errors, 1 warning
    vocore2_defconfig (gcc-10): 2 errors, 1 warning

riscv:
    defconfig (gcc-10): 2 errors, 1 warning

x86_64:
    allnoconfig (gcc-10): 2 warnings
    tinyconfig (gcc-10): 2 warnings
    x86_64_defconfig (gcc-10): 2 warnings
    x86_64_defconfig+x86-chromebook (gcc-10): 2 warnings

Errors summary:

    18   kernel/cgroup/cgroup.c:2248:2: error: implicit declaration of func=
tion =E2=80=98put_online_cpus=E2=80=99; did you mean =E2=80=98num_online_cp=
us=E2=80=99? [-Werror=3Dimplicit-function-declaration]
    18   kernel/cgroup/cgroup.c:2237:2: error: implicit declaration of func=
tion =E2=80=98get_online_cpus=E2=80=99; did you mean =E2=80=98get_online_me=
ms=E2=80=99? [-Werror=3Dimplicit-function-declaration]

Warnings summary:

    18   cc1: some warnings being treated as errors
    7    ld: warning: creating DT_TEXTREL in a PIE
    4    ld: arch/x86/boot/compressed/head_64.o: warning: relocation in rea=
d-only section `.head.text'
    3    ld: arch/x86/boot/compressed/head_32.o: warning: relocation in rea=
d-only section `.head.text'
    2    sound/pci/echoaudio/echoaudio_dsp.c:647:9: warning: iteration 1073=
741824 invokes undefined behavior [-Waggressive-loop-optimizations]
    1    {standard input}:132: Warning: macro instruction expanded into mul=
tiple instructions
    1    sound/pci/echoaudio/echoaudio_dsp.c:658:9: warning: iteration 1073=
741824 invokes undefined behavior [-Waggressive-loop-optimizations]
    1    net/core/rtnetlink.c:3199:1: warning: the frame size of 1344 bytes=
 is larger than 1024 bytes [-Wframe-larger-than=3D]
    1    net/core/rtnetlink.c:3199:1: warning: the frame size of 1328 bytes=
 is larger than 1024 bytes [-Wframe-larger-than=3D]
    1    drivers/gpio/gpio-omap.c:1233:34: warning: array =E2=80=98omap_gpi=
o_match=E2=80=99 assumed to have one element

Section mismatches summary:

    9    WARNING: modpost: Found 1 section mismatch(es).

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
32r2el_defconfig (mips, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/cgroup/cgroup.c:2237:2: error: implicit declaration of function =
=E2=80=98get_online_cpus=E2=80=99; did you mean =E2=80=98get_online_mems=E2=
=80=99? [-Werror=3Dimplicit-function-declaration]
    kernel/cgroup/cgroup.c:2248:2: error: implicit declaration of function =
=E2=80=98put_online_cpus=E2=80=99; did you mean =E2=80=98num_online_cpus=E2=
=80=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
acs5k_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
acs5k_tiny_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (riscv, gcc-10) =E2=80=94 FAIL, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
allnoconfig (i386, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 section =
mismatches

Warnings:
    ld: arch/x86/boot/compressed/head_32.o: warning: relocation in read-onl=
y section `.head.text'
    ld: warning: creating DT_TEXTREL in a PIE

---------------------------------------------------------------------------=
-----
allnoconfig (x86_64, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sectio=
n mismatches

Warnings:
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
axm55xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/cgroup/cgroup.c:2237:2: error: implicit declaration of function =
=E2=80=98get_online_cpus=E2=80=99; did you mean =E2=80=98get_online_mems=E2=
=80=99? [-Werror=3Dimplicit-function-declaration]
    kernel/cgroup/cgroup.c:2248:2: error: implicit declaration of function =
=E2=80=98put_online_cpus=E2=80=99; did you mean =E2=80=98num_online_cpus=E2=
=80=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

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
cavium_octeon_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
ci20_defconfig (mips, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/cgroup/cgroup.c:2237:2: error: implicit declaration of function =
=E2=80=98get_online_cpus=E2=80=99; did you mean =E2=80=98get_online_mems=E2=
=80=99? [-Werror=3Dimplicit-function-declaration]
    kernel/cgroup/cgroup.c:2248:2: error: implicit declaration of function =
=E2=80=98put_online_cpus=E2=80=99; did you mean =E2=80=98num_online_cpus=E2=
=80=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cm_x2xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
cm_x300_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
cns3420vb_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 se=
ction mismatches

Errors:
    kernel/cgroup/cgroup.c:2237:2: error: implicit declaration of function =
=E2=80=98get_online_cpus=E2=80=99; did you mean =E2=80=98get_online_mems=E2=
=80=99? [-Werror=3Dimplicit-function-declaration]
    kernel/cgroup/cgroup.c:2248:2: error: implicit declaration of function =
=E2=80=98put_online_cpus=E2=80=99; did you mean =E2=80=98num_online_cpus=E2=
=80=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

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
davinci_all_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 =
section mismatches

Errors:
    kernel/cgroup/cgroup.c:2237:2: error: implicit declaration of function =
=E2=80=98get_online_cpus=E2=80=99; did you mean =E2=80=98get_online_mems=E2=
=80=99? [-Werror=3Dimplicit-function-declaration]
    kernel/cgroup/cgroup.c:2248:2: error: implicit declaration of function =
=E2=80=98put_online_cpus=E2=80=99; did you mean =E2=80=98num_online_cpus=E2=
=80=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/cgroup/cgroup.c:2237:2: error: implicit declaration of function =
=E2=80=98get_online_cpus=E2=80=99; did you mean =E2=80=98get_online_mems=E2=
=80=99? [-Werror=3Dimplicit-function-declaration]
    kernel/cgroup/cgroup.c:2248:2: error: implicit declaration of function =
=E2=80=98put_online_cpus=E2=80=99; did you mean =E2=80=98num_online_cpus=E2=
=80=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
defconfig (riscv, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section mi=
smatches

Errors:
    kernel/cgroup/cgroup.c:2237:2: error: implicit declaration of function =
=E2=80=98get_online_cpus=E2=80=99; did you mean =E2=80=98get_online_mems=E2=
=80=99? [-Werror=3Dimplicit-function-declaration]
    kernel/cgroup/cgroup.c:2248:2: error: implicit declaration of function =
=E2=80=98put_online_cpus=E2=80=99; did you mean =E2=80=98num_online_cpus=E2=
=80=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section mi=
smatches

Errors:
    kernel/cgroup/cgroup.c:2237:2: error: implicit declaration of function =
=E2=80=98get_online_cpus=E2=80=99; did you mean =E2=80=98get_online_mems=E2=
=80=99? [-Werror=3Dimplicit-function-declaration]
    kernel/cgroup/cgroup.c:2248:2: error: implicit declaration of function =
=E2=80=98put_online_cpus=E2=80=99; did you mean =E2=80=98num_online_cpus=E2=
=80=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
defconfig+arm64-chromebook (arm64, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warn=
ing, 0 section mismatches

Errors:
    kernel/cgroup/cgroup.c:2237:2: error: implicit declaration of function =
=E2=80=98get_online_cpus=E2=80=99; did you mean =E2=80=98get_online_mems=E2=
=80=99? [-Werror=3Dimplicit-function-declaration]
    kernel/cgroup/cgroup.c:2248:2: error: implicit declaration of function =
=E2=80=98put_online_cpus=E2=80=99; did you mean =E2=80=98num_online_cpus=E2=
=80=99? [-Werror=3Dimplicit-function-declaration]

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
ebsa110_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

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
ep93xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-10) =E2=80=94 FAIL, 0 errors, 0 warnings, 0 sect=
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
fuloong2e_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

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
i386_defconfig (i386, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 secti=
on mismatches

Warnings:
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
imx_v6_v7_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
integrator_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
iop13xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
iop32x_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
iop33x_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
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
ip32_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
ixp4xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

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
ks8695_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

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
lemote2f_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    net/core/rtnetlink.c:3199:1: warning: the frame size of 1328 bytes is l=
arger than 1024 bytes [-Wframe-larger-than=3D]

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
loongson3_defconfig (mips, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 s=
ection mismatches

Errors:
    kernel/cgroup/cgroup.c:2237:2: error: implicit declaration of function =
=E2=80=98get_online_cpus=E2=80=99; did you mean =E2=80=98get_online_mems=E2=
=80=99? [-Werror=3Dimplicit-function-declaration]
    kernel/cgroup/cgroup.c:2248:2: error: implicit declaration of function =
=E2=80=98put_online_cpus=E2=80=99; did you mean =E2=80=98num_online_cpus=E2=
=80=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

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
malta_kvm_guest_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnin=
gs, 0 section mismatches

---------------------------------------------------------------------------=
-----
malta_qemu_32r6_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warnin=
g, 0 section mismatches

Warnings:
    {standard input}:132: Warning: macro instruction expanded into multiple=
 instructions

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
mini2440_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
mips_paravirt_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

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
multi_v5_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    kernel/cgroup/cgroup.c:2237:2: error: implicit declaration of function =
=E2=80=98get_online_cpus=E2=80=99; did you mean =E2=80=98get_online_mems=E2=
=80=99? [-Werror=3Dimplicit-function-declaration]
    kernel/cgroup/cgroup.c:2248:2: error: implicit declaration of function =
=E2=80=98put_online_cpus=E2=80=99; did you mean =E2=80=98num_online_cpus=E2=
=80=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-10) =E2=80=94 FAIL, 0 errors, 0 warnings, 0 se=
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
netx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
nhk8815_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    net/core/rtnetlink.c:3199:1: warning: the frame size of 1344 bytes is l=
arger than 1024 bytes [-Wframe-larger-than=3D]

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
omap1_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    drivers/gpio/gpio-omap.c:1233:34: warning: array =E2=80=98omap_gpio_mat=
ch=E2=80=99 assumed to have one element

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
omega2p_defconfig (mips, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    kernel/cgroup/cgroup.c:2237:2: error: implicit declaration of function =
=E2=80=98get_online_cpus=E2=80=99; did you mean =E2=80=98get_online_mems=E2=
=80=99? [-Werror=3Dimplicit-function-declaration]
    kernel/cgroup/cgroup.c:2248:2: error: implicit declaration of function =
=E2=80=98put_online_cpus=E2=80=99; did you mean =E2=80=98num_online_cpus=E2=
=80=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

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
pistachio_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
pleb_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
pnx8335_stb225_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warning=
s, 0 section mismatches

---------------------------------------------------------------------------=
-----
prima2_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

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
raumfeld_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
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
rm200_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
s3c2410_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
s3c6400_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
s5pv210_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/cgroup/cgroup.c:2237:2: error: implicit declaration of function =
=E2=80=98get_online_cpus=E2=80=99; did you mean =E2=80=98get_online_mems=E2=
=80=99? [-Werror=3Dimplicit-function-declaration]
    kernel/cgroup/cgroup.c:2248:2: error: implicit declaration of function =
=E2=80=98put_online_cpus=E2=80=99; did you mean =E2=80=98num_online_cpus=E2=
=80=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
sama5_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/cgroup/cgroup.c:2237:2: error: implicit declaration of function =
=E2=80=98get_online_cpus=E2=80=99; did you mean =E2=80=98get_online_mems=E2=
=80=99? [-Werror=3Dimplicit-function-declaration]
    kernel/cgroup/cgroup.c:2248:2: error: implicit declaration of function =
=E2=80=98put_online_cpus=E2=80=99; did you mean =E2=80=98num_online_cpus=E2=
=80=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
sb1250_swarm_defconfig (mips, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, =
0 section mismatches

Errors:
    kernel/cgroup/cgroup.c:2237:2: error: implicit declaration of function =
=E2=80=98get_online_cpus=E2=80=99; did you mean =E2=80=98get_online_mems=E2=
=80=99? [-Werror=3Dimplicit-function-declaration]
    kernel/cgroup/cgroup.c:2248:2: error: implicit declaration of function =
=E2=80=98put_online_cpus=E2=80=99; did you mean =E2=80=98num_online_cpus=E2=
=80=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

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

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
spear6xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

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
sunxi_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/cgroup/cgroup.c:2237:2: error: implicit declaration of function =
=E2=80=98get_online_cpus=E2=80=99; did you mean =E2=80=98get_online_mems=E2=
=80=99? [-Werror=3Dimplicit-function-declaration]
    kernel/cgroup/cgroup.c:2248:2: error: implicit declaration of function =
=E2=80=98put_online_cpus=E2=80=99; did you mean =E2=80=98num_online_cpus=E2=
=80=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tango4_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

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
tinyconfig (x86_64, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 section=
 mismatches

Warnings:
    ld: arch/x86/boot/compressed/head_64.o: warning: relocation in read-onl=
y section `.head.text'
    ld: warning: creating DT_TEXTREL in a PIE

---------------------------------------------------------------------------=
-----
tinyconfig (riscv, gcc-10) =E2=80=94 FAIL, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
tinyconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
tinyconfig (i386, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 section m=
ismatches

Warnings:
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

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

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
vocore2_defconfig (mips, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    kernel/cgroup/cgroup.c:2237:2: error: implicit declaration of function =
=E2=80=98get_online_cpus=E2=80=99; did you mean =E2=80=98get_online_mems=E2=
=80=99? [-Werror=3Dimplicit-function-declaration]
    kernel/cgroup/cgroup.c:2248:2: error: implicit declaration of function =
=E2=80=98put_online_cpus=E2=80=99; did you mean =E2=80=98num_online_cpus=E2=
=80=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

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
x86_64_defconfig (x86_64, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 s=
ection mismatches

Warnings:
    ld: arch/x86/boot/compressed/head_64.o: warning: relocation in read-onl=
y section `.head.text'
    ld: warning: creating DT_TEXTREL in a PIE

---------------------------------------------------------------------------=
-----
x86_64_defconfig+x86-chromebook (x86_64, gcc-10) =E2=80=94 PASS, 0 errors, =
2 warnings, 0 section mismatches

Warnings:
    ld: arch/x86/boot/compressed/head_64.o: warning: relocation in read-onl=
y section `.head.text'
    ld: warning: creating DT_TEXTREL in a PIE

---------------------------------------------------------------------------=
-----
xcep_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
zeus_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
zx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section m=
ismatches

Errors:
    kernel/cgroup/cgroup.c:2237:2: error: implicit declaration of function =
=E2=80=98get_online_cpus=E2=80=99; did you mean =E2=80=98get_online_mems=E2=
=80=99? [-Werror=3Dimplicit-function-declaration]
    kernel/cgroup/cgroup.c:2248:2: error: implicit declaration of function =
=E2=80=98put_online_cpus=E2=80=99; did you mean =E2=80=98num_online_cpus=E2=
=80=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---
For more info write to <info@kernelci.org>
