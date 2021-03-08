Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA22B331753
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 20:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbhCHTb5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 14:31:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231506AbhCHTbp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Mar 2021 14:31:45 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 284D8C06174A
        for <stable@vger.kernel.org>; Mon,  8 Mar 2021 11:31:45 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id mz6-20020a17090b3786b02900c16cb41d63so3736088pjb.2
        for <stable@vger.kernel.org>; Mon, 08 Mar 2021 11:31:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HFAWhlqOAv40i46NYBu4+mWoYGXBT2ESedbOp3BuO5I=;
        b=xWQRzAKzfxR28BHsOjEnGZDnYaBojWLGCRflQqhLmaJKW8v1LSPAZdFBFpwI3DYYK1
         c1QIA5qGVspTzAqJssFk7ULRMe49D637QJEauzKi35ZcIZrSWsb1rwUCtGopNGUR72Tx
         lC2fFjffiw5YAflGL2bE63QmiluJQOOzitdRO54SfMU6/DLG3qO5hxK6ERbVkcHXlRaL
         K5XfV1FGviZ4nIBdtPJyW9m24RYMtqKATxufCVvV4sXrWvkSoD1SXSEX8l7lpuSrEWJ2
         9vJ9Rc03OIbXkEc7A5+ou4FMQkDAsC3PlzeCOqJmD2ZE1wmgNrb0XGXA7Ruya7CnZAL+
         IRQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HFAWhlqOAv40i46NYBu4+mWoYGXBT2ESedbOp3BuO5I=;
        b=qlI42LyMHj9xSWQgsgVthLSa/GUZUoZRDbOH0eyRBC7S+5blo72iRdoUrVAoBIh27s
         MKIX+A2Fp9BF9eYDEG1MbmNogAtK8zow3yOlZd3dbhdyJn+9QcM1KzAHnt9wDqN4UmPs
         V/BUkWvI0uMIy0oV6KCKCKVx/iwJ5vR6SZIJWjQYfdKnhGypN1y0z1vOf+KRHqbG0gIT
         Xp33wzGFVARejccrLqoDqvD/GBNnU/IjNISRPIBpWyNCMmi2n7ct949F75grVlVOGKXl
         zGxP472QaSmd665YOH2FQAbrsFy048xGcyNAqadcCZaIy977JWIiwWi2ArZQ0x5Qt9ZE
         0VWA==
X-Gm-Message-State: AOAM533KLp2TjI5d8FB5rjkb9gT2g/fepAEdGXchMXtN8kxFtJrdw5ZJ
        Jy2D3xa+f/DLqnAhWuZ75FafIcYfunaoSjcE
X-Google-Smtp-Source: ABdhPJxTdlrpqdFV+qZZ1zA+rSb6q/Tuohn1S4PITI8iV7c0ILFieuc5ULxi56P1mQcQDVCtDGBy7A==
X-Received: by 2002:a17:902:f1c2:b029:e4:6c23:489f with SMTP id e2-20020a170902f1c2b02900e46c23489fmr464314plc.62.1615231904495;
        Mon, 08 Mar 2021 11:31:44 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t10sm162303pjf.30.2021.03.08.11.31.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 11:31:44 -0800 (PST)
Message-ID: <60467ba0.1c69fb81.f90e7.0ad9@mx.google.com>
Date:   Mon, 08 Mar 2021 11:31:44 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.179-20-g3db9265bc3729
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 143 runs,
 4 regressions (v4.19.179-20-g3db9265bc3729)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 143 runs, 4 regressions (v4.19.179-20-g3db92=
65bc3729)

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
nel/v4.19.179-20-g3db9265bc3729/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.179-20-g3db9265bc3729
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3db9265bc37296053b9a102a65f409d104386db6 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604646a531c9d0210baddcf0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.179=
-20-g3db9265bc3729/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.179=
-20-g3db9265bc3729/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604646a531c9d0210badd=
cf1
        failing since 114 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604646983f015653f6addcc5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.179=
-20-g3db9265bc3729/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.179=
-20-g3db9265bc3729/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604646983f015653f6add=
cc6
        failing since 114 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6046468489c01e3028addcbc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.179=
-20-g3db9265bc3729/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.179=
-20-g3db9265bc3729/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6046468489c01e3028add=
cbd
        failing since 114 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604646454277b50418addcbb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.179=
-20-g3db9265bc3729/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.179=
-20-g3db9265bc3729/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604646454277b50418add=
cbc
        failing since 114 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
