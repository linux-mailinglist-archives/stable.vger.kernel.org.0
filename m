Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48A053BBED8
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231702AbhGEP1K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231535AbhGEP1J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Jul 2021 11:27:09 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3D71C061574
        for <stable@vger.kernel.org>; Mon,  5 Jul 2021 08:24:31 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id w22so13284353pff.5
        for <stable@vger.kernel.org>; Mon, 05 Jul 2021 08:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iv9aBG+lmIwnBxnGMzJjrYTC4WADVDsCBpR5IrH52Vw=;
        b=x4r2bPz1aCej5RnlQU956V1VOkU2ArWZLr8VPm61QFEdWhEoli1Qe2tCrD2c86XV1W
         Fdc3IPMWwNecsqM5aW3CBdGP3Fv7fqCc/hl45rxDpDr3rvHiynprYI0783/sIvmRk+LV
         77jTgpWFt2+TYh6rpWF1858ApFb4h4DPoC9kjr0gbUEf5lht2J1MjQB3YwUBWuq4vNUS
         3mM7Y456+5riiYTyECpyFHs/72/YddDbtCjDZGXuDy0XVPSRu9afxPBed9bqO+nDNPWE
         QDJ5+jJ95vi8UOrl9+RHKNXZhzo16GtU33NklS05guDIwC695hucueRmEcOyGeplObob
         nPRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iv9aBG+lmIwnBxnGMzJjrYTC4WADVDsCBpR5IrH52Vw=;
        b=XRmgqMnT/fPiu7YJl3O10x9yyUpPe4MIKktUCu29sZzjU3OMExzcGeo7lQ5NyDXd8d
         0y66kK0ZQu0KgFN+OdPY7TFiXr2pkSs/4RdoEEAITwjxE/j3vJD+f1vBVhr/s0IqA6Cy
         CSFEDS4uOm6/P8kehgOZEvSrj4k9E1cfBJbmPrw6lGzNYOogO6k7LpnRS7lJdK1/t08e
         KibL1AmavAXm5uQVQ0qZCuFrz0I+NM25mxzGFl76EUk2/peqDgwjO+UEkaaICbNycDaz
         800snx+k7E4k2nJIKnACsJvCte4sc5JX9cepZyA/8n/krsuk+6mZg+p1C2diH4AJOdNf
         U6Nw==
X-Gm-Message-State: AOAM533D0a6Stta0zqQ1O1f76mWIYxNu5U6brBgc4gOPanEk6rCjeekk
        bfleSglePEm5Wdq5kOr7nqx8lfwS9MAXY5rI
X-Google-Smtp-Source: ABdhPJyh0p1eMC2bnmWo6Nygx6CqPRD9eudIk9Rkidt1z8lhGbsPGv4+Y/SfLvSelxAfHdYltuduCQ==
X-Received: by 2002:a63:df0f:: with SMTP id u15mr16240742pgg.57.1625498671334;
        Mon, 05 Jul 2021 08:24:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h24sm13501327pfn.180.2021.07.05.08.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 08:24:31 -0700 (PDT)
Message-ID: <60e3242f.1c69fb81.47ab4.7d56@mx.google.com>
Date:   Mon, 05 Jul 2021 08:24:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.12.14-7-gb9d039f0f2f2c
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.12.y
Subject: stable-rc/linux-5.12.y baseline: 181 runs,
 6 regressions (v5.12.14-7-gb9d039f0f2f2c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.12.y baseline: 181 runs, 6 regressions (v5.12.14-7-gb9d03=
9f0f2f2c)

Regressions Summary
-------------------

platform            | arch  | lab           | compiler | defconfig         =
 | regressions
--------------------+-------+---------------+----------+-------------------=
-+------------
bcm2837-rpi-3-b-32  | arm   | lab-baylibre  | gcc-8    | bcm2835_defconfig =
 | 1          =

hip07-d05           | arm64 | lab-collabora | gcc-8    | defconfig         =
 | 1          =

r8a77950-salvator-x | arm64 | lab-baylibre  | gcc-8    | defconfig         =
 | 1          =

rk3288-veyron-jaq   | arm   | lab-collabora | gcc-8    | multi_v7_defconfig=
 | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.12.y/ker=
nel/v5.12.14-7-gb9d039f0f2f2c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.12.y
  Describe: v5.12.14-7-gb9d039f0f2f2c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b9d039f0f2f2c67492e003b60d5bebb6efc4c40b =



Test Regressions
---------------- =



platform            | arch  | lab           | compiler | defconfig         =
 | regressions
--------------------+-------+---------------+----------+-------------------=
-+------------
bcm2837-rpi-3-b-32  | arm   | lab-baylibre  | gcc-8    | bcm2835_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60e2ef179d177c5b74117985

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
4-7-gb9d039f0f2f2c/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm283=
7-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
4-7-gb9d039f0f2f2c/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm283=
7-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e2ef179d177c5b74117=
986
        failing since 4 days (last pass: v5.12.13-11-g6645d6f022e7, first f=
ail: v5.12.14) =

 =



platform            | arch  | lab           | compiler | defconfig         =
 | regressions
--------------------+-------+---------------+----------+-------------------=
-+------------
hip07-d05           | arm64 | lab-collabora | gcc-8    | defconfig         =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60e2f74babb78eda28117975

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
4-7-gb9d039f0f2f2c/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
4-7-gb9d039f0f2f2c/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e2f74babb78eda28117=
976
        failing since 3 days (last pass: v5.12.13-11-g6645d6f022e7, first f=
ail: v5.12.14) =

 =



platform            | arch  | lab           | compiler | defconfig         =
 | regressions
--------------------+-------+---------------+----------+-------------------=
-+------------
r8a77950-salvator-x | arm64 | lab-baylibre  | gcc-8    | defconfig         =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60e2f1b828ad986a621179a3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
4-7-gb9d039f0f2f2c/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-sal=
vator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
4-7-gb9d039f0f2f2c/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-sal=
vator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e2f1b828ad986a62117=
9a4
        new failure (last pass: v5.12.14) =

 =



platform            | arch  | lab           | compiler | defconfig         =
 | regressions
--------------------+-------+---------------+----------+-------------------=
-+------------
rk3288-veyron-jaq   | arm   | lab-collabora | gcc-8    | multi_v7_defconfig=
 | 3          =


  Details:     https://kernelci.org/test/plan/id/60e30e969d2f6b44e811797e

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
4-7-gb9d039f0f2f2c/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
4-7-gb9d039f0f2f2c/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60e30e969d2f6b44e8117996
        failing since 20 days (last pass: v5.12.10, first fail: v5.12.10-17=
4-g38004b22b0ae)

    2021-07-05T13:52:10.525904  /lava-4141727/1/../bin/lava-test-case
    2021-07-05T13:52:10.531204  <8>[   13.305529] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60e30e969d2f6b44e81179ae
        failing since 20 days (last pass: v5.12.10, first fail: v5.12.10-17=
4-g38004b22b0ae)

    2021-07-05T13:52:09.103724  /lava-4141727/1/../bin/lava-test-case
    2021-07-05T13:52:09.104547  <8>[   11.875780] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60e30e969d2f6b44e81179af
        failing since 20 days (last pass: v5.12.10, first fail: v5.12.10-17=
4-g38004b22b0ae)

    2021-07-05T13:52:08.082611  /lava-4141727/1/../bin/lava-test-case<8>[  =
 10.856199] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-07-05T13:52:08.083045     =

 =20
