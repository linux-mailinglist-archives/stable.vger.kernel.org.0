Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD1B44858A1
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 19:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243165AbiAESnB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jan 2022 13:43:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238501AbiAESm7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jan 2022 13:42:59 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0432C061245
        for <stable@vger.kernel.org>; Wed,  5 Jan 2022 10:42:59 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id c14-20020a17090a674e00b001b31e16749cso3779269pjm.4
        for <stable@vger.kernel.org>; Wed, 05 Jan 2022 10:42:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dK6IxBl9iQznMDyWdHAb7nDJSd9IclXjVVPyO9XoQ60=;
        b=TtzUHB/dxymQsNeS236JfNfAuw0Yoc0pBGLYvJjEzeuiEdupMLAFeqGymdaPxvYpHa
         yRuDSfv2Iqs8E5YWVM1wk6Z79xc6AElg/I7tHrqrbi1TM+WSOBovRZ4jSEy/XIKG3ern
         1QFVwZpppBXswp1xudYG8HPPLDJ9VVmRyKKe6M6x0U8B90yo2gVw0n56TFvvgTo/dilc
         6cj9J2+ud9CV7FcqQGhszyUylyxEfeQYrSTQp3sfl9X6+z0rKeLSPQADIHK5jtYiiWTc
         a2ELdjlpPA0PpcptyFMdVBNVnM5cOezoCMpuuKysJ0CnrKV9Ajw6EdoxQE19VXfT/Mqy
         eqAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dK6IxBl9iQznMDyWdHAb7nDJSd9IclXjVVPyO9XoQ60=;
        b=A4eR23lWjMvrTbKff3sBYobnbHrZPMBYHLbutrApt3mHGj4G48x4lwIeYVwYy/2O9f
         vxf31fUnvhp9tjBay0MvgUp4WS+u77R8XC6baNQsjY6esJQxhBUZNaChSqC2Ao5yKHuE
         C+b/c5i5zOIxCqaXriyVq421uG2vTlIHFle0rb/v6Iqvj5S0HWK8++rh31DKKaRRChGx
         4ACszyzvM0n8knqGB7cW5d6Sd7TlZqfP5GeeyRSNfHwf8iyEVZ/LKwkssLIziAK3ntV4
         LSMzRN1aCFnsQB0/BqKsQg7hvgSLWyDLxRDCwvemQ4ipqRWSSgdwrkb3lcAXQRoohriF
         o1Hw==
X-Gm-Message-State: AOAM531wigdlWS/vTinwUC0ZeIZjCXsIbboUaOKfF0Ms2xAkg4jKwNeb
        ecL7kT+fSe/f1PzMDy5EcNnIcT10tYmuJR23
X-Google-Smtp-Source: ABdhPJxuPbfqU37ADOHuhBmubtla4I/S0CQ9luJ828Ym7VMYU8/vuklZ5sS3uKml1oWgtUHzkDgMWw==
X-Received: by 2002:a17:902:cec8:b0:148:f0dd:3ce0 with SMTP id d8-20020a170902cec800b00148f0dd3ce0mr55378864plg.156.1641408179023;
        Wed, 05 Jan 2022 10:42:59 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p186sm28168509pfp.128.2022.01.05.10.42.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 10:42:58 -0800 (PST)
Message-ID: <61d5e6b2.1c69fb81.7e4e.7738@mx.google.com>
Date:   Wed, 05 Jan 2022 10:42:58 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.4.170
X-Kernelci-Branch: linux-5.4.y
Subject: stable/linux-5.4.y baseline: 171 runs, 4 regressions (v5.4.170)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 171 runs, 4 regressions (v5.4.170)

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
v5.4.170/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.170
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      047dedaa38ce703d3c6a6b0fae180c85a5220cdb =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d5b0a7458e6f3eeeef676e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.170/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-uefi.=
txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.170/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-uefi.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d5b0a7458e6f3eeeef6=
76f
        failing since 19 days (last pass: v5.4.166, first fail: v5.4.167) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d5b0a5048cca3cccef673d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.170/ar=
m/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv2-uefi.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.170/ar=
m/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv2-uefi.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d5b0a5048cca3cccef6=
73e
        failing since 19 days (last pass: v5.4.166, first fail: v5.4.167) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d5b0a89b7d0d67cbef6741

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.170/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-uefi.=
txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.170/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-uefi.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d5b0a89b7d0d67cbef6=
742
        failing since 19 days (last pass: v5.4.166, first fail: v5.4.167) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d5b0a647133fb1eeef673d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.170/ar=
m/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv3-uefi.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.170/ar=
m/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv3-uefi.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d5b0a647133fb1eeef6=
73e
        failing since 19 days (last pass: v5.4.166, first fail: v5.4.167) =

 =20
