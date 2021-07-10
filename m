Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2BAC3C3227
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 05:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbhGJDKs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 23:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbhGJDKr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Jul 2021 23:10:47 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67FC7C0613DD
        for <stable@vger.kernel.org>; Fri,  9 Jul 2021 20:08:02 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id f17so10510492pfj.8
        for <stable@vger.kernel.org>; Fri, 09 Jul 2021 20:08:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=svbIw6+M1t1Sn7Rop9g3p88T3GZmJLPmqtu6rGx/3So=;
        b=USI3HH8XDBHJZ2yBctKbaMRKhhEzjUG3nsREwQV+WLGR/+HPma1ZlE3GK0T4/nmE2e
         MkGiFNooe4pmiQ4lPhxTmGXwvTNMWSeweOBSMSF+JiMuswRx29Q3Mg1WZpkv1T9eLt1t
         7+9aFAKuK+gkbL2Gmv0XAxI3Za930sFE9nLkmpHhReBE4jSA6F+DdX9q0KxYiY6V9TA1
         rIEErNV60HwlV8IVjzFxru8VSLfMWmKk8HYRkILeYdm6j6c3CiNlGchFy+L2PuQ3UzLT
         9ug9M2P6EJIiesQa70ULNqsZqtNh9ZacFxQlw1e0DJoTpLX8y5ohF71l1vsEIdbnddqz
         X2Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=svbIw6+M1t1Sn7Rop9g3p88T3GZmJLPmqtu6rGx/3So=;
        b=BI0YmwKMomcU7W4YIeiw81gvEPHtYbb7oMmGl1jEeqnWIu0JJQPIT0RFDPxVVMQiVa
         PME9b5WADty8ThRbDVBXSygqSJekmKLT0BEQYWt+fwdatcN73Z0PIYr2dkborUrmYud9
         53f9J7Zn0SroiPju6+iWO0ukAv05Oc/vQckKQz9aM1sq/dqrr5cRDJcuOKe3Xi2i7/jI
         ea3tZ4YPZH1AzadJAmMB8nB8hkhAmvrqgszKoCSPQRq8dcwBTTGZKT4XwXdMa6TClBD1
         FhSBeJEidsD/mKiPQH76JanetyxIqgTyTwsiBdufqfp7JkMVJDwggN4YcY330A9ND4gF
         q+kA==
X-Gm-Message-State: AOAM530NejhptTkvmrPhhz2hc7hKTqxtDbDAtpJH2kwb+GhUtI+5diAs
        vTRJUaqTixvBPN8TflEq9yiUvmDMsu4PxQ3Q
X-Google-Smtp-Source: ABdhPJz07KVdTXnHwd9EM8Qkfo0s1EqIBoiUB1LgLbnE6aMq/5/ZwSb2Kx29AT5J/29P9R5Io0iHAQ==
X-Received: by 2002:a62:507:0:b029:31c:c439:83ab with SMTP id 7-20020a6205070000b029031cc43983abmr34431164pff.65.1625886481012;
        Fri, 09 Jul 2021 20:08:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v1sm7821166pfn.40.2021.07.09.20.08.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 20:08:00 -0700 (PDT)
Message-ID: <60e90f10.1c69fb81.52ad8.942f@mx.google.com>
Date:   Fri, 09 Jul 2021 20:08:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.12.15-11-g1a88438d15d2
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.12
Subject: stable-rc/queue/5.12 baseline: 197 runs,
 5 regressions (v5.12.15-11-g1a88438d15d2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 197 runs, 5 regressions (v5.12.15-11-g1a8843=
8d15d2)

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

rk3288-veyron-jaq  | arm   | lab-collabora | gcc-8    | multi_v7_defconfig =
| 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.15-11-g1a88438d15d2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.15-11-g1a88438d15d2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1a88438d15d215c4704f9e93b59491c5b73bd297 =



Test Regressions
---------------- =



platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre  | gcc-8    | bcm2835_defconfig  =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60e8dd377babedbd38117981

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.15-=
11-g1a88438d15d2/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.15-=
11-g1a88438d15d2/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e8dd377babedbd38117=
982
        failing since 4 days (last pass: v5.12.14-5-gb49b7dd97218, first fa=
il: v5.12.14-6-g9a76cc7cd8f73) =

 =



platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
hip07-d05          | arm64 | lab-collabora | gcc-8    | defconfig          =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60e8eaa3e5231c74f111796c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.15-=
11-g1a88438d15d2/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.15-=
11-g1a88438d15d2/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e8eaa3e5231c74f1117=
96d
        failing since 8 days (last pass: v5.12.13-109-g5add6842f3ea, first =
fail: v5.12.13-109-g47e1fda87919) =

 =



platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
rk3288-veyron-jaq  | arm   | lab-collabora | gcc-8    | multi_v7_defconfig =
| 3          =


  Details:     https://kernelci.org/test/plan/id/60e8ec49fa4d1e310811796f

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.15-=
11-g1a88438d15d2/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.15-=
11-g1a88438d15d2/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60e8ec4afa4d1e3108117987
        failing since 24 days (last pass: v5.12.10-48-g5e97c6651365, first =
fail: v5.12.10-173-gfd0b35fa0b0c)

    2021-07-10T00:39:27.173241  /lava-4168522/1/../bin/lava-test-case<8>[  =
 14.035184] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-07-10T00:39:27.173737  =

    2021-07-10T00:39:27.174090  /lava-4168522/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60e8ec4afa4d1e310811799f
        failing since 24 days (last pass: v5.12.10-48-g5e97c6651365, first =
fail: v5.12.10-173-gfd0b35fa0b0c)

    2021-07-10T00:39:25.729056  /lava-4168522/1/../bin/lava-test-case
    2021-07-10T00:39:25.746791  <8>[   12.608910] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60e8ec4afa4d1e31081179a0
        failing since 24 days (last pass: v5.12.10-48-g5e97c6651365, first =
fail: v5.12.10-173-gfd0b35fa0b0c)

    2021-07-10T00:39:24.715583  /lava-4168522/1/../bin/lava-test-case<8>[  =
 11.589572] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-07-10T00:39:24.716213     =

 =20
