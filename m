Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0713C3EE3
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 21:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbhGKTqS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 15:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhGKTqR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 15:46:17 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC015C0613DD
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 12:43:29 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id m83so6537028pfd.0
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 12:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+LD95yIRyVdq/myfuZXzJBVrxsflYTx5YuuIXGX3CnE=;
        b=VfdHm7qVicxnH6wsJ4Mc89oX0GODDcddVZMpwZieUrWm9U/6gHqSpfbTK5zf0MvA4e
         t71ez2ZvSLq282Pw917WoyfYBjbmZMxESd0xYSu+enQ3BSXnmpk77+PRVHMQUfiDqc1W
         qM7TEEz/5hOqgJN2mQhV+RtKS9h7eQaB2lG0MdPuVBnQ4agxxH96TlS8ihJrLtFCmi+t
         ZjRLmFaR8a0UfoqB3/FiY+v/q67MSrEqsKw3ajaHQ1HhKMEPHJbmXlM6aXJ+3bZL7R+4
         lGmPSUGSsRC6c8VKpf2mmV9mLQNxLsS7VdbxUx5v/SfeMbyNvx/FlYV3/tJThcaHrStf
         Ekbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+LD95yIRyVdq/myfuZXzJBVrxsflYTx5YuuIXGX3CnE=;
        b=kJ83diVhRciGq3JNPywwEt/yQBCPf6SGWdFmYpR8CGQ2lQ2AOipaxazNbPsExIrHWi
         KK8rjxP1MbW7Irgpp3jgr6Fn38uFMVexyVFU0ExCfPrfBPtXKdXH/r4Pd/E8j/1bhp2r
         rl2a0bNbcha6WfvgBlD/MaN/FQgKGHhuIZ4MyMPvJ5QYNY2ua609B6t1igIB3XzHYY3l
         dkaGYeDfUqrjYPz5FrE2yUs8TR1U39MW+J33qZBRfqXOpNJbMdfRtLyITFNGxHB37U1T
         5iAXR5tz2BlAY153+uAtnA5hDofpDiCBxnyxm5KjrW58eRm3q0qwZBKnRJAfiI9u3M1O
         PHoA==
X-Gm-Message-State: AOAM530cLDH56N6Ov5T771nXyvY6wIUHNJLnFvttjdMot2T7VutYW0Vf
        oT2z9jMqWLEeOJl72WT9c4Bl2fFHsamygm+f
X-Google-Smtp-Source: ABdhPJzDb4hd8wG9NJOe3i738royrmBeQjWrMIl0wxYj3UWAEW6UB58wcRcNLn+ciO1c0cMqpgmw7w==
X-Received: by 2002:a65:4244:: with SMTP id d4mr49869208pgq.83.1626032609024;
        Sun, 11 Jul 2021 12:43:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j15sm12905361pfh.194.2021.07.11.12.43.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 12:43:28 -0700 (PDT)
Message-ID: <60eb49e0.1c69fb81.db0e1.607d@mx.google.com>
Date:   Sun, 11 Jul 2021 12:43:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.131-344-g7da707277666
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 183 runs,
 5 regressions (v5.4.131-344-g7da707277666)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 183 runs, 5 regressions (v5.4.131-344-g7da707=
277666)

Regressions Summary
-------------------

platform          | arch   | lab           | compiler | defconfig          =
          | regressions
------------------+--------+---------------+----------+--------------------=
----------+------------
d2500cc           | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon...6-c=
hromebook | 1          =

d2500cc           | x86_64 | lab-clabbe    | gcc-8    | x86_64_defconfig   =
          | 1          =

rk3288-veyron-jaq | arm    | lab-collabora | gcc-8    | multi_v7_defconfig =
          | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.131-344-g7da707277666/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.131-344-g7da707277666
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7da70727766668141a6597cb26ad2a05566214ae =



Test Regressions
---------------- =



platform          | arch   | lab           | compiler | defconfig          =
          | regressions
------------------+--------+---------------+----------+--------------------=
----------+------------
d2500cc           | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon...6-c=
hromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb16db690a534e96117973

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.131-3=
44-g7da707277666/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/ba=
seline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.131-3=
44-g7da707277666/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/ba=
seline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb16db690a534e96117=
974
        new failure (last pass: v5.4.130-4-g2151dbfa7bb2) =

 =



platform          | arch   | lab           | compiler | defconfig          =
          | regressions
------------------+--------+---------------+----------+--------------------=
----------+------------
d2500cc           | x86_64 | lab-clabbe    | gcc-8    | x86_64_defconfig   =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb186b9ea1e341021179ad

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.131-3=
44-g7da707277666/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.131-3=
44-g7da707277666/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb186b9ea1e34102117=
9ae
        new failure (last pass: v5.4.130-4-g2151dbfa7bb2) =

 =



platform          | arch   | lab           | compiler | defconfig          =
          | regressions
------------------+--------+---------------+----------+--------------------=
----------+------------
rk3288-veyron-jaq | arm    | lab-collabora | gcc-8    | multi_v7_defconfig =
          | 3          =


  Details:     https://kernelci.org/test/plan/id/60eb2a93fe4b0be5be11796d

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.131-3=
44-g7da707277666/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.131-3=
44-g7da707277666/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60eb2a93fe4b0be5be117980
        failing since 26 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-07-11T17:29:48.715026  /lava-4176568/1/../bin/lava-test-case<8>[  =
 14.817657] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-07-11T17:29:48.715491  =

    2021-07-11T17:29:48.715787  /lava-4176568/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60eb2a94fe4b0be5be117998
        failing since 26 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-07-11T17:29:47.272511  /lava-4176568/1/../bin/lava-test-case
    2021-07-11T17:29:47.290523  <8>[   13.393300] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-07-11T17:29:47.290796  /lava-4176568/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60eb2a94fe4b0be5be117999
        failing since 26 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-07-11T17:29:46.259168  /lava-4176568/1/../bin/lava-test-case<8>[  =
 12.373864] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-07-11T17:29:46.259676     =

 =20
