Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E97AF402EE7
	for <lists+stable@lfdr.de>; Tue,  7 Sep 2021 21:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233374AbhIGTTv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Sep 2021 15:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbhIGTTu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Sep 2021 15:19:50 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64155C061575
        for <stable@vger.kernel.org>; Tue,  7 Sep 2021 12:18:44 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id c6so43111pjv.1
        for <stable@vger.kernel.org>; Tue, 07 Sep 2021 12:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YBOeEDIrewGl2J+rVU6j9DzbF3UPUT96M3sxyJ4IxHc=;
        b=wLmMLkC5l7vKoEYtlGr6aHmJzWTv0HLzOP+VcTbAu0+9lP1tIaa7ZMzT4FXggP06U3
         yYBPrhky2x9c2qNdmRNPAlR1+3dP9rx9PNsU23sQvGsI0xGmaHatOlVtAalEop6HlIUC
         O/pC9dQOG3xAPsG4hRvbubH8s5K9aw67KAw0XxXqAKxcj7QB+KRJmnx9wfeXkLMOrMPw
         m+Y2wgiL9X13kqDhGZEzw24vLWCrnBnOI02nCYA6qDg9pVVeVJksxm1sZczHlV951gOO
         1oT3OoW+12tkn6MKvnGhVOXDl0K6a55XZwRlo6qwRdJRAn1EwQeYxegggSivN6cWG0dg
         pG4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YBOeEDIrewGl2J+rVU6j9DzbF3UPUT96M3sxyJ4IxHc=;
        b=CRixUv3yr+dUs6A13wYZjcYbDdFgMPF3qCClAi1lGKIO2lcHIXqHBKjFBzNXPmLZmr
         XAxNMh5JpJAzFwWpB3DWVTPMlCFGpOEJNfjfMqpHuOel6pNW5Axv9CzqvDpBO6rHY4VY
         V3LeCKNTqPxO+wzNhcZva9QhOiC8LoecWWhy66Hw03hPv8iyl45d+++lASf8UWvG6Ktb
         zlcK6TEHtgAOtCDRudgBN/FXGSqXXvQu01APcV1YaERD84KatQouDuaQ4etVn8SddKsO
         DNIb5LeQ0WqMSJz8Ls4OLFreXM8wkPCr4ZN0/sn5B39xIsBuuOV9oCx8atXgEEjNFvQp
         0cyg==
X-Gm-Message-State: AOAM530wg/Lc+3bBt40XRosuqERkRzFEPWF38MVG1UUINc06a/bc42E7
        TnTzmrP8+6kvNhJtlGogWCXowrGxoliHHomP
X-Google-Smtp-Source: ABdhPJxLJfghiSbhAMU07txixXt2xpk5O3Oc66KmYHP4pAWlF3DRFEd3/ct9X0AT9iLYPjp/WVy1dA==
X-Received: by 2002:a17:902:7e84:b0:13a:3396:1c04 with SMTP id z4-20020a1709027e8400b0013a33961c04mr4425771pla.84.1631042323607;
        Tue, 07 Sep 2021 12:18:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l11sm3289052pjg.22.2021.09.07.12.18.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 12:18:43 -0700 (PDT)
Message-ID: <6137bb13.1c69fb81.10ba.9f0c@mx.google.com>
Date:   Tue, 07 Sep 2021 12:18:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.62-29-g6ad2b8802513
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 228 runs,
 7 regressions (v5.10.62-29-g6ad2b8802513)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 228 runs, 7 regressions (v5.10.62-29-g6ad2b8=
802513)

Regressions Summary
-------------------

platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
hip07-d05                | arm64 | lab-collabora | gcc-8    | defconfig    =
      | 1          =

imx6q-var-dt6customboard | arm   | lab-baylibre  | gcc-8    | multi_v7_defc=
onfig | 2          =

imx8mp-evk               | arm64 | lab-nxp       | gcc-8    | defconfig    =
      | 1          =

