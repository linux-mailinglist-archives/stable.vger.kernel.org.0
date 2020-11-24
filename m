Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 889BA2C2E7E
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 18:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390718AbgKXR0x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 12:26:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390842AbgKXR0w (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Nov 2020 12:26:52 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 835DBC0613D6
        for <stable@vger.kernel.org>; Tue, 24 Nov 2020 09:26:52 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id c66so19169658pfa.4
        for <stable@vger.kernel.org>; Tue, 24 Nov 2020 09:26:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bCre2fXnW4+V1qfAk0I2cqoqwPVpkukE+avXehrz0iU=;
        b=t+8T3sDogihl/UBIJAbNEMxqRgWobRuNMrE8PKSA5iMFkrFyGRDh4hsNLW6b2dgXRv
         mDVPdFQSl5m1E1jI6cviRkXQ2sMyKjuraWlYZqvaZSuP/Qkm5EuVAP403tuX0V/aEjye
         uuDAz0i9iu/SkdX8IpU/Mb0Oh4cV0I8uJ8d7g2zehxacgvVbQsfEf6pcQ8+8Y3qrC/wF
         bFBLGF3/Cb1nkQBgFolAXUgnEbePfpfDxTw+ejPDMSwwadRTGVOTW7UgGmIy3LgfpexL
         XladJFQE4yK/eFSW3YgtpdMG/cCAugCYVIlkRUxXyWbXz8BLVfHotSBYuuiAIXXArKZH
         nKCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bCre2fXnW4+V1qfAk0I2cqoqwPVpkukE+avXehrz0iU=;
        b=Hsr0xUnYo8kmDpFnZwZHp8gjgRiE5FYl1gTCjLKnVOB+8EmY1UkneK44Rs+oim+ubw
         iYKTE650IXtKa86s3HgPOK/LyDO7JcjdrCwUu0mSptGxRM3az00uLY+GubFfObBHWWVj
         87jfOcOy+56baW+h6EB49FGEPjnAhmd69vNOipUWnWR/a5ynCyBXzFdAh0pJplAtRnOr
         BQXC3RWG1XOj+IeGvYeY5ugfeI3x495la5LcWPF9M3euESKgiYpMqc4uWEpzN476nktT
         SOuOopGy1+WwtHylAodVx/VD1HnBQyQ5YIPJjeFzaIJqF8Du1aLibJfbbamseUWzjPmZ
         cgug==
X-Gm-Message-State: AOAM532Q7ehzYoBaz+BxAhrdTn0YVuKyE9la89fXMb18mWj2kpcpQ2u0
        nX4AfmQFVi8burCwBXY0u7Kz7xJBwSLQBQ==
X-Google-Smtp-Source: ABdhPJx5jz1/BgVmqcVaRt3IaBHgrYlSChR4uoMfO75QhqG2IDg9VHn/KbPgXqza4fl4VBiVie6hNg==
X-Received: by 2002:a63:c34d:: with SMTP id e13mr4430342pgd.22.1606238811699;
        Tue, 24 Nov 2020 09:26:51 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t12sm15291674pfq.79.2020.11.24.09.26.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2020 09:26:50 -0800 (PST)
Message-ID: <5fbd425a.1c69fb81.e0e86.29e3@mx.google.com>
Date:   Tue, 24 Nov 2020 09:26:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.208-60-gf3bba3045f18
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 137 runs,
 5 regressions (v4.14.208-60-gf3bba3045f18)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 137 runs, 5 regressions (v4.14.208-60-gf3bba=
3045f18)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.208-60-gf3bba3045f18/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.208-60-gf3bba3045f18
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f3bba3045f18f35d41009f8fa869296edef21bde =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbd0f7cc28dd0fafcc94cc7

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-60-gf3bba3045f18/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-60-gf3bba3045f18/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fbd0f7cc28dd0f=
afcc94ccc
        failing since 2 days (last pass: v4.14.207-18-g5602fbd93fec, first =
fail: v4.14.207-17-gc8bd4f3bbcaa)
        2 lines =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbd0dbfa7feb4997bc94ccd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-60-gf3bba3045f18/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-60-gf3bba3045f18/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbd0dbfa7feb4997bc94=
cce
        failing since 10 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbd0dc0a7feb4997bc94cd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-60-gf3bba3045f18/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-60-gf3bba3045f18/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbd0dc0a7feb4997bc94=
cd4
        failing since 10 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbd101b04d961fec9c94cdc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-60-gf3bba3045f18/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-60-gf3bba3045f18/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbd101b04d961fec9c94=
cdd
        failing since 10 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbd0d749c8e026667c94d1c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-60-gf3bba3045f18/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-60-gf3bba3045f18/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbd0d749c8e026667c94=
d1d
        failing since 10 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =20
