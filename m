Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE58495139
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 16:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345827AbiATPRM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jan 2022 10:17:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231292AbiATPRJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jan 2022 10:17:09 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7B47C061574
        for <stable@vger.kernel.org>; Thu, 20 Jan 2022 07:17:09 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id q63so1461630pja.1
        for <stable@vger.kernel.org>; Thu, 20 Jan 2022 07:17:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6yVRXDWh1fYchRxrdgbqFtVdDfYPeLiFCXcp0iJ8jas=;
        b=ejOJbmyY6yuUvmXvUmbytZZvEw5CRk+OSOlV+uVw1Pi4ntgjFWh/kpSLJyaxnUZoK8
         gehA0WpDSJAkKZy1Y73JHPvH2Si4BDp7Z3ArDSKVXNPCgIGKy5U2UaSagIAeV0mNfJvo
         Piu2a2dzdVF7/2XI0pCq9Xz8/a0gZQgfMcF3LsaZMTvkcDxM7zYkwnflikzEtjJbO9rw
         TOs4plZQ7/T7uAD2pMJ4VtLXSu2j1GqpkFhi0K+EUbyqGfAv1HR2ptcFG6jixIRj9BVh
         goFgm1wXMdlk0P0ktE/8QcDExIXbikAqRDdq+yiRQZbjRR1cXIbFRBbCc9d1LLoX3Wcb
         Eryg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6yVRXDWh1fYchRxrdgbqFtVdDfYPeLiFCXcp0iJ8jas=;
        b=05xSoxn6HlrKtkIAc/gXdP9EftxS/+9wQBPZ5oZdE0XX6vnaX/eVYJiV/NVNGg3tzd
         qe+f41PWcKjvMp/BevJ+bha5IAbgAxJ2l+xW71elMShHDYnKgt8V0JwV1QqOecpi32Qq
         VoevVieL6bYPtJzhgaJYa15aw52e6T1FY4TPDjoxYkjz+IWLrWTcYP0AI6ER1hMBTk75
         jfO/lXSbL8TvAMUmxc1ZWASHyd2d5ifNSewW3Kj10b79Xo3thP/ecUgujOspvinAmYgB
         X1DB84ExB8PCIvioyEv39zMAbwmSPQ5mVotoSljkynZzJ1b+IGi8F7u0OOZYhxtKcgZ8
         2gTw==
X-Gm-Message-State: AOAM5307A9mq1b3tnFQh4lrthivNuWf/nCCTem71yKxJq8ifLCkS2BWf
        +/xAl5MIimuNKBNBnYP5HYlEfP/MG8uzaXXk
X-Google-Smtp-Source: ABdhPJzBua64vQPPKoqaCQIR/iBE1sQDJsvW1LOByKCW+UqF5EHE9lx0wB1vDwjP5zyH5Nc/SlXf7Q==
X-Received: by 2002:a17:90a:dc0d:: with SMTP id i13mr11277524pjv.103.1642691829000;
        Thu, 20 Jan 2022 07:17:09 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u4sm4068873pfk.51.2022.01.20.07.17.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 07:17:08 -0800 (PST)
Message-ID: <61e97cf4.1c69fb81.db535.ac96@mx.google.com>
Date:   Thu, 20 Jan 2022 07:17:08 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.173
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.4.y
Subject: stable/linux-5.4.y baseline: 126 runs, 4 regressions (v5.4.173)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 126 runs, 4 regressions (v5.4.173)

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


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.173/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.173
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      4aa2e7393e140f434c469bffe478e11cb9c55ed8 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e9392302211c96d4abbd16

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.173/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-uefi.=
txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.173/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-uefi.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e9392302211c96d4abb=
d17
        failing since 33 days (last pass: v5.4.166, first fail: v5.4.167) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e9392e02211c96d4abbd1b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.173/ar=
m/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv2-uefi.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.173/ar=
m/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv2-uefi.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e9392e02211c96d4abb=
d1c
        failing since 33 days (last pass: v5.4.166, first fail: v5.4.167) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e9390cb2d680cb9dabbd3d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.173/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-uefi.=
txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.173/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-uefi.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e9390cb2d680cb9dabb=
d3e
        failing since 33 days (last pass: v5.4.166, first fail: v5.4.167) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e9393002211c96d4abbd20

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.173/ar=
m/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv3-uefi.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.173/ar=
m/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv3-uefi.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e9393002211c96d4abb=
d21
        failing since 33 days (last pass: v5.4.166, first fail: v5.4.167) =

 =20
