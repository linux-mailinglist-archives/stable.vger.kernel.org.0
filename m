Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77C963DF395
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 19:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237977AbhHCRHq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 13:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237888AbhHCRH3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Aug 2021 13:07:29 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F40C061382
        for <stable@vger.kernel.org>; Tue,  3 Aug 2021 10:06:47 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id pj14-20020a17090b4f4eb029017786cf98f9so5655219pjb.2
        for <stable@vger.kernel.org>; Tue, 03 Aug 2021 10:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dVw6LA/LT2brmIXRAI0DiWhwOoLKbQBRLqV7Eu/kb9E=;
        b=mpuAQElScZYj7c6MV48MmJo+7gY3s6vf6WjlV0ulqNcLRVY8iIKBosQVnNwtuC5pEO
         BbVI3/gp9hdgQWeuPvA56sSl2rd1UyKAW+CfOQ/DQ63MWRwlrGrOxh46miXDzRF/gWEf
         jGw5NwKI5KceAha/q4GsE24rPMOoQvCRaCq5/6N9vHtPuNbprggnv14jaX4dayFliZfF
         SaX0vvNd+ZgQaqSFpfvlgEJxpzVafFrXsiCqzbmCAEcRlbMdidCAHLWoE8hAd1uj3aqI
         eIxdppA4R/Ir0l5gfxSh/vhmYF7IzRQpZnJXbRIT9+0fJe744mwHn53VQNobyiX5sENf
         ZRfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dVw6LA/LT2brmIXRAI0DiWhwOoLKbQBRLqV7Eu/kb9E=;
        b=U3vlG0hIHDE4rwuEhwU+wuOlJWnqFnby1rZXaz0ezJOc5IIfRwsXsq6NbEGbwHkonu
         +2oHF0dQday1Qy6IL3cqeshwkiTvbd0mRSnwUknNSk9Guyvz7uBvnJ/Q1cPCJA+N9liV
         Gw9MAnFeeJ/6J6AdiwhooS7bfb0KHrWETeBlabg/FjP1o7McnNqleIdtQH2LoLeqx/cA
         vdUA+XoNS91N+YsqDzTTkXIoFy19DJ59g3+j/x53/NgebCUyqrD3hOiKT9i7q8t16E3S
         e5I6UsFTgnEKfojjm7E3f0z9iyMSU+llY4ZCngBnGnKFOII0FBkMssz/qvfQv5AS95R/
         eZ1A==
X-Gm-Message-State: AOAM5333KnR0tE8S8H7XcRjOzKoXWHOPabsgEOBBCvJ72255Oxu5qzaJ
        kOBW0CFP+GsvzYDcbjebFD9eOXShXQ3iTOWe
X-Google-Smtp-Source: ABdhPJxzf/YAY/GFDB4L4FJSZbQnBjg28jZWY1Cmbygvtj8A1in3qiTQpUEvBeuQGm8Z9QpZX4aRsg==
X-Received: by 2002:a17:90a:de18:: with SMTP id m24mr23331959pjv.78.1628010406781;
        Tue, 03 Aug 2021 10:06:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b7sm15915680pfl.195.2021.08.03.10.06.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 10:06:46 -0700 (PDT)
Message-ID: <610977a6.1c69fb81.5fa32.d6ee@mx.google.com>
Date:   Tue, 03 Aug 2021 10:06:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.55-4-g48156f3dce81
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 136 runs,
 3 regressions (v5.10.55-4-g48156f3dce81)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 136 runs, 3 regressions (v5.10.55-4-g48156f3=
dce81)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.55-4-g48156f3dce81/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.55-4-g48156f3dce81
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      48156f3dce81b215b9d6dd524ea34f7e5e029e6b =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/61094b640c05c9f737b1368c

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.55-=
4-g48156f3dce81/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.55-=
4-g48156f3dce81/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/61094b640c05c9f737b136a4
        failing since 49 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-03T13:57:38.248021  /lava-4317797/1/../bin/lava-test-case
    2021-08-03T13:57:38.265332  <8>[   14.194363] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-08-03T13:57:38.265651  /lava-4317797/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/61094b640c05c9f737b136ba
        failing since 49 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-03T13:57:36.817933  /lava-4317797/1/../bin/lava-test-case
    2021-08-03T13:57:36.823512  <8>[   12.765118] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/61094b640c05c9f737b136bb
        failing since 49 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-03T13:57:35.798844  /lava-4317797/1/../bin/lava-test-case
    2021-08-03T13:57:35.804401  <8>[   11.745348] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
