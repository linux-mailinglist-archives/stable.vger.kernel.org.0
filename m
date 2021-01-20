Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 671042FD3A1
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 16:14:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731209AbhATPNC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jan 2021 10:13:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732335AbhATPKd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jan 2021 10:10:33 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A554C061575
        for <stable@vger.kernel.org>; Wed, 20 Jan 2021 07:09:53 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id m5so2360128pjv.5
        for <stable@vger.kernel.org>; Wed, 20 Jan 2021 07:09:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wq7HYYtKw1KXEVVi7o1CValU0iXpueeRJFvXUjmp3Zs=;
        b=fyi9bZ2IoPXZvhcozYrt0gyxskH0bmY0+lgOco3Y57RpJ0C/gbAgAClIHUZooqWD4P
         N/aepCmKffQ6HCnaXi04haVIH5jFmrbnnyoDGmppymyvt2dMk2gnHp32ZJXjtbpjPdAV
         5l8t/nlpfwxqEbulxsvrt/gSyTyCSdtEpAQV/eB9m6TOPgQw3rSY7SFvI76XOsrKxb++
         BpxnTR7hTjhwERwEV6xaKEJDyAxIkhanypP9trf80Bq884RsgN37zK1/jebvAw9rHUp0
         CTYkmdbMlaf6U+VflkwShkXmG35YcEmAMZiXuc5EB687t/n+ty6vX+gPgbJ+OmnbSxuV
         9zxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wq7HYYtKw1KXEVVi7o1CValU0iXpueeRJFvXUjmp3Zs=;
        b=T2bUAsob3K2AcT2AJvvMw8vSmq3J9qxb21i4NdQM4JfTBfcL/Rh0ffuR4lmHLlfUAi
         keCvj2U1d17t/F3+gfjyZdghPPTi3dPC9QbdFlHme8vmpFN9yLA4FhhRmiVCRocy/lAe
         jEXVAQ02kmLxfPmaQc13QRkm5Fgg+Ce9b1n/EOeJogjW8EJyBymAwZmjHdiPC99dVMa9
         NoRCW49XqF0xmrQychPpJ84HRl8olZ219tkXb+c3FVe7azYP8MnJ8Fj+gmnqDQGUoEZR
         ax5fxwMHGN3kUtnQjgTBxaQCYdwWQ/FZHATGvlBvkaS3jRKW3TcYRASHlILo+Da5Tx0o
         dG3g==
X-Gm-Message-State: AOAM532HEUWbdan9lqGT7vWbRnLrfC8hz42f5Dr6RgLTF6Z5EaisuUTp
        U2uO1mykUEQOFIYRsssZxR0A4XE4GBu3qg==
X-Google-Smtp-Source: ABdhPJw4/MRhs7FG+w3TN9jNHJeRziP5uDeASvbm1UoDNwaahO/NDePCaT76Zmd8h5gEMQ0i5il+6w==
X-Received: by 2002:a17:90a:ad01:: with SMTP id r1mr6313615pjq.197.1611155392162;
        Wed, 20 Jan 2021 07:09:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o13sm2814909pfp.101.2021.01.20.07.09.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 07:09:51 -0800 (PST)
Message-ID: <600847bf.1c69fb81.f0eb.64a1@mx.google.com>
Date:   Wed, 20 Jan 2021 07:09:51 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.91
Subject: stable-rc/linux-5.4.y baseline: 164 runs, 8 regressions (v5.4.91)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 164 runs, 8 regressions (v5.4.91)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
bcm2837-rpi-3-b-32   | arm   | lab-baylibre    | gcc-8    | bcm2835_defconf=
ig   | 2          =

hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.91/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.91
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d26b3110041a9fddc6c6e36398f53f7eab8cff82 =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
bcm2837-rpi-3-b-32   | arm   | lab-baylibre    | gcc-8    | bcm2835_defconf=
ig   | 2          =


  Details:     https://kernelci.org/test/plan/id/600813426d8adfaa6abb5d1a

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.91/=
arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.91/=
arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/600813426d8adfa=
a6abb5d1e
        new failure (last pass: v5.4.90)
        24 lines

    2021-01-20 11:25:40.593000+00:00  kern  :alert : Unable to handle kerne=
l NULL pointer dereference at virtual address 00<8>[   43.042389] <LAVA_SIG=
NAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=
=3D24>
    2021-01-20 11:25:40.593000+00:00  000018
    2021-01-20 11:25:40.594000+00:00  kern  :alert : pgd =3D b6b37996
    2021-01-20 11:25:40.595000+00:00  kern  :alert : [00000018] *pgd=3D2aec=
a835, *pte=3D00000000, *ppte=3D00000000
    2021-01-20 11:25:40.595000+00:00  kern  :alert : 8<--- cut here ---   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/600813426d8adfa=
a6abb5d1f
        new failure (last pass: v5.4.90)
        150 lines

    2021-01-20 11:25:40.599000+00:00  kern  :alert : pgd =3D 8617e870
    2021-01-20 11:25:40.635000+00:00  kern  :alert : [00000018] *pgd=3D2adf=
8835, *pte=3D00000000, *ppte=3D00000000
    2021-01-20 11:25:40.636000+00:00  kern  :alert : 8<--- cut here ---
    2021-01-20 11:25:40.636000+00:00  kern  :alert : Unable to handle kerne=
l NULL pointer dereference at virtual address 00000018
    2021-01-20 11:25:40.637000+00:00  kern  :alert : pgd =3D 3eda8c8f
    2021-01-20 11:25:40.637000+00:00  kern  :alert : [00000018] *pgd=3D2aeb=
c835, *pte=3D00000000, *ppte=3D00000000
    2021-01-20 11:25:40.638000+00:00  kern  :alert : 8<--- cut here ---
    2021-01-20 11:25:40.638000+00:00  kern  :alert : Unable to handle kerne=
l NULL pointer dereference at virtual address 00000018
    2021-01-20 11:25:40.638000+00:00  kern  :alert : pgd =3D 8e4a59de
    2021-01-20 11:25:40.679000+00:00  kern  :alert : [00000018] *pgd=3D2aed=
c835, *pte=3D00000000, *ppte=3D00000000 =

    ... (131 line(s) more)  =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/600812c639652d439dbb5d1c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.91/=
riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.91/=
riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600812c639652d439dbb5=
d1d
        failing since 61 days (last pass: v5.4.77-152-ga3746663c3479, first=
 fail: v5.4.78) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60081079f8daf9e183bb5d1c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.91/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.91/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60081079f8daf9e183bb5=
d1d
        failing since 66 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6008109b7a25d409e5bb5d15

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.91/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.91/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6008109b7a25d409e5bb5=
d16
        failing since 66 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6008139b0997853f6dbb5d0f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.91/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.91/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6008139b0997853f6dbb5=
d10
        failing since 66 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60082300b0180dac8bbb5d0d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.91/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.91/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60082300b0180dac8bbb5=
d0e
        failing since 66 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60082ba369f97d33dabb5d18

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.91/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.91/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60082ba369f97d33dabb5=
d19
        failing since 66 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =20
