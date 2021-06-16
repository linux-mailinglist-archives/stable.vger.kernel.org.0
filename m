Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 886743A9F05
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 17:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234558AbhFPP2f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 11:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234618AbhFPP2f (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 11:28:35 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED4A5C061574
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 08:26:27 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id v7so2273433pgl.2
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 08:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=f2lQW0/3CvIeuGRLeJSt9TTgwqxUbC6tXEHHF9KhfWM=;
        b=wb8SEohp/RTXVqSJVnAwSslCqDqHyYX6nItYAymdVbLSgR+Q6CELICi2dkTys+5hIi
         92ysVse5Dwpd2Ud+CxjieGOr2Q4cmR6FWl6fjAe56JXpIBrnC2Ly3tvMmbuk5910pgp/
         ZXNHo7fcTAQAuhD2gKWh2iUzWtfPGv7x2ED1ASTKW6V6rypKie0Ur8acSF5sUx3Ki8jo
         sQkrcGs42gtjO59BL3+8+yT5TF46Fq1dwLjP9H3Q/CaqFlNBO33M03ojt612J8C4v1sN
         Da+22O4blVY8axZP5/3jvLLtTCI98dJG39c39q6HLXEOMknXo3MZ0dSrIuoHHuDWHsxn
         24vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=f2lQW0/3CvIeuGRLeJSt9TTgwqxUbC6tXEHHF9KhfWM=;
        b=pg3645etgQjSQ+SZutes9lr2M24smUvM9j6kKYwO0EL0aP0j0++PNqQW7SdoVt0uzB
         +9ov72Rca4CTMEmc1ASWk0W8VncRQ231t5DQVsjLmseJMFTYWukIkdtwdNS6XaGoccBK
         UQQ+zPhhFGvZY9lZ95Erk7RJ0qe+y7DC4xOHu0u11VUVfYQ1MR6pNKz/LQfVwkvLAWJw
         N5T6blSDE7scRqSckGN7TSBlKw5jlATj56y8D6UCXp3C9ZB47akGmKxJFZWdgKnfyW5w
         1ET6Jcj4q5zP6P+p1YPnBq6eLPzV8JnXs/AJ8+hXjTW3cCXdi9J3fdvj4AoMmHRaOZYF
         tBpg==
X-Gm-Message-State: AOAM533v8bs9tHFlFIuIy7I+IS8OfQEscvmF3toCIQ1amEv1QK4yhVJW
        Ly4+PmsZF2QU8Y+T2+82fy40CJMLmE32Z7is
X-Google-Smtp-Source: ABdhPJxpUQn3j+PKiZLUBPpvBf3XI54xJMEGuC8MpJIxKRkxFLkc1oiuW2RMRIVMh12oIDCvNluXqQ==
X-Received: by 2002:a63:6d03:: with SMTP id i3mr138266pgc.338.1623857187047;
        Wed, 16 Jun 2021 08:26:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 194sm2476657pfb.139.2021.06.16.08.26.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 08:26:26 -0700 (PDT)
Message-ID: <60ca1822.1c69fb81.65da.67b2@mx.google.com>
Date:   Wed, 16 Jun 2021 08:26:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.237
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.14.y baseline: 124 runs, 10 regressions (v4.14.237)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 124 runs, 10 regressions (v4.14.237)

Regressions Summary
-------------------

platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
meson-gxbb-p200      | arm64  | lab-baylibre  | gcc-8    | defconfig       =
             | 1          =

meson-gxm-q200       | arm64  | lab-baylibre  | gcc-8    | defconfig       =
             | 1          =

qemu_arm-versatilepb | arm    | lab-baylibre  | gcc-8    | versatile_defcon=
fig          | 1          =

qemu_arm-versatilepb | arm    | lab-broonie   | gcc-8    | versatile_defcon=
fig          | 1          =

qemu_arm-versatilepb | arm    | lab-cip       | gcc-8    | versatile_defcon=
fig          | 1          =

qemu_arm-versatilepb | arm    | lab-collabora | gcc-8    | versatile_defcon=
fig          | 1          =

qemu_x86_64          | x86_64 | lab-broonie   | gcc-8    | x86_64_defcon...=
6-chromebook | 1          =

rk3288-veyron-jaq    | arm    | lab-collabora | gcc-8    | multi_v7_defconf=
ig           | 3          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.237/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.237
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      cfb41ef9deb1e6572ac218ddfcec9567e5d1c101 =



Test Regressions
---------------- =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
meson-gxbb-p200      | arm64  | lab-baylibre  | gcc-8    | defconfig       =
             | 1          =


  Details:     https://kernelci.org/test/plan/id/60c9e4ad48ad0e2d8a413282

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.237/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.237/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c9e4ad48ad0e2d8a413=
283
        failing since 439 days (last pass: v4.14.172, first fail: v4.14.175=
) =

 =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
meson-gxm-q200       | arm64  | lab-baylibre  | gcc-8    | defconfig       =
             | 1          =


  Details:     https://kernelci.org/test/plan/id/60c9e67e89a4899d4f413266

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.237/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.237/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c9e67e89a4899d4f413=
267
        failing since 143 days (last pass: v4.14.216, first fail: v4.14.217=
) =

 =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
qemu_arm-versatilepb | arm    | lab-baylibre  | gcc-8    | versatile_defcon=
fig          | 1          =


  Details:     https://kernelci.org/test/plan/id/60c9e3215fb11b7a4b41329a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.237/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.237/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c9e3215fb11b7a4b413=
29b
        failing since 209 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
qemu_arm-versatilepb | arm    | lab-broonie   | gcc-8    | versatile_defcon=
fig          | 1          =


  Details:     https://kernelci.org/test/plan/id/60c9e34c33090f9521413278

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.237/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.237/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c9e34c33090f9521413=
279
        failing since 209 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
qemu_arm-versatilepb | arm    | lab-cip       | gcc-8    | versatile_defcon=
fig          | 1          =


  Details:     https://kernelci.org/test/plan/id/60c9e6e44889c3e3e9413281

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.237/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.237/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c9e6e44889c3e3e9413=
282
        failing since 209 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
qemu_arm-versatilepb | arm    | lab-collabora | gcc-8    | versatile_defcon=
fig          | 1          =


  Details:     https://kernelci.org/test/plan/id/60c9f2d30f5ed3d1f2413279

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.237/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.237/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c9f2d30f5ed3d1f2413=
27a
        failing since 209 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
qemu_x86_64          | x86_64 | lab-broonie   | gcc-8    | x86_64_defcon...=
6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/60c9e59140f3b0467c41326a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.237/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/baseline-qemu_x86_=
64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.237/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/baseline-qemu_x86_=
64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c9e59140f3b0467c413=
26b
        new failure (last pass: v4.14.236) =

 =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
rk3288-veyron-jaq    | arm    | lab-collabora | gcc-8    | multi_v7_defconf=
ig           | 3          =


  Details:     https://kernelci.org/test/plan/id/60ca15d53e50a1c4ae41328f

  Results:     62 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.237/=
arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.237/=
arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60ca15d53e50a1c4ae4132ab
        new failure (last pass: v4.14.236)

    2021-06-16T15:16:29.851967  /lava-4036108/1/../bin/lava-test-case
    2021-06-16T15:16:29.856978  [   13.799466] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60ca15d53e50a1c4ae4132ac
        new failure (last pass: v4.14.236)

    2021-06-16T15:16:30.872346  /lava-4036108/1/../bin/lava-test-case
    2021-06-16T15:16:30.888010  [   14.818340] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-06-16T15:16:30.888253  /lava-4036108/1/../bin/lava-test-case   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60ca15d53e50a1c4ae4132c5
        new failure (last pass: v4.14.236)

    2021-06-16T15:16:33.301330  /lava-4036108/1/../bin/lava-test-case
    2021-06-16T15:16:33.318681  [   17.249301] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-06-16T15:16:33.318940  /lava-4036108/1/../bin/lava-test-case   =

 =20
