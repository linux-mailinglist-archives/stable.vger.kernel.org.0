Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4570C2ECA9C
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 07:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725974AbhAGGkn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 01:40:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbhAGGkn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 01:40:43 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32681C0612FF
        for <stable@vger.kernel.org>; Wed,  6 Jan 2021 22:39:57 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id u4so1433233pjn.4
        for <stable@vger.kernel.org>; Wed, 06 Jan 2021 22:39:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=G08AdDZPEKrJeqyI9Rr/oKsdqOUnXxOjvSeQsJJZeRk=;
        b=WnoyHHf6DZoxWNB2Kv3+7f6CsfNuB92a1wBuCZyoWCiwWMMq1lv2Vll6X83FMNk7ue
         GkKDKRD/kElM/LTxkdH4IIrp6jr1kIXOaSeJbR1Q1JUeNOdhWvklyqux5C1m3MNoQmaH
         38UROb4NWpjl5RM5KROlwHANLvzmT0N0rAeWS9OsCTYeBUHx82QObLYqPVqTHUy9IMAe
         NLNo6nC7sxHrBrpzG8i/P4SnzgpC0SvLXEEuKazjo9uEWIZOwazW7dC+DizLi0E0MkOB
         v3YQy/LCIxjUPAjJbFJkuz4AnzNm3+ROGYrBsEQBoPMO0seYjPDpoBH5CgRI+qODSeC1
         pQ3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=G08AdDZPEKrJeqyI9Rr/oKsdqOUnXxOjvSeQsJJZeRk=;
        b=j/XYM7/KtndsF1fV7o5wm+1TKSkzpVxZWrq8ywTOqfrzDi/3Si5JtdSikB6mJNDrIX
         m47pQTQTbJJ1w2L37Dm1WUkSHjdrSksk7i33c9NYMFYNazKECc4xfzoIk7PIZqu7pkEg
         XBh92y3NROxcKD3Ujgg3c0vi4KbmkohrFCLX7qT6sysUcaMGcyyxkez888z9uE0nDGDx
         qmhpd9Ad/Ol9+G8miDwyvflnDBdaW1+ZOOshacRSEw3PqBJsvYmv3gFUpqYOUB7syz2g
         /aoBB+6p+LngwCj83DSJICtFm+cubT8fxukHvUCyKwZD5qcKZ9bzGCuG5zZeR/6FP+ga
         vItg==
X-Gm-Message-State: AOAM532hagc2A+ejjiPjEAWMdg59zcB7i9R9Z9ZYDmyNSJg1B82Mjxok
        pHckGXwEi7W6CudTQ80SK0Vzs0prViK3lA==
X-Google-Smtp-Source: ABdhPJyfdRi+qZFO8CDj8WI1N/IirXb7hME4CHTPlHNfG78scWJtst5dKPx3qvxoXLqxn+z2nihW6g==
X-Received: by 2002:a17:90a:8a8b:: with SMTP id x11mr2696210pjn.54.1610001596452;
        Wed, 06 Jan 2021 22:39:56 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 197sm4998566pgg.43.2021.01.06.22.39.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 22:39:55 -0800 (PST)
Message-ID: <5ff6acbb.1c69fb81.306ae.c54f@mx.google.com>
Date:   Wed, 06 Jan 2021 22:39:55 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.165
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.19.y baseline: 169 runs, 5 regressions (v4.19.165)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 169 runs, 5 regressions (v4.19.165)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.165/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.165
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4143d798313fffa39f05bf24dd560ace42225c26 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff67747065d26241ec94cbf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
65/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
65/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff67747065d26241ec94=
cc0
        failing since 49 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff677457fd7a8f61bc94cc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
65/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
65/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff677457fd7a8f61bc94=
cc7
        failing since 49 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff67751a4ed8c0301c94cc7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
65/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
65/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff67751a4ed8c0301c94=
cc8
        failing since 49 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff676f4b01ea7a58ac94ccf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
65/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
65/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff676f4b01ea7a58ac94=
cd0
        failing since 49 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff6770cf7741ad32ec94ccd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
65/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatil=
epb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
65/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatil=
epb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff6770cf7741ad32ec94=
cce
        failing since 49 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =20
