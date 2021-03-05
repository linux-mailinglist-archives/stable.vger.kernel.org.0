Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3267832EC95
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 14:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbhCENzn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 08:55:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbhCENz1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 08:55:27 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15D0AC061574
        for <stable@vger.kernel.org>; Fri,  5 Mar 2021 05:55:23 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id t26so1418424pgv.3
        for <stable@vger.kernel.org>; Fri, 05 Mar 2021 05:55:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2QduAiAVdRfXZhiRD47z20oGnh3mUdpew7Aolu0Calw=;
        b=sxRDKE8MJ85OUCteSBOPH1yAGB5Q14fvClHGbC0Omnv0I4N3fs25+N64TaXmxDPfLA
         ebCqJ1zT3pedZ6RTz9deXdF6sMKe3QuhkDiWJKAlXJ+Yqa6qRWFNtUKAJaa5P++35fKq
         YGoIH8l3ckZYfV3I2vuGEBEVjCH4i7rFw6HhOhDDtk6X9kEnpdKJbmHgQeHoOrDJMG+y
         i7HpSnmpMjhXzAiq/Y+t9SygfmzVcf/tBLFekzL0nMlxPneSx5qCOOy+3Sp1JFPsS/0O
         42mqnNDsd++Aj/V6duYHPnEYMAWX5EhvRxuyN6KmEuiC/t6cZiQYBJv93irY/5h4kSIz
         6pUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2QduAiAVdRfXZhiRD47z20oGnh3mUdpew7Aolu0Calw=;
        b=YnqeRWjC6z+jjvsHMtVdF98rctViyqtd3f8Li/Q47QQltUzkeiqIK830iBnejYquml
         K0G+DuCAa8uqZl8wpMpAi+OvDIvBfzuYpLArmEZTQtQuwluv/zDQKjZASsMiIUGmOwg0
         nXcNv+X+X8NoDgfIA6y0mjR3z31axEjwyh3YzDjaVFkZz13uhEz4iUnQPPbNw00vw9rV
         LUoT1Q1SbS9M0NetngfJZj7KvbNQdZeeKpnHVrTCwJfbw49MHYcMCutlDI9te7tgL2O4
         7jL2w+v8s1wChghS1iMVMM/iy5epuIx+3m3K/0zd/Vci8A8i0i41e1L3xtvjXWCoQTnw
         iHlA==
X-Gm-Message-State: AOAM530hA7YD776t+jeh+DeFbydW2TFvwF0cL1Lqsa3ImvciDVtx3J5n
        e5qXrBIrY85Le6a/3GBkGc2E3UyR8TtIDIIQ
X-Google-Smtp-Source: ABdhPJy7eU73gjxAEuo4DQ38JMmh7S0PCrMMqLAdXtDTtG6ARoBA8iX5ZNk4FmKUVaMceKZw/CHMYg==
X-Received: by 2002:a63:f318:: with SMTP id l24mr4509589pgh.263.1614952522311;
        Fri, 05 Mar 2021 05:55:22 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r10sm2072316pfq.216.2021.03.05.05.55.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 05:55:22 -0800 (PST)
Message-ID: <6042384a.1c69fb81.a360.384f@mx.google.com>
Date:   Fri, 05 Mar 2021 05:55:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.259-40-g91eee48a63dd2
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 94 runs,
 4 regressions (v4.9.259-40-g91eee48a63dd2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 94 runs, 4 regressions (v4.9.259-40-g91eee48a=
63dd2)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.259-40-g91eee48a63dd2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.259-40-g91eee48a63dd2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      91eee48a63dd236080e1b86a0033f1746d1db2d7 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60422ed5704282a1f2addcb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-4=
0-g91eee48a63dd2/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-4=
0-g91eee48a63dd2/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60422ed5704282a1f2add=
cba
        failing since 111 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6042158336fd31736baddcb7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-4=
0-g91eee48a63dd2/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-4=
0-g91eee48a63dd2/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6042158336fd31736badd=
cb8
        failing since 111 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6042054de402945634addcca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-4=
0-g91eee48a63dd2/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-4=
0-g91eee48a63dd2/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6042054de402945634add=
ccb
        failing since 111 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6042056257ba605274addcdc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-4=
0-g91eee48a63dd2/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-4=
0-g91eee48a63dd2/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6042056257ba605274add=
cdd
        failing since 111 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
