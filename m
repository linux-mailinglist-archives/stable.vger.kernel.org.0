Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DAE66E989B
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 17:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231435AbjDTPnY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 11:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbjDTPnX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 11:43:23 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCB7FE2
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 08:43:21 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-63b51fd2972so1003516b3a.3
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 08:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682005401; x=1684597401;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=8jtQFmrObKLhBM1e98JPfSvBUNGkbCuRoQtDQ0hBXEw=;
        b=PPo2AhBb28OthIQIJMhIeNN2DsrIiFLvf3ZceWBzsQ935LdXfzLYqrCEycx9aMn20C
         S3w1ye8hmDslaLV9EVcMqrh2LBfNLZYru+Zfm7M/MlFkfgbIBQJz73ybWeipOPy+ykqH
         Pa5CZF26JLMWM6FuWARoNv04X4zfgkp9bOX9gAewpefQmwBjuSFleC2nn9zNx2vJhcA9
         v1xPJQbSL+KIvzyRx2Y929Mi5EQykpAo8nNYhH8CeD2jpQq9jps9o9Hj9YwDFR1Mk7PD
         VlmlxXFVG0w453+aiu8kEZ+T7gngcBJIKLVc11L9HejD8aJCdDUUq6QITVL8ky7EJ5lX
         0K3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682005401; x=1684597401;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8jtQFmrObKLhBM1e98JPfSvBUNGkbCuRoQtDQ0hBXEw=;
        b=OwDbo/ww31M1FujZ6C4Fs+0KHSRVlreH5zsgMgCkSP7IkTdk/HshYnGBguQ441dBfj
         QuaxWdowF66q0vl6tEpu8Cx4Liga5nRiYntBl3GjxL6DkHqzi0XwjPUunTsn2IMCTk3R
         uPO72X3LRhmX20HVDFcWEf9bBsXKF39WVG26nxi3W2UBWn0fYSnSCgE3eQBnFm48DI68
         T1+jIarKglyiebx9SD6O0XV/MKtZByTgTHk7Ay52b4xxMgRz/IX9dzDdCOmxXzRLvqX3
         HsKYl6ldo4cEyOUCCZRBJ90xS9lgwX4wZDllc6d8uZW/5y69unv/GW6o9C4PFuIIrdnk
         MpWg==
X-Gm-Message-State: AAQBX9fhz+EUSUIh67kBYP16UsQHTFiHFwQMjlD9CrN/0KqUdENjPGfV
        CWHaZY7mRn1/bzZdeXjAMXiEZ8X9UF5wPRCtUreuxXyB
X-Google-Smtp-Source: AKy350bxXD1/0YMTLChjS51zuW1GNYdLMlkaxuV6VhL0UpDjwPN8pcp40kl5ll3tmj/qxZwTmG3Crg==
X-Received: by 2002:a05:6a00:2da1:b0:63d:254a:3918 with SMTP id fb33-20020a056a002da100b0063d254a3918mr1914464pfb.29.1682005401148;
        Thu, 20 Apr 2023 08:43:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h125-20020a628383000000b0063b87717661sm1418221pfe.85.2023.04.20.08.43.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 08:43:20 -0700 (PDT)
Message-ID: <64415d98.620a0220.67a38.298a@mx.google.com>
Date:   Thu, 20 Apr 2023 08:43:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.176-293-gbe4d154b8d11
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 131 runs,
 6 regressions (v5.10.176-293-gbe4d154b8d11)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 131 runs, 6 regressions (v5.10.176-293-gbe4d=
154b8d11)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.176-293-gbe4d154b8d11/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.176-293-gbe4d154b8d11
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      be4d154b8d11c2894c9287ad0720726621b19912 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/64412a635de75624ac2e8627

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-293-gbe4d154b8d11/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-293-gbe4d154b8d11/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64412a635de75624ac2e865b
        failing since 65 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-04-20T12:04:23.479188  <8>[   20.722576] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 360595_1.5.2.4.1>
    2023-04-20T12:04:23.631222  / # #
    2023-04-20T12:04:23.744745  export SHELL=3D/bin/sh
    2023-04-20T12:04:23.748896  #
    2023-04-20T12:04:23.856390  / # export SHELL=3D/bin/sh. /lava-360595/en=
