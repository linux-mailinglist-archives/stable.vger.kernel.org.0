Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E51C3C1D73
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 04:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbhGIC07 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Jul 2021 22:26:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbhGIC06 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Jul 2021 22:26:58 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BD3DC061574
        for <stable@vger.kernel.org>; Thu,  8 Jul 2021 19:24:15 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id t9so8435337pgn.4
        for <stable@vger.kernel.org>; Thu, 08 Jul 2021 19:24:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yWqL6DeFbzzbR8gziaKqaVjhZjBhWup9P0vJw13YeZ8=;
        b=OGDOfZj3GnjCs966ZgVnnVViJ5LZTjEK/hDOQWmLctYtpfsauYpyPulrVjLBeibI1l
         sCBSUV4+FOLXNsv6iD9xA7qy1lHGsb8U9Ccx659IeiodNzRXEXPikyv6JvqvjM9iu9Qt
         b1HPGZqBcIolXxjGGmQ2g8N6nFIHKl1yHh6hV4mcnQdrOT4rkWVFFY/HLYTg8PyLhjAH
         NeJw7S6Ab/Z7H+C03Zcs7si5QRWZQTrtJaQfkajtYe8ag4gB3e+ityuOoiY1e64s6V/W
         hNaNFYOGIQtvAREEe1jSVU+bpZgHXPufmkFLAb/ae02Wmi/gHvigzQ75OeP+Qzsxv1KX
         t6nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yWqL6DeFbzzbR8gziaKqaVjhZjBhWup9P0vJw13YeZ8=;
        b=CZu+ndfW6xlaSyAZUCjm8DGIhzOD61N/95EVoiUbpP/GtwI7oZD/Z17Aq4EUyDGfNU
         H0FQa0o49rmVASYmC0SuX03v6pVsZDdoAEJdATBl6NhxN8GKcSqi5TiTpYluVZPyrIfF
         P/ahzw1HlHDWiyJB7dA/HMGwR6KIsYwLNoCNtlZ6mb9AEbeSiU54tKw44SIUAoruAHww
         aVS+sllaa4xKyYTXgashcEmXWmZaMnHYl3vrK6s1vMHPh2ziXhrvrLsonLL9jIbjjJwQ
         QFMtmIAmWBIbcgzfXNQbeYZEeIAaCpoi1trx66bwm0ZhchZHSmbGqkZ8eywaWP5v4QLV
         b+Pg==
X-Gm-Message-State: AOAM5334ih7/O9Jko3bbiLEjSCN0HyZJsiInWT944gYQ1W6vXFd82a/x
        oeKaiLoXsrA8cURweMfdv1NmV04ztTD1xX7O
X-Google-Smtp-Source: ABdhPJyzmQjutL9z5l/SZwsz80en9tFFk7CsbwZ663bWLC0/LF1hW4JBqszjU/CkpsCEQ1nCEBNUVQ==
X-Received: by 2002:a05:6a00:8c4:b029:2b4:8334:ed4d with SMTP id s4-20020a056a0008c4b02902b48334ed4dmr34067099pfu.36.1625797448447;
        Thu, 08 Jul 2021 19:24:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n23sm3614799pjq.2.2021.07.08.19.24.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 19:24:08 -0700 (PDT)
Message-ID: <60e7b348.1c69fb81.1524a.c119@mx.google.com>
Date:   Thu, 08 Jul 2021 19:24:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.238-25-gc68d366ca9ae
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 147 runs,
 5 regressions (v4.14.238-25-gc68d366ca9ae)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 147 runs, 5 regressions (v4.14.238-25-gc68d3=
66ca9ae)

Regressions Summary
-------------------

platform          | arch   | lab           | compiler | defconfig          =
| regressions
------------------+--------+---------------+----------+--------------------=
+------------
meson-gxm-q200    | arm64  | lab-baylibre  | gcc-8    | defconfig          =
| 1          =

qemu_x86_64-uefi  | x86_64 | lab-broonie   | gcc-8    | x86_64_defconfig   =
| 1          =

rk3288-veyron-jaq | arm    | lab-collabora | gcc-8    | multi_v7_defconfig =
| 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.238-25-gc68d366ca9ae/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.238-25-gc68d366ca9ae
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c68d366ca9ae258b838e73097d2e9fa74db6a8e4 =



Test Regressions
---------------- =



platform          | arch   | lab           | compiler | defconfig          =
| regressions
------------------+--------+---------------+----------+--------------------=
+------------
meson-gxm-q200    | arm64  | lab-baylibre  | gcc-8    | defconfig          =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60e78093082c00e20011796a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.238=
-25-gc68d366ca9ae/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.238=
-25-gc68d366ca9ae/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e78093082c00e200117=
96b
        failing since 129 days (last pass: v4.14.222-11-g13b8482a0f700, fir=
st fail: v4.14.222-120-gdc8887cba23e) =

 =



platform          | arch   | lab           | compiler | defconfig          =
| regressions
------------------+--------+---------------+----------+--------------------=
+------------
qemu_x86_64-uefi  | x86_64 | lab-broonie   | gcc-8    | x86_64_defconfig   =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60e77c9a7ce7a94f5c117985

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.238=
-25-gc68d366ca9ae/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x=
86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.238=
-25-gc68d366ca9ae/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x=
86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e77c9a7ce7a94f5c117=
986
        new failure (last pass: v4.14.238-21-g49bfe4ee578d0) =

 =



platform          | arch   | lab           | compiler | defconfig          =
| regressions
------------------+--------+---------------+----------+--------------------=
+------------
rk3288-veyron-jaq | arm    | lab-collabora | gcc-8    | multi_v7_defconfig =
| 3          =


  Details:     https://kernelci.org/test/plan/id/60e7a15f44161b98f811798d

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.238=
-25-gc68d366ca9ae/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.238=
-25-gc68d366ca9ae/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60e7a15f44161b98f81179a1
        failing since 23 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583) =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60e7a15f44161b98f81179ba
        failing since 23 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-07-09T01:07:01.340849  /lava-4161352/1/../bin/lava-test-case
    2021-07-09T01:07:01.358192  [   13.982046] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-07-09T01:07:01.358442  /lava-4161352/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60e7a15f44161b98f81179bb
        failing since 23 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-07-09T01:07:00.321968  /lava-4161352/1/../bin/lava-test-case
    2021-07-09T01:07:00.327737  [   12.963092] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
