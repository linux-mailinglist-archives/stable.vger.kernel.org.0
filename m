Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A119636A9E1
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 01:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbhDYXni (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Apr 2021 19:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231247AbhDYXni (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Apr 2021 19:43:38 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B22C061574
        for <stable@vger.kernel.org>; Sun, 25 Apr 2021 16:42:57 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id w6so23229793pfc.8
        for <stable@vger.kernel.org>; Sun, 25 Apr 2021 16:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5JpKN2a++Mnj7ZhsFrgsHjs8KZ+Qjcj2DxOGR8qn4wA=;
        b=WJocaedsDiUC/N7vlEtPzg/QO+20WNljX+cGkF22LlKecWB8J/ZnHesy2m/qyVknUi
         wwqRMAGHH57+qjrkkoEn0QP44UT0eZdoPcwreR10rGnf0+OyocRkhJJANbDD7xdKwM+w
         4KsMWAs5KXFu6tGrzhBzn5d6oIRQrimfB90WnlmCUP5oPNTYBhN8RHCy8EC/Xv4oGTd5
         /j378Z5zrFclNCfn09cb7rTnAFfVWnxdpgjLz9ODisGqzRQKub5VTMXwV5EOPBjJxRtN
         wF4nWJKr5XrWTxKIFLenwu0DhNIjWPfiGzDoTFRqZj5kR0xaAgzc03v7fbimtfUoawPO
         9xzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5JpKN2a++Mnj7ZhsFrgsHjs8KZ+Qjcj2DxOGR8qn4wA=;
        b=MaliwehT7tb+1lBGVrS0HRU2lursGuxALQB1PjrQg/36iZggp5SkT7XQpvwftxs30n
         llgWFWw3hMdxZf7ydXho6N0qpeaMubaqu7Mo4OjW/Z+8DHWPrKr0fF4gEUzLmRpCjz8l
         GOOeHkUdUm/6ekXCeOvkD53+qdLXDabFs4brnztYc/9htMQbd5zTACIAFsv6ymUV0ffR
         KFikKBvuTmMYar0A3SQOv491PLH9GMoy16RQUAOqgBeWU0jT+ry7oBeIW0Mhj2gxDJTK
         yLoWPU0m304j/9UoMgWn++43T11407thk+y8ynq9cxg+zU5tNwQPlppqvV8+w56hbcQh
         SoTw==
X-Gm-Message-State: AOAM53187aZRhV+FxNtWwsRmr1EsDV/BACbeiANVL3T71XXwgbfJi6ag
        WPPPSAODdEoE+bIQ2qRqH0cr92omR0cH6sVC
X-Google-Smtp-Source: ABdhPJxawI4q6X3wWtPffFL56iNhkQU7V0mfWpfgYukt7RQd9JhCxgd2HIus3llFPBQQOK4D4ycVBQ==
X-Received: by 2002:a62:6481:0:b029:249:ecee:a05d with SMTP id y123-20020a6264810000b0290249eceea05dmr14866119pfb.9.1619394175571;
        Sun, 25 Apr 2021 16:42:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k11sm13212178pjq.47.2021.04.25.16.42.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 16:42:55 -0700 (PDT)
Message-ID: <6085fe7f.1c69fb81.c11a2.730a@mx.google.com>
Date:   Sun, 25 Apr 2021 16:42:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.188-44-gbbed64df7fefa
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 148 runs,
 5 regressions (v4.19.188-44-gbbed64df7fefa)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 148 runs, 5 regressions (v4.19.188-44-gbbed6=
4df7fefa)

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

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.188-44-gbbed64df7fefa/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.188-44-gbbed64df7fefa
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bbed64df7fefa5e00759e56456b38ad8aee3897f =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6085c7578ccd892ab09b77ba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-44-gbbed64df7fefa/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-44-gbbed64df7fefa/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6085c7578ccd892ab09b7=
7bb
        failing since 162 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6085c75f8ccd892ab09b77bd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-44-gbbed64df7fefa/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-44-gbbed64df7fefa/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6085c75f8ccd892ab09b7=
7be
        failing since 162 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6085c7974980c1308e9b77c1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-44-gbbed64df7fefa/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-44-gbbed64df7fefa/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6085c7974980c1308e9b7=
7c2
        failing since 162 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6085c7282c7c70c1529b77cf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-44-gbbed64df7fefa/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-44-gbbed64df7fefa/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6085c7282c7c70c1529b7=
7d0
        failing since 162 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6085c70f7275016f889b779d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-44-gbbed64df7fefa/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-44-gbbed64df7fefa/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6085c70f7275016f889b7=
79e
        failing since 162 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
