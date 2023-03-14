Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 951856B8AD2
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 06:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjCNFwh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 01:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCNFwg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 01:52:36 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D95998B307
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 22:52:34 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id k2so7567645pll.8
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 22:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678773154;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=BW8hWHfdIXKqDlk6xK+kZeOyP52xSOxFVditRc6Qk+E=;
        b=C0BZ/+g+kEjyEWeg+MDLTRRUQgtQgJSYdAZBFDBmws0P7/XAlRf+g1Blkm28a9zB/w
         Y69PfgB84KRl43RLnArcWld5vC4JGGl49NzHbKcevB3P7SGxCc1GfsWBVCD9ruREKs3Y
         z0lvwxYTKjLVc4USSoikjGEWCo6pKXwHj6ggJqFf//x96IdGRCuG0Rr4bCqogT1XI++M
         CaMfUUl8OPRGDmgXn7Ds6Mkbt08vJK282Z8EsUIz2Rinb418sxeq2cPmERtUm6YXwyjy
         Zu3+Ko07msy3brMC0bDRTAu14r3krnaSUsJSBbMW6TafIobsU7ecTvGPinyhtgUQ3oxn
         HWkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678773154;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BW8hWHfdIXKqDlk6xK+kZeOyP52xSOxFVditRc6Qk+E=;
        b=J79a+2QZ8BKlePs+CH8hHAvTy07SE4Te7Rpa0swbHP6NdqkfQ8jftTbg43NRnxmKOR
         MQU8MO3joDdasI8oJAi8G7wpFhRtTJ2O+TFqikGvj+W++fhfD5fm94H7YsbCi0vQif6u
         XM6sBS1ZpTJZlIKdJCP5Zo7lStSSfWaDClDF4ld3FXq5tsdn0sM9x1EBEG/vtqbh6xjt
         YY7wsJM32Z4R6O7yku6ggyDv5Mc+fhxRHAriBGDIlrLKemmRu4842f/pQQ0Dmv4P0avE
         vXydmhmRp2RgaD+bOstDR7aRzmc5+G9HHW5nh4BGfaJtaOniaES1Odpofqf/3m8L3gDr
         rnhA==
X-Gm-Message-State: AO0yUKX1XII0Ma5/cl5xgJYfhsqiYSvMcDEhZvLp/t5KlROPRrMVmuLa
        o2mvTCW/1fh+387gLxvXNBOJznAEBAUS2t6suiIQRm9s
X-Google-Smtp-Source: AK7set/XCw0RM0JU5IYzEQKO0wDXFn6NT32i8BtMymGStM9u7eTZN+OaQLAsacJu5ic1WImMg00k1g==
X-Received: by 2002:a05:6a20:e688:b0:cc:aec0:e9b with SMTP id mz8-20020a056a20e68800b000ccaec00e9bmr34367824pzb.19.1678773154014;
        Mon, 13 Mar 2023 22:52:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b16-20020aa78110000000b006251e1fdd1fsm637481pfi.200.2023.03.13.22.52.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 22:52:33 -0700 (PDT)
Message-ID: <64100ba1.a70a0220.2c38a.1baf@mx.google.com>
Date:   Mon, 13 Mar 2023 22:52:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.173-69-gfcbe6bd469ed
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 168 runs,
 5 regressions (v5.10.173-69-gfcbe6bd469ed)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 168 runs, 5 regressions (v5.10.173-69-gfcbe6=
bd469ed)

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
nel/v5.10.173-69-gfcbe6bd469ed/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.173-69-gfcbe6bd469ed
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fcbe6bd469edb18a9764f8fbbabe9941a137ae29 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
beaglebone-black             | arm   | lab-broonie   | gcc-10   | omap2plus=
_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/640fd89e6c17db7d828c8689

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-69-gfcbe6bd469ed/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beagl=
ebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-69-gfcbe6bd469ed/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beagl=
ebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640fd89e6c17db7d828c86c2
        failing since 28 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-03-14T02:14:33.122516  <8>[   16.833331] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 155580_1.5.2.4.1>
    2023-03-14T02:14:33.285303  / # #
    2023-03-14T02:14:33.399851  export SHELL=3D/bin/sh
    2023-03-14T02:14:33.406201  #
    2023-03-14T02:14:33.515799  / # export SHELL=3D/bin/sh. /lava-155580/en=
vironment
    2023-03-14T02:14:33.521558  =

    2023-03-14T02:14:33.631246  / # . /lava-155580/environment/lava-155580/=
bin/lava-test-runner /lava-155580/1
    2023-03-14T02:14:33.642212  =

    2023-03-14T02:14:33.646849  / # /lava-155580/bin/lava-test-runner /lava=
-155580/1
    2023-03-14T02:14:33.746007  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
cubietruck                   | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/640fd9bb28532030698c8692

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-69-gfcbe6bd469ed/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-69-gfcbe6bd469ed/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640fd9bb28532030698c869b
        failing since 46 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-03-14T02:19:23.619163  + set +x<8>[   11.107979] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3408992_1.5.2.4.1>
    2023-03-14T02:19:23.620079  =

    2023-03-14T02:19:23.736844  / # #
    2023-03-14T02:19:23.840088  export SHELL=3D/bin/sh
    2023-03-14T02:19:23.840505  #
    2023-03-14T02:19:23.941846  / # export SHELL=3D/bin/sh. /lava-3408992/e=
nvironment
    2023-03-14T02:19:23.942792  =

    2023-03-14T02:19:23.943256  / # <3>[   11.370955] Bluetooth: hci0: comm=
and 0xfc18 tx timeout
    2023-03-14T02:19:24.045252  . /lava-3408992/environment/lava-3408992/bi=
n/lava-test-runner /lava-3408992/1
    2023-03-14T02:19:24.046858   =

    ... (13 line(s) more)  =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
rk3399-gru-kevin             | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 2          =


  Details:     https://kernelci.org/test/plan/id/640fd7875eff173f608c86a5

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-69-gfcbe6bd469ed/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-69-gfcbe6bd469ed/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/640fd7875eff173f608c86af
        new failure (last pass: v5.10.172-529-g06956b9e9396)

    2023-03-14T02:09:58.073219  /lava-9596020/1/../bin/lava-test-case

    2023-03-14T02:09:58.084328  <8>[   34.995425] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/640fd7875eff173f608c86b0
        new failure (last pass: v5.10.172-529-g06956b9e9396)

    2023-03-14T02:09:57.037035  /lava-9596020/1/../bin/lava-test-case

    2023-03-14T02:09:57.047363  <8>[   33.958350] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/640fd87c8123d4b62b8c8653

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-69-gfcbe6bd469ed/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i=
-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-69-gfcbe6bd469ed/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i=
-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640fd87c8123d4b62b8c865c
        failing since 40 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-03-14T02:14:00.525160  / # #
    2023-03-14T02:14:00.626879  export SHELL=3D/bin/sh
    2023-03-14T02:14:00.627469  #
    2023-03-14T02:14:00.729063  / # export SHELL=3D/bin/sh. /lava-3408993/e=
nvironment
    2023-03-14T02:14:00.729585  =

    2023-03-14T02:14:00.830923  / # . /lava-3408993/environment/lava-340899=
3/bin/lava-test-runner /lava-3408993/1
    2023-03-14T02:14:00.831705  =

    2023-03-14T02:14:00.850221  / # /lava-3408993/bin/lava-test-runner /lav=
a-3408993/1
    2023-03-14T02:14:00.898306  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-14T02:14:00.941020  + cd /lava-3408993/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
