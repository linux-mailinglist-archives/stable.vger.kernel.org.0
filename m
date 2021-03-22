Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9AA3441D6
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbhCVMg1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231420AbhCVMfB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 08:35:01 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95255C061574
        for <stable@vger.kernel.org>; Mon, 22 Mar 2021 05:35:00 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id s21so8374587pjq.1
        for <stable@vger.kernel.org>; Mon, 22 Mar 2021 05:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=k2AAh6wTwfrJuDlC01FKI2JfanW/Iu5P6hUqmG//aC8=;
        b=Q4vo45Rsu4fmij9Ki5uv/Q8Qmx1pKf4Ph7hOi6BmVDcuLyMkNf2G/Io6zZdjoIt+Md
         scta41XNzjpK3rFAqdt4Amyw3fRFazg+NQ0Ka8Ejz0YWdv92MoEkDJ9aJT/Qus9tYpXl
         gGKW+m7frbyIRxkZ7Nz44Z6F397Gm1X06onQHEcA9PdD5oNPyhvGyUApcG/TVzXoTZu5
         z/53x7SRUrlPJ/kiIkAY2hmEZiy+5doKziwjpXGcMg517rV0M47vaVUmpto6gkoOtPRJ
         bfgI9jT1H6Vi+2dtVdMtK/PxAETbxawAD+ey6BrleWCEncGNyicSG2sJNJkmIP8FK3Ux
         M0Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=k2AAh6wTwfrJuDlC01FKI2JfanW/Iu5P6hUqmG//aC8=;
        b=ETv0PLd33phkQE9g8m3OVvOC7jfLJzXCIOKCRQ52zH2fiJhxcE9Lgo1R7cGJc3Z6tr
         XiGbsR3/2lOMzIonbL+G8xh3kWHjTGYD3Xp43V5+C7qnO3O0zXDb0Y87ZA0nv73R3tLu
         2C9Y+kk7pP7rjPYQSoZgOPNjjhrqdhLDGxmL15vakj9+Xp5NKcfFDZqc6rOHCZ3DI0ZX
         sQu0ldle36E+9te5hv8o6NwaIePTuYGALVMuBY3eoFvJTnrnOeBBc446E34OrfYo2qTb
         DMmGfvjnnafxHZELcN6zaA6TOgcqyC/OmWMslGu8dcaQOwk6gNcYalsVivavq5/3TDQb
         EyKQ==
X-Gm-Message-State: AOAM5301E+PFhaLKdOUvinCbU5Yp/e3bstJg8LPz/ekWHwmKb4AKIuiu
        oKKI8JmwDGVu+zAuDbT/USF8HeOUrmR+OQ==
X-Google-Smtp-Source: ABdhPJw0bDvKMgqL07ne/lM71RSFTn2EP7nfOmqKJNsebD6h8ZjIticWZpqDQdvLaeHBrsFSlgrdLQ==
X-Received: by 2002:a17:90b:244:: with SMTP id fz4mr12988750pjb.137.1616416499997;
        Mon, 22 Mar 2021 05:34:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b19sm13317207pfo.7.2021.03.22.05.34.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 05:34:59 -0700 (PDT)
Message-ID: <60588ef3.1c69fb81.5252.fcb9@mx.google.com>
Date:   Mon, 22 Mar 2021 05:34:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.262-13-geb8dd9387d268
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 109 runs,
 6 regressions (v4.9.262-13-geb8dd9387d268)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 109 runs, 6 regressions (v4.9.262-13-geb8dd93=
87d268)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.262-13-geb8dd9387d268/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.262-13-geb8dd9387d268
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      eb8dd9387d2686881c3bcc9e961e0c88014e5534 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60585ae6f2d36f68efaddcb2

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.262-1=
3-geb8dd9387d268/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.262-1=
3-geb8dd9387d268/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60585ae6f2d36f6=
8efaddcb7
        new failure (last pass: v4.9.262-13-g15fefca921f6a)
        2 lines

    2021-03-22 08:52:51.025000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-03-22 08:52:51.046000+00:00  [   20.587097] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60585979c52d8adf45addcc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.262-1=
3-geb8dd9387d268/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.262-1=
3-geb8dd9387d268/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60585979c52d8adf45add=
cc7
        failing since 128 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6058597eaf5e3f79d9addcb2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.262-1=
3-geb8dd9387d268/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.262-1=
3-geb8dd9387d268/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6058597eaf5e3f79d9add=
cb3
        failing since 128 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6058599faf5e3f79d9addcca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.262-1=
3-geb8dd9387d268/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.262-1=
3-geb8dd9387d268/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6058599faf5e3f79d9add=
ccb
        failing since 128 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60588eb1c2ab61bdd3addcd5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.262-1=
3-geb8dd9387d268/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.262-1=
3-geb8dd9387d268/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60588eb1c2ab61bdd3add=
cd6
        failing since 128 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6058591622b5c518f4addd1f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.262-1=
3-geb8dd9387d268/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.262-1=
3-geb8dd9387d268/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6058591622b5c518f4add=
d20
        failing since 128 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
