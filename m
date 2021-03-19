Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 800B8342860
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 23:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbhCSWGR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 18:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230411AbhCSWGC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Mar 2021 18:06:02 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D2E4C06175F
        for <stable@vger.kernel.org>; Fri, 19 Mar 2021 15:06:02 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id v2so4597245pgk.11
        for <stable@vger.kernel.org>; Fri, 19 Mar 2021 15:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vQqufihQLyzH+XYTptRwP1i1Iigqo1ndUxaBGhpifjQ=;
        b=YeGZmmULqOaEx1WN6Y5ySaIpbGpHUXujei3g/JIoVZZepcz4YxleJp4oPjhBHssLvj
         N5NhO5ZMuwrEkBKfJKfdlZeuWCsBTb9iv8xwzdC585nwfeFYkdsDTz++mR2FVtGObLv+
         D4/ivsw56aMLtX1KC0/+i3rwrtAtz0vo3dfN3TQw/EsrOK9zY12coM+T9kYTsab8kELr
         +jR9fKf2Dm2qX0Kp6aR0Ftz3mfNz0idNMDrmRxK5Qp6pUC0gG89q7Wj8kqk9LX/gQuD3
         wEOCiyeNsP2zQHg7v7BgP+GM8dh/w4cT3XSZshefiL7jtLFz8h1LEDubechVYUeLHgaB
         FsnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vQqufihQLyzH+XYTptRwP1i1Iigqo1ndUxaBGhpifjQ=;
        b=TeBc1GTHlp4RIMS8kYslXoNk/QRFkf8kRUtuwtCZcfZbttV4bT9TMEeDDWpbz2cPeq
         hqhIXvNQK07YVV4jWcpEIF2JsZ/oqfuFTpXh57Aa5Hs3kamZzelis+KaFCv7nCBc6oyJ
         gRKSofh1CU3zalN/669aANtEMzDW0gG1yABjETxNlS1MnjgOJBoZuzw35BVo3C4+H08A
         HVwIOAPIt6m+6Y26n6+LlZ8Zz83pl63MIUwrJDx7vGA2AesS557WMXqQpBwjuNKRH0Fv
         8GEZ4eRQBkeKsHW75MiLejgmNvDPL0ExwU8GxINj/+JG9W91VqQAUrX9g/xl4SeuAEkI
         dmpA==
X-Gm-Message-State: AOAM532ZW0pQ/FxPhoqTyiw4lAvdFO2bVIJjwsydP4vvMOxRbcS4M+iy
        qU8un6eJKk80z85btr0BQfKY404uHS9t3Q==
X-Google-Smtp-Source: ABdhPJzgdUotqvWzYKR1BZ+bnWaa7kdcqClET0/7CRqbZ16FXikSDbWIuidp0/tAx+sL25GjgH7zpw==
X-Received: by 2002:a65:434d:: with SMTP id k13mr12956533pgq.42.1616191561708;
        Fri, 19 Mar 2021 15:06:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j35sm6521363pgj.45.2021.03.19.15.06.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 15:06:01 -0700 (PDT)
Message-ID: <60552049.1c69fb81.d8293.010a@mx.google.com>
Date:   Fri, 19 Mar 2021 15:06:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.181-8-g4c32048bdf66e
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 145 runs,
 4 regressions (v4.19.181-8-g4c32048bdf66e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 145 runs, 4 regressions (v4.19.181-8-g4c3204=
8bdf66e)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.181-8-g4c32048bdf66e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.181-8-g4c32048bdf66e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4c32048bdf66ed7eee72783a569c22cea29412c4 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6054ec057cb4e7dfefaddceb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.181=
-8-g4c32048bdf66e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.181=
-8-g4c32048bdf66e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6054ec057cb4e7dfefadd=
cec
        failing since 125 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6054ebe37cb4e7dfefaddcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.181=
-8-g4c32048bdf66e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.181=
-8-g4c32048bdf66e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6054ebe37cb4e7dfefadd=
cb2
        failing since 125 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6054ebc55e109594c5addcb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.181=
-8-g4c32048bdf66e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.181=
-8-g4c32048bdf66e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6054ebc55e109594c5add=
cba
        failing since 125 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6054ebaad5e9dedbccaddcc4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.181=
-8-g4c32048bdf66e/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.181=
-8-g4c32048bdf66e/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6054ebaad5e9dedbccadd=
cc5
        failing since 125 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
