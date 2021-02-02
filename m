Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE69430CB76
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238051AbhBBTZg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:25:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239637AbhBBTXd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Feb 2021 14:23:33 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46032C0613D6
        for <stable@vger.kernel.org>; Tue,  2 Feb 2021 11:22:50 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id g15so3044229pjd.2
        for <stable@vger.kernel.org>; Tue, 02 Feb 2021 11:22:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Rous/CdFEkAcy50e9OYJYgXeD0DGeMbDu9R66/5euUU=;
        b=TvGulW/CH7gcjms4p4+pb+HdtMs9jeE42WGyt0e1aNbHLOwEglyABWgsgT/1qnoUSl
         +9FcIIhycDL6DrgDDpw7YVLYm/7Oe5c1VQu7zU1N2vFE9eQJimeBw3YxvMFGyls4JKN+
         GKjThAK1OtKqDxtWADzoIisHB7jnK9YCLeAG2YqBMRoBRiTgJtDXEt2xOpb4dD8fEPsH
         ywSlvYEwl2cpoHTxIoGqOpInNNgnmOhUndAoS2b+bu/6Kj0gwRYUTP/UupWWmCh9iTpJ
         zf22qbQr6Uyuwm1YaJHj6FGUcY+ePKHizaup50TX73wKY3IG6W+jla7ACYOBFDkvDwce
         RciA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Rous/CdFEkAcy50e9OYJYgXeD0DGeMbDu9R66/5euUU=;
        b=EdRF4jMiG/Dkh+vO9J/fv5f7QAI52wzm4l/fqrYYMtwQF5zmQ5a9PYldAZPUtqs7i1
         MuijFfDx90KZRrpIJVjbHyU0OPGLx5x6ctE1l5w8fYxD2n7jZ5y8/Kjzcm12Kg6f/DLr
         9q0NLD6U7iF63iT5Pc4wMiHWyBaUwEnk8jwqFLEV+KXkrara0cwYmYsAIon02Q73QDHU
         mRUzNdEsI8VBYr8+xzSfOB6T2yxCbaWoXHL1t3QFWACVSBwuDhck2Xms99Hx0Xce0TbL
         /DEAF5IGxGUnJiiOXeXVyHJCyt/0IAwc9AWDxzWDb6xsaHx1UJXXUn+2qbVv4i7Kh4ny
         NHOA==
X-Gm-Message-State: AOAM530mCB4WrnFigd/nItzjfSTH/A9uA3DsDg/wedva0eswWU5s8Nwf
        7GxFinCsJs7dtvtRwFpglke05hIPG2uREQ==
X-Google-Smtp-Source: ABdhPJzmjXxq51kqa+ncdol6FPZhL4Vfw9Yxwpn8nMJ6h0XPHHwv+u7c/Qicb9g+oYt83QfBmJZh0Q==
X-Received: by 2002:a17:90b:4acc:: with SMTP id mh12mr5858968pjb.10.1612293769541;
        Tue, 02 Feb 2021 11:22:49 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v19sm3464302pjh.37.2021.02.02.11.22.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 11:22:48 -0800 (PST)
Message-ID: <6019a688.1c69fb81.c62a1.7efc@mx.google.com>
Date:   Tue, 02 Feb 2021 11:22:48 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.254-33-g70e4b0214c40
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 92 runs,
 5 regressions (v4.9.254-33-g70e4b0214c40)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 92 runs, 5 regressions (v4.9.254-33-g70e4b0=
214c40)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.254-33-g70e4b0214c40/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.254-33-g70e4b0214c40
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      70e4b0214c4095d6102b69f30858cfb31d36e1c2 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60196d4bdf7f1250253abe9c

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.254=
-33-g70e4b0214c40/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.254=
-33-g70e4b0214c40/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60196d4bdf7f125=
0253abea3
        failing since 3 days (last pass: v4.9.253, first fail: v4.9.253-31-=
g1aa322729224b)
        2 lines

    2021-02-02 15:18:25.137000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60196d4ddf7f1250253abea5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.254=
-33-g70e4b0214c40/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.254=
-33-g70e4b0214c40/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60196d4ddf7f1250253ab=
ea6
        failing since 80 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60196d6ce9cc0e95b23abe89

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.254=
-33-g70e4b0214c40/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.254=
-33-g70e4b0214c40/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60196d6ce9cc0e95b23ab=
e8a
        failing since 80 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60196d5e383b78a4ab3abe7d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.254=
-33-g70e4b0214c40/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.254=
-33-g70e4b0214c40/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60196d5e383b78a4ab3ab=
e7e
        failing since 80 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60196d0f7b2c1154a53abe80

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.254=
-33-g70e4b0214c40/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.254=
-33-g70e4b0214c40/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60196d0f7b2c1154a53ab=
e81
        failing since 80 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-26-g7b603f689c1c) =

 =20
