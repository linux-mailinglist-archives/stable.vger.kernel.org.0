Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9396736C813
	for <lists+stable@lfdr.de>; Tue, 27 Apr 2021 16:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237464AbhD0Oz7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Apr 2021 10:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236144AbhD0Oz7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Apr 2021 10:55:59 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F857C061574
        for <stable@vger.kernel.org>; Tue, 27 Apr 2021 07:55:16 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id s14so24206078pjl.5
        for <stable@vger.kernel.org>; Tue, 27 Apr 2021 07:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Lyei7r1Q+Hgs3r+VsTSx0nI2i9gPuKRryM1tZlhX1PE=;
        b=Lj28qkEhgnHFIuBWpX3g55CKJUg/OCU7sgHvAkywx7XNK3g6KcqjHOXWKwH71Oozc0
         t3h/xBZ5/04nKJptPJOtQwBcTvhDZDP32VhZWH36NX7TH3vaF6Vz6ReztH3dNXUKdcG2
         JEza7imysaYRSJQCzV37+EwZNN9/zj0GBRz3sMx2s9zb0mx02NwPE/VGcVhkR6RRZhzM
         bw+EUyGHpDbULMzIfodNLo8KbpmYKP1zrTTSUs316/YUIHkl8ZyOxguvwX98uSE40NyW
         RziH2EZBc3gLl5nwWmQRVcxQT33TyQMbjaVSk+TKofzEg4i/0BGMeE/C947z5ShLVp1G
         n6Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Lyei7r1Q+Hgs3r+VsTSx0nI2i9gPuKRryM1tZlhX1PE=;
        b=KHoZnBP8La6wCQ0tlU+bJx62HwXmWkqldMRtpvf6givHsr7bfjW556z4eCir5LNbPH
         MzUjXj3/y4nFb+dm+i8ZxeIcdOCJsZFoBnDNrCMUG1rKVZr8O5aUFZ+unFeB54NUvFqz
         ynNVcNErkBvPj27BEMoHuVevOcSUZV/3FiZHMBTA6ASGbShPgptd8Zvwzomh28oI8ka2
         rOMeay6eAvL5Rv8Jo+PYzj6jPK5OcZ4uU/CuOZmkU1DVrQr3QHZ6em4Q7uN5d5ekWF45
         JRg3exEDgIBCoW4hNbEBylQisnUVtDaWb0tKYqqBuLCEBzDkwHDlvR1rClvr+v5azp8M
         HOWw==
X-Gm-Message-State: AOAM532nZ5zbANX5n2ejEk4Np5XNjJIIN3Whlb7pfGcqN9Bj3CoeukzP
        c740j/jwR6o2eSBRIYHttxuGSi8paL15U0tB
X-Google-Smtp-Source: ABdhPJy1L8LbSilRVIuz4uRzVIEkncyHcPP+xlrI9aopwXSkgArjT1/cT/JiK/t76gr6Nd9JMFVoqQ==
X-Received: by 2002:a17:902:8697:b029:ea:a5dc:925f with SMTP id g23-20020a1709028697b02900eaa5dc925fmr25046577plo.56.1619535315744;
        Tue, 27 Apr 2021 07:55:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r32sm110752pgm.49.2021.04.27.07.55.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 07:55:15 -0700 (PDT)
Message-ID: <608825d3.1c69fb81.96491.0528@mx.google.com>
Date:   Tue, 27 Apr 2021 07:55:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.267-38-g98c9d8042520b
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 97 runs,
 4 regressions (v4.9.267-38-g98c9d8042520b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 97 runs, 4 regressions (v4.9.267-38-g98c9d804=
2520b)

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

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.267-38-g98c9d8042520b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.267-38-g98c9d8042520b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      98c9d8042520b7cf22c22aaa3f9d5ed46e3253f7 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6087f1bba2f5f7acae9b77a6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-3=
8-g98c9d8042520b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-3=
8-g98c9d8042520b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6087f1bba2f5f7acae9b7=
7a7
        failing since 164 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6087f1e67752c11fed9b77d9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-3=
8-g98c9d8042520b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-3=
8-g98c9d8042520b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6087f1e67752c11fed9b7=
7da
        failing since 164 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6087f1c5e2032039149b77c2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-3=
8-g98c9d8042520b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-3=
8-g98c9d8042520b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6087f1c5e2032039149b7=
7c3
        failing since 164 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6087f18493b58389459b77b4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-3=
8-g98c9d8042520b/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-3=
8-g98c9d8042520b/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6087f18493b58389459b7=
7b5
        failing since 164 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
