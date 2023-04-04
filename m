Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 874CE6D5F73
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 13:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234790AbjDDLtW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 07:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234923AbjDDLtV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 07:49:21 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D3451982
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 04:49:20 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id kq3so30976477plb.13
        for <stable@vger.kernel.org>; Tue, 04 Apr 2023 04:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680608959;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Q7yT37VG+tgXPHXdHfrnOg0/dfBWm46E9poSqH7pB30=;
        b=FyJpSIbfGMbAmsGGiLnLzFAkUO47nGLp84sGo5w+rbLyR8PVs56k7My9gMKoUx+ywE
         rH0CGU+BD1/93BJ+smC39zCkDaETbCmwKMyIgzIuoIQlWn0yxGySKozCbu1E/83qbnMn
         7iK30P6grq+D0cGJ+hQ1sKzY6LKc9XYa1OvAhPSBuAwADn+axbox9m4GnXU4mum4XaaZ
         FKgUwA6fuYXLRVuPxfrhNjDXyngYErDZ6ffOpzvEW2UaPMx1nVbPFv8gSqCteHlP12Z4
         OFiwEQrnfStFptZ4fUHUznvGMJtjCG76R32a+d2WBRn9jha+KCkdQ13taLpkPay3tr1b
         Bh3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680608959;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q7yT37VG+tgXPHXdHfrnOg0/dfBWm46E9poSqH7pB30=;
        b=PAhJWjMObcdExsB1hoHprDFYasvTNejsIG3BQLewXykFopxfueGeXIV5pTTWnpIOfo
         hnR9qQSJEK1BCp3Ri1JzYTKzKycqTHSw6/3gGb923nLQYzHxOSn+o8vAQ2caT7ts0Aog
         bj0tyEZ02VgoQz38iN2qPT2SgxMvzoJrJcHHKqy1kZE5J/+NCsV7EcGiHhdHrsE6Bt94
         ieQ2Em/RtxkGisrzAKwiUyVjUNvpDTKPKeBSVljB6Eww5ymaNA9XWJhpnjdRoyx34eBA
         9iWILHsZlFtl7DocuVCroAmBVQyEn1eLjRDFoF8QeRj2d/YW35UYpLADX412Hql8zKJ/
         LYxQ==
X-Gm-Message-State: AAQBX9dHPoneZAAxhtJt1vBZS4SF8w6ZoaE17mtf34NJR4Z+Ncop/FUM
        QGu14gAbaiWEKiS4Ai7r3hfyai3X7tt4ob1eRFXBOA==
X-Google-Smtp-Source: AKy350YJTeQq/Kx+WN95nWCnajilEpfft6fe3xCoTTyWa1fjKwOeSvRNIYVINXBNTiC795oVhwwDig==
X-Received: by 2002:a05:6a20:38a5:b0:d9:55b0:c0e8 with SMTP id n37-20020a056a2038a500b000d955b0c0e8mr1738153pzf.39.1680608959330;
        Tue, 04 Apr 2023 04:49:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k26-20020aa792da000000b00593e4e6516csm8594203pfa.124.2023.04.04.04.49.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 04:49:18 -0700 (PDT)
Message-ID: <642c0ebe.a70a0220.fc2f6.1289@mx.google.com>
Date:   Tue, 04 Apr 2023 04:49:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.176-174-g7d617ad89b616
Subject: stable-rc/linux-5.10.y baseline: 172 runs,
 7 regressions (v5.10.176-174-g7d617ad89b616)
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

stable-rc/linux-5.10.y baseline: 172 runs, 7 regressions (v5.10.176-174-g7d=
617ad89b616)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =

fsl-lx2160a-rdb              | arm64  | lab-nxp       | gcc-10   | defconfi=
g                    | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

r8a7743-iwg20d-q7            | arm    | lab-cip       | gcc-10   | shmobile=
_defconfig           | 1          =

rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.176-174-g7d617ad89b616/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.176-174-g7d617ad89b616
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7d617ad89b616010f8233d54ae9d5623cbb91b41 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/642bdc13253b0123a179e92d

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-174-g7d617ad89b616/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-c=
ubietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-174-g7d617ad89b616/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-c=
ubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642bdc13253b0123a179e932
        failing since 76 days (last pass: v5.10.158-107-gd2432186ff47, firs=
t fail: v5.10.162-852-geeaac3cf2eb3)

    2023-04-04T08:12:47.223614  <8>[   10.974971] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3468411_1.5.2.4.1>
    2023-04-04T08:12:47.333139  / # #
    2023-04-04T08:12:47.436380  export SHELL=3D/bin/sh
    2023-04-04T08:12:47.437495  #
    2023-04-04T08:12:47.539768  / # export SHELL=3D/bin/sh. /lava-3468411/e=
nvironment
    2023-04-04T08:12:47.540680  =

    2023-04-04T08:12:47.541132  / # <3>[   11.211781] Bluetooth: hci0: comm=
