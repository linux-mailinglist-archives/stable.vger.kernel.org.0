Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E11C3E3B23
	for <lists+stable@lfdr.de>; Sun,  8 Aug 2021 17:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbhHHPkH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Aug 2021 11:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbhHHPkG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Aug 2021 11:40:06 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E74CC061760
        for <stable@vger.kernel.org>; Sun,  8 Aug 2021 08:39:47 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id mq2-20020a17090b3802b0290178911d298bso2745195pjb.1
        for <stable@vger.kernel.org>; Sun, 08 Aug 2021 08:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=n+Mcy6ySeLfBrSkt27b+ITNGvO7GhF7HOEgsf8tNsM0=;
        b=xeEbo0Uygs8+OClGQ8ABvn7mkRA0QdFWEa2CPNkQI2JRtyWxL/guLKRa65pMjSw854
         Ug3gPEhp365RMm3ls22mqIOLO/P9cPpGNKHdREkqgrhqZwHGG68tYlvGjgTq22nmEeNY
         LDFkQ2g1vDVtCFK2KwlCm2s0JBalDfr4qIlfw5SG8n2zGTz2UHoZ/f5wCD82SZSj9XJ9
         gGgMdCpceC8D8YOkolJVes/LYBl7yCUpXjoV1mR5rCybRBqoTopU096E8kbBSaHG8pbT
         fsvWjiYQBUvIr6Xwk1pNd+jTdPBBTB8crS5WQrzaJtbM+2+MuFNaj5Wa4p7qnnM+jXZL
         EyRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=n+Mcy6ySeLfBrSkt27b+ITNGvO7GhF7HOEgsf8tNsM0=;
        b=loJzx848GierdE/p7fyGTTQT5zvMxq+MXhdvd9FO0tK+4ZEZ2xwXLvjj6YU/9Lcofy
         HOw1SELbvAfxTgeAMRSErRYRqScDVvNcKLGtsiiJMa3o4NHNMzoMH4NoxqM2Etod9mxT
         PqJr3fpQ+IQwBxo0+RR1ExTR+yfxqELTKkQhZIQSYojeTY1Hjjci5vFgObckrXZSrelW
         MTqgedARmrUIW0NXMxHJwmyiVop4bRAxWB1Oa3m6NkcsgQTgFwuaG3LQkWun8jEi0zyw
         eOmjkQEg3z5AuB2sWQ+cD+FLIH72xvyR1UiMlXROamsjfVS1jHinHAfy1iEcqqLG/J1t
         VXIQ==
X-Gm-Message-State: AOAM530AG7Iuiuagno/CU48pk4RawETtjpW0Y3oUtRe6cJ9dg4ctTLq5
        58K0KQwLWL4uBJYBjoc/BTlyRR6lDSZirNJ6
X-Google-Smtp-Source: ABdhPJySW1/GoJwWtFzSharNjYHweoRQiIMtEBzWW21QNTgr/U9nbv18Toaj8b7Hs+1K9dlcQEreDA==
X-Received: by 2002:a63:1952:: with SMTP id 18mr1473397pgz.15.1628437187009;
        Sun, 08 Aug 2021 08:39:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ms8sm19099722pjb.36.2021.08.08.08.39.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Aug 2021 08:39:46 -0700 (PDT)
Message-ID: <610ffac2.1c69fb81.4e1a6.8a8f@mx.google.com>
Date:   Sun, 08 Aug 2021 08:39:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.19.202
X-Kernelci-Report-Type: test
Subject: stable/linux-4.19.y baseline: 120 runs, 4 regressions (v4.19.202)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 120 runs, 4 regressions (v4.19.202)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
imx6ull-14x14-evk    | arm  | lab-nxp         | gcc-8    | imx_v6_v7_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.202/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.202
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      5c66974a63046780925e5d99b6dc6631fe2f9a31 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
imx6ull-14x14-evk    | arm  | lab-nxp         | gcc-8    | imx_v6_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610fc7c5211f60fdb0b13662

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.202/=
arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ull-14x14-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.202/=
arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ull-14x14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610fc7c5211f60fdb0b13=
663
        new failure (last pass: v4.19.200) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610fc2c3954a5f5340b13683

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.202/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.202/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610fc2c3954a5f5340b13=
684
        failing since 262 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610fed193ef000eca8b1367a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.202/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.202/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610fed193ef000eca8b13=
67b
        failing since 262 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610fea620af62815f1b13671

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.202/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.202/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610fea620af62815f1b13=
672
        failing since 262 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =20
