Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F128F3A3093
	for <lists+stable@lfdr.de>; Thu, 10 Jun 2021 18:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbhFJQ2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 12:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbhFJQ2r (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Jun 2021 12:28:47 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD37C061574
        for <stable@vger.kernel.org>; Thu, 10 Jun 2021 09:26:38 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id z3-20020a17090a3983b029016bc232e40bso4170862pjb.4
        for <stable@vger.kernel.org>; Thu, 10 Jun 2021 09:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IwBM6xzEDuX9lkXdh82HAxxZipBk8Aysr6ww2yIJJs8=;
        b=wmGsDXGXJwfRubBDOhBAyG2mkH6SvOcVmF83trOJK37XU+aKPnD+PQQDWDK7VbL1AK
         TStJMwu75HpO2oHX+vhIxtsqXe34Ds0va0bIre+p+zh5b6yF1/y88GPgRbj4wzLGBGLK
         oQR2Ch+J5Vna0xHW3H0fg7bSGMt25ShoiLuYX+CL8USPaHHiRc+MBNpQekdg7Py+lf7O
         kk8aH/ebaD4xLxw36eRp8GZVd3OHDqag/cJNUsrleGmaUgcoPOQQ3XFUMzP4kloESI9Y
         /KP9rGUa/SNhGO1sdNd2gNntV4M/KrHoJo8QWD/dudJB3siKC0cH4gsROzSVZDAbfXT0
         pYbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IwBM6xzEDuX9lkXdh82HAxxZipBk8Aysr6ww2yIJJs8=;
        b=X2PRiEO861pYgyY3gcMp3HfMtntINNGBreqtBr0yXWtXj4szPNHiZunTUnFgXIBNdX
         Kg0Q7Lld39ZnVTcBIPkN1szUFgMZ7lnsHWjymqkrXR/gPBXrn8z6woncsUO8k0A9wa3q
         kBK4c9AFZ1+LjHNUc6zFdrLeF5hizhLof00yB7FWQUE/IqwKch2CVmAnQ2eGwjvCvhn1
         7BIf5n+kDZUPvXoDSvtktKaElIvRkuBvlwVXgmtsb1vYnVmKAnf07JVdG/9Iz0/rJzNc
         tgozYKYJocsieVoxzvOFpk/pHMU8flU4LDene2qM8MrgbhZORV3TGurd/xItGfJ998hl
         EiSw==
X-Gm-Message-State: AOAM532pHpZksEF3Jl1pIFTpdLw06LjZhzb+hZQ6ijTW66/8P+TxQrM4
        b7ODxhu3FPp075ASQaVmyyOvIfhMfQjhrTdJ
X-Google-Smtp-Source: ABdhPJwc+sIGFchVQ9ytyMXQJLTiQhP8emv12kaqIR0OCQo4qLwoEtBmSZ+KtaLeXDC9CTZA6LQxtA==
X-Received: by 2002:a17:90b:4b04:: with SMTP id lx4mr4259066pjb.54.1623342397203;
        Thu, 10 Jun 2021 09:26:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a11sm2818943pfl.168.2021.06.10.09.26.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 09:26:36 -0700 (PDT)
Message-ID: <60c23d3c.1c69fb81.c8d6a.87fa@mx.google.com>
Date:   Thu, 10 Jun 2021 09:26:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.272
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.9.y
Subject: stable/linux-4.9.y baseline: 121 runs, 5 regressions (v4.9.272)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y baseline: 121 runs, 5 regressions (v4.9.272)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =

r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.9.y/kernel/=
v4.9.272/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.9.y
  Describe: v4.9.272
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      d98bf8b949c03b840010c5a4f2671b7c79019d76 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c204ef000357843d0c0df7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.272/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.272/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c204ef000357843d0c0=
df8
        failing since 203 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c204f2000357843d0c0dfd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.272/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.272/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c204f2000357843d0c0=
dfe
        failing since 203 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c204e417962770720c0dff

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.272/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.272/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c204e417962770720c0=
e00
        failing since 203 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c2048fa05f9200160c0e06

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.272/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.272/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c2048fa05f9200160c0=
e07
        failing since 203 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60c20b168a986c54220c0e1e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.272/ar=
m64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.272/ar=
m64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c20b168a986c54220c0=
e1f
        failing since 203 days (last pass: v4.9.243, first fail: v4.9.244) =

 =20
