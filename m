Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB99A3ECB83
	for <lists+stable@lfdr.de>; Sun, 15 Aug 2021 23:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbhHOVqy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Aug 2021 17:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbhHOVqv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Aug 2021 17:46:51 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE187C061764
        for <stable@vger.kernel.org>; Sun, 15 Aug 2021 14:46:20 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id n5so3015814pjt.4
        for <stable@vger.kernel.org>; Sun, 15 Aug 2021 14:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BeGPnZ+sh6F3ya0HZPiGYl8qjIT7JLE0mlq6HEgOG4M=;
        b=spoRBft4dCR0QDF9Nxak5Iz/JUCBiWaX5hs2Vy+Yc96C10rkBYQmhmzPgWmyS1H4H4
         9ZzUBBQSVPB8+jtSZzIlNrZ+CZ8mSxyQRKzLxRk5pIM+NwgUgvLslzQeZ9Umtzi4NYYs
         VJHdqKcHszvjSKWOwUWP2mdRjkM9c4oowcOqcR16S/fiJEcI9WbxIv/UvPLTnN0JfYY0
         LTRKaYEKwv9mmhqOO7wbUBzomS/9Fhyzbpm+SIvIpKT9xZf2vak3Y/tmIn/6X1BbyonP
         nohR0wvKkReeAhY08vSlq5byRzLHPCv6wg8HFlpiZyJXCZi8goLPr7wAv6fa2qGHtgXg
         c78w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BeGPnZ+sh6F3ya0HZPiGYl8qjIT7JLE0mlq6HEgOG4M=;
        b=iKJBHm4B97u2onfGSKywwKXZI6bwlnJTY2hREgfS9RbVRo+B3RvHhsw8HrMc2MFN9E
         QhKw6OYZLJrnDD6CwiVQ5BrxdkoL3favtlEVbEz7VUCGIAlVQGFr708vyxwJuh94Z8Bi
         fEmZAH9ZNrJDBWWy7lvnBWKAB6oPSJaqk32O4KNmauY7Cp0AMScenujteoYz048ghRcw
         u/Cc+uWE8K5YgYDB9g7l0Dnkb7ZhWSE3rfcIHwzerFPbe4dLQECj7iMC7BNmfLypNnV2
         iAIRVkdW+eiL4LlHB4mvJ0u8P/xlrRwPKSZzoeeiYR6HfSG6mgip4I+Out4CmtlSxHyY
         K3SQ==
X-Gm-Message-State: AOAM532wNje335Cau9du/uhwzXhfmFEG4BAA2b2Mg/SC7de9hAWEt05O
        Fk1NAA6Rpq5TQZUt6sapoGexdZfn0JqCq1aa
X-Google-Smtp-Source: ABdhPJzco5bL3lrP2h+vnhFyIAZ7mB11RHLu3OW70fRq4JCpdJAYg0cWNrLh/UeZUGig9QJ9rhgAyg==
X-Received: by 2002:a63:d106:: with SMTP id k6mr12777511pgg.234.1629063980180;
        Sun, 15 Aug 2021 14:46:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b8sm7390404pjo.51.2021.08.15.14.46.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Aug 2021 14:46:19 -0700 (PDT)
Message-ID: <61198b2b.1c69fb81.9999d.3a8c@mx.google.com>
Date:   Sun, 15 Aug 2021 14:46:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.139-154-g347fcf584ef8
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 186 runs,
 3 regressions (v5.4.139-154-g347fcf584ef8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 186 runs, 3 regressions (v5.4.139-154-g347fcf=
584ef8)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.139-154-g347fcf584ef8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.139-154-g347fcf584ef8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      347fcf584ef86a455c14b196567cd16c1763aca0 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/611959bbc0cf51a70bb1368a

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.139-1=
54-g347fcf584ef8/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.139-1=
54-g347fcf584ef8/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/611959bbc0cf51a70bb136a2
        failing since 61 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-15T18:15:05.101413  /lava-4368008/1/../bin/lava-test-case
    2021-08-15T18:15:05.118508  <8>[   14.681713] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-08-15T18:15:05.119001  /lava-4368008/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/611959bbc0cf51a70bb136b4
        failing since 61 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-15T18:15:03.678261  /lava-4368008/1/../bin/lava-test-case
    2021-08-15T18:15:03.695268  <8>[   13.258192] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-08-15T18:15:03.695501  /lava-4368008/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/611959bbc0cf51a70bb136b5
        failing since 61 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-15T18:15:02.664461  /lava-4368008/1/../bin/lava-test-case<8>[  =
 12.238705] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-08-15T18:15:02.665089     =

 =20
