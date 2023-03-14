Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6267D6B981B
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 15:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbjCNOhQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 10:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231270AbjCNOhM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 10:37:12 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B32FBA9DE3
        for <stable@vger.kernel.org>; Tue, 14 Mar 2023 07:37:07 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id h11-20020a17090a2ecb00b00237c740335cso15347481pjs.3
        for <stable@vger.kernel.org>; Tue, 14 Mar 2023 07:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678804627;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=mG5XmmKO8IPxinoII9mmWs8hbzoFt+6YX77mLiXeMqk=;
        b=vAurxCmruECl0+OGNwXqjZUdiRxvrVrSNj4ntcA/KNA52xv3gek1EMlgtVXsgOQqrC
         3PS2tOtBf/wwcZ9ugvVq0mqicO4gmaHlWCzB+eR3XR+QBuLky7N4rUMjy/v8GiTb7YRz
         EbRcju1sbiXBUT/ES5W05Wp/zfqy8B0AC819vTDSjf8hUgvjXbxrjSr5WMTxoXUHaRiD
         gUMQ+nbnGHNdZlzWBWvxr/0cMK8ciEA96b4boE92REROz0QfChZ/zdcsmjaaVMJTwfE4
         IBIWtR8TQaPoMdyox0r9O1I45LgdOscMFTbu+hxrO70y4RorE86XBLDQwQ6rkFmpLzdM
         vy+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678804627;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mG5XmmKO8IPxinoII9mmWs8hbzoFt+6YX77mLiXeMqk=;
        b=sqKLjY6DWkNG6sb8vPXFh3OiGfnFvZp3k3FH0k1gUHPDZ+cP0AKulSNmjEMUuKwcH2
         0Ph8oOrfGKuuR+DDaM+E5FT+Q3mmR5UrTHJvYH1avONVVPWIXcc5pdYj5l/CQPX1qN2W
         2wPnZpiocqZfS8ufUH+Ek+zwYfVue3nPo1/KPz2jJqTN8xBl8DCwVaiMNsQvqN6+B8XZ
         Q/+OsfHhJmmlKsAPO+j80wV7QLXuZ4l9ADgUwUpM7A/Ih+ZxRcE9IhIPxOl7eNXC3jHB
         YHq8dwyBZ1rQGVVGRU0WUmbb50Uif8EgyBzzj8Esg/VQl2cLK1FyePS49TPd0pwTRpBS
         fcMQ==
X-Gm-Message-State: AO0yUKVKAQMg2DxPnx7i3OcVyHNqgoPXb5248URSLx6tRt9fvWW51aNJ
        5fqAvnShxxX1Y7xWr1yWpryzqtT1tbMWM3F+2eh33w==
X-Google-Smtp-Source: AK7set/L7I6ku69gNc2vLbT99Y19B6bBbOxjQTONwN4yl7TwJINCqrU20vbueCWDysq6lQNS7XMtSw==
X-Received: by 2002:a17:903:1251:b0:19e:d60a:e9e with SMTP id u17-20020a170903125100b0019ed60a0e9emr29949287plh.42.1678804626870;
        Tue, 14 Mar 2023 07:37:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h17-20020a170902f55100b0019f3a28ea29sm1851920plf.160.2023.03.14.07.37.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 07:37:06 -0700 (PDT)
Message-ID: <64108692.170a0220.ffc54.4490@mx.google.com>
Date:   Tue, 14 Mar 2023 07:37:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.173-78-g2e9a706c2ad07
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 165 runs,
 4 regressions (v5.10.173-78-g2e9a706c2ad07)
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

stable-rc/queue/5.10 baseline: 165 runs, 4 regressions (v5.10.173-78-g2e9a7=
06c2ad07)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
beaglebone-black             | arm   | lab-broonie   | gcc-10   | omap2plus=
_defconfig        | 1          =

rk3399-gru-kevin             | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 2          =

sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.173-78-g2e9a706c2ad07/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.173-78-g2e9a706c2ad07
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2e9a706c2ad072a55cca9dada43ca479f763b092 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
beaglebone-black             | arm   | lab-broonie   | gcc-10   | omap2plus=
_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/6410544a425b70a23f8c865c

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-78-g2e9a706c2ad07/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-78-g2e9a706c2ad07/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6410544a425b70a23f8c8693
        failing since 28 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-03-14T11:02:15.600440  + set +x
    2023-03-14T11:02:15.603787  <8>[   20.402380] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 159879_1.5.2.4.1>
    2023-03-14T11:02:15.715190  / # #
    2023-03-14T11:02:15.817233  export SHELL=3D/bin/sh
    2023-03-14T11:02:15.818042  #
    2023-03-14T11:02:15.920162  / # export SHELL=3D/bin/sh. /lava-159879/en=
vironment
    2023-03-14T11:02:15.921042  =

    2023-03-14T11:02:16.022904  / # . /lava-159879/environment/lava-159879/=
bin/lava-test-runner /lava-159879/1
    2023-03-14T11:02:16.023862  =

    2023-03-14T11:02:16.027033  / # /lava-159879/bin/lava-test-runner /lava=
-159879/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
rk3399-gru-kevin             | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 2          =


  Details:     https://kernelci.org/test/plan/id/64105603e81d1ecce78c8658

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-78-g2e9a706c2ad07/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-78-g2e9a706c2ad07/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/64105603e81d1ecce78c8662
        failing since 0 day (last pass: v5.10.172-529-g06956b9e9396, first =
fail: v5.10.173-69-gfcbe6bd469ed)

    2023-03-14T11:09:36.309249  /lava-9607250/1/../bin/lava-test-case

    2023-03-14T11:09:36.320381  <8>[   61.432080] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/64105603e81d1ecce78c8663
        failing since 0 day (last pass: v5.10.172-529-g06956b9e9396, first =
fail: v5.10.173-69-gfcbe6bd469ed)

    2023-03-14T11:09:34.250614  <8>[   59.359830] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy-driver-present RESULT=3Dpass>

    2023-03-14T11:09:35.274970  /lava-9607250/1/../bin/lava-test-case

    2023-03-14T11:09:35.286037  <8>[   60.397310] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/641050eec58490493e8c8678

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-78-g2e9a706c2ad07/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-78-g2e9a706c2ad07/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/641050eec58490493e8c8681
        failing since 40 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-03-14T10:47:46.764367  <8>[    8.439006] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3410061_1.5.2.4.1>
    2023-03-14T10:47:46.869728  / # #
    2023-03-14T10:47:46.971554  export SHELL=3D/bin/sh
    2023-03-14T10:47:46.971931  #
    2023-03-14T10:47:47.073323  / # export SHELL=3D/bin/sh. /lava-3410061/e=
nvironment
    2023-03-14T10:47:47.073705  =

    2023-03-14T10:47:47.175028  / # . /lava-3410061/environment/lava-341006=
1/bin/lava-test-runner /lava-3410061/1
    2023-03-14T10:47:47.175668  =

    2023-03-14T10:47:47.181819  / # /lava-3410061/bin/lava-test-runner /lav=
a-3410061/1
    2023-03-14T10:47:47.277899  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =20
