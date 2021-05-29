Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88EEF394E6E
	for <lists+stable@lfdr.de>; Sun, 30 May 2021 00:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbhE2W7X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 18:59:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbhE2W7X (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 18:59:23 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50ED3C061574
        for <stable@vger.kernel.org>; Sat, 29 May 2021 15:57:45 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id x18so6071969pfi.9
        for <stable@vger.kernel.org>; Sat, 29 May 2021 15:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wswG0z7MzAfytR4ERCwsVAsJSAzzk0nHbCB2TFaMhTs=;
        b=VsmSpHh/mAMp73uhq05WXQXW18c5tV57XHxGJwYY7DMuIruO10hSgsx0y7E/+c8MDA
         LhrQhmkFXT+x3/FEZkYiWK5dmQ5Q7g4QRCwFhE2ZN+y+kTrn77kPKKLiqCiasLM0GmwR
         +H7nGE/NuKD035Qos4Cbmumg0FLA8XLEtyLsEbex5ttI2G0C1pVCbDLMOsab8NNLW2D5
         yiS/VTV9UhBP+bWnrnVUeDYaIRsFhlCqElvXkvBXHgTF6w/AwbKQg0x5QAa1D5UQvw4L
         KAN6uzgBdwAsTSr5/c9FbOC4d0JYMJ4HHAFBeQkl9NUZK1aMzJ5sL4Yx7LU2e81Nje4r
         xwvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wswG0z7MzAfytR4ERCwsVAsJSAzzk0nHbCB2TFaMhTs=;
        b=ibeI5p4xvXsGgxCaoxi4KUKDVMs2dOkmCX8Ly+/fI2sO5dKdy9Klp4wz0QOQrcvWyH
         fur7yEoLoAO3g8JtdtFsjDizaKTi4zehjnuAjFDuGSFd4qMnFuxd+TEHMdDTsJMOfaFP
         t8HUiFw76E+cmzPzBzeWT5pOXtEQI3M9HZ8Jl33vbww59UoZxGJRKKXEsyglL8WucTkB
         yQbQ1UCmydkIa+crCebvGjTJRfYVvaEMSWEQ75qBaZyu038SHHK0RkaW1gukHx/akIR/
         ok1QuIW9sJu2WyE0JOWp7zawYpH05z9FwjEdut23oV2A/1NNFzCWYmpZr0P7jOuqCaRB
         EwzQ==
X-Gm-Message-State: AOAM530sL5QdocrIIyGaOlTH4MWNKIntLLTwWHs5O/UQ73pZiuzsC7P5
        qjcdGmTtD/dbLmM3oFenhSFzRvAf19SRmZz9
X-Google-Smtp-Source: ABdhPJwihYhjzG0gT1YR4t8gJJOLujv4a72YiFIqNv0hGjL+rKkDxb8702I111BbEvtYHt3UDjoTsQ==
X-Received: by 2002:a63:3752:: with SMTP id g18mr4230659pgn.425.1622329064303;
        Sat, 29 May 2021 15:57:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id pg5sm6841069pjb.28.2021.05.29.15.57.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 May 2021 15:57:43 -0700 (PDT)
Message-ID: <60b2c6e7.1c69fb81.2b2d9.688e@mx.google.com>
Date:   Sat, 29 May 2021 15:57:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.192-23-g85151c3abdc5
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 180 runs,
 5 regressions (v4.19.192-23-g85151c3abdc5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 180 runs, 5 regressions (v4.19.192-23-g85151=
c3abdc5)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.192-23-g85151c3abdc5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.192-23-g85151c3abdc5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      85151c3abdc56267d76037a2c01d106528d6d32e =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60b2938edf00f84767b3afbc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-23-g85151c3abdc5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-23-g85151c3abdc5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b2938edf00f84767b3a=
fbd
        failing since 196 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60b293bfa4a37cfd34b3afb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-23-g85151c3abdc5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-23-g85151c3abdc5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b293bfa4a37cfd34b3a=
fb2
        failing since 196 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60b29393df00f84767b3afd4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-23-g85151c3abdc5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-23-g85151c3abdc5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b29393df00f84767b3a=
fd5
        failing since 196 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60b293af7665fd4ce2b3afa9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-23-g85151c3abdc5/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-23-g85151c3abdc5/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b293af7665fd4ce2b3a=
faa
        failing since 196 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60b29c698553580ce6b3afaa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-23-g85151c3abdc5/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-23-g85151c3abdc5/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b29c698553580ce6b3a=
fab
        failing since 196 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
