Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74D802DF0C2
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 18:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725837AbgLSRu5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 12:50:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725562AbgLSRu5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Dec 2020 12:50:57 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9105C0613CF
        for <stable@vger.kernel.org>; Sat, 19 Dec 2020 09:50:16 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id g18so3439201pgk.1
        for <stable@vger.kernel.org>; Sat, 19 Dec 2020 09:50:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=s0lzyhuWg45Mp68fjPFUrBJToVVXABO8iVdq2CbH6l8=;
        b=prsNoh/kEvwpgS/ZiPqNpB4x+Rd7Q+5pvo6VWdfzhwsk9UNKeGgrLsYnRcq+ozAnld
         T0qSiCve0/sqEspgX4mJrpqhVKQnAr9SPQfZ6EVlcvk1jWXtAdAEjZZQM5uokR2uryAq
         nKModnzjuig8SoXJiXKLhJO8xjIl0tVC0WHsNu+KeJQMYa7HgHlwR2GjxYn5ORmXvS3A
         tZSKjIAYQ1em2i6bDJ3DdDVYtPLHa+S6ij6MoGk/UCz7x1zgjGBbpqOEdIOygwaBUZuV
         Nlb/7byeE6dO1SAGsFzompK4/m78N/uAGUZW2q+1hli3s7W/QlF3kRfSDzuheHO87lNK
         DURQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=s0lzyhuWg45Mp68fjPFUrBJToVVXABO8iVdq2CbH6l8=;
        b=mrzUcNat9FE1f9gZMMNxD1TwiEfsB7vm1i67KahiOYqD303dVPOGHBvPmduxP09hwG
         ZmObic6ItX28alV1v1XI9Ozk3WbQREspFk3dae6KRyerJBpoEb/yIjIhELg2VNojiR+w
         /Wv1/z/SGRNFOAGAgmNE+kf9Z1L/6piWb1nT9h+3Tqf81Exxceo4aOBCC9+VaRAnHLVV
         V6IVTYxfO0Y/JtGDufr3aRDROoyUG8NHLs+DUH3y0kh8kcocxO6xrvVidTbH2GvcS8TP
         zpLljMFE+9woZ7KstXCgF7VU6AeG7OPesJofOZ3c396ZcFemzWFYq0eVBihPHPYU/Hlu
         KwhQ==
X-Gm-Message-State: AOAM532F+mvb34pY7XN8rGvD9oZiyPAgbvmVxj/p1zWy3RysFGp+etWI
        XQy9/mFUQ2ZJF9/3Agq+H68BVs5QrfDqcQ==
X-Google-Smtp-Source: ABdhPJwqfrMAZkSo5OfvR9Mj6AvHsXGP1F75C3jGw0CRjzU5kZUPv5Ly8fXIrDa+iQf2h74RZ4SiCA==
X-Received: by 2002:a62:3582:0:b029:19e:4935:bea2 with SMTP id c124-20020a6235820000b029019e4935bea2mr9152852pfa.34.1608400215911;
        Sat, 19 Dec 2020 09:50:15 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l190sm11984142pfl.205.2020.12.19.09.50.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Dec 2020 09:50:15 -0800 (PST)
Message-ID: <5fde3d57.1c69fb81.2ea4e.09eb@mx.google.com>
Date:   Sat, 19 Dec 2020 09:50:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.163-54-gea2d5223aced
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 130 runs,
 4 regressions (v4.19.163-54-gea2d5223aced)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 130 runs, 4 regressions (v4.19.163-54-gea2d5=
223aced)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre  | gcc-8    | defconfig  =
         | 1          =

qemu_arm-versatilepb       | arm   | lab-baylibre  | gcc-8    | versatile_d=
efconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-cip       | gcc-8    | versatile_d=
efconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-collabora | gcc-8    | versatile_d=
efconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.163-54-gea2d5223aced/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.163-54-gea2d5223aced
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ea2d5223aced93da8408b19be2742e58931f9b1b =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre  | gcc-8    | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/5fde058d3edccd0ffec94cc4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-54-gea2d5223aced/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s90=
5x-khadas-vim.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-54-gea2d5223aced/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s90=
5x-khadas-vim.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fde058d3edccd0ffec94=
cc5
        new failure (last pass: v4.19.163-47-g20080454fdbb) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm-versatilepb       | arm   | lab-baylibre  | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fde091a4375a29542c94cc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-54-gea2d5223aced/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-54-gea2d5223aced/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fde091a4375a29542c94=
cc7
        failing since 35 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm-versatilepb       | arm   | lab-cip       | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fde092677e7f5037dc94cc7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-54-gea2d5223aced/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-54-gea2d5223aced/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fde092677e7f5037dc94=
cc8
        failing since 35 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm-versatilepb       | arm   | lab-collabora | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fde08e52f233fb59bc94cdb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-54-gea2d5223aced/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-54-gea2d5223aced/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fde08e52f233fb59bc94=
cdc
        failing since 35 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =20
