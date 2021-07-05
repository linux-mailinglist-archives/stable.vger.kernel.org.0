Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA9643BBCFB
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 14:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbhGEMrj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 08:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbhGEMrj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Jul 2021 08:47:39 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B072C061574
        for <stable@vger.kernel.org>; Mon,  5 Jul 2021 05:45:02 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id v13so10192216ple.9
        for <stable@vger.kernel.org>; Mon, 05 Jul 2021 05:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=678ivOZo+ktuJDWMg9N98//WotZGsKIv4H4itzOu7/4=;
        b=o0pkBQmsGuMEY5wzTB71LoKVli9ztWyiwEriKwaMelRGrxM77RQ2Lo6t9dlPKr8QyC
         fBY0Dp71N5xy+Bi8eR1ALI0mpfXFEuXVjY/a2zzBUFPWSdOgPyiInJH01daFsiwFdN90
         qDbo2LOXKt50fZqrDWig5CdEj08H2VPnPQHNNBNGUZdGUb2ZXTx2drAOgzIiV06gaDgj
         IPUdnYDuTA/DnmVFn2Id2EdGUNq7r/ouuoEzunvvdx5wAsRT+pBEm7myppC2fI17XE1Y
         ec0bwQky7HkDRqc2p1LQJvGbjLXE+2OM28ou8woZgl28UOzlwbaF9RwRbsAeG5Zt2mqD
         02ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=678ivOZo+ktuJDWMg9N98//WotZGsKIv4H4itzOu7/4=;
        b=dAPnYK7CBd0nFQQ7WJuxTAoGz8W9jloPuTXbshrHU0hMzwJml2LxRK9ifOnKLii5f3
         rJse1Irv7UJpmzLG0GQwRY2xa2P8uzVTzXeMyYnxROGSxJePZntln1nWSg8c37hgZqW0
         AIRCplP5RgxOKlp8MZBnaWsZ5drKeg0kP4OxjoxhT08krWWEFY6ySSPI+gl8QCw8bWhu
         8cbAi8IrtAdqR6Zc0klPEPMtAg4zVkv4FvieZT0OFmIEsEklgJtb7frSvu6P+/U8MsMt
         pDKchHCErQCfVZD6RGabBnZPTLSyGmHvtsMOtjYUxWK+FgVUe7hOpbpdniQg0BycdjDT
         D+tw==
X-Gm-Message-State: AOAM532gtyx7iP/aXuOQ2J0hyKg/SS9NFEdoq1MVvT0IHXclUV91zfuF
        4xqzlMmF2oBQ2Xq/gWBnbI2ojKGC2W8PMxqN
X-Google-Smtp-Source: ABdhPJyx4YTUjrh2ujV1NwFV3aujkdmJSOHTFQTMOMPUT383+01UcoD2zpEda5bgNNkz6qMbPzTgRg==
X-Received: by 2002:a17:90b:1e02:: with SMTP id pg2mr5580432pjb.189.1625489101834;
        Mon, 05 Jul 2021 05:45:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g3sm20896428pjl.17.2021.07.05.05.45.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 05:45:01 -0700 (PDT)
Message-ID: <60e2fecd.1c69fb81.59482.ec4f@mx.google.com>
Date:   Mon, 05 Jul 2021 05:45:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.12.14-5-gb49b7dd97218
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.12
Subject: stable-rc/queue/5.12 baseline: 182 runs,
 6 regressions (v5.12.14-5-gb49b7dd97218)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 182 runs, 6 regressions (v5.12.14-5-gb49b7dd=
97218)

Regressions Summary
-------------------

platform            | arch  | lab           | compiler | defconfig         =
 | regressions
--------------------+-------+---------------+----------+-------------------=
-+------------
hip07-d05           | arm64 | lab-collabora | gcc-8    | defconfig         =
 | 1          =

imx8mp-evk          | arm64 | lab-nxp       | gcc-8    | defconfig         =
 | 1          =

r8a77950-salvator-x | arm64 | lab-baylibre  | gcc-8    | defconfig         =
 | 1          =

rk3288-veyron-jaq   | arm   | lab-collabora | gcc-8    | multi_v7_defconfig=
 | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.14-5-gb49b7dd97218/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.14-5-gb49b7dd97218
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b49b7dd972189373f5812bf67adbccc66c399b50 =



Test Regressions
---------------- =



platform            | arch  | lab           | compiler | defconfig         =
 | regressions
--------------------+-------+---------------+----------+-------------------=
-+------------
hip07-d05           | arm64 | lab-collabora | gcc-8    | defconfig         =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60e2d22378ef6387fb11799a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.14-=
5-gb49b7dd97218/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.14-=
5-gb49b7dd97218/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e2d22378ef6387fb117=
99b
        failing since 3 days (last pass: v5.12.13-109-g5add6842f3ea, first =
fail: v5.12.13-109-g47e1fda87919) =

 =



platform            | arch  | lab           | compiler | defconfig         =
 | regressions
--------------------+-------+---------------+----------+-------------------=
-+------------
imx8mp-evk          | arm64 | lab-nxp       | gcc-8    | defconfig         =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60e2ce190da8254e0e117995

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.14-=
5-gb49b7dd97218/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.14-=
5-gb49b7dd97218/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e2ce190da8254e0e117=
996
        failing since 0 day (last pass: v5.12.13-109-g47e1fda87919, first f=
ail: v5.12.14-5-g0029a8b67c08) =

 =



platform            | arch  | lab           | compiler | defconfig         =
 | regressions
--------------------+-------+---------------+----------+-------------------=
-+------------
r8a77950-salvator-x | arm64 | lab-baylibre  | gcc-8    | defconfig         =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60e2cd375166fda25c11797f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.14-=
5-gb49b7dd97218/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-salvat=
or-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.14-=
5-gb49b7dd97218/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-salvat=
or-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e2cd375166fda25c117=
980
        new failure (last pass: v5.12.14-5-g0029a8b67c08) =

 =



platform            | arch  | lab           | compiler | defconfig         =
 | regressions
--------------------+-------+---------------+----------+-------------------=
-+------------
rk3288-veyron-jaq   | arm   | lab-collabora | gcc-8    | multi_v7_defconfig=
 | 3          =


  Details:     https://kernelci.org/test/plan/id/60e2d32e5d0d41fb1f117970

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.14-=
5-gb49b7dd97218/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.14-=
5-gb49b7dd97218/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60e2d32f5d0d41fb1f117988
        failing since 20 days (last pass: v5.12.10-48-g5e97c6651365, first =
fail: v5.12.10-173-gfd0b35fa0b0c)

    2021-07-05T09:38:35.285133  /lava-4140330/1/../bin/lava-test-case
    2021-07-05T09:38:35.290226  <8>[   13.312927] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60e2d32f5d0d41fb1f1179a0
        failing since 20 days (last pass: v5.12.10-48-g5e97c6651365, first =
fail: v5.12.10-173-gfd0b35fa0b0c)

    2021-07-05T09:38:33.855088  /lava-4140330/1/../bin/lava-test-case
    2021-07-05T09:38:33.860514  <8>[   11.883415] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60e2d32f5d0d41fb1f1179a1
        failing since 20 days (last pass: v5.12.10-48-g5e97c6651365, first =
fail: v5.12.10-173-gfd0b35fa0b0c)

    2021-07-05T09:38:32.837177  /lava-4140330/1/../bin/lava-test-case<8>[  =
 10.863526] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-07-05T09:38:32.837482     =

 =20
