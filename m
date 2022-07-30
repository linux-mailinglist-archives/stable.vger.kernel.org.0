Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9934585C28
	for <lists+stable@lfdr.de>; Sat, 30 Jul 2022 22:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235337AbiG3Uwr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jul 2022 16:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232779AbiG3Uwr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Jul 2022 16:52:47 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE02E16595
        for <stable@vger.kernel.org>; Sat, 30 Jul 2022 13:52:45 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id pm17so1785802pjb.3
        for <stable@vger.kernel.org>; Sat, 30 Jul 2022 13:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ij6BGXjiHxIcyyyNsbmnyCfVpRn9JzjQedMtrWrMDVU=;
        b=SZdck35MNV7BEfOm7E+eZd1GPstcj/o+YzIHB7kxy1A+SMI6w+TSGvhNSVFUEkOtZ2
         RFrT2t34KX/6aXmxMyBfeExVKp9U/sUCQyREh0GQIlpf2WeqGYKamoecLTwdtIBcHFyu
         qlc6VF01XVotqJcUOv8tTPqT3u+l99UN2oOONkRvcT5YQkmMdjTm+MC69IcpqZQ+tDEa
         NyYqVbSK+M/ofhW62+G1ynFpMByFGunkt/VjQcfgMqUqD3cq5MEYh3S+CVn6PRhLNNmS
         UaF4L/uxOxLmywxQ1vHz8wmnDyyoOcIut+JEwbqiTL0OkTqdD/l6WVAyPkPRqXcSSLCj
         r+tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ij6BGXjiHxIcyyyNsbmnyCfVpRn9JzjQedMtrWrMDVU=;
        b=VP4Rdnuq1o2hrkjR8fCxLZjxFE7LZ5MEZAWJZ3n18sOLKnjltQO1JKEihjF4RNVryU
         MnJeQfr8yA8sMWhlV9pQyjh6mBkznbl8MTvqGIrJGyGEk8VvwwSFohEQ2uRMVKqqGu68
         zDSXg5tqclGcKuvmgK3w6u8JFM1kw2XaOu8TtCF2Pkxi3e51MbFxAQ/enp3tv2ZXbERZ
         iB7b4RnpKfKaxZq3LxuSxuG1b1t5BgYhjnewoqfCQsNO9QpACDS+LE9/s4zzpRE2eZyi
         8/w7clSvgPhxZP+aMSzcoiHfZLdPI1ZGRLLiD9ALjxPKFUFJ+kmsl5QnVRH+A8oA+JJs
         VdqQ==
X-Gm-Message-State: ACgBeo1c8nZAWd4d+mQwYJ7jxm/Vh2xNt2zRj+7srkKQ9Kv4llFIugNp
        7omYLHzZw7yXOlAJpF7KgSKjuPLa03XNDaDS
X-Google-Smtp-Source: AA6agR4M6aq0gDxLK+8ydixPADxcbmiYCSMReyafIahmDq9Tw8LZGpyptzGqRRPPvrngW/NQg+YeDA==
X-Received: by 2002:a17:903:2ce:b0:16c:f66b:50fa with SMTP id s14-20020a17090302ce00b0016cf66b50famr9905288plk.109.1659214365095;
        Sat, 30 Jul 2022 13:52:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x11-20020aa78f0b000000b00525343b5047sm5226249pfr.76.2022.07.30.13.52.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Jul 2022 13:52:44 -0700 (PDT)
Message-ID: <62e59a1c.a70a0220.9beea.7e1a@mx.google.com>
Date:   Sat, 30 Jul 2022 13:52:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.207-103-g328ceed42c15
Subject: stable-rc/queue/5.4 baseline: 95 runs,
 14 regressions (v5.4.207-103-g328ceed42c15)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 95 runs, 14 regressions (v5.4.207-103-g328cee=
d42c15)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =

