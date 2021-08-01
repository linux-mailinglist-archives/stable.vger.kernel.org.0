Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF40F3DCB0C
	for <lists+stable@lfdr.de>; Sun,  1 Aug 2021 12:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbhHAKMN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Aug 2021 06:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231446AbhHAKMM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Aug 2021 06:12:12 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71702C06175F
        for <stable@vger.kernel.org>; Sun,  1 Aug 2021 03:12:05 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id nh14so9686155pjb.2
        for <stable@vger.kernel.org>; Sun, 01 Aug 2021 03:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=31EpGxgWAG+ilI4Vpr60aTkgVKn4zQLRG4cPiKHJ3C0=;
        b=RIF0WUsRZjXUmebjEz1rHGRfMXb4WV3C7KKzrZhFCZHky15yilQmF4AJQ95YsVOk96
         HFcLUaVUsyVmcpVpPzt8XSJJKY1+rdPHzJ6qh8qvf9yBLdeBQVVajLdX9B5nZXtmpHmk
         mpaD9MPHgGnTl1IBQxL/Lidvd0g96oDmWjPVVp/PtSCv+WCIOBBiBXJWD7yzD6PyiMIA
         jIKWYbztFlHhZsUQ5ntbiV0x2M0ie8AQIuCKy83qQO4bUviQaygffqyI+5LehISNXW4o
         di4KjjSHai6tZMwV5o3f7YIIouEeCXNB+WhcZ+RrcmNvWEsUdeOiRgaBocy3VPZ5sYxA
         lVvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=31EpGxgWAG+ilI4Vpr60aTkgVKn4zQLRG4cPiKHJ3C0=;
        b=nuLHjDi6oHMOu/37be8KV1enMCVwWQPm2ZFqTKJxmOGGfSbOwZNTJwelONSlMKJGTl
         k1aQ3oVc+vv/NIeIJk7uvx3Cq17PsgW5vlomVmCRKShRlz4d8I1hXpXRVTsFXEb7NL+P
         MC/O7AW7Uol6nzArcZnjt3Oqw90O5BqMZrPCkdhFXBF5ZjBjqTUFIgslW1HIWGFDQ010
         oYgqhtKuzRAIhxlH5IJi3Bt4lFKFl4ufFugC9J5W2VUEz/fuG2Qny5TMSZ5RSZ0P9ldU
         svpuye4MF4JKgc2j8awiK3TjWIHEALfXSpqwj0k9cfkU45lp5y3E1Jy2TeC265TGEiMd
         CjLQ==
X-Gm-Message-State: AOAM533vMqfx4xY8WizPA1timBETiMNAMOGmJ3Ee82tgRybP11fzjoMl
        h8dSUPgTRYs7pDAyY4ysL5dh/nebGdG+V++R
X-Google-Smtp-Source: ABdhPJwJGP2q1owARsoE3iRr/0FvTRvJ3ZRcGot+l9TaSXfItJ3Nbc48buR9s/GVcz9deUMmutgNgQ==
X-Received: by 2002:a17:90a:aa14:: with SMTP id k20mr12545484pjq.88.1627812724736;
        Sun, 01 Aug 2021 03:12:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f24sm7567279pjj.45.2021.08.01.03.12.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Aug 2021 03:12:04 -0700 (PDT)
Message-ID: <61067374.1c69fb81.73562.5400@mx.google.com>
Date:   Sun, 01 Aug 2021 03:12:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.137-35-g8b67247ad78e
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 193 runs,
 3 regressions (v5.4.137-35-g8b67247ad78e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 193 runs, 3 regressions (v5.4.137-35-g8b67247=
ad78e)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.137-35-g8b67247ad78e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.137-35-g8b67247ad78e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8b67247ad78e734b5078f688f24bb8121b66f04e =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/6106685f8a2d17fd0885f460

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.137-3=
5-g8b67247ad78e/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.137-3=
5-g8b67247ad78e/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6106685f8a2d17fd0885f474
        failing since 47 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-01T09:24:32.588385  /lava-4298986/1/../bin/lava-test-case<8>[  =
 15.932827] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-08-01T09:24:32.588964  =

    2021-08-01T09:24:32.589450  /lava-4298986/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6106685f8a2d17fd0885f48c
        failing since 47 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-01T09:24:31.145722  /lava-4298986/1/../bin/lava-test-case
    2021-08-01T09:24:31.164126  <8>[   14.508136] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-08-01T09:24:31.164652  /lava-4298986/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6106685f8a2d17fd0885f48d
        failing since 47 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-01T09:24:30.132580  /lava-4298986/1/../bin/lava-test-case<8>[  =
 13.488695] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-08-01T09:24:30.133108     =

 =20
