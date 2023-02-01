Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77C9F687196
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 00:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjBAXCD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 18:02:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjBAXCC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 18:02:02 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EADA6C114
        for <stable@vger.kernel.org>; Wed,  1 Feb 2023 15:02:01 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id h9so51121plf.9
        for <stable@vger.kernel.org>; Wed, 01 Feb 2023 15:02:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Cle77DqpeR+OMVkqRoIBUVAutJkhb6PtCfYge+6PG4Y=;
        b=kBDTN0h+YAZIxS2OVTwExo7blm61s+2RRfQ8rDiX/fkfFcp0LjT8B+7mGhM+dNKvgZ
         XOEWI9+1WXxLLrWzQ1GQ84ZjnrST5bhtlX7A5tZZ+BZMfCoJX6DKSYUj0XBmptMRbNpk
         JP4TESrJyOtWFGKuykoIlbfOIxSQH1lilAWjuX35o6Gilw95dHMiZXQEffxUvPyan996
         yhCxBVO6YPj2quIQ/r3VnzJwSr0TsVnASaXQhRbB/4MyiWtCMMSJNDjE2IJyPMCyy2bM
         blaXZO7hsn5RF+66X7ggFu8VRSaFLINMVQCenR8pGXP+CZK9CdPCC862UFXBY8knW4mm
         MFmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Cle77DqpeR+OMVkqRoIBUVAutJkhb6PtCfYge+6PG4Y=;
        b=hAI6SZlgbfqFeRQsfgRoiatqFBArUrEMBiga2fwdR/L4PxxzXGuUPwnNK+kLGkzqMY
         Mp/uGsQwCdE7ewPnRvbujSxdJN2++ooIts+t9LSM8aHWyEUWz7ESrXzf/jUZ9U+c5rPS
         Racx4p9WfOAzbN77BVdgr+Tj7UDe2c5Q7G3MMvIrZgoXRTugJv2skZ3kGBXX7GAnfF9v
         SRfln4bzPYzmPFC2oSggU+TBMxEbe31vBpdp6WJHnwfnzzdIdzyH5bRmmEiEvzmIMy/y
         pD4cBrEUZm68Xz8rVlm7BRyggJgNCchY7AK6JNWS+WhqcV3G32i79Ka0BkNJ2fQy8VfN
         owmA==
X-Gm-Message-State: AO0yUKWd5SjV2pROMxnp2WUhpJ+ZaVujmdSPdudZee+kz3DvJKP/efZN
        EjpXWjnYzQteZtJ0Ch2krUnRL9FuJ8e5t0qStlzUUQ==
X-Google-Smtp-Source: AK7set9mA6D7moMgkXwrEkAw1CpplnT7TCvmtuqAk6RDW8OCUZlO8w8wVWL1DzCjSpTVk2xKPn1SLA==
X-Received: by 2002:a05:6a20:4411:b0:be:9893:fd82 with SMTP id ce17-20020a056a20441100b000be9893fd82mr5335618pzb.23.1675292520386;
        Wed, 01 Feb 2023 15:02:00 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u7-20020a170902a60700b00192b0a07891sm12217232plq.101.2023.02.01.15.01.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 15:02:00 -0800 (PST)
Message-ID: <63daef68.170a0220.4ed00.5990@mx.google.com>
Date:   Wed, 01 Feb 2023 15:02:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.165-149-ge30e8271d674
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 143 runs,
 5 regressions (v5.10.165-149-ge30e8271d674)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 143 runs, 5 regressions (v5.10.165-149-ge30e=
8271d674)

Regressions Summary
-------------------

platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
at91-sama5d4_xplained        | arm   | lab-baylibre | gcc-10   | multi_v7_d=
efconfig | 1          =

cubietruck                   | arm   | lab-baylibre | gcc-10   | multi_v7_d=
efconfig | 1          =

rk3328-rock64                | arm64 | lab-baylibre | gcc-10   | defconfig =
         | 1          =

stm32mp157c-dk2              | arm   | lab-baylibre | gcc-10   | multi_v7_d=
efconfig | 1          =

sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre | gcc-10   | multi_v7_d=
efconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.165-149-ge30e8271d674/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.165-149-ge30e8271d674
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e30e8271d67421eb352f4cdc92111729f1cc7b18 =



Test Regressions
---------------- =



platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
at91-sama5d4_xplained        | arm   | lab-baylibre | gcc-10   | multi_v7_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63dabf8fcd2ffdb9c7915f56

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-149-ge30e8271d674/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-at91=
-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-149-ge30e8271d674/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-at91=
-sama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63dabf8fcd2ffdb9c7915=
f57
        new failure (last pass: v5.10.165-76-gffe5f229ddc9) =

 =



platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
cubietruck                   | arm   | lab-baylibre | gcc-10   | multi_v7_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63dabebde67b2d5f63915ec1

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-149-ge30e8271d674/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-149-ge30e8271d674/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63dabebde67b2d5f63915ec6
        failing since 6 days (last pass: v5.10.165-76-g5c2e982fcf18, first =
fail: v5.10.165-77-g4600242c13ed)

    2023-02-01T19:33:39.331306  <8>[   10.950455] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3266872_1.5.2.4.1>
    2023-02-01T19:33:39.442382  / # #
    2023-02-01T19:33:39.545866  export SHELL=3D/bin/sh
    2023-02-01T19:33:39.546707  #
    2023-02-01T19:33:39.648713  / # export SHELL=3D/bin/sh. /lava-3266872/e=
nvironment
    2023-02-01T19:33:39.650000  =

    2023-02-01T19:33:39.650717  / # <3>[   11.211398] Bluetooth: hci0: comm=
and 0xfc18 tx timeout
    2023-02-01T19:33:39.753151  . /lava-3266872/environment/lava-3266872/bi=
n/lava-test-runner /lava-3266872/1
    2023-02-01T19:33:39.754815  =

    2023-02-01T19:33:39.759545  / # /lava-3266872/bin/lava-test-runner /lav=
a-3266872/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
rk3328-rock64                | arm64 | lab-baylibre | gcc-10   | defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/63dabdc65a7bd7f310915ec6

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-149-ge30e8271d674/arm64/defconfig/gcc-10/lab-baylibre/baseline-rk3328-rock=
64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-149-ge30e8271d674/arm64/defconfig/gcc-10/lab-baylibre/baseline-rk3328-rock=
64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63dabdc65a7bd7f310915ecb
        failing since 1 day (last pass: v5.10.155-149-g63e308de12c9, first =
fail: v5.10.165-142-gc53eb88edf7e)

    2023-02-01T19:30:03.869386  [   15.944087] <LAVA_SIGNAL_ENDRUN 0_dmesg =
3266814_1.5.2.4.1>
    2023-02-01T19:30:03.975611  =

    2023-02-01T19:30:03.975755  / # #[   16.029537] rockchip-drm display-su=
bsystem: [drm] Cannot find any crtc or sizes
    2023-02-01T19:30:04.077292  export SHELL=3D/bin/sh
    2023-02-01T19:30:04.077737  =

    2023-02-01T19:30:04.179039  / # export SHELL=3D/bin/sh. /lava-3266814/e=
nvironment
    2023-02-01T19:30:04.179659  =

    2023-02-01T19:30:04.281312  / # . /lava-3266814/environment/lava-326681=
4/bin/lava-test-runner /lava-3266814/1
    2023-02-01T19:30:04.282124  =

    2023-02-01T19:30:04.285325  / # /lava-3266814/bin/lava-test-runner /lav=
a-3266814/1 =

    ... (13 line(s) more)  =

 =



platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
stm32mp157c-dk2              | arm   | lab-baylibre | gcc-10   | multi_v7_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63dabe964b1b78de91915ec1

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-149-ge30e8271d674/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-stm3=
2mp157c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-149-ge30e8271d674/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-stm3=
2mp157c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63dabe964b1b78de91915ec6
        new failure (last pass: v5.10.147-29-g9a9285d3dc114)

    2023-02-01T19:32:50.124287  <8>[   12.576069] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3266876_1.5.2.4.1>
    2023-02-01T19:32:50.229011  / # #
    2023-02-01T19:32:50.330828  export SHELL=3D/bin/sh
    2023-02-01T19:32:50.331297  #
    2023-02-01T19:32:50.432567  / # export SHELL=3D/bin/sh. /lava-3266876/e=
nvironment
    2023-02-01T19:32:50.433057  =

    2023-02-01T19:32:50.534392  / # . /lava-3266876/environment/lava-326687=
6/bin/lava-test-runner /lava-3266876/1
    2023-02-01T19:32:50.535222  =

    2023-02-01T19:32:50.538528  / # /lava-3266876/bin/lava-test-runner /lav=
a-3266876/1
    2023-02-01T19:32:50.604284  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre | gcc-10   | multi_v7_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63dabe9b9f4a02b6ae915ebb

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-149-ge30e8271d674/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-149-ge30e8271d674/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63dabe9b9f4a02b6ae915ec0
        new failure (last pass: v5.10.165-139-gefb57ce0f880)

    2023-02-01T19:33:10.772481  / # #
    2023-02-01T19:33:10.874646  export SHELL=3D/bin/sh
    2023-02-01T19:33:10.875356  #
    2023-02-01T19:33:10.976937  / # export SHELL=3D/bin/sh. /lava-3266880/e=
nvironment
    2023-02-01T19:33:10.977524  =

    2023-02-01T19:33:11.079141  / # . /lava-3266880/environment/lava-326688=
0/bin/lava-test-runner /lava-3266880/1
    2023-02-01T19:33:11.080084  =

    2023-02-01T19:33:11.083775  / # /lava-3266880/bin/lava-test-runner /lav=
a-3266880/1
    2023-02-01T19:33:11.147723  + export 'TESTRUN_ID=3D1_bootrr'
    2023-02-01T19:33:11.195499  + cd /lava-3266880/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
