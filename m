Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13D8B2D6988
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 22:17:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393994AbgLJVRL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 16:17:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393993AbgLJVRL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 16:17:11 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC82C0613CF
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 13:16:31 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id w5so4649518pgj.3
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 13:16:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HaTI//DqYKnckwSMlvu75oA6xzg1UiOjElIVWf18YYw=;
        b=A73zLe+J+VZzEN/H4RRWr2koKwtIffZk7gFWvEmPSaeDJhk6hLrOa51lGrgB3zaTic
         sP96fmCDX4dqQvQncJsWawPAIqrMYhQy3vPgDXWceWAaI4aqoYZxhe6ne320LYTaeCCo
         4NJOlP6esaCWUvbZDf3dEAm85ci8Wd9NqxlPa57TAJuXuV9nvmZB+/Nw7+zlMvgU5xdJ
         LOzD0pap/6k0hCelwyNtv0sZ/kIB25G5sil3cwN4Gmfiz8BIwoll3PeQuLqDYxQeG24C
         JfX/Qp9qrbWhaFUSwVjNBqfT63CW/FoZyDegoR7UzSfoDF1PKbxxn0LTQZswse3JP9+i
         TvLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HaTI//DqYKnckwSMlvu75oA6xzg1UiOjElIVWf18YYw=;
        b=XXe0W9TBSI8Nn8P1xfhNTJxxS7ygaG82JcTufibtmZY2dqO2kTPSmiINfNhJRbbU7U
         TuGCN3LyvKv1i3ozIkFfyl4B4AXn64NPGLMr9IfyeNfjxdlk+UnqES1KQ0qI+p8qUdap
         6rUDeqHZFjBdJl0IoezRalTDRKMXc1xlfEOuAo2+tUDdhEw9M4tvNMJQl6vPu/yujpS+
         8jxovo6FcnClSasgt+yvntquIYVuLMMQT7Y4ucG47yHUTH752OrG/ZclrZS6ndwAiqtw
         nKwqB8fLnWaLLYElMUm8kvpgkM/CEXqfI8W1FLK/bktcWWdEwuzi4lwd++IhmRRDi+wU
         UTXA==
X-Gm-Message-State: AOAM531luGVbySGqDGJ443znKW7QBzfn0AcI/RXENRFLhorvoGh6SI44
        tOAvda8leR0INySFgqiy69yJacUKo0W4Hw==
X-Google-Smtp-Source: ABdhPJwBR3nnwDinWXV+oWe726WoElkTCKGKWGpJkSEsqty4GcDFi+2wP2bnSWGRzzbqspoHlZJwJA==
X-Received: by 2002:a17:90b:338d:: with SMTP id ke13mr9572145pjb.48.1607634990446;
        Thu, 10 Dec 2020 13:16:30 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p9sm7455319pfq.109.2020.12.10.13.16.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Dec 2020 13:16:29 -0800 (PST)
Message-ID: <5fd2902d.1c69fb81.48da0.db9e@mx.google.com>
Date:   Thu, 10 Dec 2020 13:16:29 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.162-41-ga1b1c60de6b97
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.19.y baseline: 161 runs,
 6 regressions (v4.19.162-41-ga1b1c60de6b97)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 161 runs, 6 regressions (v4.19.162-41-ga1b=
1c60de6b97)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
bcm2837-rpi-3-b      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

panda                | arm   | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.162-41-ga1b1c60de6b97/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.162-41-ga1b1c60de6b97
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a1b1c60de6b977bc1a2fc8176b647879030ab862 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
bcm2837-rpi-3-b      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd25a40bf59c2d67ec94cd6

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
62-41-ga1b1c60de6b97/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rp=
i-3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
62-41-ga1b1c60de6b97/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rp=
i-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5fd25a40bf59c2d6=
7ec94cd9
        failing since 0 day (last pass: v4.19.162-25-g9ce3572039658, first =
fail: v4.19.162-40-ga556f48a1f86)
        1 lines

    2020-12-10 17:24:44.426000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-12-10 17:24:44.426000+00:00  (user:khilman) is already connected
    2020-12-10 17:24:59.743000+00:00  =00
    2020-12-10 17:24:59.744000+00:00  =

    2020-12-10 17:24:59.764000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-12-10 17:24:59.764000+00:00  =

    2020-12-10 17:24:59.765000+00:00  DRAM:  948 MiB
    2020-12-10 17:24:59.780000+00:00  RPI 3 Model B (0xa02082)
    2020-12-10 17:24:59.867000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-12-10 17:24:59.899000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (362 line(s) more)  =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
panda                | arm   | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd25f5c4ac3f44565c94cb9

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
62-41-ga1b1c60de6b97/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
62-41-ga1b1c60de6b97/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fd25f5c4ac3f44=
565c94cbe
        failing since 29 days (last pass: v4.19.155-42-g97cf958a4cd1, first=
 fail: v4.19.157)
        2 lines

    2020-12-10 17:48:07.704000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/103
    2020-12-10 17:48:07.713000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd25b63f2c4d5000ec94cd8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
62-41-ga1b1c60de6b97/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
62-41-ga1b1c60de6b97/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd25b63f2c4d5000ec94=
cd9
        failing since 22 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd25b702da5627b43c94cbc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
62-41-ga1b1c60de6b97/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
62-41-ga1b1c60de6b97/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd25b702da5627b43c94=
cbd
        failing since 22 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd25b6df2c4d5000ec94ce4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
62-41-ga1b1c60de6b97/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
62-41-ga1b1c60de6b97/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd25b6df2c4d5000ec94=
ce5
        failing since 22 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd25b1186575a20a1c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
62-41-ga1b1c60de6b97/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
62-41-ga1b1c60de6b97/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd25b1186575a20a1c94=
cba
        failing since 22 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =20
