Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8258C3BB773
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 09:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbhGEHHo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 03:07:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbhGEHHo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Jul 2021 03:07:44 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15186C061574
        for <stable@vger.kernel.org>; Mon,  5 Jul 2021 00:05:07 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id y2so2781772pff.11
        for <stable@vger.kernel.org>; Mon, 05 Jul 2021 00:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uckTB3/A2kk20IWR8ST0WY9vdvtcvng9RN+mDLFo0DU=;
        b=D18KG5Wo8DHdSKtHSkH1qLr6oZeA0z3e8vKsblV1pe8nrlhvSew4JJ4xM1/RctCYVV
         060/NFHLoJhYCkD7Mtn65sTIR0sG0RzLgt3tKJ/004Jtph2CJ5NxB5aellM8hs5HYif8
         FHH1lkmMQwbYn+/SeOVnEuB0Ab8WKnUOTbP8rsCE0NeZfH//mxJnRGRZYbw3NoyZkwMv
         yeEFYNBBLsG8I5RHa5gLinSHxsSLUj4dEyXJ04EIulHR1+JwFsN6fKK5jR8cTrWw4iCR
         WlYGh7/VWixhcIx4UPmQA2XPzMAFcWGE/Wtg9AOlElbukl6WKhZVWac3Uk8t1DkDnVBN
         donA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uckTB3/A2kk20IWR8ST0WY9vdvtcvng9RN+mDLFo0DU=;
        b=a+fXY5vGou/C4xlmE+Cwwzl3VClL9cUVWnNbfeC7tt95PzlZefSmnU3EJYMRsmpKhM
         omdrlGhk8dhEEstjKHY8e2HZ1/YGV/Auag/4f4QYdvaVFPoVlFtdiQWoCoydvimVwRs+
         VJhTLMiPPbvwR8eYuHLOJe0y/AkGrhsCvu3iutckA9PYueuBnvrQ8H7xj8vep/X/2R11
         QeNd7tSRUyIbDJJw4TbHkDFQkZtvk9hmZ30QxQaFbhFUFIqsPptM0jAODWyrc/q2d1Gp
         04727jz3hdPqSQ8E5KLFwA30rOjYdczpJjIgkZ+MPIZTD3hyvoljES3rr1LdnzmMwT1o
         D8Xw==
X-Gm-Message-State: AOAM531G7/ijiXL2ScO/hImeY4smbDchUQ4N6n4jrCGuFabZmvMKw2hr
        T/Xqjobr0TkmaFheiBhRjjooa2cMQTi2tCeM
X-Google-Smtp-Source: ABdhPJzfBZifKfNtGVRnv42lqO6elzkpGnCZLzglL+HNUekwz/xhZZHPCi4YKNtkETIUm9BLQq8+3Q==
X-Received: by 2002:aa7:9e43:0:b029:301:c40f:de25 with SMTP id z3-20020aa79e430000b0290301c40fde25mr13377227pfq.59.1625468706460;
        Mon, 05 Jul 2021 00:05:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a23sm11677076pfn.117.2021.07.05.00.05.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 00:05:06 -0700 (PDT)
Message-ID: <60e2af22.1c69fb81.17bd6.3d57@mx.google.com>
Date:   Mon, 05 Jul 2021 00:05:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.238-21-g183e37794999
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 165 runs,
 4 regressions (v4.14.238-21-g183e37794999)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 165 runs, 4 regressions (v4.14.238-21-g183e3=
7794999)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
meson-gxm-q200    | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =

rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.238-21-g183e37794999/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.238-21-g183e37794999
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      183e3779499926ec467662940bd08456aa0323e7 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
meson-gxm-q200    | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60e27ea4ee84bf24fd117998

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.238=
-21-g183e37794999/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.238=
-21-g183e37794999/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e27ea4ee84bf24fd117=
999
        failing since 125 days (last pass: v4.14.222-11-g13b8482a0f700, fir=
st fail: v4.14.222-120-gdc8887cba23e) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/60e2815e4842d8c2a811796d

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.238=
-21-g183e37794999/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.238=
-21-g183e37794999/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60e2815e4842d8c2a8117984
        failing since 19 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583) =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60e2815e4842d8c2a8117996
        failing since 19 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-07-05T03:49:32.500944  /lava-4138877/1/../bin/lava-test-case
    2021-07-05T03:49:32.518692  [   16.227542] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60e2815e4842d8c2a8117997
        failing since 19 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-07-05T03:49:29.051257  /lava-4138877/1/../bin/lava-test-case
    2021-07-05T03:49:29.056845  [   12.776945] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
