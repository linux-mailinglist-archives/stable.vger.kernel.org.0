Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90EFD400BE8
	for <lists+stable@lfdr.de>; Sat,  4 Sep 2021 17:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236830AbhIDPaG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Sep 2021 11:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbhIDPaF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Sep 2021 11:30:05 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 073C5C061575
        for <stable@vger.kernel.org>; Sat,  4 Sep 2021 08:29:04 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id 7so1935555pfl.10
        for <stable@vger.kernel.org>; Sat, 04 Sep 2021 08:29:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=H6o7VrtdP1M86Fg0TY7iyIh/JiggB5chdJIKHQrbkrw=;
        b=gzBBYNGOfLlx63qe2jkSe6Mc2DJAoMes+aS/FOVP4AvG+bndWvk1mj4NhTppNFeU/L
         j/uKTHPKYAfSXgZjNi+WNOIGDbMj1PfuOSknuNpWRLDLNJ2zh/yOdfd3YM5aTq1dYeI+
         zqF63AnBBplwDvnnKrgaCAaQBosKaUWI/pZuhb+3CJu0ar2WQq1p40+1dtIR9zgk/6xm
         8F0RH+DXhraMFNL6zTsLr9JNOpVG9tPmk9edIsktQga75SegeXHEqL1J61fbKo17GLAz
         AgQFMTdhOjw/9Gul0zAm6nkA5rD6ya1UczM4mZeFKcSDgbprDcUWzgkmvrEVscT5IaGX
         y1mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=H6o7VrtdP1M86Fg0TY7iyIh/JiggB5chdJIKHQrbkrw=;
        b=NZlcU1f7hSStIeLbFAT7D6igPZcrAw35HXlZLlW9W/n21KKWYs4Xyr/RZgzBrh8Moq
         LEBXIzcbfIkv/U4OvHmR1b/3T2I62rcO2gh9c57x6QXWosvuSwtOY1lsBpiFZ/2CF//p
         iamDmQuw7WRSHVLH0MrY4Tnyc3KBpDCRQAZgMf3uUiZQEQAcV4cmCE3kTrpZR/OLWOeR
         shFbCLgyiviEplSuamt988YuKFwO754BEPotTXwZLRQ64lsawE4FfM7BVe9jQpKL4fiI
         /EmcMHP1QfVb3oZA3kvHlHlkB7RmkQXkaoxRZx6dUdPoinJajo/QWSxjcpHwwoxyCgBk
         xV7Q==
X-Gm-Message-State: AOAM533YOzq1N04RtWDTsG5crHHJOKQHgK1RDoBqG+qqYrA3BU3WycOt
        H3jY4p6al0H68ZCut+tgkap4d1u2TpILGxzv
X-Google-Smtp-Source: ABdhPJzelxDGmaH++PVThT0vro3F/pnSev6NXR2mRWIRATOnUp0Rt2t6M50GZWRbr5+2sb8kgGAQtA==
X-Received: by 2002:a62:61c1:0:b0:414:5e28:d8 with SMTP id v184-20020a6261c1000000b004145e2800d8mr1494375pfb.45.1630769343197;
        Sat, 04 Sep 2021 08:29:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b69sm2746516pfb.64.2021.09.04.08.29.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Sep 2021 08:29:02 -0700 (PDT)
Message-ID: <613390be.1c69fb81.1ecbe.76d7@mx.google.com>
Date:   Sat, 04 Sep 2021 08:29:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.62-9-ge3bb5116f2af
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 195 runs,
 8 regressions (v5.10.62-9-ge3bb5116f2af)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 195 runs, 8 regressions (v5.10.62-9-ge3bb511=
6f2af)

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

sun50i-a64-bananapi-m64  | arm64 | lab-clabbe    | gcc-8    | defconfig    =
      | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.62-9-ge3bb5116f2af/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.62-9-ge3bb5116f2af
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e3bb5116f2af4931e9b23729dedf7547f84ebf54 =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
hip07-d05                | arm64 | lab-collabora | gcc-8    | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/613362438f1412859ed5968b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.62-=
9-ge3bb5116f2af/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.62-=
9-ge3bb5116f2af/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613362438f1412859ed59=
68c
        failing since 65 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
imx6q-var-dt6customboard | arm   | lab-baylibre  | gcc-8    | multi_v7_defc=
onfig | 2          =


  Details:     https://kernelci.org/test/plan/id/61335e71c20881c81fd5969d

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.62-=
9-ge3bb5116f2af/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-va=
r-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.62-=
9-ge3bb5116f2af/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-va=
r-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/61335e71c20881c=
81fd596a4
        new failure (last pass: v5.10.62-8-g7b314af003ef)
        4 lines

    2021-09-04T11:53:58.175521  kern  :alert : 8<--- cut here ---
    2021-09-04T11:53:58.175934  kern  :alert : Unhandled fault: alignment e=
