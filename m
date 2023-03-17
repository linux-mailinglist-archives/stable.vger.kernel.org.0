Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51C906BEF87
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 18:21:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbjCQRV2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 13:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbjCQRVX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 13:21:23 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FAE7E41CE
        for <stable@vger.kernel.org>; Fri, 17 Mar 2023 10:21:06 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id h8so5993164plf.10
        for <stable@vger.kernel.org>; Fri, 17 Mar 2023 10:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679073665;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=9CSBBIvBkXhn+92e6GcGuJiwWSbBdhVAm7YM4T5Yln0=;
        b=v/QMFXv849FOOAQuG6IEcqu9CKbnt2rGCcq7lmV+08xtCWdWtk1svbNmRqCwYgha5l
         uJHTIFM/+ySstxJt1OJ4RdMwK8rdojRm2y985ruqwrIvuMZwj/Rp4E4yHDoT0xz6dIGo
         StA2WeM+PvpIpEbfVlTcknVcdMUq9DPNWE7cqJMMv+4M7E/66B77V4fGWL0dbqQcJE8a
         N8/WZjTxfOuexzqPPLSC3b8Ij6wSbCmLCi9obla4l5IOOFRBppc/K7IbWviRzzCgoikZ
         xWQoTvlwYQ9AVb5qBteaDobEO+Ei+BpJIJBZ9PUY3GZROFUix/SmTjvSxN1IOfgx/vDX
         Txrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679073665;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9CSBBIvBkXhn+92e6GcGuJiwWSbBdhVAm7YM4T5Yln0=;
        b=RY+NtNvF6SBR50BqKzYmq4QDeVtfb46k+d/gevwu6awYhKxOjikS1UaDu/Poh87h+z
         ZzeN2QHrrFj8d6V6RYYvS7Ew4wiULzXVUzVMy50Cvv44aB8T+MjcAoLC8xVBA9Ek/isH
         7hiI5CMi39ELbdwuQI00A+h0/FPH0yvpy5tqskRi9SAyBaFe+mWv6Jamkbnob1+f7oXM
         oNcN2aHD+2qFBRFKECLftE976toQwK1HIYPeHGlumUSFgVgikYPG5acptPzZf3NhEc1m
         8k3YeK9Mfz9nCkdnGytcVi6yrVqmO2EqQPUfDYTboHBr8yGK/lfj43uUyuPc/LL9vmwU
         9Few==
X-Gm-Message-State: AO0yUKWcGG/YWsVYoNO8843oEQ6WggytxHPUDH0JAQifZaGq8TUzHHqi
        ub1LEMQIV8bhvPJsL/MdWHW20TXX1k2dsB+RW2Ve4g==
X-Google-Smtp-Source: AK7set9HwHns8BLj+CjMddMZTyD8AQKrw1KlmPfWWQ2NCwdBiViJV8wkYrcPWy0zjK5Gc8reOJHnEA==
X-Received: by 2002:a17:903:1111:b0:1a1:460e:6a5d with SMTP id n17-20020a170903111100b001a1460e6a5dmr8682514plh.49.1679073664766;
        Fri, 17 Mar 2023 10:21:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d21-20020a170902b71500b0019896d29197sm1804241pls.46.2023.03.17.10.21.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 10:21:04 -0700 (PDT)
Message-ID: <6414a180.170a0220.f0a2d.4101@mx.google.com>
Date:   Fri, 17 Mar 2023 10:21:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.10.175
X-Kernelci-Report-Type: test
Subject: stable/linux-5.10.y baseline: 171 runs, 9 regressions (v5.10.175)
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

stable/linux-5.10.y baseline: 171 runs, 9 regressions (v5.10.175)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C433TA-AJ0005-rammus    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =

dell-latitude...4305U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

dell-latitude...8665U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.175/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.175
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      de26e1b2103b1f56451f6ad77f0190c9066c87dc =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C433TA-AJ0005-rammus    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64146f9a9ffb2b25438c865e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.175/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
433TA-AJ0005-rammus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.175/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
433TA-AJ0005-rammus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64146f9a9ffb2b25438c8=
65f
        new failure (last pass: v5.10.174) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64146f9bcdaf820ea78c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.175/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.175/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64146f9bcdaf820ea78c8=
630
        new failure (last pass: v5.10.174) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64146f87cf8cf8ec248c863c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.175/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-c=
x9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.175/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-c=
x9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64146f87cf8cf8ec248c8=
63d
        new failure (last pass: v5.10.174) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64146fb9aeedd557808c863c

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.175/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.175/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64146fb9aeedd557808c8645
        failing since 57 days (last pass: v5.10.158, first fail: v5.10.164)

    2023-03-17T13:48:28.774097  <8>[   10.959051] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3420861_1.5.2.4.1>
    2023-03-17T13:48:28.887372  / # #
    2023-03-17T13:48:28.990644  export SHELL=3D/bin/sh
    2023-03-17T13:48:28.991809  #
    2023-03-17T13:48:29.094345  / # export SHELL=3D/bin/sh. /lava-3420861/e=
nvironment
    2023-03-17T13:48:29.095353  =

    2023-03-17T13:48:29.197522  / # . /lava-3420861/environment/lava-342086=
1/bin/lava-test-runner /lava-3420861/1
    2023-03-17T13:48:29.199123  =

    2023-03-17T13:48:29.199580  / # /lava-3420861/bin/lava-test-runner /lav=
a-3420861/1<3>[   11.371470] Bluetooth: hci0: command 0x0c03 tx timeout
    2023-03-17T13:48:29.203912   =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
dell-latitude...4305U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64146f869ffb2b25438c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.175/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-dell-l=
atitude-5400-4305U-sarien.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.175/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-dell-l=
atitude-5400-4305U-sarien.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64146f869ffb2b25438c8=
630
        new failure (last pass: v5.10.174) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
dell-latitude...8665U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64147562b838b755958c86e3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.175/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-dell-l=
atitude-5400-8665U-sarien.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.175/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-dell-l=
atitude-5400-8665U-sarien.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64147562b838b755958c8=
6e4
        new failure (last pass: v5.10.174) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64147346939869e04b8c8694

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.175/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x36=
0-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.175/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x36=
0-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64147346939869e04b8c8=
695
        new failure (last pass: v5.10.174) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/64146e09481f3ec1938c86fb

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.175/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.175/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/64146e09481f3ec1938c8705
        new failure (last pass: v5.10.174)

    2023-03-17T13:41:19.925447  /lava-9666617/1/../bin/lava-test-case
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/64146e09481f3ec1938c8706
        new failure (last pass: v5.10.174)

    2023-03-17T13:41:17.864369  <8>[   33.133064] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy-driver-present RESULT=3Dpass>

    2023-03-17T13:41:18.888752  /lava-9666617/1/../bin/lava-test-case

    2023-03-17T13:41:18.899556  <8>[   34.169146] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =20
