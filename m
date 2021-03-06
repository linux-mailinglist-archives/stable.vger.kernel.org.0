Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 501F232FDAA
	for <lists+stable@lfdr.de>; Sat,  6 Mar 2021 23:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbhCFWEr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Mar 2021 17:04:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbhCFWEP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Mar 2021 17:04:15 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 482C4C06174A
        for <stable@vger.kernel.org>; Sat,  6 Mar 2021 14:04:15 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id c16so3138797ply.0
        for <stable@vger.kernel.org>; Sat, 06 Mar 2021 14:04:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iD8yUYQuksRLpradGupuSi8gfC8R6xYQT6DQ0zmuOjc=;
        b=gJT7bgo3ql68TT/GMfr1SlmN+F98DWMvq39NhbML8wlOVN+qL0HI9NTTWSnuUbrI9n
         GabC5ck4yzZ6GFHx401yvAkMLeL14pBL7lRKYb7zPukdGIWt/fyIeC2zvLWl04rMMKl9
         jYjrpRTpeaK3stS5ODe4tAbAvamhlQHrKcznAh1w3XGVwqmqhJ6Es5bDHRhXlRDaslB3
         2yy9jTORrkGMw6lH+W4ftzrYLWci9zrYYcw4WUV0KQnPYqAK0zWGKzL+Wirc6hbmWbR/
         npJ+ytd6foUhxF2/w9V/XMb0N8BEdjFT6WdEo66kEixkqgTGNL04t7f5RYoUqhe15IOe
         Zapg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iD8yUYQuksRLpradGupuSi8gfC8R6xYQT6DQ0zmuOjc=;
        b=VbVDZJmSWpkYz1KxbsW3SdY6bF9OTbIOLCvErqgnkX2CSDOPNarGqRE+rc5NykBafe
         iJ4OxrYm+Q5aP2u+e2tykG9qJKLrsuPBBcOqlPB5b205BxV1/xKUgzq2yd2pW1AnsJ19
         vnMt68tNuegTsnJm+iqDb9v3VOAAutMh4MePpQoSf3jN5kUlrI76TWvJMhnC4CVZ+MQU
         macJ5tW2Lopaw4c9+Psl18HvG8QhFP/+U7Y+YCKAk4KPdsFROmkkoaUzui0Zd0fBvvs9
         LNMbLUwyn3yG5hthfJXrZVIia6Q1ZT6FxNUKAzB4tl2MGehIfoUDUUfaf3DZn3JfHJFd
         R8+Q==
X-Gm-Message-State: AOAM533c1y5jcXxXbUS8MAd2Ypob1UnQV+OYlthSV3whZrNK86e3zSYY
        6M01YsSdydY3PS1JCBwmpSwxwz7mlIRp/A==
X-Google-Smtp-Source: ABdhPJwwhh0E/+DzDJ3EKzJFQ3H4+fNJ09ZqKHTod5yiXsVUNf71vD5iVeSfMllNiMdwaMwrJvFYwA==
X-Received: by 2002:a17:902:b088:b029:e5:b645:dcf2 with SMTP id p8-20020a170902b088b02900e5b645dcf2mr14574390plr.71.1615068254450;
        Sat, 06 Mar 2021 14:04:14 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d24sm5976315pfr.139.2021.03.06.14.04.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Mar 2021 14:04:14 -0800 (PST)
Message-ID: <6043fc5e.1c69fb81.43ff1.f59c@mx.google.com>
Date:   Sat, 06 Mar 2021 14:04:14 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.178-52-g8a88a7ec633b1
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 102 runs,
 4 regressions (v4.19.178-52-g8a88a7ec633b1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 102 runs, 4 regressions (v4.19.178-52-g8a88a=
7ec633b1)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.178-52-g8a88a7ec633b1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.178-52-g8a88a7ec633b1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8a88a7ec633b1c628577d39088cc63467c32bac3 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6043cca4a0a3ec682faddcb5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-52-g8a88a7ec633b1/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-52-g8a88a7ec633b1/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6043cca4a0a3ec682fadd=
cb6
        failing since 112 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6043caba73c8440faeaddcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-52-g8a88a7ec633b1/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-52-g8a88a7ec633b1/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6043caba73c8440faeadd=
cb2
        failing since 112 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6043c6f9c007de1d5daddde8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-52-g8a88a7ec633b1/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-52-g8a88a7ec633b1/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6043c6f9c007de1d5dadd=
de9
        failing since 112 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6043c70690caf5d3caaddcb8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-52-g8a88a7ec633b1/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-52-g8a88a7ec633b1/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6043c70690caf5d3caadd=
cb9
        failing since 112 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
