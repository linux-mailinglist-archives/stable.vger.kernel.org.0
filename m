Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C276C3C1C3C
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 01:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbhGHXw1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Jul 2021 19:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbhGHXw0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Jul 2021 19:52:26 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F06FC061574
        for <stable@vger.kernel.org>; Thu,  8 Jul 2021 16:49:44 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id oj10-20020a17090b4d8ab0290172f77377ebso5081086pjb.0
        for <stable@vger.kernel.org>; Thu, 08 Jul 2021 16:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=khJeE8EigkeokLqr/x1MV1nBuG/YWaIbO8rCf6/BX2Y=;
        b=Vtthm36OfJTbpeCSEUsEA4T6ov1ElpWZIWgfi+pN7R4r9uil/o3OtnNNX2qa5QUr+d
         uS12e7n+8Abcf0BcpZOXn/IBhJgBJAslibFpr0hg3owCz8T1alu+/lj3Fu+Z/OjXSzdm
         X+IURGGvhCD62nMihVBkhESGD3DDmY/+gY8fqotRCsdhtqOQ2S9QFBfDWeEyhutr8nXH
         psAb2tJ9YHGlX+8ltDJ9qpDSRZrKDN7lepnz3wIHbcAZ3TNugqRQzBzEHLyfmWB7WxGi
         ofyxT0kBUBrnuSbW6D/m+Eay3yGb49LNtVdjkj2kHNh4XMOQfkbQRy8WJQTW/+keZFb6
         w6ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=khJeE8EigkeokLqr/x1MV1nBuG/YWaIbO8rCf6/BX2Y=;
        b=K0YhlKN+hT2Vvyw/CnA6Zo0ixvcn/5vvBvKV+gkyW9M22BmYYmdoqutE6jI4F4Ukta
         6gGZ4oVk7xGRPOcD5xiZnyKO1PGZZTGyzjDQJ7cmmodepxCdFP0ZBrUYOZPhNBQvc9sn
         JapzuYQbRZKqrQCYJFsVKtRMm040nPx2BTOMTECqetEP1n8GDZvmVX3ysM9ccuCPUPki
         7trhn7KUQ3ipRHlJBV4YSk07eZtdbgravwcJBeJI46tHStoiCR0YjLY59afOO6rkH8Py
         e1zET3+LkSctwu+aptsgaJMbaUJi3DVGD7uGRumP++at8HV7AKfLpway3gcq58Fdn91q
         u6rg==
X-Gm-Message-State: AOAM531xhhdimYcgYo4N8txK2z+GTstjF8MTWFCwvvN+qIW/aAkQ5Lq9
        vskmbEAVcNGVIB9jlDTBCtht2BsEii9nZC9t
X-Google-Smtp-Source: ABdhPJzAuamYf6ruZktSisIXmsWY0aVkle/CqeIMEPSqdkMtsMl03A1TegJUpbrBWKz/nQbJe8zXPA==
X-Received: by 2002:a17:90b:4c4b:: with SMTP id np11mr7423836pjb.125.1625788183389;
        Thu, 08 Jul 2021 16:49:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 194sm4057840pfy.51.2021.07.08.16.49.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 16:49:43 -0700 (PDT)
Message-ID: <60e78f17.1c69fb81.1ebad.cd38@mx.google.com>
Date:   Thu, 08 Jul 2021 16:49:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.12.15
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.12.y
Subject: stable-rc/linux-5.12.y baseline: 195 runs, 6 regressions (v5.12.15)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.12.y baseline: 195 runs, 6 regressions (v5.12.15)

Regressions Summary
-------------------

platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre  | gcc-8    | bcm2835_defconfig  =
| 1          =

hip07-d05          | arm64 | lab-collabora | gcc-8    | defconfig          =
| 1          =

imx8mp-evk         | arm64 | lab-nxp       | gcc-8    | defconfig          =
| 1          =

rk3288-veyron-jaq  | arm   | lab-collabora | gcc-8    | multi_v7_defconfig =
| 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.12.y/ker=
nel/v5.12.15/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.12.y
  Describe: v5.12.15
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fc3b667678f2513869b20f161d648580c9b2ae62 =



Test Regressions
---------------- =



platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre  | gcc-8    | bcm2835_defconfig  =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60e759cfed921f6fef11796e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
5/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
5/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e759cfed921f6fef117=
96f
        failing since 8 days (last pass: v5.12.13-11-g6645d6f022e7, first f=
ail: v5.12.14) =

 =



platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
hip07-d05          | arm64 | lab-collabora | gcc-8    | defconfig          =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60e7661e58f1143735117972

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
5/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
5/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e7661e58f1143735117=
973
        failing since 7 days (last pass: v5.12.13-11-g6645d6f022e7, first f=
ail: v5.12.14) =

 =



platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
imx8mp-evk         | arm64 | lab-nxp       | gcc-8    | defconfig          =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60e75f825ce49d637111798f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
5/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
5/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e75f825ce49d6371117=
990
        new failure (last pass: v5.12.14) =

 =



platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
rk3288-veyron-jaq  | arm   | lab-collabora | gcc-8    | multi_v7_defconfig =
| 3          =


  Details:     https://kernelci.org/test/plan/id/60e77c065f8a68af56117974

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
5/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
5/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60e77c065f8a68af56117988
        failing since 23 days (last pass: v5.12.10, first fail: v5.12.10-17=
4-g38004b22b0ae)

    2021-07-08T22:27:45.338079  /lava-4160414/1/../bin/lava-test-case
    2021-07-08T22:27:45.355280  <8>[   13.165317] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-07-08T22:27:45.355580  /lava-4160414/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60e77c065f8a68af561179a0
        failing since 23 days (last pass: v5.12.10, first fail: v5.12.10-17=
4-g38004b22b0ae)

    2021-07-08T22:27:43.911263  /lava-4160414/1/../bin/lava-test-case
    2021-07-08T22:27:43.928328  <8>[   11.738623] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-07-08T22:27:43.928589  /lava-4160414/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60e77c065f8a68af561179a1
        failing since 23 days (last pass: v5.12.10, first fail: v5.12.10-17=
4-g38004b22b0ae)

    2021-07-08T22:27:42.898548  /lava-4160414/1/../bin/lava-test-case<8>[  =
 10.719181] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-07-08T22:27:42.898969     =

 =20
