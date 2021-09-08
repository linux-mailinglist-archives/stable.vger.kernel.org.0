Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9DCA403249
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 03:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346971AbhIHBoB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Sep 2021 21:44:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346698AbhIHBnz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Sep 2021 21:43:55 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 612C0C061575
        for <stable@vger.kernel.org>; Tue,  7 Sep 2021 18:42:48 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id u1so302609plq.5
        for <stable@vger.kernel.org>; Tue, 07 Sep 2021 18:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JGagQsuajAUhezEaxy3S/UY2KFqWwtYtT1LtkNptB8Y=;
        b=kw7UVPAkMar02ps/AYUm+PbCYrx/89+GnrQ3FG+Hs5c86l6DeKFwzV03ZcX+WZ8CLf
         eOLmKbae9E4BigrRbH/4+1SCoeqDgCFW/2Vqxsh/ZyiuE6b84kLzd5/EFDLyArKme5A4
         L1sD/MV+Xe/kTDrmva+bJ4MU7rXP2LLdBjvifvWQDCxTl/2TKtHTFQe54QYjhOHxPzZ3
         iK+QOMz8mshK5PeGguMw91vF7rNyN6IjYA85bpVh655RXgTEcK9h7ous2XJD8dtjPPGl
         er3Mew/Zk0MSvrTICuUqb8812UUc+SUTGZkSamUkpxbvu6ksP2YZ09t3pivqgP42Geg1
         XVDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JGagQsuajAUhezEaxy3S/UY2KFqWwtYtT1LtkNptB8Y=;
        b=Pza5CQ3gqZymnR7EzaIUYo7C4ZBRHzisArPN55fYt/0Xv5xsmNxnAYUyZ1iBsFQjlW
         kZuPWpblYA9FIUzsrBw3Jjo+OulHAHg6TJGoGrk8tH12v/n1g/vJzKRaVQ/uO8gdUpya
         L+G43IK3KAJXgCbiMKu0p4ED704z16DEieHtKa/RC1tZM171pZZdlMTWGOppLCfhtM/y
         1AsuQ//QFYSilqmjsaUIiHfwpHNGsL2hTbZTT2FWYaF06jXcG3Wk9cZsJ6MwjPmAkHPE
         rItYSiqdGFNdWaHY4Sv7yqKkU7XrBnszUA0VS6fT27vFYQlvonwurKkYzND+23hLmPQl
         o2vg==
X-Gm-Message-State: AOAM532I7MEWCMQTtCbHtenmW1MErmhuqsjq7+l6hbXtlBEmE3WDCdXe
        spy+Uw6syZ5fMMpL0IJu0v3P9R0UlaSzwhMc
X-Google-Smtp-Source: ABdhPJyZfldI8rNzTQMWEz6+CDtG5rtF+dTVL2TVTkZ3nFxC2ZX+/V4HRUIw6zXb8+11xPnM2Ewbxg==
X-Received: by 2002:a17:90b:1b06:: with SMTP id nu6mr641750pjb.15.1631065367803;
        Tue, 07 Sep 2021 18:42:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q29sm392016pgc.91.2021.09.07.18.42.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 18:42:47 -0700 (PDT)
Message-ID: <61381517.1c69fb81.56ac1.2809@mx.google.com>
Date:   Tue, 07 Sep 2021 18:42:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.144-21-gb97123bcdebe
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 221 runs,
 3 regressions (v5.4.144-21-gb97123bcdebe)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 221 runs, 3 regressions (v5.4.144-21-gb97123b=
cdebe)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.144-21-gb97123bcdebe/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.144-21-gb97123bcdebe
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b97123bcdebe234536f8f276dd1a68c59fedd583 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/6137e92265d574b6d9d59677

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.144-2=
1-gb97123bcdebe/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.144-2=
1-gb97123bcdebe/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6137e92365d574b6d9d5968b
        failing since 84 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-09-07T22:34:59.593178  /lava-4469690/1/../bin/lava-test-case
    2021-09-07T22:34:59.609610  <8>[   15.341075] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-09-07T22:34:59.610063  /lava-4469690/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6137e92365d574b6d9d596a1
        failing since 84 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-09-07T22:34:58.185855  /lava-4469690/1/../bin/lava-test-case<8>[  =
 13.915993] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-09-07T22:34:58.186190  =

    2021-09-07T22:34:58.186413  /lava-4469690/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6137e92365d574b6d9d596a2
        failing since 84 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-09-07T22:34:57.148071  /lava-4469690/1/../bin/lava-test-case
    2021-09-07T22:34:57.153836  <8>[   12.896316] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
