Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECB06C38F2
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 19:11:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbjCUSLG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 14:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjCUSLF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 14:11:05 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D03D38670
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 11:11:02 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id d8so9111042pgm.3
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 11:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679422261;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=B41xwcKS8XEJMDPx1xNWAI2EcJHmDxF1HJ0x35uN92g=;
        b=KCyzFwEDYhozd/VcnzLbOCcde0hkOv9Ff9cjmHpt7EQxtWwCOK9aoVuxfUZdEKdVZZ
         gFQoBI1HILaam6YlmLD3zHRPTasbvwBa5Qj7cn5hCe9bS6tEwS40x+jN4ZmM6ieKoOOF
         7A0fGeaZjbmCI7KKL78+SfLFQEkgBtUjgI07eBmvjP0yqnNhvxRZWRYMl2aP0aSPVKIV
         tV8KThsit/oICTC1uOiSpBRa2Tqtplr/T0ZIDbVBN65TJ0Nm40gQ3it53yrSBIVu7qoX
         nrp5FrXMT7pvGRazBFHGaDLUE8qJEexj0IZL4VuS+SZVIjuVkeqIMKEfCXFd0wsjAmPC
         Py0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679422261;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B41xwcKS8XEJMDPx1xNWAI2EcJHmDxF1HJ0x35uN92g=;
        b=mRgdD0xF0LPaUZcwrIEqQRYMV3SRY1K8DL/aCJIXMRRLYodiAAezWypsZlK4WTnZEx
         NR2AV19g/Y951zz8hxC09G6wlpmxQo5grp8bjIARNaJXkDoJWGQILvy33zCJMdlhY0M/
         X0IkOf0EZHyJ2lrpbSCl66xK3R6vlhNQAKgX9TO78kB9CpVQApxffk7nW9BfoCXab6L7
         rqFXsz4j9fAAjuiTyD9pg03LTXV0ELtVwA8E3wPj5tbLQnv+54dO3UviPKRYt09oPkLy
         pqnZU2Y/7cLHmqaY5oOfrdnaFElkDlcrsqqlP64slSyxqiJq96ZQa6TNWMMkFf/cz0ZE
         q3pA==
X-Gm-Message-State: AO0yUKX1CMNLxrpMcbcsu+/w10I4YsRcElk5ygAFYEUNpj4FFuZK0JJe
        w69KWGg5FrS3c/DS5daB67b2tHBe8IU0wvTccOC2sQ==
X-Google-Smtp-Source: AK7set9XBocxyFGfPVMMKMd0Lkj4o5nQn6fR93RR/2Ws9eknEaZL8K6+M61v72qWiD6nrmzPt2aP+Q==
X-Received: by 2002:aa7:9619:0:b0:627:eb0a:56e9 with SMTP id q25-20020aa79619000000b00627eb0a56e9mr595399pfg.29.1679422261596;
        Tue, 21 Mar 2023 11:11:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t19-20020a62ea13000000b005a8de0f4c64sm8508921pfh.82.2023.03.21.11.11.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 11:11:01 -0700 (PDT)
Message-ID: <6419f335.620a0220.9e656.f6e0@mx.google.com>
Date:   Tue, 21 Mar 2023 11:11:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.175-98-g9048b2ac4673
Subject: stable-rc/queue/5.10 baseline: 156 runs,
 5 regressions (v5.10.175-98-g9048b2ac4673)
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

stable-rc/queue/5.10 baseline: 156 runs, 5 regressions (v5.10.175-98-g9048b=
2ac4673)

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
nel/v5.10.175-98-g9048b2ac4673/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.175-98-g9048b2ac4673
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9048b2ac4673f5fec7187befca4cc9431488a5d7 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
beaglebone-black             | arm   | lab-broonie   | gcc-10   | omap2plus=
_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/6419bc6d71333d62ec9c950e

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-98-g9048b2ac4673/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beagl=
ebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-98-g9048b2ac4673/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beagl=
ebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6419bc6d71333d62ec9c9548
        failing since 35 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-03-21T14:17:03.399523  <8>[   25.006783] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 200124_1.5.2.4.1>
    2023-03-21T14:17:03.510501  / # #
    2023-03-21T14:17:03.612826  export SHELL=3D/bin/sh
    2023-03-21T14:17:03.613593  #
    2023-03-21T14:17:03.715302  / # export SHELL=3D/bin/sh. /lava-200124/en=
