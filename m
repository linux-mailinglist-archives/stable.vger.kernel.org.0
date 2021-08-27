Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C48CC3F9373
	for <lists+stable@lfdr.de>; Fri, 27 Aug 2021 06:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231830AbhH0EP4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Aug 2021 00:15:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbhH0EP4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Aug 2021 00:15:56 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 402CBC061757
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 21:15:08 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id u11-20020a17090adb4b00b00181668a56d6so3921965pjx.5
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 21:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3MUi1U1assjMIxxsaspzRwW0ckOYJnSXIMMXkdTXp6E=;
        b=ebFKEA2PCwLgKk7vsmqtuC/WT8RKzVsk5udIjDEIW4adBzLDeODKtQKkxKlF2N9N3Z
         2y0/Kmtuh4/R09Mg0Vj1mDWFhT+MkGdD92OLEkSB420da0nRR8oPdWyF37t/5IjwbraP
         0giTuhqzWBcLkHbv4y/qMBC8VF9xa0R3Ffz1t3cQ7I9CoLluitb/bdX4MmlvLDPY+RSs
         r+YBHJ0Ce98veF2c8lkZL76kkSIx8Lr+BUMSe99eSjKLc28mZnESsguJsdbSDFF+AC5z
         pw+hqFFv6nzqwUY+HaYh/dW0GR3ev7ZgbprU4QCg6o5+jVcYhkjL89kyQ7PJEoweSnE0
         KF/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3MUi1U1assjMIxxsaspzRwW0ckOYJnSXIMMXkdTXp6E=;
        b=nuAeyJXrzBqDIgpTq1fdw5akC85g1U/bEAbBUnJTu98wRnXHXKuBnhGwa991Hzxutb
         U2JhsZKj7eMeR78KEayYGDu446gLzyVlJulxLucuEgG+klyOFHFXPvxknPJCXm+pnKZA
         PZt+nIVEWiATo8V1Q29GzVZTKPhfUAdoC9LiXYqEOr/0xjg+7aYtEfOoO7FIuHvWpph8
         1MGAh0DCTeNymcJXE8wuP4iQ6TKfrnLsF9qEAMEeDfSnYWHmCaDAQZsrHvEJjAiNE/LJ
         PQQySk0e4fNYptG9jcIsosqhRRi4Vl+k69SZGdWGnSyEKlzyevFRyO+xj11Uq6s6Kb5S
         VaOA==
X-Gm-Message-State: AOAM532ayLj+59QfimRKAM8u/tOcgC7BNh/TZbsY09RKlBwMwHemCcaA
        iQxR+kT65lvgiQar76jhJ9+ms7Ydh5yp+CHh
X-Google-Smtp-Source: ABdhPJxNQL8C72uYHWK7SdjhMYIirLxfTfXCiDDs0wR14g85xXhObYLW/5v3fx2deMKcUjZooq4rRg==
X-Received: by 2002:a17:902:e80f:b0:137:3940:ec35 with SMTP id u15-20020a170902e80f00b001373940ec35mr7043205plg.16.1630037707556;
        Thu, 26 Aug 2021 21:15:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s1sm4429818pfd.13.2021.08.26.21.15.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 21:15:07 -0700 (PDT)
Message-ID: <612866cb.1c69fb81.a4879.cc11@mx.google.com>
Date:   Thu, 26 Aug 2021 21:15:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.205
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
Subject: stable/linux-4.19.y baseline: 124 runs, 3 regressions (v4.19.205)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 124 runs, 3 regressions (v4.19.205)

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


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.205/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.205
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      e23d55af0e1fca9be5c99f0c37d48b289f4d6489 =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/61282c33bdd775dfc18e2c7c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.205/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.205/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61282c33bdd775dfc18e2=
c7d
        failing since 281 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/61285fce2995d335dc8e2c9e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.205/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.205/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61285fce2995d335dc8e2=
c9f
        failing since 281 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/61282c28acb3321b038e2ce3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.205/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.205/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61282c28acb3321b038e2=
ce4
        failing since 281 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =20
