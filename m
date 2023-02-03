Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82CA4689E89
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 16:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232673AbjBCPwX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 10:52:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBCPwX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 10:52:23 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A79F15CE45
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 07:52:21 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id o16-20020a17090ad25000b00230759a8c06so2380348pjw.2
        for <stable@vger.kernel.org>; Fri, 03 Feb 2023 07:52:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=j7cZx4jsgm9pMrt4E+VUw1k7F1cjWaPrgG6jt7bAMmU=;
        b=FrM6YVZREgm2OhMOF3rR3mLxlrcaH8NBZyRCglf4KQH0mq2BlSbhbZOuj0uwaLxKuk
         T+tcoR6p3t6CokcXs8tEAT4hvUZdnZ2m2Lxepv6SOCrHq5o3Wqw7j/Ou5Sz71SoUcTXv
         Y5TMVpJniXDvWYfzw5/2R4z5i/jDhHO0b0c0u6CUGnjX3WliA/8c2AUztPzslSsDdtre
         O32OseAgXXccO/jtUpE3fzFmxNfTYAYq5Zv4/PMe6Ha4767w1fYUks49tTTacBjMvO6E
         OW8aPPZ5W3J7aJ8mwN3bV3QuqX79KLsWU1IUykOykp6w8h7bHilKkGUQjRDaKb7N6eAG
         z9+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j7cZx4jsgm9pMrt4E+VUw1k7F1cjWaPrgG6jt7bAMmU=;
        b=5RW+mEZwc1Fl0I/VPw/k3EsTlgbC4f/Lta3aKPbkH6pV+z0+qRZcdNyezB6neDCP7+
         2uc+JYx7Qz2kPCsdNMgR2EU/ZgvQHrKWOH0vmH7OY1cpzwW7uyY7SRfB7OIqgXwXdhRq
         hK9rLzFsPixE6dHMoqENiXDXCUsBjPSt467p0X7cwnGhYhfKmZFI1+wOwp6NNbCFX+ip
         E2tfbBQIX8xKODA4n+lg2U6uqC5nuKZX7zTrh7m3oePkehR1HNEpZElaxaaFPKfAVptS
         UX2S3tWInC8KlfFV3juLSqkq1EJpP5MEHcI38btEzggnfCaHjvZhPhoqcl5oHqF2HYam
         mLCg==
X-Gm-Message-State: AO0yUKUSajArdSh83fMGLy0vZSi7iZFQ23/8/10p0Y0DVVDrISoopjLY
        hFUPy06L1ywGVpdtkqh9koV6jXJjcAnTs6OAvKe+iQ==
X-Google-Smtp-Source: AK7set8bZmMvxYDeYKlEiYXXd3WhpM+qlptJvIEK6D7awlgLGdX+uu9Qi3pU6q+TVBkJLY2KRQ9YZw==
X-Received: by 2002:a17:902:e54d:b0:194:a602:13c8 with SMTP id n13-20020a170902e54d00b00194a60213c8mr14548207plf.52.1675439540885;
        Fri, 03 Feb 2023 07:52:20 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 18-20020a170902c25200b001925c3ec34esm1760571plg.196.2023.02.03.07.52.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 07:52:20 -0800 (PST)
Message-ID: <63dd2db4.170a0220.68a9.2ffa@mx.google.com>
Date:   Fri, 03 Feb 2023 07:52:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.91-20-gf1e8edddbe95
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 167 runs,
 6 regressions (v5.15.91-20-gf1e8edddbe95)
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

stable-rc/queue/5.15 baseline: 167 runs, 6 regressions (v5.15.91-20-gf1e8ed=
ddbe95)

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

stm32mp157c-dk2        | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig  | 1          =

sun50i-a64-pine64-plus | arm64 | lab-baylibre    | gcc-10   | defconfig    =
       | 1          =

sun50i-a64-pine64-plus | arm64 | lab-broonie     | gcc-10   | defconfig    =
       | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.91-20-gf1e8edddbe95/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.91-20-gf1e8edddbe95
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f1e8edddbe958d693b1827b65547bf0eb12f9389 =



Test Regressions
---------------- =



platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
beagle-xm              | arm   | lab-baylibre    | gcc-10   | omap2plus_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/63dcfdc6c239cc5d08915ee4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
20-gf1e8edddbe95/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
20-gf1e8edddbe95/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63dcfdc6c239cc5d08915=
ee5
        failing since 0 day (last pass: v5.15.91-12-g3290f78df1ab, first fa=
il: v5.15.91-18-ga7afd81d41cb) =

 =



platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
cubietruck             | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/63dcf9ef5b89011a70915ee5

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
20-gf1e8edddbe95/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubiet=
ruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
20-gf1e8edddbe95/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubiet=
ruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63dcf9ef5b89011a70915eea
        failing since 17 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-02-03T12:11:09.600198  + set +x<8>[    9.940312] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3281222_1.5.2.4.1>
    2023-02-03T12:11:09.600488  =

    2023-02-03T12:11:09.708053  / # #
    2023-02-03T12:11:09.809509  export SHELL=3D/bin/sh
    2023-02-03T12:11:09.809932  #
    2023-02-03T12:11:09.911185  / # export SHELL=3D/bin/sh. /lava-3281222/e=
