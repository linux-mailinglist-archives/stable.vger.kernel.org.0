Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA593F92AB
	for <lists+stable@lfdr.de>; Fri, 27 Aug 2021 05:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243968AbhH0DNI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 23:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232258AbhH0DNI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Aug 2021 23:13:08 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 849BEC061757
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 20:12:20 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id e15so3050454plh.8
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 20:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4OdGFeqKOGmIA8BAPcq4Ma9RiOi6VBLEBE/y+wgduiU=;
        b=dH/ajwoiHhqrB+Q1w/rbG+GElH3nbsNBt09YeRVUiIlL27j70JOPLzlZFv+FGP4HSS
         llXe4ppRa1dMCcatbGOfqaqnmTHPvdcyT4aKCdffIMeBVIaOCDE4GS+SoFd0C/20X1/v
         3r255IFy49xs49nG9uZsT/ULKArRAldwaI13uiQuL+IBhB+TXj+gw+8r+pe90OtNRRsz
         XXboohP3/22EDqxgUE+vikYzHnh7U4ApPuQ/PeDayaOFbklzXSxdzU8tugfu7bJj2MiS
         YqJocKT2z/EK7rxAmFrSEcTfvc8HBYAOFVBTD8D6Zf5OxRKMK3eFSRkQRBFnT2UJBw4M
         +9Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4OdGFeqKOGmIA8BAPcq4Ma9RiOi6VBLEBE/y+wgduiU=;
        b=AbVS4IALJkC7tVTf2GeQUdvHzz2s5EHWrbKXlhSrXr2sefwornWVamJW+FWxl+kdto
         AgrmWk4rN1vduYURM9jTKloAA6Kq5IKpWQgnMQfPmUSJaIazznaDpsnTnKh3a/EvRjMW
         5Uxt7zBQDLpik2xjKxSbab1VRqHj//Bg8R2Cw6yPe+Pso2wLoTkJPvmOha+CZ6ynCY8G
         oqKB9uk8SQtv3AQvplAYDLz/pKhhIWrsRnRpH0sWjaHk1w+ioPpCCVecEqez+RhbQq8R
         uT5vhqAN3ycm6zjdz0AeH0mzmMAoX/xX32jI8Y67p8Ry7KhQfO1JVMuYRLNIwnbQ/6oV
         PfzQ==
X-Gm-Message-State: AOAM533UdG9ShBzTkiGcKgzboI5cZ1NWz/IFXca9wYUOON3N+CHsc/Mt
        hr9tOZo0Ht6+oDic/MFi6hG7FvqdelHWRV+9
X-Google-Smtp-Source: ABdhPJw2qFYHquzzCRcbPeX2FRAf60+TQ8XD1SieCAWTPtaNTFT5ojXEWKnZGczXs0JqSJh8+Gk7cg==
X-Received: by 2002:a17:902:c3cc:b0:135:875:cf2 with SMTP id j12-20020a170902c3cc00b0013508750cf2mr6607578plj.81.1630033939859;
        Thu, 26 Aug 2021 20:12:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ev12sm9971705pjb.57.2021.08.26.20.12.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 20:12:19 -0700 (PDT)
Message-ID: <61285813.1c69fb81.80203.b63a@mx.google.com>
Date:   Thu, 26 Aug 2021 20:12:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.143
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
Subject: stable/linux-5.4.y baseline: 133 runs, 4 regressions (v5.4.143)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 133 runs, 4 regressions (v5.4.143)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig         =
  | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.143/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.143
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      fd80923202c6bfd723742fc32426a7aa3632abaa =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/6128209490fb2f4c158e2c89

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.143/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.143/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6128209490fb2f4c158e2=
c8a
        failing since 14 days (last pass: v5.4.139, first fail: v5.4.140) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/612821406eccaa72648e2ca1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.143/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.143/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612821406eccaa72648e2=
ca2
        failing since 281 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/612855dfd72ce4e8a08e2c84

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.143/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.143/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612855dfd72ce4e8a08e2=
c85
        failing since 281 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61282138629fe1c0a68e2c91

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.143/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.143/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61282138629fe1c0a68e2=
c92
        failing since 281 days (last pass: v5.4.77, first fail: v5.4.78) =

 =20
