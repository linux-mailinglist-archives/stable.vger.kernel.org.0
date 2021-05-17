Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE059382C84
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 14:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233477AbhEQMsz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 08:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231591AbhEQMsz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 08:48:55 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D9DC061573
        for <stable@vger.kernel.org>; Mon, 17 May 2021 05:47:38 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id h20so3075115plr.4
        for <stable@vger.kernel.org>; Mon, 17 May 2021 05:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ox2ablRo6P2B43ACJi7KTacH6WVXHhxRtRwsCXX5Cmo=;
        b=CRmR9X5fAMlrm7veWFCw0kZG5ftFtuieBHoUTDjThyHd2lyIu20fVx4U0/hudJMOkj
         SEzIoqEtPH7zx77OzYm53xJhhN0UHUg1rRNgzJ+0n2G/h7DOIgcEg0zLUixnE+0iCNgV
         wpSsmD2Wu/Ur6dp6f89tG+SvnjmeUj0uqk1OtjIe3NUOg9T1WMZ0Gpa/iY62TJQUx6GS
         lRvb9EDauAt5JPGBSnuS1/1ljmXuptku55jvXVRZ8uLTmfe9/I4mggUlrCEMHne6blJq
         egqzRCMAZAsx4lHbiaNOpYZUpPLpExB42QsVkoi09CyquWcxJaRLbZmgEwBgS2wq0R+p
         jDuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ox2ablRo6P2B43ACJi7KTacH6WVXHhxRtRwsCXX5Cmo=;
        b=glP+l8EPcxiB5YvgLzLX6iab/5B9axpeopQ4vu8FuM9DQbKcct/T/fyMX9ouh9M9wJ
         YuCpaDNEnZ7c6KWMqXHjVlOZEVVDCeE5d8jw5tdsTV5oKIYhnoOSAQJX627t+2+/As/O
         PWNCzP1UHDvBMQpjzpaluZD4BJu33SrbuATD/l9spX9XevWKJrHb18rsHqT7ikgRD2AQ
         WUTBL24xMU9tM6Apkd6jQHkRjFy+HAEAZoTGqXTkSb35gl0wEwlozsvjfsOwQyDEGAot
         iyntaXuI5TlZb1QTa5jtpCQhj1M5J9p82jn3yD/0g78lEOTSjKqy/AJGZ1UPa8qP6Rqb
         o/4w==
X-Gm-Message-State: AOAM5302z/lpiwNLp0yb6JOsvl2GKcdNsklQ7gIY8lK4vKNobaC6dYT0
        sqFpitdrGNB5gD7g7IsfjKlZcYRGkXPLePZ9
X-Google-Smtp-Source: ABdhPJzSaAg9KWcSVZwlUeFNWxJT3+AgpVhuRPdjc2KEfgBwzcY6bOpwvaRncL3a/ws0/YQUVSCPfQ==
X-Received: by 2002:a17:90a:b116:: with SMTP id z22mr18227615pjq.113.1621255657574;
        Mon, 17 May 2021 05:47:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b13sm10149743pfl.140.2021.05.17.05.47.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 05:47:37 -0700 (PDT)
Message-ID: <60a265e9.1c69fb81.de1cb.1df9@mx.google.com>
Date:   Mon, 17 May 2021 05:47:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.268-211-g24185b9286d3
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.9.y baseline: 87 runs,
 4 regressions (v4.9.268-211-g24185b9286d3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 87 runs, 4 regressions (v4.9.268-211-g24185=
b9286d3)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =

r8a7795-salvator-x   | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.268-211-g24185b9286d3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.268-211-g24185b9286d3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      24185b9286d389a1f3508fc62fe35384a84a5635 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a232a39c933a8cf1b3afb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-211-g24185b9286d3/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-211-g24185b9286d3/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a232a39c933a8cf1b3a=
fba
        failing since 183 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a2329e9c933a8cf1b3afb5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-211-g24185b9286d3/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-211-g24185b9286d3/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a2329e9c933a8cf1b3a=
fb6
        failing since 183 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a2329f817af84c25b3afaf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-211-g24185b9286d3/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-211-g24185b9286d3/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a2329f817af84c25b3a=
fb0
        failing since 183 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
r8a7795-salvator-x   | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/60a2348866a86b0a3ab3afa9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-211-g24185b9286d3/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salv=
ator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-211-g24185b9286d3/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salv=
ator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a2348866a86b0a3ab3a=
faa
        failing since 180 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-79-gd3e70b39d31a) =

 =20
