Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF5438F12E
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 18:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236268AbhEXQKx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 12:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238827AbhEXQKX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 12:10:23 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57500C00F7C6
        for <stable@vger.kernel.org>; Mon, 24 May 2021 08:52:13 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id c12so9568465pfl.3
        for <stable@vger.kernel.org>; Mon, 24 May 2021 08:52:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EXzVdl8Y6Gc2L+gPqicwAwmq6wPKuJUkey9GmwmAG9A=;
        b=LEVC9WcsbC5y2Bde1bLLib5+RoO2eX9QR5PpXmiErDCBPhC/9Md+aqH8hjj6p5A9dE
         Vk5GYsMBQOFQwyeQlGQm4C+ZKmyqDm+Yw5sI5c6Pw79JGA5vXFwekeC5nNwVVmSg1gAG
         60IgOguFxZoHknqZhwN0LAih0QMXVvio96IXWZ1KhL4fKdBNZH8hs8NWj4pZp8lAUQWq
         o6a11pBp/uAe1/KL97LYEsdhrsLsDJsqnXC+//wr/nTkOo2U8MSULSYx0taNHezoPg3V
         VPDTYOO/pHBRrQUPVJcYMtYzBIag9PQqdiKaugPHB3EYEoK4y+0ssuV8G4QLvAK2eP1P
         Ml/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EXzVdl8Y6Gc2L+gPqicwAwmq6wPKuJUkey9GmwmAG9A=;
        b=ICuYfgT21+u21S2yEnBLGg0Z8QfwlRn56esSSsKX3MVmUvHYC5RoZwRE1/SkkFm/cC
         jWvszJY9oDlDx9zO2sf3fxPRPZ3FdF88Q3WjoDPuuQqbl5PUlS9wbi/zQPeSLxTl8TZp
         LcLd4FaYOMajafLSutQWub2ysVzS/HhpxogtqB2a8gkqxPRL1mfPOW8AbTtAmHSTt1vP
         ZHctXXVzU1T1xu5xLMjjedsaOOlnb3mg5vqKv7wfUvcPa2fwdh11pYS7mkUxFOrw8Dul
         Vmz2M/0TRoyKRbMZA41LV9hunJU7FEY92kxYaOcJ4RLOCA8UuqBz6bU+JlokyC2anxQx
         PNyQ==
X-Gm-Message-State: AOAM532chGjT8kXLpuov4+eZAjSlq/iodhJcREBd6m1jd5+2eV26Awu2
        2KpDu+W/8zid7NAvD+1uthdoy5FLYrm8Q1GX
X-Google-Smtp-Source: ABdhPJytiC6ATBmUMq6lCiEEfcBQOZdF3I/GOyb+FKoa2hVXkPhaanOAFl+sa3ys144X5YUICph8LQ==
X-Received: by 2002:aa7:938f:0:b029:2de:2cf2:6a27 with SMTP id t15-20020aa7938f0000b02902de2cf26a27mr24883657pfe.47.1621871532567;
        Mon, 24 May 2021 08:52:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 5sm14816386pjo.17.2021.05.24.08.52.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 08:52:12 -0700 (PDT)
Message-ID: <60abcbac.1c69fb81.80cd1.1724@mx.google.com>
Date:   Mon, 24 May 2021 08:52:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.191-42-gb3097465a7ae
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 95 runs,
 4 regressions (v4.19.191-42-gb3097465a7ae)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 95 runs, 4 regressions (v4.19.191-42-gb30974=
65a7ae)

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
nel/v4.19.191-42-gb3097465a7ae/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.191-42-gb3097465a7ae
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b3097465a7ae9f77275383e7776de3ec239460c8 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ab9aecec9317fd6eb3b008

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.191=
-42-gb3097465a7ae/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.191=
-42-gb3097465a7ae/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60ab9aecec9317f=
d6eb3b00f
        failing since 0 day (last pass: v4.19.190-433-ga1bcf11cef15, first =
fail: v4.19.190-434-g7549be3766e0)
        2 lines

    2021-05-24 12:24:07.388000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, rcu_sched/10
    2021-05-24 12:24:07.398000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ab98ccd4141b6df4b3afa2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.191=
-42-gb3097465a7ae/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.191=
-42-gb3097465a7ae/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ab98ccd4141b6df4b3a=
fa3
        failing since 191 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ab98b5f63019423ab3afad

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.191=
-42-gb3097465a7ae/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.191=
-42-gb3097465a7ae/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ab98b5f63019423ab3a=
fae
        failing since 191 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ab9db40717223d27b3af9f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.191=
-42-gb3097465a7ae/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.191=
-42-gb3097465a7ae/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ab9db40717223d27b3a=
fa0
        failing since 191 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
