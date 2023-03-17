Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE266BEDBC
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 17:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbjCQQIi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 12:08:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjCQQIh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 12:08:37 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DF171F5EA
        for <stable@vger.kernel.org>; Fri, 17 Mar 2023 09:08:08 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id e15-20020a17090ac20f00b0023d1b009f52so9642602pjt.2
        for <stable@vger.kernel.org>; Fri, 17 Mar 2023 09:08:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679069286;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=gLQy1j1GO79FKWd4HCuwpKNG6jpC/fiyW/g1LF8P/js=;
        b=g2+gf0fowgO/NjtCOKgx9QrYc/ftXghwJObYrUdc/3TAN4CpvOD+S6AJ5TuFK/lGFx
         QKJDoDAR2KkdjIWij+uah/cu1DeWAWjNM6BUmJJ3uFrLr4IYkvXXK2o+yJOyyUTXyKEx
         tJndWjnTy9V+ob8icx9oOkj4EDEwbFpbZGrLohd/CvPE98cLXOrhbzF4KsjkgwiHukdE
         w9pdiqNqshxyHC2misXbGph1s0U9G46WmleXSqGzvr1shw0RdhqabJ8RB6hXhm0G/IoZ
         KhC/mtRCpU3BsLHe5aJ++oZbJl+SaQR0j0S8pbn832u4c+9avetHUX3FYfoQyIjjQcdt
         xUSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679069286;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gLQy1j1GO79FKWd4HCuwpKNG6jpC/fiyW/g1LF8P/js=;
        b=QgD+aJCHIvCADEV6TcB5Ehz5VszW89as8OTcIxd3vRQ4FjpsRqOyEhaQpAIXc2i2JQ
         DvLV5JReOu1eC4TTExnYVA/aG4Tmq/iYPaj7LfQtLYKnmHpYRaIoh8gNJih41AlZrsek
         DZV/1wVMud4TdG/Cg8c0MGkfMkcfpvxy3fVsBPoc83Oi2dG0w8Vavp5UHrGxqRO3Ie6K
         gh18J4rfXeuWn+aS+s7c4SkMMXlHt+XcQv3M07QMLKYZPcOM4ex/SVk6Pn3/ZHuSH6k8
         pcXJI+baqnpGxrSh/+Evg+7ThEfqLk64p4zGZqsvGmnRsneoU2Txd6skGSqoQ66yYPCY
         rjFg==
X-Gm-Message-State: AO0yUKW5e7gQlbddSt0xLDkgIz5PfB8XuhtNllmjy3J/+m9aYECO1r8c
        09j3ercVomW5Cvmptkxr7YPyA8P+S09M7Yf48aBiBw==
X-Google-Smtp-Source: AK7set+MRS4HT0mJGbun+7nIgX8nb/8sogW4WqzrNg6qO1LyMTaP8mFCBVRd09cD7eOOsSOJMDKsHA==
X-Received: by 2002:a17:90b:17cb:b0:229:f4f3:e904 with SMTP id me11-20020a17090b17cb00b00229f4f3e904mr9492693pjb.11.1679069285717;
        Fri, 17 Mar 2023 09:08:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m3-20020a170902bb8300b0019a7d58e595sm1732358pls.143.2023.03.17.09.08.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 09:08:05 -0700 (PDT)
Message-ID: <64149065.170a0220.5cd31.37c7@mx.google.com>
Date:   Fri, 17 Mar 2023 09:08:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.175
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 193 runs, 10 regressions (v5.10.175)
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

stable-rc/linux-5.10.y baseline: 193 runs, 10 regressions (v5.10.175)

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

rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.175/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.175
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      de26e1b2103b1f56451f6ad77f0190c9066c87dc =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C433TA-AJ0005-rammus    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64145f1bca0abb5b1c8c86ad

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
75/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asu=
s-C433TA-AJ0005-rammus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
75/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asu=
s-C433TA-AJ0005-rammus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64145f1bca0abb5b1c8c8=
6ae
        failing since 2 days (last pass: v5.10.173-4-g955623617f2f, first f=
ail: v5.10.173-117-g61362c8f9b46) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64145f1b2a4d3e8de88c866e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
75/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asu=
s-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
75/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asu=
s-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64145f1b2a4d3e8de88c8=
66f
        failing since 2 days (last pass: v5.10.173-4-g955623617f2f, first f=
ail: v5.10.173-117-g61362c8f9b46) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64145f1ba87470d4cf8c8634

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
75/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asu=
s-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
75/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asu=
s-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64145f1ba87470d4cf8c8=
635
        failing since 2 days (last pass: v5.10.173-4-g955623617f2f, first f=
ail: v5.10.173-117-g61362c8f9b46) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64145ee3b6f0bbf65c8c8647

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
75/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
75/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64145ee3b6f0bbf65c8c8650
        failing since 58 days (last pass: v5.10.158-107-gd2432186ff47, firs=
t fail: v5.10.162-852-geeaac3cf2eb3)

    2023-03-17T12:36:18.151945  <8>[   10.995015] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3420497_1.5.2.4.1>
    2023-03-17T12:36:18.262118  / # #
    2023-03-17T12:36:18.365294  export SHELL=3D/bin/sh
    2023-03-17T12:36:18.366274  #
    2023-03-17T12:36:18.468803  / # export SHELL=3D/bin/sh. /lava-3420497/e=
