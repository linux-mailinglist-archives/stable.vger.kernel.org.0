Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B58D96D815F
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 17:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238726AbjDEPQ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 11:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238727AbjDEPQF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 11:16:05 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2918A7A96
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 08:14:18 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id h12-20020a17090aea8c00b0023d1311fab3so37622695pjz.1
        for <stable@vger.kernel.org>; Wed, 05 Apr 2023 08:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680707651;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=gLxEMvlifhLavKLGOfegF/2n7Tz2JhBxtBiLJ/mxWvs=;
        b=MGg0JuQdPdUIeY1KL8trmG0No26usOY62OYKuB39JvCGkXGIZGr73AtqZ431xRuu8g
         3WQan+ph4wOUmSEyH7k2UX7PBiQlH8hwlQU3U7fdMhhazFV5U+4qDMqoh2qXLIG3SODm
         4gfEORvlmazfcVi/zCKzVAKMu1nAH/jcyRpBwHn+EfVRtoWXanJdImbqMMLDzJOaMrx+
         ghLLnX3KfMivhrknrtcGsG9eZkFbOfAW2wENfOSe+wnu8stMwfOqAQ5IeUJZGM/12D+L
         D7Mfl81BOeOeIhpT2+ngMoMl2tXvrGAPFIAj96fZ6paeH51J2xMFlEkrTTSNjPQvCwxS
         mO2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680707651;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gLxEMvlifhLavKLGOfegF/2n7Tz2JhBxtBiLJ/mxWvs=;
        b=kRfkuARG+uRR+mEniacz1/pkFHaq+gzI0GlWVUvq12yPg5+BLIa666vg8OobpsHRuj
         ASa2wVENqHTBMAJpW2ta9GYAFghIbPNBS+TN0WjqIxsQBQmdQkd8qmVyZ2aQsa1K34Zh
         h8NDBVztD4qZQIGGpRoK4nt6bPWRxc7qpfQxIX1ic7RHdzzEfMYuJb+v7GC77Bp6dUj7
         spdzPGluJgfWOHXX/tPH8DRT61XSdh5YvuL9h5p8BEic5FA1B5dJbt9x4ZemdUlJoDVQ
         Lm8n+aeM/KKscn4if3Tx6YljoEZqEEA5FAymx63zsLE5f//puKej5HlDPjj6HNeB6dKZ
         jTEw==
X-Gm-Message-State: AAQBX9dy/XULqJH8rCYE53hWE4LHf33cNYeq1rhIkuhiGsSUnei714+A
        bMDGF4oG9Tv14DSRUtbSrpXTUGe6P5pKBGnl9UbJsA==
X-Google-Smtp-Source: AKy350YD+mJvWEkNBjlc8ntmKmpnVwn6m8wi3+AcpRwT22wkwZgZPPSKuMVE1bFUmzqrV3IBUnUajQ==
X-Received: by 2002:a17:90a:5e4d:b0:23f:58d6:b532 with SMTP id u13-20020a17090a5e4d00b0023f58d6b532mr7169019pji.5.1680707650653;
        Wed, 05 Apr 2023 08:14:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n15-20020a17090a2bcf00b0023a84911df2sm1505195pje.7.2023.04.05.08.14.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 08:14:10 -0700 (PDT)
