Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5B66C5354
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 19:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjCVSLA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 14:11:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjCVSK7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 14:10:59 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A2E45BD98
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 11:10:58 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id fb38so6752045pfb.7
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 11:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679508658;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=bod4g2w9DDZcGPpkx6EdCaazukT1224Nw1ig+7ETBuk=;
        b=UBz6StJRt+UvTWm0T9ufQeq56pl0RTjPoJ4GhYPVHkV6sAec+ry0q4/LuFCdfGb5fa
         H2TFxlZQMB6xneX2jQ9CLtUWnGx1Z0nd9ohJu86GbHM/Bl4QCvfdyIxifJIT0Kee0tKw
         MyRKJTXU4kzNXyGJBwOmZ3oPro1MC/UqY6w0NZO/ZhXv5jfsmZgcIwWr95BHAgqapbn9
         h+b98So7C071oSwcn/A1SqNzTLlgB/hjas6O7fPe26rz5G9GwakZcRbww2cJsdiUmfLT
         6XKPOWZlE0OAVX5VWrJyCDRBP7ro80ER8kjte13C6JBbjlM/6OAoXLdrODKLJnC42y9j
         wX5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679508658;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bod4g2w9DDZcGPpkx6EdCaazukT1224Nw1ig+7ETBuk=;
        b=FMqMDnFgpvtkHBk5NJ/yZD3G9ZyxvxCfYdtrqjTikpODtSa4kl1+gdt4vbB8omD5XA
         oXYTFR3dJxWlt+PFJHZz7S01qBI/AunJYfWGITeVY1Nx11h/XMxje/xI1x9a7QHtpLVA
         H6PKEm2on0T+oqh2gKuV2DGh+rNB2hPX5NI5poIreSqcXeCtRMow18FQtuVTQoywPZhf
         iAx9ix5teAYuaYtMkyVU8eD0Im5FVsKQ/c5hD9QbKLcCqZu+o+JYVsd1lV23f88P+SXE
         xdEZ9ii3kxQOebG2Fpk3RchvZrJ8H2qpWkz4W6W9wpB4zrszzklXNWtNxXx9DfoW9u5y
         7P3Q==
X-Gm-Message-State: AO0yUKXtjSAff42aS9EqdxBaygT/rO9vgJon2UdFEhmA+5K+l0Hth2HV
        PrDv0BMYNc/saR0hjxIVQhTQ2Kq0JCp5nK73cy4=
X-Google-Smtp-Source: AK7set9f2uoiJODGdjwT/ZaggbqARGWvTszUCQL+Ltk/d2tC2Z+Jeq5i5KX0GRywmSHtxrG2/68hFQ==
X-Received: by 2002:aa7:9597:0:b0:592:de72:4750 with SMTP id z23-20020aa79597000000b00592de724750mr3802710pfj.23.1679508657689;
        Wed, 22 Mar 2023 11:10:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i20-20020aa79094000000b005abbfa874d9sm9892866pfa.88.2023.03.22.11.10.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 11:10:57 -0700 (PDT)
