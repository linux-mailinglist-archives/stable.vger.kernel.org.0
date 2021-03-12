Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72F023388E0
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 10:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232804AbhCLJnw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 04:43:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232444AbhCLJnZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Mar 2021 04:43:25 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E0CC061761
        for <stable@vger.kernel.org>; Fri, 12 Mar 2021 01:43:25 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id d8so11656490plg.10
        for <stable@vger.kernel.org>; Fri, 12 Mar 2021 01:43:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cymnIpQlwyO1epzAPACexH+w8QDGXa/Lkuql1JtjCvo=;
        b=AEcYY4Q2CByPenE496+UiMLhJJfP9qhqvCYSTOyeKx+D9gR4wKc1ygwkLDQaJcF5m0
         080m/G8DYTRieOyHS3t7e8X2S0KVQs7T7fSIt3oHNmv2h507tSiTUquFFjc5ivei0HUH
         ILDO0boiJsiyM1BDMUJL05XLoJdl0Ds176kExlntvU4Ohx93YgRx2PdhCCokpjpbwlVP
         Jz/M44pJJbIjIGj7m5YoqtWAhMD3/+h9yMdwg9jYuXaTzKlw8zN8Am3ikNtDtwCW+MYt
         K/fh1HPqDT7P05Z6PCdLbxSkp5HmOuPLVngEDLVLbhW6axNzB3X2NFqCmSxBvFU+YKlK
         tZ3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cymnIpQlwyO1epzAPACexH+w8QDGXa/Lkuql1JtjCvo=;
        b=ZDstIpysvSWiPm3A4W1jFn5FxN64+SlCpdt9WvTqUv381AgZ3ZpJcb39xt31BsOZZt
         hC3+5sWVfi7/DPM52Sg6DU/4OqhpeTzGekrMN49yoQfgqzVNVVwcpqA4nt1DjdZ0D7/z
         sM3lUuzd32TYV6pSGo+JVvySuQkjTvgjR/6oxcNpEGTM4Z6LXG8MmqaokvtysH41Lh/5
         9JmkYg5HvckDiaVI8VSHxK2AK4baJqhFF/AQHlhjDlbNPpt10xLQEILZ8vLHbCNl5Fyp
         WAYH8lwY84c40kvhj6VxRniUrSytQ+SKVZANOjRPqonZS8/6+grjkuXzWn1ZvIN7C0Kz
         79vg==
X-Gm-Message-State: AOAM530Sk0hu0xO4fk9cpTzRrl5iYzFlnheHdetZlAhpSBXrCfWuiWa4
        hFcufHlhnTLF5ArrcHiDDD49CefAr1mhPw==
X-Google-Smtp-Source: ABdhPJwsdmVw3+nLPSjGP7wurvX8kFxhD9z3PzGXAfOJRi6gktWQs6ZzRFcFAVDHA1cZUlUUq6lh3w==
X-Received: by 2002:a17:902:a707:b029:e6:52fd:a14d with SMTP id w7-20020a170902a707b02900e652fda14dmr13078096plq.34.1615542204245;
        Fri, 12 Mar 2021 01:43:24 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o62sm4581628pga.43.2021.03.12.01.43.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 01:43:23 -0800 (PST)
Message-ID: <604b37bb.1c69fb81.8f214.c514@mx.google.com>
Date:   Fri, 12 Mar 2021 01:43:23 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.225-11-ga5cc03880a07b
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 90 runs,
 5 regressions (v4.14.225-11-ga5cc03880a07b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 90 runs, 5 regressions (v4.14.225-11-ga5cc03=
880a07b)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.225-11-ga5cc03880a07b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.225-11-ga5cc03880a07b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a5cc03880a07b0c29468410fe1166f46627cf03d =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604b04f9722da21720addcbb

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.225=
-11-ga5cc03880a07b/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.225=
-11-ga5cc03880a07b/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/604b04f9722da21=
720addcc0
        new failure (last pass: v4.14.224-20-g7af575ced3e9a)
        2 lines

    2021-03-12 06:06:45.943000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/105
    2021-03-12 06:06:45.952000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-03-12 06:06:45.965000+00:00  [   20.678283] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604b02c48d83b5d219addcc5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.225=
-11-ga5cc03880a07b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.225=
-11-ga5cc03880a07b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604b02c48d83b5d219add=
cc6
        failing since 118 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604b03c06f706a6988addcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.225=
-11-ga5cc03880a07b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.225=
-11-ga5cc03880a07b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604b03c06f706a6988add=
cb2
        failing since 118 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604b025ddaa86dfe80addcb8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.225=
-11-ga5cc03880a07b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.225=
-11-ga5cc03880a07b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604b025ddaa86dfe80add=
cb9
        failing since 118 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604b13ac48fefd7d6faddcb2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.225=
-11-ga5cc03880a07b/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.225=
-11-ga5cc03880a07b/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604b13ac48fefd7d6fadd=
cb3
        failing since 118 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