rk3288-veyron-jaq          | arm   | lab-collabora | gcc-10   | multi_v7_de=
fconfig         | 6          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.207-103-g328ceed42c15/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.207-103-g328ceed42c15
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      328ceed42c15336881bd25bfb89ab72fa0815082 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62e5646004fd5d6bf5daf0f1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
03-g328ceed42c15/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
03-g328ceed42c15/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e5646004fd5d6bf5daf=
0f2
        failing since 81 days (last pass: v5.4.191-84-g56ce42d78d96, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/62e565b377a85a06ecdaf076

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
03-g328ceed42c15/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
03-g328ceed42c15/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e565b377a85a06ecdaf=
077
        failing since 81 days (last pass: v5.4.191-77-g1a3b249e415b, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62e564373f6a5dee4fdaf102

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
03-g328ceed42c15/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
03-g328ceed42c15/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e564373f6a5dee4fdaf=
103
        failing since 81 days (last pass: v5.4.191-84-g56ce42d78d96, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/62e565db65b37868e3daf07c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
03-g328ceed42c15/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
03-g328ceed42c15/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e565db65b37868e3daf=
07d
        failing since 81 days (last pass: v5.4.191-77-g1a3b249e415b, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62e5645f04fd5d6bf5daf0ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
03-g328ceed42c15/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
03-g328ceed42c15/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e5645f04fd5d6bf5daf=
0ef
        failing since 81 days (last pass: v5.4.191-84-g56ce42d78d96, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/62e565c8f8423da887daf080

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
03-g328ceed42c15/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
03-g328ceed42c15/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e565c8f8423da887daf=
081
        failing since 81 days (last pass: v5.4.191-77-g1a3b249e415b, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62e5644bb4a8caf18ddaf069

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
03-g328ceed42c15/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
03-g328ceed42c15/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e5644bb4a8caf18ddaf=
06a
        failing since 81 days (last pass: v5.4.191-84-g56ce42d78d96, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/62e565b420464ab42fdaf066

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
03-g328ceed42c15/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
03-g328ceed42c15/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e565b420464ab42fdaf=
067
        failing since 81 days (last pass: v5.4.191-77-g1a3b249e415b, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
rk3288-veyron-jaq          | arm   | lab-collabora | gcc-10   | multi_v7_de=
fconfig         | 6          =


  Details:     https://kernelci.org/test/plan/id/62e57568569709bc84daf058

  Results:     61 PASS, 10 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
03-g328ceed42c15/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
03-g328ceed42c15/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.cros-ec-keyb-probed: https://kernelci.org/test/case/id/=
62e57568569709bc84daf06a
        new failure (last pass: v5.4.207-87-g63a366361d9d8)

    2022-07-30T18:15:49.850278  /lava-6925146/1/../bin/lava-test-case
    2022-07-30T18:15:49.850895  <8>[   27.209549] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-keyb-probed RESULT=3Dfail>   =


  * baseline.bootrr.cros-ec-keyb-driver-present: https://kernelci.org/test/=
case/id/62e57568569709bc84daf06b
        new failure (last pass: v5.4.207-87-g63a366361d9d8)

    2022-07-30T18:15:48.829578  /lava-6925146/1/../bin/lava-test-case
    2022-07-30T18:15:48.835301  <8>[   26.189808] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-keyb-driver-present RESULT=3Dfail>   =


  * baseline.bootrr.cros-ec-i2c-tunnel-probed: https://kernelci.org/test/ca=
se/id/62e57568569709bc84daf06c
        new failure (last pass: v5.4.207-87-g63a366361d9d8)

    2022-07-30T18:15:47.810144  /lava-6925146/1/../bin/lava-test-case
    2022-07-30T18:15:47.815381  <8>[   25.170521] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-i2c-tunnel-probed RESULT=3Dfail>   =


  * baseline.bootrr.cros-ec-i2c-tunnel-driver-present: https://kernelci.org=
/test/case/id/62e57568569709bc84daf06d
        new failure (last pass: v5.4.207-87-g63a366361d9d8)

    2022-07-30T18:15:46.791123  /lava-6925146/1/../bin/lava-test-case
    2022-07-30T18:15:46.795176  <8>[   24.150068] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-i2c-tunnel-driver-present RESULT=3Dfail>   =


  * baseline.bootrr.cros-ec-dev-probed: https://kernelci.org/test/case/id/6=
2e57568569709bc84daf06e
        new failure (last pass: v5.4.207-87-g63a366361d9d8)

    2022-07-30T18:15:45.772965  /lava-6925146/1/../bin/lava-test-case
    2022-07-30T18:15:45.773332  <8>[   23.131380] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-dev-probed RESULT=3Dfail>   =


  * baseline.bootrr.cros-ec-dev-driver-present: https://kernelci.org/test/c=
ase/id/62e57568569709bc84daf09a
        new failure (last pass: v5.4.207-87-g63a366361d9d8)

    2022-07-30T18:15:44.751843  /lava-6925146/1/../bin/lava-test-case
    2022-07-30T18:15:44.756850  <8>[   22.111617] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-dev-driver-present RESULT=3Dfail>   =

 =20
