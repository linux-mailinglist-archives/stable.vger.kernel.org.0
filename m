Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8C3480484
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 21:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232805AbhL0UWV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 15:22:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232753AbhL0UWV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 15:22:21 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25413C06173E
        for <stable@vger.kernel.org>; Mon, 27 Dec 2021 12:22:21 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id f8so4231780pgf.8
        for <stable@vger.kernel.org>; Mon, 27 Dec 2021 12:22:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=34JC4C/TPe0/mHmhwTJx3eql2flnR+EF15w1/Xr41C0=;
        b=oXb2DW2KDRLSqD/szXyr6wIQ72GtZIELZu/Pg8OfemXq2seacGjv5MnynUyzYDypga
         hDeA/FClRX7tBsySxZ5bd5aRxkpUIZC1bW5XwxYbIJPu2rtY/yXoQN3FnV8WMzyarvEn
         8vL631jMobfFCg8VBh/ysbR07Kg5C7/TzWzYfp45P6GiROYO0Qj2vskdytU/KKNOPXid
         hpuUjuEUL6ZfAD0qrczUdYaiGcS6DdUAnk1a4MKmkZqcjhD7lpu2ZWNF+f8FN7Tj4n9n
         OGGjVH0ql4lLBdlKQIOU1/FXquxGFzuVS9+/TNJg6epVX4ugxF0usm8Fp7l1TiJxishI
         nYYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=34JC4C/TPe0/mHmhwTJx3eql2flnR+EF15w1/Xr41C0=;
        b=HqfUvWiS1GwDwYGuRQesS3t9J5q9EMefV4zpys2WusJ6WKG9M/0mxtRveMwaFqyD5F
         ufR4PLCq+CEu4V7gac4js1ETAXKoRgzEe9ASqNHJ8Uty/ghlJ/6mNjWMKKx6Y9nAei+v
         MFfvry/bxuAWL1kOpzCYRNy764MAxHCstrOQHYs7h6duzVvR9MXsDASF7eOwdem37uHb
         7qoKhG6tFsUIPFf0QGs3DwORpVy8XYwil6EjatsaqFN8CLMnPyPIfyuYwr6ZBcfSIQlH
         Y9m3RGDs8aTKI+to9Z33TGcDOKStQt563E+JTYWE6Kck8QqAu7QXfR8aFlfWy12h0vNt
         klVw==
X-Gm-Message-State: AOAM532mAYfxYtsAwoWXVZTMlE+m+jPnHLQf/zyZS9x/gpYYOUo0Nt33
        axPxbZ2pHCRwHp1rA/5pR/nkXnivlnSvIv89
X-Google-Smtp-Source: ABdhPJzHuptmnY1TdMjWzks+THZ3bVLgYeJ8EeG2QvJnIK+BEoGqY01/fr4iS0oo5NzLxfIsicgp4A==
X-Received: by 2002:a63:b914:: with SMTP id z20mr16880618pge.496.1640636540304;
        Mon, 27 Dec 2021 12:22:20 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id cu18sm19649081pjb.53.2021.12.27.12.22.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Dec 2021 12:22:20 -0800 (PST)
Message-ID: <61ca207c.1c69fb81.23f50.86cd@mx.google.com>
Date:   Mon, 27 Dec 2021 12:22:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.168-48-g55d919268b6e
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.4.y baseline: 145 runs,
 4 regressions (v5.4.168-48-g55d919268b6e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 145 runs, 4 regressions (v5.4.168-48-g55d91=
9268b6e)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.168-48-g55d919268b6e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.168-48-g55d919268b6e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      55d919268b6e0816a2eaa3a74303fb57102ab4a9 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61c9e9a0a40ce8fab8397172

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.168=
-48-g55d919268b6e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.168=
-48-g55d919268b6e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c9e9a0a40ce8fab8397=
173
        failing since 11 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61c9ea09857465345a397139

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.168=
-48-g55d919268b6e/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.168=
-48-g55d919268b6e/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c9ea09857465345a397=
13a
        failing since 11 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61c9e975c79efe61be39712d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.168=
-48-g55d919268b6e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.168=
-48-g55d919268b6e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c9e975c79efe61be397=
12e
        failing since 11 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61c9e9b9838c6da1b9397153

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.168=
-48-g55d919268b6e/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.168=
-48-g55d919268b6e/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c9e9b9838c6da1b9397=
154
        failing since 11 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =20
