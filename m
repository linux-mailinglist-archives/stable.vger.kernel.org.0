Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED7E2309F2E
	for <lists+stable@lfdr.de>; Sun, 31 Jan 2021 23:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbhAaWEs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Jan 2021 17:04:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbhAaWAW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 Jan 2021 17:00:22 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29C6EC06174A
        for <stable@vger.kernel.org>; Sun, 31 Jan 2021 13:59:41 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id o20so10311062pfu.0
        for <stable@vger.kernel.org>; Sun, 31 Jan 2021 13:59:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VNRZs19CtvTH5VopUkP9ChMXsSuS45c9cpIQ2I+5olM=;
        b=IvI3IMGxlefThuPIePNoR+0N2OzJ20TmaJYL/oJgduQ+P1kmri46lzGmRdQVwqO2AG
         mlGRNV/xF7nmPjnFz3VNMtGvNFUKx+iSjFcgU3V6vqRxU6ZgvEwAyrHEOFLEgz/2x4Nd
         LYnAgZxWVLlTyEPbaUe699MW8RnD7809OPEAMoCeMyLbFFJMqjwhmS+o25kM6RmS51FM
         n+GaiqaBWl1UYnDH1zj4rikmOUNPG9MNApY0H6nDys2HE/S+Nru/Tv8/XGx0GfT/kJa7
         yigUSHmD23t0b2l3sV1nfBG/mV5QuN1+JmQwBhQOPShwxCb2pEMIlyxaKHgGo4XdlBPd
         FheA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VNRZs19CtvTH5VopUkP9ChMXsSuS45c9cpIQ2I+5olM=;
        b=CdCCffZKeiBYm10T435zl5Bm9pVd0D/zvh/wD1cuth355r/qoTVwnBL+5t60MXQ/70
         sa2lwe07FE0DToh0ogiLyFwnu0jGkUhcZcAl0idmV8Wye4e7C102F6funXOSSOL4TzT1
         VvqMx7Yr+m0+lvObTctV6agHSYTDGV9kBV2z7of9Vxs8g0A1iBC9i9iVEMMLj+T2hmZs
         PwayblZ32fvnsD6vQLQbFjGN5EV3Doxq46TBbUFm52tEP4kbDP6qgCpXVjXfrp9Fb6SE
         TShZWHx60J9LyJBGrmnVNppBlnTbAbnL8xtvCWiJ1KEStjA2pCCSU2xsiQAUS/m6cNqC
         XTuw==
X-Gm-Message-State: AOAM532UZHG6wVAykJ26a1VISLdYZSIIWMpWliZXsTufRljeKPe3OCrj
        NeJTYAqd8E6snVMQP4gEjKUSZjQYCBOVkQ==
X-Google-Smtp-Source: ABdhPJzG1UzIX510UKKImJZTEnXfzNgW0uziia09k4YOmqGPsHgfPHi4dmF/lNqtovx1YV8xwAqcAA==
X-Received: by 2002:a63:1865:: with SMTP id 37mr14015288pgy.206.1612130380347;
        Sun, 31 Jan 2021 13:59:40 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v8sm15015633pfn.114.2021.01.31.13.59.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Jan 2021 13:59:39 -0800 (PST)
Message-ID: <6017284b.1c69fb81.9da8c.5408@mx.google.com>
Date:   Sun, 31 Jan 2021 13:59:39 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.254-3-g3946bf8b16e7
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 121 runs,
 5 regressions (v4.9.254-3-g3946bf8b16e7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 121 runs, 5 regressions (v4.9.254-3-g3946bf8b=
16e7)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.254-3-g3946bf8b16e7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.254-3-g3946bf8b16e7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3946bf8b16e7233e072d8094983633f1031feb93 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6016f588ebf3a04331d3dfcb

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.254-3=
-g3946bf8b16e7/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.254-3=
-g3946bf8b16e7/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6016f588ebf3a04=
331d3dfd0
        failing since 0 day (last pass: v4.9.253-30-g6cb2db3a6d706, first f=
ail: v4.9.254-3-g1ef1a4ed104f)
        2 lines

    2021-01-31 18:23:00.882000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6016f511b59d26fac1d3dfc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.254-3=
-g3946bf8b16e7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.254-3=
-g3946bf8b16e7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6016f511b59d26fac1d3d=
fca
        failing since 78 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6016f520b59d26fac1d3dfd5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.254-3=
-g3946bf8b16e7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.254-3=
-g3946bf8b16e7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6016f520b59d26fac1d3d=
fd6
        failing since 78 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6016f517b59d26fac1d3dfcc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.254-3=
-g3946bf8b16e7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.254-3=
-g3946bf8b16e7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6016f517b59d26fac1d3d=
fcd
        failing since 78 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6016f4c8233a1e0fdbd3dfe8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.254-3=
-g3946bf8b16e7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.254-3=
-g3946bf8b16e7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6016f4c8233a1e0fdbd3d=
fe9
        failing since 78 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =20
