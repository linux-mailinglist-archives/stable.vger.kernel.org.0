Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 478AD37CEF9
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344410AbhELRH6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245396AbhELQwb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 12:52:31 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55FCEC022AAF
        for <stable@vger.kernel.org>; Wed, 12 May 2021 09:31:33 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id z18so9196320plg.8
        for <stable@vger.kernel.org>; Wed, 12 May 2021 09:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TBBAtQ8cMiTgJZTQhU/iCahZLrjQ2CeT+0mYeKQMcMw=;
        b=IOYdXSxAI2XJmL7D2oLLAl9m+a7cHOEi8ZUW1rKUxMXZDh1Dtbnym0I7+0eL3sixls
         R6hJr6JH8aulSYe35/4G/qZERC0Z8fNYQTsOsaUttnJV+zCuXfUWACdAosmTdxn57m9w
         Rsy/nDM0iua2t3ZROiGWt+OVmyGV1G47sTUgPRflKGecxRpVy3fLQuyDg66XxxPe8QAq
         uIAqLiykh7Tb2sjpi8GVYxh7aOhXTYyovVxXyUboEv4QYmRM89ZTaups/ezZu9FrXDgb
         Em4LPQ+6s6nEnDNmd0ByvJOC9gdrKQDfzohwOzIwPxOp2cLumWT5d0IL4QxCeQxG6F3O
         LzIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TBBAtQ8cMiTgJZTQhU/iCahZLrjQ2CeT+0mYeKQMcMw=;
        b=Wg4NwWAhNbaRXT09Kjs8tsBRPGiMpb9eQcxUUxckK4tV52ox9yRu5VkrBi204gHm+u
         3hLr955X5nOHcbnj7gPcz1CYEZgB/qIA7oajA4eGApZakMeIExEHqqx97ksKV1H5hvCM
         fMpNTbMDrSF23Fw4KzYBlwEznwb9uo8iy9pwZxmjb2Br4yUqmYebgRQTuVwrlcS92DXP
         BWwk5WoSXq2om5RoFYjQaZJTVIMH+rwFikEt26z6xT08xRie88zM5AAcGqUR/kFVWbW2
         Dd8rLQZ9w/H/IiYF1uJFNUuSobibsZiX6k3lXxqHeEHFrlspCdN/mxzGopIz/amPK2eI
         gK1Q==
X-Gm-Message-State: AOAM531EaqLlcCy1Ejk7i2FROWQJCAaOAnTsAisMNG0K+EsD7vOuN3Mq
        AXnQQLKd6/zAG4iOnhagFsWKAFbBF32Lm8XV
X-Google-Smtp-Source: ABdhPJwt8RpJWBSZBHL9G2je9APEAZlXpMTqRyewA1vNRroqRL7H3JWgIn2RotX+lIImWARywmtgDw==
X-Received: by 2002:a17:902:8c97:b029:ee:f8c1:7bbe with SMTP id t23-20020a1709028c97b02900eef8c17bbemr36251043plo.8.1620837092699;
        Wed, 12 May 2021 09:31:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z13sm296437pgc.60.2021.05.12.09.31.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 09:31:32 -0700 (PDT)
Message-ID: <609c02e4.1c69fb81.49233.1081@mx.google.com>
Date:   Wed, 12 May 2021 09:31:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.190-300-g50e98dbc7e725
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 145 runs,
 4 regressions (v4.19.190-300-g50e98dbc7e725)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 145 runs, 4 regressions (v4.19.190-300-g50e9=
8dbc7e725)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.190-300-g50e98dbc7e725/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.190-300-g50e98dbc7e725
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      50e98dbc7e725fd2dc96fa5550826209a6b35cdd =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/609bce0e9d2f844112d08f2c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-300-g50e98dbc7e725/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-300-g50e98dbc7e725/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609bce0e9d2f844112d08=
f2d
        failing since 179 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/609bce109d2f844112d08f31

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-300-g50e98dbc7e725/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-300-g50e98dbc7e725/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609bce109d2f844112d08=
f32
        failing since 179 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/609bd22995ce8305a8d08f2a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-300-g50e98dbc7e725/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-300-g50e98dbc7e725/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609bd22995ce8305a8d08=
f2b
        failing since 179 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/609bcdbacf6d296c35d08f3e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-300-g50e98dbc7e725/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-300-g50e98dbc7e725/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609bcdbacf6d296c35d08=
f3f
        failing since 179 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
