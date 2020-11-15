Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5342B38FB
	for <lists+stable@lfdr.de>; Sun, 15 Nov 2020 21:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727496AbgKOUPM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Nov 2020 15:15:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727317AbgKOUPM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Nov 2020 15:15:12 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23079C0613CF
        for <stable@vger.kernel.org>; Sun, 15 Nov 2020 12:15:12 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id w6so11428675pfu.1
        for <stable@vger.kernel.org>; Sun, 15 Nov 2020 12:15:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=a6YuGarYogV6KKuSQS/VrGTibS4FBz2EQsUKs28QjIo=;
        b=FtKHWyvSsYjymqF0mDvwOelyDuhQpKqEfe6Qav6bZTUhGyApa96/DyUyRRmFcImS2j
         3UkXcoEdeka1RfMBDADBKpLdydJTidd6Af4VNivxesZFokV1cI+fbgWwBEUa5ZU2C2Fn
         r5/O4JvsDOC27ZOdD4SRnO9en4EE1OEDey3Up4Bp1XPi8IIQhcWpIn/0VlYp5+SuMfar
         8EVW1gvFLrlXlvMf8uefMqEkNMQiNnV6zACarxyWXSDBozML+x23X+a/7oHsKJSyXYrf
         xEC5pKRJR5cuEpmi2oiZPC4G4bId+uuxT12PdbmBPxGqnE2UdlguJlOfrjhq1iN1KKZF
         5GaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=a6YuGarYogV6KKuSQS/VrGTibS4FBz2EQsUKs28QjIo=;
        b=S9+q8hccGr46msvkLAh29murtOGJ/ndB+f9w8lyhy0DLunFY8DNYgDzfO/lCLA+sJh
         BeduF6M3Ce7jJoO4CWwfOLlici8pl/JAfuSKYxjkMGzskM2n3dFOsgEZ3qXmoXrpgUnk
         DbHgMGbZYeLU6ikITk8DZR3yR0f5+0fNmqZjTEblXm9hqBK3hi4p5W7gFxJ4nIAJ3UEj
         3kFOi0CHndpoSs6xGcocZme51m3F1BWtaRmtXbw7ePB30439C80H62heYfs5e46K8ysr
         2F2ltUtLN37p7lYpS03kp0ALJka0tSw9Zu+I4FMYKWeWzE3CdUKmJy7/f2t9f6WVv744
         E19A==
X-Gm-Message-State: AOAM5323Y8lL4SX9wq3ujGdKII1NJJ0TTr5wNDrs3+hmBT5/c00Tk9EX
        rr3jgXLI/qpkK2B/sWXEp6OZ0xykNj8KQA==
X-Google-Smtp-Source: ABdhPJxT71nZUCJpMAxF7miHHYObA6MsBYv+TzZZguKmCU3M8c/q89QLcezrX+/aLEQBLETJy81dng==
X-Received: by 2002:aa7:9595:0:b029:18e:ecd5:bcdc with SMTP id z21-20020aa795950000b029018eecd5bcdcmr11091864pfj.47.1605471310986;
        Sun, 15 Nov 2020 12:15:10 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l14sm16483359pfd.113.2020.11.15.12.15.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 12:15:10 -0800 (PST)
Message-ID: <5fb18c4e.1c69fb81.6e113.3c11@mx.google.com>
Date:   Sun, 15 Nov 2020 12:15:10 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.157-47-g478dfec05dc4
X-Kernelci-Report-Type: build
Subject: stable-rc/queue/4.19 build: 20 builds: 0 failed, 20 passed,
 6 warnings (v4.19.157-47-g478dfec05dc4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 build: 20 builds: 0 failed, 20 passed, 6 warnings (v4.=
19.157-47-g478dfec05dc4)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F4.1=
9/kernel/v4.19.157-47-g478dfec05dc4/

Tree: stable-rc
Branch: queue/4.19
Git Describe: v4.19.157-47-g478dfec05dc4
Git Commit: 478dfec05dc404b4f804aeff40166af01b660b5d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 4 unique architectures

Warnings Detected:

arc:
    haps_hs_defconfig (gcc-8): 1 warning
    haps_hs_smp_defconfig (gcc-8): 1 warning

arm:
    eseries_pxa_defconfig (gcc-8): 1 warning

mips:
    allnoconfig (gcc-8): 1 warning
    maltasmvp_eva_defconfig (gcc-8): 1 warning

riscv:
    tinyconfig (gcc-8): 1 warning


Warnings summary:

    6    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_l=
ist=E2=80=99 defined but not used [-Wunused-variable]

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
allnoconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mi=
smatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
ath79_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
badge4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
haps_hs_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
haps_hs_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
keystone_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, =
0 section mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
multi_v5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
nuc950_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
pxa_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
rb532_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
sb1250_swarm_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, =
0 section mismatches

---------------------------------------------------------------------------=
-----
socfpga_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
tinyconfig (riscv, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mi=
smatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
vocore2_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---
For more info write to <info@kernelci.org>
