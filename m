Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E76B2489BCE
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 16:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231803AbiAJPGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 10:06:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbiAJPGx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 10:06:53 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5F86C06173F
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 07:06:52 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id w7so12207125plp.13
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 07:06:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CVH6ekMMZegySJI91KA77MgpZWLRmIeUP43PkSQ3x7c=;
        b=RIL0Zfi994huwY6Sdcq+OxaMYJvKOqm2p74ZjJY+p7spkEidp5m9sj66gbFb5c2hXg
         mIebRMSbhEcXJ75L2MDEgeL5+vz2M5ANmjPNeUsd6WD8EKjiVy+f5HvSlbyNc7o8BjcL
         pxpgg3WwWPbko76h0S0mkCXX2LUBv+2ilkmNpO51pbza6rCjIWMcmIbhxN/6V6iodB8y
         YsM1foRZJCA8zdmVffoYrSuVJI+qYsAeTh/FG/BPdKNdcHU+o9L3/c+HE1p1zk190ilB
         pMnCHIoWKU7XZyh5OjBGzXXaU30OhkR2+m7I+GwepWcCsnj/wQ8Q20HLJQ1FXX1PMal2
         xzIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CVH6ekMMZegySJI91KA77MgpZWLRmIeUP43PkSQ3x7c=;
        b=WoERt3q0AwJxA3J8/nlV+GoRVsjVatuC1SgJtm7wh/QrIYYjzotuMQBJZvV46arfGo
         H0CA3npdx9pD5HY7BGnJf52FLKR1i/4HHSbdDaQFtFxr2Xj0VWMdUB4WZjlMihZjG0c0
         Kf96HKWfkY5DNFftEbwZZ/7qHPccVhaj2tsK85BW4UHZ04chORv2kl/2oqgoKWkYVAe+
         FxvHcpd1kmuSgqxlcsm9j+prrxYsqVlIigDa2Bv2yiX9UAAZ00q6E+TLWCgvGMDDv3dN
         mDjven39+4os6IT+QIABbFt2JD5Y3TFIFi2SHK0YW7QyBKok+qZrWc0nUF3Pb4wI/Gaw
         VegQ==
X-Gm-Message-State: AOAM530uhEvG+5Bym/LyYyOCcFQX/EZ0brFeU3H4ZGYmBMOpli7gLQgx
        f2PF9dlOvvhZr3Cg0tBdgHRvk7lgoFekmfB2
X-Google-Smtp-Source: ABdhPJzgpYnCwbB9sM5b5+Z6AqkFeDJwdlvLHIcC2tRq0iSUr79Sbv02XqNq6Ai6Nz8N8GTF2gXa6A==
X-Received: by 2002:a63:ac54:: with SMTP id z20mr157607pgn.302.1641827212233;
        Mon, 10 Jan 2022 07:06:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w4sm9042184pjq.7.2022.01.10.07.06.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 07:06:51 -0800 (PST)
Message-ID: <61dc4b8b.1c69fb81.956df.71af@mx.google.com>
Date:   Mon, 10 Jan 2022 07:06:51 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.170-35-g681e37e4e026
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 142 runs,
 4 regressions (v5.4.170-35-g681e37e4e026)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 142 runs, 4 regressions (v5.4.170-35-g681e3=
7e4e026)

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
el/v5.4.170-35-g681e37e4e026/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.170-35-g681e37e4e026
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      681e37e4e026f3e38040daf69869b507a40b60c3 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61dc1a583a1acf65b4ef6746

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.170=
-35-g681e37e4e026/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.170=
-35-g681e37e4e026/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61dc1a583a1acf65b4ef6=
747
        failing since 25 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61dc1a683e2bd421daef6759

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.170=
-35-g681e37e4e026/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.170=
-35-g681e37e4e026/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61dc1a683e2bd421daef6=
75a
        failing since 25 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61dc1a593e2bd421daef6749

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.170=
-35-g681e37e4e026/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.170=
-35-g681e37e4e026/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61dc1a593e2bd421daef6=
74a
        failing since 25 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61dc1a6a3e2bd421daef675c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.170=
-35-g681e37e4e026/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.170=
-35-g681e37e4e026/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61dc1a6a3e2bd421daef6=
75d
        failing since 25 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =20
