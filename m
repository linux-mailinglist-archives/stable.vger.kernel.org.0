Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C53038E251
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 10:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232313AbhEXIeC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 04:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232306AbhEXIeC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 04:34:02 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9DABC061574
        for <stable@vger.kernel.org>; Mon, 24 May 2021 01:32:33 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id f22so18636481pgb.9
        for <stable@vger.kernel.org>; Mon, 24 May 2021 01:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=saf7Cdt5MVITPriwIi02Fpqg9wysdCeCFoVKgFZa1L4=;
        b=mE7rKIJZwb2OcZ2Hx7au1SWJH4QN7gM5OWWqStGA6L06XPPG5gQKTSeaZodGSzLOip
         9ubTbmGqimOj6kUjytpOCgJnmU67uGm4lhKBSRpZ4tz6ROBLHBacvxZyq6EeFG3SOA65
         Zx4mRgqQCuMYHStDjVsmEFn6cAjELw2fJI2XT6zs+Gbm4dOTRjj6aH146QLbM2OPnJbC
         XE6/6b+SLKndLrtQZ+v7hEd+TLL8/zGuEcY3anlNTLq+gnvnPOKk4H5ncVKtst+//xyI
         Rz9Z02o8h//kTbkZv47Z1X+q1lfXnf1VcGeMn7aqVWFaXlgA8QqBHJPt7GTmLqwt0fa+
         Yidg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=saf7Cdt5MVITPriwIi02Fpqg9wysdCeCFoVKgFZa1L4=;
        b=cay6rDara12g1tWzvkkgDDsrr2uUKG/Icpklyi69YYmXO6/chHid0nkE+6yb7Ht9Mc
         Z2IvJUaiB4aDDKsLJTBmkneJ41iJHR7/MZeza3J1tTR77DvpeQZSJLge80qG5IOfAJSW
         OsEMnLjSG8U6P3RKZD4jcg0SyElp2dvAl9j/g7YTDgi7Y3MKYeNKSuTzWRtmePptw9O4
         nDbEdLBoR9E1PFH0RwtK41en2qsIxHeY20+DzEjAQzUtR3o4KvyKQ4nwj22iq9KkzWU9
         9ffJ6DQ6CfUZE2E0y2fcZ6tNGYDrBsr+xiS9w54HcTMFKRujynvErSoYErdGQeU4CRPg
         F6cQ==
X-Gm-Message-State: AOAM531ukCfdTL90aPNyCOPvPEu8DxT3A7VSLySSlpfmp4fO/ALOheMv
        iPrL2cqbnfnDSvnHOLAoE6o0KmAGgmYuc8Y6
X-Google-Smtp-Source: ABdhPJwbqKkVDPU+MPUb/jdpDA7nCkoolxORc/TtyjhZ6wTXBbIYbqJYWdKuUMt3dfvOn5tMRcTfsA==
X-Received: by 2002:a05:6a00:124d:b029:2e7:d663:e5bd with SMTP id u13-20020a056a00124db02902e7d663e5bdmr8347954pfi.21.1621845153000;
        Mon, 24 May 2021 01:32:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l1sm9470565pjt.40.2021.05.24.01.32.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 01:32:32 -0700 (PDT)
Message-ID: <60ab64a0.1c69fb81.b203d.fdb3@mx.google.com>
Date:   Mon, 24 May 2021 01:32:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.190-434-g7549be3766e0
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 109 runs,
 5 regressions (v4.19.190-434-g7549be3766e0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 109 runs, 5 regressions (v4.19.190-434-g7549=
be3766e0)

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
nel/v4.19.190-434-g7549be3766e0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.190-434-g7549be3766e0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7549be3766e0a7d5ea8653bbe14a1fbd1ca0d7a4 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ab32fdb826b47caab3afc3

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-434-g7549be3766e0/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-434-g7549be3766e0/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60ab32fdb826b47=
caab3afca
        new failure (last pass: v4.19.190-433-ga1bcf11cef15)
        2 lines

    2021-05-24 05:00:41.109000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, kworker/0:2/119
    2021-05-24 05:00:41.118000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ab320db9b8e775c0b3afab

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-434-g7549be3766e0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-434-g7549be3766e0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ab320db9b8e775c0b3a=
fac
        failing since 191 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ab32197b102b1836b3afa6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-434-g7549be3766e0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-434-g7549be3766e0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ab32197b102b1836b3a=
fa7
        failing since 191 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ab4ddd179742143cb3afab

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-434-g7549be3766e0/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-434-g7549be3766e0/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ab4ddd179742143cb3a=
fac
        failing since 191 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ab3077f4bc0e022eb3afe4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-434-g7549be3766e0/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-434-g7549be3766e0/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ab3077f4bc0e022eb3a=
fe5
        failing since 191 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
