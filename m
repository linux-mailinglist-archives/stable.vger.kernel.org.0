Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 179323110DF
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 20:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233385AbhBERc7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 12:32:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233634AbhBERcE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 12:32:04 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C99DC06174A
        for <stable@vger.kernel.org>; Fri,  5 Feb 2021 11:13:47 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id d2so4360671pjs.4
        for <stable@vger.kernel.org>; Fri, 05 Feb 2021 11:13:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HwhwI2Crb0T21uobm+9DbgR4iscA46ihZvTHx/eI4JM=;
        b=DSocqOIsTxHZm1xQfJ25avg5r1NvzEwx7IU6MFuCw91hhQwOf0PFIevdWFTNceAVub
         USODxo3scpmQnbo76tmSYGlxZsG5rYNmD7YxqaeC8RoU2IL6e8JbSCNYyw4SqdPWr6uf
         jFNpGSZe3zRbm0lo3ggdy8j1Vb5ZbjtwK4y35P4mcupuk5RrGFDIjTM03Rnljkb1NfEX
         unrNqRvA6pjFv9L/1IrwBALjmCcZAU9VYbNF/fxWHEcIRrAV2buuM8Q2GD0tF/sjl7Jz
         2wSIIsW7NstO0Mdp1EjaYZirfBh5HYa5VDYBBtvbUSEKTjrJMlGWDFKz+TCoLy4MKYUS
         vv4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HwhwI2Crb0T21uobm+9DbgR4iscA46ihZvTHx/eI4JM=;
        b=KfN8PvKPUHekfIQH3dynkfWRQ3yXd3dIjq/EPvybQF8f0M6svhOxDr7yddzlBs9+pm
         s7IwaL+XG+w6ffzFgwa9IsNCikgMj6Gnogh7yZGvXmpd57nYJRwymR7U71FRJoh/C5Xe
         Y2ckEt2NfUm8Oo6+JqteYqfuZGrrWQshyRY4t9KalYdeuXzKUTxap5IOvth0V4HEBtEj
         S9r+7s4fgYSHsSvUHDYX2pbkKlLJp6Zlezh42hbB9RMJhISoUJQ2U0jRgymb7DBvs1w3
         +3TofmMHuQHC7ADe/EisuDFSvpHvTXYQ1lzkCJuOn6T4kLy0fYPSEzLOObGiq02l5Ixg
         6Y1Q==
X-Gm-Message-State: AOAM532cV++Dg6IsWxgzx+9BB8wZ+2LLNnjw/AV9euY5fa/bTVjMFx7P
        EQlgVP8+ynTa6euHnetnoA23iUY150kULg==
X-Google-Smtp-Source: ABdhPJzqV8bMw3eUIjFUwPc2OcXL6WgeEH6WAetggaNrw2LYiuUNXFzSDnqJh+sG4v3OcFiJWbjOHA==
X-Received: by 2002:a17:90b:70b:: with SMTP id s11mr5651090pjz.20.1612552426501;
        Fri, 05 Feb 2021 11:13:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q2sm10072603pfj.32.2021.02.05.11.13.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 11:13:45 -0800 (PST)
Message-ID: <601d98e9.1c69fb81.95104.5b6b@mx.google.com>
Date:   Fri, 05 Feb 2021 11:13:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.95-32-g4af9560d1c93f
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 155 runs,
 4 regressions (v5.4.95-32-g4af9560d1c93f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 155 runs, 4 regressions (v5.4.95-32-g4af9560d=
1c93f)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.95-32-g4af9560d1c93f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.95-32-g4af9560d1c93f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4af9560d1c93f09fbe656619656d8d99aba9a267 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d64b68d1044d6133abe7a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.95-32=
-g4af9560d1c93f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.95-32=
-g4af9560d1c93f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d64b68d1044d6133ab=
e7b
        failing since 83 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d6569a232dfe0cc3abe6a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.95-32=
-g4af9560d1c93f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.95-32=
-g4af9560d1c93f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d6569a232dfe0cc3ab=
e6b
        failing since 83 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d64bea9527230993abe76

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.95-32=
-g4af9560d1c93f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.95-32=
-g4af9560d1c93f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d64bea9527230993ab=
e77
        failing since 83 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d646bc0a7f91c5a3abe6b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.95-32=
-g4af9560d1c93f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.95-32=
-g4af9560d1c93f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d646bc0a7f91c5a3ab=
e6c
        failing since 83 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =20
