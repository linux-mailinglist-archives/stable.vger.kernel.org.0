Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E51102F8334
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 19:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728163AbhAOSBL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 13:01:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727711AbhAOSBK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 13:01:10 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76524C061757
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 10:00:30 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id r4so5075800pls.11
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 10:00:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CtvC23QTSmPoVcX25tRLKOrXA9gTmCKhsnbqe1YeFz0=;
        b=HpCIhsoWxWDHx56NXTl+T//pyaeSEiD5JoSFpVdAO6BMFnuCFAM342X9Ss+nz0BuX4
         papx9Ji5GkaJAsbhumxnTS/7woOJvW+YCw6kOM+1c8+MfivtIzz7RAPjwTxq3Z1BCZiS
         z+PtLi+xah41Y08q5py8gJBK6U1M4l5Lblp0HGUToKWB1q4t9QpcYgTknlJnlE0cb+Dp
         ZI3FajtjDWw+I5NgjrE6OKGjt21SI6ijhBrLIUCt/sJ0BGlPm8MJiN6u63j8Bm4ndEPn
         VPr1EmqM8bYR2RGE97EV3miuzNdZpP52is3ip5gtJoJGh6hN+LXs/1ZWG0hLIptOoqEr
         MGyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CtvC23QTSmPoVcX25tRLKOrXA9gTmCKhsnbqe1YeFz0=;
        b=Wq/C8O2Q5M3ps+bZxHSVdGehL7rjX08CEjU3HF1HnSIotqJHtXhPYSZBp+bPk7FuAe
         IaKvS2k4T7b7lTw94oLpQwCod8ZgRAx/ABdZEFIdaIrD6SIK07m1Y+9fKT9QRzrG8w5r
         SNlQhrKBcVh7CTpBEyBRiM7NK55Zdzdnr80yo1Lkt+VSu6EGOEjUQiivyemrPNXajCdr
         ZyxhU5rG0tMAXQ7/djYj+MSyr3n7CyAaaPXorHgYgM1Y/8/dsnA4ajlBPDshF4PYbiiJ
         gksP8PdPLZ8TzWwEEN5tmzMoilX2kgS2ODMaM3Stc1CncL0eL9L3LbAgHkGhl3A7Nf/m
         gDPQ==
X-Gm-Message-State: AOAM530Fmc0PykHRtYd6gHV7TDFYJV2nIkdrJuPS91Kjv9wUCKMUOQJZ
        YQ/m/KECvB+pMu8pB3gUIRlpRJxKu/6bOA==
X-Google-Smtp-Source: ABdhPJzSoC750CxsRC9p250r/afV/dfGM6jx7eWtP8qIQzKPUW2n3GSfGaX2yz4+40/Jf9gczB5DhA==
X-Received: by 2002:a17:90b:128a:: with SMTP id fw10mr11486180pjb.113.1610733629674;
        Fri, 15 Jan 2021 10:00:29 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c205sm8464388pfc.160.2021.01.15.10.00.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 10:00:29 -0800 (PST)
Message-ID: <6001d83d.1c69fb81.adec9.55e6@mx.google.com>
Date:   Fri, 15 Jan 2021 10:00:29 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.167-43-g7a15ea567512
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 146 runs,
 4 regressions (v4.19.167-43-g7a15ea567512)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 146 runs, 4 regressions (v4.19.167-43-g7a15e=
a567512)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.167-43-g7a15ea567512/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.167-43-g7a15ea567512
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7a15ea5675122ed9d78c9356668c3e35ba465a8e =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60019ddb50eb5d5a28c94cfd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.167=
-43-g7a15ea567512/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.167=
-43-g7a15ea567512/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60019ddb50eb5d5a28c94=
cfe
        failing since 62 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60019df1f03553c21ac94ccb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.167=
-43-g7a15ea567512/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.167=
-43-g7a15ea567512/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60019df1f03553c21ac94=
ccc
        failing since 62 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60019e0974f0983e2fc94cef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.167=
-43-g7a15ea567512/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.167=
-43-g7a15ea567512/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60019e0974f0983e2fc94=
cf0
        failing since 62 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6001b08e3ea10feb3ac94cff

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.167=
-43-g7a15ea567512/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.167=
-43-g7a15ea567512/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6001b08e3ea10feb3ac94=
d00
        failing since 62 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =20
