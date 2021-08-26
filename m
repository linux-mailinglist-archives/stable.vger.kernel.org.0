Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96B023F8F20
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 21:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243459AbhHZTrz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 15:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243477AbhHZTry (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Aug 2021 15:47:54 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9EE5C061757
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 12:47:06 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id g14so3680331pfm.1
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 12:47:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FxCYUsZtlpDrBtb8t3ZZvCNLQ+4POwO4ZcZosizrTb8=;
        b=0b1p14a6sBYHibt5SficaAikUJ3nPx4p3PkP/kGEhk8k+Oy4qHXBWRqVl4RJ7SRhS6
         Iy5xuZVNQUBl202QxxyYSrkgD0mfLNjNTY3i3c4Dr+odkpVqxxlARwcJeix3RdWQZEmz
         To8lIViR5oKWyfOCx5sMvaJeVm+zKXh5oqAFjKqTTBA/NH+3q6iMk2asdkTYCfpb4w5n
         s7SLrXLhmgc7QRzPimluR2n8vD2wSsANlzJdrqf0UehfQx0W7RN1WSRjnkYtESURLh6e
         wkNXNB1qOte4IabZQCo53V09d9ckLelbp5eecCgWnkXm4dW4fqBt4cPYLk2mNGZYM1Gj
         HUpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FxCYUsZtlpDrBtb8t3ZZvCNLQ+4POwO4ZcZosizrTb8=;
        b=j1xO5vczwHTmaYIPjZ9fjErmWBR2qDJPry4NqVjeZU7+0HG7XL1/2ZE0PT4gIYNwWg
         QI6CmkUqqqN6l6UId8iwiYNgNEMUAuqy/IGZIfhL0Q/LHVBIvpR3ZhRIz0L0EHUnrW8o
         tY9bZ58WeYskiz76QXAR40pN0JyIswIJh+nG0E+OVNcR2Tt738acka+ciWRHVBjOoY8c
         MR0oUFodPR7BoMF5Rv9QtUk+gird4/HmrLv3zeLdLgleb9hQRPBnpHcOWDQKi9gCri7h
         530uU2RGKnT0o1jJzXwj1vkW4OW04VvHSkDb/05mHZO+rTwMExA7Xt0Lhqk/fdbBy3EJ
         LWSw==
X-Gm-Message-State: AOAM533JzJ4rG+7mdEB5F+mhLfCfvkCVI560is+mm0PAXjINRI7hi8bm
        7WRMjaXIeo1WOhLAYlwM4yavZDoRYAKZOoB8
X-Google-Smtp-Source: ABdhPJxVkcRERD5uwZ5cR8T04+dw5e91u5mjfFye3ACAUfUW4qvy21y0AChkjuAK+eFHEmq2RlxiKQ==
X-Received: by 2002:a65:5086:: with SMTP id r6mr4675339pgp.65.1630007226019;
        Thu, 26 Aug 2021 12:47:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x12sm3704611pfu.21.2021.08.26.12.47.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 12:47:05 -0700 (PDT)
Message-ID: <6127efb9.1c69fb81.5465c.a397@mx.google.com>
Date:   Thu, 26 Aug 2021 12:47:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.244-63-g95e0cf61b8df
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 150 runs,
 3 regressions (v4.14.244-63-g95e0cf61b8df)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 150 runs, 3 regressions (v4.14.244-63-g95e0c=
f61b8df)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.244-63-g95e0cf61b8df/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.244-63-g95e0cf61b8df
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      95e0cf61b8dfc6a48257b2edde3d0a9d9231fab3 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/6127c25192855ede5d8e2c78

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.244=
-63-g95e0cf61b8df/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.244=
-63-g95e0cf61b8df/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6127c25192855ede5d8e2c8c
        failing since 72 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-08-26T16:33:01.298118  /lava-4418812/1/../bin/lava-test-case
    2021-08-26T16:33:01.315437  [   16.334496] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-08-26T16:33:01.315929  /lava-4418812/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6127c25192855ede5d8e2ca5
        failing since 72 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-08-26T16:32:58.867507  /lava-4418812/1/../bin/lava-test-case
    2021-08-26T16:32:58.885746  [   13.903616] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-08-26T16:32:58.886232  /lava-4418812/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6127c25192855ede5d8e2ca6
        failing since 72 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-08-26T16:32:57.848370  /lava-4418812/1/../bin/lava-test-case
    2021-08-26T16:32:57.853763  [   12.884675] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
