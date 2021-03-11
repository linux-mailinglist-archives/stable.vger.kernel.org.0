Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1B44337B6B
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 18:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbhCKRz3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 12:55:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbhCKRzH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 12:55:07 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6146C061574
        for <stable@vger.kernel.org>; Thu, 11 Mar 2021 09:55:07 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id n17so7024197plc.7
        for <stable@vger.kernel.org>; Thu, 11 Mar 2021 09:55:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/tupR9fBRfCXGgf4q8RrYBCqM6mddJreoJ2YNeagO4Y=;
        b=j8ruubX7du01Rmtq/BUoWeaOQanoYKFK8Kn/M5RgDy8uTcyX9rSXEWCjLInzkK3Xgm
         GxfA61pSUihdTKE+j41Jx3XEQtGmJvfJqHKZeeOTOvMPeh7J2kcGI5tdDV+B6pGG1f5Z
         pIRFoTFLWEq/TzVKMBKC5l2d+cB60adhkbAXTLbzvs4kr1w8c4EmqXkbzR5XNUttlvTp
         e+5t2mkOgZj5CVd1TdpeYrElTU68ZarKP8KDbqhyaIin1QFOT0czaSLuf7REFuIov1aS
         i2HGrR5y3YSHYDpSMo43bfIRLRNHB8pK705XzRIrA4AXX0cfMEtHBerto4HbsF9b+jdU
         ++eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/tupR9fBRfCXGgf4q8RrYBCqM6mddJreoJ2YNeagO4Y=;
        b=GpDZU8Wjj4bHW0YERhmosnmwyPFmT97OXxHP6Qw2n46KPz0Y0GNRGsiqPXOc/54yP1
         Fptp1tj08SW7DNQU4GXEl7jKNwtGI8G4z0lDMxhzJsaYaR6ayl/ivcMYePmsr1w7ijls
         b6GS4SXNYeXKL104jxwAI7wzVQ6ZHfebujkB5wEUsjsHGoKOm/e3CfhduKZOVlPNC1Lg
         dU/TGE277r/b9YegTicF5S23XqGvlkkjc+7WPIvD1MXHpKJnoRiyQ2xVhOsaeI0/zo8Z
         4jOzqcuwCVpBLe3NSVUuIGMrPwpzW/lkG2TFzRQeYfJbVCo2jWg59VrwjOPpzjcV4jcJ
         OUwg==
X-Gm-Message-State: AOAM530kYuZPZpJkoBH4tZwkArv4+xE4/vQmP9wt/Zo3/P5Lw/wKJD7D
        w5EebsI4aA4fYfk1zaEGN/nm285CIyxF7zhL
X-Google-Smtp-Source: ABdhPJzTRcoAM5NLcsm3ACUtumkEp5qMjXb9wB6mVI5v0bxDAixM03MSl4xuk06orTrEjOMa1F6sEA==
X-Received: by 2002:a17:90b:686:: with SMTP id m6mr9760591pjz.26.1615485306945;
        Thu, 11 Mar 2021 09:55:06 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t10sm2969628pjf.30.2021.03.11.09.55.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 09:55:06 -0800 (PST)
Message-ID: <604a597a.1c69fb81.f81ec.7952@mx.google.com>
Date:   Thu, 11 Mar 2021 09:55:06 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.261
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.9.y
Subject: stable/linux-4.9.y baseline: 71 runs, 3 regressions (v4.9.261)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y baseline: 71 runs, 3 regressions (v4.9.261)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.9.y/kernel/=
v4.9.261/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.9.y
  Describe: v4.9.261
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      1feba1d9c860c6082d5f7acfde54feae74151a61 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604a234515ee80fa06addcc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.261/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.261/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604a234515ee80fa06add=
cc7
        failing since 112 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604a23481fdf2a8424addcd4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.261/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.261/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604a23481fdf2a8424add=
cd5
        failing since 112 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604a22d1526341d681addce0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.261/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.261/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604a22d1526341d681add=
ce1
        failing since 112 days (last pass: v4.9.243, first fail: v4.9.244) =

 =20
