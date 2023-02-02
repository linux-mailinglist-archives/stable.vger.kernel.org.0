Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA5C6876B6
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 08:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231926AbjBBHr2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 02:47:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231903AbjBBHrX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 02:47:23 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D69B2A14C
        for <stable@vger.kernel.org>; Wed,  1 Feb 2023 23:46:57 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id c10-20020a17090a1d0a00b0022e63a94799so4779918pjd.2
        for <stable@vger.kernel.org>; Wed, 01 Feb 2023 23:46:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=NcQ0y1B3oOpn7msq4twenQ6s53o6uoLRVdI3pK6krVk=;
        b=2xBfD+JSH1PhQkWFtwYr0OhJB1Oe4pT786yCpVPhIgM2qxgiqDDvAHKM5ygnD9f81w
         SQL8TYxGFMw5uONXpsvLBl/5T7vTxy/nq7dw+Efxcu5KFk+YPhCnPSAx7gQiTGLxYoC7
         JRoB4bmR4ZEL0dOnSJat0jiOoKsWqMoXmMWWRlUvxM+l0YBOtylxX21/puY3Um+XkD8B
         h2hKDitHHqq8GAYba2OFEvOwfWVt13X7oVLmE5008yhe1/tEfJQlb/UMMWFhj0ozRk/n
         +Hh5mBP8huf4MWevx7ov23rCuE84bt9oqNxi6wN0Q7a1rycGzFiwKU68J1MrjqLzSMGF
         kIiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NcQ0y1B3oOpn7msq4twenQ6s53o6uoLRVdI3pK6krVk=;
        b=uLMKxNVZkVIylnwPwwyfTkYbA3SqSyUZ355j8G8VzzSGRxuj9NYaGd9nVBt+MqO5Xp
         WsyNmWCszVENI7lsFPga88tyXEQ/rrSax4DnT9Mqdf9iqRxCF47DtyUXCxtJ/DgkuDgL
         3HaaDnsUCQCWgrBjzk7To5TiIO2zpoQt5sEIAQ8LkaBSseoJEKOEo28Va902PzzWNA36
         KRwR+qUQnT5GktH/sgtMMpJTRnk8LSo/lYsQ0iPBuSWBJCWdBdj1BKERcmvYQjPCF1nY
         gkSL9g964Q66TcmAg65DJuEaB9d/Yo1M+u8O155MJsP+0rHUUQqOlh6EoLzcyq9fgpja
         1iCA==
X-Gm-Message-State: AO0yUKU07pNJ12ON0EWl2a2n38d5Q/4Ip9s2Xk9G1Sj7281z4SWqI4gK
        KkNiBw0N6leVy+BRo3EWVcQhW6rqYi+Xt8CgdYMDPA==
X-Google-Smtp-Source: AK7set/lExjyoQLCjeUSAts7LthjJTpRm2pi8pj8+/iJ2wOIiO8RUQqq6L5VaN5tUcHGYag7fupWkw==
X-Received: by 2002:a17:903:1cc:b0:196:63d0:a674 with SMTP id e12-20020a17090301cc00b0019663d0a674mr7378455plh.9.1675323960184;
        Wed, 01 Feb 2023 23:46:00 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c6-20020a170903234600b001947ba0ac8fsm9695000plh.236.2023.02.01.23.45.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 23:45:59 -0800 (PST)
Message-ID: <63db6a37.170a0220.200a0.1be6@mx.google.com>
Date:   Wed, 01 Feb 2023 23:45:59 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.165-149-gfd12020450ea
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 178 runs,
 5 regressions (v5.10.165-149-gfd12020450ea)
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

stable-rc/queue/5.10 baseline: 178 runs, 5 regressions (v5.10.165-149-gfd12=
020450ea)

Regressions Summary
-------------------

platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
bcm2711-rpi-4-b              | arm64 | lab-linaro-lkft | gcc-10   | defconf=
ig           | 1          =

beagle-xm                    | arm   | lab-baylibre    | gcc-10   | omap2pl=
us_defconfig | 1          =

cubietruck                   | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig  | 1          =

stm32mp157c-dk2              | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig  | 1          =

sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.165-149-gfd12020450ea/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.165-149-gfd12020450ea
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fd12020450ead2b166f9af695bb56ca40ca11d7d =



