Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FAF63F2535
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 05:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238127AbhHTDSO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 23:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238156AbhHTDSB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Aug 2021 23:18:01 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C96C061757
        for <stable@vger.kernel.org>; Thu, 19 Aug 2021 20:17:23 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id e7so7818791pgk.2
        for <stable@vger.kernel.org>; Thu, 19 Aug 2021 20:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lGpg+Upcic52byWxaxP3uWIbcxlHWblMXNAZmLMN0rI=;
        b=dbeIyiH4IlUqPcT2uZ/xd+N+FQDGYtKbOEWqtfs3/EJQXQ0n1VO9bmmlKvnTMWPhU+
         DmBgfhjObu2R2im2F+HahpU60veSq90yO7Z1dqY2i6iu5YznfsN2X0NMpMWMWuNczfUG
         KCiOf+CtZTqvMM5FgT+5I0w52n6logF19QOKZfX6hZuFbLSc72Ibaem2qcEZ4GKH5gwD
         WS9JBG4erPgaHRhmexlwNFMwiomJHhqx4ep7XEtxctICFUP4IUU/Oj5edBmpEX7H0s1z
         PR/tIGHNYf7itk6UbjaFaEC3woeOufXMdIGxi2zIX3GKaiwg5/SDMe/cA54TDGK4rx2F
         tdMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lGpg+Upcic52byWxaxP3uWIbcxlHWblMXNAZmLMN0rI=;
        b=ApnrjIWosgi8qbezYme7l5dXJK4s0ZEYYeR3xaNFhFjzt4NehveeEiYA+Fs5iWDi9N
         Ax8ENIaLIQnOHo5n6FNrTNJL8O39G0+jdhxoQbI7YzUbXMxwuMcEe0ijm0tjRJBZJUJA
         57PX+qGaniaYdzbnUR0adF8phO++vBFSsrbOqEWg3454loYsgYfTd8gUMgDo2ZE1OMEd
         Fp7IpP9DBKrIDYZ98otxGq5mfsTtmgG4440khnGgfYzs61RXDJZ2sqF7+EA3DSverAAo
         11S4LtU2skUlSxRI7jx4gEKpZp/lt7Js2gO7tmM+sXYwsZpoBaI+5FVzPc4zkFsNp+I3
         EVHQ==
X-Gm-Message-State: AOAM531bOiNH0217QnqiqwFTJjk1E8dOMjIoutGoEW4vreJGG/xE3uaI
        +/GIfdbTFuPkJXcZVxxDTzk2MghVJ3OeNoHx
X-Google-Smtp-Source: ABdhPJyWLFP44yMZcDC+hd3iNTRa1DGsm0sNTJf+mdXso4Y0u5fehHcToea+fEP0TzGPMIqFGYwMlQ==
X-Received: by 2002:aa7:8206:0:b029:3c6:2846:3f9f with SMTP id k6-20020aa782060000b02903c628463f9fmr18113466pfi.30.1629429442356;
        Thu, 19 Aug 2021 20:17:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x13sm4696789pjh.30.2021.08.19.20.17.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 20:17:22 -0700 (PDT)
Message-ID: <611f1ec2.1c69fb81.d044b.02e3@mx.google.com>
Date:   Thu, 19 Aug 2021 20:17:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.280-29-g87e061dffc0b
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 119 runs,
 4 regressions (v4.9.280-29-g87e061dffc0b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 119 runs, 4 regressions (v4.9.280-29-g87e061d=
ffc0b)

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
el/v4.9.280-29-g87e061dffc0b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.280-29-g87e061dffc0b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      87e061dffc0b4a677d5142fa48fce5b4a0df368a =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/611ee5392102c66b3cb1367b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-2=
9-g87e061dffc0b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-2=
9-g87e061dffc0b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611ee5392102c66b3cb13=
67c
        failing since 278 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/611ee530ae8217f3b8b1367a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-2=
9-g87e061dffc0b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-2=
9-g87e061dffc0b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611ee530ae8217f3b8b13=
67b
        failing since 278 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/611ee4d1fa0783a7e9b1368d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-2=
9-g87e061dffc0b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-2=
9-g87e061dffc0b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611ee4d1fa0783a7e9b13=
68e
        failing since 278 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/611ee4db4ec421b3b5b13669

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-2=
9-g87e061dffc0b/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-2=
9-g87e061dffc0b/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611ee4db4ec421b3b5b13=
66a
        failing since 278 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