nvironment
    2023-03-17T12:36:18.470408  =

    2023-03-17T12:36:18.573325  / # . /lava-3420497/environment/lava-342049=
7/bin/lava-test-runner /lava-3420497/1
    2023-03-17T12:36:18.575554  =

    2023-03-17T12:36:18.580380  / # /lava-3420497/bin/lava-test-runner /lav=
a-3420497/1
    2023-03-17T12:36:18.606531  <3>[   11.451417] Bluetooth: hci0: command =
0x0c03 tx timeout =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
dell-latitude...4305U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64145f1efa226e9bcc8c8651

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
75/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-del=
l-latitude-5400-4305U-sarien.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
75/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-del=
l-latitude-5400-4305U-sarien.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64145f1efa226e9bcc8c8=
652
        failing since 2 days (last pass: v5.10.173-4-g955623617f2f, first f=
ail: v5.10.173-117-g61362c8f9b46) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
dell-latitude...8665U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64145f1b28ed2ab7308c86c3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
75/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-del=
l-latitude-5400-8665U-sarien.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
75/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-del=
l-latitude-5400-8665U-sarien.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64145f1b28ed2ab7308c8=
6c4
        failing since 2 days (last pass: v5.10.173-4-g955623617f2f, first f=
ail: v5.10.173-117-g61362c8f9b46) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
fsl-lx2160a-rdb              | arm64  | lab-nxp       | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/64145f37f6b075023a8c8640

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
75/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
75/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-rdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64145f38f6b075023a8c8647
        failing since 13 days (last pass: v5.10.155, first fail: v5.10.172)

    2023-03-17T12:37:58.875766  [   10.388130] <LAVA_SIGNAL_ENDRUN 0_dmesg =
1176518_1.5.2.4.1>
    2023-03-17T12:37:58.982037  / # #
    2023-03-17T12:37:59.084150  export SHELL=3D/bin/sh
    2023-03-17T12:37:59.084667  #
    2023-03-17T12:37:59.186047  / # export SHELL=3D/bin/sh. /lava-1176518/e=
nvironment
    2023-03-17T12:37:59.186550  =

    2023-03-17T12:37:59.287956  / # . /lava-1176518/environment/lava-117651=
8/bin/lava-test-runner /lava-1176518/1
    2023-03-17T12:37:59.288815  =

    2023-03-17T12:37:59.290594  / # /lava-1176518/bin/lava-test-runner /lav=
a-1176518/1
    2023-03-17T12:37:59.307771  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64145f1bfa226e9bcc8c8649

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
75/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-=
x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
75/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-=
x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64145f1bfa226e9bcc8c8=
64a
        failing since 2 days (last pass: v5.10.173-4-g955623617f2f, first f=
ail: v5.10.173-117-g61362c8f9b46) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/64145ecb20a975aa438c8662

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
75/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gr=
u-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
75/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gr=
u-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/64145ecb20a975aa438c866c
        failing since 3 days (last pass: v5.10.173, first fail: v5.10.173-4=
-g955623617f2f)

    2023-03-17T12:36:04.785431  /lava-9665704/1/../bin/lava-test-case

    2023-03-17T12:36:04.797067  <8>[   35.019629] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/64145ecb20a975aa438c866d
        failing since 3 days (last pass: v5.10.173, first fail: v5.10.173-4=
-g955623617f2f)

    2023-03-17T12:36:02.727384  <8>[   32.945930] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy-driver-present RESULT=3Dpass>

    2023-03-17T12:36:03.748458  /lava-9665704/1/../bin/lava-test-case

    2023-03-17T12:36:03.759458  <8>[   33.982023] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =20
