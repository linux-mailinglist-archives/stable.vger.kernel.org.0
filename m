Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4B114263FC
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 07:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbhJHFOo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 01:14:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbhJHFOn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 01:14:43 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0ED7C061570
        for <stable@vger.kernel.org>; Thu,  7 Oct 2021 22:12:48 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id 145so7167917pfz.11
        for <stable@vger.kernel.org>; Thu, 07 Oct 2021 22:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0XNREWJhM+rE2Mq+YGxWBELvFw+Wxi0YTRq6SgBGVi0=;
        b=47t/f1ljtktF7GFyay56kd0yw/EK2J7GPzFfoFQW61Ix3Vo3T9fxJidOSybmEneUnZ
         lvNjzgAtHsCi3NWemDZxNgViYwX2ZdPGUrxWrSpzK/wEIg2wKAjHslh+5q+uhj8CoiHp
         kNTw4QQ0MCoew7NJqMZ/g4m/9FuJEnfbd4dI7zhiv1aqSsf9IToVuvSFn+FypQpUkozA
         f4Ev05cI5MTSyYuLkjdXCif9Q1X5hIqhd1k8Wq747KY/V4s3QKxaf3DTgcb5r/6YxT7J
         Eys6cxthWPxsqxZkViCn7WOTqdwqybJjrvgFPrZGhTIn/uOXZI3COcplVaUAp9vswGn7
         mgGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0XNREWJhM+rE2Mq+YGxWBELvFw+Wxi0YTRq6SgBGVi0=;
        b=GSASXK9p7Td6MILxLUE6uWJDzOJXegCbRpQlsznMrm0r0sFh94LtnJf07FaAHNp0bO
         JYejbKR3SB2wmsjBdXkfKg0THsl7J2eQ7TT/A33btqgGNpz8OjYfub8cFOUvO8spa3g/
         tJh3fqwJVqqWCH+EHf6o5xfRCIY++yQdYhV5NWSQOJcjxZDu/tskBgMOkU6svReKVzqQ
         63pBGH/YqtO+SeWZXHGFYCYfX9uL8S1bJ8SEMuPwReQRbKK4SR0J0cob+zQe2fZ/2wu/
         kdfaQt3Cx4d1ghaMkjLO03YcS2bkMvdigM02OXk34MwV0yhRJ0E5864ph5uDIPWAlD2k
         b6eg==
X-Gm-Message-State: AOAM533SqqR71Z7vlzjx3mmoSAhmXdCxBSqsiQV6gaiNQX7zXp6ALeMx
        z4iQQ3M6EqtuPEJ3dsv4fy22eCaYNVqx920Y
X-Google-Smtp-Source: ABdhPJwoSO+d3JsoanNSt86uJ9lXFt8hvY9cP77ivWZN8FBQEuQOh1HDxsoxy+Dz0wB2iV6faIyxSQ==
X-Received: by 2002:a05:6a00:26e9:b0:44c:654f:80e9 with SMTP id p41-20020a056a0026e900b0044c654f80e9mr8515896pfw.14.1633669967569;
        Thu, 07 Oct 2021 22:12:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 130sm1065318pfz.77.2021.10.07.22.12.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 22:12:47 -0700 (PDT)
Message-ID: <615fd34f.1c69fb81.f047a.4498@mx.google.com>
Date:   Thu, 07 Oct 2021 22:12:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.209-10-ga1bf7827b475
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 114 runs,
 3 regressions (v4.19.209-10-ga1bf7827b475)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 114 runs, 3 regressions (v4.19.209-10-ga1bf7=
827b475)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.209-10-ga1bf7827b475/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.209-10-ga1bf7827b475
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a1bf7827b4757cef6545da96763e9be7d3b92f5b =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/615fa1e2bbeb96ebdf99a2f9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.209=
-10-ga1bf7827b475/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.209=
-10-ga1bf7827b475/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615fa1e2bbeb96ebdf99a=
2fa
        failing since 328 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/615fa66c1c1eed743d99a30c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.209=
-10-ga1bf7827b475/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.209=
-10-ga1bf7827b475/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615fa66c1c1eed743d99a=
30d
        failing since 328 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/615fca1a442816930b99a30f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.209=
-10-ga1bf7827b475/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.209=
-10-ga1bf7827b475/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615fca1a442816930b99a=
310
        failing since 328 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