Test Regressions
---------------- =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
bcm2711-rpi-4-b              | arm64 | lab-linaro-lkft | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63db6978b1e4dee516915ebd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-149-gfd12020450ea/arm64/defconfig/gcc-10/lab-linaro-lkft/baseline-bcm2711-=
rpi-4-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-149-gfd12020450ea/arm64/defconfig/gcc-10/lab-linaro-lkft/baseline-bcm2711-=
rpi-4-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63db6978b1e4dee516915=
ebe
        new failure (last pass: v5.10.165-149-ge30e8271d674) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
beagle-xm                    | arm   | lab-baylibre    | gcc-10   | omap2pl=
us_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63db36ba427c993222915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-149-gfd12020450ea/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-149-gfd12020450ea/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63db36ba427c993222915=
eba
        new failure (last pass: v5.10.165-149-ge30e8271d674) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
cubietruck                   | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/63db37637073be15ed915ec4

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-149-gfd12020450ea/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-149-gfd12020450ea/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63db37637073be15ed915ec9
        failing since 6 days (last pass: v5.10.165-76-g5c2e982fcf18, first =
fail: v5.10.165-77-g4600242c13ed)

    2023-02-02T04:08:39.578665  <8>[   11.123129] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3270082_1.5.2.4.1>
    2023-02-02T04:08:39.685404  / # #
    2023-02-02T04:08:39.787215  export SHELL=3D/bin/sh
    2023-02-02T04:08:39.787639  #
    2023-02-02T04:08:39.888926  / # export SHELL=3D/bin/sh. /lava-3270082/e=
nvironment
    2023-02-02T04:08:39.889335  =

    2023-02-02T04:08:39.990688  / # . /lava-3270082/environment/lava-327008=
2/bin/lava-test-runner /lava-3270082/1
    2023-02-02T04:08:39.992181  =

    2023-02-02T04:08:39.992675  / # <3>[   11.451907] Bluetooth: hci0: comm=
and 0x0c03 tx timeout
    2023-02-02T04:08:39.996501  /lava-3270082/bin/lava-test-runner /lava-32=
70082/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
stm32mp157c-dk2              | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/63db364c8ee23f46ae915f12

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-149-gfd12020450ea/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-stm3=
2mp157c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-149-gfd12020450ea/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-stm3=
2mp157c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63db364c8ee23f46ae915f17
        failing since 0 day (last pass: v5.10.147-29-g9a9285d3dc114, first =
fail: v5.10.165-149-ge30e8271d674)

    2023-02-02T04:04:12.185118  <8>[   12.700050] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3270087_1.5.2.4.1>
    2023-02-02T04:04:12.291091  / # #
    2023-02-02T04:04:12.393738  export SHELL=3D/bin/sh
    2023-02-02T04:04:12.394482  #
    2023-02-02T04:04:12.496285  / # export SHELL=3D/bin/sh. /lava-3270087/e=
nvironment
    2023-02-02T04:04:12.496782  =

    2023-02-02T04:04:12.598400  / # . /lava-3270087/environment/lava-327008=
7/bin/lava-test-runner /lava-3270087/1
    2023-02-02T04:04:12.599665  =

    2023-02-02T04:04:12.603186  / # /lava-3270087/bin/lava-test-runner /lav=
a-3270087/1
    2023-02-02T04:04:12.669336  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/63db3670e18db4fab4915eb9

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-149-gfd12020450ea/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-149-gfd12020450ea/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63db3670e18db4fab4915ebe
        failing since 0 day (last pass: v5.10.165-139-gefb57ce0f880, first =
fail: v5.10.165-149-ge30e8271d674)

    2023-02-02T04:04:46.568709  / # #
    2023-02-02T04:04:46.670376  export SHELL=3D/bin/sh
    2023-02-02T04:04:46.670723  #
    2023-02-02T04:04:46.772028  / # export SHELL=3D/bin/sh. /lava-3270086/e=
nvironment
    2023-02-02T04:04:46.772374  =

    2023-02-02T04:04:46.873746  / # . /lava-3270086/environment/lava-327008=
6/bin/lava-test-runner /lava-3270086/1
    2023-02-02T04:04:46.874344  =

    2023-02-02T04:04:46.880029  / # /lava-3270086/bin/lava-test-runner /lav=
a-3270086/1
    2023-02-02T04:04:46.944116  + export 'TESTRUN_ID=3D1_bootrr'
    2023-02-02T04:04:46.978882  + cd /lava-3270086/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
