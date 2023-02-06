Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5C868BFB1
	for <lists+stable@lfdr.de>; Mon,  6 Feb 2023 15:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbjBFONS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 09:13:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230498AbjBFONE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 09:13:04 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D4F26594
        for <stable@vger.kernel.org>; Mon,  6 Feb 2023 06:12:11 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id q9so8277423pgq.5
        for <stable@vger.kernel.org>; Mon, 06 Feb 2023 06:12:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=7GxHsS5mPVs8KoswgfTqHxx6ELcxTbHgW4vm9MA2cuM=;
        b=p7ME+Eyx5c6fU4IRFM0Bfm4K003sW5ey3qtEwc8jH1M0xVVNfsicDpt69rrZ4ZWwU8
         XeTlTx8P9CUx2rbsbURBQxIutPjo6qRo5njrwN8yinZlc9JxMNsvYBg7VF0lbI25ITzg
         czjNpqO65kSz+UwOcKzxkA48T/R4cIu55JaVQL/42NdJm0eQosL9w52nBZh4XDQFBXrO
         j7EWpb7ctray2+8tkt8UR7ATpWj09Kp/vGawDZXp1dYbawKfWLUv5GFIiqkhxojTc7go
         ogYS2hnw0ynJR05iCCLXdkNNTWVXCbNNVMx9CRjzhdkhsvW02sX4cW9nwSar/3Skn6p0
         auPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7GxHsS5mPVs8KoswgfTqHxx6ELcxTbHgW4vm9MA2cuM=;
        b=zVq9H4Ia7BDyMXxBjV9R/bhojA4UdcVywjwNbyEeLyCZiIl44lAhpke7L0b9Al09hL
         iTe0Y4BVGrS1pA4b7BHpbQUgH76q9248ZVY+fPrIwwU8iSYbD5pOTrdsjOBL39qyRgI3
         In7+GRGNawGNDNt88gMcnFGRU9WL9ho3vDynEzKQCZhmKAt3JQAU9akPmTlj2uqxccmA
         j49IwCZhmjVg49bfrrSiMbotzb0fBiHzz4eszjrafDdsm4kTaou+iUUYhtVEqRGzIeHW
         +PnqgK03diXhwmvJgM+ltPnLfi3mRW9cZeYTjLra2SkveN34PvM91n/wr1GfBinGtvJU
         dwIg==
X-Gm-Message-State: AO0yUKXTwG1lktw0q0HWQes5X8dyi4KXMrF/fxZ0ezZnCLpftq2V2yav
        9yQoMoqDACEdtRqMM2MW2UvGRIt3hsJ4UCViuzM=
X-Google-Smtp-Source: AK7set/wciLy4mFiOhvCCCz9FQi29egXl/lR1f3SzOMyIEcxqY5nisRreW0Wd6Ts1Yci9vzanCykpQ==
X-Received: by 2002:a62:6385:0:b0:594:1f1c:3d2c with SMTP id x127-20020a626385000000b005941f1c3d2cmr9993864pfb.1.1675692720472;
        Mon, 06 Feb 2023 06:12:00 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id bx6-20020a056a00428600b0058da92f7c8dsm7382317pfb.17.2023.02.06.06.11.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 06:12:00 -0800 (PST)
Message-ID: <63e10ab0.050a0220.9f793.b822@mx.google.com>
Date:   Mon, 06 Feb 2023 06:12:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.92
X-Kernelci-Report-Type: test
Subject: stable/linux-5.15.y baseline: 222 runs, 5 regressions (v5.15.92)
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

stable/linux-5.15.y baseline: 222 runs, 5 regressions (v5.15.92)

Regressions Summary
-------------------

platform               | arch  | lab             | compiler | defconfig    =
                | regressions
-----------------------+-------+-----------------+----------+--------------=
----------------+------------
cubietruck             | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig           | 1          =

imx53-qsrb             | arm   | lab-pengutronix | gcc-10   | multi_v7_defc=
onfig           | 1          =

mt8173-elm-hana        | arm64 | lab-collabora   | gcc-10   | defconfig+arm=
...ok+kselftest | 1          =

sun50i-a64-pine64-plus | arm64 | lab-baylibre    | gcc-10   | defconfig    =
                | 1          =

sun50i-a64-pine64-plus | arm64 | lab-broonie     | gcc-10   | defconfig    =
                | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.92/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.92
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      e515b9902f5fa362ca66db9b01e7b2161c324c06 =



Test Regressions
---------------- =



platform               | arch  | lab             | compiler | defconfig    =
                | regressions
-----------------------+-------+-----------------+----------+--------------=
----------------+------------
cubietruck             | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0da6417c14816c8915f0b

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.92/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.92/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e0da6417c14816c8915f10
        failing since 18 days (last pass: v5.15.82, first fail: v5.15.89)

    2023-02-06T10:45:41.331566  <8>[    9.969271] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3295396_1.5.2.4.1>
    2023-02-06T10:45:41.438584  / # #
    2023-02-06T10:45:41.540071  export SHELL=3D/bin/sh
    2023-02-06T10:45:41.540516  #
    2023-02-06T10:45:41.641862  / # export SHELL=3D/bin/sh. /lava-3295396/e=