Message-ID: <641b44b1.a70a0220.98183.1cda@mx.google.com>
Date:   Wed, 22 Mar 2023 11:10:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.175-98-g07e9a8a803e3
Subject: stable-rc/queue/5.10 baseline: 138 runs,
 5 regressions (v5.10.175-98-g07e9a8a803e3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 138 runs, 5 regressions (v5.10.175-98-g07e9a=
8a803e3)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
beaglebone-black             | arm   | lab-broonie   | gcc-10   | omap2plus=
_defconfig        | 1          =

cubietruck                   | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig         | 1          =

rk3399-gru-kevin             | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 2          =

sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.175-98-g07e9a8a803e3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.175-98-g07e9a8a803e3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      07e9a8a803e31f2285e45bfcc9ea3531e2f0d85e =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
beaglebone-black             | arm   | lab-broonie   | gcc-10   | omap2plus=
_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/641b0a75ff8f7a75719c953c

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-98-g07e9a8a803e3/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beagl=
ebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-98-g07e9a8a803e3/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beagl=
ebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/641b0a75ff8f7a75719c9571
        failing since 36 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-03-22T14:02:10.015557  <8>[   18.702714] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 207576_1.5.2.4.1>
    2023-03-22T14:02:10.124427  / # #
    2023-03-22T14:02:10.226336  export SHELL=3D/bin/sh
    2023-03-22T14:02:10.226843  #
    2023-03-22T14:02:10.328487  / # export SHELL=3D/bin/sh. /lava-207576/en=
vironment
    2023-03-22T14:02:10.328955  =

    2023-03-22T14:02:10.430450  / # . /lava-207576/environment/lava-207576/=
bin/lava-test-runner /lava-207576/1
    2023-03-22T14:02:10.431270  =

    2023-03-22T14:02:10.435837  / # /lava-207576/bin/lava-test-runner /lava=
-207576/1
    2023-03-22T14:02:10.546042  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
cubietruck                   | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/641b0cde5193e051f29c9534

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-98-g07e9a8a803e3/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-98-g07e9a8a803e3/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/641b0cde5193e051f29c953d
        failing since 55 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-03-22T14:12:38.300406  + set +x<8>[   11.108597] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3434809_1.5.2.4.1>
    2023-03-22T14:12:38.301119  =

    2023-03-22T14:12:38.412865  / # #
    2023-03-22T14:12:38.516369  export SHELL=3D/bin/sh
    2023-03-22T14:12:38.517397  #<3>[   11.211154] Bluetooth: hci0: command=
 0xfc18 tx timeout
    2023-03-22T14:12:38.518038  =

    2023-03-22T14:12:38.620372  / # export SHELL=3D/bin/sh. /lava-3434809/e=
nvironment
    2023-03-22T14:12:38.621497  =

    2023-03-22T14:12:38.723943  / # . /lava-3434809/environment/lava-343480=
9/bin/lava-test-runner /lava-3434809/1
    2023-03-22T14:12:38.725693   =

    ... (13 line(s) more)  =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
rk3399-gru-kevin             | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 2          =


  Details:     https://kernelci.org/test/plan/id/641b0d5d07f1dca1b29c9505

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-98-g07e9a8a803e3/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-98-g07e9a8a803e3/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/641b0d5d07f1dca1b29c950f
        failing since 8 days (last pass: v5.10.172-529-g06956b9e9396, first=
 fail: v5.10.173-69-gfcbe6bd469ed)

    2023-03-22T14:14:39.518248  <8>[   34.828126] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>

    2023-03-22T14:14:40.542482  /lava-9731162/1/../bin/lava-test-case

    2023-03-22T14:14:40.553701  <8>[   35.864225] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/641b0d5d07f1dca1b29c9510
        failing since 8 days (last pass: v5.10.172-529-g06956b9e9396, first=
 fail: v5.10.173-69-gfcbe6bd469ed)

    2023-03-22T14:14:39.507069  /lava-9731162/1/../bin/lava-test-case
   =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/641b0c6e71f12ad5f29c953c

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-98-g07e9a8a803e3/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i=
-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-98-g07e9a8a803e3/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i=
-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/641b0c6e71f12ad5f29c9545
        failing since 48 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-03-22T14:10:32.633231  <8>[    8.390507] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3434806_1.5.2.4.1>
    2023-03-22T14:10:32.738490  / # #
    2023-03-22T14:10:32.840231  export SHELL=3D/bin/sh
    2023-03-22T14:10:32.840884  #
    2023-03-22T14:10:32.942350  / # export SHELL=3D/bin/sh. /lava-3434806/e=
nvironment
    2023-03-22T14:10:32.942717  =

    2023-03-22T14:10:33.044035  / # . /lava-3434806/environment/lava-343480=
6/bin/lava-test-runner /lava-3434806/1
    2023-03-22T14:10:33.044941  =

    2023-03-22T14:10:33.050595  / # /lava-3434806/bin/lava-test-runner /lav=
a-3434806/1
    2023-03-22T14:10:33.164610  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =20
