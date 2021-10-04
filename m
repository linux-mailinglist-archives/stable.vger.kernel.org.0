Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 443D4420594
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 07:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232453AbhJDFa4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 01:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232358AbhJDFaz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 01:30:55 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95DD2C0613EC
        for <stable@vger.kernel.org>; Sun,  3 Oct 2021 22:29:07 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id s75so4589923pgs.5
        for <stable@vger.kernel.org>; Sun, 03 Oct 2021 22:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3eItIoPBgBkHwd1NXDg6t4UWXzHGIMyGQ8fK22r2Ixk=;
        b=Z7d3U+K3I+9iNeQtUNaYjIvVyOuD/wnZfH8B1KDv8jwrQs4ooaxOQTh1kdiFhVZB25
         b/43oDBfJyg35E0VagYqpXKnhNOpf6VIM+J5Hw5WERbSERbw8r4mZyCSJLGDQbgUlZ8X
         FWvttJKavkdFNrqdIUmWVq4nG8ZANVOODg22DL46AKx5+YgWIjLGLtSKztlJb4CR1Hgv
         Oub3zPCYqUGYtfXQcjUwpiVrC3q8U21iaiNducBiYsRr4QEay1OtPcIqFzcJTcpT025C
         WMPZM6Cf6EzndGeswYurm8LMmCTpomH17PAYSWd6ZjXBY7Gc6fwpgLEuik26uv/BdWbS
         goHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3eItIoPBgBkHwd1NXDg6t4UWXzHGIMyGQ8fK22r2Ixk=;
        b=0igHypAzdVnYId43fe5ZyI+B3rVqoDXvtFkbNPc753dAQFVdoK0Kd9JcbFqGmghSlu
         q6KBm+e/TOel3PDevKqEDQnE+9X62DB9nKeYQLu4spiOih8xTMZMN5gUNyuJuIhohhyG
         SKg04slDHpSJGqk3weo8RkMQ6zi1dn4P7dTJHacWRlNQ7xb7UI+CfqQPWmZm55viEeVl
         0OvZDGZhyUnT7VZjGCihV71ttsD8e2v25Ulv1L9wcVmwo5aq9w0GVJKSoySq5Z8PQ27+
         NrqhOf2K7m6zWPgIC6xjzcRUCtCqT7ONtJJEsLE/jRNr5ZG5qakBmSp7Ih9Z7512b+WP
         5X+w==
X-Gm-Message-State: AOAM531iMZNFf2lt1T2iR7HzYR9D0pkMAsELM9o7660Aw4BR9n5GaUNC
        GCFd81lUMhKRlVjhXjlPUQ99v589nDhYlNqn
X-Google-Smtp-Source: ABdhPJyRsPbgq9dopI9kyUvdd1JcZwyg3mZgtUDHr3TBRL7S0eO1xEO6G5ZTQu7gwqKs7+RuQx6iCA==
X-Received: by 2002:a63:e216:: with SMTP id q22mr9009617pgh.3.1633325346826;
        Sun, 03 Oct 2021 22:29:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k190sm13097044pfd.211.2021.10.03.22.29.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Oct 2021 22:29:06 -0700 (PDT)
Message-ID: <615a9122.1c69fb81.30c26.7687@mx.google.com>
Date:   Sun, 03 Oct 2021 22:29:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.248-46-g2142aa76a52d
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 160 runs,
 9 regressions (v4.14.248-46-g2142aa76a52d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 160 runs, 9 regressions (v4.14.248-46-g214=
2aa76a52d)

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

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =

rk3288-veyron-jaq    | arm  | lab-collabora   | gcc-8    | multi_v7_defconf=
ig  | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.248-46-g2142aa76a52d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.248-46-g2142aa76a52d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2142aa76a52d857b9f677f0cb266d7dc1f84373b =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/615a58fbc2d57d205899a2e3

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-46-g2142aa76a52d/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-46-g2142aa76a52d/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/615a58fbc2d57d2=
05899a2e9
        new failure (last pass: v4.14.248-42-g0933954630a3)
        2 lines

    2021-10-04T01:29:09.949223  [   20.718872] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-10-04T01:29:09.991898  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/104
    2021-10-04T01:29:10.000541  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/615a55e9aad8b6b5be99a2fa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-46-g2142aa76a52d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-46-g2142aa76a52d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615a55e9aad8b6b5be99a=
2fb
        failing since 323 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/615a55e5aad8b6b5be99a2f7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-46-g2142aa76a52d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-46-g2142aa76a52d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615a55e5aad8b6b5be99a=
2f8
        failing since 323 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/615a561a18326db43d99a2ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-46-g2142aa76a52d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-46-g2142aa76a52d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615a561a18326db43d99a=
2ef
        failing since 323 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/615a606c979a2c998199a2ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-46-g2142aa76a52d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-46-g2142aa76a52d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615a606c979a2c998199a=
2ef
        failing since 323 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/615a64f55e83fbaafa99a2ea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-46-g2142aa76a52d/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-=
qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-46-g2142aa76a52d/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-=
qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615a64f55e83fbaafa99a=
2eb
        failing since 323 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
rk3288-veyron-jaq    | arm  | lab-collabora   | gcc-8    | multi_v7_defconf=
ig  | 3          =


  Details:     https://kernelci.org/test/plan/id/615a6944b0cf67ff6c99a2db

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-46-g2142aa76a52d/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-46-g2142aa76a52d/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/615a6944b0cf67ff6c99a2eb
        failing since 111 days (last pass: v4.14.236, first fail: v4.14.236=
-50-g2e03cf25d5d0)

    2021-10-04T02:38:43.722229  /lava-4636780/1/../bin/lava-test-case
    2021-10-04T02:38:43.738368  [   16.781138] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-10-04T02:38:43.738884  /lava-4636780/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/615a6944b0cf67ff6c99a304
        failing since 111 days (last pass: v4.14.236, first fail: v4.14.236=
-50-g2e03cf25d5d0) =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/615a6944b0cf67ff6c99a305
        failing since 111 days (last pass: v4.14.236, first fail: v4.14.236=
-50-g2e03cf25d5d0)

    2021-10-04T02:38:40.270577  /lava-4636780/1/../bin/lava-test-case
    2021-10-04T02:38:40.275757  [   13.329710] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