nvironment
    2023-02-06T10:45:41.642545  =

    2023-02-06T10:45:41.744215  / # . /lava-3295396/environment/lava-329539=
6/bin/lava-test-runner /lava-3295396/1
    2023-02-06T10:45:41.745219  =

    2023-02-06T10:45:41.745492  / # /lava-3295396/bin/lava-test-runner /lav=
a-3295396/1<3>[   10.353524] Bluetooth: hci0: command 0x0c03 tx timeout
    2023-02-06T10:45:41.749691   =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
                | regressions
-----------------------+-------+-----------------+----------+--------------=
----------------+------------
imx53-qsrb             | arm   | lab-pengutronix | gcc-10   | multi_v7_defc=
onfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0d9afb40908e3a2915ee6

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.92/a=
rm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.92/a=
rm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e0d9afb40908e3a2915eeb
        failing since 5 days (last pass: v5.15.81, first fail: v5.15.91)

    2023-02-06T10:42:32.755183  + set +x
    2023-02-06T10:42:32.755368  [    9.320209] <LAVA_SIGNAL_ENDRUN 0_dmesg =
899116_1.5.2.3.1>
    2023-02-06T10:42:32.861813  / # #
    2023-02-06T10:42:32.963325  export SHELL=3D/bin/sh
    2023-02-06T10:42:32.963722  #
    2023-02-06T10:42:33.064973  / # export SHELL=3D/bin/sh. /lava-899116/en=
vironment
    2023-02-06T10:42:33.065362  =

    2023-02-06T10:42:33.166548  / # . /lava-899116/environment/lava-899116/=
bin/lava-test-runner /lava-899116/1
    2023-02-06T10:42:33.167115  =

    2023-02-06T10:42:33.169781  / # /lava-899116/bin/lava-test-runner /lava=
-899116/1 =

    ... (11 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
                | regressions
-----------------------+-------+-----------------+----------+--------------=
----------------+------------
mt8173-elm-hana        | arm64 | lab-collabora   | gcc-10   | defconfig+arm=
...ok+kselftest | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0d86ec702fe727b915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook+kselftest
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.92/a=
rm64/defconfig+arm64-chromebook+kselftest/gcc-10/lab-collabora/baseline-mt8=
173-elm-hana.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.92/a=
rm64/defconfig+arm64-chromebook+kselftest/gcc-10/lab-collabora/baseline-mt8=
173-elm-hana.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e0d86ec702fe727b915=
eba
        failing since 12 days (last pass: v5.15.89, first fail: v5.15.90) =

 =



platform               | arch  | lab             | compiler | defconfig    =
                | regressions
-----------------------+-------+-----------------+----------+--------------=
----------------+------------
sun50i-a64-pine64-plus | arm64 | lab-baylibre    | gcc-10   | defconfig    =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0da448392217ab7915ebf

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.92/a=
rm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-pine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.92/a=
rm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-pine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e0da448392217ab7915ec4
        new failure (last pass: v5.15.82)

    2023-02-06T10:45:08.152469  <8>[   16.036209] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3295235_1.5.2.4.1>
    2023-02-06T10:45:08.272518  / # #
    2023-02-06T10:45:08.378056  export SHELL=3D/bin/sh
    2023-02-06T10:45:08.379632  #
    2023-02-06T10:45:08.483006  / # export SHELL=3D/bin/sh. /lava-3295235/e=
nvironment
    2023-02-06T10:45:08.484520  =

    2023-02-06T10:45:08.587968  / # . /lava-3295235/environment/lava-329523=
5/bin/lava-test-runner /lava-3295235/1
    2023-02-06T10:45:08.590621  =

    2023-02-06T10:45:08.593855  / # /lava-3295235/bin/lava-test-runner /lav=
a-3295235/1
    2023-02-06T10:45:08.638136  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
                | regressions
-----------------------+-------+-----------------+----------+--------------=
----------------+------------
sun50i-a64-pine64-plus | arm64 | lab-broonie     | gcc-10   | defconfig    =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0d72593f1d116c7915ec6

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.92/a=
rm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.92/a=
rm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e0d72593f1d116c7915ecb
        new failure (last pass: v5.15.82)

    2023-02-06T10:31:56.027046  + set +x
    2023-02-06T10:31:56.031232  <8>[   16.064335] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 260024_1.5.2.4.1>
    2023-02-06T10:31:56.141985  / # #
    2023-02-06T10:31:56.244458  export SHELL=3D/bin/sh
    2023-02-06T10:31:56.245201  #
    2023-02-06T10:31:56.346895  / # export SHELL=3D/bin/sh. /lava-260024/en=
vironment
    2023-02-06T10:31:56.347917  =

    2023-02-06T10:31:56.450945  / # . /lava-260024/environment/lava-260024/=
bin/lava-test-runner /lava-260024/1
    2023-02-06T10:31:56.453156  =

    2023-02-06T10:31:56.456661  / # /lava-260024/bin/lava-test-runner /lava=
-260024/1 =

    ... (12 line(s) more)  =

 =20
