Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 954D73D4117
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 21:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbhGWTGJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 15:06:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbhGWTGJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Jul 2021 15:06:09 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47702C061575
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 12:46:41 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id gv20-20020a17090b11d4b0290173b9578f1cso7084661pjb.0
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 12:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zwraOLLnR9u4al4RMWalfHrETxrJ8/+gO+hq3ztEnSw=;
        b=NwWkGxkN09EgEMzX4uiKL5rtxhleqkhkFa6Pr+x12/DFxcjtOdhFVQjARAFGI59VJd
         f44vmS5alvokZMfTJn5npcWgyv6VD7C5PRQzMlddUJAyknf4anQ0HsrBcGJYyioIUN9A
         /fL1xsrzZhg5/bJ48q9d5yvH0NmGCA0rpWfjot6mXYrgJvoPVRdR92Up3QVO6F2jH1aS
         jkV06MGuor0r7wVHT3yZQGt2meMANCjsEVkWVu7VvCE4ZCZSCYLNdGKnLEBuIucLK1Jf
         sn0SGBk5cWgMnM+EFB4uB5BVSuJIFClSGzfC/4CwwrNCwKin70UurjjTCyBh/ZS3QLVG
         V9Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zwraOLLnR9u4al4RMWalfHrETxrJ8/+gO+hq3ztEnSw=;
        b=br6JnQGfyu3LyoFH/ctc8E8CRldm4O5lzdaAxfgpBbMim/OfSRDngd6YJiPdsqlckV
         wHNljbuarG8B+xaDdmfgzp21+KputrKk4qeZEL+gyk0SZzoTQ+P69zc+IIz/UD0WaCWq
         AzY427q06UUk3KtrxQk3grW98Z/OvQuyaPOque9Ms742yFXIayWil9A/HVZdJgkHdbLj
         r2M507x8tWMRNoEsyZKv2oKPYVeXkYsN6DL0I6NAb+72F6NZ5GiR7DyRrNvnX64kzJ3W
         QaF2tn1YE+pX6oDgQDuKo2H3ywtDs0KeKdDGEz95zhvzGbZIUccpb8/N/++Fi2d5pT04
         ozWw==
X-Gm-Message-State: AOAM530WqBBTrcfbtiZ5lGCRB7dhnNfIKCKtNvqty0EffuHi7lte9RqC
        FN0WzWXN+7DfllV5OVsNlSPQFCgYIw0fFUf8
X-Google-Smtp-Source: ABdhPJxTghf3PkeW+OtJz1LkfrdbzAWgmGOGqXBSRudeKD6hVPlZS5m/dxp/tU3hd5d6lreGJN6sig==
X-Received: by 2002:aa7:82cb:0:b029:2e6:f397:d248 with SMTP id f11-20020aa782cb0000b02902e6f397d248mr6047189pfn.52.1627069600620;
        Fri, 23 Jul 2021 12:46:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 6sm3248149pfg.108.2021.07.23.12.46.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 12:46:40 -0700 (PDT)
Message-ID: <60fb1ca0.1c69fb81.8e02b.8c60@mx.google.com>
Date:   Fri, 23 Jul 2021 12:46:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.133-220-gf339372bde31
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 175 runs,
 4 regressions (v5.4.133-220-gf339372bde31)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 175 runs, 4 regressions (v5.4.133-220-gf33937=
2bde31)

Regressions Summary
-------------------

platform           | arch | lab           | compiler | defconfig          |=
 regressions
-------------------+------+---------------+----------+--------------------+=
------------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre  | gcc-8    | bcm2835_defconfig  |=
 1          =

rk3288-veyron-jaq  | arm  | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.133-220-gf339372bde31/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.133-220-gf339372bde31
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f339372bde310e814dd0aca2ab72b68f397aeb98 =



Test Regressions
---------------- =



platform           | arch | lab           | compiler | defconfig          |=
 regressions
-------------------+------+---------------+----------+--------------------+=
------------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre  | gcc-8    | bcm2835_defconfig  |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60fae0f9637c7680fe3a2f28

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.133-2=
20-gf339372bde31/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.133-2=
20-gf339372bde31/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/60fae0fa637c768=
0fe3a2f2f
        new failure (last pass: v5.4.133-220-g738aadf661ad7)
        1 lines

    2021-07-23T15:31:45.631015  kern  :alert : BUG: Bad page state in proce=
ss udevd  pfn:2a8e7
    2021-07-23T15:31:45.632364  <8>[   13.724335] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>   =

 =



platform           | arch | lab           | compiler | defconfig          |=
 regressions
-------------------+------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq  | arm  | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/60fafc33ae8ed029613a2f37

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.133-2=
20-gf339372bde31/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.133-2=
20-gf339372bde31/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60fafc33ae8ed029613a2f4a
        failing since 38 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-07-23T17:28:05.066453  /lava-4236917/1/../bin/lava-test-case<8>[  =
 15.052983] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-07-23T17:28:05.066845  =

    2021-07-23T17:28:05.067396  /lava-4236917/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60fafc33ae8ed029613a2f62
        failing since 38 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-07-23T17:28:03.624735  /lava-4236917/1/../bin/lava-test-case
    2021-07-23T17:28:03.642055  <8>[   13.627888] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-07-23T17:28:03.642326  /lava-4236917/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60fafc33ae8ed029613a2f63
        failing since 38 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-07-23T17:28:02.618450  /lava-4236917/1/../bin/lava-test-case<8>[  =
 12.608346] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-07-23T17:28:02.618775     =

 =20
