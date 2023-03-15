Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A65286BBC05
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 19:27:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbjCOS1U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 14:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbjCOS1S (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 14:27:18 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 622942B9DE
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 11:27:14 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id y2so19831460pjg.3
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 11:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678904833;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=JOykP1ORKSBSiXw8FCwVdgCCNX1qm8r5hJ2bj8xHp80=;
        b=Ti5DYtDPn3P51du3ZwA9nwkM06bdKhHHMsPVke/DAuHpuAm4JDyTmjJqpsd2gPIw78
         LJ+hesDtMfxO8skjEjHI1IGTpHZsypMuvDjDGDVoDAkO4OcaMgyl5Os3grNHweY7W55q
         q9JVm1RedJhYIf7JOkxaD6+FEEFa/VG/2r3CNwhN/bYkNIwHxvDm/+yK94k+ZTEQwIOQ
         364fa/kB/uikcBn0ZD6AaRssNVUry3p5jgLjUg1SiaLuYT7MOJKdobtZuc1Xvn4EgS0P
         WW9gDcw3exk+Sba47Mmq0eNyIA5qftVuyhTWKXjZqRYNF1zklGUhNTIYNINloeC//PWr
         kH5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678904833;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JOykP1ORKSBSiXw8FCwVdgCCNX1qm8r5hJ2bj8xHp80=;
        b=MgZg0czlc1n9O7YDHEdr6djKNBxkKYCFQ+ozRRBGzEBcVfzqEcFp/+sBUtA3npTXhz
         I7HT/AlRokIVjmTaVjURvTJ1own4kIARkA978BZrBBCUxK3477kEMsa5XcEUMNigC/d4
         AKKnHQXgrktII1AzcSJDME7ugNs3CR3GqBLxGktoowHcrbFLdZz8MQrnlKZI9fhaIJcf
         JZFKnmGUxD7zWsbuFwdzTxubGME3w/CcN6tK7ejqesRiAPniR/XAr756HrlAWrO9Igyi
         Lcun8KwuNcxvCCWoi01HbQ+uzfL6mIzyRRPBrez/DcdCB/1KShWfHpQDo0GC+JWp3vco
         U/EA==
X-Gm-Message-State: AO0yUKUBgPWgWhY7oHRFmVk0AN7Ncxa2JB2czXMTIfEOjyLtc6bzGIdT
        DgUwpdDB3EiJItU6oncwIBxbvQW31C4D+fL9AZmfw6e3
X-Google-Smtp-Source: AK7set9zQMved7J+ZfPrKjWVJmdjfPQYSYHrNFUx5RRP54IqKlJ++dIRTKQPORDhHNkSilM+X6HnHw==
X-Received: by 2002:a17:902:d4cd:b0:19b:dbf7:f9ca with SMTP id o13-20020a170902d4cd00b0019bdbf7f9camr607779plg.0.1678904833435;
        Wed, 15 Mar 2023 11:27:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e4-20020a170902cf4400b00194d14d8e54sm3994482plg.96.2023.03.15.11.27.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 11:27:13 -0700 (PDT)
Message-ID: <64120e01.170a0220.a5fdf.98ea@mx.google.com>
Date:   Wed, 15 Mar 2023 11:27:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.173-109-g420b6d10bae3
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 168 runs,
 11 regressions (v5.10.173-109-g420b6d10bae3)
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

stable-rc/linux-5.10.y baseline: 168 runs, 11 regressions (v5.10.173-109-g4=
20b6d10bae3)

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

fsl-lx2160a-rdb              | arm64  | lab-nxp       | gcc-10   | defconfi=
g                    | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

r8a7743-iwg20d-q7            | arm    | lab-cip       | gcc-10   | shmobile=
_defconfig           | 1          =

rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.173-109-g420b6d10bae3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.173-109-g420b6d10bae3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      420b6d10bae34ef9aa0d118b31afec6107595e72 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C433TA-AJ0005-rammus    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6411d4e8ad91c7e5138c8654

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
73-109-g420b6d10bae3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-asus-C433TA-AJ0005-rammus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
73-109-g420b6d10bae3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-asus-C433TA-AJ0005-rammus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6411d4e8ad91c7e5138c8=
655
        failing since 0 day (last pass: v5.10.173-4-g955623617f2f, first fa=
il: v5.10.173-117-g61362c8f9b46) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6411d4e9ad91c7e5138c8659

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
73-109-g420b6d10bae3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
73-109-g420b6d10bae3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6411d4e9ad91c7e5138c8=
65a
        failing since 0 day (last pass: v5.10.173-4-g955623617f2f, first fa=
il: v5.10.173-117-g61362c8f9b46) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6411d54d19d8fd89398c8667

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
73-109-g420b6d10bae3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
73-109-g420b6d10bae3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6411d54d19d8fd89398c8=
668
        failing since 0 day (last pass: v5.10.173-4-g955623617f2f, first fa=
il: v5.10.173-117-g61362c8f9b46) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6411d75acf9d3e94dd8c86e0

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
73-109-g420b6d10bae3/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cu=
bietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
73-109-g420b6d10bae3/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cu=
bietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6411d75acf9d3e94dd8c86e9
        failing since 56 days (last pass: v5.10.158-107-gd2432186ff47, firs=
t fail: v5.10.162-852-geeaac3cf2eb3)

    2023-03-15T14:33:53.456282  + set +x<8>[   10.990031] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3414263_1.5.2.4.1>
    2023-03-15T14:33:53.456521  =

    2023-03-15T14:33:53.562860  / # #
    2023-03-15T14:33:53.664342  export SHELL=3D/bin/sh
    2023-03-15T14:33:53.664683  #
    2023-03-15T14:33:53.765757  / # export SHELL=3D/bin/sh. /lava-3414263/e=
nvironment
    2023-03-15T14:33:53.766203  =

    2023-03-15T14:33:53.766422  / # . /lava-3414263/environment<3>[   11.29=
0937] Bluetooth: hci0: command 0x0c03 tx timeout
    2023-03-15T14:33:53.867637  /lava-3414263/bin/lava-test-runner /lava-34=