nvironment
    2023-02-03T12:11:09.911559  =

    2023-02-03T12:11:10.012756  / # . /lava-3281222/environment/lava-328122=
2/bin/lava-test-runner /lava-3281222/1
    2023-02-03T12:11:10.013488  =

    2023-02-03T12:11:10.013691  / # /lava-3281222/bin/lava-test-runner /lav=
a-3281222/1<3>[   10.353523] Bluetooth: hci0: command 0xfc18 tx timeout =

    ... (13 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
imx53-qsrb             | arm   | lab-pengutronix | gcc-10   | multi_v7_defc=
onfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/63dcf9806c3d6a996c915f2a

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
20-gf1e8edddbe95/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
20-gf1e8edddbe95/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63dcf9806c3d6a996c915f2f
        failing since 7 days (last pass: v5.15.81-121-gcb14018a85f6, first =
fail: v5.15.90-146-gbf7101723cc0)

    2023-02-03T12:09:16.920747  + set +x
    2023-02-03T12:09:16.920938  [    9.360744] <LAVA_SIGNAL_ENDRUN 0_dmesg =
897123_1.5.2.3.1>
    2023-02-03T12:09:17.031877  / # #
    2023-02-03T12:09:17.136410  export SHELL=3D/bin/sh
    2023-02-03T12:09:17.137472  #
    2023-02-03T12:09:17.238748  / # export SHELL=3D/bin/sh. /lava-897123/en=
vironment
    2023-02-03T12:09:17.239301  =

    2023-02-03T12:09:17.340670  / # . /lava-897123/environment/lava-897123/=
bin/lava-test-runner /lava-897123/1
    2023-02-03T12:09:17.341547  =

    2023-02-03T12:09:17.343915  / # /lava-897123/bin/lava-test-runner /lava=
-897123/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
stm32mp157c-dk2        | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/63dcf960f6585b9729915ebd

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
20-gf1e8edddbe95/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-stm32m=
p157c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
20-gf1e8edddbe95/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-stm32m=
p157c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63dcf960f6585b9729915ec2
        failing since 1 day (last pass: v5.15.72-36-g3886958cda706, first f=
ail: v5.15.90-215-gdf99871482a0)

    2023-02-03T12:08:55.810619  <8>[   11.587655] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3281216_1.5.2.4.1>
    2023-02-03T12:08:55.916637  / # #
    2023-02-03T12:08:56.019362  export SHELL=3D/bin/sh
    2023-02-03T12:08:56.020097  #
    2023-02-03T12:08:56.121878  / # export SHELL=3D/bin/sh. /lava-3281216/e=
nvironment
    2023-02-03T12:08:56.122265  =

    2023-02-03T12:08:56.223644  / # . /lava-3281216/environment/lava-328121=
6/bin/lava-test-runner /lava-3281216/1
    2023-02-03T12:08:56.224544  =

    2023-02-03T12:08:56.228766  / # /lava-3281216/bin/lava-test-runner /lav=
a-3281216/1
    2023-02-03T12:08:56.295632  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
sun50i-a64-pine64-plus | arm64 | lab-baylibre    | gcc-10   | defconfig    =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/63dcfce8b9df112528915eb9

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
20-gf1e8edddbe95/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-pi=
ne64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
20-gf1e8edddbe95/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-pi=
ne64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63dcfce8b9df112528915ebe
        failing since 16 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-02-03T12:23:51.468077  <8>[   16.035767] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3281298_1.5.2.4.1>
    2023-02-03T12:23:51.589115  / # #
    2023-02-03T12:23:51.694997  export SHELL=3D/bin/sh
    2023-02-03T12:23:51.696601  #
    2023-02-03T12:23:51.800277  / # export SHELL=3D/bin/sh. /lava-3281298/e=
nvironment
    2023-02-03T12:23:51.801870  =

    2023-02-03T12:23:51.905682  / # . /lava-3281298/environment/lava-328129=
8/bin/lava-test-runner /lava-3281298/1
    2023-02-03T12:23:51.908583  =

    2023-02-03T12:23:51.911660  / # /lava-3281298/bin/lava-test-runner /lav=
a-3281298/1
    2023-02-03T12:23:51.959372  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
sun50i-a64-pine64-plus | arm64 | lab-broonie     | gcc-10   | defconfig    =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/63dcfa33eca363b0f8915ecc

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
20-gf1e8edddbe95/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pin=
e64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
20-gf1e8edddbe95/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pin=
e64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63dcfa33eca363b0f8915ed1
        failing since 16 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-02-03T12:12:26.020825  + set +x
    2023-02-03T12:12:26.024578  <8>[   16.056561] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 244154_1.5.2.4.1>
    2023-02-03T12:12:26.135533  / # #
    2023-02-03T12:12:26.237741  export SHELL=3D/bin/sh
    2023-02-03T12:12:26.238338  #
    2023-02-03T12:12:26.340084  / # export SHELL=3D/bin/sh. /lava-244154/en=
vironment
    2023-02-03T12:12:26.340705  =

    2023-02-03T12:12:26.442493  / # . /lava-244154/environment/lava-244154/=
bin/lava-test-runner /lava-244154/1
    2023-02-03T12:12:26.443368  =

    2023-02-03T12:12:26.446663  / # /lava-244154/bin/lava-test-runner /lava=
-244154/1 =

    ... (12 line(s) more)  =

 =20
