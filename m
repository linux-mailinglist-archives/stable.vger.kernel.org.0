Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 273ED681A1E
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 20:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238288AbjA3TOo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 14:14:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238378AbjA3TOe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 14:14:34 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5000534C1E
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 11:14:29 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id rm7-20020a17090b3ec700b0022c05558d22so12079007pjb.5
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 11:14:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=oTMHYd08CXZxpYmAGG2oU8YSUC4u8zZoM9r7Hja8cLw=;
        b=KRCXN7iB1WB55FZQBj3QpHlewgqibDRWz6/8DqW+SpC2BDg4oZzH/pSHJqGTyoYp42
         kXssO7VhBm/B+CGEMSPW6doCH5fDzq5X410TXbPWB8vzbzy4dBn8FeiVJrlV4rx6aPJF
         S/TbRMs8OVV5pKKnSA7YwIJdOkpiFvIGxwMvjXtij29WoaGsr58x2WIxXSPyl3wHL4Vv
         /q8uswLrVz4fLprnUFbwgpOnzMp1Qf9HzcE0uFxpEJl0F1IbnjxwOw8ZNdBvo9VfxTP+
         Q/66hpetEtw0cjAieNNSKDuXusHzzMZczpgMasZuoQioVEt12WWejVxPuy+n28TQb3iS
         rtxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oTMHYd08CXZxpYmAGG2oU8YSUC4u8zZoM9r7Hja8cLw=;
        b=KpYyUC+WML8kB7+jWG/pkU+e3R4UL+Eow4aFgnZQ6k7N39TNSgfBKlUr8lfxn2zmuS
         dGn32/08zgxpBRB/dOW8L1V32EH+pDBS/cnQ2PTvRnkGrypZlavVUL8Xr6+7oAw8OAcS
         WgvmvuutGssudypZLJBOr9q1SZ95pp7rIcXfTdUuqkN29bZl35njblmCWlBPhV0HqsTk
         0jmmnV7Zz5J9WYWNX97Tqt745QVEQV99DJhBiTPdZFxkqdwotAO9d9pJzEZUfgI/5wBq
         ger7ZrXLI4wIeySRdNg7jTZH2cYER+wUR6O5vbmGOFRwM/CvIjrYC0+NP1hHPUFa2tZq
         b8Ww==
X-Gm-Message-State: AO0yUKUe6j0nRhoLtO4c9iqOW8Kj4i+yHu5JVXsbrT3dEO9bGEvXdSQv
        nIPI5C9fhl38XQmaUmHym339Odg/q99iJBYS4B5t8w==
X-Google-Smtp-Source: AK7set/sWNL+CwGMASx4gG0g/0L7LIo+9k22o4nMqVHaf/MbJD2D2wusFEQzmd8HHNnlH2OxfUt6rA==
X-Received: by 2002:a17:90a:1959:b0:22b:ec7d:e484 with SMTP id 25-20020a17090a195900b0022bec7de484mr11033796pjh.28.1675106068464;
        Mon, 30 Jan 2023 11:14:28 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t6-20020a63b246000000b00499a90cce5bsm7282929pgo.50.2023.01.30.11.14.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 11:14:28 -0800 (PST)
Message-ID: <63d81714.630a0220.eb169.b753@mx.google.com>
Date:   Mon, 30 Jan 2023 11:14:28 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.90-205-g5605d15db022
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.15.y baseline: 164 runs,
 4 regressions (v5.15.90-205-g5605d15db022)
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

stable-rc/linux-5.15.y baseline: 164 runs, 4 regressions (v5.15.90-205-g560=
5d15db022)

Regressions Summary
-------------------

platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
cubietruck             | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig | 1          =

imx53-qsrb             | arm   | lab-pengutronix | gcc-10   | multi_v7_defc=
onfig | 1          =

sun50i-a64-pine64-plus | arm64 | lab-baylibre    | gcc-10   | defconfig    =
      | 1          =

sun50i-a64-pine64-plus | arm64 | lab-broonie     | gcc-10   | defconfig    =
      | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.90-205-g5605d15db022/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.90-205-g5605d15db022
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5605d15db0225e49efaa8f83e03f78a8bee3bb5d =



