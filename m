Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8165B3B39ED
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 02:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbhFYAJs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Jun 2021 20:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbhFYAJs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Jun 2021 20:09:48 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA966C061574
        for <stable@vger.kernel.org>; Thu, 24 Jun 2021 17:07:28 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id k6so6576718pfk.12
        for <stable@vger.kernel.org>; Thu, 24 Jun 2021 17:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zqQtEIyFGWpOS9eqUIaD30NIl2KwewOBU3dX+ViwhyM=;
        b=eAGCyPn0lJlUmq0D4qzoGhwEnuyVPae8GCWeJITyTItyqE5eoUS29WdnT1FkQRTQ71
         m4HS3qcoQYmnsY/VT/q9Vpz6VCdREtu1A1KSAYd0RiIwhRJRUDwrGTVP9uTEfTr8woyj
         o9H9v43Ix33UtmjnnyZEXZoJFgGIqK6wUuDsxHYpRSbACZ8EaXcQ7iVUgFTQds/iJDhX
         80+NgWtoYEHayfP56OumiciJoaOD2CwBK9OYkvX02R14w4a7BoJP+gt2fKIxLD3VFky3
         jrFnyosYpMPyRsRjM0YC3QTZgWOPhTT+mSC0Rul3ZoJKAVXg5RMC3V1T9/mR6DyV1NaW
         O17Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zqQtEIyFGWpOS9eqUIaD30NIl2KwewOBU3dX+ViwhyM=;
        b=CdydnzU5xBhp4587yVskMEiTFgQs0jkrUyvsLwH/ymQ11XMmE9/gxNuwdJf9xjOyNN
         9a8fmOr3mA/fowhOeXnfll+KF1r4w2mVplzkxINTpbuQtzKS0fvCLDbttKyT4Ld4Oa6r
         YZAaJn6f4zLDdHX+/BSx15inWinNjKfpO61s7gsmuamroe/ED85LDH1vanfsko5RY7lf
         5Hi+RORzxwC4gipL+/bFqGU9dILB27WXEzDIR6d67mWdfbRH6hkyweIwLgfbuaWeGkJ2
         2+RejhFEbprp63Tjr0N1ydb2Y1s/N9j6EsBxdmDXPFA6d8bJkDud8YBFTU94of4hbkyO
         UzeQ==
X-Gm-Message-State: AOAM531qtxIASYDCdh+kGtKkoBhfYSLjUAAEGCCW6WjKQsawwdoHZn3r
        coZsifbS/sCmhI3sYiG+FRUiU5+FSYxnltpM
X-Google-Smtp-Source: ABdhPJzOGcK7I9fHc6Ki1oSaYck4obLCWSrjE5wR5SdZ7gGc3a0O27z0wvS9s7QSuuuBSnv58BsBNQ==
X-Received: by 2002:a63:7985:: with SMTP id u127mr7017987pgc.228.1624579648200;
        Thu, 24 Jun 2021 17:07:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y29sm4301663pff.161.2021.06.24.17.07.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 17:07:27 -0700 (PDT)
Message-ID: <60d51e3f.1c69fb81.5914b.c8f8@mx.google.com>
Date:   Thu, 24 Jun 2021 17:07:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.273-51-gf4e2de1eb097
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 96 runs,
 4 regressions (v4.9.273-51-gf4e2de1eb097)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 96 runs, 4 regressions (v4.9.273-51-gf4e2de1e=
b097)

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

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.273-51-gf4e2de1eb097/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.273-51-gf4e2de1eb097
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f4e2de1eb0970fe1db3f775b0929b0f438c84f13 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60d4e26c60edc2df2941328a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-5=
1-gf4e2de1eb097/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-5=
1-gf4e2de1eb097/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d4e26c60edc2df29413=
28b
        failing since 222 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60d4e860482d66f931413269

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-5=
1-gf4e2de1eb097/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-5=
1-gf4e2de1eb097/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d4e860482d66f931413=
26a
        failing since 222 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60d4e267e7d7a460de413267

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-5=
1-gf4e2de1eb097/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-5=
1-gf4e2de1eb097/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d4e267e7d7a460de413=
268
        failing since 222 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60d4e3d97455404495413266

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-5=
1-gf4e2de1eb097/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-5=
1-gf4e2de1eb097/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d4e3d97455404495413=
267
        failing since 222 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
