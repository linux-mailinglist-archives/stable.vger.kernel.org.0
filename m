Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B34CD6E795E
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 14:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232957AbjDSMJV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 08:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjDSMJV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 08:09:21 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC3E5F7
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 05:09:17 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 41be03b00d2f7-51b6d137403so1277074a12.0
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 05:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681906157; x=1684498157;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=pYf3dWLd0vTIMOePMPMQTxvUHy039oNbb3ax2k1U0CI=;
        b=qm0zWk9NEGmQ2UhjdJzyAgxDMppZ/VAs0H8eTrgYhoK2rrWCw8/26Vr3UkcaJRylo6
         xmCLJqqV1UCbbONXh7eRShAMz4Gdcp7V4ML2u41dcaeTqLAASF8MJ3pFWxmOxN40/6Mf
         v4Tgdo4v4W3ta5+qkkZqFojmHmZ1WrSeNzmKBOtMy4aL1yoUtGlJIxKoldDtM2OwMfQ9
         ks6elqH3kbtDcKESUTdO2Q44iTuCEgq8eRmQlV+D0Uysy5L7uK2kNf0HSs9HkAv5GQyL
         Ln5xj4dTssFJDgjXZqLlEX4BuZ5QA4wMuE20xqjGDJtS/5G1u6AiaeOEYgbmW7CM/cKi
         n/GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681906157; x=1684498157;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pYf3dWLd0vTIMOePMPMQTxvUHy039oNbb3ax2k1U0CI=;
        b=e3+AX2Ka3kirw6Mzqgl7Fn6k1KQ1NDiBs/9OvhS7mBypaiMl+d9dVmJsW0q7c67G6N
         bX6iiJeBRbp2BYH4fAG8R6adU1+cT+p7uwI92VrZ3qmML6f2C652mveg9lbb8CQi8LQo
         qBDHG+E+GzQBb/yhepXZpefSgDLAcY+DIs9Ilf9oSpnrAxldn7HLRFOQso0VfFvcA31/
         yiV209od7ayx0dMSnEOG9hO95Z7chzCBjwXNCeAvt6+CpT8waH4o9xPpDuwr1OQ25/Dx
         zcPJgkmZQz2/SO7R2ua5FlKT0flvt0pBiMS4JNYhB+RP14aYCl4tt9Dzz5KzDbBHoLWe
         aUOg==
X-Gm-Message-State: AAQBX9e/UrKUaz9H4oYyuenHdZmmqxOlUNr+2FOCL+KsAo/EADEW2Tm+
        H79q+VMGvBS280UmUxgBWhiJ4gmzH5q+CmtSZchRsHwy
X-Google-Smtp-Source: AKy350YRuzgp33ee0nL9AuyXS5IbNqv3HkpY5/Rjw+HXGkK1OuJpHVvYzMtYnlVdQd2PnV1MZ9TDBQ==
X-Received: by 2002:a17:90b:1c11:b0:23e:f855:79f2 with SMTP id oc17-20020a17090b1c1100b0023ef85579f2mr3091476pjb.12.1681906156798;
        Wed, 19 Apr 2023 05:09:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h1-20020a170902f7c100b001a6de1edadbsm5383147plw.124.2023.04.19.05.09.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 05:09:16 -0700 (PDT)
