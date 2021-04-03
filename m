Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91F4C353448
	for <lists+stable@lfdr.de>; Sat,  3 Apr 2021 16:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236380AbhDCOOd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Apr 2021 10:14:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231755AbhDCOOc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Apr 2021 10:14:32 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB6AEC0613E6
        for <stable@vger.kernel.org>; Sat,  3 Apr 2021 07:14:29 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id j25so5335334pfe.2
        for <stable@vger.kernel.org>; Sat, 03 Apr 2021 07:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=t6xfE9Jw/NzldKd1tPeE/erjf54QNOZfbehAsfQzAY8=;
        b=0iU1GLfZov4Dy8NCQEW7dbs2UGKFOFxSmbaUnrkUr160speeAghts9pYbNJ7QKS1Sm
         OecDZOiSu3GlTJ6CcB1+djG9FuVZlFv8t8UAiQSC1h6izgld26EP1wbrNRTSJj448vas
         5ibGEoLYnwpDX34oz1anHwk6m5JBHCl3uptA4Tms5n9w8sqBL1APxvHafG7xGSDgri/D
         diwqtsTSLlfAV7b8AFjQ5tiKwWt/qyz+q719A/pUCh+C1W20SUF3UbgBCEBmw90P2xjX
         FX/M3bLn/Wte8+gE8tjq4PEmAHCUVQ7eMuYz8OpQSYFwhP0l+BIX05h2EIwnH8wmAJe8
         jrKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=t6xfE9Jw/NzldKd1tPeE/erjf54QNOZfbehAsfQzAY8=;
        b=T5LYaUq26asMHntJuAHjKESLTyouvbWMX+BAopRvFEDu7cBMEmr3a3gi2ShMVGpvaF
         Vhnp7JKhoX5xBksLLrGnzbutWRdLJV1g2LRKpbldfla9eRnKpta2y/nZ6my6GfmuHcLK
         oDlam//yoT8O/IvMc6j7lrAST3mIeIc6O4t3ITpITbFatbm5G+9iP7YX64RRZOfIswEj
         nYMyCNEBgALOVGdbhlXt4CR5clDXxHee9Pd9v2evbD4sG2+hSGvCwjDZuQokUjkQKPu+
         OouFZKOkS+vI1FG5gb691gqXCLN5sfmhN+yVvn6iiTMnSqZBTmrHAhhcpv3URuS6Lp0u
         CXeA==
X-Gm-Message-State: AOAM531jAAHswF7xFNV3YV6OrNHh+B3JlrHCe7LCTrnPSjNeprNI/r3O
        Lics/MddGPPa9S5HSDmACu/aA2ArysbKt6Wp
X-Google-Smtp-Source: ABdhPJxqlXf5hy4+Cz8rw9CAzrstiMzS5R1YfH+N9+6Ad6hiGRnvEbBdMh6cDTGYyOXbU8aPidj6CQ==
X-Received: by 2002:a63:dc49:: with SMTP id f9mr15742307pgj.361.1617459269285;
        Sat, 03 Apr 2021 07:14:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i4sm11490601pfo.14.2021.04.03.07.14.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Apr 2021 07:14:29 -0700 (PDT)
Message-ID: <60687845.1c69fb81.63fe4.c93e@mx.google.com>
Date:   Sat, 03 Apr 2021 07:14:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.264-23-g7fcf501baf34b
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 89 runs,
 5 regressions (v4.9.264-23-g7fcf501baf34b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 89 runs, 5 regressions (v4.9.264-23-g7fcf501b=
af34b)

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

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.264-23-g7fcf501baf34b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.264-23-g7fcf501baf34b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7fcf501baf34b4f008d75b5e334be7455cc56176 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60683e803b60c1b567dac6c2

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-2=
3-g7fcf501baf34b/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-2=
3-g7fcf501baf34b/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60683e803b60c1b=
567dac6c9
        new failure (last pass: v4.9.264-15-g73f542b1b5bc)
        2 lines

    2021-04-03 10:07:56.990000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60683dfd4e306af4fddac6c4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-2=
3-g7fcf501baf34b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-2=
3-g7fcf501baf34b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60683dfd4e306af4fddac=
6c5
        failing since 140 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60683e014e306af4fddac6ca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-2=
3-g7fcf501baf34b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-2=
3-g7fcf501baf34b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60683e014e306af4fddac=
6cb
        failing since 140 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60686f0f94de1321f4dac6bc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-2=
3-g7fcf501baf34b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-2=
3-g7fcf501baf34b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60686f0f94de1321f4dac=
6bd
        failing since 140 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60683db4f1ea0c9a83dac6e1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-2=
3-g7fcf501baf34b/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-2=
3-g7fcf501baf34b/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60683db4f1ea0c9a83dac=
6e2
        failing since 140 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
