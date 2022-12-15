Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF85A64E29B
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 21:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbiLOU4r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 15:56:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiLOU4q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 15:56:46 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF3A7528AF
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 12:56:45 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso4030020pjt.0
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 12:56:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=YmHVPKOJegl7FWE3B5P7uLbPqCaWK0Elh5vrDHfv5bI=;
        b=NH7DvfKDKA+NwxG3CUk1tufio6ktl6mh0Y4gI2gl9CMghgrz2F62AsbsUmkVJqwlGi
         yOiV5LrEWDUVrbrbCb2K3zrBwaTHIkRbGEpriOgZpKGYnMggYowZlrmPlWldNJhs5L9Y
         RunqOK4+WZhp0kkxaKRyA8Lw25zSlTs0+Y7CnajIIG8Mts6xXyJaE5quBCshHf9SqrJ7
         T1uOY6njeeYM3vwmt0ZcQ1oUkVjGqz0s10XAaNepXplCaI2zLCO/BdSN2GztaDrePm3P
         +B339iodDT9XstpkNBWOutesZaTGv2F+fiPMZ+Hu6LbQTPCy0K2yYeXU5IKV+L11dJD7
         KGXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YmHVPKOJegl7FWE3B5P7uLbPqCaWK0Elh5vrDHfv5bI=;
        b=s8LmsD0/g5M88BlATBDUgQhsyls+d1gAw5ogWiuZ+tCxYQ63ed9kv9QYr3IFA+rJl0
         9gH07TAoUKLwKjao6ioj5e6JLRMudS9wGpOb9JuhlKWUfpWOs6nTfAUo7RHcMzpVglRs
         coxaDBjMdJsoe2ja5pQfGoPuxpsMCZnp9csEKkJibns1sLlGhooKr1FWeXNvkVfqy19k
         tCJqtcMu1IhNxqfKJhvgxC6Q/oROQkN7vtRSTztPNoV6LdFksOQnozpDuB6FnOQEPfs6
         3B1pfQghwLTtFpA0gI+9ARxGHmRQgcW0W4fbgjR6+jQAOf5WDG/xP6/CIq+irLA0n1B7
         8tUw==
X-Gm-Message-State: ANoB5pmMWYz44GV9eO7j/WUDQ2R0jVHBD/g4rv0uXJh3SHYfIEvwpNyo
        lq/Evttz5+KaNqbYKcv6vlvTCJPtb//vngtNR1grag==
X-Google-Smtp-Source: AA0mqf7+u7hTWY4v+GpCUPuiZ3XEwdg+atloLUjFn8WBITaf66HURVDUo3d8RnQhLTt1bt3nro8QAA==
X-Received: by 2002:a17:902:a416:b0:188:f5de:8908 with SMTP id p22-20020a170902a41600b00188f5de8908mr26578672plq.65.1671137805028;
        Thu, 15 Dec 2022 12:56:45 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v10-20020a170902b7ca00b0018962933a3esm64442plz.181.2022.12.15.12.56.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 12:56:44 -0800 (PST)
Message-ID: <639b8a0c.170a0220.c1ca5.0282@mx.google.com>
Date:   Thu, 15 Dec 2022 12:56:44 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.83-14-g3d9b12df4028
X-Kernelci-Report-Type: build
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 build: 35 builds: 1 failed, 34 passed,
 1 error (v5.15.83-14-g3d9b12df4028)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 build: 35 builds: 1 failed, 34 passed, 1 error (v5.15.=
83-14-g3d9b12df4028)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F5.1=
5/kernel/v5.15.83-14-g3d9b12df4028/

Tree: stable-rc
Branch: queue/5.15
Git Describe: v5.15.83-14-g3d9b12df4028
Git Commit: 3d9b12df4028fc77bceed2eac6b78f607975c819
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 5 unique architectures

Build Failure Detected:

mips:
    ip28_defconfig: (gcc-10) FAIL

Errors Detected:

arc:

arm:

i386:

mips:
    ip32_defconfig (gcc-10): 1 error

riscv:

Errors summary:

    1    expr: syntax error: unexpected argument =E2=80=980xffffffff8000000=
0=E2=80=99


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
at91_dt_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
ath79_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
ci20_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
collie_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
davinci_all_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
defconfig (riscv, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

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
h5000_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
haps_hs_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
i386_defconfig (i386, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
imx_v4_v5_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
ip22_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
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
jmr3927_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
maltaup_xpa_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, =
0 section mismatches

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
mtx1_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
mvebu_v7_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
nhk8815_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
nommu_k210_defconfig (riscv, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, =
0 section mismatches

---------------------------------------------------------------------------=
-----
omap1_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
pxa168_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
pxa3xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

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
rs90_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
sama5_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
shannon_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
spear13xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
spear6xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
tegra_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---
For more info write to <info@kernelci.org>
