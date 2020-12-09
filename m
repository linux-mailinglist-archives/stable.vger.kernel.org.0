Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C79A12D45C2
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 16:48:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbgLIPqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 10:46:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbgLIPqc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 10:46:32 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 367CBC0613CF
        for <stable@vger.kernel.org>; Wed,  9 Dec 2020 07:45:52 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id r4so1120939pls.11
        for <stable@vger.kernel.org>; Wed, 09 Dec 2020 07:45:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QB6Ee4peWGpJe5TgtxjWuU32lCmj2g5d5NRT/IYOMWw=;
        b=B+qlikrmnDLWModndUviva0uFt/rVdjP02CM2DcDBN/11741wCks+ymc9LZPOl9iRO
         BlDJyL+oetrksoka4pnUn/6/ZTbZyfDGExgBgAIGF/ZkSWMkhUSbcmCMHYGPtBGTguSH
         nWNSH7HkaLxiGBgM+SSjVKH9OYfz/ZGsv2TwnRPhOmp9KYdLfwKN6gBk0Wb0o0SghQC3
         7f7ny+gGwTT5AxvfL12fBYLxTXW4OJ18qxciWNN95owmJ7xfn/7ZUD+S3J8O6ivPl40p
         LrKmHnSUAjfdYLEcq5pIdkOn4iAreFXlIavnPB4eDJsqx+gbWMfowbh+TQPSHlsoCCcF
         Fr2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QB6Ee4peWGpJe5TgtxjWuU32lCmj2g5d5NRT/IYOMWw=;
        b=iCXxsLm6Sb1XJyt79qf9H3S1olkEfJy4QZgJNSnO+jFBW1NwO49ZwkmxqaG4TfhGdU
         6o4DqKg4DwK4vSLoQDk00uGv7sbCygK04DY8ogCFi85TgogME2spGDwgKi3eouBOUkbu
         BDRTCK0RPEi0iqcWXksxVT8t82Ihk6C4rnGjpp3alTOUQCgVvMvOCyttOZ0VSSN7GIuk
         sRpBeQpsTRDCZhi0Gk3CyNarJkBcNtU1xTn9ZzqhJ+oGAHPCESBRCfpx88oJXVk+O7Gx
         cwo/tsL5J8GxnsKvk1f8P/wSO8ix/uvOnXu8cNb61n+AQh+f11ii5OWZimZ9OVyiM5WB
         z3CQ==
X-Gm-Message-State: AOAM532N5BpDWSgrYY34Vs+chlDZr0wR9EcJwAx6yIR8WzOxxYCZeppJ
        m1GNHhXenQSfLj7Dwwa0oEegPN+ySN/2nw==
X-Google-Smtp-Source: ABdhPJwGq+mSQy1MCI1uG5dOetG9jNzoZSH84sRoWxib5/TwLPCHyDC66qBmpoR6wE7b6x/A49w9Gg==
X-Received: by 2002:a17:902:bf4a:b029:da:d0b8:6489 with SMTP id u10-20020a170902bf4ab02900dad0b86489mr2537525pls.58.1607528751372;
        Wed, 09 Dec 2020 07:45:51 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 29sm1642751pgu.77.2020.12.09.07.45.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 07:45:50 -0800 (PST)
Message-ID: <5fd0f12e.1c69fb81.7e851.28bb@mx.google.com>
Date:   Wed, 09 Dec 2020 07:45:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.211-20-ga8b522f1aec2
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 114 runs,
 4 regressions (v4.14.211-20-ga8b522f1aec2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 114 runs, 4 regressions (v4.14.211-20-ga8b52=
2f1aec2)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
meson-gxm-q200       | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.211-20-ga8b522f1aec2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.211-20-ga8b522f1aec2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a8b522f1aec222eb295beeb898c7ded21760e031 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
meson-gxm-q200       | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0bc755a787b9212c94cd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.211=
-20-ga8b522f1aec2/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.211=
-20-ga8b522f1aec2/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd0bc755a787b9212c94=
cd2
        failing since 1 day (last pass: v4.14.210-20-gc32b9f7cbda7, first f=
ail: v4.14.210-20-g5ea7913395d3) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0bc62501c41b1bdc94cbf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.211=
-20-ga8b522f1aec2/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.211=
-20-ga8b522f1aec2/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd0bc62501c41b1bdc94=
cc0
        failing since 25 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0bcefbc405fa90bc94cc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.211=
-20-ga8b522f1aec2/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.211=
-20-ga8b522f1aec2/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd0bcefbc405fa90bc94=
cc3
        failing since 25 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0bc52329ad52601c94cd5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.211=
-20-ga8b522f1aec2/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.211=
-20-ga8b522f1aec2/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd0bc52329ad52601c94=
cd6
        failing since 25 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =20
