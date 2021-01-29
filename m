Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 730EE308D74
	for <lists+stable@lfdr.de>; Fri, 29 Jan 2021 20:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232863AbhA2Tb4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jan 2021 14:31:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232727AbhA2Tbw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jan 2021 14:31:52 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E46C061574
        for <stable@vger.kernel.org>; Fri, 29 Jan 2021 11:31:12 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id b145so64283pfb.4
        for <stable@vger.kernel.org>; Fri, 29 Jan 2021 11:31:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=n5fbO2zTsEyYpRylW25cuONGHZOe+QKnvALpZeE8398=;
        b=je0Y3mgTLueam71zAMvV5wSj3JM0UsUoFkYNZKI6OBDcz0aiBfKKTIMQ8hu/bjO4Vy
         BARuN5H0ix6/Jrg+2B0o/fcMsW/V9p0WaNXvNSneyhmPQLtGu+DfagSR3Ow7eq4Scz09
         4Pz7DIT9AKoI+TB0hNzv8kqNQrq3469C9CPyUqiFpqVrldmI03QvbzkFaTcOOvAaCJj/
         Sz3Nz4dRV3zIi3PxFKUE9d3wlN85YO5b6vHsnd+smAUsCvxZFJUPCakWNIeruxm4YWSQ
         pQQIrYH7fCdCvmWGt6v6jEv6TNNfWr8sRGGbeso66xDT7ZbXWBNxLrH5sb/K44XERhKg
         WOxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=n5fbO2zTsEyYpRylW25cuONGHZOe+QKnvALpZeE8398=;
        b=mQvP8EAkT3//C188Rtm5BGv9MVT2vKubgYdXtJq7ocsagsX0hTMYqNFyrI0oYnYQJN
         L7//v55sex88sJZns0jIGg30MsrvLTSOLvrJcINmHGkWwNd7ifzqu8KePmlVzigFYlzV
         b+nQ3LgqzRvFGdsUVut1ZrPpdeDe5nh/rbzQTkz5GkXea+vhMC5Nssrxetp70PYJ0P4i
         RBwEyl0JcyeZZLuqt+4kCdHPfkmXZR9k7pussefS57V80lUQLCbynhymLBCcuAXt3Pjg
         JTh5iCRC6RzFlbLC+rrsfVWzSuomL0md3fFLT/+DFeDv53sMXeGItUlI0UlNvEMccnff
         n0Gw==
X-Gm-Message-State: AOAM530xaQ2vP0kHNrhS6sqY08fNRAxzPoGwutF04gR7DRSfcxStql3m
        8ZLMJy8FqG1FruDGnVXAzvcU1NDe+Kg9Ug==
X-Google-Smtp-Source: ABdhPJyGYQgR8jPbnDyoPv05+x8sUlHEy7DTTZWtELoTTWRUWgWv+dCjeBXOdXTQfMCVkmLvwK6+vA==
X-Received: by 2002:a63:6686:: with SMTP id a128mr6069021pgc.109.1611948671706;
        Fri, 29 Jan 2021 11:31:11 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j17sm9399698pfh.183.2021.01.29.11.31.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 11:31:11 -0800 (PST)
Message-ID: <6014627f.1c69fb81.7b964.6fc2@mx.google.com>
Date:   Fri, 29 Jan 2021 11:31:11 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.93-18-gdd375400a7bc
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 169 runs,
 4 regressions (v5.4.93-18-gdd375400a7bc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 169 runs, 4 regressions (v5.4.93-18-gdd375400=
a7bc)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.93-18-gdd375400a7bc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.93-18-gdd375400a7bc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dd375400a7bc92ebdec5553cb42d850fd9658af3 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60142f1f2d92033978d3dfe6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.93-18=
-gdd375400a7bc/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.93-18=
-gdd375400a7bc/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60142f1f2d92033978d3d=
fe7
        failing since 76 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60142f274fca7fa369d3e0bd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.93-18=
-gdd375400a7bc/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.93-18=
-gdd375400a7bc/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60142f274fca7fa369d3e=
0be
        failing since 76 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60142f1246706fe987d3dff3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.93-18=
-gdd375400a7bc/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.93-18=
-gdd375400a7bc/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60142f1246706fe987d3d=
ff4
        failing since 76 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60142ecc7d2a15651ed3dfde

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.93-18=
-gdd375400a7bc/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.93-18=
-gdd375400a7bc/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60142ecc7d2a15651ed3d=
fdf
        failing since 76 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =20
