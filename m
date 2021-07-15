Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30BD23CADFE
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 22:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbhGOUhJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 16:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231250AbhGOUhI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Jul 2021 16:37:08 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10D22C06175F
        for <stable@vger.kernel.org>; Thu, 15 Jul 2021 13:34:14 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id o4so3104197pgs.6
        for <stable@vger.kernel.org>; Thu, 15 Jul 2021 13:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QKX9Ve6JKXcXqAFHdvPF9OAhGiCZIqHztuYo5P372fA=;
        b=FwP5Q2uWCEOEc52qET7nsNj4d5mTiBQCUu0Dm5qVKkqlQvLkNZwNxoZpgx9to3F0EI
         QT1BkVJNXiM7b9ziVdXFdvF7oow2sHFA8LwESfY2JL074OKh1Icn4f9ei51wkI8lZ2y4
         fZeIwXdQRpy9nKTzN31TRQwWbHSTkljfHApiQgfLZKVkJwytJ+zomzSOViM2LcVInMtB
         Nmbe5ks2w5cB23ZkbKK52bD0RhRSGCXjJbytbxfQmySJOmoS3NauWsM9N/rvurtnEH6y
         bDkAfFK+nER0gY49kP0nZ4O2WWuXy4AzDIgmGQRryoDuUtGVFT1YhocCSgT2LLQS5LfH
         tsuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QKX9Ve6JKXcXqAFHdvPF9OAhGiCZIqHztuYo5P372fA=;
        b=l/IpW+EIH8yDTKnKRPVVMlsmiOtux0FYNoHHm6UWdrO9x99uI4C9tWYtkeqVkldiUD
         yJbv5JP238oKQUilDwu/hjgg95lnnFPErfmvypImOQ5TRAmD/yRBcGeqwZ00LRAVJYAR
         0CBB26jrD5MwELVZO44uMomZoeE6gJfbmxn3TpUNvGL259ccmkSXHQeTt6+6gya/iiMQ
         EiHLmxCTPnw7o09kH//jRC0XaVyl6z7ZyQqM8cnZvbVdfeDuazYrJzQpneOzSxhPYd/3
         +EvW28GYRr+KXh1ZTzytbVpBzgi075AdE79mKen1rWXC1Dz0E3yJD3SkuJK3kNZcNO/n
         SQGg==
X-Gm-Message-State: AOAM530MqoWgz0QLOPDUiyiksnJjH7yXtcyu1/nRCjtDw0MDeoiH2tz7
        EgVsgwoNsapvRH4Pcuz3ceNz+VSS7TMlZOM0
X-Google-Smtp-Source: ABdhPJxpVosLFn/XOSHtV93j40hjdt0/BXYSBp/3sjIDZ5MieAxa/8NNTHKKVeq7vSnyw5h+BSsMdg==
X-Received: by 2002:a62:b502:0:b029:2ec:a539:e29b with SMTP id y2-20020a62b5020000b02902eca539e29bmr6584405pfe.37.1626381253210;
        Thu, 15 Jul 2021 13:34:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o134sm7809860pfg.62.2021.07.15.13.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 13:34:12 -0700 (PDT)
Message-ID: <60f09bc4.1c69fb81.fb262.7cb7@mx.google.com>
Date:   Thu, 15 Jul 2021 13:34:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.12
X-Kernelci-Kernel: v5.12.17-229-g894263ece741
Subject: stable-rc/queue/5.12 baseline: 199 runs,
 10 regressions (v5.12.17-229-g894263ece741)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 199 runs, 10 regressions (v5.12.17-229-g8942=
63ece741)

Regressions Summary
-------------------

platform           | arch   | lab           | compiler | defconfig         =
 | regressions
-------------------+--------+---------------+----------+-------------------=
-+------------
bcm2837-rpi-3-b-32 | arm    | lab-baylibre  | gcc-8    | bcm2835_defconfig =
 | 2          =

beagle-xm          | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfig=
 | 1          =

d2500cc            | x86_64 | lab-clabbe    | gcc-8    | x86_64_defconfig  =
 | 1          =

hip07-d05          | arm64  | lab-collabora | gcc-8    | defconfig         =
 | 1          =

imx8mp-evk         | arm64  | lab-nxp       | gcc-8    | defconfig         =
 | 1          =

meson-gxm-q200     | arm64  | lab-baylibre  | gcc-8    | defconfig         =
 | 1          =

rk3288-veyron-jaq  | arm    | lab-collabora | gcc-8    | multi_v7_defconfig=
 | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.17-229-g894263ece741/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.17-229-g894263ece741
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      894263ece741b09e9c0961f29715e86cbbd17b13 =



Test Regressions
---------------- =



platform           | arch   | lab           | compiler | defconfig         =
 | regressions
-------------------+--------+---------------+----------+-------------------=
-+------------
bcm2837-rpi-3-b-32 | arm    | lab-baylibre  | gcc-8    | bcm2835_defconfig =
 | 2          =


  Details:     https://kernelci.org/test/plan/id/60f0673090c07f722c8a93b8

  Results:     2 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.17-=
229-g894263ece741/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.17-=
229-g894263ece741/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/60f0673190c07f7=
22c8a93bc
        new failure (last pass: v5.12.17-153-ga65b3f168efa)
        4 lines

    2021-07-15T16:49:39.282647  kern  :alert : 8<--- cut here ---
    2021-07-15T16:49:39.284239  kern  :alert : Unable to handle kernel NULL=
 pointer dereference at virtual address 00000024
    2021-07-15T16:49:39.285060  kern  :alert : pgd =3D 6e7d78b9
    2021-07-15T16:49:39.285802  kern  :alert : [00000024] *pgd=3D04170835, =
