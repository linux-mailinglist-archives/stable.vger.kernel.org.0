Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87B453F11F7
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 05:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237088AbhHSDip (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 23:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237331AbhHSDie (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Aug 2021 23:38:34 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8880C0612A6
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 20:37:58 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id w6so3102693plg.9
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 20:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cGu8xzU/DIUxEWSK52PzmQbDGAWcOH8UhghFht65qpU=;
        b=Mr+Cb/0bEfmUnWP2DpJEcjp63tVUysB4nD9a3dsTHZLIjV296IlUaVbVaLAuv1oJUJ
         cjm0HdnFQT2u4O7gItnLUy+mm8oST+RXYvKWKvVbxx8N22ArSccQoUba5JSxYM2FMnsg
         Ab9pS3Qd5fpWGMigMX5rD1etfhPFgfzJcvuIyIBvJ9Xjd1oXdo5ZAqfHlh1VKuPbUiy0
         7MOVDt8COyvvU7nBeKWd7lndmnz8/AghTpEpH06J6ikSdCikm1T7qZIxCx6Qz7ymFM/s
         JtP+EjXolKvEPbQpc6vYKnbBuKYqwvR2sDdOqxpSI8DdaTiU5hPFJEYN4D88bX7RJi5u
         33wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cGu8xzU/DIUxEWSK52PzmQbDGAWcOH8UhghFht65qpU=;
        b=UI8GCRsq07Eu5OxECNVHx90eS9pNQ+gMjsgKAJfYH9w7psSPef6zOCQH+MC3KT6I4B
         QvnkzyRb6gXhi2BYbnCxrMDUzg9rL4rDuXaw5GYdG2hcr4l4BQFlS/Dn/JoF6WcKBVOZ
         ppd5CkRgT7qHmf0WerXSlRzegoJtF4MjvMUT/VYdjFYlj/BoqOhDcHOi1W+tyIyuA1cN
         ajbeD2a6aalLfbqVairmkprG1HFFxJj23eS/OcHgIT2MmvUp8apvruWeHKVX5FUgbFqS
         c3FJVY8vZpOtOFXTtOx9uCZ24hW4C5EXOLsgWsEGEasMQL7VcMRdgyG3V5c/CbaFRbEW
         yzYQ==
X-Gm-Message-State: AOAM532EX+HHS4qIfk24od6mZY06foUUzjDvlEgcscR7pUFzmvFdeCxk
        diP9scs8TTXEioqYA0CtDAR5Wwwur2Bp8q6B
X-Google-Smtp-Source: ABdhPJw/zmdbBWGL9xiiAzjGeFYleD4pozNaDCXdCKE56c05XB3Gig0lcrPgJRa2H85j4gNJRsgvgg==
X-Received: by 2002:a17:90b:e08:: with SMTP id ge8mr12780208pjb.204.1629344278025;
        Wed, 18 Aug 2021 20:37:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p17sm1267678pfh.33.2021.08.18.20.37.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 20:37:57 -0700 (PDT)
Message-ID: <611dd215.1c69fb81.1e87e.5cf4@mx.google.com>
Date:   Wed, 18 Aug 2021 20:37:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.244-38-gc56c404cd987
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 115 runs,
 3 regressions (v4.14.244-38-gc56c404cd987)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 115 runs, 3 regressions (v4.14.244-38-gc56c4=
04cd987)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.244-38-gc56c404cd987/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.244-38-gc56c404cd987
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c56c404cd9873025b8b2d234b17c03035ec7d800 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/611da682e522cb6ba1b1367f

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.244=
-38-gc56c404cd987/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.244=
-38-gc56c404cd987/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/611da682e522cb6ba1b13697
        failing since 64 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-08-19T00:31:50.243560  /lava-4381271/1/../bin/lava-test-case
    2021-08-19T00:31:50.260991  [   16.470939] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-08-19T00:31:50.261218  /lava-4381271/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/611da682e522cb6ba1b136b0
        failing since 64 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-08-19T00:31:47.816565  /lava-4381271/1/../bin/lava-test-case
    2021-08-19T00:31:47.831039  [   14.039965] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-08-19T00:31:47.831268  /lava-4381271/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/611da682e522cb6ba1b136c7
        failing since 64 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-08-19T00:31:46.793641  /lava-4381271/1/../bin/lava-test-case
    2021-08-19T00:31:46.799565  [   13.021031] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
