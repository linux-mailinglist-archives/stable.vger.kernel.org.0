Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2343C945F
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 01:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbhGNXXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 19:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbhGNXXG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Jul 2021 19:23:06 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB18C06175F
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 16:20:13 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 37so4163603pgq.0
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 16:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=g10vMUMEeC0SQGT1KzfgIkoaY3Gevkhjf5a10eKLKNo=;
        b=nCLKktviOitErtvJnhTzNiY9as5nRT1Q+6rLz4PoVbxx3H/qZSs+zuMbAc/HxoZI0v
         fvNGHdU/t9UjIIPZWRDm70YWhEtkY094HR17DB+SJpaEqTqrZGsXUpGeFSTllWhjd5mQ
         CyJc6BxALdF5Kplz3Nb4GkGh40loG6RVevwvE8dfNLh5QnbmLyfzM4DTPr8HMclcTXP5
         fUvaMaeD0hhFffK2m4cBPtVdRslMn3MjdC0hhNUOPERL6gr8HON42jst1rk0DE7QAQ6a
         Ini+WrKJl10X33gMDhKzouO5bjrWDdrKpkJ8nKD4H3MXnEOp7E48mPfs81nmZwX9B/Ju
         Ulkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=g10vMUMEeC0SQGT1KzfgIkoaY3Gevkhjf5a10eKLKNo=;
        b=mncoVMc0B9sto7brY5UBBQ4i/T33bPIOeL4iQn1VBnwY2XMqenx2+4oLiZ/VhR1qHl
         rMCaoWffT1h/DQpXHeCbCsVe0e53l3HMH4tYE8OcjwabjbkXZWtbS84x5WLAL9jCOfnv
         pOcCujsNDQ78qMxo1irO7mDHZsHFvuCuVo98FAC9sbCta1yD/U7zUII1y2hlUonDOrSm
         cOkRR0jjZDB66Dyuc53NzrukgBk5MEu1waInCaijEN3Z55g8teZFI4zICFsxcq0rH01c
         puXWlM93+kXbDH2GlSNAJpDvbRJ03UeH6r6SmD2w8OmtGe/E/0uJjwBnCpc/gchIVyWO
         cLfQ==
X-Gm-Message-State: AOAM533u+2NYvNv+FjQHbbP38hprEyhmKVLco0ApV/fFQBYuAaYXsZCL
        KgAVk3mvLz9GJ/tdBC/ewAbBY0cET4iTEjd3
X-Google-Smtp-Source: ABdhPJyodzaacX1PEr+ezfQ8s9G/3oWcFERB/wcbN7Qldin2mUFaCDQwH8gwCgiimKyQ+fBrKxBKVg==
X-Received: by 2002:a62:15c5:0:b029:32c:ea9f:a5ed with SMTP id 188-20020a6215c50000b029032cea9fa5edmr446121pfv.27.1626304813366;
        Wed, 14 Jul 2021 16:20:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i24sm4099197pfr.56.2021.07.14.16.20.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 16:20:13 -0700 (PDT)
Message-ID: <60ef712d.1c69fb81.1ec77.d1aa@mx.google.com>
Date:   Wed, 14 Jul 2021 16:20:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.12.y
X-Kernelci-Kernel: v5.12.17
Subject: stable/linux-5.12.y baseline: 179 runs, 5 regressions (v5.12.17)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.12.y baseline: 179 runs, 5 regressions (v5.12.17)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
hip07-d05         | arm64 | lab-collabora | gcc-8    | defconfig          |=
 1          =

imx8mp-evk        | arm64 | lab-nxp       | gcc-8    | defconfig          |=
 1          =

rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.12.y/kernel=
/v5.12.17/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.12.y
  Describe: v5.12.17
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      72e0aab10d2c35cd136fb842ad4cf1dc0f451df1 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
hip07-d05         | arm64 | lab-collabora | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60ef413b79b0f14a7e8a93c9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.12.y/v5.12.17/a=
rm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.12.y/v5.12.17/a=
rm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ef413c79b0f14a7e8a9=
3ca
        failing since 13 days (last pass: v5.12.13, first fail: v5.12.14) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
imx8mp-evk        | arm64 | lab-nxp       | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60ef40ba1e79c4a7238a93b2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.12.y/v5.12.17/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.12.y/v5.12.17/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ef40ba1e79c4a7238a9=
3b3
        new failure (last pass: v5.12.16) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/60ef5c20aaf2c603168a93b1

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.12.y/v5.12.17/a=
rm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.12.y/v5.12.17/a=
rm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60ef5c20aaf2c603168a93c9
        failing since 28 days (last pass: v5.12.10, first fail: v5.12.11)

    2021-07-14T21:50:09.121034  /lava-4199043/1/../bin/lava-test-case
    2021-07-14T21:50:09.138297  <8>[   13.451430] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-07-14T21:50:09.138524  /lava-4199043/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60ef5c20aaf2c603168a93e1
        failing since 28 days (last pass: v5.12.10, first fail: v5.12.11)

    2021-07-14T21:50:07.690222  /lava-4199043/1/../bin/lava-test-case
    2021-07-14T21:50:07.708559  <8>[   12.020919] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-07-14T21:50:07.708769  /lava-4199043/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60ef5c20aaf2c603168a93e2
        failing since 28 days (last pass: v5.12.10, first fail: v5.12.11)

    2021-07-14T21:50:06.670279  /lava-4199043/1/../bin/lava-test-case
    2021-07-14T21:50:06.675843  <8>[   11.000910] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
