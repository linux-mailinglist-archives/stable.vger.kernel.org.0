Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 515B32B7D1D
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 12:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbgKRL4M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 06:56:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727237AbgKRL4M (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Nov 2020 06:56:12 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99441C0613D4
        for <stable@vger.kernel.org>; Wed, 18 Nov 2020 03:56:12 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id d17so860107plr.5
        for <stable@vger.kernel.org>; Wed, 18 Nov 2020 03:56:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LSVocFhjbfQ0itLs2bv0hL/DPK8i4jqXjDYw3NZ4BrQ=;
        b=s0MrmC4dizqXDSCGa2ZcRfLxJqWOCFOadh3Y8CU5SI6SE0HYJ1SQWzQ7EWblNQhyfN
         hFJAMopIEF/eyOX6WOylwe78bmamGGM9B2JEllLrGqitQviFhpJAeRIa7CItd2OkGwJX
         LB3RSot+Ue7HAi1fBOV/sqhjeJYJWBUk+qzCdyyhsacES6WEDzxYIV2EYRi6klrIto7v
         NVoZiCgqzQhrlfmeN802CEuNVOH1hUUjDfn2C6Cmx7xn9tN20O0ieTgxtFUkDMB1UWnY
         H2LVP6J652xkUyX4DIBf0EWS3dA/WXoDpP3LFzraVKr6ryKqPOFhLlviBX2bvKuHBvHA
         1DEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LSVocFhjbfQ0itLs2bv0hL/DPK8i4jqXjDYw3NZ4BrQ=;
        b=jDkHeQ0QXuAWaeGHgPBoMfDU4WGYN6L1NCqFsyzvgKkauyLU5oZIvSDosfd6n8RMGz
         JByYfajy/X+Cps102fNEsyY9PgQbkOQroJFzoN5ZzBFgmm8RkKD/kJsopQd/dKbAJ7HO
         OdunR0XOXDopkal9QfcCGAE/iAu6ojqCTSm+bIEEifaLbsJVN0rAiZor/6emgt8QPBAp
         etARxXsVNYYZQmLhZFxROpYefYuiCDkdNk1ku7c4mlaYLNbP5y84JKCzdIT58jXAPnAp
         jPMFjOm6hkvgKYDqPFawD456QZbXp9a9O4BigLQenmR+MRmehzAqQMJOyzYDKPUaCxbe
         9S1Q==
X-Gm-Message-State: AOAM533xWL5s/VFOpOeKhbzMnoFgVKOpYtdjE5BQ0/EIKXAYhcPfgDDP
        VMegMXAqLtwYvP5jg4vjhdeQd6JVkG0/tQ==
X-Google-Smtp-Source: ABdhPJzDFjQRnrfF/EcuheyC3QGgD1PRSmPa4eFN1QWz9CEqH1ajB8bgsmLn4LP3R4F/uDfrEw5Yag==
X-Received: by 2002:a17:902:26a:b029:d6:caca:620a with SMTP id 97-20020a170902026ab02900d6caca620amr4420400plc.46.1605700570940;
        Wed, 18 Nov 2020 03:56:10 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m8sm22419243pgg.1.2020.11.18.03.56.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 03:56:10 -0800 (PST)
Message-ID: <5fb50bda.1c69fb81.9a091.f70a@mx.google.com>
Date:   Wed, 18 Nov 2020 03:56:10 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.206-85-gb637c1cf2e77
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 164 runs,
 7 regressions (v4.14.206-85-gb637c1cf2e77)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 164 runs, 7 regressions (v4.14.206-85-gb637c=
1cf2e77)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
fsl-ls2088a-rdb      | arm64 | lab-nxp         | gcc-8    | defconfig      =
     | 1          =

panda                | arm   | lab-collabora   | gcc-8    | omap2plus_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.206-85-gb637c1cf2e77/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.206-85-gb637c1cf2e77
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b637c1cf2e77c0a954ac3b5ab7eebb442ebd62a4 =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
fsl-ls2088a-rdb      | arm64 | lab-nxp         | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb4d955f3606b9aced8d90c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.206=
-85-gb637c1cf2e77/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.206=
-85-gb637c1cf2e77/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb4d955f3606b9aced8d=
90d
        new failure (last pass: v4.14.206-21-g787a7a3ca16c) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
panda                | arm   | lab-collabora   | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb4da20a43811daa8d8d971

  Results:     2 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.206=
-85-gb637c1cf2e77/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.206=
-85-gb637c1cf2e77/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fb4da20a43811d=
aa8d8d975
        failing since 4 days (last pass: v4.14.206-21-g787a7a3ca16c, first =
fail: v4.14.206-22-ga949bf40fb01)
        2 lines

    2020-11-18 08:23:56.827000+00:00  <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3D=
alert RESULT=3D[   20.409698] usbcore: registered new interface driver smsc=
95xx
    2020-11-18 08:23:56.830000+00:00  pass UNITS=3Dlines MEASUREMENT=3D0>
    2020-11-18 08:23:56.877000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/104
    2020-11-18 08:23:56.887000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb4d75ab662f96d5ad8d976

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.206=
-85-gb637c1cf2e77/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.206=
-85-gb637c1cf2e77/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb4d75ab662f96d5ad8d=
977
        failing since 4 days (last pass: v4.14.206-21-g787a7a3ca16c, first =
fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb4d75e3e6d47f9c7d8d901

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.206=
-85-gb637c1cf2e77/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.206=
-85-gb637c1cf2e77/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb4d75e3e6d47f9c7d8d=
902
        failing since 4 days (last pass: v4.14.206-21-g787a7a3ca16c, first =
fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb4d755b662f96d5ad8d963

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.206=
-85-gb637c1cf2e77/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.206=
-85-gb637c1cf2e77/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb4d755b662f96d5ad8d=
964
        failing since 4 days (last pass: v4.14.206-21-g787a7a3ca16c, first =
fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb4e71ad6a626e99bd8d911

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.206=
-85-gb637c1cf2e77/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.206=
-85-gb637c1cf2e77/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb4e71ad6a626e99bd8d=
912
        failing since 4 days (last pass: v4.14.206-21-g787a7a3ca16c, first =
fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb4e18dc1d9704c8dd8d93d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.206=
-85-gb637c1cf2e77/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.206=
-85-gb637c1cf2e77/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb4e18dc1d9704c8dd8d=
93e
        failing since 4 days (last pass: v4.14.206-21-g787a7a3ca16c, first =
fail: v4.14.206-22-ga949bf40fb01) =

 =20
