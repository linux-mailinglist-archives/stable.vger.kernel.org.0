Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0B437F16A
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 04:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbhEMCnS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 22:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbhEMCnS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 22:43:18 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ECBEC061574
        for <stable@vger.kernel.org>; Wed, 12 May 2021 19:42:09 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id h127so20331014pfe.9
        for <stable@vger.kernel.org>; Wed, 12 May 2021 19:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WbK9GrsCP+zXY7G80Qm1qLvKED6Pe9LvyznBZBh29rw=;
        b=09TGyegIMYqSPCBRPXHIK6Z5Jg2Hki0IGFfzVlAkaifqe8VLBP24H21e03HMiwB06n
         FJ/h89JdXJrpz0lPuxjsJO7GZcOzmd2+4Ao6/BP7hg5s0NZZMnXuF+QzdtS0Je/sOj8M
         +h4XH800e73DQ6cLy85+JX9wmi3b/lTaH/PedcN86wC5Pe2AeS2OtJhl508uC9fyVzYh
         YUYFshirZWtfdgc3SNmsHM9T99Z+C9Qy6tWgrmv0f1lIP++PRk2zWt0tOZ3Gn7YKgT5f
         c+/kQyC0VO4cnfXGR0PTKDTsQyE7PPWbOn4ahslMUUA6jAc4VvjTn/AlV2Y9bwlmbh/y
         B+Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WbK9GrsCP+zXY7G80Qm1qLvKED6Pe9LvyznBZBh29rw=;
        b=WWRRsCG8eKP6eZ3xZvEoxUgU0wc+BMqJ2laQ85ezVA7gdJtKTgKEbb4p10iBb7LxoP
         qMDHXqUO2G4SGVL5nb411smRuGB9O819dPssa0daeCjpUWaqS/6pugrdp131NndAdhn7
         8Lp//JuORRgqrEAfZyfriGm1wPVsNETea9OoongIWzKrUrvEmGq5mB3KKnzPYJLq2cft
         oYlJH9r2FbQMpm9eotfeY1aIggxjARkBeOq4s6fB34jpivaDIR3RMsZhMOv0eLYu61Ay
         BArN2VrHQ/Q0e2qAHZfV3UiGfNCcKMdv7ZSQBgVjZRNeOFLAzaT5wsNj0ttUcNUgggi+
         UjaA==
X-Gm-Message-State: AOAM5324Z9lXRj14oLd5qRB6/WCWn5O/4+ogke/45CxgVlgYLtFGXALK
        0/Ew6TfifCa4xBc3uSEpNmrC9upmwFo8axv2
X-Google-Smtp-Source: ABdhPJxCv/cncQ96BZoZw8C/kdrrvey2mPlKLx8O8AaM31Z3WG99hYonnljWZFFPFk2oJBQRQ97gxQ==
X-Received: by 2002:a63:1c6:: with SMTP id 189mr29296809pgb.144.1620873728697;
        Wed, 12 May 2021 19:42:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h2sm914366pgr.37.2021.05.12.19.42.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 19:42:08 -0700 (PDT)
Message-ID: <609c9200.1c69fb81.cba33.446d@mx.google.com>
Date:   Wed, 12 May 2021 19:42:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.190-301-gc26f37c7539f
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 104 runs,
 4 regressions (v4.19.190-301-gc26f37c7539f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 104 runs, 4 regressions (v4.19.190-301-gc26f=
37c7539f)

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
nel/v4.19.190-301-gc26f37c7539f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.190-301-gc26f37c7539f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c26f37c7539f0d70279178363d979b3d1c4f99a7 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/609c5df3b7475863f2199297

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-301-gc26f37c7539f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-301-gc26f37c7539f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609c5df3b7475863f2199=
298
        failing since 180 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/609c5dea24171cd094199280

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-301-gc26f37c7539f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-301-gc26f37c7539f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609c5dea24171cd094199=
281
        failing since 180 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/609c5debb7475863f2199291

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-301-gc26f37c7539f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-301-gc26f37c7539f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609c5debb7475863f2199=
292
        failing since 180 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/609c5d9fc8ca4a373f19927d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-301-gc26f37c7539f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-301-gc26f37c7539f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609c5d9fc8ca4a373f199=
27e
        failing since 180 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
