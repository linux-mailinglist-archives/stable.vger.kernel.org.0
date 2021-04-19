Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 429D23638C1
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 02:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236053AbhDSAQm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Apr 2021 20:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235730AbhDSAQm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Apr 2021 20:16:42 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8385C06174A
        for <stable@vger.kernel.org>; Sun, 18 Apr 2021 17:16:13 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id nm3-20020a17090b19c3b029014e1bbf6c60so13298141pjb.4
        for <stable@vger.kernel.org>; Sun, 18 Apr 2021 17:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8Q5fHxHgQJUelcHEOgPxn133hfLjbGW4JE6wZ4mI2wU=;
        b=J4GwCXHIumuy46/AXTMRAQAyQw/i+2fzoHXQSqY1sh5LETHytGsEx7rJhfASiXHuxQ
         yMqTVWLVM782ogaXZtyfM3CBolm2VZSmyn/CsFShrojZSTVHCROE2sUJAlD6N4kmVnHl
         KRvqyfL28Iyn11eEOltQ6EVqxHHXQbwnqrmBi9/m61aYVTcey2mUG3ggw7fj61Z0gFRo
         RTAW4YBULZUS1GnFpvFHXAFXky0Nw5HBck8y0bahW2j4onDk7eJTTgiSMbwnqSEtPs9T
         9JVi5EuSw878Xv1NBoSiE8L5MCDYhhqTZghAjm9tO1kgh7fEJx5Ltfr2XN9gf0VJPMuS
         tXTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8Q5fHxHgQJUelcHEOgPxn133hfLjbGW4JE6wZ4mI2wU=;
        b=uJvuwk9/3TbR5NFMtigIzRqD+WDOgLeNb5Ru+67c5wTRaEhpdYEkLHt+kPnN/xRyrJ
         Yi99DsnoMyCyKcecQsf1VD/AHF5BfW0OzZkcnoSR3umhE1SWaGBlvt07rYo8Aoub247u
         6bITMvHnN56DBcnQiLqCx07VM4Q59v6XMsnAu4kz8OJzrPHY9TlNxh84tAHtRkDYUvsN
         xzIZg/l/KElFH768pX63TXLEkLCs9Cgw3ESJHJm0ZSYahW7frP2extmZbMcqEwuQkC/8
         435/GgUWkdM0jsDsWZ3UWneP4r1NPLdI8cNUP32Gh2GitdfV8PiqZh/VvPolPkZvZHay
         7UFg==
X-Gm-Message-State: AOAM5339H8v0aDPoZkSdnIkj68hbhmhYm2jn4lGaT0uMduGE/J4KaOFc
        ydptqPbvwQj1rgnDF4C9PEHoL26C327a7sLa
X-Google-Smtp-Source: ABdhPJzcu5diGEnzUzWERIFmx8KeAl9EfB0u8lFVu0As/ZuqsaUkVLVhVbnY7ZcfKjAN3SxIrGCS/A==
X-Received: by 2002:a17:90b:349:: with SMTP id fh9mr21747771pjb.126.1618791373181;
        Sun, 18 Apr 2021 17:16:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 144sm10430031pfy.75.2021.04.18.17.16.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Apr 2021 17:16:12 -0700 (PDT)
Message-ID: <607ccbcc.1c69fb81.2f2d6.b821@mx.google.com>
Date:   Sun, 18 Apr 2021 17:16:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.188-41-ge2f3163382d7
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 122 runs,
 4 regressions (v4.19.188-41-ge2f3163382d7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 122 runs, 4 regressions (v4.19.188-41-ge2f31=
63382d7)

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
nel/v4.19.188-41-ge2f3163382d7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.188-41-ge2f3163382d7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e2f3163382d737c94b6b559b2942da99bff06b07 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/607c8ead1bcc406ebcdac6bb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-41-ge2f3163382d7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-41-ge2f3163382d7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607c8ead1bcc406ebcdac=
6bc
        failing since 155 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/607c8eb53252a6e4a2dac6b4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-41-ge2f3163382d7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-41-ge2f3163382d7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607c8eb53252a6e4a2dac=
6b5
        failing since 155 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/607c8eac60c1b7e8cfdac6ba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-41-ge2f3163382d7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-41-ge2f3163382d7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607c8eac60c1b7e8cfdac=
6bb
        failing since 155 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/607c8e68dea10010bedac6c9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-41-ge2f3163382d7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-41-ge2f3163382d7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607c8e68dea10010bedac=
6ca
        failing since 155 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
