Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0022D9271
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 06:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbgLNFIc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 00:08:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726357AbgLNFIc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 00:08:32 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 851FCC0613CF
        for <stable@vger.kernel.org>; Sun, 13 Dec 2020 21:07:52 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id f9so11301774pfc.11
        for <stable@vger.kernel.org>; Sun, 13 Dec 2020 21:07:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=48D9mVelYKi7XjwMcBDqEngm6AwVBkSplbDctXfO5LQ=;
        b=E8iZWouQf5Pz/kmLshLrKJBf1WyOxmgIsTh/49B6F8qHeU3L0xHXb2GZmS0w94XZfI
         paCRfMRST1s7owJCGcNDXXiQ5dMoE/BqxdUMPf+e/w+cHcAXp/GTI9fsDm+tcv/Gx+Q3
         qQqzCTWCnvAtdGoyD9GmwWQXp9/6ZP2wOgmqzJv1thDWB272GgEaWH0QyGA0BQJ1Ken1
         R/c5bplr3+Hfs7v6hCmoQSfrk7Dat8bZwyi+ZLc91DtKa6fUUCOMIb0i3sjfibI1W74V
         2+Lyx8rVAIbUZkN2r4EzqiiH/ioZ96zJ/5nMVjvxNjsghC7weEAiJiNp8tMDBnkU164g
         FueQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=48D9mVelYKi7XjwMcBDqEngm6AwVBkSplbDctXfO5LQ=;
        b=hqI77sjYOKCRrmmxd+WWpJkWT6vNr+lMrDjHGdBsVUUEALbO9WWzOQkDDVO6coaGym
         Vuyy/hHh5lgc41B1V2FByMD15hM0unl4Wrm4n2cIV3xsPAznrgxoPE6/U/ZMElPECRjs
         OX6k5/BnK5mMBiE4PC5X3A52y/c9Nf57WST1Yxg6aBaSkIL3rN4VcKnFvuj5I2xrIi82
         EKY0pLuwLSoBnlGKHK6vN/aV+mF6hFz5aGc4AJgDovQqKhUUa0kAQs7IyB67I1XFsV5K
         mSjzQ4d9B+S3cM+pskpD+HgC+MblaNWZAv7zuH+oqeZg8cElnLC33GOJjCW7U2k5xE0Z
         0rpQ==
X-Gm-Message-State: AOAM533iXFv8hxendQXHDravhsI1Zw6LKIlOf4XT1DniBOl9IH+W2+E9
        6rAOx3M61IH+6e+5BcUn62JisG+bN80e5A==
X-Google-Smtp-Source: ABdhPJz2QClevGHEcxJWnb1gpGIs1Xd1fwtf4CinjntjRwntdOXvggoTNOqW10qBC0dLtjQ+siEgug==
X-Received: by 2002:a63:560b:: with SMTP id k11mr16847629pgb.407.1607922471812;
        Sun, 13 Dec 2020 21:07:51 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p185sm15290391pfb.165.2020.12.13.21.07.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Dec 2020 21:07:51 -0800 (PST)
Message-ID: <5fd6f327.1c69fb81.71994.069c@mx.google.com>
Date:   Sun, 13 Dec 2020 21:07:51 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.248-6-g1d3e7d6f3f6f7
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 122 runs,
 4 regressions (v4.9.248-6-g1d3e7d6f3f6f7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 122 runs, 4 regressions (v4.9.248-6-g1d3e7d6f=
3f6f7)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.248-6-g1d3e7d6f3f6f7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.248-6-g1d3e7d6f3f6f7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1d3e7d6f3f6f7738efe4dd2cde946d0f7eac18d4 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd6c0a1b8173424a1c94ce0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-6=
-g1d3e7d6f3f6f7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-6=
-g1d3e7d6f3f6f7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd6c0a1b8173424a1c94=
ce1
        failing since 30 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd6c0a3b8173424a1c94ce3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-6=
-g1d3e7d6f3f6f7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-6=
-g1d3e7d6f3f6f7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd6c0a3b8173424a1c94=
ce4
        failing since 30 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd6c06c1a7f1fd3e5c94d21

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-6=
-g1d3e7d6f3f6f7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-6=
-g1d3e7d6f3f6f7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd6c06c1a7f1fd3e5c94=
d22
        failing since 30 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd6c06fd2a2633b52c94cdb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-6=
-g1d3e7d6f3f6f7/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-6=
-g1d3e7d6f3f6f7/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd6c06fd2a2633b52c94=
cdc
        failing since 30 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =20
