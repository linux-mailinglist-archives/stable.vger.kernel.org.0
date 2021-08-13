Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 307B83EADFD
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 02:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234368AbhHMAgz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Aug 2021 20:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237919AbhHMAgz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Aug 2021 20:36:55 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BEE5C061756
        for <stable@vger.kernel.org>; Thu, 12 Aug 2021 17:36:29 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id w6so2653972plg.9
        for <stable@vger.kernel.org>; Thu, 12 Aug 2021 17:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yIf2Tn+umyAW5cH+4OI+uIRvJ4Yw3CROnMlavKpMUwE=;
        b=ulZqhyYyjFwsHMrKSybQQODneE3mID2LZ/aE6ikd1YyMbKFz4Tm9a5X24j6vcHesbD
         hhkHknc75lwSARlzbkzUONLbunyZeULjP0bpqCxoam8CFhsOZfwU2RHrFmIhLio2Ncw7
         Cukz01eukKfRDgm5IdL5OzuA+Wf5u7eJFLCX/oTvdOJq9Do0RDqFEnkcjfK/wAKyC+ov
         b3DSUPfiIZo/2hutLf5TCoXOv2uf6Sj4WtFY672KBrlG6wtWx3jkxv4DWvGqFkPz17bT
         BAZ8FWsbwz852sFXw/+Mziu27xIq/NJibzXIM9dAT2k5LboYKltUCszJLqy/2APSvKo1
         FRPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yIf2Tn+umyAW5cH+4OI+uIRvJ4Yw3CROnMlavKpMUwE=;
        b=QajvSEBGGDUdYQTAzBs6hmzuT0MYuNBSCZJZ+nPqYD34gnn91LPEvg7BGH4dNGExmy
         jx4r0rKliaBILVpkMJ7A4M6f8gOiwr5qxLQBI7XbTGfq8o8YMXg/Q/EJCcapNyWLnO9D
         0ELh8A6wdt/FGrQ6U/b2MQ5TO4rdZtdyRRDdnIfZ/rdNIGqd5Ei1ffrJtnv3V3D4Y84A
         u6p1Ic0fn4mn2Sr/78M9eOx/nGWfEw17Z7sfDtIcr3SsiBp5Ysz0Qc8nTSBFFLs/Vflp
         WMUQ+b4oIxzT/Jt+8zgaJdCV0ZGvdtpcR9UVBPaIh0pBpcQIob1I9zCos/V8IanJ6liH
         CJJA==
X-Gm-Message-State: AOAM531FGAgWz5fm1ehs92gjmDl/jOiEOeGoPXJu/MCBkdVy1RbAMCrw
        72eEmhTvTmEwoRWCsN702wzIyVgnhyfLeYeR
X-Google-Smtp-Source: ABdhPJx9aOo7URREnEWps5Xxhetp46W+nS8LRj1jji0kUuq+kZSY+I6kvk+wbABYmDvVKH6Ii8oWSw==
X-Received: by 2002:a17:90a:1108:: with SMTP id d8mr18941686pja.190.1628814988716;
        Thu, 12 Aug 2021 17:36:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r14sm4773099pff.106.2021.08.12.17.36.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 17:36:28 -0700 (PDT)
Message-ID: <6115be8c.1c69fb81.7bcb1.e3f0@mx.google.com>
Date:   Thu, 12 Aug 2021 17:36:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.57-139-g906cd6fc30f8
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 130 runs,
 3 regressions (v5.10.57-139-g906cd6fc30f8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 130 runs, 3 regressions (v5.10.57-139-g906cd=
6fc30f8)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.57-139-g906cd6fc30f8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.57-139-g906cd6fc30f8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      906cd6fc30f875963b6f867e341f74343a97a7e5 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/611589a88ac49a808ab1377c

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.57-=
139-g906cd6fc30f8/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.57-=
139-g906cd6fc30f8/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/611589a88ac49a808ab13794
        failing since 58 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-12T20:50:33.806509  /lava-4355076/1/../bin/lava-test-case
    2021-08-12T20:50:33.823408  <8>[   14.242130] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/611589a98ac49a808ab137ac
        failing since 58 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-12T20:50:32.400283  /lava-4355076/1/../bin/lava-test-case<8>[  =
 12.818703] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-08-12T20:50:32.400638  =

    2021-08-12T20:50:32.400834  /lava-4355076/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/611589a98ac49a808ab137ad
        failing since 58 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-12T20:50:31.363509  /lava-4355076/1/../bin/lava-test-case
    2021-08-12T20:50:31.368935  <8>[   11.799387] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
