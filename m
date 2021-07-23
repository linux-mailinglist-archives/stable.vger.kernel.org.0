Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC9E3D41A8
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 22:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbhGWUAZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 16:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbhGWUAY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Jul 2021 16:00:24 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B63AFC061575
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 13:40:57 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id mt6so3926569pjb.1
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 13:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eK6kAXxAVW7LDbtZ4FqhPNl5UPTCusoWaGyhuXeiB6U=;
        b=vAoEgThDawpY6gSVW4SBTZCsshDSwbrBBfYcvEccAQGnIjt7TT4fstoe1adhDzQmQO
         MyUnxUjVEcyvAXgTPwjN4u3Ig1Iorm8se0c/i+aDNgV+fVaOzvCBcUfQNAy00fmbaZsP
         MU8nnnFeB9zuWQUweoTznBJd5o4mx2a291ZlIZyuk+3V5EmWLe6rE19G8T3a2er28NFA
         pouuAwmJp32RWI1dt1i308x4fIPS/0A0dQs1KN+xFWO8ltfs6HTs3ZYRdRH8tmEvMgU6
         X7/gN5t8pHeWGf+xIn0R9jrLuKfMGIc1kW/TzKVOU8/3QsGtdfvu3ummbJHyZ8um/wT8
         K/dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eK6kAXxAVW7LDbtZ4FqhPNl5UPTCusoWaGyhuXeiB6U=;
        b=K6Ho1fOJOzrFIijuQ4t7e1G1rcwRbo8eiYrQ8xdwhBFxNi+kvQGjsql6p3xchptovv
         aJPUJvxUdQYr//4ClUXTz68PiqnPngh+7mu+DWXBEJdxywA4+RF/DV8e2/6i3VUTKLHg
         aTABe5rP2HDlw0ij+UrxI1rsrzAfXY3LXM/FgTonCUVf4IRpZ5rQy+ZOwhKdS9du7uoN
         ypII6x22k862EI44qMLPNuoqTBxBT5ma+oF2aRPPV8mZpqf5e33ogsFR+JDzLSt3h0/N
         PgtxdS3CTNHuV6wxC/vyYtuoMvgWBaFPXv8/7ucFg4ggBRifWsWfWPyoGlg2ALSsMNb0
         dCRQ==
X-Gm-Message-State: AOAM533Bk7vshZlp6+xH9NmgSBx4X6ftUawXcB8wXlQ6pGHPdjUX4jzC
        v18Kghfek+hQEyfkisT94lLDNbQIe6Zt+Eoy
X-Google-Smtp-Source: ABdhPJwVf+xia9l1PM/rIqrJ+P+d2ARq7KpoIR8o+EuWS8Piha7hmIHa1PM79fgpWBxzucVeQ+97ow==
X-Received: by 2002:aa7:8b07:0:b029:2f7:d38e:ff1 with SMTP id f7-20020aa78b070000b02902f7d38e0ff1mr6333023pfd.72.1627072857056;
        Fri, 23 Jul 2021 13:40:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m7sm1558727pgl.67.2021.07.23.13.40.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 13:40:56 -0700 (PDT)
Message-ID: <60fb2958.1c69fb81.c551f.5c16@mx.google.com>
Date:   Fri, 23 Jul 2021 13:40:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.51-363-g9821f32d9c36
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 180 runs,
 5 regressions (v5.10.51-363-g9821f32d9c36)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 180 runs, 5 regressions (v5.10.51-363-g9821f=
32d9c36)

Regressions Summary
-------------------

platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre  | gcc-8    | bcm2835_defconfig  =
| 1          =

imx8mp-evk         | arm64 | lab-nxp       | gcc-8    | defconfig          =
| 1          =

rk3288-veyron-jaq  | arm   | lab-collabora | gcc-8    | multi_v7_defconfig =
| 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.51-363-g9821f32d9c36/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.51-363-g9821f32d9c36
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9821f32d9c362ae85cba162a61076af81ffb1d3b =



Test Regressions
---------------- =



platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre  | gcc-8    | bcm2835_defconfig  =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60faee94dbb08590bb3a2f60

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.51-=
363-g9821f32d9c36/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.51-=
363-g9821f32d9c36/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60faee94dbb08590bb3a2=
f61
        new failure (last pass: v5.10.51-363-gc7603cd6c337) =

 =



platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
imx8mp-evk         | arm64 | lab-nxp       | gcc-8    | defconfig          =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60faf95718e9fdd35e3a2f64

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.51-=
363-g9821f32d9c36/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.51-=
363-g9821f32d9c36/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60faf95718e9fdd35e3a2=
f65
        new failure (last pass: v5.10.51-239-g0625d8e48998) =

 =



platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
rk3288-veyron-jaq  | arm   | lab-collabora | gcc-8    | multi_v7_defconfig =
| 3          =


  Details:     https://kernelci.org/test/plan/id/60faff0c53ced847ae3a2f49

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.51-=
363-g9821f32d9c36/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.51-=
363-g9821f32d9c36/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60faff0c53ced847ae3a2f5c
        failing since 38 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-07-23T17:40:08.977739  /lava-4237401/1/../bin/lava-test-case
    2021-07-23T17:40:08.995028  <8>[   13.820885] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-07-23T17:40:08.995279  /lava-4237401/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60faff0c53ced847ae3a2f74
        failing since 38 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-07-23T17:40:07.571640  /lava-4237401/1/../bin/lava-test-case<8>[  =
 12.395287] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-07-23T17:40:07.572032  =

    2021-07-23T17:40:07.572231  /lava-4237401/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60faff0c53ced847ae3a2f75
        failing since 38 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-07-23T17:40:06.533205  /lava-4237401/1/../bin/lava-test-case
    2021-07-23T17:40:06.538986  <8>[   11.375623] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
