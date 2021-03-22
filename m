Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C252134531C
	for <lists+stable@lfdr.de>; Tue, 23 Mar 2021 00:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbhCVXil (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 19:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbhCVXht (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 19:37:49 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2870C061574
        for <stable@vger.kernel.org>; Mon, 22 Mar 2021 16:37:48 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id mz6-20020a17090b3786b02900c16cb41d63so9335146pjb.2
        for <stable@vger.kernel.org>; Mon, 22 Mar 2021 16:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=oMePm5Sx2F8Bhpu2Gu2+BgpTk2jYTQtc3KSt+6wXla4=;
        b=l3zyvTx2dQr87okiWhbBTsddO7l/SAjPvP7PYX0Qn9UkWtjKKHU9Kr/O1r4lPO9JvZ
         yZI0rAAYG6RCDgbRc0DxSvmKu5tCAP+adc+yHPt7DsX7woh6whUoXuMQ9DvYZ0RFiMyP
         KidLY5+I6r8D1Eu6/06DwU8VGvXr7NKEZIK/HUX54hQ12lTa0LD7hRJftAERm4U2ul3v
         Ju/tzKfCTxYZfyqhvV3l8S2DhEWdlwAvKokpgIVYO1IK/jODQWA6QbT7drdt7lIxA0Ys
         SyIE/SbVMB3mPIaLo+WgumB9AkfHCVuKnF24dCy5UDAsdClNCVbQL7DaCt4V13HxvvQA
         gMZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=oMePm5Sx2F8Bhpu2Gu2+BgpTk2jYTQtc3KSt+6wXla4=;
        b=O4L0jV/mqBYoD7VIVSd+OwOtIozxCnAm4Py2hzKJb0gG4OjkGfNiNFUHg7YgFvnB0S
         1Aaaer6ejjgmmPdEa2y4kpW4D3R1pwPDl98V5L1G+hD48Jx53uOSs6KVVY0I7u46orUm
         /io95fce2Uz1uRF3VBH7FkFxifCEnnleW+jK2CQpjcWSteMGvVQTBB8dmoC3pZlbKedj
         fw5MZDNvTctuv1GHu4hKx39wt1CN6OKkiY8P0r75ujl9UaFFw4fOuTnCb56xyr830M4g
         ifL5lJw7vP9+1c2wfhOBxzGiaB3C9ihHnD8kI+Wt2oh9dOLyb7ecYhDOzQeHl325s0e9
         +PyQ==
X-Gm-Message-State: AOAM53275pe6oF91TYg2lDb0BWZMg9XB0dbFdYw45PI9WbT8eija5j24
        Meuh8GODqvP8BUPO8LQUrH3mxoovh4oIbQ==
X-Google-Smtp-Source: ABdhPJxexE70E1ydNASGDHiBRivxp1Q1aoy/Em9VKyTuqNt7ue15JoW1nTQC8AnrwC19QcxaCD2d1A==
X-Received: by 2002:a17:90a:fe93:: with SMTP id co19mr1477332pjb.142.1616456267816;
        Mon, 22 Mar 2021 16:37:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y24sm14264515pfn.213.2021.03.22.16.37.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 16:37:47 -0700 (PDT)
Message-ID: <60592a4b.1c69fb81.a5662.3a62@mx.google.com>
Date:   Mon, 22 Mar 2021 16:37:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.182-44-g155590e98805
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 158 runs,
 6 regressions (v4.19.182-44-g155590e98805)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 158 runs, 6 regressions (v4.19.182-44-g155=
590e98805)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.182-44-g155590e98805/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.182-44-g155590e98805
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      155590e98805144ae9800805ca98d3edcd2228de =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6058f2bac4af820122addcb2

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
82-44-g155590e98805/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
82-44-g155590e98805/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6058f2bac4af820=
122addcb7
        new failure (last pass: v4.19.182)
        2 lines

    2021-03-22 19:40:35.677000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/102
    2021-03-22 19:40:35.686000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6058f1a8ffccc03c49addcba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
82-44-g155590e98805/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
82-44-g155590e98805/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6058f1a8ffccc03c49add=
cbb
        failing since 124 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6058f1a234d47cc688addcbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
82-44-g155590e98805/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
82-44-g155590e98805/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6058f1a234d47cc688add=
cbf
        failing since 124 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6058f20624702867d4addcb2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
82-44-g155590e98805/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
82-44-g155590e98805/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6058f20624702867d4add=
cb3
        failing since 124 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6058f342bceb960ee4addd66

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
82-44-g155590e98805/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
82-44-g155590e98805/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6058f342bceb960ee4add=
d67
        failing since 124 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/605907c7c677833f47addcb4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
82-44-g155590e98805/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-=
qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
82-44-g155590e98805/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-=
qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605907c7c677833f47add=
cb5
        failing since 124 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
