Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F30B82D6591
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 19:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390784AbgLJSvd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 13:51:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390900AbgLJSuc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 13:50:32 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE16C061793
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 10:49:52 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id w16so5046530pga.9
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 10:49:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tcAqADr3Y2eyICF7rLhGNNvifqDDSAq5LMoRV0u9Oio=;
        b=wssja4tIFf8PnJ8uxqJ/GJaw7hm+cxNGa1syC6XjPuJtWITq/FsW8rs/CLvORCaOlD
         TK6IXBowk3FWkdP3cPUx+5UGqc7+CX/q6YpVm7GniZoRQoGCv7Y43LkvCTa9CTggGYNa
         l+XYeDU5YcrzDD/8Y6H3QnbWW0Le5cYsHlkvB3kr51xQPuRaLdVf/zk1TIKR5++REArJ
         EZg4I5b+lZ97wigpgloUsCqcemGWjwYxkrbtSTp90eLadeL6MBqOxATST90MOmSVDvVi
         T9rO5XdMj5eyrIGMPV2OssBGd5GeR0f1fOey8vntp/OPfBNUMmZ1bYgFV4C7Y5FjD8VL
         sRPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tcAqADr3Y2eyICF7rLhGNNvifqDDSAq5LMoRV0u9Oio=;
        b=HnMYQ6tRY1z0TeD7+AFHfayBbHT6DDEbWdhYSrhvcxTgicgLZvQwJnhvi4KjarYKRt
         WpJiFNm8CEmK57EDRODtzFI5I80u2BZnECkEkV8G959hTzoGMaDcpRDW9vK4QxXFFs8y
         Zj3IKRM7LMqwPW1Lphc+pqku4lKGYB9LLPm54w3jCTPMbR+FHcACtKLK8gJI5pMUcnjf
         LohlbYeNapqaQAC/YAUZo6NzxWHevL2h4mYbJtEAAIZSIiCjB7eQF0Yql5EDvFQ285bl
         yA9PRxDHnWiaAF5gkaNyWnJeJPaPvsEJtFCZ4o5Xt+/q+LbUrPd+NJCzPMF4/wnriFHd
         bqMA==
X-Gm-Message-State: AOAM533s1HC6wptoxUtKsQI8l3EQdWN4yf7i6GmlduerIZ1ROHMnH2WM
        YlDSaBvx41otuBOE1OQJZNmwwfaI6Q7omw==
X-Google-Smtp-Source: ABdhPJx8NmhX4BdKoQXYVG1/WDAjg0lBg/uJyUvPHRL5X+3dAr+F06qvIMiZICxNMowMVRA7ZCt11g==
X-Received: by 2002:a17:90a:4142:: with SMTP id m2mr9306889pjg.156.1607626191337;
        Thu, 10 Dec 2020 10:49:51 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r68sm7224295pfr.113.2020.12.10.10.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Dec 2020 10:49:50 -0800 (PST)
Message-ID: <5fd26dce.1c69fb81.70d22.d73e@mx.google.com>
Date:   Thu, 10 Dec 2020 10:49:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.82-54-g1eabd0fdb4d4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 179 runs,
 7 regressions (v5.4.82-54-g1eabd0fdb4d4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 179 runs, 7 regressions (v5.4.82-54-g1eabd0fd=
b4d4)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
hifive-unleashed-a00       | riscv | lab-baylibre  | gcc-8    | defconfig  =
         | 1          =

meson-gxl-s905d-p230       | arm64 | lab-baylibre  | gcc-8    | defconfig  =
         | 1          =

meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre  | gcc-8    | defconfig  =
         | 1          =

qemu_arm-versatilepb       | arm   | lab-baylibre  | gcc-8    | versatile_d=
efconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-broonie   | gcc-8    | versatile_d=
efconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-cip       | gcc-8    | versatile_d=
efconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-collabora | gcc-8    | versatile_d=
efconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.82-54-g1eabd0fdb4d4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.82-54-g1eabd0fdb4d4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1eabd0fdb4d4654b81257706f71566d500ba64f9 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
hifive-unleashed-a00       | riscv | lab-baylibre  | gcc-8    | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd23b45c65574bde5c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-54=
-g1eabd0fdb4d4/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-54=
-g1eabd0fdb4d4/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd23b45c65574bde5c94=
cba
        failing since 20 days (last pass: v5.4.78-5-g843222460ebea, first f=
ail: v5.4.78-13-g81acf0f7c6ec) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
meson-gxl-s905d-p230       | arm64 | lab-baylibre  | gcc-8    | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd23a89db0f44d424c94cce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-54=
-g1eabd0fdb4d4/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905d-=
p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-54=
-g1eabd0fdb4d4/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905d-=
p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd23a89db0f44d424c94=
ccf
        new failure (last pass: v5.4.82-39-g91f8eb162536) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre  | gcc-8    | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd2392846aae39dccc94cc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-54=
-g1eabd0fdb4d4/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905x-=
khadas-vim.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-54=
-g1eabd0fdb4d4/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905x-=
khadas-vim.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd2392846aae39dccc94=
cc7
        new failure (last pass: v5.4.82-39-g91f8eb162536) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm-versatilepb       | arm   | lab-baylibre  | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd2398a7edaf6388cc94cd9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-54=
-g1eabd0fdb4d4/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-54=
-g1eabd0fdb4d4/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd2398a7edaf6388cc94=
cda
        failing since 26 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm-versatilepb       | arm   | lab-broonie   | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd239ba8012ff90b9c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-54=
-g1eabd0fdb4d4/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-54=
-g1eabd0fdb4d4/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd239ba8012ff90b9c94=
cba
        failing since 26 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm-versatilepb       | arm   | lab-cip       | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd2398ac2d6809569c94cc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-54=
-g1eabd0fdb4d4/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-54=
-g1eabd0fdb4d4/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd2398ac2d6809569c94=
cc1
        failing since 26 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm-versatilepb       | arm   | lab-collabora | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd239478cd0d440c0c94d07

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-54=
-g1eabd0fdb4d4/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-54=
-g1eabd0fdb4d4/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd239478cd0d440c0c94=
d08
        failing since 26 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =20