*pte=3D00000000, *ppte=3D00000000
    2021-07-15T16:49:39.286910  <8>[   43.521943] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60f0673190c07f7=
22c8a93bd
        new failure (last pass: v5.12.17-153-ga65b3f168efa)
        28 lines

    2021-07-15T16:49:39.358168  kern  :emerg : Internal error: Oops: 17 [#1=
] ARM
    2021-07-15T16:49:39.359763  kern  :emerg : Process start-stop-daem (pid=
: 140, stack limit =3D 0x1b7ba70a)
    2021-07-15T16:49:39.360537  kern  :emerg : Stack: (0xc42add80 to 0xc42a=
e000)
    2021-07-15T16:49:39.361304  kern  :emerg : dd80: 00000000 c42ade60 ffff=
ffff c42add9<8>[   43.595150] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RE=
SULT=3Dfail UNITS=3Dlines MEASUREMENT=3D28>   =

 =



platform           | arch   | lab           | compiler | defconfig         =
 | regressions
-------------------+--------+---------------+----------+-------------------=
-+------------
beagle-xm          | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60f06c288c1ce74ccd8a93ba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.17-=
229-g894263ece741/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.17-=
229-g894263ece741/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f06c288c1ce74ccd8a9=
3bb
        failing since 0 day (last pass: v5.12.16-704-g811a519d7fbbb, first =
fail: v5.12.16-702-gf996b03ef63d7) =

 =



platform           | arch   | lab           | compiler | defconfig         =
 | regressions
-------------------+--------+---------------+----------+-------------------=
-+------------
d2500cc            | x86_64 | lab-clabbe    | gcc-8    | x86_64_defconfig  =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60f068323c4ed6f48f8a93a7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.17-=
229-g894263ece741/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.17-=
229-g894263ece741/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f068323c4ed6f48f8a9=
3a8
        failing since 3 days (last pass: v5.12.15-11-g1a88438d15d2, first f=
ail: v5.12.16-682-g36eea3662e2d) =

 =



platform           | arch   | lab           | compiler | defconfig         =
 | regressions
-------------------+--------+---------------+----------+-------------------=
-+------------
hip07-d05          | arm64  | lab-collabora | gcc-8    | defconfig         =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60f06c1d8c1ce74ccd8a93b4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.17-=
229-g894263ece741/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.17-=
229-g894263ece741/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f06c1d8c1ce74ccd8a9=
3b5
        failing since 14 days (last pass: v5.12.13-109-g5add6842f3ea, first=
 fail: v5.12.13-109-g47e1fda87919) =

 =



platform           | arch   | lab           | compiler | defconfig         =
 | regressions
-------------------+--------+---------------+----------+-------------------=
-+------------
imx8mp-evk         | arm64  | lab-nxp       | gcc-8    | defconfig         =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60f06ad66aaaafdb7b8a93be

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.17-=
229-g894263ece741/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.17-=
229-g894263ece741/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f06ad66aaaafdb7b8a9=
3bf
        failing since 0 day (last pass: v5.12.16-702-gf996b03ef63d7, first =
fail: v5.12.17-153-ga65b3f168efa) =

 =



platform           | arch   | lab           | compiler | defconfig         =
 | regressions
-------------------+--------+---------------+----------+-------------------=
-+------------
meson-gxm-q200     | arm64  | lab-baylibre  | gcc-8    | defconfig         =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60f0696f0c25856aba8a939d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.17-=
229-g894263ece741/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.17-=
229-g894263ece741/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f0696f0c25856aba8a9=
39e
        new failure (last pass: v5.12.17-153-ga65b3f168efa) =

 =



platform           | arch   | lab           | compiler | defconfig         =
 | regressions
-------------------+--------+---------------+----------+-------------------=
-+------------
rk3288-veyron-jaq  | arm    | lab-collabora | gcc-8    | multi_v7_defconfig=
 | 3          =


  Details:     https://kernelci.org/test/plan/id/60f06b51757cc217a48a93cb

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.17-=
229-g894263ece741/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.17-=
229-g894263ece741/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60f06b52757cc217a48a93e3
        failing since 30 days (last pass: v5.12.10-48-g5e97c6651365, first =
fail: v5.12.10-173-gfd0b35fa0b0c)

    2021-07-15T17:06:52.039823  /lava-4204601/1/../bin/lava-test-case
    2021-07-15T17:06:52.056807  <8>[   13.487907] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-07-15T17:06:52.057034  /lava-4204601/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60f06b52757cc217a48a93fb
        failing since 30 days (last pass: v5.12.10-48-g5e97c6651365, first =
fail: v5.12.10-173-gfd0b35fa0b0c)

    2021-07-15T17:06:50.602126  /lava-4204601/1/../bin/lava-test-case
    2021-07-15T17:06:50.611641  <8>[   12.058498] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60f06b52757cc217a48a93fc
        failing since 30 days (last pass: v5.12.10-48-g5e97c6651365, first =
fail: v5.12.10-173-gfd0b35fa0b0c)

    2021-07-15T17:06:49.596138  /lava-4204601/1/../bin/lava-test-case<8>[  =
 11.038731] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-07-15T17:06:49.596442     =

 =20