and 0x0c03 tx timeout
    2023-04-04T08:12:47.643095  . /lava-3468411/environment/lava-3468411/bi=
n/lava-test-runner /lava-3468411/1
    2023-04-04T08:12:47.644653  =

    2023-04-04T08:12:47.649585  / # /lava-3468411/bin/lava-test-runner /lav=
a-3468411/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
fsl-lx2160a-rdb              | arm64  | lab-nxp       | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/642bd82d068e82599779e922

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-174-g7d617ad89b616/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-r=
db.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-174-g7d617ad89b616/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-r=
db.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642bd82d068e82599779e929
        failing since 31 days (last pass: v5.10.155, first fail: v5.10.172)

    2023-04-04T07:55:59.041639  [   10.671918] <LAVA_SIGNAL_ENDRUN 0_dmesg =
1194034_1.5.2.4.1>
    2023-04-04T07:55:59.147358  / # #
    2023-04-04T07:55:59.249196  export SHELL=3D/bin/sh
    2023-04-04T07:55:59.249791  #
    2023-04-04T07:55:59.351324  / # export SHELL=3D/bin/sh. /lava-1194034/e=
nvironment
    2023-04-04T07:55:59.351924  =

    2023-04-04T07:55:59.453309  / # . /lava-1194034/environment/lava-119403=
4/bin/lava-test-runner /lava-1194034/1
    2023-04-04T07:55:59.454120  =

    2023-04-04T07:55:59.455869  / # /lava-1194034/bin/lava-test-runner /lav=
a-1194034/1
    2023-04-04T07:55:59.472641  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642bda251b03dece7479e924

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-174-g7d617ad89b616/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-174-g7d617ad89b616/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642bda251b03dece7479e929
        failing since 6 days (last pass: v5.10.176, first fail: v5.10.176-1=
05-g18265b240021)

    2023-04-04T08:04:40.819878  + set +x

    2023-04-04T08:04:40.826353  <8>[   14.557831] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9856199_1.4.2.3.1>

    2023-04-04T08:04:40.931111  / # #

    2023-04-04T08:04:41.032164  export SHELL=3D/bin/sh

    2023-04-04T08:04:41.032389  #

    2023-04-04T08:04:41.133337  / # export SHELL=3D/bin/sh. /lava-9856199/e=
nvironment

    2023-04-04T08:04:41.133565  =


    2023-04-04T08:04:41.234527  / # . /lava-9856199/environment/lava-985619=
9/bin/lava-test-runner /lava-9856199/1

    2023-04-04T08:04:41.234853  =


    2023-04-04T08:04:41.239560  / # /lava-9856199/bin/lava-test-runner /lav=
a-9856199/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642bda15039082d25179e944

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-174-g7d617ad89b616/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-174-g7d617ad89b616/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642bda15039082d25179e949
        failing since 6 days (last pass: v5.10.176, first fail: v5.10.176-1=
05-g18265b240021)

    2023-04-04T08:04:17.251211  <8>[    9.416649] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9856173_1.4.2.3.1>

    2023-04-04T08:04:17.254189  + set +x

    2023-04-04T08:04:17.355977  #

    2023-04-04T08:04:17.356419  =


    2023-04-04T08:04:17.457694  / # #export SHELL=3D/bin/sh

    2023-04-04T08:04:17.458313  =


    2023-04-04T08:04:17.560133  / # export SHELL=3D/bin/sh. /lava-9856173/e=
nvironment

    2023-04-04T08:04:17.560434  =


    2023-04-04T08:04:17.661727  / # . /lava-9856173/environment/lava-985617=
3/bin/lava-test-runner /lava-9856173/1

    2023-04-04T08:04:17.662885  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
r8a7743-iwg20d-q7            | arm    | lab-cip       | gcc-10   | shmobile=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/642bd8eb8d55f362f579e96b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-174-g7d617ad89b616/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a774=
3-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-174-g7d617ad89b616/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a774=
3-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/642bd8eb8d55f362f579e=
96c
        failing since 12 days (last pass: v5.10.175-100-g1686e1df6521, firs=
t fail: v5.10.176) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/642bde1af12b39264d79e95a

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-174-g7d617ad89b616/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora=
/baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-174-g7d617ad89b616/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora=
/baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/642bde1af12b39264d79e960
        failing since 21 days (last pass: v5.10.173, first fail: v5.10.173-=
4-g955623617f2f)

    2023-04-04T08:21:40.304577  /lava-9856377/1/../bin/lava-test-case
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/642bde1af12b39264d79e961
        failing since 21 days (last pass: v5.10.173, first fail: v5.10.173-=
4-g955623617f2f)

    2023-04-04T08:21:38.246159  <8>[   33.028251] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy-driver-present RESULT=3Dpass>

    2023-04-04T08:21:39.268404  /lava-9856377/1/../bin/lava-test-case

    2023-04-04T08:21:39.278506  <8>[   34.062864] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =20
