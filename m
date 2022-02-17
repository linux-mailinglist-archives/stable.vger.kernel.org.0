Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C91054B96C1
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 04:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232678AbiBQDkI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 22:40:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbiBQDkI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 22:40:08 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6D6729C134
        for <stable@vger.kernel.org>; Wed, 16 Feb 2022 19:39:53 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id d9-20020a17090a498900b001b8bb1d00e7so4232910pjh.3
        for <stable@vger.kernel.org>; Wed, 16 Feb 2022 19:39:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=B5VGyeyYCNrLe3jHfn3+dFvBvpULI0wX7GGqAR3hXRg=;
        b=utF+yustsdl5eHJN3yCLVjBUMrXurV0m2cnLHpudqss8L+8jaK73ikfzZIkiWQCCsf
         iEW3n8eJl18375WQxfkk8uNCNPUX+gDrRro1j5QXB05P6NCo5V65Qasm1/GdXJxygoCi
         mSuhKkPeVLMawre8doJ9e/abcJyJ7SaiHY+Gwm+gexmsxwgQk+olCZsmhvu69iUl7L1C
         b5riRRA4oEtHBrPgfUQvh8KE7UmDcm2a5iRdlXFuuugUUNE6vFZ6MPLZHt2VtNZxGbvb
         gi6fvECx6vO6StJ0Z+VNCHSPAMivQRo8wdFyU8aY9x/Ar6sMoC/6idnZi1+5IGSc2C2f
         qyrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=B5VGyeyYCNrLe3jHfn3+dFvBvpULI0wX7GGqAR3hXRg=;
        b=CzGStvB+7fgsczpO7RqoFTETNppWl55etGsCXyeLomcmNn2EoVMDHpOL97HcrxAVSN
         l0mQlQsSJ/Q0QR1nbnIGHBYbexmZQdS4nh2GXHOQ00KbjZFvUu9bN1x9kg4LvVJaO4Ff
         9PiB+V7Kt5ulC2W5EY8yvcRxzLGp6jwJdaC63lHn/vUJjyCSbtNLOuqisiGsE8u1akwJ
         MUxjrC5oburLg0+To14Yc2HMOAxOc/wjbsCDq5NZx34/3jFwv9Xb240dSqgjOpScptkE
         DCGju0MLF8cH3d7Qu+fXqpUGHi9nhFYnNCgT/uDpLkF6DBOLe1OdNvSj2ZCETxftKzcj
         a/zw==
X-Gm-Message-State: AOAM532q9YUwe5pe1iPANTef5SafwSctYdTT30pGHXfonrjZzUOKE7ob
        wCpK1UeRLIotstuYaetGO6s4YiZ0laX224fR
X-Google-Smtp-Source: ABdhPJyZwehnfKMsESGnEXQ4zvWmYwzbBFowM3VfdCe44vV/scMjsbV1XeUDu/sfS9okSKRIiKv1DA==
X-Received: by 2002:a17:90a:de15:b0:1b5:9208:58b5 with SMTP id m21-20020a17090ade1500b001b5920858b5mr1094511pjv.142.1645069192536;
        Wed, 16 Feb 2022 19:39:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m1sm47105008pfk.202.2022.02.16.19.39.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 19:39:52 -0800 (PST)
Message-ID: <620dc388.1c69fb81.9fba2.4ca1@mx.google.com>
Date:   Wed, 16 Feb 2022 19:39:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.267
Subject: stable-rc/linux-4.14.y baseline: 73 runs, 10 regressions (v4.14.267)
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

stable-rc/linux-4.14.y baseline: 73 runs, 10 regressions (v4.14.267)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
meson8b-odroidc1           | arm   | lab-baylibre  | gcc-10   | multi_v7_de=
fconfig         | 1          =

panda                      | arm   | lab-collabora | gcc-10   | omap2plus_d=
efconfig        | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.267/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.267
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a35d65bedfbc38cffe2701798cd6810bbdf07892 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
meson8b-odroidc1           | arm   | lab-baylibre  | gcc-10   | multi_v7_de=
fconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/620d89e8946209d0bdc62968

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
67/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
67/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620d89e8946209d0bdc62=
969
        failing since 2 days (last pass: v4.14.266, first fail: v4.14.266-4=
5-gce409501ca5f) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
panda                      | arm   | lab-collabora | gcc-10   | omap2plus_d=
efconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/620d88b1378dbf2a73c62978

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
67/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
67/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/620d88b1378dbf2=
a73c6297b
        failing since 6 days (last pass: v4.14.264-70-g1d3edcc1650d, first =
fail: v4.14.264-74-g11dfe0b41849)
        2 lines

    2022-02-16T23:28:25.290679  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/103
    2022-02-16T23:28:25.296862  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2022-02-16T23:28:25.314850  [   20.390899] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/620d8920dffa31f03ec6299d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
67/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
67/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620d8920dffa31f03ec62=
99e
        failing since 6 days (last pass: v4.14.264-70-g1d3edcc1650d, first =
fail: v4.14.264-74-g11dfe0b41849) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/620d890f11ab6bc900c62998

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
67/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
67/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620d890f11ab6bc900c62=
999
        failing since 6 days (last pass: v4.14.264-70-g1d3edcc1650d, first =
fail: v4.14.264-74-g11dfe0b41849) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/620d8921dffa31f03ec629a0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
67/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
67/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620d8921dffa31f03ec62=
9a1
        failing since 6 days (last pass: v4.14.264-70-g1d3edcc1650d, first =
fail: v4.14.264-74-g11dfe0b41849) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/620d891011ab6bc900c6299b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
67/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
67/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620d891011ab6bc900c62=
99c
        failing since 6 days (last pass: v4.14.264-70-g1d3edcc1650d, first =
fail: v4.14.264-74-g11dfe0b41849) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/620d8922dffa31f03ec629a6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
67/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
67/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620d8922dffa31f03ec62=
9a7
        failing since 6 days (last pass: v4.14.264-70-g1d3edcc1650d, first =
fail: v4.14.264-74-g11dfe0b41849) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/620d891111ab6bc900c629a1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
67/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
67/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620d891111ab6bc900c62=
9a2
        failing since 6 days (last pass: v4.14.264-70-g1d3edcc1650d, first =
fail: v4.14.264-74-g11dfe0b41849) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/620d8923dffa31f03ec629b4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
67/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
67/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620d8923dffa31f03ec62=
9b5
        failing since 6 days (last pass: v4.14.264-70-g1d3edcc1650d, first =
fail: v4.14.264-74-g11dfe0b41849) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/620d891235203e9c55c62968

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
67/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
67/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620d891235203e9c55c62=
969
        failing since 6 days (last pass: v4.14.264-70-g1d3edcc1650d, first =
fail: v4.14.264-74-g11dfe0b41849) =

 =20
