Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0712F840A
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 19:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388020AbhAOSUW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 13:20:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733304AbhAOSUV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 13:20:21 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 127DAC061757
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 10:19:41 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id be12so5122162plb.4
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 10:19:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ynx/w0Yz12VlqbZyMBebb9zJZaXxzYjZnDBkHHeACK0=;
        b=qoz+BjA+lEp8n10eKX+ZIsUZbK1cNgkdT+mw8zHHzmRJEqayFrJer1HkhjjUO2nSv9
         jZmdUFuR42BpELRO9GpsWr18v9DC/idE+Nz5s4fr5T3VT4cQVJdThldXuk/rsVkEiU/m
         QHroQTOO2CZS/HkN2ibeXODIZf7xlb/GNb//6cQAAKx+K16W6ZGw4/4oUAC8nTtcbT/s
         N8xoRdi7Ftx0yVGY6iRljLrk7RwUeuiG+bNy2h/VkNKKXFiOt+1wiBWYg0xPtYczl6n6
         3iuzUR4VG/6G+NMRgEQ0ZkG5lCNcNEc7RlzIY4pbYW7NmorOSjuBc2pwvwzG93dy7jPt
         CkJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ynx/w0Yz12VlqbZyMBebb9zJZaXxzYjZnDBkHHeACK0=;
        b=OKi0rjL0Bw50S95826htEw7gUfqLvXvq2CxDjOaY+Zq7l502rkmZm1nXBGuXxa91R1
         NXVkq1nOW8vZAw+itGfxA5yoINN2vVD9E58+sECP9S1RVY+RV2S+aHPDUmqUB7OEQQxg
         dBxtApuON0CtTxTjmmuz8t3eEGZGBDZgIKt/SnnZ5TXgkjKMojyd87g7xGUq/+gPscQZ
         z/UQs1lkzGkbTCdCqZKn77/CQ8hGK6wDCuWuivwkBf4PvFDxIFy834JZEo4w/dmdMpvR
         +cGd9bcPE29BlrBBT3CxcKvOvVEDcc0ZELijmgx9bO9XAWaX8Rvg9IXKGfBVfhWxC+gE
         mffQ==
X-Gm-Message-State: AOAM531kHdPX2Ch1YY5dUPlLYxFyyOAkGixH9w9PKNvU53v0tvyRdPfR
        DLU0qXnUbIw6vE6bWKmGxe5eHNp7ywTVEg==
X-Google-Smtp-Source: ABdhPJzebi8bvin5q7LHuCFgmphGiVND7dBsYTv4MtvFv3CRaMxtxyknYFsnbICOUo5hLkCFBNekvw==
X-Received: by 2002:a17:90a:450c:: with SMTP id u12mr11941959pjg.93.1610734780329;
        Fri, 15 Jan 2021 10:19:40 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q70sm8796445pja.39.2021.01.15.10.19.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 10:19:39 -0800 (PST)
Message-ID: <6001dcbb.1c69fb81.c1e5a.58b5@mx.google.com>
Date:   Fri, 15 Jan 2021 10:19:39 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.167-44-g710affe26b436
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.19.y baseline: 148 runs,
 4 regressions (v4.19.167-44-g710affe26b436)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 148 runs, 4 regressions (v4.19.167-44-g710=
affe26b436)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.167-44-g710affe26b436/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.167-44-g710affe26b436
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      710affe26b4363782b54ed8cc7bf77d6fdfbe151 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6001aab364d5420632c94cd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
67-44-g710affe26b436/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
67-44-g710affe26b436/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6001aab364d5420632c94=
cd2
        failing since 58 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6001aaac92c4b28cb3c94ccd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
67-44-g710affe26b436/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
67-44-g710affe26b436/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6001aaac92c4b28cb3c94=
cce
        failing since 58 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6001aaac92c4b28cb3c94cca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
67-44-g710affe26b436/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
67-44-g710affe26b436/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6001aaac92c4b28cb3c94=
ccb
        failing since 58 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6001b77d00a81d23a5c94cc5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
67-44-g710affe26b436/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
67-44-g710affe26b436/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6001b77d00a81d23a5c94=
cc6
        failing since 58 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =20