vironment
    2023-04-20T12:04:23.860500  =

    2023-04-20T12:04:23.968175  / # . /lava-360595/environment/lava-360595/=
bin/lava-test-runner /lava-360595/1
    2023-04-20T12:04:23.975399  =

    2023-04-20T12:04:23.978564  / # /lava-360595/bin/lava-test-runner /lava=
-360595/1
    2023-04-20T12:04:24.080112  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64412cb2d89d2c2ae42e85fa

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-293-gbe4d154b8d11/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-293-gbe4d154b8d11/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64412cb2d89d2c2ae42e85ff
        failing since 84 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-04-20T12:14:22.091851  <8>[   11.065432] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3516016_1.5.2.4.1>
    2023-04-20T12:14:22.200962  / # #
    2023-04-20T12:14:22.304189  export SHELL=3D/bin/sh
    2023-04-20T12:14:22.305213  #
    2023-04-20T12:14:22.407406  / # export SHELL=3D/bin/sh. /lava-3516016/e=
nvironment
    2023-04-20T12:14:22.408402  =

    2023-04-20T12:14:22.510616  / # . /lava-3516016/environment/lava-351601=
6/bin/lava-test-runner /lava-3516016/1
    2023-04-20T12:14:22.512164  =

    2023-04-20T12:14:22.517128  / # /lava-3516016/bin/lava-test-runner /lav=
a-3516016/1
    2023-04-20T12:14:22.599101  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64412c786e8cc6382d2e85e6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-293-gbe4d154b8d11/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-293-gbe4d154b8d11/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64412c786e8cc6382d2e85eb
        failing since 21 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-20T12:13:30.831364  + set +x

    2023-04-20T12:13:30.837712  <8>[   10.184185] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10061164_1.4.2.3.1>

    2023-04-20T12:13:30.942783  / # #

    2023-04-20T12:13:31.043789  export SHELL=3D/bin/sh

    2023-04-20T12:13:31.043967  #

    2023-04-20T12:13:31.144946  / # export SHELL=3D/bin/sh. /lava-10061164/=
environment

    2023-04-20T12:13:31.145151  =


    2023-04-20T12:13:31.246093  / # . /lava-10061164/environment/lava-10061=
164/bin/lava-test-runner /lava-10061164/1

    2023-04-20T12:13:31.246366  =


    2023-04-20T12:13:31.251698  / # /lava-10061164/bin/lava-test-runner /la=
va-10061164/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64412c79b7f8d982642e85ff

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-293-gbe4d154b8d11/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-293-gbe4d154b8d11/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64412c79b7f8d982642e8604
        failing since 21 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-20T12:13:27.385871  <8>[   11.691402] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10061195_1.4.2.3.1>

    2023-04-20T12:13:27.389285  + set +x

    2023-04-20T12:13:27.493899  / # #

    2023-04-20T12:13:27.594707  export SHELL=3D/bin/sh

    2023-04-20T12:13:27.594883  #

    2023-04-20T12:13:27.695777  / # export SHELL=3D/bin/sh. /lava-10061195/=
environment

    2023-04-20T12:13:27.695943  =


    2023-04-20T12:13:27.796806  / # . /lava-10061195/environment/lava-10061=
195/bin/lava-test-runner /lava-10061195/1

    2023-04-20T12:13:27.797049  =


    2023-04-20T12:13:27.802056  / # /lava-10061195/bin/lava-test-runner /la=
va-10061195/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/64412afc23ec004df22e85f7

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-293-gbe4d154b8d11/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-293-gbe4d154b8d11/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/64412afc23ec004df22e85fd
        failing since 37 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-20T12:07:14.911713  /lava-10061030/1/../bin/lava-test-case

    2023-04-20T12:07:14.922834  <8>[   35.057879] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/64412afc23ec004df22e85fe
        failing since 37 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-20T12:07:13.875349  /lava-10061030/1/../bin/lava-test-case

    2023-04-20T12:07:13.886440  <8>[   34.020843] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =20
