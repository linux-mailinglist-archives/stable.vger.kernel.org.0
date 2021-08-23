Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3AC3F52C2
	for <lists+stable@lfdr.de>; Mon, 23 Aug 2021 23:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232710AbhHWVV3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 17:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232908AbhHWVVT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Aug 2021 17:21:19 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9820C061757
        for <stable@vger.kernel.org>; Mon, 23 Aug 2021 14:20:36 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id x16so16492361pfh.2
        for <stable@vger.kernel.org>; Mon, 23 Aug 2021 14:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=s9aRfCMA9JPuGdWwg1TLlDAc1vX3kMpxGY2LeLx2utc=;
        b=Ui44lUYkduqiRoFsUuxUQWZ8AygNFQ//hxAgVzjC8hgs7SGxcxw458Y1ruDLdbdNhk
         VAQmvLgu3UhDEPWbFDRBc8jAqic0ZFcXfMCz0ho+NOBPVQoWYEl9GQU0P7ORM+Ny3Gi8
         Xyqud7sB1ImxgrN9lMB3CZZHRLC39MGbx+z4fwx9G52HhYJUCQMvBLHxmPeTNOPNdj6f
         F/nqwtp7tOG7D2PmRiCUc1z5NxaL98YDsQgu5hUifwbtxfsJ2a7MjL+hpJzFC5x9IBjd
         Q4fAnFny0KgNCjMHdlxc3RcOSoNdZTu41OpjnZ66N2xKIlBAYwLCYxSJyP0iSHQe+5vy
         YqGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=s9aRfCMA9JPuGdWwg1TLlDAc1vX3kMpxGY2LeLx2utc=;
        b=Pye6qHLhNxdgLCnSdgPukT0ac8rKJVbMXO2rgIiVIed6oNblevjD+51StDuSGpCvd2
         68pb68GtTuUcPjZBV1LESODy+tCyWo+fcWNSvMWu2FxczCUYnMUVrf5VF8FCUXU0gnvc
         1XxkPavol9jDeMXfL8nJgmnOEVqlyrfaidPeJsOYm+JbABVvJqOLHSahqg9ngWMfBdHB
         Oc1vVnqPOtIWtAAuqO8gI+EI1OsHrghY72yVX/u01LY2vmhUCrfxvHU8/BLNN5jjQ+uZ
         hVaDsVlqfnoileu5GA1tWtzaAZXxrTD3gRQgjCSAs4A/dqXpFkxBXJN/ZAXho+9ViTN9
         86jQ==
X-Gm-Message-State: AOAM530tv1BpxxeUd57D8qfJeS0QdVK+WTOAuN6ZCno2GKBF1uUxWgUL
        zjP6BDXb4owRNwyeVZNJ4dfbbur2/qYVGtht
X-Google-Smtp-Source: ABdhPJwsb3r6FRvpaY5jE5ixgMrVY+hpn2rE3NTuhOSp29lZB4VREMFDJA2B7VDuS32Kb0CV1srePQ==
X-Received: by 2002:a62:e308:0:b0:3e1:4077:4fbd with SMTP id g8-20020a62e308000000b003e140774fbdmr35917293pfh.51.1629753636358;
        Mon, 23 Aug 2021 14:20:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n10sm181339pjp.3.2021.08.23.14.20.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 14:20:36 -0700 (PDT)
Message-ID: <61241124.1c69fb81.2cae6.0e77@mx.google.com>
Date:   Mon, 23 Aug 2021 14:20:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.60-72-g2ab13f40f28a
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 208 runs,
 5 regressions (v5.10.60-72-g2ab13f40f28a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 208 runs, 5 regressions (v5.10.60-72-g2ab13f=
40f28a)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
fsl-ls1043a-rdb   | arm64 | lab-nxp       | gcc-8    | defconfig          |=
 1          =

hip07-d05         | arm64 | lab-collabora | gcc-8    | defconfig          |=
 1          =

rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.60-72-g2ab13f40f28a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.60-72-g2ab13f40f28a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2ab13f40f28ac2583b53dd9f59cde4b70803fb00 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
fsl-ls1043a-rdb   | arm64 | lab-nxp       | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6123e3d0d32992fe028e2caa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
72-g2ab13f40f28a/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls1043a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
72-g2ab13f40f28a/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls1043a-rdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6123e3d0d32992fe028e2=
cab
        new failure (last pass: v5.10.60-33-g1da01150ea2b) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
hip07-d05         | arm64 | lab-collabora | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6124088234c2902e688e2c91

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
72-g2ab13f40f28a/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
72-g2ab13f40f28a/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6124088234c2902e688e2=
c92
        failing since 53 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/6123fa62c89412e3148e2c92

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
72-g2ab13f40f28a/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
72-g2ab13f40f28a/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6123fa62c89412e3148e2ca6
        failing since 69 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-23T19:43:18.527927  /lava-4400912/1/../bin/lava-test-case
    2021-08-23T19:43:18.545591  <8>[   13.469038] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-08-23T19:43:18.545963  /lava-4400912/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6123fa62c89412e3148e2cbc
        failing since 69 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-23T19:43:16.080512  /lava-4400912/1/../bin/lava-test-case
    2021-08-23T19:43:16.085816  <8>[   11.020826] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6123fa63c89412e3148e2cd6
        failing since 69 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-23T19:43:17.099053  /lava-4400912/1/../bin/lava-test-case
    2021-08-23T19:43:17.104314  <8>[   12.040781] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =

 =20
