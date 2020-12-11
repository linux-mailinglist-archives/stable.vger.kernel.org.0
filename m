Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 885E72D7F33
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 20:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390657AbgLKTJa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 14:09:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730713AbgLKTJP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Dec 2020 14:09:15 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68BC0C0613CF
        for <stable@vger.kernel.org>; Fri, 11 Dec 2020 11:08:32 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id f9so7549572pfc.11
        for <stable@vger.kernel.org>; Fri, 11 Dec 2020 11:08:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WlhYbUdgo1W3Mi173lX+aGf5HQQQOqZR7c2N05cASfk=;
        b=U4zMqGj1xGtdt4SwnDfauyinnexpi4lbVWCoyQQUdF6F3+zvNRo7ed3ukUZuQZPFVE
         mhvXbw3m3zihEbRi1Zx0oepydWzhIPeDFLBcy8lRo0J19P1WTzChahrQBVAnZNylvJkN
         5SLNGUi0c66+LTdAHUQ6jOKXPWUXKvf9WqcTW52igBraoLIRCHCYnd3xfP6aZV32U2eA
         8Ls68C3OHOLKYrOxeH9ee62MISlLDAyAv0hHD0l5ykmc4/WWcNYm02DgeM4K2f0IxyKv
         D8XjrdcWF8xuheh3KsCg2yV+X3PAyVFjRjEfCzVNDLC7oMWLRfvUUCDvRNh0I1kL66ze
         CCqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WlhYbUdgo1W3Mi173lX+aGf5HQQQOqZR7c2N05cASfk=;
        b=rXvc1KiyzC9T0vOStjllQuuebqw7CSv4mDm5R4jlKf5f+u8kB2oHLuw18/KJmr9NKR
         U3zqE0ub/JzNCi7M8v7UtXHcI75vFE6oaM4PeIKJRQSStejTNrmhdCTDpkCH1MbSlNjz
         mHizEKW+0R91UwWaxsn0MQ7GPBy/WwIolahSNVe6SAI9WkSbI4OAsMnUj+tVB0R+Fief
         ZsYLx9WwEriNv6b8queWm/br4TSgMeDlzrTFQkNQuyFhRjSUH9HIXlwz/W6w/MLVslRu
         wE7rpeBit907Swipecniy4FTK5508nUMm4ddiD51q7UqQBvqg7CvThb9D4c8ssA959Iz
         C99w==
X-Gm-Message-State: AOAM531Yl3STkOwnL7AHkXwbNxp8i7U08BoKbhX18MBqW9PSBifSu7DS
        KdepLu/+PdF3DjlwErsPTESinxYZoNJWYA==
X-Google-Smtp-Source: ABdhPJyDYDGRDW85Yx5wXJpwGbEXBe83xgjw4tGAVNsVRBp/8x+DUSJFZTKgpJSoxQkm2JrLD8Xm6g==
X-Received: by 2002:a63:6707:: with SMTP id b7mr10156087pgc.353.1607713711649;
        Fri, 11 Dec 2020 11:08:31 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x10sm11379395pfc.179.2020.12.11.11.08.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 11:08:30 -0800 (PST)
Message-ID: <5fd3c3ae.1c69fb81.e4674.5459@mx.google.com>
Date:   Fri, 11 Dec 2020 11:08:30 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.19.163
X-Kernelci-Report-Type: test
Subject: stable/linux-4.19.y baseline: 156 runs, 5 regressions (v4.19.163)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 156 runs, 5 regressions (v4.19.163)

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


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.163/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.163
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      13d2ce42de8cb98ff952f8de6307f896203854c2 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd3915d225e1a36d8c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.163/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.163/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd3915d225e1a36d8c94=
cba
        failing since 22 days (last pass: v4.19.157, first fail: v4.19.158) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd3915080cbc1e9d8c94cef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.163/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.163/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd3915080cbc1e9d8c94=
cf0
        failing since 22 days (last pass: v4.19.157, first fail: v4.19.158) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd3914c80cbc1e9d8c94cce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.163/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.163/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd3914c80cbc1e9d8c94=
ccf
        failing since 22 days (last pass: v4.19.157, first fail: v4.19.158) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd3910b79d4f3da56c94cdc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.163/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.163/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd3910b79d4f3da56c94=
cdd
        failing since 22 days (last pass: v4.19.157, first fail: v4.19.158) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd39112dfbfc31aa7c94ce7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.163/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.163/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd39112dfbfc31aa7c94=
ce8
        failing since 22 days (last pass: v4.19.157, first fail: v4.19.158) =

 =20
