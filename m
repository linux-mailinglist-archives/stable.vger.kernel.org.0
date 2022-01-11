Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 776DE48BB95
	for <lists+stable@lfdr.de>; Wed, 12 Jan 2022 00:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346882AbiAKX7U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 18:59:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346885AbiAKX7R (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 18:59:17 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C7EC06173F
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 15:59:16 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id c3so1357003pls.5
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 15:59:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2oR50kxGxM76Kc8ZFLZwgBlabXh9zbeYR+zVhbH3P+A=;
        b=qKjT7XRcmR2yPzk7vZ5Tj+4ALfGt9DHUMScvUorRCaJ1wzNWxDXpr1paPiHkdqyyim
         jOR8VzDLYlMhmeUwAq0nbrMStnv8Yd5MZoUtxn7tmU+izIgL+BWGJb12s48nFuK/NT51
         G0qeJ5MKPEEXrhM2BEXkzIEiYqOaMeD/jxjGzNGfB6lSltcGJCy3OXXwDFGzU9/z77qK
         cqvfxHuvmXxeZNOE9aLhDLrzWE58wnHHPmI/sCJW8upfvORRKt9VMKx7WVkbx7U5r/k7
         8Ym+V9NpDo7bR/gKQMxOfGQ6/u8ME1gPHEb6Y2Jf6YSKZBjuLxP7M8g5CDh8wEVV4m4u
         6CCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2oR50kxGxM76Kc8ZFLZwgBlabXh9zbeYR+zVhbH3P+A=;
        b=aBhIf9BeAM7aVZVdIhg4IFq42JRhOML4sJ1O4KHdWtJsCX/P0wjdH86zG6J71d5rXO
         jiM+122hW6NWE64KPWk2SmXHFGoavwSRvYTuJ/p4C8CkIxxjbaA5DcraRgEkv+4K9Qtk
         EC6nBwYOHUa75pwkDKkvLcONNPWK24YxB5tGBoRlbrggpGzHbiJSnfzMgw/p8mSZNTpK
         pcCYzI9GG+kSld6p/NBUpZcdrtEfL5HrvS65yDVpEN73HJkcMm2Aw3QN1dHMYO+17Jdp
         piL+mbP9PQtkhU6KeWOfXiipOJWP/3y9/saCjCDLZYgGWc++Og0F6nTTA6x2zp9dq6hJ
         MKkQ==
X-Gm-Message-State: AOAM533oRTeF/4e+6r98hRdoS8BDbKi6/UD9aZM/XzgP8d7+TAX5Qdqi
        ulpYw6L9uWQJYo47zDrT1QE6ujCmtLsadDU7
X-Google-Smtp-Source: ABdhPJzpyu6+ouowmkSjK+eofAFRiunLcOmLYEdgKcVkP1SXQlqMlw0hoOVjwE7LtxmREDG4Fe4R7w==
X-Received: by 2002:a63:5920:: with SMTP id n32mr6120606pgb.226.1641945556015;
        Tue, 11 Jan 2022 15:59:16 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i9sm9259426pfe.94.2022.01.11.15.59.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 15:59:15 -0800 (PST)
Message-ID: <61de19d3.1c69fb81.c96c.875d@mx.google.com>
Date:   Tue, 11 Jan 2022 15:59:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.4.171
X-Kernelci-Branch: linux-5.4.y
Subject: stable/linux-5.4.y baseline: 146 runs, 4 regressions (v5.4.171)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 146 runs, 4 regressions (v5.4.171)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.171/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.171
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      0a4ce4977bbeea4560a1f32632650b388c834c8a =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61dde37515b3e77729ef6757

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.171/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-uefi.=
txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.171/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-uefi.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61dde37515b3e77729ef6=
758
        failing since 25 days (last pass: v5.4.166, first fail: v5.4.167) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61dde38af2c01187dfef6749

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.171/ar=
m/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv2-uefi.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.171/ar=
m/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv2-uefi.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61dde38af2c01187dfef6=
74a
        failing since 25 days (last pass: v5.4.166, first fail: v5.4.167) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61dde376ac405f8c05ef6752

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.171/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-uefi.=
txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.171/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-uefi.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61dde376ac405f8c05ef6=
753
        failing since 25 days (last pass: v5.4.166, first fail: v5.4.167) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61dde38bf2c01187dfef674e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.171/ar=
m/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv3-uefi.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.171/ar=
m/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv3-uefi.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61dde38bf2c01187dfef6=
74f
        failing since 25 days (last pass: v5.4.166, first fail: v5.4.167) =

 =20
