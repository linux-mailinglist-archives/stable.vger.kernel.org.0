Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2EB35CEE0
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 18:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244285AbhDLQve (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 12:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343838AbhDLQn6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 12:43:58 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A414C06138F
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 09:34:27 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id m11so9531488pfc.11
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 09:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kGG2TFpsWCGSpcodS4ySAY5p3Yx32Wo8rgioIHvhDyQ=;
        b=hrzPyCrSu5hLeEt1pKvd9c2N7f8+jDKrTXyK+FlRvf3Y2wLnGZLumd1jSK7b52y7x3
         Idpwxr5/4iqtkp97tFPqOCesl278H5/UcYxhnxOwnf76dNc9gr1o9df0tLwFnlc8R0OK
         sOG+ygMZfW6Mwkulzl0Yr5nmLPJDmAB7BhYQgaRJgReBX5bQ1sWxXxdYNjFzguF/4TSA
         nJrr5nmukwPzDUK4GkVKiCoHd1mtLKP3Nbn24oRZQ3IC/um5FKm7c99mwFg8l80gllsE
         aSbcZAJX/KkcHn66IMkSS5eW1rvVAzol88fy/KWkmb0CCOtuE+dcHkNDdshySv979KwV
         cWzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kGG2TFpsWCGSpcodS4ySAY5p3Yx32Wo8rgioIHvhDyQ=;
        b=mAm9OG6mACXcZOhVarK6hzXFiwt3eosX3ffhCXiwmOW15pS4YZoQGrpqGKv9UOv4GP
         TkA4KLIGmmoMLsehEwC/1iBLCKk4CEhjt+WfJDNk5eV5tf+L1xpg6WAwW7AYziZasWm/
         JRv5c9ZSuN36mHKwguJAab3t00eUezjEaNF/0YNuMVdM/Y6ZfI35I/6La+0QDYEiOCYz
         5XsJ9TioJtdXDabA7Ss/Y/kklcW75gGOMc7gl52fjfAgTxXKv4t0dpec2J/BvFUJp0a7
         rbU/zJdHK67SaxBTjdurRWBhpcPNgbvDIv7XDZ3OMnEJ1YOYCe7oR2Lg7rheYkU8+u7v
         unrw==
X-Gm-Message-State: AOAM532vLZb+PZq/Mgs9b8k+FsNAUub2y0abVBmd+aroAccI5XIkVO/W
        bQKErZpwK8pf3SxB9kH1XTMGBgDOrL2djRT0
X-Google-Smtp-Source: ABdhPJzzBRpba/D+AQxV4mwztzElf33KXGuhhaxWiyyFRGppLdu5VzF19ZEKElgVkTHtUC/Qqfr18Q==
X-Received: by 2002:a62:5a83:0:b029:222:c9de:5c65 with SMTP id o125-20020a625a830000b0290222c9de5c65mr25958611pfb.23.1618245266529;
        Mon, 12 Apr 2021 09:34:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h19sm120685pgm.40.2021.04.12.09.34.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 09:34:26 -0700 (PDT)
Message-ID: <60747692.1c69fb81.c55e0.060e@mx.google.com>
Date:   Mon, 12 Apr 2021 09:34:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.186-65-gf7275a2da53b
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 108 runs,
 4 regressions (v4.19.186-65-gf7275a2da53b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 108 runs, 4 regressions (v4.19.186-65-gf7275=
a2da53b)

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

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.186-65-gf7275a2da53b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.186-65-gf7275a2da53b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f7275a2da53b8d1f2030ebb82804f8db4d0e501e =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/607441e8c1fa32aff9dac72a

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.186=
-65-gf7275a2da53b/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.186=
-65-gf7275a2da53b/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/607441e8c1fa32a=
ff9dac731
        new failure (last pass: v4.19.186-52-gf2aee9aaba24e)
        2 lines

    2021-04-12 12:49:40.185000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/100
    2021-04-12 12:49:40.194000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-04-12 12:49:40.209000+00:00  <8>[   22.833343] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60743d595b85a84121dac6c0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.186=
-65-gf7275a2da53b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.186=
-65-gf7275a2da53b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60743d595b85a84121dac=
6c1
        failing since 149 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60743d45aecfc31354dac6bf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.186=
-65-gf7275a2da53b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.186=
-65-gf7275a2da53b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60743d45aecfc31354dac=
6c0
        failing since 149 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60743cf2d383eb8b50dac6b6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.186=
-65-gf7275a2da53b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.186=
-65-gf7275a2da53b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60743cf2d383eb8b50dac=
6b7
        failing since 149 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
