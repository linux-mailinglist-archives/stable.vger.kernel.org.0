Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9829409C60
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 20:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238614AbhIMSjU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 14:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238241AbhIMSjT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 14:39:19 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3520C061574
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 11:38:03 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id k23so7031334pji.0
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 11:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tO6NBSI1ExqHCwCzVwTLfxkonr7MAS8hELg9oAjc1Aw=;
        b=iZh+eSD8BSX4qdc5ISjhZSAEXsVudJK1I3kRuETX+5lAjuToz/jNkoFTzQWDYl/ziA
         S0D3O23uXRfoa0XJxRTwCjgg3eUy/EqCA3JkdENQXM/wMWQLSuWfeAfFGP9+8V1SfWsI
         0zcfjrIdd6VHuT4O15rmV/M0wPCxqwRgq8Y9VJpvOsFMsD8qd38zFf236aDzAO3SWa+Y
         US+9Jc/KQRbxkZ3DlYimbBTo7S+8UtBz3kHiB4WBJkQ6N+18PRMIUo+YnUsmWToo2ldA
         1NPm1Pd20JpdvWBxWAleW3GFGePfmHsQS4wI+yfpOrL/bVqLBjWypQX7XbcafSc0fK1G
         W3aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tO6NBSI1ExqHCwCzVwTLfxkonr7MAS8hELg9oAjc1Aw=;
        b=UZLROZ8SOUN/JmbUOrBMZ8oDfdZluwxBNUA/Uyw99/daRetUWOczzc5LPKyPYvyyzx
         Yq4O3XNxf+adeGRIUPLE7J2iThFiBR9/9yNaeLz9GgK+zq5g8hl8X7EVSZ7qj64xBLsL
         QeQhffHI4VqPdLc3VFsb6FGyD2eNnW4pKL1tNZmpOaYadxy6zsd73z0XTS6+Puzs8sQT
         B5+tzWv3c+cj8xks2NRcY6EgyxWZied3Oq8dj8ZEZe/aJDETFtFEVZEvbzFQZrz/MqZ9
         C1ZPjf0wTgXYBNSRu6moYpTz3VHgalcZw3UKOP1kDjhD+LzWhvUfWYmotyuSJ2y/YPCk
         580A==
X-Gm-Message-State: AOAM531OTtUkuGIO1vwHIyDI9jJ1alUWlg2waCsQQPmT0zklilxxTdkO
        Nex8Ql5gRmB5+t7EVxpLbo//qvIBUBV/BLRV
X-Google-Smtp-Source: ABdhPJyd1nJIyT9TcQD73t1mN2Le65Gh2OhaPdQWzxsLcFyD5CMPHvPZVTWurSr/7Cl2W2qBB5qRAA==
X-Received: by 2002:a17:90a:ea0a:: with SMTP id w10mr977112pjy.32.1631558283182;
        Mon, 13 Sep 2021 11:38:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a26sm9135203pgm.87.2021.09.13.11.38.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 11:38:02 -0700 (PDT)
Message-ID: <613f9a8a.1c69fb81.a530e.a122@mx.google.com>
Date:   Mon, 13 Sep 2021 11:38:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.206-120-gf2cc6960ceb9
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 151 runs,
 6 regressions (v4.19.206-120-gf2cc6960ceb9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 151 runs, 6 regressions (v4.19.206-120-gf2cc=
6960ceb9)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =

rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.206-120-gf2cc6960ceb9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.206-120-gf2cc6960ceb9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f2cc6960ceb92d5c814d530d85c19b332e62fff2 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/613f669bd88b8a3d9199a31b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-120-gf2cc6960ceb9/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-120-gf2cc6960ceb9/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613f669bd88b8a3d9199a=
31c
        failing since 303 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/613f66c788fc564e8899a2de

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-120-gf2cc6960ceb9/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-120-gf2cc6960ceb9/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613f66c788fc564e8899a=
2df
        failing since 303 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/613f670ba1e8c74c4e99a2f7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-120-gf2cc6960ceb9/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-120-gf2cc6960ceb9/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613f670ba1e8c74c4e99a=
2f8
        failing since 303 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:     https://kernelci.org/test/plan/id/613f7f77bb35b8df2e99a2ee

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-120-gf2cc6960ceb9/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-120-gf2cc6960ceb9/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/613f7f78bb35b8df2e99a302
        failing since 90 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-09-13T16:42:20.343858  /lava-4510435/1/../bin/lava-test-case
    2021-09-13T16:42:20.361209  <8>[   18.065928] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-09-13T16:42:20.361657  /lava-4510435/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/613f7f78bb35b8df2e99a31b
        failing since 90 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-09-13T16:42:17.922348  /lava-4510435/1/../bin/lava-test-case<8>[  =
 15.624242] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-09-13T16:42:17.922706  =

    2021-09-13T16:42:17.922901  /lava-4510435/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/613f7f78bb35b8df2e99a31c
        failing since 90 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-09-13T16:42:16.883889  /lava-4510435/1/../bin/lava-test-case
    2021-09-13T16:42:16.892710  <8>[   14.604752] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
