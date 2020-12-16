Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDB7D2DC6AA
	for <lists+stable@lfdr.de>; Wed, 16 Dec 2020 19:41:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731586AbgLPSlV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Dec 2020 13:41:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731583AbgLPSlV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Dec 2020 13:41:21 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D307C0617A7
        for <stable@vger.kernel.org>; Wed, 16 Dec 2020 10:40:41 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id c79so17140312pfc.2
        for <stable@vger.kernel.org>; Wed, 16 Dec 2020 10:40:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fMC5AiJNiswuiK3Flnof1kiQj1pzyNarw/+m78pUMsI=;
        b=EQajX03P20M4c/SNocrDPHkaaEJEupgoWqmG2q7vEzUap/sX2fbLuUpS0bH9QXntI4
         sJutAuTfQhrJ/lk+g5667T7uorC1Aa8ODajzsWD4203m74xn3X2oW1v7uv7eVd8vpTUB
         RMGx7/72saoNeJRmeLhcFB/YJRrDsoDTHjv2/oBP/YZsfYPWkDnBh7L+YbRUTK1FxddS
         z59XmDyIFeTyCXSi20bI0DgaBSFQn7LGF4mAYtd5xEnm48cyfxBQjeEog90tjP9gtOsY
         3hcbukL0/leq0BaWA4Utb1jsqt9or5yJLVnk4tk0GqDNgcCsuG/xZB+0p9vCEnkvHLAM
         hIBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fMC5AiJNiswuiK3Flnof1kiQj1pzyNarw/+m78pUMsI=;
        b=ld7KMyiJ0VxT3ZhisoibSItNjlc95DW6l9i5u5bqNWyZDIToZwDgXMxu/ezGgayWI5
         oGWcyvbjhAs39gxKnTL8HQ4qIHq3lXVRadtHx5ONnavAaiXebfXMjPeu+fcS8bjUB0e6
         chKFjIRWTSACTfxmPnP/oa41S65BIpaoywnlaJ/J1zPsvJY25GxI56UdOpErJ9XMDqBp
         SB115QstZRkqEHuxoL6RGUBInN8lRXD7obGXVu0NKNnvoCUyKnFvINQdomF3z6KFYV47
         +30i0ja6TQbl266LZJA2qcwnotLemIku29rFGa8YmCwWPSCTOKa+Rxw9dInHx8aN1J2Z
         z0Qg==
X-Gm-Message-State: AOAM530mzo9GfdafpDLwMtGH9y9XZYj9Jm7/Qfwh4YLRAE8IOdhClDx8
        3ipkGK47ZpfvGIGy7EUk7px9xdLLnvkDoA==
X-Google-Smtp-Source: ABdhPJz9gVgyEASZK6Ndm3fzAuspGXma5ZapQHuQQbblRUQMdC98fxcrren5E6PZWTSPQumaSLfebw==
X-Received: by 2002:aa7:9af4:0:b029:19d:975a:3ef2 with SMTP id y20-20020aa79af40000b029019d975a3ef2mr2636075pfp.5.1608144040234;
        Wed, 16 Dec 2020 10:40:40 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u15sm2825423pju.7.2020.12.16.10.40.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 10:40:39 -0800 (PST)
Message-ID: <5fda54a7.1c69fb81.87213.60bf@mx.google.com>
Date:   Wed, 16 Dec 2020 10:40:39 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.212-16-g9544db5305ec
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 140 runs,
 7 regressions (v4.14.212-16-g9544db5305ec)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 140 runs, 7 regressions (v4.14.212-16-g9544d=
b5305ec)

Regressions Summary
-------------------

platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre    | gcc-8    | defconfig=
           | 1          =

meson-gxm-q200             | arm64 | lab-baylibre    | gcc-8    | defconfig=
           | 1          =

panda                      | arm   | lab-collabora   | gcc-8    | omap2plus=
_defconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-baylibre    | gcc-8    | versatile=
_defconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-cip         | gcc-8    | versatile=
_defconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-collabora   | gcc-8    | versatile=
_defconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-linaro-lkft | gcc-8    | versatile=
_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.212-16-g9544db5305ec/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.212-16-g9544db5305ec
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9544db5305eceee782ff4ad13c33ac4cbedb4447 =



Test Regressions
---------------- =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre    | gcc-8    | defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/5fda1d64a3784c6a65c94cc4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-16-g9544db5305ec/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s90=
5x-khadas-vim.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-16-g9544db5305ec/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s90=
5x-khadas-vim.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fda1d64a3784c6a65c94=
cc5
        failing since 2 days (last pass: v4.14.212-2-ga950f1bfe7736, first =
fail: v4.14.212-9-g0472cccb2d80) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
meson-gxm-q200             | arm64 | lab-baylibre    | gcc-8    | defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/5fda2d771894aa7519c94cf8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-16-g9544db5305ec/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-16-g9544db5305ec/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fda2d771894aa7519c94=
cf9
        failing since 8 days (last pass: v4.14.210-20-gc32b9f7cbda7, first =
fail: v4.14.210-20-g5ea7913395d3) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
panda                      | arm   | lab-collabora   | gcc-8    | omap2plus=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fda23158a4cdaf57ac94cf7

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-16-g9544db5305ec/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-16-g9544db5305ec/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fda23158a4cdaf=
57ac94cfc
        failing since 2 days (last pass: v4.14.212-2-ga950f1bfe7736, first =
fail: v4.14.212-9-g0472cccb2d80)
        2 lines

    2020-12-16 15:09:04.042000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-baylibre    | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fda2149f1a00cb6fec94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-16-g9544db5305ec/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-16-g9544db5305ec/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fda2149f1a00cb6fec94=
cba
        failing since 32 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-cip         | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fda2156185ef414f6c94cc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-16-g9544db5305ec/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-16-g9544db5305ec/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fda2156185ef414f6c94=
cc9
        failing since 32 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-collabora   | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fda2148de4601f7cdc94cf4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-16-g9544db5305ec/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-16-g9544db5305ec/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fda2148de4601f7cdc94=
cf5
        failing since 32 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-linaro-lkft | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fda212d22870c1540c94d0a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-16-g9544db5305ec/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-16-g9544db5305ec/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fda212d22870c1540c94=
d0b
        failing since 32 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =20
