Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06C3D34BC10
	for <lists+stable@lfdr.de>; Sun, 28 Mar 2021 12:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbhC1Kic (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Mar 2021 06:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbhC1Ki2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Mar 2021 06:38:28 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5AD0C061762
        for <stable@vger.kernel.org>; Sun, 28 Mar 2021 03:38:27 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id y2so3022388plg.5
        for <stable@vger.kernel.org>; Sun, 28 Mar 2021 03:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EmrcU3fdYuEkNCB4RHi5LTIB8XaEMy5nSRVfDVJ06Z0=;
        b=uiSbVvxMyG0Dl3gB9QPT5DDadTCx1QTQiYRIhmZ9G0UuTlxkLBTBxTpGpnhyVzzZn/
         BNBUBfN1YoJ2plhCqzd5s84Z8orrjBdDSpPAxNq077Fa1VAhS7FKefd7i4RO+jjGNCdp
         xgy8bGFhxPqHcp9hENEqQRBjDe5Tiz+rRuvb3Ww4ecRytZfneQPconhaJqA50WK9Yo8J
         XOv6M0qE1HPQnHOlwO1GISlk3aZiHiCf7Q6DUUW5vUbB7t8jk+1SIREfQ+rT7J2EJbvp
         vV81i+OzYM3KBzY7DfxpDfyvms8LhOcOoZySR9l2YWnqpJEmwpWvB8VmDNrIhIh5s0rr
         hg6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EmrcU3fdYuEkNCB4RHi5LTIB8XaEMy5nSRVfDVJ06Z0=;
        b=V9mcsQtlPcjQ2z2PuWyRw37D2GUWvSYvY7BpVCgogmWOwUzpTtPpuZ0IpMpMNPTbow
         RpiBkz2CGvmhw/oMzfFZVm/tRab/Ab7l87DYjz5umhCJWC8aFprluJNq1wiMUDMNo1pT
         gnnDgOilyhaijsHgDZcJS9RUd/CmP6RVddDmHUqTepMVN7QPi5q4dcSZQVbM23bHupo1
         kczIDZh4iaK/av4hBNqwdjX8muWchnMuplrYJYJMrfyDyWIjHVewRtOB8mwxleKHR5mU
         iI16rxMAsjraJVjhp9hViVyKN4++hDzHCM9x/C6iTOH3BGBfktA4C1tW1itWYcPxS30o
         p+1g==
X-Gm-Message-State: AOAM530zh5PcNrKeS5IOgyCWQrQcEcYOgl3d1vyhnSyOMdGurKD/49e5
        AjO4/cY3qkgjyd0G1qjecfPAmHHiYuXdeA==
X-Google-Smtp-Source: ABdhPJzH4NAuN9az6CtsXzC8n+xWjwWk/e7Ttk3Q7jKEbL9qituL2OvPN4vwa2zXOqpO8i+Enkx6yg==
X-Received: by 2002:a17:902:e549:b029:e6:6b3a:49f7 with SMTP id n9-20020a170902e549b02900e66b3a49f7mr24728948plf.52.1616927906791;
        Sun, 28 Mar 2021 03:38:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w5sm14422158pge.55.2021.03.28.03.38.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Mar 2021 03:38:26 -0700 (PDT)
Message-ID: <60605ca2.1c69fb81.82536.343b@mx.google.com>
Date:   Sun, 28 Mar 2021 03:38:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.183-58-ga572ed1c941f7
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 89 runs,
 4 regressions (v4.19.183-58-ga572ed1c941f7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 89 runs, 4 regressions (v4.19.183-58-ga572ed=
1c941f7)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.183-58-ga572ed1c941f7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.183-58-ga572ed1c941f7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a572ed1c941f763da8b95da2ede3415b26e7ea7c =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60601f01afb7f25a1faf02c6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.183=
-58-ga572ed1c941f7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.183=
-58-ga572ed1c941f7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60601f01afb7f25a1faf0=
2c7
        failing since 134 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60601f024ed44d1928af02db

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.183=
-58-ga572ed1c941f7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.183=
-58-ga572ed1c941f7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60601f024ed44d1928af0=
2dc
        failing since 134 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/606036d8f3ad045b38af02ae

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.183=
-58-ga572ed1c941f7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.183=
-58-ga572ed1c941f7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606036d8f3ad045b38af0=
2af
        failing since 134 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60601ebc2f2c446357af02be

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.183=
-58-ga572ed1c941f7/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.183=
-58-ga572ed1c941f7/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60601ebc2f2c446357af0=
2bf
        failing since 134 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
