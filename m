Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCBF505FE0
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 00:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232199AbiDRWr3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 18:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232404AbiDRWr2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 18:47:28 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94EDF292
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 15:44:47 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id mm4-20020a17090b358400b001cb93d8b137so580493pjb.2
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 15:44:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vXwqZh03V2N3w/9GAO5/UbJtuXIJQu/UwSHdLMnJxLo=;
        b=e7z2tiq1QCwPkKhqSwenpGkIvtY5J7AFCD1zYVKIqzobpa8HoavaT4ZF1dcpdpUIPv
         UYQ6VVG+Ch0PlxIFSgBWZCQj6Es9RShaG11ixoyjiZxeJbixUSmqdbMDL1HD6a6NMeIT
         dgOnwLE5N16ONdGWZZ7uLTYkWFScQuwnIyrOf7xRX0qUb7kRxn4OoXsmjyrgklwk/vGT
         hLFbj4yzTwJKSaFYDZVPiKk93uzDkXrvHqwgs5604OYevwIP3Mc+PhNB3VmDg1EHDu51
         6JaFWjxXntNOWSbddDvXRUT8tnp75j1eeaXybXe1lQ8QkcPuFsrLUBb1BAKE9f/6AJX1
         zcaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vXwqZh03V2N3w/9GAO5/UbJtuXIJQu/UwSHdLMnJxLo=;
        b=umhe/84fjm4EiU5CVIB8h4ZI40FeWE058KeYxDRtUE8pXJ96WKJhGLL0mY+s+VopeZ
         ctKXAtTzN0SNLG1sl7UFCeO3RDPbcGaroiwZTlEV59GoJ36KMoiejR3Y2lagp2APe1NZ
         lXIkTzecndqsBepht/7P+IYcJe5rvq9eDTuKKPtE7o96WoscC2JfB1/tAwrJD/Sxc/p4
         reP9Qwq+x5pDDnGhps9J0Y1ym1CgUCDMCKhkEfDF/lyoebcG7iYoN8sQ5+itTnC7QcDq
         9AonnQbII+NDFbj30XIpRzY2SXk4yjoUTSAgY1SMsBYpWztY9xeDF7/a5mjftOjZWlnR
         4LzQ==
X-Gm-Message-State: AOAM533HOPFUUxca7gfpficOUx9ONodNu+LHZNaGcFBqOJKE4AQCWBHu
        JXIIhi+pj8mBUwCEuRdceML54xmtfYszWjKY
X-Google-Smtp-Source: ABdhPJx9wubMiniBeEdmQTcaGnjkR4Q5MVQ47XNisuM6EIhz0SvNMKoIlLBfWUDM3jPurXkrkRb+lg==
X-Received: by 2002:a17:90a:a509:b0:1ca:c48e:a795 with SMTP id a9-20020a17090aa50900b001cac48ea795mr20501710pjq.165.1650321886919;
        Mon, 18 Apr 2022 15:44:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j63-20020a636e42000000b003987df110edsm14047451pgc.42.2022.04.18.15.44.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 15:44:46 -0700 (PDT)
Message-ID: <625de9de.1c69fb81.48a40.17f4@mx.google.com>
Date:   Mon, 18 Apr 2022 15:44:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.189-64-gab55553793398
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.4.y baseline: 135 runs,
 6 regressions (v5.4.189-64-gab55553793398)
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

stable-rc/linux-5.4.y baseline: 135 runs, 6 regressions (v5.4.189-64-gab555=
53793398)

Regressions Summary
-------------------

platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
hifive-unleashed-a00     | riscv | lab-baylibre  | gcc-10   | defconfig    =
              | 1          =

qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =

qemu_arm-virt-gicv2-uefi | arm   | lab-broonie   | gcc-10   | multi_v7_defc=
onfig         | 1          =

qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =

qemu_arm-virt-gicv3-uefi | arm   | lab-broonie   | gcc-10   | multi_v7_defc=
onfig         | 1          =

rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.189-64-gab55553793398/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.189-64-gab55553793398
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ab55553793398bae2b33694dbbf1b3529c5ac2db =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
hifive-unleashed-a00     | riscv | lab-baylibre  | gcc-10   | defconfig    =
              | 1          =


  Details:     https://kernelci.org/test/plan/id/625db49adbf4bad98bae067c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.189=
-64-gab55553793398/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unle=
ashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.189=
-64-gab55553793398/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unle=
ashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625db49adbf4bad98bae0=
67d
        failing since 11 days (last pass: v5.4.188-371-g48b29a8f8ae0, first=
 fail: v5.4.188-368-ga24be10a1a9ef) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/625db790c9aebea29eae068c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.189=
-64-gab55553793398/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_arm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.189=
-64-gab55553793398/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_arm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625db790c9aebea29eae0=
68d
        failing since 123 days (last pass: v5.4.165, first fail: v5.4.165-1=
9-gb780ab989d60) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-broonie   | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/625db77c5efe8a2dabae06a8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.189=
-64-gab55553793398/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_=
arm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.189=
-64-gab55553793398/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_=
arm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625db77c5efe8a2dabae0=
6a9
        failing since 123 days (last pass: v5.4.165, first fail: v5.4.165-1=
9-gb780ab989d60) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/625db78fc9aebea29eae067c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.189=
-64-gab55553793398/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_arm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.189=
-64-gab55553793398/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_arm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625db78fc9aebea29eae0=
67d
        failing since 123 days (last pass: v5.4.165, first fail: v5.4.165-1=
9-gb780ab989d60) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-broonie   | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/625db77bb628ee1b37ae067c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.189=
-64-gab55553793398/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_=
arm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.189=
-64-gab55553793398/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_=
arm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625db77bb628ee1b37ae0=
67d
        failing since 123 days (last pass: v5.4.165, first fail: v5.4.165-1=
9-gb780ab989d60) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/625db7f0816f17925aae06ac

  Results:     88 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.189=
-64-gab55553793398/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.189=
-64-gab55553793398/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/625db7f0816f17925aae06ce
        failing since 43 days (last pass: v5.4.181-51-gb77a12b8d613, first =
fail: v5.4.182-54-gf27af6bf3c32)

    2022-04-18T19:11:31.712694  <8>[   30.395141] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-04-18T19:11:32.723235  /lava-6117854/1/../bin/lava-test-case
    2022-04-18T19:11:32.732101  <8>[   31.415736] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
