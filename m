Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 374543B7C0B
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 05:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbhF3DUh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 23:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233038AbhF3DUg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Jun 2021 23:20:36 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF5C9C061760
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 20:18:07 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id x22so653564pll.11
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 20:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6kpVGQNnA9nLVsxnG6Vu85f+CcQmjdLaelxlq9Z4SjI=;
        b=rzGClwkOn3vHHIwAiLqe2yNb2MkG9zfzck3SM5/mmMrjg0YhHXCSs6+UDGD2UuXMBJ
         QHLM8aTNefkVEO41jQxBfZEHIIu2Fe204qE55rtfCRmhJjJfcSOMY6p6FG5iB2Tj69tA
         aCg+iFKRjxEskRHWcKWvnfY2csR/6jQGrpVDZhrMXvOiwOvdGfTeATijd+24C/wHcgkF
         pFMAFnTD2HQYAUH4ycitC78OIeJVDarGyrHoMB67cKmSAB19bPGf0Gx9He4Se30blS9P
         1sETAPLfc9sHkBaiEH+XrBVWvXS3Hs0zqgBnj/v8qZcxEKLjzQ5Ja3cCEpZ69u/oxytr
         tk+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6kpVGQNnA9nLVsxnG6Vu85f+CcQmjdLaelxlq9Z4SjI=;
        b=hmytQYN7HIao2jKG1aj3c/Akzrbd+7SapWS1R0813jgTnAp4thQClbrsAHkg2VbS2l
         d38Cwzvj9AhhAwxNJxesD9y8MnOj8KCPgwpInDnm25S8oce1yCijO+WxPkpW9/PwGbFQ
         F9mtG/Yo3pEwQ5RlFfFr0sGoSK4osFfiPOyZA3iEdiZHdUxB4IxIFgWur+oZOG0xxluj
         H7A8Lqgv4JUb8KPZ7ENAg/1BrMquyVUlIietdDp7N1J3750AITm+eo+/SBZ8F3NpKa8U
         G1NmxuKzBi8RjUdY1QA/zxsdS1r/frrvDuJCuJcEk3hlgtlOjAqeDPAnJ0mQnsxg9I8u
         HTVA==
X-Gm-Message-State: AOAM531uiirt2MRNIJhgJUnrs+ABC6cDCWAdgZEDnGm8Yd0hcozamMgf
        lz6g1AlfmbuHHXroVYi6YNlmoPM6hHpF73KA
X-Google-Smtp-Source: ABdhPJy7yxihq9/g/5LlIK/tVKfhU3gx+PZySOhRYy1+mBvGPHQ0u7xqpMOnINX6YM0V1T91qxVJsA==
X-Received: by 2002:a17:902:da8c:b029:127:a075:cb with SMTP id j12-20020a170902da8cb0290127a07500cbmr26978468plx.26.1625023086999;
        Tue, 29 Jun 2021 20:18:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a15sm19331065pff.128.2021.06.29.20.18.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 20:18:06 -0700 (PDT)
Message-ID: <60dbe26e.1c69fb81.8a250.a256@mx.google.com>
Date:   Tue, 29 Jun 2021 20:18:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.237-87-g40c926756603e
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 132 runs,
 4 regressions (v4.14.237-87-g40c926756603e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 132 runs, 4 regressions (v4.14.237-87-g40c92=
6756603e)

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
nel/v4.14.237-87-g40c926756603e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.237-87-g40c926756603e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      40c926756603e67f4d2ac559d79a170e554e7125 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
meson-gxm-q200    | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60dbd5576f6c5079e723bbd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.237=
-87-g40c926756603e/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.237=
-87-g40c926756603e/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60dbd5576f6c5079e723b=
bd2
        failing since 120 days (last pass: v4.14.222-11-g13b8482a0f700, fir=
st fail: v4.14.222-120-gdc8887cba23e) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/60dbdce9f6e60ee64723bbd4

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.237=
-87-g40c926756603e/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.237=
-87-g40c926756603e/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60dbdce9f6e60ee64723bbed
        failing since 14 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-06-30T02:54:26.120345  /lava-4115698/1/../bin/lava-test-case
    2021-06-30T02:54:26.125458  [   13.016382] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60dbdce9f6e60ee64723bbee
        failing since 14 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-06-30T02:54:27.139324  /lava-4115698/1/../bin/lava-test-case
    2021-06-30T02:54:27.156503  [   14.035016] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-06-30T02:54:27.156756  /lava-4115698/1/../bin/lava-test-case   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60dbdceaf6e60ee64723bc07
        failing since 14 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-06-30T02:54:29.569380  /lava-4115698/1/../bin/lava-test-case
    2021-06-30T02:54:29.585433  [   16.464940] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-06-30T02:54:29.585719  /lava-4115698/1/../bin/lava-test-case   =

 =20