vironment
    2023-03-21T14:17:03.715930  =

    2023-03-21T14:17:03.817696  / # . /lava-200124/environment/lava-200124/=
bin/lava-test-runner /lava-200124/1
    2023-03-21T14:17:03.818915  =

    2023-03-21T14:17:03.822350  / # /lava-200124/bin/lava-test-runner /lava=
-200124/1
    2023-03-21T14:17:03.927810  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
cubietruck                   | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/6419bd2c12238fb4dc9c951b

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-98-g9048b2ac4673/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-98-g9048b2ac4673/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6419bd2c12238fb4dc9c9524
        failing since 54 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-03-21T14:20:15.165422  <8>[   11.125790] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3431637_1.5.2.4.1>
    2023-03-21T14:20:15.277152  / # #
    2023-03-21T14:20:15.381399  export SHELL=3D/bin/sh
    2023-03-21T14:20:15.382583  #
    2023-03-21T14:20:15.484824  / # export SHELL=3D/bin/sh. /lava-3431637/e=
nvironment
    2023-03-21T14:20:15.486012  =

    2023-03-21T14:20:15.588391  / # . /lava-3431637/environment/lava-343163=
7/bin/lava-test-runner /lava-3431637/1
    2023-03-21T14:20:15.590844  =

    2023-03-21T14:20:15.591574  / # /lava-3431637/bin/lava-test-runner /lav=
a-3431637/1<3>[   11.530984] Bluetooth: hci0: command 0x0c03 tx timeout
    2023-03-21T14:20:15.594914   =

    ... (12 line(s) more)  =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
rk3399-gru-kevin             | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 2          =


  Details:     https://kernelci.org/test/plan/id/6419c134dd43e275709c957f

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-98-g9048b2ac4673/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-98-g9048b2ac4673/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/6419c134dd43e275709c9589
        failing since 7 days (last pass: v5.10.172-529-g06956b9e9396, first=
 fail: v5.10.173-69-gfcbe6bd469ed)

    2023-03-21T14:37:28.615582  <8>[   33.815379] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>

    2023-03-21T14:37:29.640370  /lava-9715372/1/../bin/lava-test-case

    2023-03-21T14:37:29.650360  <8>[   34.851266] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/6419c134dd43e275709c958a
        failing since 7 days (last pass: v5.10.172-529-g06956b9e9396, first=
 fail: v5.10.173-69-gfcbe6bd469ed)

    2023-03-21T14:37:28.603993  /lava-9715372/1/../bin/lava-test-case
   =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/6419bc8eec7b55a5f29c9524

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-98-g9048b2ac4673/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i=
-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-98-g9048b2ac4673/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i=
-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6419bc8eec7b55a5f29c952d
        failing since 47 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-03-21T14:17:23.905073  =

    2023-03-21T14:17:24.006585  / # #export SHELL=3D/bin/sh
    2023-03-21T14:17:24.006949  =

    2023-03-21T14:17:24.108278  / # export SHELL=3D/bin/sh. /lava-3431642/e=
nvironment
    2023-03-21T14:17:24.108660  =

    2023-03-21T14:17:24.210015  / # . /lava-3431642/environment/lava-343164=
2/bin/lava-test-runner /lava-3431642/1
    2023-03-21T14:17:24.210656  =

    2023-03-21T14:17:24.216277  / # /lava-3431642/bin/lava-test-runner /lav=
a-3431642/1
    2023-03-21T14:17:24.320192  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-21T14:17:24.320507  + cd /lava-3431642/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
