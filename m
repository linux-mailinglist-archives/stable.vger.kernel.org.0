Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 785B1363697
	for <lists+stable@lfdr.de>; Sun, 18 Apr 2021 18:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbhDRQ2j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Apr 2021 12:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbhDRQ2j (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Apr 2021 12:28:39 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 065E7C06174A
        for <stable@vger.kernel.org>; Sun, 18 Apr 2021 09:28:10 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id e2so12143984plh.8
        for <stable@vger.kernel.org>; Sun, 18 Apr 2021 09:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Bssz5pNmqzSMUolk+sLz4g07w4xOuQXf4M/Ng9YEP9s=;
        b=XgCfUVKWr/ytT+L5EYblmVt4lGzbFjTb4uvhnxb6X+dLrFB4IUmIZnHxeMTlKbkomy
         LoZTt8+buxR3JpQDn5exEDQIxA1L3B5ihywwnsumhmzYTcTsFD/q9doo1eOl6NGBvTNW
         oekrzdAwjSoaRzc/9TgGgxZeybYtsH0cvKzofY8LNgE1idYGSnfFX+IvZYF+2U+TJo0W
         F6zfhDPY2fREa1GAvS+Kn/uxOAZC1xnLxUEoWABOC2cOzm1v/KXrnZp8GcJEoxJkctUe
         /3afX0WBzPpDrlZpX5qhfmFQcYBoFOtRoJFaO0hZ4+IsA28DW3nStBdgXEqWAAvIHY3d
         N3lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Bssz5pNmqzSMUolk+sLz4g07w4xOuQXf4M/Ng9YEP9s=;
        b=Ay6zKa8mOUMcwT2NrdLAEfbrLOX6AIYg/AgpZDXqyIg39BvNiIzORuXUmWTA1/Obed
         GhWXl/v1Y8nFYLwGUqloDcHaxMFKjfodr+9OiBwDcX/r+kcmuQQgyrlhRjd5nONWrsT/
         APVxeT0FThVF5NR2XZRAhvwg7Bxl7rJI4pLrMX5bK7wkpr1YX3ZuaoZJ5tReUi+NK4KM
         wxfpgtuUZ0Qe2Tcf8bWE611TMyz7GAablJ3EVRaAMghriHR+/WNcUyIFCMCHo5oKdV2n
         GAudYTLygyun0Wm1n1qV95mum67Su3UEqt/IzbXmkcSqC8UNlaiwob/AgcRD54l59UlD
         yAyw==
X-Gm-Message-State: AOAM532AiwFm/xgJwmvJN9zXKiDlY+QBFJ0E2SUdVArtN9RJnIBLRmmG
        WfOjM1rfIOEDFSkbLDlpUSp+ot3TjW/7HKZt
X-Google-Smtp-Source: ABdhPJzj5JwOyKQwzf5mgZMSxisOArJbgFSoYmfF84B5sidRouH5CEpcE/hweUiFvBfsbNXqNpXtwg==
X-Received: by 2002:a17:90b:e8b:: with SMTP id fv11mr20381368pjb.66.1618763290176;
        Sun, 18 Apr 2021 09:28:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o27sm7332929pgd.76.2021.04.18.09.28.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Apr 2021 09:28:09 -0700 (PDT)
Message-ID: <607c5e19.1c69fb81.82378.fe21@mx.google.com>
Date:   Sun, 18 Apr 2021 09:28:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.188-31-g6412e1b666bd8
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 108 runs,
 4 regressions (v4.19.188-31-g6412e1b666bd8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 108 runs, 4 regressions (v4.19.188-31-g6412e=
1b666bd8)

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
nel/v4.19.188-31-g6412e1b666bd8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.188-31-g6412e1b666bd8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6412e1b666bd85cc021319c0787f9a0819e390ee =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/607c2b84f5da528898dac6e5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-31-g6412e1b666bd8/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-31-g6412e1b666bd8/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607c2b84f5da528898dac=
6e6
        failing since 155 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/607c2b8cd52ca90c61dac6b1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-31-g6412e1b666bd8/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-31-g6412e1b666bd8/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607c2b8cd52ca90c61dac=
6b2
        failing since 155 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/607c2b9ad52ca90c61dac6bd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-31-g6412e1b666bd8/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-31-g6412e1b666bd8/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607c2b9ad52ca90c61dac=
6be
        failing since 155 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/607c2b2c7cc320a737dac6b7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-31-g6412e1b666bd8/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-31-g6412e1b666bd8/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607c2b2c7cc320a737dac=
6b8
        failing since 155 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
