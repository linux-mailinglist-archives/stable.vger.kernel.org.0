Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 451163C93AC
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 00:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235410AbhGNWUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 18:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbhGNWUG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Jul 2021 18:20:06 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7899EC06175F
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 15:17:13 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id w15so3927723pgk.13
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 15:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AUScqkVIRxvRRo7CCG27k1QfPCYmgIEL43EHZ3T4VIQ=;
        b=Yo7m8MXhOVsOzTzQIgUPGB2pUAZozcn5cy59G+Yxg+bScYbrTPAW2K0+1BVLc1HkmW
         TB41SY53wclSQrGQY0+dYTSQK5ztub0tDx2wQes8L09uaR9hfcApC+kzr1uId+mYgTBc
         XiveJls2Jdf711p5qmxLdBq6oZyRAX+3940Y0ijkoATWSj/aPlgFwzhgom5KxWUUJNtf
         3WxUe3TAfGT059/hhoW22D7mXHXL967JRpJ1IX7zedM72a3eKDBCe2biDUsOC4Vzcuvc
         A4RfOfW4CWtumKIsHrtdpcob4wh8TrGx7XxueuZ1uXV36MJIxEHCsp9bPEoAsonyIrMs
         X0Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AUScqkVIRxvRRo7CCG27k1QfPCYmgIEL43EHZ3T4VIQ=;
        b=RMc4y7rrGhjUe1EKHh3kXMIv5e+8lQIaHXYsn7mkiExf38DFIGOXHV6ZOksRNcGM4K
         BANui3cHQldo4kUwUjhGyv6ikemAOSgiwRvC9CU5PVWeRW+XQKpzote1iHJFzyfZWrO3
         xgDGKiVjH//Fa0A0BEAtAeL/CW8Gtp1yF+8pjpkBL75oe4+1MpWBR61stXbcDr/S0l/T
         O0l6WF0yIJftLKMSOVTRRhBKo0SBK3c4Y3/Z0p7AMTAgF6RR7sAYREdCtcW+a6fBiBKU
         n4TSPNdSueqfgDSyERyDi85MmRLpTSamsob/nQqNN4ks47HCafd1l9p4goviUSscxS3N
         tI4g==
X-Gm-Message-State: AOAM533c8jSl2NUyjpc+DO/IdcJymfZSrli8csAcqcysFA7u74gjBg+O
        viM7pkW9des5QLcelK6D+AM6tOwvNdJz72au
X-Google-Smtp-Source: ABdhPJxhdUHJTpIKf36thpmgoFUDM0H+hnyGfjd/vSOa4myYxtYwhORNaugFVgzBUQFXvjgtQqy11Q==
X-Received: by 2002:a63:e205:: with SMTP id q5mr254723pgh.404.1626301032937;
        Wed, 14 Jul 2021 15:17:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 127sm4048622pfy.107.2021.07.14.15.17.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 15:17:12 -0700 (PDT)
Message-ID: <60ef6268.1c69fb81.b7242.cc4e@mx.google.com>
Date:   Wed, 14 Jul 2021 15:17:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.50
Subject: stable/linux-5.10.y baseline: 184 runs, 6 regressions (v5.10.50)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 184 runs, 6 regressions (v5.10.50)

Regressions Summary
-------------------

platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
hip07-d05                | arm64 | lab-collabora | gcc-8    | defconfig    =
      | 1          =

imx6q-var-dt6customboard | arm   | lab-baylibre  | gcc-8    | multi_v7_defc=
onfig | 1          =

imx8mp-evk               | arm64 | lab-nxp       | gcc-8    | defconfig    =
      | 1          =

rk3288-veyron-jaq        | arm   | lab-collabora | gcc-8    | multi_v7_defc=
onfig | 3          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.50/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.50
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      43b0742ef44c30f202afbf8355e9326710af9ca1 =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
hip07-d05                | arm64 | lab-collabora | gcc-8    | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/60ef3133c24c4ce4818a93a5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.50/a=
rm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.50/a=
rm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ef3133c24c4ce4818a9=
3a6
        failing since 7 days (last pass: v5.10.46, first fail: v5.10.48) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
imx6q-var-dt6customboard | arm   | lab-baylibre  | gcc-8    | multi_v7_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ef30e104ca2fb3e08a93b6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.50/a=
rm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-var-dt6customboard.=
txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.50/a=
rm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-var-dt6customboard.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ef30e104ca2fb3e08a9=
3b7
        new failure (last pass: v5.10.49) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
imx8mp-evk               | arm64 | lab-nxp       | gcc-8    | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/60ef2fbd2251a7a1ae8a93ea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.50/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.50/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ef2fbd2251a7a1ae8a9=
3eb
        failing since 7 days (last pass: v5.10.47, first fail: v5.10.48) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
rk3288-veyron-jaq        | arm   | lab-collabora | gcc-8    | multi_v7_defc=
onfig | 3          =


  Details:     https://kernelci.org/test/plan/id/60ef4189cc89963ae58a93a9

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.50/a=
rm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.50/a=
rm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60ef4189cc89963ae58a93c1
        failing since 28 days (last pass: v5.10.43, first fail: v5.10.44)

    2021-07-14T19:56:44.028580  /lava-4198529/1/../bin/lava-test-case
    2021-07-14T19:56:44.045910  <8>[   13.784582] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-07-14T19:56:44.046260  /lava-4198529/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60ef4189cc89963ae58a93d9
        failing since 28 days (last pass: v5.10.43, first fail: v5.10.44)

    2021-07-14T19:56:42.603663  /lava-4198529/1/../bin/lava-test-case
    2021-07-14T19:56:42.620938  <8>[   12.359335] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-07-14T19:56:42.621239  /lava-4198529/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60ef4189cc89963ae58a93da
        failing since 28 days (last pass: v5.10.43, first fail: v5.10.44)

    2021-07-14T19:56:41.590812  /lava-4198529/1/../bin/lava-test-case<8>[  =
 11.339875] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-07-14T19:56:41.591175     =

 =20
