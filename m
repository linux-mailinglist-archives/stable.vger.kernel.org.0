Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 744C932E73D
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 12:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbhCELan (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 06:30:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbhCELa3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 06:30:29 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C6DFC061574
        for <stable@vger.kernel.org>; Fri,  5 Mar 2021 03:30:29 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id d12so1887851pfo.7
        for <stable@vger.kernel.org>; Fri, 05 Mar 2021 03:30:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TNPG9lLg3q5oPdl5xqLTSMvP+DqRhk3q4/LVL09wQvg=;
        b=hxeftvcUNdoL0aXBDGWnZJnlwTe8V8ITN/CVGap0Y7YG/hHdGUXG3SB+MD1IBdbgyp
         WHcXYxb4q5V4n+BaTiWs+tsSgAUJiWDIyEauW2bDU3QygM6N5Fi3vKk3YWIT8VMm4WNq
         Zn6W4OlUikSATZ6Hh/sJjdKM47gsiX2GUp81LOR/tMOF4j/Nq/fGZIapEONH6KAeFiks
         cYuLJAHl4jrbjcQobgRG7u3al8NBWthCV7w445xK3/ULhx+BOl/R41Id/G6781TNxNPQ
         RLcFAWKZ49aC5AlJapPFCq1/GhYpLnZM8PrBbHK1m8ByCUZriqJnzX29zJ6ijDkLiJV8
         sLwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TNPG9lLg3q5oPdl5xqLTSMvP+DqRhk3q4/LVL09wQvg=;
        b=V/+z2e/P5FiD0FLLv6J3OWVyIeDdVJhX8mUHoR64EMqmJw+/YxDbBzfZpniE6KgIZW
         9Xlx+a7NxcPbnejcqlk90hn5BROWxyA5v2wG5g6eAS22pn/Oe2GgP9bU+n42ozoQGzQz
         W44QfKaS6IssTxxo/zLvySt+u/YLJ2MLEZEeUmq487JJPDpEr+Ca361ol7sxymV5jh9z
         Q1lNdu1n4mMJPuEGtbuGw1trSZTumm63rJMQRCoEgLOOxCpesL2cO4KEVKl047IaB0t2
         ZYcQnZtxiyulTpXyCHzRsC3jxrVwAEbe5gEWa7+0PkbvcmxJhS/zSipwRcC5pn6M70W0
         +4/w==
X-Gm-Message-State: AOAM530K5V+HfEimUF7GHcGZYIGJ06cp89FdLSemItVk+SrowfxwHiV2
        neyIvWu3xhAFQSNnEAk+zvwDeeprsEhelx4x
X-Google-Smtp-Source: ABdhPJyDItrbbJbr5hNGj3a3kYon0bqTsgsUJnNtU1Sj2OIpxjkGGbYIj44GpEQ8ktQV+3DV9adB4A==
X-Received: by 2002:a63:4f56:: with SMTP id p22mr8238843pgl.224.1614943828373;
        Fri, 05 Mar 2021 03:30:28 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 6sm2181446pfv.185.2021.03.05.03.30.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 03:30:28 -0800 (PST)
Message-ID: <60421654.1c69fb81.47aa5.620e@mx.google.com>
Date:   Fri, 05 Mar 2021 03:30:28 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.259-32-ge3151d2bd36d
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 94 runs,
 5 regressions (v4.9.259-32-ge3151d2bd36d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 94 runs, 5 regressions (v4.9.259-32-ge3151d2b=
d36d)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.259-32-ge3151d2bd36d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.259-32-ge3151d2bd36d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e3151d2bd36d3e0cde33ab937c5f9d33a7d6b1f2 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6041e411d9b4d55905addcd3

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-3=
2-ge3151d2bd36d/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-3=
2-ge3151d2bd36d/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6041e411d9b4d55=
905addcd8
        failing since 0 day (last pass: v4.9.259-22-gef981795155f, first fa=
il: v4.9.259-22-g60dc3d39f4a2)
        2 lines

    2021-03-05 07:55:57.259000+00:00  [   20.404144] usb 3-1.1: New USB dev=
ice strings: Mfr=3D0, Product=3D0, SerialNumber=3D0
    2021-03-05 07:55:57.286000+00:00  [   20.436187] smsc95xx v1.0.5
    2021-03-05 07:55:57.318000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/120
    2021-03-05 07:55:57.326000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-03-05 07:55:57.342000+00:00  [   20.486145] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604207f9a299b3a103addcb5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-3=
2-ge3151d2bd36d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-3=
2-ge3151d2bd36d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604207f9a299b3a103add=
cb6
        failing since 111 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6041fcca573eb05f3faddcba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-3=
2-ge3151d2bd36d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-3=
2-ge3151d2bd36d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6041fcca573eb05f3fadd=
cbb
        failing since 111 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6041e4950be1457697addcbf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-3=
2-ge3151d2bd36d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-3=
2-ge3151d2bd36d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6041e4950be1457697add=
cc0
        failing since 111 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6041e32d3dec163c26addcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-3=
2-ge3151d2bd36d/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-3=
2-ge3151d2bd36d/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6041e32d3dec163c26add=
cb2
        failing since 111 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
