Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 290A03B7756
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 19:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233135AbhF2Rkf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 13:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232523AbhF2Rke (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Jun 2021 13:40:34 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ABABC061760
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 10:38:07 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id a7so8460772pga.1
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 10:38:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=J6w+kddcE69K6z0JINS9OvxHfDdsMjmvGJzGxiFuVHU=;
        b=gbkoRHUvlFp9J1lqb0Z43R2vMFP1E4wWZLpFdH4e+OaZHJJlEmGnSfD+p1QNk/Y6DH
         L5y1MGhuYQzymHEVyAz0RoJP/PhuEHNojYXFoAP1GbD8eYHv80WKt9dVxS5gaR7m/Lh8
         1fIn/dPFp48wh7CAUgSMi6WV74x7Cljurbi9T5T+4JDKuMG4IKR/Nmxhf7N0QrSRYNvo
         d7zzKQJE+EYXeZ6fxwrTEhjhxxOAYbAL03dfBVza+D4RA87B60w1gCLRij1SwEkLve1D
         htOPhyk4WSWtjp8nfTcAe8TNbyEdIkLD4WrJwG0Vmm4GskGTONyyX4+Oa7nIjSjJl6qK
         WY+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=J6w+kddcE69K6z0JINS9OvxHfDdsMjmvGJzGxiFuVHU=;
        b=HnjUJ+QVzshW/Kc8NT9sEsUjRXMlHxtd/EXVsTBUOFfDX/HNxJhEdrBN5+t7Szfb8I
         MqP/Dea0cIDALsm52C9jIMvpQUISUPSiuEm/DoyQ02HRWGcHQqUYVUBntAHFLEOW9bBW
         4QjvJhDE0YxDwqufKhlahgkE6EmPNYMzSOlISr8yVU7mMd38USmCWR1CTBVOSBAvSMOo
         kSoQwNc2dcTxPtLCCtDoo0UMZya4D2eAMw4FV26ljcC78qF4d3q0cLNdpJ5v0Z1pMakI
         3AVokf+AAvFw0ejCM06HezDbRH4QNs2t4cn2MYEps4OGslSK1+LMFYBI37UYBFcmNezE
         OMkQ==
X-Gm-Message-State: AOAM531MBDN0Gb45m/J/Jfg8zmwLBWLO+sOYmK7d29gf23IrWm/ptrO+
        Z4gEptjkwt7hzfatPs97n0ugluH3jn4neqsq
X-Google-Smtp-Source: ABdhPJwCVBGsON1353EeZhGXIJ7Llrrn1kWCqbu23T7uf5wQQPMcO2p4UY8gvtgUKY+rV8uZ/Or7cQ==
X-Received: by 2002:a63:1c1f:: with SMTP id c31mr12007346pgc.380.1624988286916;
        Tue, 29 Jun 2021 10:38:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d13sm17925137pfn.136.2021.06.29.10.38.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 10:38:06 -0700 (PDT)
Message-ID: <60db5a7e.1c69fb81.5ba18.54c2@mx.google.com>
Date:   Tue, 29 Jun 2021 10:38:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.12.13-109-g5add6842f3ea
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.12
Subject: stable-rc/queue/5.12 baseline: 167 runs,
 4 regressions (v5.12.13-109-g5add6842f3ea)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 167 runs, 4 regressions (v5.12.13-109-g5add6=
842f3ea)

Regressions Summary
-------------------

platform           | arch | lab           | compiler | defconfig          |=
 regressions
-------------------+------+---------------+----------+--------------------+=
------------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre  | gcc-8    | bcm2835_defconfig  |=
 1          =

rk3288-veyron-jaq  | arm  | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.13-109-g5add6842f3ea/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.13-109-g5add6842f3ea
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5add6842f3eabef6471fa8e5017fce9d112e60e4 =



Test Regressions
---------------- =



platform           | arch | lab           | compiler | defconfig          |=
 regressions
-------------------+------+---------------+----------+--------------------+=
------------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre  | gcc-8    | bcm2835_defconfig  |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60db22d1a9b19661ca23bbe0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.13-=
109-g5add6842f3ea/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.13-=
109-g5add6842f3ea/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60db22d1a9b19661ca23b=
be1
        new failure (last pass: v5.12.13-12-gf45ef4c1b3a2) =

 =



platform           | arch | lab           | compiler | defconfig          |=
 regressions
-------------------+------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq  | arm  | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/60db3408c27180a43e23bbc2

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.13-=
109-g5add6842f3ea/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.13-=
109-g5add6842f3ea/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60db3408c27180a43e23bbdc
        failing since 14 days (last pass: v5.12.10-48-g5e97c6651365, first =
fail: v5.12.10-173-gfd0b35fa0b0c)

    2021-06-29T14:53:53.547238  /lava-4112092/1/../bin/lava-test-case
    2021-06-29T14:53:53.553027  <8>[   12.412643] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60db3408c27180a43e23bbdd
        failing since 14 days (last pass: v5.12.10-48-g5e97c6651365, first =
fail: v5.12.10-173-gfd0b35fa0b0c)

    2021-06-29T14:53:54.572902  /lava-4112092/1/../bin/lava-test-case<8>[  =
 13.432233] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-06-29T14:53:54.573421     =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60db3408c27180a43e23bbf5
        failing since 14 days (last pass: v5.12.10-48-g5e97c6651365, first =
fail: v5.12.10-173-gfd0b35fa0b0c)

    2021-06-29T14:53:55.995558  /lava-4112092/1/../bin/lava-test-case
    2021-06-29T14:53:55.995954  <8>[   14.857443] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =

 =20
