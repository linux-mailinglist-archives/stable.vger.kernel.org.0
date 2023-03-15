Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFFBA6BB6C2
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 15:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233308AbjCOO52 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 10:57:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232318AbjCOO5J (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 10:57:09 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F341F8C539
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 07:56:39 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id d8so10946077pgm.3
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 07:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678892142;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=BkxfwXgl6WZnWY20uY1+9RdXlg4ooQsQ8gYkw/4bAx4=;
        b=YTld+JzeDDgC0ypNwpqqB4120z3/h4W2ushH6OFAs+hxoYEm9icJllLU78+jHQu+Xr
         X524fkP7RCxaBQjy7w9Asa1r46Npxhu21gyZ9nDTRblKU1DfXXP1AFJwdramgFJxWz3o
         JBRJ/TaY1kNgoADMgfiiJQZ2p6odCoQGjaM6BrLRdHkmWTWhKzP4rYE2ieS+y6jJVUS+
         KKk601ycBU8neUPAHVvSh6Xf1oDa7E6h7yicwUge5TqLr5yC1HWnS3deBkLqlTBXVr72
         qAr59j6TKHUwEhFx+1PTZ71YsjwFVOEoKCNrvAGANtDEZTRUSyqWL3/+ZONCRMvRjTdJ
         0Zrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678892142;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BkxfwXgl6WZnWY20uY1+9RdXlg4ooQsQ8gYkw/4bAx4=;
        b=rV1QQv3+8BQ/D8h9jgzSwvMbJhfVMML2zk0Bvso2HFO4y+SOAP6nuYwgWdYM4VaD1H
         aFUgPIUYSIPz8MXtI0eg/FasmprX3flSEf80QU7J+koiPNob/NeFxVg9IDjQ1KrV4GWu
         hwaEgDcvpzM+fLl8bsocw7RkBYiObue/464gcHI9lLVX+exxaNpG8Lc9IVrMlWfCHOHw
         uE364i4wstE7cIL9o8Fa+ROrWxXW+5bi1x4gxfGkUy27o2idYD9JNSYB3ZjQQ60DZR1Q
         v8sSsNZNKohR7IhRwJC+xiple+KCUDiY4vJOsyZJSMgCt6CDVDgYcFiZCvEDJdkgcbYo
         TKDw==
X-Gm-Message-State: AO0yUKWFF4UAXa0QRuiW+KQUbF+kMDg5NZ4QyqTCaVv7xKzNGHax7ZQn
        EX8KvTPr1pLRx5+KVZHOSF7i3imqgMWRl7b8GCCfgIZx
X-Google-Smtp-Source: AK7set+iLP0DtUekCZAXLkCHDFjgPZGf/VxgTbrmUPOhCi1OEnGOJ976U2myEt8K4omrd2GJBcU34g==
X-Received: by 2002:a62:6541:0:b0:5a8:5424:d138 with SMTP id z62-20020a626541000000b005a85424d138mr32197763pfb.16.1678892142388;
        Wed, 15 Mar 2023 07:55:42 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l22-20020a62be16000000b005e4d8c6168csm3617788pff.210.2023.03.15.07.55.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 07:55:42 -0700 (PDT)
Message-ID: <6411dc6e.620a0220.bc1cf.7ca1@mx.google.com>
Date:   Wed, 15 Mar 2023 07:55:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.173-113-g17daa9aba1258
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 160 runs,
 11 regressions (v5.10.173-113-g17daa9aba1258)
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

stable-rc/queue/5.10 baseline: 160 runs, 11 regressions (v5.10.173-113-g17d=
aa9aba1258)

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

beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =

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

sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.173-113-g17daa9aba1258/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.173-113-g17daa9aba1258
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      17daa9aba12582226f4584e8f3d7e90c1512ade8 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C433TA-AJ0005-rammus    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6411a989301a44e9f78c8640

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-113-g17daa9aba1258/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-C433TA-AJ0005-rammus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-113-g17daa9aba1258/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-C433TA-AJ0005-rammus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6411a989301a44e9f78c8=
641
        failing since 0 day (last pass: v5.10.173-89-gbb0818a7908b, first f=
ail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6411a9743bfbda16858c86b5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-113-g17daa9aba1258/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-113-g17daa9aba1258/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6411a9743bfbda16858c8=
6b6
        failing since 0 day (last pass: v5.10.173-89-gbb0818a7908b, first f=
ail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6411a977fbd3cb0d228c8662

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-113-g17daa9aba1258/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-113-g17daa9aba1258/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6411a977fbd3cb0d228c8=
663
        failing since 0 day (last pass: v5.10.173-89-gbb0818a7908b, first f=
ail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/6411aba7c55343d7958c8630

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-113-g17daa9aba1258/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-bea=
glebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-113-g17daa9aba1258/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-bea=
glebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6411aba7c55343d7958c8667
        failing since 29 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-03-15T11:27:15.466812  <8>[   21.334345] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 166730_1.5.2.4.1>
    2023-03-15T11:27:15.577710  / # #
    2023-03-15T11:27:15.681052  export SHELL=3D/bin/sh
    2023-03-15T11:27:15.682233  #
    2023-03-15T11:27:15.785077  / # export SHELL=3D/bin/sh. /lava-166730/en=
vironment
    2023-03-15T11:27:15.785937  =

    2023-03-15T11:27:15.887966  / # . /lava-166730/environment/lava-166730/=
bin/lava-test-runner /lava-166730/1
    2023-03-15T11:27:15.889233  =

    2023-03-15T11:27:15.893652  / # /lava-166730/bin/lava-test-runner /lava=
-166730/1
    2023-03-15T11:27:16.003489  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6411abaabac2cc49588c8642

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-113-g17daa9aba1258/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-113-g17daa9aba1258/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6411abaabac2cc49588c864b
        failing since 47 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-03-15T11:27:18.014735  <8>[   11.134797] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3413578_1.5.2.4.1>
    2023-03-15T11:27:18.120594  / # #
    2023-03-15T11:27:18.222322  export SHELL=3D/bin/sh
    2023-03-15T11:27:18.222680  #
    2023-03-15T11:27:18.323808  / # export SHELL=3D/bin/sh. /lava-3413578/e=
nvironment
    2023-03-15T11:27:18.324165  =

    2023-03-15T11:27:18.425334  / # . /lava-3413578/environment/lava-341357=
8/bin/lava-test-runner /lava-3413578/1
    2023-03-15T11:27:18.425939  =

    2023-03-15T11:27:18.426139  / # /lava-3413578/bin/lava-test-runner /lav=
a-3413578/1<3>[   11.530963] Bluetooth: hci0: command 0x0c03 tx timeout
    2023-03-15T11:27:18.430906   =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
dell-latitude...4305U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6411a98634f46955648c8632

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-113-g17daa9aba1258/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-dell-latitude-5400-4305U-sarien.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-113-g17daa9aba1258/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-dell-latitude-5400-4305U-sarien.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6411a98634f46955648c8=
633
        failing since 0 day (last pass: v5.10.173-89-gbb0818a7908b, first f=
ail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
dell-latitude...8665U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6411abdeee9f9953eb8c8643

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-113-g17daa9aba1258/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-dell-latitude-5400-8665U-sarien.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-113-g17daa9aba1258/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-dell-latitude-5400-8665U-sarien.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6411abdeee9f9953eb8c8=
644
        failing since 0 day (last pass: v5.10.173-89-gbb0818a7908b, first f=
ail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6411ac4746aba8f5948c86a2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-113-g17daa9aba1258/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-113-g17daa9aba1258/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6411ac4746aba8f5948c8=
6a3
        failing since 0 day (last pass: v5.10.173-89-gbb0818a7908b, first f=
ail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/6411aa138ac73e99108c864b

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-113-g17daa9aba1258/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-113-g17daa9aba1258/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/6411aa138ac73e99108c8681
        failing since 1 day (last pass: v5.10.172-529-g06956b9e9396, first =
fail: v5.10.173-69-gfcbe6bd469ed)

    2023-03-15T11:20:46.765993  /lava-9629727/1/../bin/lava-test-case

    2023-03-15T11:20:46.777204  <8>[   35.137077] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/6411aa138ac73e99108c8682
        failing since 1 day (last pass: v5.10.172-529-g06956b9e9396, first =
fail: v5.10.173-69-gfcbe6bd469ed)

    2023-03-15T11:20:44.705107  <8>[   33.063751] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy-driver-present RESULT=3Dpass>

    2023-03-15T11:20:45.729250  /lava-9629727/1/../bin/lava-test-case

    2023-03-15T11:20:45.740817  <8>[   34.100120] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6411aa53a4bc28b2638c8642

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-113-g17daa9aba1258/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun=
8i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-113-g17daa9aba1258/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun=
8i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6411aa53a4bc28b2638c864b
        failing since 41 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-03-15T11:21:26.080683  / # #
    2023-03-15T11:21:26.182343  export SHELL=3D/bin/sh
    2023-03-15T11:21:26.182719  #
    2023-03-15T11:21:26.284016  / # export SHELL=3D/bin/sh. /lava-3413579/e=
nvironment
    2023-03-15T11:21:26.284409  =

    2023-03-15T11:21:26.385736  / # . /lava-3413579/environment/lava-341357=
9/bin/lava-test-runner /lava-3413579/1
    2023-03-15T11:21:26.386355  =

    2023-03-15T11:21:26.391959  / # /lava-3413579/bin/lava-test-runner /lav=
a-3413579/1
    2023-03-15T11:21:26.489825  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-15T11:21:26.490336  + cd /lava-3413579/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
