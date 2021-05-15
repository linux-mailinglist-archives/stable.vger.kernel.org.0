Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02DF93819B9
	for <lists+stable@lfdr.de>; Sat, 15 May 2021 18:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233090AbhEOQEv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 May 2021 12:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233088AbhEOQEu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 May 2021 12:04:50 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A0D3C061573
        for <stable@vger.kernel.org>; Sat, 15 May 2021 09:03:37 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id h20so848752plr.4
        for <stable@vger.kernel.org>; Sat, 15 May 2021 09:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GpQOaii7dAFPTeNLJb1D0H9UwCvOl3ubaJ/4/KwwSYI=;
        b=w0O0hPUG7mx5NrCJJ/b3YgHcjFzcFQ/WdmrgV8BJhXKVxEC0syD9xRixA9IB5fQUwq
         LDzXv6+kaKlO5Yfie409edjwWTzwCHWfdzPN9MrdGP7TX9LGW1xY26QoHAhLRG3SVPT4
         gVmWcoDoQKSNzFIJyyXs7x5V5LUBwADMxhwU/d1N7TCtiSC4JvGAdF1S0DpKENwKbwbj
         elvcJQ0yl4EJZzZHBf8uDOnONcxWR7FqA6vesB/9k6+9JjXmAXVlatm7pkdEV+NX7ymH
         NLL74/ndwO0JT49X56rsIuGunioF/U4iBN8PaPgJv03w743QZUNVmN4ZliriP+6S1Ztd
         qsmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GpQOaii7dAFPTeNLJb1D0H9UwCvOl3ubaJ/4/KwwSYI=;
        b=W0G9nItLwHgU8lYaXY0LV+RrAhrLmXF2ucfcHEyorAedXduvOsC2xDaQ+rIjMzbAPN
         MWDGvKez4FMqfJeFV8IVkpDHWe2AxfxUnVc5FSkKmPrw8NhbiGNUI6aeKEmUGAlgw1kl
         dIGSwQH55qaNnT04Z+Ng63CMlZcReWoK69FecarL40zPTfbuA18vy44v+Pnj8G6OmTMy
         nGPKwglC+dCr14kSD5lco1bkdspEYm9UtlLwlt6THyvatSyyGx4nGEbdZHOSBSsEzXV0
         fr4dB7hdNRBB+GU0L3s5FuVSEulXLXeuDaMADSHN+V1L5ifFkXpUmsbYrJw996VaDTsK
         /5bQ==
X-Gm-Message-State: AOAM532NnFezDPpW2OB7oMx5cHg4y9qUfslr81JQbR7XoqR/oXoQMwLD
        mOcyvOO2EwVpMDx9fNDWcnLIlxHia59GrlqH
X-Google-Smtp-Source: ABdhPJwdITa6tH6ryULjvah9baL4uBCjQNKGB2hwzYfDXpc8nGONMvMS5JKd+XRfjayntYkTVolc0A==
X-Received: by 2002:a17:90a:9105:: with SMTP id k5mr12413738pjo.48.1621094616914;
        Sat, 15 May 2021 09:03:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id kk7sm8247942pjb.16.2021.05.15.09.03.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 May 2021 09:03:36 -0700 (PDT)
Message-ID: <609ff0d8.1c69fb81.6ff91.a9ca@mx.google.com>
Date:   Sat, 15 May 2021 09:03:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.190-363-ge9fac36a943e
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.19.y baseline: 96 runs,
 3 regressions (v4.19.190-363-ge9fac36a943e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 96 runs, 3 regressions (v4.19.190-363-ge9f=
ac36a943e)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.190-363-ge9fac36a943e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.190-363-ge9fac36a943e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e9fac36a943ef8e037b40eb31a9521422b8d3e35 =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/609fbd164c1def65beb3afe7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
90-363-ge9fac36a943e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
90-363-ge9fac36a943e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609fbd164c1def65beb3a=
fe8
        failing since 178 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/609fbd194c1def65beb3afec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
90-363-ge9fac36a943e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
90-363-ge9fac36a943e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609fbd194c1def65beb3a=
fed
        failing since 178 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/609fbd20811d774ffab3afc1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
90-363-ge9fac36a943e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
90-363-ge9fac36a943e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609fbd20811d774ffab3a=
fc2
        failing since 178 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
