Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 704AA689C92
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 16:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233180AbjBCPE1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 10:04:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232784AbjBCPEY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 10:04:24 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6184917CD8
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 07:04:22 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id jh15so5478698plb.8
        for <stable@vger.kernel.org>; Fri, 03 Feb 2023 07:04:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=mGPYoxMt2FkLOyM4PUdRtVBb+bwLX3gAjcWQPOc8x3A=;
        b=Nt6vaFrqemBd4Z1QGRINKf98bDz/yGX/ds4xmdDCrZsuef7f2mYrq4xwQm8rCST1Ry
         qJfjlU2PvWw0wwUSvMOflvgA1F9q16LQ/jEOthfOvZA/NXEofiIpGnJquIoHvlPRbzXO
         8+3AfgGDFeLO+Az5hpvGyanGGh8sy9gOPoWpXBStizTaGwHQjf6sqS5Bz3yjlB9woU0m
         ljdpQMt429lvh94K04EzC5l0ciBu5ilYkdCUAHqiPUOujMHcvoZ8QWpk2OLhOQLJ12IT
         xknzE12uJwzbW6gFUP1hnedbgTebAqSqAvToYRpkEH140pDZl8lZadoF3gxMPoy3gGB3
         RgTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mGPYoxMt2FkLOyM4PUdRtVBb+bwLX3gAjcWQPOc8x3A=;
        b=6ioBpdNWeF2SdzMgxmsgZxemc0eSBtxYEDR80my4INKB1P9HGSQNVHP2Xph2+C0Va3
         mevotPO6JtN5jhyUwTZOhn5gj/tU5LWLN4wGOVQx1QHCNMz5QaDofQvf9C7po5bmZbXz
         r0cvOmMVKFA0CshHiYIlH06Txmfx1vb2M8XHAmKX9zn59WI9DiiWIan6C0K3OdADlXMO
         r6WVrq3epXwdDC04G7i86CGhbdfYSZgBssHL4hPmAYJHJYJ3OE5BHqLEUaQ6WeMO2/Ta
         rFN6qInSLOEuz36zNZfUzeEf+PYzoBnOqq3DS+e5nN10eVnqnVtSE9ni0POo6D7Lkyuw
         wOsg==
X-Gm-Message-State: AO0yUKWFeqnP4+vBN5pMeXc2sd9zMmGtDKu8z0YJPGoLHAkB/3nBPqtv
        rZ6ypMry8FC9ws7JcZXzDhgW8QnQdbsVvi7nHDIRxg==
X-Google-Smtp-Source: AK7set/ujKbYFat600SNZEtDzADNLSBaUMH5Gk1OrGEd3SrPaDfw5OVHXDzU0jGr1s/uX5P2wUHwBg==
X-Received: by 2002:a17:902:e2cb:b0:198:e056:4d79 with SMTP id l11-20020a170902e2cb00b00198e0564d79mr1246944plc.42.1675436661494;
        Fri, 03 Feb 2023 07:04:21 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r25-20020a639b19000000b0049f5da82b12sm1556202pgd.93.2023.02.03.07.04.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 07:04:21 -0800 (PST)
Message-ID: <63dd2275.630a0220.cdbb.2c37@mx.google.com>
Date:   Fri, 03 Feb 2023 07:04:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.166-10-g6278b8c9832e
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 167 runs,
 5 regressions (v5.10.166-10-g6278b8c9832e)
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

stable-rc/linux-5.10.y baseline: 167 runs, 5 regressions (v5.10.166-10-g627=
8b8c9832e)

Regressions Summary
-------------------

platform               | arch  | lab          | compiler | defconfig       =
   | regressions
-----------------------+-------+--------------+----------+-----------------=
---+------------
cubietruck             | arm   | lab-baylibre | gcc-10   | multi_v7_defconf=
ig | 1          =

r8a7743-iwg20d-q7      | arm   | lab-cip      | gcc-10   | shmobile_defconf=
ig | 1          =

stm32mp157c-dk2        | arm   | lab-baylibre | gcc-10   | multi_v7_defconf=
ig | 1          =

sun50i-a64-pine64-plus | arm64 | lab-baylibre | gcc-10   | defconfig       =
   | 1          =

sun50i-a64-pine64-plus | arm64 | lab-broonie  | gcc-10   | defconfig       =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.166-10-g6278b8c9832e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.166-10-g6278b8c9832e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6278b8c9832e3a5adb841ca9e2cfebadb522f304 =



Test Regressions
---------------- =



platform               | arch  | lab          | compiler | defconfig       =
   | regressions
-----------------------+-------+--------------+----------+-----------------=
---+------------
cubietruck             | arm   | lab-baylibre | gcc-10   | multi_v7_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/63dcf03dee3cdd2d4c915f17

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
66-10-g6278b8c9832e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
66-10-g6278b8c9832e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63dcf03dee3cdd2d4c915f1c
        failing since 16 days (last pass: v5.10.158-107-gd2432186ff47, firs=
t fail: v5.10.162-852-geeaac3cf2eb3)

    2023-02-03T11:29:44.517276  <8>[   11.004473] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3280918_1.5.2.4.1>
    2023-02-03T11:29:44.623722  / # #
    2023-02-03T11:29:44.725155  export SHELL=3D/bin/sh
    2023-02-03T11:29:44.725504  #
    2023-02-03T11:29:44.826623  / # export SHELL=3D/bin/sh. /lava-3280918/e=
