Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3813348E044
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 23:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237543AbiAMWbb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 17:31:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237533AbiAMWba (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jan 2022 17:31:30 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50FBAC061574
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 14:31:30 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id j27so1141096pgj.3
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 14:31:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=V38wzQY48UAWmpboVRhZDzaw8I8qNc0e16QyrRbOlcM=;
        b=ejX1oe9C/g+MIKCVarZpTI+dc3hQNyWdORth7sjhQDlXpR55jhtK/vC0TjtS0OanJv
         5ILS34Vqy6trIRiI16vDoH8U8LiAEGcEny61TyRpUNTfEXnVK5BfAb1w9Ps4vmFhMkk2
         OT0Kth1+sQD4y5vZIe938I7keyMsKWsAD6m54VEI800UMfIvOYpuHJu7modoJWrPWCeu
         TS5hhwLtRwY5swvWe9iiG4fDeUE7cF2zmMvBlorDnRyc1Zx6GuHQfH9UmIqdkYh4RhVz
         xWw9QZknshq+599XDrnLpeBvdaO+iYv8cZ+RjdyOgv5538qFm1sbXhUucR/5Y9Pqq78K
         ejZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=V38wzQY48UAWmpboVRhZDzaw8I8qNc0e16QyrRbOlcM=;
        b=Hm1yM2CXnntiyDzz2x22tGrnEeM6BbNB3fiFk6JqsnkrZK7U0FoueTJJyPIl5GzFiZ
         wEBPwGvWydFCxRx56eUxCpVZ7tu/QTDyUT/I0n4hHSDbG0K0xs5yec2zo+ID995JeO9s
         tybdGhnm5VO7aot2n8ukcIXFiTUo803LiEPxSfS9JIM9ESgrFDAfjNyBW0SE1a7SZms4
         CFznBqIOi1l3HKq282r7nMnPTN3YxsCqV+6vZORBS3STbRpzY62LlIXbaYakBL2+0W5J
         a9ZyKiNmotZS2PNqfYTrIHp9nmPUFAdqGgnx4UsERpcQI5HsV9T6Hy+G5EWwmqJoR/To
         p1FQ==
X-Gm-Message-State: AOAM530d0ecFf4CLYe9ef0T5DVERbxqBeXyX4GroNWujsCg/LsN9ycgm
        4MG7TyNeEpHgLjZpHts79vJGswXAl28tihVIGe4=
X-Google-Smtp-Source: ABdhPJyws6H3k3ri39NcQ48yPBxLJ4AZiWH02YVbEYF/3RW3ERL41OHaBExBLu6WrHeUAf4oYNuHUQ==
X-Received: by 2002:a62:cd41:0:b0:4bf:3fb3:82a8 with SMTP id o62-20020a62cd41000000b004bf3fb382a8mr6099841pfg.66.1642113089691;
        Thu, 13 Jan 2022 14:31:29 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x1sm3037760pgh.44.2022.01.13.14.31.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 14:31:29 -0800 (PST)
Message-ID: <61e0a841.1c69fb81.34246.8a06@mx.google.com>
Date:   Thu, 13 Jan 2022 14:31:29 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.225-6-gfcab44e17f2f
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 144 runs,
 1 regressions (v4.19.225-6-gfcab44e17f2f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 144 runs, 1 regressions (v4.19.225-6-gfcab44=
e17f2f)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.225-6-gfcab44e17f2f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.225-6-gfcab44e17f2f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fcab44e17f2f94c4c9b471a9fadce26ed5875c22 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61e072c24a4bb1deecef6744

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.225=
-6-gfcab44e17f2f/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.225=
-6-gfcab44e17f2f/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e072c24a4bb1d=
eecef6747
        failing since 1 day (last pass: v4.19.224-21-gaa8492ba4fad, first f=
ail: v4.19.225)
        2 lines

    2022-01-13T18:42:59.110957  <8>[   21.232269] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-13T18:42:59.158050  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/102
    2022-01-13T18:42:59.167698  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
