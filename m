Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 591862D8250
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 23:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436581AbgLKWqL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 17:46:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436541AbgLKWp6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Dec 2020 17:45:58 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC1ACC0613CF
        for <stable@vger.kernel.org>; Fri, 11 Dec 2020 14:45:18 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id b5so3108935pjl.0
        for <stable@vger.kernel.org>; Fri, 11 Dec 2020 14:45:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RFN6jCUjVUtmXHgbyfd43tukuFcvDIP4b3451qiU5eA=;
        b=Cls0zk7pr8Ip6HCsN9NumYLAaz9Wqff/ZzEgWxNbzE0uCbmpOt6kjfuWITROpI4SB5
         powiajTI8PiXf9oLGSx/bcugOT4njdmQ4cvim8xtwkkPSZ3izKVGn2LSbRBOKEyKwyX8
         RtVThZ6TCNU4hHBQPOJW6ujCN89kZvwEFZp/ZYY/QfgE516O73oA8weCYZu/CslUHrg2
         Gx/MEOzIdj+g/hKX7ZDwtJ9bMxQGtgGyx+yUaAbYZ8+DC0WLO1JremsabewhLsDE1Zs9
         fgh3cT0HBsQQzu7B6I4kZlgWdi21ifeJllQahEdSX2/rgB40tvIQ6M6jTTBOc2UEc/Hb
         +dmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RFN6jCUjVUtmXHgbyfd43tukuFcvDIP4b3451qiU5eA=;
        b=n+CgouzEUwt97F2+2d2ia1EKaUt2i2HDpbP9pg0FStFls8oCUdRBrkwpBPLV45zqqR
         Z8iVovAp/aL8V4Ls8BKH3BC+o8hI1FLN+MMkwQR+vXUws7l8FAe6ahsESJkrASe5Jj7p
         hVUtZVatMpjzUbx9Am2qIVc+PJo3eJvS6uTAeoeLIUiMlwNM8XwGSfV98MiaRHE6QEj8
         zAcanlPzeFuThokXgenmgw8w+0qXgFOKfG3COXN3XHKe6slQAfQbSGpQ9oXmeTgrNb1J
         DX42YzP6xwkasmHP/DOIs7Ctyno5cgVTuBH8bkI28uT8bVZn6QgGOghxQRMJPKRkL+Wh
         Q/Kg==
X-Gm-Message-State: AOAM532Y0g/0/5N1uZZKA6FrCQimECBIJTAh1QvTCVG6uXgb1tEs5Vf6
        i7uO+H3wgsq9qnn7pH/3EqYhdqPN65OiyQ==
X-Google-Smtp-Source: ABdhPJzmBgOExdcJ7S+mTU7d/rz3qfCRCrrE6wt/h1OEeQj+BkPnhrun7CHYpygxqOVS6tUYkJTydA==
X-Received: by 2002:a17:902:ee86:b029:da:76bc:2aa4 with SMTP id a6-20020a170902ee86b02900da76bc2aa4mr13005744pld.62.1607726717831;
        Fri, 11 Dec 2020 14:45:17 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h12sm11518512pgf.49.2020.12.11.14.45.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 14:45:17 -0800 (PST)
Message-ID: <5fd3f67d.1c69fb81.b0041.5d40@mx.google.com>
Date:   Fri, 11 Dec 2020 14:45:17 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.163-4-g3bb41fbdeee2
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 135 runs,
 6 regressions (v4.19.163-4-g3bb41fbdeee2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 135 runs, 6 regressions (v4.19.163-4-g3bb41f=
bdeee2)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig=
  | 1          =

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.163-4-g3bb41fbdeee2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.163-4-g3bb41fbdeee2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3bb41fbdeee22dc2bfe0746516a040aeba38b713 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig=
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd3c57c4934e59ad8c94ccd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-4-g3bb41fbdeee2/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-panda.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-4-g3bb41fbdeee2/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-panda.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd3c57c4934e59ad8c94=
cce
        new failure (last pass: v4.19.162-40-g54ca76dc034cd) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd3c58811671d62b3c94cf0

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-4-g3bb41fbdeee2/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-4-g3bb41fbdeee2/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fd3c58811671d6=
2b3c94cf5
        failing since 1 day (last pass: v4.19.162-27-g7042181619c5, first f=
ail: v4.19.162-40-gbaa0b97cc4354)
        2 lines =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd3c1996eaa2cdc9cc94ccb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-4-g3bb41fbdeee2/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-4-g3bb41fbdeee2/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd3c1996eaa2cdc9cc94=
ccc
        failing since 27 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd3c997c3f86d9cabc94cba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-4-g3bb41fbdeee2/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-4-g3bb41fbdeee2/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd3c997c3f86d9cabc94=
cbb
        failing since 27 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd3c20d938aa09941c94ccf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-4-g3bb41fbdeee2/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-4-g3bb41fbdeee2/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd3c20d938aa09941c94=
cd0
        failing since 27 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd3c1591c3c219ccdc94cd4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-4-g3bb41fbdeee2/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-4-g3bb41fbdeee2/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd3c1591c3c219ccdc94=
cd5
        failing since 27 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =20
