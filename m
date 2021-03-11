Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA150337C73
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 19:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbhCKSXf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 13:23:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbhCKSXL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 13:23:11 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B16DC061574
        for <stable@vger.kernel.org>; Thu, 11 Mar 2021 10:23:11 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id z5so10633458plg.3
        for <stable@vger.kernel.org>; Thu, 11 Mar 2021 10:23:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dTm2l/h+j8QquBZ7R0yrBA+ke6tLvSgfaDEb2O77b1Q=;
        b=vGGIBM++dM6oH7E4T1Gae37cs5oIrm5I8A9WsgB6NrFJY/AY+KA+egwxoIBNUT99q+
         z5OvwcOQHPoU4673gZsW/hu6Y+88lqPdsu+HEzOAtEkbTPyKLSngJW72DQ65g+7jJy/k
         oRrQbriq2RJun1Le2usG+HkP70CPLQeYlpmYDyyLlg0XMsdrgVfUaQKCOxzYnHfZArZj
         ueop9MKXwKGPTmjmPry1EV8dAbsNpxCSK9scFxNyWoJ5gKaYKjS0XFEAVDoU5vaQlz0B
         ISVxlYBDGFeBJXY6leCAEcMdbc15Fhwfc1Sj1PZ4Dl9n6Q6EmfTTCijh6NgYsfVuuKl2
         jRdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dTm2l/h+j8QquBZ7R0yrBA+ke6tLvSgfaDEb2O77b1Q=;
        b=oWdM596u6hmZ9hWYIH7U8JNmbgfDFvVeBUN+9nBAdNfHftuVa0SyJ/VSVO3OPR9j6H
         240iBNZw5cfm7fbr9GW8g1bmmgvKN0LTxG9aIyyg6xT8gQZjR+syo0o+odzDrhkDaNXs
         2MRLqqFx6rGwnhjm5FyH22o540fVexh1325igUiKyyGrIrAxeU76SmVimqFj/v9I1JA6
         vNRAnF4OehZvS1Efz0ptsXOeeDZ3KgboDIUVTZW/1/Aky3pTZx7h9hE5mzC7Co2oC3pd
         G6ncj31OR+EIV8CpaYAVdZtifAqSvVGOVputYzgepmiiuQn8M3uxku1X3OKAsfIPn5c8
         uxVA==
X-Gm-Message-State: AOAM5324XIVw7wE7yMPUiE92LbXpw+6psLIaL0BteEV3grCow4VGTkse
        3MWNJylETO9vdPGjTta9N/l3we+6jRcXps7A
X-Google-Smtp-Source: ABdhPJzq6Q8KpeZXWMOtuxtpAai+2p7tJa55lMQuPY7Q9wNJryK26CedYucb5oq9g56w/M1ha1AuUA==
X-Received: by 2002:a17:90a:de06:: with SMTP id m6mr9755197pjv.184.1615486990480;
        Thu, 11 Mar 2021 10:23:10 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b10sm2939992pgm.76.2021.03.11.10.23.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 10:23:10 -0800 (PST)
Message-ID: <604a600e.1c69fb81.7be2f.7c75@mx.google.com>
Date:   Thu, 11 Mar 2021 10:23:10 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.225
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
Subject: stable/linux-4.14.y baseline: 72 runs, 3 regressions (v4.14.225)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 72 runs, 3 regressions (v4.14.225)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.225/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.225
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      c7150cd2fa8c831c8a2ddd27bce3ac2a3372c93d =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604a2a9e230419006faddcbb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.225/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.225/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604a2a9e230419006fadd=
cbc
        failing since 112 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604a2a6fb0c1abe52aaddcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.225/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.225/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604a2a6fb0c1abe52aadd=
cb2
        failing since 112 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604a2a1861e23f56d8addcd4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.225/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.225/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604a2a1861e23f56d8add=
cd5
        failing since 112 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =20
