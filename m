Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0868C3F8DCD
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 20:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbhHZS0N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 14:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbhHZS0N (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Aug 2021 14:26:13 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 995FDC061757
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 11:25:25 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id e7so3806158pgk.2
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 11:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NdDWuHUk5WQ2SnW283fTyZTE5ZyX1tDtrPSf2xJQCac=;
        b=TZGKgDGHBMhjO4+XO2+JGGtjP/9ATjzoGvpzVMlP4Qwwuds6DVFGMmaps4am9jeenz
         ILUHXtsZL45Xrta7dH+P3u1jGCyGrhwvg8OP/VxEdr7++2c4jZmjohZwDOS9Y3ezFYK2
         l3nd6VIB+yaDtmmTjlv5Rja27+ub/zu5Y4Dt8vHL4ajH2pgWzQjoVzhHsNyrUOv5HTPX
         Ejf/b3a2cNUoOMS03yBjNFqO4MIelQAddhPT8QbJDcksrZBBimzC87rzaL9R3zXmi+XR
         OwAtejbfnUKKWhn7p53W+t7iEvMqh0yXPW00lsYjBFO+16S0UoHKzLJtQc3GYvR1gV16
         MNaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NdDWuHUk5WQ2SnW283fTyZTE5ZyX1tDtrPSf2xJQCac=;
        b=iUILNGjZrhRnHal+AUMD+Qf9l1FJXJC1D/+k9yfzmolVaAQpzo38eGT1ofdOD4TZRT
         XnoMcsQKOgqcEBJSPDr8CZq6K5hmZ+MIAoO82dnh3M9niworW/UiaYk4jqECkWw0c5Zv
         eYpF39d6K5SdcPoqb/Q5/yvhSSVIPhQNtThgkKJUbSzexFwiCUg63ojp1K/3v6wyvNQZ
         Gj1/+XBXXPvASkWkGjT7P/dhV1qwO+F2zn2zCaRgurHtB7qjByNrcaqEhVWo91C6o8HH
         MmY6hXInoCY3NFYJ3sc/y5ybyqe3kBwbCOnwb3DXMqatmLkjqcAEts7NG9hck9dKoIxN
         2rPg==
X-Gm-Message-State: AOAM532Kr7ZqGLNrAqj061JPofUh071jB+3ULvj/1bVJfjylNxaqR7Wc
        2dhYfKeZPSblx/pOiVuluK0bjbfR1BnYhoo+
X-Google-Smtp-Source: ABdhPJxkIYMlGZr7m7bycP+wliYH1+tZ/lkzujUxPT2QpZ2T5WSMHde3uU8MuA1pWFomR1JRcc8brw==
X-Received: by 2002:aa7:8e56:0:b029:3cd:c2ec:6c1c with SMTP id d22-20020aa78e560000b02903cdc2ec6c1cmr4822205pfr.80.1630002324986;
        Thu, 26 Aug 2021 11:25:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e21sm1777107pfl.188.2021.08.26.11.25.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 11:25:24 -0700 (PDT)
Message-ID: <6127dc94.1c69fb81.da3f1.3d64@mx.google.com>
Date:   Thu, 26 Aug 2021 11:25:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.280-42-gdba16fd49ec7
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 131 runs,
 4 regressions (v4.9.280-42-gdba16fd49ec7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 131 runs, 4 regressions (v4.9.280-42-gdba16fd=
49ec7)

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
el/v4.9.280-42-gdba16fd49ec7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.280-42-gdba16fd49ec7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dba16fd49ec751f4438457138a42f8caa17a1b12 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6127a67dea066d37eb8e2c78

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-4=
2-gdba16fd49ec7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-4=
2-gdba16fd49ec7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6127a67dea066d37eb8e2=
c79
        failing since 285 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6127b8b3705dacb1158e2c94

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-4=
2-gdba16fd49ec7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-4=
2-gdba16fd49ec7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6127b8b3705dacb1158e2=
c95
        failing since 285 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6127a68d5427a346798e2cb0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-4=
2-gdba16fd49ec7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-4=
2-gdba16fd49ec7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6127a68d5427a346798e2=
cb1
        failing since 285 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6127a63886795812c48e2cad

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-4=
2-gdba16fd49ec7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-4=
2-gdba16fd49ec7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6127a63886795812c48e2=
cae
        failing since 285 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
