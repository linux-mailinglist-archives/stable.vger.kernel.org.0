Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FDD835B6CF
	for <lists+stable@lfdr.de>; Sun, 11 Apr 2021 21:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235234AbhDKTu7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Apr 2021 15:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235127AbhDKTu6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Apr 2021 15:50:58 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB99BC061574
        for <stable@vger.kernel.org>; Sun, 11 Apr 2021 12:50:41 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id r13so1688561pjf.2
        for <stable@vger.kernel.org>; Sun, 11 Apr 2021 12:50:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jdzEK5aSWCRUiryeUm+PCgdtKlN9nmf8DHyL1uMgKIA=;
        b=NG3jxadLmIL1An65R9nLT89vLqtuMopssSdEA4YFE1hpJjrk1UTe6c/i16Ux6rju6a
         5CL8i3Z1U3QC0SAaqzemA1takuy4LBmKk35Gw429I9MjipCWsXSLfLCHBoQwYXCFbs6P
         Ezs+kjOavisR5fPYoIPxdtTIlb2vcwBvG918g8G4+6g16Up68bWyWTTzrCIhtQaqFLVk
         SI+314p0HSd2cyGhDYvHT+jEUMNmhrB06OopTJncExv31O0ol7Lt4uNPySgMMu5ghoYI
         A52DCDn2rktbnrtwwkn6jPrqx5LbUfFsksCwOJMyyEOwfBwLo9CZuDDv8LQBhBL5VAtW
         q03g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jdzEK5aSWCRUiryeUm+PCgdtKlN9nmf8DHyL1uMgKIA=;
        b=Ls4RmgQpBj2i/d+dSAdnRej6SKnq6GB7tjCJcD+Eci7AChJjYnOexZAh+GLE/HxLSG
         qiIzp7IGRsJPB8XJPLGx64H/TbIyzlav4p525Smw2Fl1u8/ZYp+88D5k8guRDKbu7WYl
         5WJqzX9tKdkzevrogkV/Va6Hh/8stzxDBoVygvl5bmGXT6QLNOQuuPC5jl6udu2hBkpz
         KPxZDGOfZTKCLmn049K4tvqGFUfZWow+hjZHeDjb0aB2nSlYOmucGVu0oFt5I79Y/F+m
         +3EMgt7qbP1a2bYyNNyUJE2mHgS1pV8Xjtw0dAAMGVMOPtMMOpQGIoCw5aoUsBKiHgU3
         nq2A==
X-Gm-Message-State: AOAM531r4/V/4ioIc82hKfZooEbj6DiPP8L9Q97Jw5xx6ylNDM1/PGCU
        UQ6fqw54wNDYDJc7XN90EJZNkeAb/df6IdSP
X-Google-Smtp-Source: ABdhPJwRKcV2IKsFFNXSSZB/E2RUM5JLmIsFBVQszk/dMvYdF2w7s+w+KXv38io3R98exvWRehNYjA==
X-Received: by 2002:a17:903:1cc:b029:e6:f37a:2185 with SMTP id e12-20020a17090301ccb02900e6f37a2185mr23328752plh.67.1618170641087;
        Sun, 11 Apr 2021 12:50:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e9sm9280568pgk.69.2021.04.11.12.50.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 12:50:40 -0700 (PDT)
Message-ID: <60735310.1c69fb81.7862e.5cd1@mx.google.com>
Date:   Sun, 11 Apr 2021 12:50:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.266-17-gbef36b8f37175
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 125 runs,
 5 regressions (v4.9.266-17-gbef36b8f37175)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 125 runs, 5 regressions (v4.9.266-17-gbef36b8=
f37175)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.266-17-gbef36b8f37175/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.266-17-gbef36b8f37175
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bef36b8f37175953058fe149a68ae7d3e1057bf7 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/607320a0d4bedbba2ddac71e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-1=
7-gbef36b8f37175/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-1=
7-gbef36b8f37175/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607320a0d4bedbba2ddac=
71f
        failing since 148 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6073209b07e880e233dac6c6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-1=
7-gbef36b8f37175/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-1=
7-gbef36b8f37175/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6073209b07e880e233dac=
6c7
        failing since 148 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/607320a4d3345f12d7dac6b4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-1=
7-gbef36b8f37175/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-1=
7-gbef36b8f37175/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607320a4d3345f12d7dac=
6b5
        failing since 148 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60732035d3782914c2dac6cb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-1=
7-gbef36b8f37175/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-1=
7-gbef36b8f37175/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60732035d3782914c2dac=
6cc
        failing since 148 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60732036285dbfe403dac6d1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-1=
7-gbef36b8f37175/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-1=
7-gbef36b8f37175/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60732036285dbfe403dac=
6d2
        failing since 148 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