rk3288-veyron-jaq        | arm   | lab-collabora | gcc-8    | multi_v7_defc=
onfig | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.62-29-g6ad2b8802513/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.62-29-g6ad2b8802513
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6ad2b880251399f9497c36b22865e73e02284013 =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
hip07-d05                | arm64 | lab-collabora | gcc-8    | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/61378b1c73abd94872d596cb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.62-=
29-g6ad2b8802513/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.62-=
29-g6ad2b8802513/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61378b1c73abd94872d59=
6cc
        failing since 68 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
imx6q-var-dt6customboard | arm   | lab-baylibre  | gcc-8    | multi_v7_defc=
onfig | 2          =


  Details:     https://kernelci.org/test/plan/id/6137862ebd98aaa925d596d5

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.62-=
29-g6ad2b8802513/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-v=
ar-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.62-=
29-g6ad2b8802513/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-v=
ar-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/6137862ebd98aaa=
925d596dc
        new failure (last pass: v5.10.62-29-gb20c77b1bdff)
        4 lines

    2021-09-07T15:32:50.746732  kern  :alert : 8<--- cut here ---
    2021-09-07T15:32:50.777671  kern  :alert : Unhandled fault: alignment e=
xception (0x001) at 0xcec60217
    2021-09-07T15:32:50.777943  kern  :alert : pgd =3D (ptrval)
    2021-09-07T15:32:50.779028  kern  :alert : [<8>[   42.568818] <LAVA_SIG=
NAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=
=3D4>
    2021-09-07T15:32:50.779295  cec60217] *pgd=3D1ec1141e(bad)   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6137862ebd98aaa=
925d596dd
        new failure (last pass: v5.10.62-29-gb20c77b1bdff)
        26 lines

    2021-09-07T15:32:50.829922  kern  :emerg : Internal error: : 1 [#1] SMP=
 ARM
    2021-09-07T15:32:50.830190  kern  :emerg : Process kworker/0:4 (pid: 54=
, stack limit =3D 0x(ptrval))
    2021-09-07T15:32:50.830665  kern  :emerg : Stack: (0xc2403eb0 to<8>[   =
42.615200] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=
=3Dlines MEASUREMENT=3D26>
    2021-09-07T15:32:50.830905   0xc2404000)
    2021-09-07T15:32:50.831123  kern  :emerg : 3ea0<8>[   42.626759] <LAVA_=
SIGNAL_ENDRUN 0_dmesg 806602_1.5.2.4.1>
    2021-09-07T15:32:50.831340  :                                     1e9b1=
0fe 31ece3b6 c2381880 cec60217   =

 =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
imx8mp-evk               | arm64 | lab-nxp       | gcc-8    | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/61378c38b22491b1dcd596d7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.62-=
29-g6ad2b8802513/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.62-=
29-g6ad2b8802513/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61378c38b22491b1dcd59=
6d8
        failing since 3 days (last pass: v5.10.62-8-g7b314af003ef, first fa=
il: v5.10.62-9-ge3bb5116f2af) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
rk3288-veyron-jaq        | arm   | lab-collabora | gcc-8    | multi_v7_defc=
onfig | 3          =


  Details:     https://kernelci.org/test/plan/id/61378d5328fb862213d59686

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.62-=
29-g6ad2b8802513/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.62-=
29-g6ad2b8802513/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/61378d5328fb862213d5969a
        failing since 84 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-09-07T16:03:21.985524  /lava-4467574/1/../bin/lava-test-case
    2021-09-07T16:03:22.002627  <8>[   13.257647] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-09-07T16:03:22.003131  /lava-4467574/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/61378d5328fb862213d596b1
        failing since 84 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-09-07T16:03:20.558536  /lava-4467574/1/../bin/lava-test-case
    2021-09-07T16:03:20.576308  <8>[   11.830909] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/61378d5328fb862213d596b2
        failing since 84 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-09-07T16:03:19.538580  /lava-4467574/1/../bin/lava-test-case
    2021-09-07T16:03:19.543853  <8>[   10.811136] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
