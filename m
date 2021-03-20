Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D982E342E3D
	for <lists+stable@lfdr.de>; Sat, 20 Mar 2021 17:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbhCTQNa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Mar 2021 12:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhCTQNP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Mar 2021 12:13:15 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45F62C061574
        for <stable@vger.kernel.org>; Sat, 20 Mar 2021 09:13:15 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id y200so8024695pfb.5
        for <stable@vger.kernel.org>; Sat, 20 Mar 2021 09:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=z5fH55Oijb2OTkwfekSlAhSbgXEcdj+rP87pcNz0Vzs=;
        b=wzlNWouzr06d2WKjgAwOnsN0RMRWF7NO6A5FJgEbixDBWn1PaA6a2JZbtF2FoWY1ab
         +la5VuOYfWy2uJRwfovGsiadaTSFJUt34XC+KijlS5KHxc5Z7nZL89VZtExczO8niQfg
         3uZCC7hopcgeR5MMGA/MGt1aQs36BXyjZNTWYpPHioEV5oK4++bzUHONy9Wdq+ghmCjb
         DFPL2TJ/122qz/g7gkxAjB9DKE2xt4J3jkpGvRjpbRX6JJSDd6717bV9ZiC0soPCitGD
         9HxinAoQ0aLpoS2opbwccFdNaNEHXOpx7hvQgfanVSL06+J0BMZGnMH0XJBcJIXSB46h
         mrDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=z5fH55Oijb2OTkwfekSlAhSbgXEcdj+rP87pcNz0Vzs=;
        b=QG98/7sC9BGV3saxFJBEnYnPqvC0jSbFSnWL3sgq1w/WPsIz5MTyOBrTh4lDZ9JGYl
         tP4Nr3SB0BstVTq+lIBFGeoxmdu/1aimF1YoADAsdIPXhbRTV/3m3ueAuSaFsmNoQj7W
         tqden8zvRhBW/6sZZJPgLopcNossipufApxlG6DrfrwmVjEhNLw9COmaY6RNYqy69+Cm
         TM0+wVym0ZvlMfjAnBoO3dh7SVis7D+I1nyR1IW+vcw/nooCF2omO/YWTMaafvS5xln/
         K/gSvPA60OOwaJVdFD8aRX2BYwI3Y/O1b+ETXCST5frMhPXAKtY+Utb+OHTY2ezNNtG/
         4y3w==
X-Gm-Message-State: AOAM531x3WB3vRFCjYC15b32O/D9M2/+DPQfdqtSICssQIF37HW+USZq
        UjJEh+g+vrGqM+1YqsDlRkpYhmfcC3QzVA==
X-Google-Smtp-Source: ABdhPJzbZtliUzdVt9mnKDZ6NKc78/2r47P+7Ha9G7kwpt3H11DyyK331Y3J+uQ5+da/HbcuGpclxA==
X-Received: by 2002:a62:2f83:0:b029:1ec:48b2:73da with SMTP id v125-20020a622f830000b02901ec48b273damr14395618pfv.1.1616256794513;
        Sat, 20 Mar 2021 09:13:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o62sm7909692pga.43.2021.03.20.09.13.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Mar 2021 09:13:14 -0700 (PDT)
Message-ID: <60561f1a.1c69fb81.0b5c.2b17@mx.google.com>
Date:   Sat, 20 Mar 2021 09:13:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.182
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 144 runs, 4 regressions (v4.19.182)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 144 runs, 4 regressions (v4.19.182)

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
nel/v4.19.182/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.182
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      125222814e7b8f84df767d6ab622aff2a6d2f234 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6055ece981c019fd8daddccb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
82/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
82/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6055ece981c019fd8dadd=
ccc
        failing since 122 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6055eca11a978f42ebaddcc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
82/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
82/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6055eca11a978f42ebadd=
cc7
        failing since 122 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6055eceb6c14c6870faddcb2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
82/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
82/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6055eceb6c14c6870fadd=
cb3
        failing since 122 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6055ecdc81c019fd8daddcbf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
82/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
82/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6055ecdc81c019fd8dadd=
cc0
        failing since 122 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
