Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2953731B2
	for <lists+stable@lfdr.de>; Tue,  4 May 2021 22:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232455AbhEDVAe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 May 2021 17:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbhEDVAe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 May 2021 17:00:34 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB7EC061574
        for <stable@vger.kernel.org>; Tue,  4 May 2021 13:59:39 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id x188so261594pfd.7
        for <stable@vger.kernel.org>; Tue, 04 May 2021 13:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=F11/8HM9kbMRvUjPmKY0eaHVlXt42PkWzpTvMxn7rns=;
        b=S5agKZEYlERY8a6/0bWzYzGbFlEWU3rJ7W6Gq5YlHzGEpBiV/06srOkjgs0qnVvU4/
         +bHymD75AAyzlucT0cmnQHG9aVj+9Mq5qUwi0cEO61gEuqgpOqE3dNXz2iPKS7kY3Vtq
         afspV+TioMKFHWdV7Eo8tin2zqrbu6glCOUxrJZ5VdL8Sfvu/gndJ0Ai/KNlv/pKvPfa
         +LMcucaOK2lLiPiUFWDQ9hwSJ/QsidG6805hkVIRcQFjk/kV3gP5LCVfcJ8ZWQdPWu3P
         lKerxopb80PJYG5vNOZldjKrzNk28hn7UPtlNYrJ0E+SCPZ5B0bQB7+oUjr1twWaGatn
         pIuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=F11/8HM9kbMRvUjPmKY0eaHVlXt42PkWzpTvMxn7rns=;
        b=QaJbcFxQsgrCHAOvObKTGwg8b6dZsALK7zizEf/UBYmzEs3FyS+/W2NDkfEqPwImNF
         d8trQDjNlDWpTeRNwbPk2UIMy4kw6ce/6WmScFua7Og2qDgRVYUy/BwibsaLye/t6U/d
         5pitEhVCWcv2bfeADHUO7fnB2PepAN9sxLv3lqPn2MSvk5pjN66CQwTWx8BBHqylQywr
         9tVArkV9B2SeBPVioypHqJkQe7EFURkwkTYRaIcaiLUFgB291tA+z+iMW8J65PEceJd1
         m5mkxX/gL55R9eGSpWKKNBGTKnRDEHpQJn57GPFVpHle5QLzwqauSKYLNMOoSm8TBD1q
         RSaQ==
X-Gm-Message-State: AOAM532M26+ltdfy+IkLeqqL1LbzkKgWxQiGM6YC0oA0HuqFvEvWaaN7
        fZsBAN+E/kjMY5G6tpTXp95mX7cszLMorR7X
X-Google-Smtp-Source: ABdhPJxzjOQReRXhqcdUcL2XDLX8wx29LFpLZ0sTAFidP5V35h/rKDOeMSZ5dcAQ9ohWNSm3CdpDQQ==
X-Received: by 2002:a17:90a:e298:: with SMTP id d24mr30610117pjz.144.1620161978374;
        Tue, 04 May 2021 13:59:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g6sm7868157pfr.213.2021.05.04.13.59.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 13:59:38 -0700 (PDT)
Message-ID: <6091b5ba.1c69fb81.0649.42ee@mx.google.com>
Date:   Tue, 04 May 2021 13:59:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.268-2-g07b9bde6ef981
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 75 runs,
 5 regressions (v4.9.268-2-g07b9bde6ef981)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 75 runs, 5 regressions (v4.9.268-2-g07b9bde6e=
f981)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.268-2-g07b9bde6ef981/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.268-2-g07b9bde6ef981
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      07b9bde6ef9818e5660744924c5ea426db8613d1 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60919fb977aeaf77ff843f17

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
-g07b9bde6ef981/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
-g07b9bde6ef981/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60919fba77aeaf7=
7ff843f1c
        failing since 0 day (last pass: v4.9.268-1-gf945683b79529, first fa=
il: v4.9.268-1-gf967fc4704b0c)
        2 lines

    2021-05-04 19:25:42.061000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/119
    2021-05-04 19:25:42.070000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/609179ac45ebf34a45843f1e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
-g07b9bde6ef981/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
-g07b9bde6ef981/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609179ac45ebf34a45843=
f1f
        failing since 171 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/609179b5c9e3c70bff843f17

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
-g07b9bde6ef981/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
-g07b9bde6ef981/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609179b5c9e3c70bff843=
f18
        failing since 171 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60917a1b12d0d952e5843f2f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
-g07b9bde6ef981/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
-g07b9bde6ef981/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60917a1b12d0d952e5843=
f30
        failing since 171 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6091795a0516dff5bd843f1a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
-g07b9bde6ef981/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
-g07b9bde6ef981/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6091795a0516dff5bd843=
f1b
        failing since 171 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
