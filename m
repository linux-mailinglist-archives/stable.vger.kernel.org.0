Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEF9E68AC1F
	for <lists+stable@lfdr.de>; Sat,  4 Feb 2023 20:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbjBDTk5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Feb 2023 14:40:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBDTk4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Feb 2023 14:40:56 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAEA32BF0A
        for <stable@vger.kernel.org>; Sat,  4 Feb 2023 11:40:54 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id d2so4459363pjd.5
        for <stable@vger.kernel.org>; Sat, 04 Feb 2023 11:40:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=BtCh3qiaNtcvFgPV8epWkHUo60nLUo7g6FUVgRdYiBA=;
        b=dsKtzxsSMJB2zzOf73Vw3vHPIsgrhBGNPjJRoUwoEQJRGO/6ww+m3UVXqY0MUC63e0
         /szdHoWGAMvrOCG/1PxsX3juVPhk7IEAhjh9lBLOd7LprywCPRveDqQtHx0z2SOiBc05
         FJ6kaCVbrto9MB0BDQsT8GtEFZpI8HzAFlPP9y3DR4N95dPDMqt1UG95g/Thb9xeI3S1
         yiSbO3lp+GXuVA4576U8epEG2emXOLK/f5WanZNXtEEdOrKY9c9oFe2O9sd5fXNZHRtx
         RJnsCHedYi2DYxKLdTpXmp5NPsFM2Ktl0T3vVQ/6gEWzIxND++w7FEkE4tb7hV5UhnUB
         bXBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BtCh3qiaNtcvFgPV8epWkHUo60nLUo7g6FUVgRdYiBA=;
        b=NRW5khbL3xe3WpdbYDUZjpOsbQYTRw6IESKPCGQv6P23QJpjwRjzC84K2izrOq6OX+
         ngz7IASyEsIp+DHGnmXMglN6gXquUioMzttxW3BJ5zM7PZ+lqUQfwF2j7tPY+R4Gb84N
         hebXNC1Uk6yUPKwCvvtXuW9cJz78zWymIVCsRTVJ/+nUXss+zsqPlNMoXcc2vhXNL+ie
         /B2HxA+fMJZ7N1DTgZ0LAKhK+ueU4ygFIRaH7Aq/esAQWrBwOe2tS+D8tZpKRbcfU2Qt
         bXjzUo+3EqEkXD+H+XcAdbUYO0KlB7iITwsGYqxl+TanH410MHKaH2v0msnEmauuRSo2
         qBiw==
X-Gm-Message-State: AO0yUKW0ceM5l/AXmCsIbxtSZb/hxjHdH8/nxHtRdM16V7GWedZ1AQRa
        rZrCYAqOTzhIuOgOs9iBk9iTmXw6NYZH/ys2bd8Asg==
X-Google-Smtp-Source: AK7set9eOg53hAdBU39Nnhsvb9JfNl8pBQ51p0ZGXyL7qA3kjEh9aG6cBPAZXrGVb1hSJnvpSWKuuQ==
X-Received: by 2002:a17:902:dac8:b0:196:38f4:78df with SMTP id q8-20020a170902dac800b0019638f478dfmr8203717plx.39.1675539654129;
        Sat, 04 Feb 2023 11:40:54 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id jj15-20020a170903048f00b0019300c89011sm3803843plb.63.2023.02.04.11.40.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Feb 2023 11:40:53 -0800 (PST)
Message-ID: <63deb4c5.170a0220.8e069.6778@mx.google.com>
Date:   Sat, 04 Feb 2023 11:40:53 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.91-20-gdc9a687dc9c4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 177 runs,
 5 regressions (v5.15.91-20-gdc9a687dc9c4)
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

stable-rc/queue/5.15 baseline: 177 runs, 5 regressions (v5.15.91-20-gdc9a68=
7dc9c4)

Regressions Summary
-------------------

platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
beagle-xm              | arm   | lab-baylibre    | gcc-10   | omap2plus_def=
config | 1          =

cubietruck             | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig  | 1          =

imx53-qsrb             | arm   | lab-pengutronix | gcc-10   | multi_v7_defc=
onfig  | 1          =

sun50i-a64-pine64-plus | arm64 | lab-baylibre    | gcc-10   | defconfig    =
       | 1          =

sun50i-a64-pine64-plus | arm64 | lab-broonie     | gcc-10   | defconfig    =
       | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.91-20-gdc9a687dc9c4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.91-20-gdc9a687dc9c4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dc9a687dc9c49ebada4283d179cdaf64b1f567b7 =



Test Regressions
---------------- =



platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
beagle-xm              | arm   | lab-baylibre    | gcc-10   | omap2plus_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/63de814ee51bd1305b915ec7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
20-gdc9a687dc9c4/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
20-gdc9a687dc9c4/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63de814ee51bd1305b915=
ec8
        failing since 1 day (last pass: v5.15.91-12-g3290f78df1ab, first fa=
il: v5.15.91-18-ga7afd81d41cb) =

 =



platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
cubietruck             | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/63de840edbf3ff8059915ebc

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
20-gdc9a687dc9c4/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubiet=
ruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
20-gdc9a687dc9c4/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubiet=
ruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63de840edbf3ff8059915ec1
        failing since 18 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-02-04T16:12:21.317470  <8>[   10.012551] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3288386_1.5.2.4.1>
    2023-02-04T16:12:21.428540  / # #
    2023-02-04T16:12:21.531960  export SHELL=3D/bin/sh
    2023-02-04T16:12:21.532880  #
    2023-02-04T16:12:21.635158  / # export SHELL=3D/bin/sh. /lava-3288386/e=
nvironment
    2023-02-04T16:12:21.636307  =

    2023-02-04T16:12:21.738337  / # . /lava-3288386/environment/lava-328838=
6/bin/lava-test-runner /lava-3288386/1
    2023-02-04T16:12:21.739963  =

    2023-02-04T16:12:21.740585  / # /lava-3288386/bin/lava-test-runner /lav=
a-3288386/1<3>[   10.433573] Bluetooth: hci0: command 0x0c03 tx timeout
    2023-02-04T16:12:21.744426   =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
imx53-qsrb             | arm   | lab-pengutronix | gcc-10   | multi_v7_defc=
onfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/63de83d4beb346c5f1915efa

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
20-gdc9a687dc9c4/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
20-gdc9a687dc9c4/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63de83d4beb346c5f1915eff
        failing since 8 days (last pass: v5.15.81-121-gcb14018a85f6, first =
fail: v5.15.90-146-gbf7101723cc0)

    2023-02-04T16:11:39.226141  + set +x
    2023-02-04T16:11:39.226427  [    9.358616] <LAVA_SIGNAL_ENDRUN 0_dmesg =
898268_1.5.2.3.1>
    2023-02-04T16:11:39.333328  / # #
    2023-02-04T16:11:39.435565  export SHELL=3D/bin/sh
    2023-02-04T16:11:39.436126  #
    2023-02-04T16:11:39.537450  / # export SHELL=3D/bin/sh. /lava-898268/en=
vironment
    2023-02-04T16:11:39.538108  =

    2023-02-04T16:11:39.639597  / # . /lava-898268/environment/lava-898268/=
bin/lava-test-runner /lava-898268/1
    2023-02-04T16:11:39.640442  =

    2023-02-04T16:11:39.642565  / # /lava-898268/bin/lava-test-runner /lava=
-898268/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
sun50i-a64-pine64-plus | arm64 | lab-baylibre    | gcc-10   | defconfig    =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/63de80efb3c2cf5196915ef5

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
20-gdc9a687dc9c4/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-pi=
ne64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
20-gdc9a687dc9c4/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-pi=
ne64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63de80efb3c2cf5196915efa
        failing since 17 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-02-04T15:59:34.509752  + set +x
    2023-02-04T15:59:34.513885  <8>[   16.059248] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3288279_1.5.2.4.1>
    2023-02-04T15:59:34.634289  / # #
    2023-02-04T15:59:34.739843  export SHELL=3D/bin/sh
    2023-02-04T15:59:34.741353  #
    2023-02-04T15:59:34.844752  / # export SHELL=3D/bin/sh. /lava-3288279/e=
nvironment
    2023-02-04T15:59:34.846270  =

    2023-02-04T15:59:34.949926  / # . /lava-3288279/environment/lava-328827=
9/bin/lava-test-runner /lava-3288279/1
    2023-02-04T15:59:34.955612  =

    2023-02-04T15:59:34.958124  / # /lava-3288279/bin/lava-test-runner /lav=
a-3288279/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
sun50i-a64-pine64-plus | arm64 | lab-broonie     | gcc-10   | defconfig    =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/63de8004e0bc87d4c2915f5e

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
20-gdc9a687dc9c4/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pin=
e64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
20-gdc9a687dc9c4/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pin=
e64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63de8004e0bc87d4c2915f63
        failing since 17 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-02-04T15:55:25.410426  + set +x
    2023-02-04T15:55:25.414291  <8>[   16.001011] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 251190_1.5.2.4.1>
    2023-02-04T15:55:25.526361  / # #
    2023-02-04T15:55:25.629388  export SHELL=3D/bin/sh
    2023-02-04T15:55:25.630112  #
    2023-02-04T15:55:25.732280  / # . /lava-251190/environment
    2023-02-04T15:55:25.873030  export SHELL=3D/bin/sh
    2023-02-04T15:55:25.873539  / # . /lava-251190/environment
    2023-02-04T15:55:25.975447  / # /lava-251190/bin/lava-test-runner /lava=
-251190/1
    2023-02-04T15:55:25.980934  /lava-251190/bin/lava-test-runner /lava-251=
190/1 =

    ... (12 line(s) more)  =

 =20
