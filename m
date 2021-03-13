Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1C7339D27
	for <lists+stable@lfdr.de>; Sat, 13 Mar 2021 10:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbhCMJIo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Mar 2021 04:08:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbhCMJIZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Mar 2021 04:08:25 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97749C061574
        for <stable@vger.kernel.org>; Sat, 13 Mar 2021 01:08:22 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id y13so3508205pfr.0
        for <stable@vger.kernel.org>; Sat, 13 Mar 2021 01:08:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jZbdzTkjHjPePo62tW8ZdN9WERcXXGlT3jvvjJT6bO0=;
        b=uULBO3F+210SLMtkynYgFoGCTr7Wm4G7uaxL34OWuyy3kMbEBhRHtfvZ2mTH8pOPFk
         kH97c4f2BynPjg7Sz9FFAP0Reiovd2NL7EcD48jzZ2vq7m59pSM6XlKkgBcryiM0kOR0
         yQFgSdaDgv9//S80MmECqN+uedbGj0TD6qTy7Ycev9yn/zWK/kglzxo676SsCDrs+IPo
         JEojV3uAt+cmyRYmKpP+So63YksnXt2vZj2NbEItx95/pvzF/8E4u04n/LYvpoQmqbGf
         LTvBuxwgByid15100ZYeD5MFaZDlyh7L4lOHYnt3g2JogbM+HsUK6LGsGsRl5PF8OEly
         C3wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jZbdzTkjHjPePo62tW8ZdN9WERcXXGlT3jvvjJT6bO0=;
        b=Q7M9UBVLLV5GJhxFKZwc1fWbHfQYnYQguiTYT8JDoSC4P04JzGasjkph0i31Bxa+rR
         DGoPBxXBnXEXjhyUd/qpqVmVFLeGMH4m3jEpSL+ElRYjIg8IiOsOc+KD+xrYJJlfbkVO
         /0tpTlrBQS9iddfMpjgvPiXGOlhxcctU4yAg3deKwk43dDYaRsvpFJmVpPKgA6gm6jQf
         mc+VDHt7RYT5IYyElCHyjdrLbVOB3qrjArqSiK8YfdFcihR+VXetTOOAUoAfteV2Saj8
         9yt858a7NIRg9Ap6fivZgIXGuVGawEedTdhoyOtADuLLyjF67+KGMDL3FJ4sekEUf0U7
         cEGQ==
X-Gm-Message-State: AOAM5328f+VO5tLztg8PF+zPtoF4uAVzMX7lvTlOYlfj3/X6xDPWtY/N
        RFpY7CoLSEeLnvCYOj5dFobDTKH86Qub1w==
X-Google-Smtp-Source: ABdhPJx8v6TNJHeUdEULq5UajShTcjnqeH6h5XrV0EWWkDbu74jk4l25LdETTybzpNg3HQs3bCXYeg==
X-Received: by 2002:a62:7a09:0:b029:1f1:5cf4:3fd7 with SMTP id v9-20020a627a090000b02901f15cf43fd7mr16094969pfc.66.1615626501762;
        Sat, 13 Mar 2021 01:08:21 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d7sm7510425pfh.73.2021.03.13.01.08.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Mar 2021 01:08:21 -0800 (PST)
Message-ID: <604c8105.1c69fb81.b9f08.3d50@mx.google.com>
Date:   Sat, 13 Mar 2021 01:08:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.180-85-gc30c87d88c19d
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 107 runs,
 5 regressions (v4.19.180-85-gc30c87d88c19d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 107 runs, 5 regressions (v4.19.180-85-gc30c8=
7d88c19d)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.180-85-gc30c87d88c19d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.180-85-gc30c87d88c19d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c30c87d88c19d54741ffdff769e91bd11cc377ba =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604c4f479cbcc950b2addcb6

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-85-gc30c87d88c19d/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-85-gc30c87d88c19d/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/604c4f479cbcc95=
0b2addcbb
        failing since 0 day (last pass: v4.19.180-18-g4334f738815bb, first =
fail: v4.19.180-40-g3f0127cea9d86)
        2 lines

    2021-03-13 05:36:02.603000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604c4d8d3d0029658caddcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-85-gc30c87d88c19d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-85-gc30c87d88c19d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604c4d8d3d0029658cadd=
cb2
        failing since 119 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604c4d44bfa0b5b7e2addcc5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-85-gc30c87d88c19d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-85-gc30c87d88c19d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604c4d44bfa0b5b7e2add=
cc6
        failing since 119 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604c4cf4ada80d1403addcd9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-85-gc30c87d88c19d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-85-gc30c87d88c19d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604c4cf4ada80d1403add=
cda
        failing since 119 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604c4cfaada80d1403addce6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-85-gc30c87d88c19d/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-85-gc30c87d88c19d/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604c4cfaada80d1403add=
ce7
        failing since 119 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
