Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2C693DCB4D
	for <lists+stable@lfdr.de>; Sun,  1 Aug 2021 13:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbhHALIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Aug 2021 07:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231461AbhHALIQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Aug 2021 07:08:16 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5F0DC06175F
        for <stable@vger.kernel.org>; Sun,  1 Aug 2021 04:08:07 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id mz5-20020a17090b3785b0290176ecf64922so27424849pjb.3
        for <stable@vger.kernel.org>; Sun, 01 Aug 2021 04:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=n4mQnORU3Ege2QLpHQ6xFBTPLCMEW9Du5eVB/Q4Vaa4=;
        b=By9YsLdZanGjn6lnM7MO50N0iCkzQjHRidTO4v6oNeTUvvF7PGnnUSRgFn7AHS5WHv
         hQGs+T5J82lmOsyvrU3EfdU8RWFfrB/8RVv4gNmHyZNy2prltWj0QB1ewQxVDxbwkmfg
         t4/T1HcMFsuD4ucIA/7gQleWAI5nmVSho12bztp6FGoiHuGbftt8V0q95MGfx5cmthzg
         hGA2RVoZmA1I52Dr/TN0wazRkB5gJ8gyUdIZApK/n2nuP2j8Bs0A/gMSvSLA8spEsCxO
         DS9Gdp5v9TZNXPNcdUxXnyDEbv1LP/517bvRCW4+cYQ6okTciIPu3p8RLscQaZXMxQlp
         u4eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=n4mQnORU3Ege2QLpHQ6xFBTPLCMEW9Du5eVB/Q4Vaa4=;
        b=Uh65TqypbAvLl6i1LS6OlP6KrN4VAKd0vO754gD8lji8ZRAbSwv4iURdMWP1yIkdEJ
         cVkxEPzCDlYfpEbFRp9fjCycpSM7WXZL2t7Y6aCvJj5np4xfsmFHnd0Kylbq81nUvOtQ
         649T5EnELmcVP5IHzQ3703nEMHSNKmSZmj5qJBPH9za59UHYt6dxKgD4JMhSWNSY5rqn
         ubIGKQEhOLLo7yhLMhCPPiOC5QPcmpQ9nG9Nu1WsQYx3axzL4a4SBFr60i/LHgQtB+xd
         DZxjKbndolnizHYdc292pY2Sw9OLOlRqK9tNlAvOmyAoqftJGO96Uy1+AoMabZNZEDyV
         FPQg==
X-Gm-Message-State: AOAM533glGyELISsPPV52ostsbzHPRVbQsm/lInuS+WMcfKDyrlbpzYt
        OBvD1ehZfIxq4wCxu3ovqD5Qj2fLMaoOLVC9
X-Google-Smtp-Source: ABdhPJw2GxLE/aNaICLi3rzAfWLhWQBzYJf3lbyY6Q2AfI8eV0zQFm8U2aZ6ZTYpFw/U0fLSQgWyRw==
X-Received: by 2002:a17:902:f211:b029:12c:a7c7:a4d1 with SMTP id m17-20020a170902f211b029012ca7c7a4d1mr4126060plc.60.1627816087228;
        Sun, 01 Aug 2021 04:08:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m18sm7592453pjq.32.2021.08.01.04.08.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Aug 2021 04:08:06 -0700 (PDT)
