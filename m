Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 566B43FF4B8
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 22:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234548AbhIBUR7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 16:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbhIBUR7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Sep 2021 16:17:59 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC31CC061575
        for <stable@vger.kernel.org>; Thu,  2 Sep 2021 13:17:00 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id e7so3207564pgk.2
        for <stable@vger.kernel.org>; Thu, 02 Sep 2021 13:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rfFXQ2L3GI9J29ZZAtUvJzFo6zXD0ZHLS4gBb6+Mnrc=;
        b=KJ1PbrRxbGTYL07V/g5sIVf1sQz4Hg15fdJAHjtBdhP5+zS8wytnhJxZtF13o4KPuv
         pJZdiyEjBQNGet2d4aA0oDoiwSTjWAenvZQViIw41LP9vo6T1kCl7XpDQHdNiUa7u5Go
         MZwCdOc4aa1mek2ml88M7n3O8Gm+Q1pttJ85XkbssiTJTXCTC3yDh81FlWPjhXMhX5Vr
         TwsEO5QBzX3YLxVn0EE91XCxHBPDFwI+gGdj6APMxEUO8EaXhBI68Jjn+yOTtMULtXNa
         0ED6wWrWgoAeJqM5gi00qCHy5K4ZdEDjsviTO0M8UURWEPW0IbfQaaAPbzktf25pXV3r
         42EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rfFXQ2L3GI9J29ZZAtUvJzFo6zXD0ZHLS4gBb6+Mnrc=;
        b=lLPx5Ru5EMcWxJspc9RV1CtKy/2bwtjLoTm4mTN+scwzwrpH0S5jZK1A9HpNF05wkl
         eGrj6UKPp6Fs0OAG2Zubbr8h+WKPFRuA8MFQOarNcv/MLm8vO0CuKss0gUwslVav7d6R
         dRfscb+ys5ATypdjbM6G9KlgvV4IGtAl7lHZGOHySDDc64yNuC+gz5kxRgePu9B/UDdP
         qh6sYMLCC60cWoRAyYUMIA+JVR6D3M+4vdhyBT/llwW3CR7rWdfC1S35oUkkU2AwFdsu
         T4fWRVQPGv7+JJeoDgvt6qsZ3cwpdcGW8gD4mdHN/FZ0hkfgPfAcryDi3IxehgS6gq2L
         KMUw==
X-Gm-Message-State: AOAM533xYocbDwYRfRtLEY8vNc1VTVHl/GlBBwG+eZeoj932zPkDayqA
        NfszjYTZsAEkt6bQSmp15+kbTVzffofsPlFZ
X-Google-Smtp-Source: ABdhPJzyFxX9d4qJfF8NH8EMuG3PcHp3N9M1LHt59i2vrWgKATplWjWO8QDy3IQOP3QoN/am3z4Cww==
X-Received: by 2002:aa7:800b:0:b029:330:455f:57a8 with SMTP id j11-20020aa7800b0000b0290330455f57a8mr5032235pfi.7.1630613819948;
        Thu, 02 Sep 2021 13:16:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c9sm3663681pgq.58.2021.09.02.13.16.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 13:16:59 -0700 (PDT)
Message-ID: <6131313b.1c69fb81.e7956.9cf2@mx.google.com>
Date:   Thu, 02 Sep 2021 13:16:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.61-104-g67c4228ae810
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 93 runs,
 4 regressions (v5.10.61-104-g67c4228ae810)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 93 runs, 4 regressions (v5.10.61-104-g67c422=
8ae810)

Regressions Summary
-------------------

platform                 | arch | lab           | compiler | defconfig     =
     | regressions
-------------------------+------+---------------+----------+---------------=
-----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre  | gcc-8    | multi_v7_defco=
nfig | 1          =

rk3288-veyron-jaq        | arm  | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.61-104-g67c4228ae810/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.61-104-g67c4228ae810
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      67c4228ae810eaa1de44d81c072fc0725834b799 =



Test Regressions
---------------- =



platform                 | arch | lab           | compiler | defconfig     =
     | regressions
-------------------------+------+---------------+----------+---------------=
-----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre  | gcc-8    | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6130f700562f608e9ad59667

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.61-=
104-g67c4228ae810/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-=
var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.61-=
104-g67c4228ae810/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-=
var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6130f700562f608e9ad59=
668
        new failure (last pass: v5.10.61-104-g63d6d9cde5d2) =

 =



platform                 | arch | lab           | compiler | defconfig     =
     | regressions
-------------------------+------+---------------+----------+---------------=
-----+------------
rk3288-veyron-jaq        | arm  | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =


  Details:     https://kernelci.org/test/plan/id/6130f6eff97a380f7bd59683

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.61-=
104-g67c4228ae810/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.61-=
104-g67c4228ae810/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6130f6eff97a380f7bd59697
        failing since 79 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-09-02T16:07:53.395610  <6>[   12.527870] sbs-battery 20-000b: Disa=
bling PEC because of broken Cros-EC implementation
    2021-09-02T16:07:53.427552  <4>[   12.563570] sbs-battery 20-000b: Unkn=
own chemistry: POLY
    2021-09-02T16:07:53.963814  <6>[   13.095926] sbs-battery 20-000b: Disa=
bling PEC because of broken Cros-EC implementation
    2021-09-02T16:07:53.993977  <4>[   13.129100] sbs-battery 20-000b: Unkn=
own chemistry: POLY
    2021-09-02T16:07:54.001692  <4>[   13.132698] sbs-battery 20-000b: Unkn=
own chemistry: POLY
    2021-09-02T16:07:54.199800  /lava-4436178/1/../bin/lava-test-case
    2021-09-02T16:07:54.210406  <8>[   13.343727] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6130f6eff97a380f7bd596af
        failing since 79 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-09-02T16:07:51.736748  <6>[   10.870160] sbs-battery 20-000b: Disa=
bling PEC because of broken Cros-EC implementation
    2021-09-02T16:07:51.768609  <4>[   10.903527] sbs-battery 20-000b: Unkn=
own chemistry: POLY
    2021-09-02T16:07:51.779256  <4>[   10.907114] sbs-battery 20-000b: Unkn=
own chemistry: POLY
    2021-09-02T16:07:52.292386  <6>[   11.424053] sbs-battery 20-000b: Disa=
bling PEC because of broken Cros-EC implementation
    2021-09-02T16:07:52.321921  <4>[   11.457506] sbs-battery 20-000b: Unkn=
own chemistry: POLY
    2021-09-02T16:07:52.729909  /lava-4436178/1/../bin/lava-test-case
    2021-09-02T16:07:52.747979  <8>[   11.863011] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-09-02T16:07:52.748211  /lava-4436178/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6130f6eff97a380f7bd596b0
        failing since 79 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-09-02T16:07:51.181036  <6>[   10.312932] sbs-battery 20-000b: Disa=
bling PEC because of broken Cros-EC implementation
    2021-09-02T16:07:51.218588  <4>[   10.352222] sbs-battery 20-000b: Unkn=
own chemistry: POLY
    2021-09-02T16:07:51.710237  /lava-4436178/1/../bin/lava-test-case
    2021-09-02T16:07:51.715429  <8>[   10.843067] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
