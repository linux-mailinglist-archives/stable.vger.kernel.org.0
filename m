Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1861F310D95
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 17:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231911AbhBEO0U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 09:26:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232579AbhBEOXg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 09:23:36 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D9E2C061A27
        for <stable@vger.kernel.org>; Fri,  5 Feb 2021 07:50:00 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id m7so7843010oiw.12
        for <stable@vger.kernel.org>; Fri, 05 Feb 2021 07:50:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dsHGmwg9Ggoy9aJMY5q/c1urIxO9LS4sNDcMRxSlY94=;
        b=tX/UYeaIgkH9UwHkNfbbVCoD46wAoOEz84jpaTI54awyywiwneGUfkbT66j8neihvd
         rJVKMZWRfEUP9RI1Tp9oHnshN5obMJnT+x9GRkyMlMG4Swx01KsEb++vJiUoPOoWoX1q
         8iO6YJm6JJ1uGj0hMOUldQRk4dj+53a3+cdDYjRkJ7N/LEdTuzk3LHWqIsJedkUIRUZw
         8vPsbBnmTY+b7edgtBdhoA1sNR7qqZtDL8TAlE6b/0YStAAYcKk479+7tB6urq4Nadbf
         6OPX9rW0852hz/UD3U227jTzH2ffDSsgnYtDImPsQ6Z447zlFGWXKLXDACa6e5xhzYKP
         3aMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dsHGmwg9Ggoy9aJMY5q/c1urIxO9LS4sNDcMRxSlY94=;
        b=Flm1pLDbySi8GCPeQvHqPSyv9ymRP/TWOki2hWonyzUkJWXua06m1PN28N/DGyjYms
         /+iisZsmTrhee1PKoOYZ1hGOVSmUW0K+1WcZxADiVpfqW+iV9SYyYUJRewFBeVnwmia0
         zljCH43V2YJ6UqtrnR8u2cu9J6t+XNk/Lp8OVPoeOVt8/dJP5B0oPBLVKXnj4wNNmXdy
         tjp8nKdBwAYMdD/9ZA96h1QRcqXf+nkiYR+u2mwCLSKNycAWM8o4nPt+kjXWvJVjWKQU
         LIJxR5lhu5puOd4lQOqtpPTn240iguubOYvq/RH6Aw3ox4WzOtbAA6PIREFH+giIOVdL
         ZFxg==
X-Gm-Message-State: AOAM531Yv1KtH6h2vzsUvTZoY7ljbr+nTFf/YelYa+w2XDcqNk+F1JY1
        9lI4yumAwkLTPLdItEFu95uQYZ7ZdkrtJw==
X-Google-Smtp-Source: ABdhPJxA5B9TvDTFhMu3OtQPlVWcmC4RGgFaszyfRX+tEeKfF+cGrGwwUOw2E1FUy7v+wNxepgRV2w==
X-Received: by 2002:a17:90b:46c5:: with SMTP id jx5mr4678383pjb.27.1612539751489;
        Fri, 05 Feb 2021 07:42:31 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f3sm2393883pgj.6.2021.02.05.07.42.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 07:42:30 -0800 (PST)
Message-ID: <601d6766.1c69fb81.173b.3e36@mx.google.com>
Date:   Fri, 05 Feb 2021 07:42:30 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.173-5-g9a0b47b184f3
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 137 runs,
 5 regressions (v4.19.173-5-g9a0b47b184f3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 137 runs, 5 regressions (v4.19.173-5-g9a0b47=
b184f3)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.173-5-g9a0b47b184f3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.173-5-g9a0b47b184f3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9a0b47b184f313dc0d8468f62aa813ec76bfb702 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d358630a627e37e3abeaa

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.173=
-5-g9a0b47b184f3/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.173=
-5-g9a0b47b184f3/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/601d358630a627e=
37e3abeb1
        new failure (last pass: v4.19.173-3-g00c3d82a0479)
        2 lines

    2021-02-05 12:09:37.773000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/112
    2021-02-05 12:09:37.782000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d3291168d7247c23abe6c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.173=
-5-g9a0b47b184f3/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.173=
-5-g9a0b47b184f3/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d3291168d7247c23ab=
e6d
        failing since 83 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d37554738e4a7483abe80

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.173=
-5-g9a0b47b184f3/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.173=
-5-g9a0b47b184f3/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d37554738e4a7483ab=
e81
        failing since 83 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d3241eb636d47683abe96

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.173=
-5-g9a0b47b184f3/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.173=
-5-g9a0b47b184f3/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d3241eb636d47683ab=
e97
        failing since 83 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d31e6dd508919d23abe76

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.173=
-5-g9a0b47b184f3/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.173=
-5-g9a0b47b184f3/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d31e6dd508919d23ab=
e77
        failing since 83 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =20