Message-ID: <61068096.1c69fb81.67a08.53ea@mx.google.com>
Date:   Sun, 01 Aug 2021 04:08:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.55-57-gb2d53f9b52f5
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 197 runs,
 8 regressions (v5.10.55-57-gb2d53f9b52f5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 197 runs, 8 regressions (v5.10.55-57-gb2d53f=
9b52f5)

Regressions Summary
-------------------

platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre  | gcc-8    | bcm2835_defconfig  =
| 1          =

fsl-ls1028a-rdb    | arm64 | lab-nxp       | gcc-8    | defconfig          =
| 1          =

hip07-d05          | arm64 | lab-collabora | gcc-8    | defconfig          =
| 1          =

imx6q-sabresd      | arm   | lab-nxp       | gcc-8    | multi_v7_defconfig =
| 1          =

imx8mp-evk         | arm64 | lab-nxp       | gcc-8    | defconfig          =
| 1          =

rk3288-veyron-jaq  | arm   | lab-collabora | gcc-8    | multi_v7_defconfig =
| 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.55-57-gb2d53f9b52f5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.55-57-gb2d53f9b52f5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b2d53f9b52f518f23a98a2ceb823b6763adba09a =



Test Regressions
---------------- =



platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre  | gcc-8    | bcm2835_defconfig  =
| 1          =


  Details:     https://kernelci.org/test/plan/id/61064b4b16ac9296a185f4a0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.55-=
57-gb2d53f9b52f5/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.55-=
57-gb2d53f9b52f5/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61064b4b16ac9296a185f=
4a1
        new failure (last pass: v5.10.55-27-ge0b8a9439c81) =

 =



platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
fsl-ls1028a-rdb    | arm64 | lab-nxp       | gcc-8    | defconfig          =
| 1          =


  Details:     https://kernelci.org/test/plan/id/61064d11de0052f36a85f49b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.55-=
57-gb2d53f9b52f5/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls1028a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.55-=
57-gb2d53f9b52f5/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls1028a-rdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61064d11de0052f36a85f=
49c
        new failure (last pass: v5.10.55-27-ge0b8a9439c81) =

 =



platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
hip07-d05          | arm64 | lab-collabora | gcc-8    | defconfig          =
| 1          =


  Details:     https://kernelci.org/test/plan/id/61064becfae352acdb85f499

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.55-=
57-gb2d53f9b52f5/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.55-=
57-gb2d53f9b52f5/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61064becfae352acdb85f=
49a
        failing since 30 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
imx6q-sabresd      | arm   | lab-nxp       | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/61064c1caed9c1ddb985f4ad

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.55-=
57-gb2d53f9b52f5/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6q-sabres=
d.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.55-=
57-gb2d53f9b52f5/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6q-sabres=
d.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61064c1caed9c1ddb985f=
4ae
        new failure (last pass: v5.10.55-27-ge0b8a9439c81) =

 =



platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
imx8mp-evk         | arm64 | lab-nxp       | gcc-8    | defconfig          =
| 1          =


  Details:     https://kernelci.org/test/plan/id/61064cf8de0052f36a85f465

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.55-=
57-gb2d53f9b52f5/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.55-=
57-gb2d53f9b52f5/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61064cf8de0052f36a85f=
466
        failing since 0 day (last pass: v5.10.54-2-g41c54732efb5, first fai=
l: v5.10.55-27-ge0b8a9439c81) =

 =



platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
rk3288-veyron-jaq  | arm   | lab-collabora | gcc-8    | multi_v7_defconfig =
| 3          =


  Details:     https://kernelci.org/test/plan/id/61066cf7392bbb622085f465

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.55-=
57-gb2d53f9b52f5/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.55-=
57-gb2d53f9b52f5/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/61066cf7392bbb622085f479
        failing since 47 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-01T09:44:01.710803  /lava-4299070/1/../bin/lava-test-case
    2021-08-01T09:44:01.728078  <8>[   13.264298] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-08-01T09:44:01.728614  /lava-4299070/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/61066cf7392bbb622085f490
        failing since 47 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-01T09:44:00.281793  /lava-4299070/1/../bin/lava-test-case
    2021-08-01T09:44:00.300254  <8>[   11.835836] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-08-01T09:44:00.300783  /lava-4299070/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/61066cf7392bbb622085f491
        failing since 47 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-01T09:43:59.263715  /lava-4299070/1/../bin/lava-test-case
    2021-08-01T09:43:59.268452  <8>[   10.816264] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
