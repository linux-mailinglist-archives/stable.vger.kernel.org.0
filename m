Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B83893D6BF4
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 04:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234251AbhG0Btp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 21:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233727AbhG0Btm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Jul 2021 21:49:42 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A73D1C061757
        for <stable@vger.kernel.org>; Mon, 26 Jul 2021 19:30:10 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id e21so9544372pla.5
        for <stable@vger.kernel.org>; Mon, 26 Jul 2021 19:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=E0wRbI4uqX6ZlKBBN8vIGcrdhzZSro5STS/NSL0sYIY=;
        b=Luo6ICv//3tNMK8IqFvvJw2rX1dFzEQ8y/vyOrk4PoVNAkeucTF3XhO8VtXU1lWiRr
         7OoFKIiw+eXe7JXk55SJMdYdtxVNe5XlMkq+MuF3+8uIXF29pGnaasm0OtdS2Og/cCSC
         lJa+C+JBQjJHgrHJI1zZmD+8hhp4XvUhKloeemZKUOdAvmK6ZeWGzuRd2lShOmsrRI8l
         /oBj1bqVC6D3aaYXRGe7m1vn6SNh9CkOYEd57vYDXMlhwe4s1Mr6bbG/vHhDNZ2fLrtP
         rIwghxdfrzupoLdnxsO0cNMJVVre30lNaMDo+ZEGMgi+21NHeQAEpXSJFrN24J5ZgEnF
         0oZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=E0wRbI4uqX6ZlKBBN8vIGcrdhzZSro5STS/NSL0sYIY=;
        b=HgVBbdDPKA1jPA5xOarg2xuPTb/WK6wpTdmQc50lc85uAuxsFIj+iaBEl1qlx4HHOn
         NDxeb3iNz+JYDo8v3rl6HTi2wJv1d5p4BbFXqdBgMht8RmLJ2YWWpQ14ww+3KFMnQcDE
         Fl2r1DLd/KfUC7718QgYUbq1p98ECdFnmKqAgASbGcYLOmITXRI9IeDwPR6VjX+S7PDi
         +oh4OtNcxcM/Hl6YguKg19midc4hknEuCGgsZ6w/9Fo/KIz16Jf21jL8zrLZH/VKPQG4
         MeRV2H4feLWSFP+7p6lhu//Q2+km9JOMLMxAFrgAYdGijRiREQJwVmskoynn6Cao6hKk
         HDCw==
X-Gm-Message-State: AOAM531I4zGNVivgSUoZ/o2Z1QcvK7ZCWfDMrPdJKLtd3K6lqTF29soI
        KSSAfpXLgVyZZ9LsvHyjBZy/NwOTdGPa9c6y
X-Google-Smtp-Source: ABdhPJwawhFgEm9FOcmqTbDZ1htBGKfruoZRsTIXWA5CRKWQi2xytvxD7qrwW9stNvGGc/zmFI2HsA==
X-Received: by 2002:aa7:9115:0:b029:359:69db:bc89 with SMTP id 21-20020aa791150000b029035969dbbc89mr20780749pfh.32.1627353009954;
        Mon, 26 Jul 2021 19:30:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ce15sm834252pjb.48.2021.07.26.19.30.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 19:30:09 -0700 (PDT)
Message-ID: <60ff6fb1.1c69fb81.cef92.402d@mx.google.com>
Date:   Mon, 26 Jul 2021 19:30:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.53
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
Subject: stable/linux-5.10.y baseline: 127 runs, 4 regressions (v5.10.53)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 127 runs, 4 regressions (v5.10.53)

Regressions Summary
-------------------

platform          | arch   | lab           | compiler | defconfig          =
          | regressions
------------------+--------+---------------+----------+--------------------=
----------+------------
d2500cc           | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon...6-c=
hromebook | 1          =

rk3288-veyron-jaq | arm    | lab-collabora | gcc-8    | multi_v7_defconfig =
          | 3          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.53/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.53
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      71046eac2db9aeccf10763d034a1a123911c9a81 =



Test Regressions
---------------- =



platform          | arch   | lab           | compiler | defconfig          =
          | regressions
------------------+--------+---------------+----------+--------------------=
----------+------------
d2500cc           | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon...6-c=
hromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/60ff36eedc7cee11c43a2f31

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.53/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/baseline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.53/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/baseline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ff36eedc7cee11c43a2=
f32
        failing since 6 days (last pass: v5.10.49, first fail: v5.10.51) =

 =



platform          | arch   | lab           | compiler | defconfig          =
          | regressions
------------------+--------+---------------+----------+--------------------=
----------+------------
rk3288-veyron-jaq | arm    | lab-collabora | gcc-8    | multi_v7_defconfig =
          | 3          =


  Details:     https://kernelci.org/test/plan/id/60ff68825b2ea0e1de3a2f48

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.53/a=
rm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.53/a=
rm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60ff68825b2ea0e1de3a2f5c
        failing since 40 days (last pass: v5.10.43, first fail: v5.10.44)

    2021-07-27T01:59:24.756662  /lava-4250759/1/../bin/lava-test-case
    2021-07-27T01:59:24.773973  <8>[   13.785205] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-07-27T01:59:24.774211  /lava-4250759/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60ff68825b2ea0e1de3a2f74
        failing since 40 days (last pass: v5.10.43, first fail: v5.10.44)

    2021-07-27T01:59:23.332375  /lava-4250759/1/../bin/lava-test-case
    2021-07-27T01:59:23.349813  <8>[   12.360853] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-07-27T01:59:23.350050  /lava-4250759/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60ff68825b2ea0e1de3a2f75
        failing since 40 days (last pass: v5.10.43, first fail: v5.10.44)

    2021-07-27T01:59:22.312697  /lava-4250759/1/../bin/lava-test-case
    2021-07-27T01:59:22.318558  <8>[   11.341314] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
