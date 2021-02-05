Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 679E63111FA
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 21:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233108AbhBES2e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 13:28:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbhBES1c (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 13:27:32 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3BFBC061756
        for <stable@vger.kernel.org>; Fri,  5 Feb 2021 12:09:16 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id o63so5309291pgo.6
        for <stable@vger.kernel.org>; Fri, 05 Feb 2021 12:09:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FsdFLKBOJ35/3q7S2gLx9ElNdHrRh+DB7tTf52OeGHU=;
        b=N1UYbhPqVVrF4PZzblsNaziVzCZrKiKwpe2xzfy+MwE24x+87/aVc1P/FFnWB18Ciw
         Wd6a/KliA7hEfnz67XA012OxWn+34zbOsistdYdeSK5UsNXYbacaLbSBvk58aP0Kke8R
         p6OkZ0yKFrIWIM9FYnJFBacb83cAP/3z72OYuEBD4UzScMgP04ypKXn89zWHlZpu0hVZ
         Di/Z+ejXECSJZZyeFVxMBvnXWwi628GoNdylScCn+mluEGGaCJ5QarbKmS4Q3c+ugBbK
         uYRsVuLVLvhm9IwO2jGrZNvd7FePWj/nh/6TRE5r9zw7NBbUHvC0wRUFqD4JeNSqy+NW
         5nWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FsdFLKBOJ35/3q7S2gLx9ElNdHrRh+DB7tTf52OeGHU=;
        b=JiQ1nZ73c+xIkF9QgxDzu8aTjrWe3y7kT1HszD13gDqyOEMrPvR4/rKw6OyKQaD6l2
         TH6MXOvCoJ9OnqPwS9ERXTUpzit4N8cvSK5+sR6kxroxDCI1nX/VD6twpKDRupvW7x5k
         YMBxgI2cY/ZIcv8EI4fBgy7T6PBudNB/NYhE1OjRb6GQIcS5ukTDCIWr+1V9A1sHcGkq
         gW0/qjbYke0FKlzNJc3ztn89YPGJpzch86Z91FIYFoZ7v0BLL5wvWoGcYJUvDfy5V4EH
         U2+qLlRb+552rQhK0nIDeMzC9EoKTjW/9HsVlb9DEv+8Ke+t1n6J/0eTw5KMx9aAhoJB
         TP0w==
X-Gm-Message-State: AOAM533VQG0z3kGSGVtgcOb1MaBy6qdVoKn8IrzZ9Fk9uj/7kPiL+xz9
        YXbdlqPz0Stild8ua2xHwELmbb+VQV5ZMA==
X-Google-Smtp-Source: ABdhPJz0JoNZOcHOFLV9GP/Qe3OIYDoh5Xq7dLSOrDVkFAOAUHhxpoHFNl9OSw6q4rVwkw0GB2QEvw==
X-Received: by 2002:a63:d256:: with SMTP id t22mr6014146pgi.351.1612555756092;
        Fri, 05 Feb 2021 12:09:16 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k9sm8862490pji.8.2021.02.05.12.09.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 12:09:15 -0800 (PST)
Message-ID: <601da5eb.1c69fb81.656f8.3368@mx.google.com>
Date:   Fri, 05 Feb 2021 12:09:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.173-18-g7a4e5f94ac6cc
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 124 runs,
 4 regressions (v4.19.173-18-g7a4e5f94ac6cc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 124 runs, 4 regressions (v4.19.173-18-g7a4=
e5f94ac6cc)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.173-18-g7a4e5f94ac6cc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.173-18-g7a4e5f94ac6cc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7a4e5f94ac6ccb0ba6023c08e97db26a20dc7dd6 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d6d743b112217193abe6b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
73-18-g7a4e5f94ac6cc/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
73-18-g7a4e5f94ac6cc/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d6d743b112217193ab=
e6c
        failing since 79 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d6dbb1539fa27993abe6e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
73-18-g7a4e5f94ac6cc/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
73-18-g7a4e5f94ac6cc/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d6dbb1539fa27993ab=
e6f
        failing since 79 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d6d763b112217193abe77

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
73-18-g7a4e5f94ac6cc/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
73-18-g7a4e5f94ac6cc/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d6d763b112217193ab=
e78
        failing since 79 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d6d40bb3c7314d83abe8e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
73-18-g7a4e5f94ac6cc/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
73-18-g7a4e5f94ac6cc/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d6d40bb3c7314d83ab=
e8f
        failing since 79 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =20
