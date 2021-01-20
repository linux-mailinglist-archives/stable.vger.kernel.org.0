Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27CA22FD936
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 20:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388228AbhATTLr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jan 2021 14:11:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728784AbhATS5e (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jan 2021 13:57:34 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C7BC061575
        for <stable@vger.kernel.org>; Wed, 20 Jan 2021 10:56:54 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id y205so9247500pfc.5
        for <stable@vger.kernel.org>; Wed, 20 Jan 2021 10:56:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=l00KjB3tsE8p/ygqA6j/qZTlXqU+V/1iax0G/C8cgeA=;
        b=Ih81XsAdVS8gBfsncZgErqGBcZiydWZFfxoYpO7WnLLka1xwVML2DyooBVMsQpQ32A
         U//q9tvjOht0vLClIJo3D9T8SIh3L95Etq/T6tugNsJTO+y8LUH0eSI7tzjOoh1hgbEt
         6ZP3NSCfdqkrJ+ABdLNzFPiiK5UWu/urxCD83SZHEoXMqhugkUqRsl+V7D6EykkGro+S
         sKK1RrjDtDprvdXnHSVzkVqaKPbubgjBM3rdIJWL99EAi5vaBovwEEMFKNBlD0A2/UqD
         rYDtRC6eJWegPkMMx6koFPpRqvCjud2b0l/3XqhnSU+RTPCExsNcStvqtNm3m3Qfc92T
         av1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=l00KjB3tsE8p/ygqA6j/qZTlXqU+V/1iax0G/C8cgeA=;
        b=ni1WNZL6a+qLPbg1g0HYiQ9LttNNAVytZjbcQltrZIBzdWMf7PWO7tZhyViAZ6omOM
         EMR42VhLXrd6OwiFt1IMXowwPUYfpuVB/0xYIC0xiEshuC5OdK9+cC5SLQgWR3cO5TJ7
         36H48wkXt1M7b92k/AWKjER+wNbPnB86B+XUh+wAdi99tbuM/AslA/+kg3uNXr6tHY4l
         AYJMnMVgwsMt8G4Ekh2rUKmoq77L6wRhwUeeUXtfXkoLWUuy2XrN2dcrdFwnb1ZzPAq7
         2Z42drU60d1OyKW2syJM+KRcIjc1wfzSE3lrJzx8Zr81SJrck1iVi4Cc/1uslihLLtbc
         8HRA==
X-Gm-Message-State: AOAM532EyABedmH3EKTBtxhS4emiCK8sIUAXsHZWGhNOXEn51GS8EhK1
        +r/IJXd2ruRDORIQgyMRDtXeXyVgsn+z2A==
X-Google-Smtp-Source: ABdhPJzw6DynPnEsCXUJPwx4zBkNsG6DPWbTXgDAh9RGbq9jePxWi7VDrMmI8VAlZ/eco7i5krCmtA==
X-Received: by 2002:aa7:818f:0:b029:1ae:6a6a:e131 with SMTP id g15-20020aa7818f0000b02901ae6a6ae131mr10426732pfi.38.1611169013324;
        Wed, 20 Jan 2021 10:56:53 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k4sm2966946pfk.44.2021.01.20.10.56.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 10:56:52 -0800 (PST)
Message-ID: <60087cf4.1c69fb81.f777.7067@mx.google.com>
Date:   Wed, 20 Jan 2021 10:56:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.252-24-g9ee5b55a5ffd2
Subject: stable-rc/queue/4.9 baseline: 124 runs,
 6 regressions (v4.9.252-24-g9ee5b55a5ffd2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 124 runs, 6 regressions (v4.9.252-24-g9ee5b55=
a5ffd2)

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
el/v4.9.252-24-g9ee5b55a5ffd2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.252-24-g9ee5b55a5ffd2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9ee5b55a5ffd249231861477252e8aa86b0e7207 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/600847a2c9b4771890bb5d5d

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.252-2=
4-g9ee5b55a5ffd2/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.252-2=
4-g9ee5b55a5ffd2/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/600847a2c9b4771=
890bb5d62
        failing since 0 day (last pass: v4.9.252-14-g2e053b32fc97c, first f=
ail: v4.9.252-22-g7930947a54962)
        2 lines

    2021-01-20 15:09:18.885000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/129
    2021-01-20 15:09:18.895000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/600846e465c1ba8de1bb5d26

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.252-2=
4-g9ee5b55a5ffd2/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.252-2=
4-g9ee5b55a5ffd2/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600846e465c1ba8de1bb5=
d27
        failing since 67 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60084751e94e58ce66bb5d1f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.252-2=
4-g9ee5b55a5ffd2/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.252-2=
4-g9ee5b55a5ffd2/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60084751e94e58ce66bb5=
d20
        failing since 67 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60084784b700b12fe8bb5d42

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.252-2=
4-g9ee5b55a5ffd2/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.252-2=
4-g9ee5b55a5ffd2/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60084784b700b12fe8bb5=
d43
        failing since 67 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6008471c5d6fb7584ebb5d17

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.252-2=
4-g9ee5b55a5ffd2/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.252-2=
4-g9ee5b55a5ffd2/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6008471c5d6fb7584ebb5=
d18
        failing since 67 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/600846b9477294d0d8bb5d0c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.252-2=
4-g9ee5b55a5ffd2/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.252-2=
4-g9ee5b55a5ffd2/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600846b9477294d0d8bb5=
d0d
        failing since 67 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =20
