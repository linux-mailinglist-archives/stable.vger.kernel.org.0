Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 194AC3F8A15
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 16:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242755AbhHZO2l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 10:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231479AbhHZO2k (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Aug 2021 10:28:40 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48B8BC061757
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 07:27:53 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id s11so3197296pgr.11
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 07:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5fNVVZWK7FnZSeKFr0Cbhf0xA1oDMvzyqNJPSBPKOKY=;
        b=1pPIbWMEbCGdMAiLoDNwYhSUsDbXyexTsNOO9WzP4/oNskEn2+rD/GJOrovJN1gXAV
         aZgNun4lzwUGn16I3uY+lFCT7oaI6sh5DPmcawv907LrT1YuJGeo9UdDAPtrm7/1YZpT
         0YMAigbXdG+7mgV5PEosXaGe+zKKqhRjtyFIMhVYqB66WgxZghbRdXH3Uj1/bzRbz+HT
         gv3VkgOxL45cOP+HbTaRkAJzz74QjIieUYaSntpN+h6G/kS+BIC6unfPMRLNxtGFHQCf
         J3eQxhCwO5Yw58iDLfF9Fjvji8skEZha/wy2wcXytzhfqpt7TWbNNWoxsOn4DeB2ZJRJ
         otMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5fNVVZWK7FnZSeKFr0Cbhf0xA1oDMvzyqNJPSBPKOKY=;
        b=MzpRtQc8UQyvTLW4OVQZSFiAjaKjtB75a7QPr+VN5qByQeNopSRcLNgSfEX2u2Nvn4
         Y0rbnVtfxm72kfs0KQ7+p+/nMCGvNT9ETMkllpgESMXsRNqcd6IgzbdRjtsWaaAA/mYG
         SU5cvz4ZrJj2BLUR1vQs1tJ8Jvfl8S36WyMTyYafT8PzuuaAyWS5uivfC8qMx12bLrds
         gunc8d0Dg1ni+Frk7DoNWCgqytJ65vKaUu30LRhNJ47Lw7ahCgDxMHmalGvyX4K+1MZl
         E0fSD7b88cFrYjOZxZJwr5GXuEFsLf5F529ldk47hyqqaAp/ZTOWslnkA2FQhY3jUOcw
         oWQw==
X-Gm-Message-State: AOAM533Cza9SgZERmZjovJTihSeHjs3MkzgqUg/8HU6Bfb80mwBZgQpy
        e4xoWJSJaeQg8UoCg4iLmBKXIg0PcbLa5GZL
X-Google-Smtp-Source: ABdhPJy3b5fyFEFiNxO0hUaR3fzA+1Hct8v+mPVGNmoZ5ZCYhDoYb035fQEY9o9SrZHpaAs4iryYKA==
X-Received: by 2002:a05:6a00:1746:b0:3eb:1577:bf9b with SMTP id j6-20020a056a00174600b003eb1577bf9bmr4070081pfc.27.1629988072506;
        Thu, 26 Aug 2021 07:27:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a26sm3933066pgm.87.2021.08.26.07.27.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 07:27:52 -0700 (PDT)
Message-ID: <6127a4e8.1c69fb81.80d5d.ab57@mx.google.com>
Date:   Thu, 26 Aug 2021 07:27:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.280-42-g3dd67d2de8b8
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 158 runs,
 5 regressions (v4.9.280-42-g3dd67d2de8b8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 158 runs, 5 regressions (v4.9.280-42-g3dd67d2=
de8b8)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.280-42-g3dd67d2de8b8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.280-42-g3dd67d2de8b8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3dd67d2de8b8e3c38d5f32f6bf9015720452e83c =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61277100a75b1ac8e18e2c95

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-4=
2-g3dd67d2de8b8/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-4=
2-g3dd67d2de8b8/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61277100a75b1ac8e18e2=
c96
        failing since 285 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/612777f52e256106168e2c8a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-4=
2-g3dd67d2de8b8/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-4=
2-g3dd67d2de8b8/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612777f52e256106168e2=
c8b
        failing since 285 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6127706048f4263d618e2c78

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-4=
2-g3dd67d2de8b8/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-4=
2-g3dd67d2de8b8/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6127706048f4263d618e2=
c79
        failing since 285 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61277414e12561c07f8e2cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-4=
2-g3dd67d2de8b8/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-4=
2-g3dd67d2de8b8/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61277414e12561c07f8e2=
cba
        failing since 285 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/612779a731fc80f9f18e2c7e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-4=
2-g3dd67d2de8b8/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-4=
2-g3dd67d2de8b8/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612779a731fc80f9f18e2=
c7f
        failing since 285 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
