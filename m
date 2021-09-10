Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60386406ACD
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 13:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232727AbhIJLoO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 07:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232613AbhIJLoN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Sep 2021 07:44:13 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD8B8C061574
        for <stable@vger.kernel.org>; Fri, 10 Sep 2021 04:43:02 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id v123so1624221pfb.11
        for <stable@vger.kernel.org>; Fri, 10 Sep 2021 04:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4w9S8H0chCgk4ykeHD2/qNQwH/TSPUUCwmYWW42QE0c=;
        b=Y2F2ItIlwqABZG7agimWPB9vH+kBo7kSbXDlHzRXEKs78sE29WWkUD4v472HEy7IdP
         IDdyI8qv2OdyQQsqJlxe9f+zeYsnjx4YQrb06tjVvAxF+mmnhJdBHi8AJzkvKNOB25xK
         Hrrm0IZFrO83uKUSoRJMyg7gRU31n0ONyXT7jgO+K9OTCpeVRKyLjRFbV8YM67PlcmLm
         FtQMRTE8vwCN4yFdXUdAon04EuNOm0AeWxBZOXiHWgP0URpkTE7lP3snMtP65ycwoCsS
         JNYC+BJT7xPwyf85RYqS5CA4e+KxkiTgzoeq5Y97micSZRjP+UCKnheuWVD8+NtS1UGo
         ksXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4w9S8H0chCgk4ykeHD2/qNQwH/TSPUUCwmYWW42QE0c=;
        b=tB1D6ciEBIR7Qj1zoOaysR5BHUKVxX4eSiJs03ybJb9cLQZXWq486tJ7nS0bvedbIl
         nBr4TIdF5WN4fD/qk5c+15ViyL58xq2gvBTx62Y1HiN6x70w0SeHuk+R0YCD65ghI2bP
         QYgY+48dPlU6cmf4nfgDkQRcIfcPixZJO+/OrUChmiBC1fyeSiVvnzRnlLDv9ve3XNFS
         4uR+hLaluoX7jrEsG66ZGuqDWmkYfMcKXTXnypZchQ8NHUQQiFNx1DA/6UcIAWkIurKF
         Ee+9ybo9ljR6lmn+cWA/Xu1DI/ArqK2PU1OlvR7PlRnveaxFRSZ3kxelZ5ATB74rQa7m
         xftg==
X-Gm-Message-State: AOAM5305/ig02dXIrwvjdYGW+754H/gW7zgJpobwgQhBeUQCoN1qtKKi
        LyYzbcEKSVKlnUHWk3bLyqwX6JQBRU7r14+f
X-Google-Smtp-Source: ABdhPJwnPKIAXQ4urztJ7bbypq+hVy2VNAyFHNH6EMQT/yUlrxltRbeheL9rh211DzjIROl9noGKdQ==
X-Received: by 2002:a63:3e8c:: with SMTP id l134mr6891372pga.463.1631274180799;
        Fri, 10 Sep 2021 04:43:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i10sm5036473pfk.87.2021.09.10.04.43.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 04:43:00 -0700 (PDT)
Message-ID: <613b44c4.1c69fb81.2afae.e072@mx.google.com>
Date:   Fri, 10 Sep 2021 04:43:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.282-32-g848355b9467e
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 136 runs,
 4 regressions (v4.9.282-32-g848355b9467e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 136 runs, 4 regressions (v4.9.282-32-g848355b=
9467e)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.282-32-g848355b9467e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.282-32-g848355b9467e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      848355b9467e5e8abc90409df4edba6a39ac1cda =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/613b100132af1e05d4d59677

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-3=
2-g848355b9467e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-3=
2-g848355b9467e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613b100132af1e05d4d59=
678
        failing since 300 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/613b1139861c42cdc6d59667

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-3=
2-g848355b9467e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-3=
2-g848355b9467e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613b1139861c42cdc6d59=
668
        failing since 300 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/613b16f3dfc01eb65ad59665

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-3=
2-g848355b9467e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-3=
2-g848355b9467e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613b16f3dfc01eb65ad59=
666
        failing since 300 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/613b139c9df45c623ad59665

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-3=
2-g848355b9467e/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-3=
2-g848355b9467e/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613b139c9df45c623ad59=
666
        failing since 300 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
