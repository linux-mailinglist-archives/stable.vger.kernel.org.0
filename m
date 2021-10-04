Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0441B420575
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 06:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232494AbhJDErD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 00:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232388AbhJDErC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 00:47:02 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE2AC0613EC
        for <stable@vger.kernel.org>; Sun,  3 Oct 2021 21:45:14 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id s55so12350090pfw.4
        for <stable@vger.kernel.org>; Sun, 03 Oct 2021 21:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sZ2kg/S6tswAwf3QIgp8kfofI+GwSzopUxTscaft7xU=;
        b=cmO5duEHOQXSGFtd3Id+2FN/F68Db48w3IQVqe4x1KnUuD9/VodjbNVlzbuTW/ezt6
         u+R9vqmYoDUK/2lp4QjFyLhHEaxv0xuUxsCtELdHVf8tei1tBWd4fBVzNPW0M+e6sEQt
         8O5Cz+PIOZg+MMea1jZ/I6I6A5AdM8YhyB8Bzg+QjA1zhLfwN1KJmTdjyDmX6KkLh9+o
         BBcWT52KbWz7/h250BSEVVjSktJv46ZTLXWAGWNipAd3xXOo3hNY2oTwt61KoN+3rXN8
         QVvBDDqL2s+OZySXB4HjsdAVkU3WHxpwh/FT4gOIM0iCKR6ParPNQYlvnrjvdAoe0/Sb
         b3jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sZ2kg/S6tswAwf3QIgp8kfofI+GwSzopUxTscaft7xU=;
        b=cRHuFK2FoD2gyYnwDGwlbZR1BzZ1YyzZRZE52c/lV2JSiDoXVbrIg7oJUbwth4XO2R
         FLRYcB5RQKyW6DX2tJc/NupogU6zQvouUsC8P9piACxSN2eCSX7Icz2un0/ziPTUsf92
         Q1wctlsxMATxY6g9FpUMiAvSVSL0csYyCJg/u6zVz9vViYjHjvfnPrzE0jnm1Ek5N/Pb
         /eeRL9Nl5RlDw6ua3yBG5kRhsEmnLPWMbXpFcPb2BJg8EuWdY1n5+vJoHjtVdR7thOvM
         XFPT7Ie+HZZjX0u2YLUVNZl/9c6jBWCteBszRpidWK/kwE56cJxU8SRjT5HBG2AlK2SV
         axJA==
X-Gm-Message-State: AOAM532jHCwE9yV/pBAHR+ThnNnlZuCjTCrqzA6mPa7UzzCLiI69DchZ
        lksTJmDX3Jr0jFfN3GlAQKAO+stMkajyPPlw
X-Google-Smtp-Source: ABdhPJztoSEjF1a+hTS1JQebfgVxBUk5jaI6wiKQnCn/J7Wa+J+ysamf1fEjKqMBt7CrhgZmiineuQ==
X-Received: by 2002:a63:7010:: with SMTP id l16mr9134542pgc.32.1633322713815;
        Sun, 03 Oct 2021 21:45:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 3sm11574540pjk.18.2021.10.03.21.45.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Oct 2021 21:45:13 -0700 (PDT)
Message-ID: <615a86d9.1c69fb81.eb0d2.3000@mx.google.com>
Date:   Sun, 03 Oct 2021 21:45:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.70-25-g94756d80f44e
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 184 runs,
 7 regressions (v5.10.70-25-g94756d80f44e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 184 runs, 7 regressions (v5.10.70-25-g9475=
6d80f44e)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig     =
     | 1          =

imx6ull-14x14-evk       | arm   | lab-nxp       | gcc-8    | multi_v7_defco=
nfig | 1          =

imx8mp-evk              | arm64 | lab-nxp       | gcc-8    | defconfig     =
     | 1          =

rk3288-veyron-jaq       | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.70-25-g94756d80f44e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.70-25-g94756d80f44e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      94756d80f44e4b5f52455eeb7330c2e14e92b7ea =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/615a5077a2f95ed97999a317

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
0-25-g94756d80f44e/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
0-25-g94756d80f44e/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615a5077a2f95ed97999a=
318
        failing since 94 days (last pass: v5.10.46-101-ga41d5119dc1e, first=
 fail: v5.10.47) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
imx6ull-14x14-evk       | arm   | lab-nxp       | gcc-8    | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/615a4e9d15f6a0bb6b99a2fa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
0-25-g94756d80f44e/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ull-14=
x14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
0-25-g94756d80f44e/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ull-14=
x14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615a4e9d15f6a0bb6b99a=
2fb
        new failure (last pass: v5.10.65-55-g84286fd568e7) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
imx8mp-evk              | arm64 | lab-nxp       | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/615a50f5e038825f4a99a2ed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
0-25-g94756d80f44e/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
0-25-g94756d80f44e/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615a50f5e038825f4a99a=
2ee
        new failure (last pass: v5.10.67-125-gbb6d31464809) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
rk3288-veyron-jaq       | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =


  Details:     https://kernelci.org/test/plan/id/615a53a031bc19456799a2e4

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
0-25-g94756d80f44e/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
0-25-g94756d80f44e/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/615a53a031bc19456799a2f8
        failing since 110 days (last pass: v5.10.43, first fail: v5.10.43-1=
31-g3f05ff8b3370)

    2021-10-04T01:06:28.791332  /lava-4636287/1/../bin/lava-test-case
    2021-10-04T01:06:28.809414  <8>[   14.549230] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-10-04T01:06:28.809639  /lava-4636287/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/615a53a031bc19456799a310
        failing since 110 days (last pass: v5.10.43, first fail: v5.10.43-1=
31-g3f05ff8b3370)

    2021-10-04T01:06:27.367293  /lava-4636287/1/../bin/lava-test-case
    2021-10-04T01:06:27.384490  <8>[   13.124210] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-10-04T01:06:27.384694  /lava-4636287/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/615a53a031bc19456799a311
        failing since 110 days (last pass: v5.10.43, first fail: v5.10.43-1=
31-g3f05ff8b3370)

    2021-10-04T01:06:26.347365  /lava-4636287/1/../bin/lava-test-case
    2021-10-04T01:06:26.353170  <8>[   12.104826] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/615a4ff3fc8ba82dbe99a2ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
0-25-g94756d80f44e/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
0-25-g94756d80f44e/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615a4ff3fc8ba82dbe99a=
2ef
        new failure (last pass: v5.10.65-55-g84286fd568e7) =

 =20
