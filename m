Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F41C37550C
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 15:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233918AbhEFNs3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 May 2021 09:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233854AbhEFNs3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 May 2021 09:48:29 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55DA8C061574
        for <stable@vger.kernel.org>; Thu,  6 May 2021 06:47:31 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id ge1so3369141pjb.2
        for <stable@vger.kernel.org>; Thu, 06 May 2021 06:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=R+9c2lirX/g1Vtdv1LQwtmgQHf2mHZWxpFGZzTdCqGc=;
        b=R2bm4V5KDa0+sP2RwR0auF8CTC2z5NJrlObmeEEaIK5h54RujmvKUw3IBD1rLaXE3G
         O7WKYh0iWvXu+IMXA5u0SOVU+O3BM1bXqiHpQRksgFNAWxab74IY9BfX8FRl5r/ceq+K
         V02GE+60X/VqmWvDNGM1jkLZiduqikpvIIss+vlipAw32J68mj/WS/F/hD9eOAoMlwUs
         CjqxIkG8fQTzq8DslhGRBlxmWK/P3nb9azvmuUemupxQmuBvFcMjW38G6medorjy5Lqf
         cfsuzMrl/75Y+asjEAkPNIfvtNG3cY9c82bfhnlgvNiWAYRfCuFwkReJZceLbz5fjALD
         1WPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=R+9c2lirX/g1Vtdv1LQwtmgQHf2mHZWxpFGZzTdCqGc=;
        b=Ax7td5W+UfDNwMeUgOiUHcH47+dtpzw2xBfzsrNnZkZdCLepP2IiqxpdM/TWjlX21t
         OF8yh9NHS/dJaQMaAfrGCQGKIxwp3SXZ5Z97HikVNsJJi4EtTCMrAFRACgLWdr1La+yf
         JN7nbIbIIEWoh9CInuYWkb27VAX6701H/c4hWXaHA0a03Et4XOakOetsPJ9+5UBj0wCa
         xAGqVimAp/ADHD5CfZj2i9rJj159S1bO3nrdf2aafbQWc4VIgqEh1r/jmt19F8G0aAr4
         AeOp6JVyKUbN7FkMbgsIAZ2xrC92r7aU9obnrdkHls9/78de4Ixil7sLOpOz6bJIykvo
         +UJg==
X-Gm-Message-State: AOAM530helQFLCfW0O9Yep4vNmuun3vqufxOshIB79LC1quKSZw+w37n
        jbiuNPoEKOzMmqQdIFhJP13C25qIj3GfUTML
X-Google-Smtp-Source: ABdhPJyA01hZ9/iMv+v3MznMMXH33omN0mc4sRNiPAPW7JtLw/wbFfAK/PJoUYVRt1m3dmoabPJlJg==
X-Received: by 2002:a17:902:aa4c:b029:ee:ec17:89f with SMTP id c12-20020a170902aa4cb02900eeec17089fmr4787325plr.11.1620308850513;
        Thu, 06 May 2021 06:47:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b15sm2104398pjg.15.2021.05.06.06.47.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 06:47:30 -0700 (PDT)
Message-ID: <6093f372.1c69fb81.8b1fc.6056@mx.google.com>
Date:   Thu, 06 May 2021 06:47:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.232-16-gde17eaf4e1904
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 43 runs,
 4 regressions (v4.14.232-16-gde17eaf4e1904)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 43 runs, 4 regressions (v4.14.232-16-gde17ea=
f4e1904)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.232-16-gde17eaf4e1904/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.232-16-gde17eaf4e1904
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      de17eaf4e19044468a3fcd2a0deda0bc240a06a2 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6093ecffc0a8fe0aa06f546a

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-16-gde17eaf4e1904/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-16-gde17eaf4e1904/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6093ecffc0a8fe0=
aa06f546f
        new failure (last pass: v4.14.232-12-g29a7f2233e906)
        2 lines

    2021-05-06 13:19:55.542000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/96
    2021-05-06 13:19:55.551000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6093ba9698822a98146f5479

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-16-gde17eaf4e1904/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-16-gde17eaf4e1904/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6093ba9698822a98146f5=
47a
        failing since 173 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6093c0dd9166b7d4946f546e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-16-gde17eaf4e1904/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-16-gde17eaf4e1904/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6093c0dd9166b7d4946f5=
46f
        failing since 173 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6093c57212f7f80c996f5475

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-16-gde17eaf4e1904/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-16-gde17eaf4e1904/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6093c57212f7f80c996f5=
476
        failing since 173 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
