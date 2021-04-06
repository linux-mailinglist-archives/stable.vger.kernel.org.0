Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEF8354D2A
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 08:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244101AbhDFG6O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 02:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244099AbhDFG6N (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 02:58:13 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0265C06174A
        for <stable@vger.kernel.org>; Mon,  5 Apr 2021 23:58:06 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id v10so9737419pfn.5
        for <stable@vger.kernel.org>; Mon, 05 Apr 2021 23:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rcJ9RYA7iRQwFVXvG7HVSm7JlemIV/oB8dKnj6rRecU=;
        b=eIs8aQQztuEX/MRQVbfjCIJezTd1z7BbDw6P2vA1kYs5lVn8h9f77GP92IPHW95kdv
         g/PzBNvV6ECHFC1mOqxaXYjPJ44Mojjw1m8gEczotvvUUz3/G2bTq/23h5/9ENNTCPfQ
         YUt0IP72zRSCMreojAQaSTsMPVS3quB3TAn1mxgz7nXfE/ks3lxvPWrSc+iPQ12WPz0F
         SBAPpyVjBkKjTJem6Wxu9ImWlJHTaaRrPzR9P68dWVEzz4AQ5J+f0aloGW1ITrb4YeA8
         AeNzkqT0UBb6b/I9kD9slsiRutIgA/S46FsaC3rS0JrQK8l4lKFaW5Pcdhf5AAaqlpYq
         Bdnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rcJ9RYA7iRQwFVXvG7HVSm7JlemIV/oB8dKnj6rRecU=;
        b=P4XXVarFPo/P99aGL88DwJs3uIUwNIF/1vn2p7lpWrQ9mVqoBB3/7d6HGT3nTz4H+L
         95DoNkJGNx+Kh/K3t1W0rZjNo/vqYgl89ylIvM95ysXRxC1i6OwL/kk91tohXrmkPzsD
         rZfADEAaNW3xN8zYAGyqwnKneG8LFUQQYlXKAMwXtTgJ0gXubBrhRocuT7eBHGdPIJa5
         GF0qwyrxUDx4xsXyIJi6foiLbu01qCmUbq1b8+AmUq6XstN02use8FgiR025CSCUNarE
         JCud7m23cisF9g/OaEqWjMrya818i+gumQ7/6Xhr/NJpYlU4f8zJzD3AI66YcNQw5Jep
         v8+Q==
X-Gm-Message-State: AOAM530CMEJ04m2febU9m1h3GwV56ywpxeGBlCSMQ0H3jX/E1bZMY82v
        NjsT8YGd6EqZzpFjq4LEddIaRC7ABLGRpg==
X-Google-Smtp-Source: ABdhPJwEEmFcadpl7a7/TMQHUo2UK0qjolVefs1mRvzYV3oQ5p4j5NzckdLQsRLa6wle6kk3cdjwDA==
X-Received: by 2002:a62:e70f:0:b029:1fd:6bae:235d with SMTP id s15-20020a62e70f0000b02901fd6bae235dmr27150336pfh.43.1617692286144;
        Mon, 05 Apr 2021 23:58:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w23sm17464744pgi.63.2021.04.05.23.58.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 23:58:05 -0700 (PDT)
Message-ID: <606c067d.1c69fb81.c9d52.dca2@mx.google.com>
Date:   Mon, 05 Apr 2021 23:58:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.184-56-g73d616e2eed85
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 122 runs,
 5 regressions (v4.19.184-56-g73d616e2eed85)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 122 runs, 5 regressions (v4.19.184-56-g73d61=
6e2eed85)

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

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.184-56-g73d616e2eed85/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.184-56-g73d616e2eed85
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      73d616e2eed85cc896f9bf9e957d64cdaf19e0b1 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/606bd084a0c238c46edac6e0

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.184=
-56-g73d616e2eed85/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.184=
-56-g73d616e2eed85/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/606bd084a0c238c=
46edac6e7
        new failure (last pass: v4.19.184-39-ga54c31013b292)
        2 lines

    2021-04-06 03:07:43.803000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/103
    2021-04-06 03:07:43.812000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/606bce9d4146b6f8bedac6ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.184=
-56-g73d616e2eed85/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.184=
-56-g73d616e2eed85/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606bce9d4146b6f8bedac=
6ef
        failing since 143 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/606bce894146b6f8bedac6d4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.184=
-56-g73d616e2eed85/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.184=
-56-g73d616e2eed85/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606bce894146b6f8bedac=
6d5
        failing since 143 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/606bce6200b4ded5c5dac6cc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.184=
-56-g73d616e2eed85/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.184=
-56-g73d616e2eed85/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606bce6200b4ded5c5dac=
6cd
        failing since 143 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/606bce3a00b4ded5c5dac6bb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.184=
-56-g73d616e2eed85/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.184=
-56-g73d616e2eed85/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606bce3a00b4ded5c5dac=
6bc
        failing since 143 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
