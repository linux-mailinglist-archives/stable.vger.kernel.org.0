Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8243AD799
	for <lists+stable@lfdr.de>; Sat, 19 Jun 2021 05:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbhFSD6k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 23:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbhFSD6j (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Jun 2021 23:58:39 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D71C061574
        for <stable@vger.kernel.org>; Fri, 18 Jun 2021 20:56:29 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id 69so5686650plc.5
        for <stable@vger.kernel.org>; Fri, 18 Jun 2021 20:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0eM5fqw+wxy/TnX2NxemLftJYYI1XmmE8lia1BhLG6A=;
        b=rHTFQz8pSzTaWizbeMnWIRaZun2ZkFjRjPRVLmgB5p1gGZOW8aZC+7YxRx1782YRkQ
         UsuaQtTXM6/0dPbiMmCJJUrG8+3OJ+2VYoNjaLm8iHD266KtKlgvvwE7QkXFugTRAwFc
         20f5q0KOZI4PaTTSk2W/YPxN+AtRhrn3Z2+8ySuK5rGnqU5L1SavCEcll8Qowvy6Kcct
         N1jb/hy63ywljXmlO9YFeE+d253Se/xSxySsWHiqneQPQmSbzuFRZNhxYXbb21G5Er2Z
         lXnVFrE+K/Ra1nj5gx1qrZE4qCOPpH3XngWc2lcOHLYqQIZUcvK471mLToNa6bfQnpCv
         6nlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0eM5fqw+wxy/TnX2NxemLftJYYI1XmmE8lia1BhLG6A=;
        b=tsgcUGIwAWnbvzeEhTyImRcvm3PRA+ULhmIBTUO9qtI5t3INaP/TTxvw54PYOv2T5+
         REtTNYv8U1/SNOAEKc828ZrheSrKNm8SH2Zc2CED9uTfFSFVPbpuumMuVVpUuGShUgdX
         Ca2zsB602qIjhf8O8UwALhO47vf1M14nQe69DZIP3vX+i/3NNcSEc7bpFSo8+epHdnkg
         7Y08WadLTNetkyP+4jVnOfcUxj2l72wJQBvFjBcxe2iJVL/nQiRPmdb3wJt/n6sQiy/h
         pbw4XwUPS4GV1LYk/vq1ghkBW2UfCwukz4ADz06QaWRcLIApK9hYnIX7VVbX/TfXYIP9
         +pgg==
X-Gm-Message-State: AOAM532YplEyEGyx/tSNUmMIHpjYjztOgQwIVnVoq+3t6rBMb+b7/Red
        Nl0OtPEX/h+j0aRjYlNi5DR7XNf9MFqqiFcs
X-Google-Smtp-Source: ABdhPJyA/TRpDiTqIzxzBKG8jG3gxBcMae1Wlrv1kZJlTT186Xn3+zsKE5AAkerN4PFmJ+GvmANNEw==
X-Received: by 2002:a17:90a:d18f:: with SMTP id fu15mr14291383pjb.78.1624074989010;
        Fri, 18 Jun 2021 20:56:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y8sm4061928pfe.162.2021.06.18.20.56.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 20:56:28 -0700 (PDT)
Message-ID: <60cd6aec.1c69fb81.36ec6.c73c@mx.google.com>
Date:   Fri, 18 Jun 2021 20:56:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.273-19-g7f8d14ca3655
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 130 runs,
 7 regressions (v4.9.273-19-g7f8d14ca3655)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 130 runs, 7 regressions (v4.9.273-19-g7f8d14c=
a3655)

Regressions Summary
-------------------

platform             | arch   | lab             | compiler | defconfig     =
               | regressions
---------------------+--------+-----------------+----------+---------------=
---------------+------------
qemu_arm-versatilepb | arm    | lab-baylibre    | gcc-8    | versatile_defc=
onfig          | 1          =

qemu_arm-versatilepb | arm    | lab-broonie     | gcc-8    | versatile_defc=
onfig          | 1          =

qemu_arm-versatilepb | arm    | lab-cip         | gcc-8    | versatile_defc=
onfig          | 1          =

qemu_arm-versatilepb | arm    | lab-collabora   | gcc-8    | versatile_defc=
onfig          | 1          =

qemu_arm-versatilepb | arm    | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig          | 1          =

qemu_x86_64          | x86_64 | lab-broonie     | gcc-8    | x86_64_defcon.=
..6-chromebook | 1          =

qemu_x86_64-uefi     | x86_64 | lab-broonie     | gcc-8    | x86_64_defcon.=
..6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.273-19-g7f8d14ca3655/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.273-19-g7f8d14ca3655
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7f8d14ca3655c7c8e7915030d1a1f26ad773c00b =



Test Regressions
---------------- =



platform             | arch   | lab             | compiler | defconfig     =
               | regressions
---------------------+--------+-----------------+----------+---------------=
---------------+------------
qemu_arm-versatilepb | arm    | lab-baylibre    | gcc-8    | versatile_defc=
onfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/60cd3323397227fc51413275

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-1=
9-g7f8d14ca3655/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-1=
9-g7f8d14ca3655/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60cd3323397227fc51413=
276
        failing since 217 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab             | compiler | defconfig     =
               | regressions
---------------------+--------+-----------------+----------+---------------=
---------------+------------
qemu_arm-versatilepb | arm    | lab-broonie     | gcc-8    | versatile_defc=
onfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/60cd33b4c471c3fa6e413298

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-1=
9-g7f8d14ca3655/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-1=
9-g7f8d14ca3655/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60cd33b4c471c3fa6e413=
299
        failing since 217 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab             | compiler | defconfig     =
               | regressions
---------------------+--------+-----------------+----------+---------------=
---------------+------------
qemu_arm-versatilepb | arm    | lab-cip         | gcc-8    | versatile_defc=
onfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/60cd330a278ca8daf6413282

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-1=
9-g7f8d14ca3655/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-1=
9-g7f8d14ca3655/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60cd330a278ca8daf6413=
283
        failing since 217 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab             | compiler | defconfig     =
               | regressions
---------------------+--------+-----------------+----------+---------------=
---------------+------------
qemu_arm-versatilepb | arm    | lab-collabora   | gcc-8    | versatile_defc=
onfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/60cd4e9fe7d064564a413266

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-1=
9-g7f8d14ca3655/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-1=
9-g7f8d14ca3655/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60cd4e9fe7d064564a413=
267
        failing since 217 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab             | compiler | defconfig     =
               | regressions
---------------------+--------+-----------------+----------+---------------=
---------------+------------
qemu_arm-versatilepb | arm    | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/60cd326a4d834808cf41327b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-1=
9-g7f8d14ca3655/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-1=
9-g7f8d14ca3655/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60cd326a4d834808cf413=
27c
        failing since 217 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab             | compiler | defconfig     =
               | regressions
---------------------+--------+-----------------+----------+---------------=
---------------+------------
qemu_x86_64          | x86_64 | lab-broonie     | gcc-8    | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/60cd32245127356dba413266

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-1=
9-g7f8d14ca3655/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/ba=
seline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-1=
9-g7f8d14ca3655/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/ba=
seline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60cd32245127356dba413=
267
        new failure (last pass: v4.9.273-19-gafb7b9c97ade) =

 =



platform             | arch   | lab             | compiler | defconfig     =
               | regressions
---------------------+--------+-----------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi     | x86_64 | lab-broonie     | gcc-8    | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/60cd31d417ef3f46dd41326e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-1=
9-g7f8d14ca3655/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/ba=
seline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-1=
9-g7f8d14ca3655/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/ba=
seline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60cd31d417ef3f46dd413=
26f
        new failure (last pass: v4.9.273-19-gafb7b9c97ade) =

 =20
