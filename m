Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 536963ADD77
	for <lists+stable@lfdr.de>; Sun, 20 Jun 2021 09:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbhFTHtC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Jun 2021 03:49:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbhFTHtC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Jun 2021 03:49:02 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0823C061574
        for <stable@vger.kernel.org>; Sun, 20 Jun 2021 00:46:50 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id f10so4727395plg.0
        for <stable@vger.kernel.org>; Sun, 20 Jun 2021 00:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=w0FgJ7OJWmOiNkUKkDLLwFn9w5jLkE9hYOgPBR5cZ54=;
        b=FRt6M9uDs+zzzBUVQcRk+A9kspsWBG/CnfBO3/OIv4BSM4P/FZ042toHrP5UEjPYpY
         T33tE2uGUxnsDMMmxTESe96V3pXUGERq55OnElPdxFEyD+Ee99YysSyiy6Q5OBsoQUrS
         vWf/l3f7UXbwmTqs3M5g2Kh0mtKDVgw3e3lxVh9UEbO4zq7vLohcHY64zU/C4XY4mNwC
         LhlxwScwoOgIZPfghAnIdkgF0xChj2cWddPoZ9p4IGUX4O8UNK0wTECAgq3k5sI0Eahb
         DwJrUEgoqFpj6Tz8cO7MEjbTMJoxU0rtTVH6S4Q2yJYd4wlbKYLl3xMlMYkSaohsBs15
         b6+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=w0FgJ7OJWmOiNkUKkDLLwFn9w5jLkE9hYOgPBR5cZ54=;
        b=NOsqGG5YSrIvAcuR9zHGQ8kjKGTLMGqkA/PN/jnrpPSJfgg6qUn+GeYrcNS6n0fjRN
         sCBkKICJZnt74dRi3Bq/jkIRpFVWDxAtw8t6K3KjhaYJax5pIj2LyIT6zf7I0uqwULMO
         qhAgTA8LLsjrr8vt5YOCrvA8x6f43tv/81TWIe6sIL90MiA/iRJKnKnubLSNQpSgKRUP
         QvezVyNuV6CAyY8cInEjqDP1WxjmQ6xXnx1XB7+HhUJqAB9FVS3AG+jf/ggTrlwvejbq
         3vsdOXSsvroW+N1sETEma/j1iK3okJWgNF+Bi0oZp/haqRJTuHDzjUXID89ee4dxF2tz
         boCA==
X-Gm-Message-State: AOAM533CCqfTrzrOL55XucDM74GZXZptZiYyHDasT0TRE9BbRzuWdzfA
        gImKRMSoeflXRtQ0Zwgpi+o9YlDx4U942ACz
X-Google-Smtp-Source: ABdhPJyl0TU9ET8y2li4z7K23M8MbrMyXTuxE0HnKvQKLpNYDOh1u7bHnCm6959xWfqaTY3H9qyIUA==
X-Received: by 2002:a17:90b:4b88:: with SMTP id lr8mr20176876pjb.85.1624175209903;
        Sun, 20 Jun 2021 00:46:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n5sm7538324pfv.159.2021.06.20.00.46.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Jun 2021 00:46:49 -0700 (PDT)
Message-ID: <60cef269.1c69fb81.d9aff.5193@mx.google.com>
Date:   Sun, 20 Jun 2021 00:46:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.237-40-g4f795ed121c3
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 156 runs,
 5 regressions (v4.14.237-40-g4f795ed121c3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 156 runs, 5 regressions (v4.14.237-40-g4f795=
ed121c3)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
bcm2837-rpi-3-b   | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =

meson-gxm-q200    | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =

rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.237-40-g4f795ed121c3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.237-40-g4f795ed121c3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4f795ed121c365d4e69a55f1b1e25fafc75e5a8d =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
bcm2837-rpi-3-b   | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60cec23fa236b7dbf5413274

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.237=
-40-g4f795ed121c3/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.237=
-40-g4f795ed121c3/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60cec23fa236b7dbf5413=
275
        new failure (last pass: v4.14.237-21-gf8ebb3accc92) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
meson-gxm-q200    | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60cec45d08bff219d341327a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.237=
-40-g4f795ed121c3/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.237=
-40-g4f795ed121c3/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60cec45d08bff219d3413=
27b
        failing since 110 days (last pass: v4.14.222-11-g13b8482a0f700, fir=
st fail: v4.14.222-120-gdc8887cba23e) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/60cec49b75f89bdf4e4132e8

  Results:     62 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.237=
-40-g4f795ed121c3/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.237=
-40-g4f795ed121c3/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60cec49b75f89bdf4e413304
        failing since 4 days (last pass: v4.14.236-20-gdb14655bb4bf, first =
fail: v4.14.236-49-gfd4c319f2583)

    2021-06-20T04:31:13.881122  /lava-4062746/1/../bin/lava-test-case
    2021-06-20T04:31:13.886250  [   13.583879] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60cec49b75f89bdf4e413305
        failing since 4 days (last pass: v4.14.236-20-gdb14655bb4bf, first =
fail: v4.14.236-49-gfd4c319f2583)

    2021-06-20T04:31:14.899611  /lava-4062746/1/../bin/lava-test-case
    2021-06-20T04:31:14.917681  [   14.602851] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-06-20T04:31:14.918112  /lava-4062746/1/../bin/lava-test-case   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60cec49b75f89bdf4e41331e
        failing since 4 days (last pass: v4.14.236-20-gdb14655bb4bf, first =
fail: v4.14.236-49-gfd4c319f2583)

    2021-06-20T04:31:17.330707  /lava-4062746/1/../bin/lava-test-case
    2021-06-20T04:31:17.348405  [   17.033718] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-06-20T04:31:17.348966  /lava-4062746/1/../bin/lava-test-case   =

 =20
