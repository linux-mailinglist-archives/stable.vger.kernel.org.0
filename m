Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19D833BA699
	for <lists+stable@lfdr.de>; Sat,  3 Jul 2021 03:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbhGCBT6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Jul 2021 21:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbhGCBT6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Jul 2021 21:19:58 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E5ABC061762
        for <stable@vger.kernel.org>; Fri,  2 Jul 2021 18:17:24 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id h4so11587619pgp.5
        for <stable@vger.kernel.org>; Fri, 02 Jul 2021 18:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dpmKwSCIVhPjYqpoeFuGYALlAX4odi8OjiCwURw8H2Y=;
        b=mNhNN6xEe4r9rg8b09NjF06epUVJpe5XXilOsgzxBfwsO7rnOqY9Eix1HBHvkhPwZM
         4I2DRruCdHiBz5xTmF0LURgIWHyLP3adV3lvkk4PfAtKfL8hPwqEGxGKJyD3Uaf6mWh0
         PREog9chbaty3CBylybCDAKyKo8scsjECHAJJ8s6WvbFiz7KleiC8WQ9/smmoQJL/Zg6
         XxBmUs3u7mFo6WgrcIM+paxMty0EhKaq+7yr3AtgKBW0fhklXzm13vVFval+amcTsD/q
         5wG8Kxa9kCocRTISHlg2RTMgcq7yWFaO0SMvfHw9J/XNbt7jYOXyNoYr1xH6OmT82WUn
         UDLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dpmKwSCIVhPjYqpoeFuGYALlAX4odi8OjiCwURw8H2Y=;
        b=ldlRr9+/sQ+FfN406BYiOsIX9hot1l8zqrlqCRs+dMDm9fhrfWeGV4l2xuOLERBniS
         jxBFhtAmhyk0N7tSnH4pzDnpiOqgMMNTPZcFyfFmNjp/QPsp1E6QK4NqVLSNpSoV3GXo
         yfwPsOymWyrgYshDpeOip5eeKnN3mpjEpwLNC+4EifGwGwkOdkbm2TLFzajgVAA209xY
         TsfY00tUY/9a/hzXBDpiKPYVHsqk2ZxYuLGVinWeMFJ8dEVZag4YJBn+KB2TQ1Xq4v8B
         M8uOj3x0AzjGL4cm81m0IL6v+q83jddEoP4kLQ3SY35plo9oiW+kdp30+2OoKTUdX3A4
         SwVg==
X-Gm-Message-State: AOAM53173UhwZz/27iy7w/CCiUgjkH4CFPc5sZ5jibXafxmGWuDKEZ/I
        UmPe3xdxZDV/CL163V8FE37ibSO/OHw4jHJZ
X-Google-Smtp-Source: ABdhPJzEofa248yfQ7094qLUehwuLv9EI1cZGu98bHiT0Cq9S91lV4KphbRO5PI4oXyUVm/63aBhSQ==
X-Received: by 2002:a63:fa11:: with SMTP id y17mr2801783pgh.128.1625275043606;
        Fri, 02 Jul 2021 18:17:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a31sm5208131pgm.73.2021.07.02.18.17.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jul 2021 18:17:23 -0700 (PDT)
Message-ID: <60dfbaa3.1c69fb81.6fd70.2ff3@mx.google.com>
Date:   Fri, 02 Jul 2021 18:17:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.129-1-ged9a233c4a6ed
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 196 runs,
 4 regressions (v5.4.129-1-ged9a233c4a6ed)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 196 runs, 4 regressions (v5.4.129-1-ged9a233c=
4a6ed)

Regressions Summary
-------------------

platform          | arch   | lab           | compiler | defconfig          =
| regressions
------------------+--------+---------------+----------+--------------------=
+------------
d2500cc           | x86_64 | lab-clabbe    | gcc-8    | x86_64_defconfig   =
| 1          =

rk3288-veyron-jaq | arm    | lab-collabora | gcc-8    | multi_v7_defconfig =
| 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.129-1-ged9a233c4a6ed/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.129-1-ged9a233c4a6ed
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ed9a233c4a6ed5d717d0a9fdd51c81f1e21a1aae =



Test Regressions
---------------- =



platform          | arch   | lab           | compiler | defconfig          =
| regressions
------------------+--------+---------------+----------+--------------------=
+------------
d2500cc           | x86_64 | lab-clabbe    | gcc-8    | x86_64_defconfig   =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60df86b1a1bf41cd4011796e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.129-1=
-ged9a233c4a6ed/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.129-1=
-ged9a233c4a6ed/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60df86b1a1bf41cd40117=
96f
        new failure (last pass: v5.4.123-176-gd4db92620f28) =

 =



platform          | arch   | lab           | compiler | defconfig          =
| regressions
------------------+--------+---------------+----------+--------------------=
+------------
rk3288-veyron-jaq | arm    | lab-collabora | gcc-8    | multi_v7_defconfig =
| 3          =


  Details:     https://kernelci.org/test/plan/id/60df87b125a1cd83bb117995

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.129-1=
-ged9a233c4a6ed/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.129-1=
-ged9a233c4a6ed/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60df87b125a1cd83bb1179ad
        failing since 17 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-07-02T21:39:45.304399  /lava-4130216/1/../bin/lava-test-case<8>[  =
 14.280745] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-07-02T21:39:45.304778  =

    2021-07-02T21:39:45.305001  /lava-4130216/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60df87b125a1cd83bb1179c5
        failing since 17 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-07-02T21:39:43.863203  /lava-4130216/1/../bin/lava-test-case
    2021-07-02T21:39:43.868668  <8>[   12.856486] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60df87b125a1cd83bb1179c6
        failing since 17 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-07-02T21:39:42.844722  /lava-4130216/1/../bin/lava-test-case
    2021-07-02T21:39:42.849638  <8>[   11.836845] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