Message-ID: <642d9042.170a0220.16f0e.2f6e@mx.google.com>
Date:   Wed, 05 Apr 2023 08:14:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.176-172-gbdb8a7cd3cc4
Subject: stable-rc/queue/5.10 baseline: 165 runs,
 7 regressions (v5.10.176-172-gbdb8a7cd3cc4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 165 runs, 7 regressions (v5.10.176-172-gbdb8=
a7cd3cc4)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =

cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =

sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.176-172-gbdb8a7cd3cc4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.176-172-gbdb8a7cd3cc4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bdb8a7cd3cc4326e8b59fa4aa30b874b297d70ed =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/642d5e482ef31dd4e379e928

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-172-gbdb8a7cd3cc4/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-172-gbdb8a7cd3cc4/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642d5e482ef31dd4e379e95e
        failing since 50 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-04-05T11:40:40.919842  <8>[   21.499768] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 282399_1.5.2.4.1>
    2023-04-05T11:40:41.029263  / # #
    2023-04-05T11:40:41.131402  export SHELL=3D/bin/sh
    2023-04-05T11:40:41.131964  #
    2023-04-05T11:40:41.233385  / # export SHELL=3D/bin/sh. /lava-282399/en=
vironment
    2023-04-05T11:40:41.234133  =

    2023-04-05T11:40:41.336133  / # . /lava-282399/environment/lava-282399/=
bin/lava-test-runner /lava-282399/1
    2023-04-05T11:40:41.337727  =

    2023-04-05T11:40:41.340890  / # /lava-282399/bin/lava-test-runner /lava=
-282399/1
    2023-04-05T11:40:41.446871  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/642d5f737e7ccefecb79e92e

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-172-gbdb8a7cd3cc4/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-172-gbdb8a7cd3cc4/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642d5f737e7ccefecb79e933
        failing since 68 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-04-05T11:45:38.196931  <8>[   11.109296] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3473122_1.5.2.4.1>
    2023-04-05T11:45:38.305897  / # #
    2023-04-05T11:45:38.407416  export SHELL=3D/bin/sh
    2023-04-05T11:45:38.407783  #
    2023-04-05T11:45:38.509068  / # export SHELL=3D/bin/sh. /lava-3473122/e=
nvironment
    2023-04-05T11:45:38.509954  =

    2023-04-05T11:45:38.611746  / # . /lava-3473122/environment/lava-347312=
2/bin/lava-test-runner /lava-3473122/1
    2023-04-05T11:45:38.612319  =

    2023-04-05T11:45:38.612524  / # <3>[   11.451487] Bluetooth: hci0: comm=
and 0x0c03 tx timeout
    2023-04-05T11:45:38.617542  /lava-3473122/bin/lava-test-runner /lava-34=
73122/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642d5cc4420d71b08279e993

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-172-gbdb8a7cd3cc4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-172-gbdb8a7cd3cc4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642d5cc4420d71b08279e998
        failing since 6 days (last pass: v5.10.176-61-g2332301f1fab4, first=
 fail: v5.10.176-104-g2b4187983740)

    2023-04-05T11:34:17.000668  + set +x

    2023-04-05T11:34:17.007435  <8>[   14.552314] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9877623_1.4.2.3.1>

    2023-04-05T11:34:17.111891  / # #

    2023-04-05T11:34:17.212952  export SHELL=3D/bin/sh

    2023-04-05T11:34:17.213158  #

    2023-04-05T11:34:17.314155  / # export SHELL=3D/bin/sh. /lava-9877623/e=
nvironment

    2023-04-05T11:34:17.314364  =


    2023-04-05T11:34:17.415319  / # . /lava-9877623/environment/lava-987762=
3/bin/lava-test-runner /lava-9877623/1

    2023-04-05T11:34:17.415598  =


    2023-04-05T11:34:17.420630  / # /lava-9877623/bin/lava-test-runner /lav=
a-9877623/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642d5c9a32c891b33879e94c

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-172-gbdb8a7cd3cc4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-172-gbdb8a7cd3cc4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642d5c9a32c891b33879e94f
        failing since 6 days (last pass: v5.10.176-61-g2332301f1fab4, first=
 fail: v5.10.176-104-g2b4187983740)

    2023-04-05T11:33:24.107752  <8>[   11.860604] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9877629_1.4.2.3.1>

    2023-04-05T11:33:24.110916  + set +x

    2023-04-05T11:33:24.215754  / # #

    2023-04-05T11:33:24.316851  export SHELL=3D/bin/sh

    2023-04-05T11:33:24.317007  #

    2023-04-05T11:33:24.418017  / # export SHELL=3D/bin/sh. /lava-9877629/e=
nvironment

    2023-04-05T11:33:24.418224  =


    2023-04-05T11:33:24.519096  / # . /lava-9877629/environment/lava-987762=
9/bin/lava-test-runner /lava-9877629/1

    2023-04-05T11:33:24.519392  =


    2023-04-05T11:33:24.524175  / # /lava-9877629/bin/lava-test-runner /lav=
a-9877629/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/642d6217849419cd1679e977

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-172-gbdb8a7cd3cc4/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-172-gbdb8a7cd3cc4/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/642d6217849419cd1679e97d
        failing since 22 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-05T11:57:03.105664  /lava-9877810/1/../bin/lava-test-case

    2023-04-05T11:57:03.116976  <8>[   34.899167] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/642d6217849419cd1679e97e
        failing since 22 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-05T11:57:02.070355  /lava-9877810/1/../bin/lava-test-case

    2023-04-05T11:57:02.081624  <8>[   33.864040] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/642d5e395634a7c59c79e978

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-172-gbdb8a7cd3cc4/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-172-gbdb8a7cd3cc4/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642d5e395634a7c59c79e97d
        failing since 62 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-04-05T11:40:26.728538  / # #
    2023-04-05T11:40:26.830703  export SHELL=3D/bin/sh
    2023-04-05T11:40:26.831389  #
    2023-04-05T11:40:26.933083  / # export SHELL=3D/bin/sh. /lava-3473126/e=
nvironment
    2023-04-05T11:40:26.933842  =

    2023-04-05T11:40:27.035549  / # . /lava-3473126/environment/lava-347312=
6/bin/lava-test-runner /lava-3473126/1
    2023-04-05T11:40:27.036676  =

    2023-04-05T11:40:27.052666  / # /lava-3473126/bin/lava-test-runner /lav=
a-3473126/1
    2023-04-05T11:40:27.140540  + export 'TESTRUN_ID=3D1_bootrr'
    2023-04-05T11:40:27.141116  + cd /lava-3473126/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