nvironment
    2023-02-03T11:29:44.826963  =

    2023-02-03T11:29:44.928091  / # . /lava-3280918/environment/lava-328091=
8/bin/lava-test-runner /lava-3280918/1
    2023-02-03T11:29:44.928711  =

    2023-02-03T11:29:44.928887  / # <3>[   11.371349] Bluetooth: hci0: comm=
and 0x0c03 tx timeout
    2023-02-03T11:29:44.933354  /lava-3280918/bin/lava-test-runner /lava-32=
80918/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab          | compiler | defconfig       =
   | regressions
-----------------------+-------+--------------+----------+-----------------=
---+------------
r8a7743-iwg20d-q7      | arm   | lab-cip      | gcc-10   | shmobile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/63dcec15816ccdd6a0915ee7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
66-10-g6278b8c9832e/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-=
iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
66-10-g6278b8c9832e/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-=
iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63dcec15816ccdd6a0915=
ee8
        failing since 8 days (last pass: v5.10.162-951-g9096aabfe9e0, first=
 fail: v5.10.165) =

 =



platform               | arch  | lab          | compiler | defconfig       =
   | regressions
-----------------------+-------+--------------+----------+-----------------=
---+------------
stm32mp157c-dk2        | arm   | lab-baylibre | gcc-10   | multi_v7_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/63dceebf5f81cf53eb915eb9

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
66-10-g6278b8c9832e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-stm=
32mp157c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
66-10-g6278b8c9832e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-stm=
32mp157c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63dceebf5f81cf53eb915ebe
        new failure (last pass: v5.10.147)

    2023-02-03T11:23:38.138350  <8>[   12.660698] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3280912_1.5.2.4.1>
    2023-02-03T11:23:38.242973  / # #
    2023-02-03T11:23:38.344942  export SHELL=3D/bin/sh
    2023-02-03T11:23:38.345805  #
    2023-02-03T11:23:38.447699  / # export SHELL=3D/bin/sh. /lava-3280912/e=
nvironment
    2023-02-03T11:23:38.448479  =

    2023-02-03T11:23:38.550444  / # . /lava-3280912/environment/lava-328091=
2/bin/lava-test-runner /lava-3280912/1
    2023-02-03T11:23:38.551122  =

    2023-02-03T11:23:38.555729  / # /lava-3280912/bin/lava-test-runner /lav=
a-3280912/1
    2023-02-03T11:23:38.622600  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform               | arch  | lab          | compiler | defconfig       =
   | regressions
-----------------------+-------+--------------+----------+-----------------=
---+------------
sun50i-a64-pine64-plus | arm64 | lab-baylibre | gcc-10   | defconfig       =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/63dcf0de6edd60461f915ef0

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
66-10-g6278b8c9832e/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64=
-pine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
66-10-g6278b8c9832e/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64=
-pine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63dcf0de6edd60461f915ef5
        failing since 3 days (last pass: v5.10.158-107-g6b6a42c25ed4, first=
 fail: v5.10.165-144-g930bc29c79c4)

    2023-02-03T11:32:35.440454  + set +x
    2023-02-03T11:32:35.444546  <8>[   17.088974] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3280930_1.5.2.4.1>
    2023-02-03T11:32:35.564629  / # #
    2023-02-03T11:32:35.670202  export SHELL=3D/bin/sh
    2023-02-03T11:32:35.671780  #
    2023-02-03T11:32:35.775091  / # export SHELL=3D/bin/sh. /lava-3280930/e=
nvironment
    2023-02-03T11:32:35.776620  =

    2023-02-03T11:32:35.880076  / # . /lava-3280930/environment/lava-328093=
0/bin/lava-test-runner /lava-3280930/1
    2023-02-03T11:32:35.882751  =

    2023-02-03T11:32:35.886053  / # /lava-3280930/bin/lava-test-runner /lav=
a-3280930/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab          | compiler | defconfig       =
   | regressions
-----------------------+-------+--------------+----------+-----------------=
---+------------
sun50i-a64-pine64-plus | arm64 | lab-broonie  | gcc-10   | defconfig       =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/63dcf00c13d5f89148915f24

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
66-10-g6278b8c9832e/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-=
pine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
66-10-g6278b8c9832e/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-=
pine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63dcf00c13d5f89148915f29
        failing since 3 days (last pass: v5.10.158-107-g6b6a42c25ed4, first=
 fail: v5.10.165-144-g930bc29c79c4)

    2023-02-03T11:29:02.283870  + set +x
    2023-02-03T11:29:02.288162  <8>[   17.030274] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 243740_1.5.2.4.1>
    2023-02-03T11:29:02.397446  / # #
    2023-02-03T11:29:02.499599  export SHELL=3D/bin/sh
    2023-02-03T11:29:02.500426  #
    2023-02-03T11:29:02.602330  / # export SHELL=3D/bin/sh. /lava-243740/en=
vironment
    2023-02-03T11:29:02.602802  =

    2023-02-03T11:29:02.704067  / # . /lava-243740/environment/lava-243740/=
bin/lava-test-runner /lava-243740/1
    2023-02-03T11:29:02.704885  =

    2023-02-03T11:29:02.708970  / # /lava-243740/bin/lava-test-runner /lava=
-243740/1 =

    ... (12 line(s) more)  =

 =20