Test Regressions
---------------- =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
cubietruck             | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63d7e0f88d23f82be0915ed6

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
0-205-g5605d15db022/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
0-205-g5605d15db022/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d7e0f88d23f82be0915edb
        failing since 13 days (last pass: v5.15.82-124-gd731c63c25d1, first=
 fail: v5.15.87-101-g5bcc318cb4cd)

    2023-01-30T15:23:17.205258  <8>[   10.087600] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3248152_1.5.2.4.1>
    2023-01-30T15:23:17.311785  / # #
    2023-01-30T15:23:17.413243  export SHELL=3D/bin/sh
    2023-01-30T15:23:17.413614  #
    2023-01-30T15:23:17.413790  / # export SHELL=3D/bin/sh<3>[   10.275386]=
 Bluetooth: hci0: command 0xfc18 tx timeout
    2023-01-30T15:23:17.514945  . /lava-3248152/environment
    2023-01-30T15:23:17.515272  =

    2023-01-30T15:23:17.616435  / # . /lava-3248152/environment/lava-324815=
2/bin/lava-test-runner /lava-3248152/1
    2023-01-30T15:23:17.616970  =

    2023-01-30T15:23:17.621651  / # /lava-3248152/bin/lava-test-runner /lav=
a-3248152/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
imx53-qsrb             | arm   | lab-pengutronix | gcc-10   | multi_v7_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63d7e0908dd84a1721915ebe

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
0-205-g5605d15db022/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
0-205-g5605d15db022/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d7e0908dd84a1721915ec3
        new failure (last pass: v5.15.81-122-gc5f8d4a5d3c8)

    2023-01-30T15:21:26.832587  + set +x
    2023-01-30T15:21:26.832756  [    9.379885] <LAVA_SIGNAL_ENDRUN 0_dmesg =
892217_1.5.2.3.1>
    2023-01-30T15:21:26.939000  / # #
    2023-01-30T15:21:27.040620  export SHELL=3D/bin/sh
    2023-01-30T15:21:27.041453  #
    2023-01-30T15:21:27.142697  / # export SHELL=3D/bin/sh. /lava-892217/en=
vironment
    2023-01-30T15:21:27.143349  =

    2023-01-30T15:21:27.244683  / # . /lava-892217/environment/lava-892217/=
bin/lava-test-runner /lava-892217/1
    2023-01-30T15:21:27.245269  =

    2023-01-30T15:21:27.248128  / # /lava-892217/bin/lava-test-runner /lava=
-892217/1 =

    ... (11 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
sun50i-a64-pine64-plus | arm64 | lab-baylibre    | gcc-10   | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/63d7e0fe8d23f82be0915ef2

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
0-205-g5605d15db022/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64=
-pine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
0-205-g5605d15db022/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64=
-pine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d7e0fe8d23f82be0915ef7
        failing since 13 days (last pass: v5.15.82-124-gd731c63c25d1, first=
 fail: v5.15.87-101-g5bcc318cb4cd)

    2023-01-30T15:22:51.265188  + set +x
    2023-01-30T15:22:51.268231  <8>[   16.056269] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3248103_1.5.2.4.1>
    2023-01-30T15:22:51.393726  / # #
    2023-01-30T15:22:51.499647  export SHELL=3D/bin/sh
    2023-01-30T15:22:51.501278  #
    2023-01-30T15:22:51.604896  / # export SHELL=3D/bin/sh. /lava-3248103/e=
nvironment
    2023-01-30T15:22:51.606506  =

    2023-01-30T15:22:51.710230  / # . /lava-3248103/environment/lava-324810=
3/bin/lava-test-runner /lava-3248103/1
    2023-01-30T15:22:51.713208  =

    2023-01-30T15:22:51.716410  / # /lava-3248103/bin/lava-test-runner /lav=
a-3248103/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
sun50i-a64-pine64-plus | arm64 | lab-broonie     | gcc-10   | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/63d7e096a11681e684915ee2

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
0-205-g5605d15db022/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-=
pine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
0-205-g5605d15db022/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-=
pine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d7e096a11681e684915ee7
        failing since 13 days (last pass: v5.15.82-124-gd731c63c25d1, first=
 fail: v5.15.87-101-g5bcc318cb4cd)

    2023-01-30T15:21:50.996050  <8>[   16.071027] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 214289_1.5.2.4.1>
    2023-01-30T15:21:51.106845  / # #
    2023-01-30T15:21:51.208873  export SHELL=3D/bin/sh
    2023-01-30T15:21:51.209461  #
    2023-01-30T15:21:51.311159  / # export SHELL=3D/bin/sh. /lava-214289/en=
vironment
    2023-01-30T15:21:51.311628  =

    2023-01-30T15:21:51.413116  / # . /lava-214289/environment/lava-214289/=
bin/lava-test-runner /lava-214289/1
    2023-01-30T15:21:51.414043  =

    2023-01-30T15:21:51.418494  / # /lava-214289/bin/lava-test-runner /lava=
-214289/1
    2023-01-30T15:21:51.462355  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =20
