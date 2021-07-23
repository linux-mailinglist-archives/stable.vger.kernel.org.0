Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87EE93D409D
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 21:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbhGWSiB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 14:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbhGWSiB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Jul 2021 14:38:01 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE082C061575
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 12:18:33 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id i10so1084432pla.3
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 12:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kqRJfSJFghyM7Mv02cNq1EVuWLacDgHAX/gzWo1bepM=;
        b=jljMiS47QfnBmYc5RsLecuttOynKu6zealudQY8oBMpNqjq60BOrzlY5nOPLLrQoQP
         XCFdMbLC3aMaALKUEeGmTHsSFmyw0vq0dUPEiSIiqS89W/nqewI800TyIwNdh4dRbCcK
         tj0pd+ThS5wE3rug0AoMAGJG28S+0H7DEWKmdL4lGHuD2OVd0y2Eu8vaL027WAdHFiBK
         i8qVwk8x4zasc9owEKEA6MxJ9uQVAkxgSehO890LzXOBgeN/2zr5N8clTUiGCh7JRe5Y
         yssvd+ARMXVHPuC/I2v5azdF3W+f8On2+qGNv/uXSG/LX+JVJd8pEDhrFtEeJlv+0xlR
         jY3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kqRJfSJFghyM7Mv02cNq1EVuWLacDgHAX/gzWo1bepM=;
        b=N8bGPI4w3xulGAQeQmHvXnlXfEW+LIEQYmJny//aKEa+D+uFt58hp9ESo0epHXSRfN
         soAvVr2G2LozD/VN5pBn8X4Im+T+z2seLzXUhPkXt7fGZgzdEP/umlzJnFOryeqWdZsj
         ERxe//3LXohfLBz+YFUcxdtAEAr0RBwXu69gOQEsRAm2Opy++6SXyADNQY5eCXji9qR1
         2IoAXrjBkOGRTohaKg4ACXI7bvhyOfu8rx5gpbH16BE7s1sYOMoegMYoyA5d89cfSrR4
         GvYcLU+sT8hpj5nRYODQxUTlDl9I7l273QmyFjbFJxHIV7arqA9DC6l61nMi9vlWgw1z
         xRsQ==
X-Gm-Message-State: AOAM5332jK97t5zIgFrx+fiFHQJHiHeNe84zoS+9GEsHq+nf31h7pR7R
        Hl64cIATOV7s1Mx5d+Vut0Bf1G9ySlF2bOze
X-Google-Smtp-Source: ABdhPJyn2jbdqESHdHc7pxpQLtcUR7SDlHxBVQiAe8hSvdRsdCEIT5+BcpdLcaMCHTt9IG6TVXKFdA==
X-Received: by 2002:a17:90a:f682:: with SMTP id cl2mr1867995pjb.166.1627067913201;
        Fri, 23 Jul 2021 12:18:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j6sm38905029pgq.0.2021.07.23.12.18.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 12:18:32 -0700 (PDT)
Message-ID: <60fb1608.1c69fb81.4226f.7e13@mx.google.com>
Date:   Fri, 23 Jul 2021 12:18:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.275-270-g1fa85228ca7e
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 118 runs,
 4 regressions (v4.9.275-270-g1fa85228ca7e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 118 runs, 4 regressions (v4.9.275-270-g1fa852=
28ca7e)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.275-270-g1fa85228ca7e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.275-270-g1fa85228ca7e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1fa85228ca7e69f8a70c409fde4dbdb69f8dedde =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60fae5f82aca5370a23a2f43

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-2=
70-g1fa85228ca7e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-2=
70-g1fa85228ca7e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fae5f82aca5370a23a2=
f44
        failing since 251 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60faeb8024d10381c13a2f3e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-2=
70-g1fa85228ca7e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-2=
70-g1fa85228ca7e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60faeb8024d10381c13a2=
f3f
        failing since 251 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60fadc42934f538d883a2f38

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-2=
70-g1fa85228ca7e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-2=
70-g1fa85228ca7e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fadc43934f538d883a2=
f39
        failing since 251 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60fadbf35dadd06da23a2f47

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-2=
70-g1fa85228ca7e/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-2=
70-g1fa85228ca7e/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fadbf35dadd06da23a2=
f48
        failing since 251 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
