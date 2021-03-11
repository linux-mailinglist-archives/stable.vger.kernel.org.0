Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E036F337D5D
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 20:12:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbhCKTMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 14:12:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbhCKTMQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 14:12:16 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8DEC061574
        for <stable@vger.kernel.org>; Thu, 11 Mar 2021 11:12:16 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id ga23-20020a17090b0397b02900c0b81bbcd4so9550601pjb.0
        for <stable@vger.kernel.org>; Thu, 11 Mar 2021 11:12:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+uNISIhHnjgDjwSjm5QBRcob6EcAzQQWxYjLzPTAv14=;
        b=VboMdNdRLAnsA1ayiYnlWqUoubZadC/R+AQdC8t+/B3G+ewSJiPuHyTiHBmn91yKWY
         XirUYmKTQdUKvspJ9uRnB3YS0sZRyJG3NtjU9OucB5hg6Ugp/E/g0OZNrTYVRcTz95SJ
         kzFKgIuWGDmMo8pJp3ezeIAnQS/GgRdnvwQkn0lylkvJpvjyFFawmdMze3iVkn5rq2UN
         65o43Id+ASZd14Gyhz68YIgFWHa4db2ymFnMBqWS9GUWrPzuQ+BoPOCcEv7pFrRCeGT/
         UUEKZ6H2h/3fx0+4ZAcDaLOLnp0i1/oV7ZvE7jcGetqCSwgpFhLfLacKq81U7vcbWZL8
         kyDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+uNISIhHnjgDjwSjm5QBRcob6EcAzQQWxYjLzPTAv14=;
        b=GbWK3Ko3IAhcIQ0qGgSzLZTkquOjUOcKuagEsSbVOXJAjNnkuZ+M6M0UiQy3U0xGrW
         Ptcd7/TQGDig6EZXT+PMHx8Z/lyBZ4FsBEVNCeK1oavM9XrVcD1t4EPhIpF28AGk2jDi
         r7n/A5kb91cDjev78I7wQcGFnsNxcI8rAkihOcnZqhVfH+pheYjyDamwkeU3+oTfGkfR
         /wB68ntQI/grYvLZNxkHzOyF2QK6jvNk1Cm0PHngl9DhZqv6bj4rqhPgMfUm08L5Vo5k
         fB/d/tzJ/mS/lSVJt/V6WIi8OpU19Ud5PQgBCsvncw3YLV/7uL5BGoREHjjHSsBq1K77
         jCRA==
X-Gm-Message-State: AOAM5301IR0VVjeI0bZD14RIASCR8WTrXeEbMoHoPM3EnZND12XiokCt
        0Hc0gnfli5pmW1M9w9yVMvidAF/FL+q3IFLq
X-Google-Smtp-Source: ABdhPJzmvsYKroyo5GZCKY1fYoc5vLumJ0pvo1L74KTzhGftArfELbj+cWvT1QIOJ5F179Py2pNcnw==
X-Received: by 2002:a17:903:2301:b029:e4:700b:6d91 with SMTP id d1-20020a1709032301b02900e4700b6d91mr9844094plh.19.1615489935537;
        Thu, 11 Mar 2021 11:12:15 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b19sm3141592pfo.7.2021.03.11.11.12.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 11:12:15 -0800 (PST)
Message-ID: <604a6b8f.1c69fb81.bdc6d.89fc@mx.google.com>
Date:   Thu, 11 Mar 2021 11:12:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.179-39-g881ea87f40882
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 78 runs,
 4 regressions (v4.19.179-39-g881ea87f40882)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 78 runs, 4 regressions (v4.19.179-39-g881ea8=
7f40882)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.179-39-g881ea87f40882/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.179-39-g881ea87f40882
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      881ea87f4088216c8f566347b1b968991b7acbce =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604a3751219ae03c3eaddcc6

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.179=
-39-g881ea87f40882/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.179=
-39-g881ea87f40882/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/604a3751219ae03=
c3eaddccb
        failing since 1 day (last pass: v4.19.179-21-gc964fee72067, first f=
ail: v4.19.179-39-g8b229a67729c8)
        2 lines

    2021-03-11 15:29:16.706000+00:00  <6>[   22.819915] smsc95xx 3-1.1:1.0 =
eth0: register 'smsc95xx' at usb-4a064c00.ehci-1.1, smsc95xx USB 2.0 Ethern=
et, be:31:b8:34:3f:22
    2021-03-11 15:29:16.713000+00:00  <6>[   22.833496] usbcore: registered=
 new interface driver smsc95xx
    2021-03-11 15:29:16.762000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/100
    2021-03-11 15:29:16.771000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604a35f58ee79cbb0baddcb2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.179=
-39-g881ea87f40882/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.179=
-39-g881ea87f40882/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604a35f58ee79cbb0badd=
cb3
        failing since 117 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604a3641799cd2b0c4addcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.179=
-39-g881ea87f40882/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.179=
-39-g881ea87f40882/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604a3641799cd2b0c4add=
cb2
        failing since 117 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604a357df563fcf404addcbc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.179=
-39-g881ea87f40882/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.179=
-39-g881ea87f40882/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604a357df563fcf404add=
cbd
        failing since 117 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
