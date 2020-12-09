Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71EB02D387E
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 02:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbgLIB5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Dec 2020 20:57:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbgLIB5B (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Dec 2020 20:57:01 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9BF1C0613CF
        for <stable@vger.kernel.org>; Tue,  8 Dec 2020 17:56:20 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id lb18so19216pjb.5
        for <stable@vger.kernel.org>; Tue, 08 Dec 2020 17:56:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=180PbV690pa/GhCmhhkm8zco4b50y1j9NUQTRXydIPc=;
        b=Oxe6hHMQLF4tvOK7s7gqAWxINQyN2+/LXESAr20dlvprAwhsQwt6g/am4locG22uxx
         8iFGNx7M30TMRzes0PYbG1eYnBhhDhVE00jMHbKKL0SdZ9pi8zXmBaVo2eJQIFJSlc11
         KC6H9dtyNBBA0QhY6K08UJBaOCQWT54eTFUlA5bpv45fl/TOlMdpb7x3YWXRYBm4p3Gz
         5/NWWQB5sXoPUrSuC1WbSUJNVoRE2D2j4HT/piEHyzquaBRVMXLe90W7729f69myjKO3
         pt6ULhk0yvIEnl7xbCA1ZSZy/VWjvu3bMaMFCKZqmnPr2DvoQAFsEph5JQ9gukKcJdFR
         0aFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=180PbV690pa/GhCmhhkm8zco4b50y1j9NUQTRXydIPc=;
        b=UX9D+G4aW7/tjuR4qpbZEiT0JLAj850eeqgpEkpsppeK9j0q2pTyAvys93NHAnhV1r
         zTeVRDZBpIaPaqWcKUpkKC+df7COD5ABQuBIg+riV/OOlsiHAQ8jkZoT8DV4ZMreaT/c
         1LgWIcL6Sc5TiI0gu6tu4MUopgpcOy3PjNEE8+S870r2lJ13K/WrxNq8sL2O3MOKOCog
         LY4XWhlMAfZbsMfreaY1RZGfVyjwo9HOoYCxBiu615qaI0TNkkv2TvoN5MSKpFkRC0rF
         qHYCycPkQwrFqt4J2SAurEtfjXDznTKDbRBsF19fwsMZJumrjbJfGH0RpTTYp6icE/Qb
         ytkQ==
X-Gm-Message-State: AOAM532KcPK5KseNvXNLJukCjDXTr5cNh9+ze9yX3TAGMT7IXchQ9Xmt
        7GSd6wb20Jdl6tJHFePqfVqYLYYWCUtgLw==
X-Google-Smtp-Source: ABdhPJyRJ5055AmR+LkS8Fv6dDi683LeEkAw3xCog1wF/EwVfaROwf+y3wyPj85mIy2xAm6Avo62FQ==
X-Received: by 2002:a17:902:8ecc:b029:d8:d11d:9612 with SMTP id x12-20020a1709028eccb02900d8d11d9612mr319487plo.4.1607478979954;
        Tue, 08 Dec 2020 17:56:19 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id bf3sm56954pjb.45.2020.12.08.17.56.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 17:56:19 -0800 (PST)
Message-ID: <5fd02ec3.1c69fb81.83cc.0316@mx.google.com>
Date:   Tue, 08 Dec 2020 17:56:19 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.211
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.14.y baseline: 109 runs, 8 regressions (v4.14.211)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 109 runs, 8 regressions (v4.14.211)

Regressions Summary
-------------------

platform              | arch   | lab          | compiler | defconfig       =
    | regressions
----------------------+--------+--------------+----------+-----------------=
----+------------
at91-sama5d4_xplained | arm    | lab-baylibre | gcc-8    | sama5_defconfig =
    | 1          =

meson-gxbb-p200       | arm64  | lab-baylibre | gcc-8    | defconfig       =
    | 1          =

qemu_arm-versatilepb  | arm    | lab-baylibre | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb  | arm    | lab-broonie  | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb  | arm    | lab-cip      | gcc-8    | versatile_defcon=
fig | 1          =

qemu_i386             | i386   | lab-baylibre | gcc-8    | i386_defconfig  =
    | 1          =

qemu_i386-uefi        | i386   | lab-baylibre | gcc-8    | i386_defconfig  =
    | 1          =

qemu_x86_64-uefi      | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig=
    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.211/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.211
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      47cbf4cc32db62f053c4cd04fc6ee39a0218139e =



Test Regressions
---------------- =



platform              | arch   | lab          | compiler | defconfig       =
    | regressions
----------------------+--------+--------------+----------+-----------------=
----+------------
at91-sama5d4_xplained | arm    | lab-baylibre | gcc-8    | sama5_defconfig =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fcff664ddeafc8640c94ce1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
11/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
11/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fcff664ddeafc8640c94=
ce2
        failing since 137 days (last pass: v4.14.188-126-g5b1e982af0f8, fir=
st fail: v4.14.189) =

 =



platform              | arch   | lab          | compiler | defconfig       =
    | regressions
----------------------+--------+--------------+----------+-----------------=
----+------------
meson-gxbb-p200       | arm64  | lab-baylibre | gcc-8    | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fcff316caa95095b0c94ce4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
11/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
11/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fcff316caa95095b0c94=
ce5
        failing since 252 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform              | arch   | lab          | compiler | defconfig       =
    | regressions
----------------------+--------+--------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm    | lab-baylibre | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fcff48b0b7648ac15c94ce8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
11/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
11/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fcff48b0b7648ac15c94=
ce9
        failing since 24 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform              | arch   | lab          | compiler | defconfig       =
    | regressions
----------------------+--------+--------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm    | lab-broonie  | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fcff48a0b7648ac15c94ce3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
11/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
11/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fcff48a0b7648ac15c94=
ce4
        failing since 24 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform              | arch   | lab          | compiler | defconfig       =
    | regressions
----------------------+--------+--------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm    | lab-cip      | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fcff47f0b7648ac15c94cca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
11/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
11/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fcff47f0b7648ac15c94=
ccb
        failing since 24 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform              | arch   | lab          | compiler | defconfig       =
    | regressions
----------------------+--------+--------------+----------+-----------------=
----+------------
qemu_i386             | i386   | lab-baylibre | gcc-8    | i386_defconfig  =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fcff782032cdca194c94d31

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
11/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
11/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fcff782032cdca194c94=
d32
        new failure (last pass: v4.14.210-21-geea918eb2691) =

 =



platform              | arch   | lab          | compiler | defconfig       =
    | regressions
----------------------+--------+--------------+----------+-----------------=
----+------------
qemu_i386-uefi        | i386   | lab-baylibre | gcc-8    | i386_defconfig  =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fcff77f79a876a80bc94d06

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
11/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
11/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fcff77f79a876a80bc94=
d07
        new failure (last pass: v4.14.210-21-geea918eb2691) =

 =



platform              | arch   | lab          | compiler | defconfig       =
    | regressions
----------------------+--------+--------------+----------+-----------------=
----+------------
qemu_x86_64-uefi      | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig=
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fcff6aabe6d286078c94ccd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
11/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
11/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fcff6aabe6d286078c94=
cce
        new failure (last pass: v4.14.210-21-geea918eb2691) =

 =20
