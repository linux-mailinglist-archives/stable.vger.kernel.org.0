Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E488A400273
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 17:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349704AbhICPjZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 11:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349674AbhICPjY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Sep 2021 11:39:24 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A913C061575
        for <stable@vger.kernel.org>; Fri,  3 Sep 2021 08:38:24 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id g184so5903235pgc.6
        for <stable@vger.kernel.org>; Fri, 03 Sep 2021 08:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lbUp6CXe+Ol9lnfADMAf3N7/3NZPH7v7NCprt+suKKk=;
        b=cOyi6/IP42HdBCpbnK7VcdG/OZwZ9ax5zFOf+EzuNu616c7RT2pWdq8aMrldcmy50l
         MP4hR/ww+udTnyu0ai7FJ+0FovPF1dZK5d+y6xmQuqzpfF6KHxnEIfKYt6FMdiDjkj7M
         IkdESs1pHSw0IGLWfUXDLscJ1/JwyB1FrdQ1ahXqFqWg88SEllkFGdaonxge8GLAldG0
         GuRJROmdnMRM35oUNXJEVVSQOZ6CGvI4xyLnmL8Kb+u8LdYhjj+BXKCZYGg4P0mnKLrm
         z9yyCUcWCDNVhVsaZFw1Oa30+jdzScdEOtTA8dmVYc/9b1v627vZTmjldeL1u325md9y
         Di9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lbUp6CXe+Ol9lnfADMAf3N7/3NZPH7v7NCprt+suKKk=;
        b=VtdfJiXtOySIsPSYxlrvBqIIATA+XoEKz5czbJftTDZqUGT2/G05gYTeAPCrfeuVL/
         SxbaFmlLhB+0wtYG1vL1eWleIPnJUDp8cUlHIby6KqoSh01Q2P1Ih2zYlgDYMHpannBC
         Wq0xuhFNZ7G1tg1qktfVAP1ams8zQMHMK4AKzJEFJLNsxrXZRMK2TT7SehtXVSy8M7+h
         7vR3w/xUuYWNJz7QYb8CX1ZpUSoCUEX84KWGE9AugG8E99ceyEYsvczxcrCxEyaivfn2
         mD6Ea8kwMXewczTpHNWkS7MxKxl4imOXeoqbJ5vT/kcehcoPI4DUteh9XrRJtF+fRkmq
         tWJQ==
X-Gm-Message-State: AOAM533A0AhRnbPPejv7A+a3n12oAScEp3rg374AqNHRBqBCuOW64AVi
        zRAOvJw+apKzixwr00BieD43vBWv459fqBLb
X-Google-Smtp-Source: ABdhPJze6YMlx7u0nQtaDpUGdyQRFuckaYl6e5xuKBJgEXCK+VjzcdutxulSbWYtYd7kV80QHotZ0A==
X-Received: by 2002:a63:184a:: with SMTP id 10mr4118939pgy.149.1630683503494;
        Fri, 03 Sep 2021 08:38:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p9sm6110384pfq.15.2021.09.03.08.38.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 08:38:23 -0700 (PDT)
Message-ID: <6132416f.1c69fb81.f435f.f866@mx.google.com>
Date:   Fri, 03 Sep 2021 08:38:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.246
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
Subject: stable/linux-4.14.y baseline: 138 runs, 8 regressions (v4.14.246)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 138 runs, 8 regressions (v4.14.246)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

rk3288-veyron-jaq    | arm   | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 3          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.246/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.246
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      f96eb53cbd76415edfba99c2cfa88567a885a428 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/61320f12e86d38ca80d5968a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.246/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.246/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61320f12e86d38ca80d59=
68b
        failing since 518 days (last pass: v4.14.172, first fail: v4.14.175=
) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/6132115ba6b899394ad5967d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.246/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.246/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6132115ba6b899394ad59=
67e
        failing since 222 days (last pass: v4.14.216, first fail: v4.14.217=
) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/61320d3d25ae49c52dd5966b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.246/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.246/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61320d3d25ae49c52dd59=
66c
        failing since 288 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/61321894ff2a09745bd5968d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.246/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.246/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61321894ff2a09745bd59=
68e
        failing since 288 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/61320a14a7207095c4d59671

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.246/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.246/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61320a14a7207095c4d59=
672
        failing since 288 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
rk3288-veyron-jaq    | arm   | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 3          =


  Details:     https://kernelci.org/test/plan/id/61320dcecea04a0658d59671

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.246/=
arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.246/=
arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/61320dcecea04a0658d59685
        failing since 78 days (last pass: v4.14.236, first fail: v4.14.237)

    2021-09-03T11:57:39.665700  /lava-4442573/1/../bin/lava-test-case
    2021-09-03T11:57:39.682721  [   17.035024] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-09-03T11:57:39.682987  /lava-4442573/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/61320dcecea04a0658d5969e
        failing since 78 days (last pass: v4.14.236, first fail: v4.14.237)

    2021-09-03T11:57:37.234466  /lava-4442573/1/../bin/lava-test-case
    2021-09-03T11:57:37.251454  [   14.603545] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/61320dcecea04a0658d5969f
        failing since 78 days (last pass: v4.14.236, first fail: v4.14.237)

    2021-09-03T11:57:36.215607  /lava-4442573/1/../bin/lava-test-case
    2021-09-03T11:57:36.221219  [   13.584756] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
