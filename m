Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB23C4931EC
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 01:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238443AbiASAhU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 19:37:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237177AbiASAhU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 19:37:20 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E465CC061574
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 16:37:19 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id r5so921545pfl.2
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 16:37:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pV5wap1RlFDizJEBW+mL2wtXBnqBxJARX9+ot//RKpc=;
        b=ITSflt/ojn0yPC/Uv6B00I4Uf7KfBPfd4KlIvJ1I/M4L5agkS1MdsvhtN++Gi+QFC7
         cVT1eQthkugoaBkGY8vmHzmXjqkSN3MhOfCSPMCZv/xUrkgyz23fI/myjm1hhRTcdX6f
         6CM/kkLdBuTtX1LWFzuoxQPHv5vgMtbZ3klx71kJkT65QCzaUsA+p2QGTHFgaIqrjGQ8
         D7uT0IO9sOpJ9V9omOAwaN9PsI2NntiCeJ93e6C+4amgBJChxs1TGYay1/VOJgLnfmHR
         Sq8cCuEwAGw8Nj4gFszowz1zG0F+sEFzV90tPtbf2jqu7jDCsd2BIYMdfVUC2hSAsei9
         lFog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pV5wap1RlFDizJEBW+mL2wtXBnqBxJARX9+ot//RKpc=;
        b=zehwJSkxMZT0SXFJGRxyOuHX0ajpzgxV2Oq+7n9Se1/6E6PklzYqWbjeP+zwVqQnhL
         oA5AFCmebjDMmmFAxN+2hREKQgRbyM+HqXnS3hP9/BAwJRFIt9ekyGD/pAcIl0mRgi9c
         KspZt+tbq/xGHyVyb0nSQIcGG4YM0PH1iWOrGsrVxZFFjLohRKK2qGwamROBY69INnzX
         ngLFUtio1UViBa3dXw6KrZIXOxb1xO1FRYLePBqrrqMPiAdOIanv1HC3iOU8EWrRw2kU
         agnLbakgxtGFoj9+rwle7EzND0h778BB2Vm5nbWBkHVkdlq4UUkYyz0afumORps5l5YZ
         +XAw==
X-Gm-Message-State: AOAM533Pij1djpBsaV1AnenN7ttdQIHT7duZLQ56cmk0/YekaUtlvmSJ
        M8l/OL5Z8VK4sIZkeCNRtflfz7Zpi757xAyp
X-Google-Smtp-Source: ABdhPJxKNpoMnov5TLd/YK8kJ1m1ocdqwXSLvCRlPQsOFJPKily3gFAogkZKbEfvU9CdbG1fVee2jA==
X-Received: by 2002:aa7:8887:0:b0:4c2:6ed0:fc00 with SMTP id z7-20020aa78887000000b004c26ed0fc00mr24210021pfe.65.1642552639305;
        Tue, 18 Jan 2022 16:37:19 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p15sm3672568pjj.52.2022.01.18.16.37.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 16:37:19 -0800 (PST)
Message-ID: <61e75d3f.1c69fb81.4f6a7.a97b@mx.google.com>
Date:   Tue, 18 Jan 2022 16:37:19 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.171-35-g6a507169a5ff
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 132 runs,
 4 regressions (v5.4.171-35-g6a507169a5ff)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 132 runs, 4 regressions (v5.4.171-35-g6a507=
169a5ff)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.171-35-g6a507169a5ff/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.171-35-g6a507169a5ff
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6a507169a5ff33a54b96499b12c79f71537e0bde =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e72bae8054b62856abbd2e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.171=
-35-g6a507169a5ff/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.171=
-35-g6a507169a5ff/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e72bae8054b62856abb=
d2f
        failing since 33 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e72bcd2f317d8d8cabbd18

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.171=
-35-g6a507169a5ff/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.171=
-35-g6a507169a5ff/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e72bcd2f317d8d8cabb=
d19
        failing since 33 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e72bac4bb3da324fabbd1e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.171=
-35-g6a507169a5ff/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.171=
-35-g6a507169a5ff/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e72bac4bb3da324fabb=
d1f
        failing since 33 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e72bc94bb3da324fabbd33

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.171=
-35-g6a507169a5ff/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.171=
-35-g6a507169a5ff/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e72bc94bb3da324fabb=
d34
        failing since 33 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =20
