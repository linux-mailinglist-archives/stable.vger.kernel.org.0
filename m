Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99ECE3C3EDE
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 21:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbhGKTf0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 15:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbhGKTfZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 15:35:25 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1690C0613DD
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 12:32:38 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id o3-20020a17090a6783b0290173ce472b8aso271396pjj.2
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 12:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VkanZ42nuaiDDia4iKG/MEVFeuDh+uMe39vNBFQT3q8=;
        b=BKRdN85EkK6vCvqr3NQOfqcd6790Z49bSuBv0lIprvk/oTUsuNUbi1GYq6LZQhUeaR
         Sj6maC3ozCFlD99v6X4pbQjLqyJQV1KrY4e+UELihzqQXllPm2D1HvSE/gMosi/Rd7AJ
         nE/clQ11qtFR4sHs6a9YgFU1TWfOuWVOsA1izglup48Zxg/FeHPtPSI+mmeenx9UClGi
         XR5yAX36b8Bb7cyd1Mo96upX7NSBpI54NGIzdVcKuO189GuiRw//ZlXSxhqyVy72C0vW
         w5ypyIke7dsw/r62mDKv2r8WHd04NjkNFXZTHPehwtKqBXjyOtWdaLv1FFXMjTBhWvIc
         Fc+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VkanZ42nuaiDDia4iKG/MEVFeuDh+uMe39vNBFQT3q8=;
        b=AYKRqoR52DGlnzpYlJzRBlTcbFsiWpSPzUSGRwDQa/DGnDpXho1YZhs4q962ZdjyZm
         epFK/H2Nyo0JHXguS2AIkOGzbyk1oNdupdLADpxr/cmoWFZdwYP4adOBpk9o5yx2xwPd
         Pa+hwwVwdkf6UtIVD4VFo5MRWMobRRTiZDCtmD9k/nbwrZvN+yzLBXxORlFacY3fBzCl
         m1NTlwwwH0EUv7W6fY5EDA+m0Y/wJpjW4UbeSl2zTSZ9gw/y1Xxyht1aUpllkUlMlglK
         lI2msWV0xceZrFkPyXotUmNqNbfnBAiK2E0nMmtzxtb6rptGeEeKnzYK+YD9lJW2FKvJ
         3gYQ==
X-Gm-Message-State: AOAM5325mVvsorhAQf+HBVcot3wuYDOK3dBOfragRD2fyEyTkObReWlL
        W1mLVSSRZYcLxlg+q2u3/CVOgQO/LZp+KiGe
X-Google-Smtp-Source: ABdhPJwmz3gE5AKJRiJjHPdKjRI3vCvQEL6NV3N7PXYIEvIcDc9eipZpY0w6E+iJueq46nFLlv/m6Q==
X-Received: by 2002:a17:90a:e7c4:: with SMTP id kb4mr10270416pjb.43.1626031957970;
        Sun, 11 Jul 2021 12:32:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g27sm14392284pgl.19.2021.07.11.12.32.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 12:32:37 -0700 (PDT)
Message-ID: <60eb4755.1c69fb81.6eb67.ad39@mx.google.com>
Date:   Sun, 11 Jul 2021 12:32:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.49
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 190 runs, 8 regressions (v5.10.49)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 190 runs, 8 regressions (v5.10.49)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
  | regressions
---------------------+-------+---------------+----------+------------------=
--+------------
hip07-d05            | arm64 | lab-collabora | gcc-8    | defconfig        =
  | 1          =

imx8mp-evk           | arm64 | lab-nxp       | gcc-8    | defconfig        =
  | 1          =

meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
  | 1          =

meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-8    | defconfig        =
  | 1          =

meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
  | 1          =

rk3288-veyron-jaq    | arm   | lab-collabora | gcc-8    | multi_v7_defconfi=
g | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.49/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.49
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      904ad453baa0aae7189ebd07f0d43cb694fb2987 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
  | regressions
---------------------+-------+---------------+----------+------------------=
--+------------
hip07-d05            | arm64 | lab-collabora | gcc-8    | defconfig        =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb1a6d94e2ff9bdc11797a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
9/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
9/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb1a6d94e2ff9bdc117=
97b
        failing since 9 days (last pass: v5.10.46-101-ga41d5119dc1e, first =
fail: v5.10.47) =

 =



platform             | arch  | lab           | compiler | defconfig        =
  | regressions
---------------------+-------+---------------+----------+------------------=
--+------------
imx8mp-evk           | arm64 | lab-nxp       | gcc-8    | defconfig        =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb18366667ea24881179a7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
9/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
9/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb18366667ea2488117=
9a8
        new failure (last pass: v5.10.48-7-g5b40bcb16853d) =

 =



platform             | arch  | lab           | compiler | defconfig        =
  | regressions
---------------------+-------+---------------+----------+------------------=
--+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb187f7889c8d0db11796e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
9/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
9/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb187f7889c8d0db117=
96f
        new failure (last pass: v5.10.48-7-g5b40bcb16853d) =

 =



platform             | arch  | lab           | compiler | defconfig        =
  | regressions
---------------------+-------+---------------+----------+------------------=
--+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-8    | defconfig        =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb188010b271eb2811796a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
9/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
9/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb188010b271eb28117=
96b
        new failure (last pass: v5.10.48-7-g5b40bcb16853d) =

 =



platform             | arch  | lab           | compiler | defconfig        =
  | regressions
---------------------+-------+---------------+----------+------------------=
--+------------
meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb1762f435a6c60211798c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
9/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
9/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb1762f435a6c602117=
98d
        new failure (last pass: v5.10.48-7-g5b40bcb16853d) =

 =



platform             | arch  | lab           | compiler | defconfig        =
  | regressions
---------------------+-------+---------------+----------+------------------=
--+------------
rk3288-veyron-jaq    | arm   | lab-collabora | gcc-8    | multi_v7_defconfi=
g | 3          =


  Details:     https://kernelci.org/test/plan/id/60eb265536b669a8e211797e

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
9/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
9/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60eb265636b669a8e2117992
        failing since 26 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-07-11T17:11:41.272700  /lava-4176450/1/../bin/lava-test-case
    2021-07-11T17:11:41.289880  <8>[   13.127505] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-07-11T17:11:41.290097  /lava-4176450/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60eb265636b669a8e21179aa
        failing since 26 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-07-11T17:11:39.846098  /lava-4176450/1/../bin/lava-test-case
    2021-07-11T17:11:39.864108  <8>[   11.700026] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-07-11T17:11:39.864330  /lava-4176450/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60eb265636b669a8e21179ab
        failing since 26 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-07-11T17:11:38.826122  /lava-4176450/1/../bin/lava-test-case
    2021-07-11T17:11:38.831768  <8>[   10.680276] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
