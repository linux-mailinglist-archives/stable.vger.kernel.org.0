Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB5D0403B41
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 16:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235140AbhIHOPW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 10:15:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbhIHOPW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Sep 2021 10:15:22 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B80DC061575
        for <stable@vger.kernel.org>; Wed,  8 Sep 2021 07:14:14 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id u11-20020a17090adb4b00b00181668a56d6so1596675pjx.5
        for <stable@vger.kernel.org>; Wed, 08 Sep 2021 07:14:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1R9NMpZ9WwNgGAdYtoyJ2kwnjUpvD79H4+MktANs94c=;
        b=I/SvrCuVeJWxG8u85VTewACKbQLmviy7fq28/DVzovN+XGgGEHB95IFphPe3bqIJ5C
         51NtPEAIKhDeC27kldawtZ8cneN32aAnbFhPMMnXRqk+c2Sm3RcFOPWTsyhv8jtumpFq
         z2+gZaHDej51sCtxztNztzeHOTPiFZ6qOW+RiT9rdZvCaxkYH36GvvyVIwTOiC69lFIB
         369zhfJMiYoHI7MFPdSGx4CcQHdAZgGTyzGvoMTuJe6+NdCVyzYGs/CQ5605PRWpJfvK
         456+DpvzeM74gncRAJ8MFsgAVICzd/rK0y0XCUGfifO3PUk8KrNbRE9JhVhdPcTgfgwD
         6obQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1R9NMpZ9WwNgGAdYtoyJ2kwnjUpvD79H4+MktANs94c=;
        b=pNyS4IyBaivkZpDXy1YqH7xuyAeSlst8rdLVCLFKBE66FoDl8LlxZ5JEX5rGKqn7uY
         vRbVShICwgT7uJUuaSjwPj6gbiA/6hDMVq0eutwgZf/ADClsR8eE5l9UB8ucEZDNPb2j
         ZnGVfKSuEQiw3C98uQ28Qr0Ji2uadU4KJCwYEwXQiiR49Z//0RXv2KbXaugxk4Ci55Ch
         f46eCyUK4fQw2zq3QCSeHs7ApmabXFlOM84PyTo/Yz1zl0ebR/cZEAgT0jcPFR/9AtTS
         d0vXf7C2X3AG1/htDEoYaH/blTvCOHROfD3vXE0RBdQT5itSL5VwzBAjh6nRcHW+QvEp
         k67w==
X-Gm-Message-State: AOAM532EW1Jut11WZicduRqv4A5h9Ua99YLscy2fFG3+6qP6Ro31qfc4
        YJT3jf9oXYSRYH4iy0t92XrVqV/D39a7+uXA
X-Google-Smtp-Source: ABdhPJy0+mSkXu9wdrZk07YuNzx8RT4ySn8Gm8l4gpwl9BlsdTuXnosQGw61l9Wlu2HKf4KvvZ6Ulw==
X-Received: by 2002:a17:903:22ca:b0:13a:1109:f90d with SMTP id y10-20020a17090322ca00b0013a1109f90dmr3207694plg.84.1631110453036;
        Wed, 08 Sep 2021 07:14:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e13sm2655153pfi.210.2021.09.08.07.14.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 07:14:12 -0700 (PDT)
Message-ID: <6138c534.1c69fb81.7cdfb.71e3@mx.google.com>
Date:   Wed, 08 Sep 2021 07:14:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.63
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 203 runs, 6 regressions (v5.10.63)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 203 runs, 6 regressions (v5.10.63)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.63/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.63
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e07f317d5a289f06b7eb9025d2ada744cf22c940 =



Test Regressions
---------------- =



platform            | arch  | lab           | compiler | defconfig         =
 | regressions
--------------------+-------+---------------+----------+-------------------=
-+------------
hip07-d05           | arm64 | lab-collabora | gcc-8    | defconfig         =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/61389195b63a313e3fd59676

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.63/=
arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.63/=
arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61389195b63a313e3fd59=
677
        failing since 68 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform            | arch  | lab           | compiler | defconfig         =
 | regressions
--------------------+-------+---------------+----------+-------------------=
-+------------
imx8mp-evk          | arm64 | lab-nxp       | gcc-8    | defconfig         =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/613890f9f6e458f325d59672

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.63/=
arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.63/=
arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613890f9f6e458f325d59=
673
        failing since 3 days (last pass: v5.10.62-8-g7b314af003ef, first fa=
il: v5.10.62-9-ge3bb5116f2af) =

 =



platform            | arch  | lab           | compiler | defconfig         =
 | regressions
--------------------+-------+---------------+----------+-------------------=
-+------------
r8a77950-salvator-x | arm64 | lab-baylibre  | gcc-8    | defconfig         =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6138904cc51fad8ffed59684

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.63/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-salvator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.63/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-salvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6138904cc51fad8ffed59=
685
        new failure (last pass: v5.10.62-29-g6ad2b8802513) =

 =



platform            | arch  | lab           | compiler | defconfig         =
 | regressions
--------------------+-------+---------------+----------+-------------------=
-+------------
rk3288-veyron-jaq   | arm   | lab-collabora | gcc-8    | multi_v7_defconfig=
 | 3          =


  Details:     https://kernelci.org/test/plan/id/6138a88cf98a77efcbd59693

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.63/=
arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.63/=
arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6138a88cf98a77efcbd596a7
        failing since 85 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-09-08T12:11:36.322734  /lava-4475353/1/../bin/lava-test-case
    2021-09-08T12:11:36.340008  <8>[   13.362861] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-09-08T12:11:36.340219  /lava-4475353/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6138a88cf98a77efcbd596bf
        failing since 85 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-09-08T12:11:34.898028  /lava-4475353/1/../bin/lava-test-case
    2021-09-08T12:11:34.915121  <8>[   11.937216] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-09-08T12:11:34.915410  /lava-4475353/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6138a88cf98a77efcbd596c0
        failing since 85 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-09-08T12:11:33.877784  /lava-4475353/1/../bin/lava-test-case
    2021-09-08T12:11:33.883779  <8>[   10.917770] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
