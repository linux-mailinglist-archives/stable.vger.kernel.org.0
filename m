Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0A853110A4
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 20:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbhBERUM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 12:20:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233653AbhBERQ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 12:16:57 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46575C0613D6
        for <stable@vger.kernel.org>; Fri,  5 Feb 2021 10:58:40 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id j11so4029069plt.11
        for <stable@vger.kernel.org>; Fri, 05 Feb 2021 10:58:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HDjOhka7CjoBq+eaRDsLDoj0Qe/MKRJDGAbItisSlsE=;
        b=QgM/Hzxq9yXNIRFckP0cE4/ikSjlhrJvHAre8+FQfJm6mFmmvXWA8Gnk4pDV8A49k2
         CZSEQ7b8dKwnXx6ia3RdB0iQMpapxYR3GpM7K00KTfAsxvHa4GFaim2v4mJLyvtKgRY2
         OUp+ai/BucZ3Gv9SdOSAgumRonk1LGeG6imVjBmDpXBM8tfyj3rUZoRQIkgcZk8CXuzR
         +4upGPsNfou5BC39jXZQ6hvvQaJG7dQmtVaIOhgpAr8MYYA/nGW1tYW1xpLNW5etDhpn
         mbPFcmh2voFdU97Zrk54iwreHLx7+MxI4Weq8MakUzEq/tXkaBIwTn77xNW2OgRk6X/6
         6+xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HDjOhka7CjoBq+eaRDsLDoj0Qe/MKRJDGAbItisSlsE=;
        b=c89O69A+HgjjwDil0zRtfEbAXUi2KEdOsUZnC4xNPcWIn7tg0Sx3fBTlQlf1zXBjdo
         NDFhMoeXUagtQeDA2vvWwlbjeiWAdnAi+iP433gefVjQNheiQY6Cf/whZiJwvg8fv1Y2
         wgd2WRokS7/ZSEWir+1GWWeEn2G8xOL6fnpgxIuWpkxfTPTedo3swS599g1PJV4S6lsB
         ++SM75ahVgH1r4RoY6NgkhyXYMdONeVoVjoBI+suwhX6p+byMMZCRjA6aQBQvf0yFWtJ
         tVpUFhSxPoXa1XoR0ci1B7Ry1xgC5LFSibaBcTJo2b4Rvs030Yal8qAHJdTiVAsXyzQP
         SQsw==
X-Gm-Message-State: AOAM533ye37pH49MlMp0Iw6rJ4NkKXKE/ZcJxJzS8dVlQMbOjgbNMpdx
        OAd5bu8YCCgbZTm/rryVL7RXp9hU8jbpfg==
X-Google-Smtp-Source: ABdhPJwpFqnXLZtMc0QVflATn7uNcQB2Z7/OAUrXpMHYltWmucbEYoItuvYm1jvyykRCsBE9crzT5Q==
X-Received: by 2002:a17:90a:6a0e:: with SMTP id t14mr2300183pjj.216.1612551519553;
        Fri, 05 Feb 2021 10:58:39 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o190sm11312296pgo.50.2021.02.05.10.58.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 10:58:38 -0800 (PST)
Message-ID: <601d955e.1c69fb81.722ce.7efa@mx.google.com>
Date:   Fri, 05 Feb 2021 10:58:38 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.256-18-g9a90abe4b6d7
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 100 runs,
 5 regressions (v4.9.256-18-g9a90abe4b6d7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 100 runs, 5 regressions (v4.9.256-18-g9a90a=
be4b6d7)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =

r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.256-18-g9a90abe4b6d7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.256-18-g9a90abe4b6d7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9a90abe4b6d7ffe084575ce067f9871dc8f7a245 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/601d6111006140e4833abe83

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.256=
-18-g9a90abe4b6d7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.256=
-18-g9a90abe4b6d7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d6111006140e4833ab=
e84
        failing since 82 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/601d62ecb95299c52f3abe7f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.256=
-18-g9a90abe4b6d7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.256=
-18-g9a90abe4b6d7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d62ecb95299c52f3ab=
e80
        failing since 82 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/601d61185b2680d2603abe7a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.256=
-18-g9a90abe4b6d7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.256=
-18-g9a90abe4b6d7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d61185b2680d2603ab=
e7b
        failing since 82 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/601d60d07b0a684b653abe86

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.256=
-18-g9a90abe4b6d7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.256=
-18-g9a90abe4b6d7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d60d07b0a684b653ab=
e87
        failing since 82 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/601d63f16e0daf21113abe6c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.256=
-18-g9a90abe4b6d7/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.256=
-18-g9a90abe4b6d7/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d63f16e0daf21113ab=
e6d
        failing since 79 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-79-gd3e70b39d31a) =

 =20
