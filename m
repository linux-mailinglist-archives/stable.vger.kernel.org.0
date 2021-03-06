Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8D032FB2B
	for <lists+stable@lfdr.de>; Sat,  6 Mar 2021 15:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbhCFO1y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Mar 2021 09:27:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbhCFO1f (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Mar 2021 09:27:35 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A9A1C06174A
        for <stable@vger.kernel.org>; Sat,  6 Mar 2021 06:27:35 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id q6-20020a17090a4306b02900c42a012202so732438pjg.5
        for <stable@vger.kernel.org>; Sat, 06 Mar 2021 06:27:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZCwSyX0Psi3zLAYUh0d6P5geJbg/zmaxhTY1JVFuTy8=;
        b=kO6wt9eoGD+X3fFAPy9KN4ZKdp6nvgi9jP3IVz4LGz0zBE516Jkpj4GGutF0IMbC3I
         LZ1ZsNADx3EgmQphrOIdUoPW+39EBMqNmo/+XMKlbCTg2DDS0DreGJwHKGU8MCuhFIAX
         qqn0/+9ZIQtixE1+8W3ddsm8gQO/yjR8U4F6TSAELIZdAd//AVIvmE1rJLKQ132ja+ZB
         fkrBEILdrW4NBWyrv/BVay+BgRezezChE+pkGoV5Ep3+ZDBuwTUq8fhd5D1oKfjAzUf4
         BfY/WvqwJw9s2A18zGBiJLtBa3u5/pi6tcv7BlDhKlgcSb5QF522B3R5UVKwoPIdTNd9
         D0UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZCwSyX0Psi3zLAYUh0d6P5geJbg/zmaxhTY1JVFuTy8=;
        b=PJgjJWCH2LHedV0+xMG2KWoZ7Ej7CoFtZcI5F7iNxdzOsK3ht2Ui+y5V3GjL88ifN8
         cLSekGW1tmh+ea1w2eoqvjjkSSiX/2YIlLe2OS3cxqokcZQ3KHsUUoDkGlSPpxi35iHZ
         MKL1aD3D5AKKOKmX12pk/eeiYVB1Q4iAVvgnRh0NYEtuGKxGV/3zVtCDSXiElfeAjZiJ
         1RdhV4jVwnPFqVrXx9ZfOuFQi68rCWLGfhCxBX811Pd5S0GvjUOhxDNrVR+6Ldrd/wiM
         W7mWX1ctfjxvtKQSvnHSCICbZLWTh+0+cJQQHWKho1Kp2Q7dIiE1IdROnscNMdp8gGkk
         MY8w==
X-Gm-Message-State: AOAM532aETNZuRrvq17YeD2W+fuQTb7YqrJ6W8Ca73RckSsyOqtaCV8n
        0Bg0wMW52fbGl2xGzisBrdzrdIk+LZ6UQo3w
X-Google-Smtp-Source: ABdhPJzzz4YEGbb5b9JYXu+zHbie8P7u4BpgHZm2tDa1W4xLfzPQKIalcAhWVuEIcOHvrGlLDPwgdQ==
X-Received: by 2002:a17:90a:6e44:: with SMTP id s4mr14854064pjm.112.1615040854285;
        Sat, 06 Mar 2021 06:27:34 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b15sm5454481pgj.84.2021.03.06.06.27.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Mar 2021 06:27:33 -0800 (PST)
Message-ID: <60439155.1c69fb81.bd4b4.d953@mx.google.com>
Date:   Sat, 06 Mar 2021 06:27:33 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.102-72-g7b9a9013aea46
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 98 runs,
 4 regressions (v5.4.102-72-g7b9a9013aea46)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 98 runs, 4 regressions (v5.4.102-72-g7b9a9013=
aea46)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.102-72-g7b9a9013aea46/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.102-72-g7b9a9013aea46
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7b9a9013aea468e0fb57801dc27ad5d47464b41a =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60435deb2049abcc4aaddcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-7=
2-g7b9a9013aea46/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-7=
2-g7b9a9013aea46/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60435deb2049abcc4aadd=
cb2
        failing since 112 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6043670cf1ed68cea7addce1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-7=
2-g7b9a9013aea46/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-7=
2-g7b9a9013aea46/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6043670cf1ed68cea7add=
ce2
        failing since 112 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60435d817e62b030c5addcb8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-7=
2-g7b9a9013aea46/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-7=
2-g7b9a9013aea46/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60435d817e62b030c5add=
cb9
        failing since 112 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60435da1f3ab389d01addd1f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-7=
2-g7b9a9013aea46/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-7=
2-g7b9a9013aea46/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60435da1f3ab389d01add=
d20
        failing since 112 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =20
