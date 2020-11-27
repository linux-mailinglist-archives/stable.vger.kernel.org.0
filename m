Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3D02C6BBA
	for <lists+stable@lfdr.de>; Fri, 27 Nov 2020 19:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729422AbgK0Ss7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Nov 2020 13:48:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729383AbgK0SsW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Nov 2020 13:48:22 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F493C0613D2
        for <stable@vger.kernel.org>; Fri, 27 Nov 2020 10:48:29 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id y7so5263571pfq.11
        for <stable@vger.kernel.org>; Fri, 27 Nov 2020 10:48:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5XjBd9AkXhKmI0TQYo69ozPNKs6stfs++IDdTG0zQgw=;
        b=PcgKNhinwjl2KcPWv7++FB61DjlcOcVLAeOX/Xz0bnQC/OejqF+CoYoN3DhBswldGM
         G3bmGdUv8pI0RieTkh2pCzMSaa+DSiExGPsUSkUk8ZCSbjFjsgfhzxVa6eBhSv5SncPs
         YZbTytclv5rcf6f+5NbUNb17DFNI/beA7j1Xv0efag5c9Hx6pVqRlU1ucFdsvg2heRlV
         QjIULCaXa2rBwz5qR1jpdw+7XXZdhdd4XxVamQ0L2RKhltNvUHiPUeUt4F7ubwQThDF5
         g5HXV/7It3694LccuRkQXMKzJ8jTKSwOhBOfLkpIKoxAyhmvWFuTMNGPQdREkMDUSVYx
         w1hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5XjBd9AkXhKmI0TQYo69ozPNKs6stfs++IDdTG0zQgw=;
        b=njP2BvVDep5uabJJ/mPwBgNxILiqjI44clUgyeBK2KDYxd+tyYBTy8BGH3TsDPdH9h
         11opMlQ0Cm+U1+Uusuye0TQ+6YzgHf+CMPlMgq/LCX6YIL2cTKKUueI1R+6PG5W6p65O
         fvAwISXtr2gWqbjeenh24zwVWb5oMuk/8YWoOJP9OC7UluYLE8MymoJnQ5nrEUAdNy2Q
         TylyI1dzX7mb1mVnP3aouSeReErG6kqP2aJTi96LSYz2gl3k/KwJIrjffzZlSniUU0UX
         kE+1lbykeJyCt4XnjYd8WvYP9Ts63/KVp9ITz4LQwl1twNxTMZCYicOVUr951wJP2mm3
         g43Q==
X-Gm-Message-State: AOAM532b+ghiaJoHUH50/mWBeZhMnIPTpg7Xr/MZH5mqGQKcMGgozc5F
        2ShNvtDBYW2wuIrkg0pOcSujJgl60IodmA==
X-Google-Smtp-Source: ABdhPJw4AeNhCsaXLQAZlwfs0Z9nsTgWnjANfzOvRXomvgNjoxZuZcma6PkJkCMnHm0+VHZm/3SnsA==
X-Received: by 2002:a63:5a22:: with SMTP id o34mr4071825pgb.187.1606502908733;
        Fri, 27 Nov 2020 10:48:28 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z7sm8057157pfr.140.2020.11.27.10.48.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 10:48:28 -0800 (PST)
Message-ID: <5fc149fc.1c69fb81.2feae.36dd@mx.google.com>
Date:   Fri, 27 Nov 2020 10:48:28 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.80-4-g90d955c74420
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 161 runs,
 7 regressions (v5.4.80-4-g90d955c74420)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 161 runs, 7 regressions (v5.4.80-4-g90d955c74=
420)

Regressions Summary
-------------------

platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
at91-sama5d4_xplained | arm   | lab-baylibre    | gcc-8    | sama5_defconfi=
g     | 1          =

bcm2837-rpi-3-b       | arm64 | lab-baylibre    | gcc-8    | defconfig     =
      | 1          =

hifive-unleashed-a00  | riscv | lab-baylibre    | gcc-8    | defconfig     =
      | 1          =

qemu_arm-versatilepb  | arm   | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb  | arm   | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb  | arm   | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb  | arm   | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.80-4-g90d955c74420/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.80-4-g90d955c74420
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      90d955c7442062024a6cdd8f65559c2ad8199523 =



Test Regressions
---------------- =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
at91-sama5d4_xplained | arm   | lab-baylibre    | gcc-8    | sama5_defconfi=
g     | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc112b03f504c5b81c94cc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-4-=
g90d955c74420/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_=
xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-4-=
g90d955c74420/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_=
xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc112b03f504c5b81c94=
cca
        failing since 29 days (last pass: v5.4.72-409-gbbe9df5e07cf, first =
fail: v5.4.72-409-ga6e47f533653) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
bcm2837-rpi-3-b       | arm64 | lab-baylibre    | gcc-8    | defconfig     =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc1122d2346cfe1f9c94cbd

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-4-=
g90d955c74420/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-4-=
g90d955c74420/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5fc1122d2346cfe1=
f9c94cc0
        failing since 2 days (last pass: v5.4.80-2-g916d352681d9, first fai=
l: v5.4.80-3-g778c35c99c99)
        1 lines

    2020-11-27 14:48:22.090000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-11-27 14:48:22.090000+00:00  (user:khilman) is already connected
    2020-11-27 14:48:37.492000+00:00  =00
    2020-11-27 14:48:37.493000+00:00  =

    2020-11-27 14:48:37.493000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-11-27 14:48:37.493000+00:00  =

    2020-11-27 14:48:37.493000+00:00  DRAM:  948 MiB
    2020-11-27 14:48:37.509000+00:00  RPI 3 Model B (0xa02082)
    2020-11-27 14:48:37.595000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-11-27 14:48:37.627000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (376 line(s) more)  =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
hifive-unleashed-a00  | riscv | lab-baylibre    | gcc-8    | defconfig     =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc1139a4c0fb74a35c94cc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-4-=
g90d955c74420/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-=
a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-4-=
g90d955c74420/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-=
a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc1139a4c0fb74a35c94=
cc1
        failing since 7 days (last pass: v5.4.78-5-g843222460ebea, first fa=
il: v5.4.78-13-g81acf0f7c6ec) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc11262191c387c16c94cc5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-4-=
g90d955c74420/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-4-=
g90d955c74420/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc11262191c387c16c94=
cc6
        failing since 13 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc1127200d8e08794c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-4-=
g90d955c74420/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-4-=
g90d955c74420/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc1127200d8e08794c94=
cba
        failing since 13 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc1127375286c989ec94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-4-=
g90d955c74420/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versa=
tilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-4-=
g90d955c74420/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versa=
tilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc1127375286c989ec94=
cba
        failing since 13 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc112272346cfe1f9c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-4-=
g90d955c74420/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-4-=
g90d955c74420/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc112272346cfe1f9c94=
cba
        failing since 13 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =20
