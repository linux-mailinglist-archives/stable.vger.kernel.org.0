Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B20E3B4899
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 20:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbhFYSFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Jun 2021 14:05:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbhFYSF3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Jun 2021 14:05:29 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6AFDC061574
        for <stable@vger.kernel.org>; Fri, 25 Jun 2021 11:03:08 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id t9so8430231pgn.4
        for <stable@vger.kernel.org>; Fri, 25 Jun 2021 11:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PTJ715dzbs1xoTN1rV+uMFeCggqMQZRMKJsBufZv+7E=;
        b=Xtin5TVo264cqb9X3Bo8YgNDzlteVHxuNRpnorATM/cpuPVCQAJGi/lXUpmm1KZUiU
         0VktVNCaBng+E8IqrpNOAs3vy00n7KfQtL66rTQOhm77yuxARsJNRPrmeOEaorC3S29p
         mocKzWQzdCQAf3swDVh1nnWYcBB6/DOQPzNFdX5kcSV3fK2Y3VRweyLis/2ATIrkRCFy
         7mSck13Ip7rMh7x9lAHG4OhYyYi8PPvWJHCOkxwpj2Rid6M/hllx48HqtUxPpGuYLYPS
         Yb+qwxaLgiLLk+Izy8x7rSnAywJ6jGVzs/xDCSjzyNvOGJyicDVZ/YqgfHQkKGmcG49V
         CofQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PTJ715dzbs1xoTN1rV+uMFeCggqMQZRMKJsBufZv+7E=;
        b=J9AgYV0um/IEzteSB47/sbaGoDz7m3iUBar45G6303q6W5bTli3MbMLD9HTQPpCnSa
         g+Y8EktcQ1AkzelhAl8V06hqzfh4qM8P/XYYpr1Pol8gaWngrWykuNVgeTbd7EhtyrXR
         BYCDBqurB2FJy1itZkT89cO3CMFLeCi6YRasPrsMDPLrMTbrn8AaTas6npx0msQ9vE2a
         qIv8A/yckU7irRkxhaX8rzfXL+hMvNE6Ua5O4OcY00TMlFa1+DJ2iHoGaE9vlIHMTvWN
         /7oR59AhbAKpNuaPoyvnwdsaH4MtPhAWZYLzkvTcQR1oXSJAwfMq1hpvoTZIQt6fCPE8
         diPg==
X-Gm-Message-State: AOAM5300tA7UydzxLxaVHtRmfB/Yat7WsqcXhUFcLw++a5izPUt7nvWk
        Z2Av9NSxTzrcL6aJYvqn6BMkqmXs+AUKJOTk
X-Google-Smtp-Source: ABdhPJwB90tS5yZEptkiMonbZsnyUPDaMvTQi0IfwIU22YB9O4otMf50ZNaxVqukTYhtfrmAF1xOGQ==
X-Received: by 2002:a63:450e:: with SMTP id s14mr10584378pga.312.1624644188143;
        Fri, 25 Jun 2021 11:03:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 71sm6848765pfw.13.2021.06.25.11.03.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 11:03:07 -0700 (PDT)
Message-ID: <60d61a5b.1c69fb81.16b83.3033@mx.google.com>
Date:   Fri, 25 Jun 2021 11:03:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.46-13-g88b257611f2a
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.10.y baseline: 157 runs,
 5 regressions (v5.10.46-13-g88b257611f2a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 157 runs, 5 regressions (v5.10.46-13-g88b2=
57611f2a)

Regressions Summary
-------------------

platform                 | arch | lab           | compiler | defconfig     =
     | regressions
-------------------------+------+---------------+----------+---------------=
-----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre  | gcc-8    | multi_v7_defco=
nfig | 2          =

rk3288-veyron-jaq        | arm  | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.46-13-g88b257611f2a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.46-13-g88b257611f2a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      88b257611f2a985f74b6a788723711223439fbed =



Test Regressions
---------------- =



platform                 | arch | lab           | compiler | defconfig     =
     | regressions
-------------------------+------+---------------+----------+---------------=
-----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre  | gcc-8    | multi_v7_defco=
nfig | 2          =


  Details:     https://kernelci.org/test/plan/id/60d5e68706a45a4d5741329f

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
6-13-g88b257611f2a/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q=
-var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
6-13-g88b257611f2a/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q=
-var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/60d5e68706a45a4=
d574132a3
        new failure (last pass: v5.10.46)
        4 lines

    2021-06-25T14:21:49.245887  kern  :alert : 8<--- cut here ---
    2021-06-25T14:21:49.246395  kern  :alert : Unhandled fault: alignment e=
xception (0x001) at 0xcec60217
    2021-06-25T14:21:49.246638  kern  :alert : pgd =3D (ptrval)
    2021-06-25T14:21:49.247488  kern  :alert : [<8>[   39.405207] <LAVA_SIG=
NAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=
=3D4>
    2021-06-25T14:21:49.247756  cec60217] *pgd=3D1ec1141e(bad)   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60d5e68706a45a4=
d574132a4
        new failure (last pass: v5.10.46)
        26 lines

    2021-06-25T14:21:49.297510  kern  :emerg : Internal error: : 1 [#1] SMP=
 ARM
    2021-06-25T14:21:49.298017  kern  :emerg : Process kworker/0:3 (pid: 52=
, stack limit =3D 0x(ptrval))
    2021-06-25T14:21:49.298500  kern  :emerg : Stack: (0xc2401eb0 to<8>[   =
39.451348] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=
=3Dlines MEASUREMENT=3D26>
    2021-06-25T14:21:49.298740   0xc2402000)
    2021-06-25T14:21:49.298960  kern  :emerg : 1ea0<8>[   39.462924] <LAVA_=
SIGNAL_ENDRUN 0_dmesg 491893_1.5.2.4.1>
    2021-06-25T14:21:49.299174  :                                     1e9b1=
0fe 31a05607 c340ce80 cec60217   =

 =



platform                 | arch | lab           | compiler | defconfig     =
     | regressions
-------------------------+------+---------------+----------+---------------=
-----+------------
rk3288-veyron-jaq        | arm  | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =


  Details:     https://kernelci.org/test/plan/id/60d5ff1008bab9ac0d413267

  Results:     66 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
6-13-g88b257611f2a/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
6-13-g88b257611f2a/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60d5ff1008bab9ac0d413284
        failing since 10 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-06-25T16:06:32.213041  /lava-4095201/1/../bin/lava-test-case
    2021-06-25T16:06:32.218883  <8>[   11.875656] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60d5ff1008bab9ac0d413285
        failing since 10 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-06-25T16:06:33.231967  /lava-4095201/1/../bin/lava-test-case
    2021-06-25T16:06:33.249955  <8>[   12.895159] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60d5ff1008bab9ac0d41329d
        failing since 10 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-06-25T16:06:34.657930  /lava-4095201/1/../bin/lava-test-case
    2021-06-25T16:06:34.675434  <8>[   14.320818] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-06-25T16:06:34.675714  /lava-4095201/1/../bin/lava-test-case   =

 =20