Message-ID: <643fd9ec.170a0220.4d308.c667@mx.google.com>
Date:   Wed, 19 Apr 2023 05:09:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.105-277-g6405847d6038a
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.15.y baseline: 179 runs,
 19 regressions (v5.15.105-277-g6405847d6038a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.15.y baseline: 179 runs, 19 regressions (v5.15.105-277-g6=
405847d6038a)

Regressions Summary
-------------------

platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

asus-CM1400CXA-dalboz        | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

asus-cx9400-volteer          | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 1          =

cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =

fsl-lx2160a-rdb              | arm64  | lab-nxp         | gcc-10   | defcon=
fig                    | 1          =

hifive-unleashed-a00         | riscv  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

imx53-qsrb                   | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

odroid-xu3                   | arm    | lab-collabora   | gcc-10   | exynos=
_defconfig             | 1          =

qemu_riscv64                 | riscv  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

qemu_riscv64                 | riscv  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =

qemu_riscv64                 | riscv  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =

qemu_smp8_riscv64            | riscv  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

qemu_smp8_riscv64            | riscv  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =

qemu_smp8_riscv64            | riscv  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.105-277-g6405847d6038a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.105-277-g6405847d6038a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6405847d6038a0e87dfe7ca86a5b8ec74da5c200 =



Test Regressions
---------------- =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fa5e77c6d3460ae2e85f1

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-277-g6405847d6038a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-277-g6405847d6038a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fa5e87c6d3460ae2e85f6
        failing since 21 days (last pass: v5.15.104, first fail: v5.15.104-=
147-gea115396267e)

    2023-04-19T08:27:01.713378  + set +x

    2023-04-19T08:27:01.719866  <8>[   10.951311] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10041938_1.4.2.3.1>

    2023-04-19T08:27:01.824558  / # #

    2023-04-19T08:27:01.925535  export SHELL=3D/bin/sh

    2023-04-19T08:27:01.925732  #

    2023-04-19T08:27:02.026664  / # export SHELL=3D/bin/sh. /lava-10041938/=
environment

    2023-04-19T08:27:02.026847  =


    2023-04-19T08:27:02.127779  / # . /lava-10041938/environment/lava-10041=
938/bin/lava-test-runner /lava-10041938/1

    2023-04-19T08:27:02.128113  =


    2023-04-19T08:27:02.133996  / # /lava-10041938/bin/lava-test-runner /la=
va-10041938/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fa5e97c6d3460ae2e85fc

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-277-g6405847d6038a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-277-g6405847d6038a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fa5e97c6d3460ae2e8601
        failing since 21 days (last pass: v5.15.104, first fail: v5.15.104-=
147-gea115396267e)

    2023-04-19T08:26:58.500624  + set<8>[   11.137488] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10041951_1.4.2.3.1>

    2023-04-19T08:26:58.500746   +x

    2023-04-19T08:26:58.605381  / # #

    2023-04-19T08:26:58.706377  export SHELL=3D/bin/sh

    2023-04-19T08:26:58.706565  #

    2023-04-19T08:26:58.807442  / # export SHELL=3D/bin/sh. /lava-10041951/=
environment

    2023-04-19T08:26:58.807666  =


    2023-04-19T08:26:58.908642  / # . /lava-10041951/environment/lava-10041=
951/bin/lava-test-runner /lava-10041951/1

    2023-04-19T08:26:58.908936  =


    2023-04-19T08:26:58.914378  / # /lava-10041951/bin/lava-test-runner /la=
va-10041951/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fa5e2a5cbedbbd92e862b

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-277-g6405847d6038a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-277-g6405847d6038a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fa5e2a5cbedbbd92e8630
        failing since 21 days (last pass: v5.15.104, first fail: v5.15.104-=
147-gea115396267e)

    2023-04-19T08:26:50.248877  <8>[    7.941130] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10041942_1.4.2.3.1>

    2023-04-19T08:26:50.252338  + set +x

    2023-04-19T08:26:50.358093  #

    2023-04-19T08:26:50.359485  =


    2023-04-19T08:26:50.462247  / # #export SHELL=3D/bin/sh

    2023-04-19T08:26:50.462972  =


    2023-04-19T08:26:50.565019  / # export SHELL=3D/bin/sh. /lava-10041942/=
environment

    2023-04-19T08:26:50.565783  =


    2023-04-19T08:26:50.667808  / # . /lava-10041942/environment/lava-10041=
942/bin/lava-test-runner /lava-10041942/1

    2023-04-19T08:26:50.668851  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/643fa4a80f9e4060132e863a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-277-g6405847d6038a/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-=
beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-277-g6405847d6038a/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-=
beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643fa4a80f9e4060132e8=
63b
        failing since 341 days (last pass: v5.15.37-259-gab77581473a3, firs=
t fail: v5.15.39) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/643fa932fbf4990c4c2e85e9

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-277-g6405847d6038a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-c=
ubietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-277-g6405847d6038a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-c=
ubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fa932fbf4990c4c2e85ee
        failing since 92 days (last pass: v5.15.82-124-gd731c63c25d1, first=
 fail: v5.15.87-101-g5bcc318cb4cd)

    2023-04-19T08:40:58.065918  <8>[   10.029607] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3511034_1.5.2.4.1>
    2023-04-19T08:40:58.178402  / # #
    2023-04-19T08:40:58.282418  export SHELL=3D/bin/sh
    2023-04-19T08:40:58.283492  #
    2023-04-19T08:40:58.385792  / # export SHELL=3D/bin/sh. /lava-3511034/e=
nvironment
    2023-04-19T08:40:58.387129  =

    2023-04-19T08:40:58.489685  / # . /lava-3511034/environment/lava-351103=
4/bin/lava-test-runner /lava-3511034/1
    2023-04-19T08:40:58.491659  =

    2023-04-19T08:40:58.492289  / # /lava-3511034/bin/lava-test-runner /lav=
a-3511034/1<3>[   10.432962] Bluetooth: hci0: command 0x0c03 tx timeout
    2023-04-19T08:40:58.495330   =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
fsl-lx2160a-rdb              | arm64  | lab-nxp         | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643fa335c8fe9682cf2e85ef

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-277-g6405847d6038a/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-r=
db.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-277-g6405847d6038a/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-r=
db.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fa335c8fe9682cf2e85f2
        failing since 46 days (last pass: v5.15.79, first fail: v5.15.98)

    2023-04-19T08:15:00.760087  [   14.722094] <LAVA_SIGNAL_ENDRUN 0_dmesg =
1203202_1.5.2.4.1>
    2023-04-19T08:15:00.866006  / # #
    2023-04-19T08:15:00.967861  export SHELL=3D/bin/sh
    2023-04-19T08:15:00.968328  #
    2023-04-19T08:15:01.069668  / # export SHELL=3D/bin/sh. /lava-1203202/e=
nvironment
    2023-04-19T08:15:01.070136  =

    2023-04-19T08:15:01.171497  / # . /lava-1203202/environment/lava-120320=
2/bin/lava-test-runner /lava-1203202/1
    2023-04-19T08:15:01.172250  =

    2023-04-19T08:15:01.174077  / # /lava-1203202/bin/lava-test-runner /lav=
a-1203202/1
    2023-04-19T08:15:01.191853  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hifive-unleashed-a00         | riscv  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643fa4a60f9e4060132e8630

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-277-g6405847d6038a/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-u=
nleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-277-g6405847d6038a/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-u=
nleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643fa4a60f9e4060132e8=
631
        failing since 0 day (last pass: v5.15.105-194-g415a9d81c640, first =
fail: v5.15.105-280-g0b6a5617247c) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fa8c8e23e762eed2e85eb

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-277-g6405847d6038a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-277-g6405847d6038a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fa8c8e23e762eed2e85f0
        failing since 21 days (last pass: v5.15.104, first fail: v5.15.104-=
147-gea115396267e)

    2023-04-19T08:39:20.170800  + <8>[   10.419334] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10042001_1.4.2.3.1>

    2023-04-19T08:39:20.170916  set +x

    2023-04-19T08:39:20.272867  #

    2023-04-19T08:39:20.273134  =


    2023-04-19T08:39:20.373881  / # #export SHELL=3D/bin/sh

    2023-04-19T08:39:20.374107  =


    2023-04-19T08:39:20.475021  / # export SHELL=3D/bin/sh. /lava-10042001/=
environment

    2023-04-19T08:39:20.475250  =


    2023-04-19T08:39:20.576229  / # . /lava-10042001/environment/lava-10042=
001/bin/lava-test-runner /lava-10042001/1

    2023-04-19T08:39:20.576512  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fa6d58cacca5c882e85f0

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-277-g6405847d6038a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-277-g6405847d6038a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fa6d58cacca5c882e85f5
        failing since 21 days (last pass: v5.15.104, first fail: v5.15.104-=
147-gea115396267e)

    2023-04-19T08:30:56.386153  + set +x

    2023-04-19T08:30:56.392456  <8>[   10.425344] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10041933_1.4.2.3.1>

    2023-04-19T08:30:56.497628  / # #

    2023-04-19T08:30:56.598786  export SHELL=3D/bin/sh

    2023-04-19T08:30:56.599027  #

    2023-04-19T08:30:56.699981  / # export SHELL=3D/bin/sh. /lava-10041933/=
environment

    2023-04-19T08:30:56.700256  =


    2023-04-19T08:30:56.801302  / # . /lava-10041933/environment/lava-10041=
933/bin/lava-test-runner /lava-10041933/1

    2023-04-19T08:30:56.801810  =


    2023-04-19T08:30:56.806753  / # /lava-10041933/bin/lava-test-runner /la=
va-10041933/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fa5e5a5cbedbbd92e8643

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-277-g6405847d6038a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-277-g6405847d6038a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fa5e5a5cbedbbd92e8648
        failing since 21 days (last pass: v5.15.104, first fail: v5.15.104-=
147-gea115396267e)

    2023-04-19T08:26:52.400689  + set<8>[   11.559986] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10041986_1.4.2.3.1>

    2023-04-19T08:26:52.401257   +x

    2023-04-19T08:26:52.509677  / # #

    2023-04-19T08:26:52.613120  export SHELL=3D/bin/sh

    2023-04-19T08:26:52.613905  #

    2023-04-19T08:26:52.715866  / # export SHELL=3D/bin/sh. /lava-10041986/=
environment

    2023-04-19T08:26:52.716855  =


    2023-04-19T08:26:52.819078  / # . /lava-10041986/environment/lava-10041=
986/bin/lava-test-runner /lava-10041986/1

    2023-04-19T08:26:52.820194  =


    2023-04-19T08:26:52.824874  / # /lava-10041986/bin/lava-test-runner /la=
va-10041986/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx53-qsrb                   | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/643fa8f499b3411cfd2e8630

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-277-g6405847d6038a/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-277-g6405847d6038a/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fa8f499b3411cfd2e8635
        failing since 78 days (last pass: v5.15.81-122-gc5f8d4a5d3c8, first=
 fail: v5.15.90-205-g5605d15db022)

    2023-04-19T08:39:57.242388  + set +x
    2023-04-19T08:39:57.242577  [    9.367863] <LAVA_SIGNAL_ENDRUN 0_dmesg =
930510_1.5.2.3.1>
    2023-04-19T08:39:57.350516  / # #
    2023-04-19T08:39:57.452396  export SHELL=3D/bin/sh
    2023-04-19T08:39:57.452864  #
    2023-04-19T08:39:57.554128  / # export SHELL=3D/bin/sh. /lava-930510/en=
vironment
    2023-04-19T08:39:57.554630  =

    2023-04-19T08:39:57.656060  / # . /lava-930510/environment/lava-930510/=
bin/lava-test-runner /lava-930510/1
    2023-04-19T08:39:57.656666  =

    2023-04-19T08:39:57.659149  / # /lava-930510/bin/lava-test-runner /lava=
-930510/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fa5cfca8c9384672e85f1

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-277-g6405847d6038a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-277-g6405847d6038a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fa5cfca8c9384672e85f6
        failing since 21 days (last pass: v5.15.104, first fail: v5.15.104-=
147-gea115396267e)

    2023-04-19T08:26:41.983705  <8>[   11.296326] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10041988_1.4.2.3.1>

    2023-04-19T08:26:42.088602  / # #

    2023-04-19T08:26:42.189616  export SHELL=3D/bin/sh

    2023-04-19T08:26:42.189847  #

    2023-04-19T08:26:42.290800  / # export SHELL=3D/bin/sh. /lava-10041988/=
environment

    2023-04-19T08:26:42.291048  =


    2023-04-19T08:26:42.391745  / # . /lava-10041988/environment/lava-10041=
988/bin/lava-test-runner /lava-10041988/1

    2023-04-19T08:26:42.392064  =


    2023-04-19T08:26:42.397004  / # /lava-10041988/bin/lava-test-runner /la=
va-10041988/1

    2023-04-19T08:26:42.402557  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
odroid-xu3                   | arm    | lab-collabora   | gcc-10   | exynos=
_defconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/643fa49d0f9e4060132e862a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-277-g6405847d6038a/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-od=
roid-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-277-g6405847d6038a/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-od=
roid-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643fa49d0f9e4060132e8=
62b
        new failure (last pass: v5.15.105-280-g0b6a5617247c) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_riscv64                 | riscv  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643fa47a23461fa81c2e887e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-277-g6405847d6038a/riscv/defconfig/gcc-10/lab-baylibre/baseline-qemu_ris=
cv64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-277-g6405847d6038a/riscv/defconfig/gcc-10/lab-baylibre/baseline-qemu_ris=
cv64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643fa47a23461fa81c2e8=
87f
        failing since 0 day (last pass: v5.15.105-194-g415a9d81c640, first =
fail: v5.15.105-280-g0b6a5617247c) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_riscv64                 | riscv  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643fa42923461fa81c2e85e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-277-g6405847d6038a/riscv/defconfig/gcc-10/lab-broonie/baseline-qemu_risc=
v64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-277-g6405847d6038a/riscv/defconfig/gcc-10/lab-broonie/baseline-qemu_risc=
v64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643fa42923461fa81c2e8=
5e7
        failing since 0 day (last pass: v5.15.105-194-g415a9d81c640, first =
fail: v5.15.105-280-g0b6a5617247c) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_riscv64                 | riscv  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643fa3df984500070e2e85ed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-277-g6405847d6038a/riscv/defconfig/gcc-10/lab-collabora/baseline-qemu_ri=
scv64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-277-g6405847d6038a/riscv/defconfig/gcc-10/lab-collabora/baseline-qemu_ri=
scv64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643fa3df984500070e2e8=
5ee
        failing since 0 day (last pass: v5.15.105-194-g415a9d81c640, first =
fail: v5.15.105-280-g0b6a5617247c) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_smp8_riscv64            | riscv  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643fa47fd9615f5dba2e85f7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-277-g6405847d6038a/riscv/defconfig/gcc-10/lab-baylibre/baseline-qemu_smp=
8_riscv64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-277-g6405847d6038a/riscv/defconfig/gcc-10/lab-baylibre/baseline-qemu_smp=
8_riscv64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643fa47fd9615f5dba2e8=
5f8
        failing since 0 day (last pass: v5.15.105-194-g415a9d81c640, first =
fail: v5.15.105-280-g0b6a5617247c) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_smp8_riscv64            | riscv  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643fa4675c485c54e12e8648

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-277-g6405847d6038a/riscv/defconfig/gcc-10/lab-broonie/baseline-qemu_smp8=
_riscv64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-277-g6405847d6038a/riscv/defconfig/gcc-10/lab-broonie/baseline-qemu_smp8=
_riscv64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643fa4675c485c54e12e8=
649
        failing since 0 day (last pass: v5.15.105-194-g415a9d81c640, first =
fail: v5.15.105-280-g0b6a5617247c) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_smp8_riscv64            | riscv  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643fa3e06328135d0e2e85f0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-277-g6405847d6038a/riscv/defconfig/gcc-10/lab-collabora/baseline-qemu_sm=
p8_riscv64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-277-g6405847d6038a/riscv/defconfig/gcc-10/lab-collabora/baseline-qemu_sm=
p8_riscv64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643fa3e06328135d0e2e8=
5f1
        failing since 0 day (last pass: v5.15.105-194-g415a9d81c640, first =
fail: v5.15.105-280-g0b6a5617247c) =

 =20