14263/1
    2023-03-15T14:33:53.868294   =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
dell-latitude...4305U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6411d4eb8f9308f2ed8c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
73-109-g420b6d10bae3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-dell-latitude-5400-4305U-sarien.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
73-109-g420b6d10bae3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-dell-latitude-5400-4305U-sarien.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6411d4eb8f9308f2ed8c8=
630
        failing since 0 day (last pass: v5.10.173-4-g955623617f2f, first fa=
il: v5.10.173-117-g61362c8f9b46) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
dell-latitude...8665U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6411d7e2efc411f5428c8652

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
73-109-g420b6d10bae3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-dell-latitude-5400-8665U-sarien.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
73-109-g420b6d10bae3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-dell-latitude-5400-8665U-sarien.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6411d7e2efc411f5428c8=
653
        failing since 0 day (last pass: v5.10.173-4-g955623617f2f, first fa=
il: v5.10.173-117-g61362c8f9b46) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
fsl-lx2160a-rdb              | arm64  | lab-nxp       | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/6411d86426f5f42a488c8665

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
73-109-g420b6d10bae3/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-rd=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
73-109-g420b6d10bae3/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-rd=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6411d86426f5f42a488c866c
        failing since 11 days (last pass: v5.10.155, first fail: v5.10.172)

    2023-03-15T14:38:17.738992  [   13.389910] <LAVA_SIGNAL_ENDRUN 0_dmesg =
1173883_1.5.2.4.1>
    2023-03-15T14:38:17.844433  / # #
    2023-03-15T14:38:17.946616  export SHELL=3D/bin/sh
    2023-03-15T14:38:17.947321  #
    2023-03-15T14:38:18.048880  / # export SHELL=3D/bin/sh. /lava-1173883/e=
nvironment
    2023-03-15T14:38:18.049377  =

    2023-03-15T14:38:18.150799  / # . /lava-1173883/environment/lava-117388=
3/bin/lava-test-runner /lava-1173883/1
    2023-03-15T14:38:18.151615  =

    2023-03-15T14:38:18.153294  / # /lava-1173883/bin/lava-test-runner /lav=
a-1173883/1
    2023-03-15T14:38:18.171332  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6411d63df1e0023d698c8638

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
73-109-g420b6d10bae3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
73-109-g420b6d10bae3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6411d63df1e0023d698c8=
639
        failing since 0 day (last pass: v5.10.173-4-g955623617f2f, first fa=
il: v5.10.173-117-g61362c8f9b46) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
r8a7743-iwg20d-q7            | arm    | lab-cip       | gcc-10   | shmobile=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6411d5296175b903a18c8631

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
73-109-g420b6d10bae3/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743=
-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
73-109-g420b6d10bae3/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743=
-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6411d5296175b903a18c8=
632
        failing since 1 day (last pass: v5.10.173, first fail: v5.10.173-4-=
g955623617f2f) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/6411da4ed2a93589ee8c8631

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
73-109-g420b6d10bae3/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
73-109-g420b6d10bae3/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/6411da4fd2a93589ee8c8666
        failing since 1 day (last pass: v5.10.173, first fail: v5.10.173-4-=
g955623617f2f)

    2023-03-15T14:46:27.422793  /lava-9632781/1/../bin/lava-test-case
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/6411da4fd2a93589ee8c8667
        failing since 1 day (last pass: v5.10.173, first fail: v5.10.173-4-=
g955623617f2f)

    2023-03-15T14:46:26.385241  /lava-9632781/1/../bin/lava-test-case

    2023-03-15T14:46:26.396571  <8>[   34.091938] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =20
