Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9318A2CC0B8
	for <lists+stable@lfdr.de>; Wed,  2 Dec 2020 16:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728280AbgLBPXR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Dec 2020 10:23:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728168AbgLBPXR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Dec 2020 10:23:17 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82D2CC0613CF
        for <stable@vger.kernel.org>; Wed,  2 Dec 2020 07:22:37 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id o9so1433013pfd.10
        for <stable@vger.kernel.org>; Wed, 02 Dec 2020 07:22:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0ZLvpQt0oGruGz5TZ9dtQAE2Dx7N5tnF8bMmjCHU/gA=;
        b=UssvQPTBgBk29x7JcG9Sn0wCtSmaH1/phoJ9oc3mVvRTB+SyGaNU3P/H1sD0NhRezY
         4KRu6BFevrMAXeZipWUUntF0cjG/YcqcVJSArrnAcRzrXHmhlKSInIuN3waFtGFLK63u
         0Ufs+VPq/B0OIv++d1DiStOGGHuh69t2YES7iU9dyP/7erGvgu+ADrzHovJQWMvFr546
         OYV9dgtF9P9kKlhAkNjtNHH3WWMjPDWrOGT2l2YOt/GRFW52H46nPszYZO4xB9Fgg2+J
         C7K1boNyyfw5Lb8Tu9ZFTwdOPeah5Uw2tPmEhmDPyBwUqFFQXLtlBqQVwq9HJsaNVMPd
         9avw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0ZLvpQt0oGruGz5TZ9dtQAE2Dx7N5tnF8bMmjCHU/gA=;
        b=BTpYcA1M83mUE+dCIic8RW3lbfmLmI5N8hVa6pnZ6DhEhn3ZjM9nMSum+z24dMoypI
         Z2jZH83UI/ClwiplJWJh4X6C13DTCHcdIIOCUNxaROhxXUzR2BMjbtSpN8qPE9lfuKtr
         8KXccGi04rdwyyi77l3jJruOs4YB2szbixht9DdAbN2XOsmYNY6Bg9MDxCmT/1zgaCCB
         boX1XGtnKvrfJk/Er2TSICYyGKu1UT4ifwrcd9sUxf9AXN/IRu1qBczeWRQYiqbnxAun
         u/pIQknmU6LePDi/0zyppIAaZv/x4sjgPkLHC0IwrCHhYgZLHZ1tr+cMd3noIrGf4eJP
         wmXQ==
X-Gm-Message-State: AOAM533mu+C6XaFDG1bIyZxqe7H1oXWX5XnQthTIw+q8JyAone3A7R4P
        Pi0mNO7PZvFc1Nh1jlYyra16Fsv39BCoeQ==
X-Google-Smtp-Source: ABdhPJwc/8oCJDKG0sR4bN0PqX16tRqpAynr7DixZoa4HlbPCvhHBonhYjbP5fuitZMEeLE/UAnmcQ==
X-Received: by 2002:a05:6a00:14cd:b029:18b:fac7:d88 with SMTP id w13-20020a056a0014cdb029018bfac70d88mr3055532pfu.6.1606922556591;
        Wed, 02 Dec 2020 07:22:36 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g9sm145173pgk.73.2020.12.02.07.22.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 07:22:35 -0800 (PST)
Message-ID: <5fc7b13b.1c69fb81.fb36d.0569@mx.google.com>
Date:   Wed, 02 Dec 2020 07:22:35 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.19.161
X-Kernelci-Report-Type: test
Subject: stable/linux-4.19.y baseline: 152 runs, 5 regressions (v4.19.161)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 152 runs, 5 regressions (v4.19.161)

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


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.161/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.161
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      daefdc9eb24bfa11ab77a4b2a9c3923f1051fe0b =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc77e8eace13a1d83c94ce2

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.161/=
arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.161/=
arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fc77e8eace13a1=
d83c94ce7
        new failure (last pass: v4.19.160)
        2 lines

    2020-12-02 11:46:17.779000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc77ea932255868f6c94d08

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.161/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.161/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc77ea932255868f6c94=
d09
        failing since 13 days (last pass: v4.19.157, first fail: v4.19.158) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc77ec497ddedbbc3c94cd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.161/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.161/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc77ec497ddedbbc3c94=
cd3
        failing since 13 days (last pass: v4.19.157, first fail: v4.19.158) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc77eb697ddedbbc3c94ccd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.161/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.161/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc77eb697ddedbbc3c94=
cce
        failing since 13 days (last pass: v4.19.157, first fail: v4.19.158) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc7963dc90bcf2556c94d1c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.161/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.161/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc7963dc90bcf2556c94=
d1d
        failing since 13 days (last pass: v4.19.157, first fail: v4.19.158) =

 =20
