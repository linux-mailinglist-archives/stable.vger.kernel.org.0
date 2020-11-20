Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D87AF2BAACF
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 14:08:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727364AbgKTNHM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 08:07:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727316AbgKTNHM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Nov 2020 08:07:12 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C10BBC0613CF
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 05:07:11 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id v12so7771706pfm.13
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 05:07:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jHr1sDY2Dyba7Y9ONuNDvW+LxyugOGUNwmOdm81atmM=;
        b=Kf14lmB1BzyVlHf5DFSoFPmhrO/26WcAJyxtk0op07uDdDDSv8rDiqwNtItgI6UHmI
         hMk8qWrovPmCzw8YpxLcClL/8kFjru/QLecqDCS38fECv7Cpst95L0Sf/zrs1Qeqw6u9
         pOSyM5R5FebYNVHFnhp/yAyjGny36SyySY9NupcCXmOa3ltzEiKCL2yZ9CKl3UZjM2Ov
         WdqexcQvE9RtE7O8BldnZc7zovODzvMd2MGQemYnz5o36IZsk+Jg7EwF3ZpbchmECxKk
         LmB6XX35Lht5VgGZIvr90cc0nN01vQh8bsWw881so2lGbm7W/kNwTTgOSHmlUV04202Q
         w3aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jHr1sDY2Dyba7Y9ONuNDvW+LxyugOGUNwmOdm81atmM=;
        b=uEGGtCEEnFiVPht0UepQZmYP30sNtvdPzqvyHXm4fkxpGa6id/e+tlcL/wigXP+RW6
         NduaZ7BDtDqaSxe0Cc3mBpK1yJB+TzlJlAaSzG4ixiKcuC54Xc5W+RtzdO/US126fHhm
         lEpCErh5ENbbFYz0SwwCML5h+AcM3rvrUSBi904HfogKbk7GbqMt6JT0A1COM0ozFwc5
         qUpGWoyoaorcqJ7gWLhDImbG78P6TBUMJCdQr+B0zDw/lYFtf8jUHqS5A6NGeRijC+8R
         R0HdAB8tbU+xin4bbQYrVZNldCtmMBBzz7Wh/RIm0yI+EMfM0xZFaaOCgIH/oHD+xKqn
         PD5Q==
X-Gm-Message-State: AOAM531HgnYWeVpQnDbiIW/jSpXWxjVqAFq/IvrDTYg0DY2RWYprPYJU
        pkbF072uLyieeWBkUoz88qhdqiIV5UHWxQ==
X-Google-Smtp-Source: ABdhPJxRjo49QCDLKFC1GM3qfIrRW4U1OkSgBm4QOJROg784O+eUUcbWnUQlamvzvAKJ9ogcmlGeiA==
X-Received: by 2002:a63:495d:: with SMTP id y29mr8744109pgk.384.1605877630498;
        Fri, 20 Nov 2020 05:07:10 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l76sm3770732pfd.82.2020.11.20.05.07.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 05:07:09 -0800 (PST)
Message-ID: <5fb7bf7d.1c69fb81.149cc.6e90@mx.google.com>
Date:   Fri, 20 Nov 2020 05:07:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.158-8-g062c323df420
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 151 runs,
 4 regressions (v4.19.158-8-g062c323df420)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 151 runs, 4 regressions (v4.19.158-8-g062c32=
3df420)

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

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.158-8-g062c323df420/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.158-8-g062c323df420
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      062c323df42032143a3496f3e6237f507f31300c =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb78dc1b1571243d0d8d913

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.158=
-8-g062c323df420/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.158=
-8-g062c323df420/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fb78dc1b157124=
3d0d8d918
        failing since 6 days (last pass: v4.19.157-26-gd59f3161b3a0, first =
fail: v4.19.157-27-g5543cc2c41d55)
        2 lines =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb78c0a92da7ab432d8d934

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.158=
-8-g062c323df420/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.158=
-8-g062c323df420/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb78c0a92da7ab432d8d=
935
        failing since 6 days (last pass: v4.19.157-26-gd59f3161b3a0, first =
fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb78c1fbfdb346c57d8d90a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.158=
-8-g062c323df420/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.158=
-8-g062c323df420/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb78c1fbfdb346c57d8d=
90b
        failing since 6 days (last pass: v4.19.157-26-gd59f3161b3a0, first =
fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb78bcf7922f2afa8d8d91c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.158=
-8-g062c323df420/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.158=
-8-g062c323df420/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb78bcf7922f2afa8d8d=
91d
        failing since 6 days (last pass: v4.19.157-26-gd59f3161b3a0, first =
fail: v4.19.157-27-g5543cc2c41d55) =

 =20