xception (0x001) at 0xcec60217
    2021-09-04T11:53:58.176483  kern  :alert : pgd =3D (ptrval)
    2021-09-04T11:53:58.177016  kern  :alert : [<8>[   39.561554] <LAVA_SIG=
NAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=
=3D4>
    2021-09-04T11:53:58.177286  cec60217] *pgd=3D1ec1141e(bad)   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61335e71c20881c=
81fd596a5
        new failure (last pass: v5.10.62-8-g7b314af003ef)
        26 lines

    2021-09-04T11:53:58.227508  kern  :emerg : Internal error: : 1 [#1] SMP=
 ARM
    2021-09-04T11:53:58.227847  kern  :emerg : Process kworker/0:4 (pid: 54=
, stack limit =3D 0x(ptrval))
    2021-09-04T11:53:58.228375  kern  :emerg : Stack: (0xc2419eb0 to<8>[   =
39.607753] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=
=3Dlines MEASUREMENT=3D26>
    2021-09-04T11:53:58.228652   0xc241a000)
    2021-09-04T11:53:58.228904  kern  :emerg : 9ea0<8>[   39.619292] <LAVA_=
SIGNAL_ENDRUN 0_dmesg 797024_1.5.2.4.1>
    2021-09-04T11:53:58.229154  :                                     c3959=
840 cec6008f c3959894 cec60217   =

 =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
imx8mp-evk               | arm64 | lab-nxp       | gcc-8    | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/613361c62fb6aacc0fd596a4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.62-=
9-ge3bb5116f2af/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.62-=
9-ge3bb5116f2af/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613361c62fb6aacc0fd59=
6a5
        new failure (last pass: v5.10.62-8-g7b314af003ef) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
rk3288-veyron-jaq        | arm   | lab-collabora | gcc-8    | multi_v7_defc=
onfig | 3          =


  Details:     https://kernelci.org/test/plan/id/613364e9d6a2930c21d596a3

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.62-=
9-ge3bb5116f2af/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.62-=
9-ge3bb5116f2af/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/613364e9d6a2930c21d596b7
        failing since 81 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-09-04T12:21:38.897937  <6>[   12.667868] sbs-battery 20-000b: Disa=
bling PEC because of broken Cros-EC implementation
    2021-09-04T12:21:38.919994  <4>[   12.692860] sbs-battery 20-000b: Unkn=
own chemistry: POLY
    2021-09-04T12:21:38.942703  <4>[   12.716216] sbs-battery 20-000b: Unkn=
own chemistry: POLY
    2021-09-04T12:21:39.458946  <6>[   13.228875] sbs-battery 20-000b: Disa=
bling PEC because of broken Cros-EC implementation
    2021-09-04T12:21:39.491748  <4>[   13.264725] sbs-battery 20-000b: Unkn=
own chemistry: POLY
    2021-09-04T12:21:39.732876  /lava-4449661/1/../bin/lava-test-case
    2021-09-04T12:21:39.751330  <8>[   13.503729] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-09-04T12:21:39.751567  /lava-4449661/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/613364e9d6a2930c21d596cf
        failing since 81 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-09-04T12:21:37.271886  <4>[   11.043563] sbs-battery 20-000b: Unkn=
own chemistry: POLY
    2021-09-04T12:21:37.283883  <4>[   11.056796] sbs-battery 20-000b: Unkn=
own chemistry: POLY
    2021-09-04T12:21:37.786204  <6>[   11.556271] sbs-battery 20-000b: Disa=
bling PEC because of broken Cros-EC implementation
    2021-09-04T12:21:37.817858  <4>[   11.591223] sbs-battery 20-000b: Unkn=
own chemistry: POLY
    2021-09-04T12:21:38.261256  /lava-4449661/1/../bin/lava-test-case
    2021-09-04T12:21:38.278942  <8>[   12.032840] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-09-04T12:21:38.279173  /lava-4449661/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/613364e9d6a2930c21d596d0
        failing since 81 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-09-04T12:21:36.673752  <6>[   10.443505] sbs-battery 20-000b: Disa=
bling PEC because of broken Cros-EC implementation
    2021-09-04T12:21:36.709681  <4>[   10.483095] sbs-battery 20-000b: Unkn=
own chemistry: POLY
    2021-09-04T12:21:37.230044  /lava-4449661/1/../bin/lava-test-case
    2021-09-04T12:21:37.242338  <6>[   11.000174] sbs-battery 20-000b: Disa=
bling PEC because of broken Cros-EC implementation
    2021-09-04T12:21:37.242617  <8>[   11.000536] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
sun50i-a64-bananapi-m64  | arm64 | lab-clabbe    | gcc-8    | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/613360d21c281d28d9d596a6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.62-=
9-ge3bb5116f2af/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banana=
pi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.62-=
9-ge3bb5116f2af/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banana=
pi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613360d21c281d28d9d59=
6a7
        new failure (last pass: v5.10.62-8-g7b314af003ef) =

 =20
