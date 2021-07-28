Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 034C63D9659
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 22:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbhG1UFM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 16:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbhG1UFM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 16:05:12 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7879EC061757
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 13:05:10 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id e5so4067135pld.6
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 13:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=K2gVA35CxwGhvMjhXgEUtzAdzJJ3E/jA8hFQYqVyNbc=;
        b=O+d536q3NjdoBlOoPT6O2nR6a2+8DmmllfqVyaTTt5QKUQrB6NDIgafZny6zJFS85Q
         wJIskWpKi1sjuD0NCdG+6A2ohwWsWfZHjZeeF8e3Gcxjz3vntBvZIBSmwkbtbbJgfUBC
         2c2SQSo0zx/nLUnDZ4FTk3lL6C7Kh5umEoALb7w7JG5oad6a/DlHJeJsXhts5nxvuIWV
         fUcfK4ifkDLcpBASJUIlRscHyCHa1lzy9SZSr9vDv5nFawSnqfLr6/X54kV3cyDWO/bQ
         jbg/bpPk50YvaOsG+WWgskwOWZAWQHOi4ITOUmkL4gmvwOGqZ/g/G3imgjVOXmWgwzb6
         vJrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=K2gVA35CxwGhvMjhXgEUtzAdzJJ3E/jA8hFQYqVyNbc=;
        b=qp/h6CAn2ywuEr/qyhFod8pdO2N92BeO3D81B/bJg/FgQZr0wYodz6y9wB7a4++Cb2
         +8f9akQWDHfnpuYPEJmENrFDl2qhnQ1TQMSFC4c4tJI2O6yMQEKECu79UEYNYwFxT+5T
         2Wm5riyfMvvnLhNM2uaxfbkMdamfkdutLCPbgVCYC6lRG42TL4wga5cwisfTqfzrJc8K
         eoY8/wxE8CyNMnC6nJPGFpB6ORcgNqcGzImcptPOEq5I3tspePIqni1OB3FY8AyZvArd
         mGzpfT0l5L4NHLcrV6XOupzcwBKeDWMSK/nchhqpVn26+7tO5np2aDC0L8hZSzJuPZyo
         Do/w==
X-Gm-Message-State: AOAM5317wEAYLXuKDMWar47fHSR9nRA9BuOIt/Y58Dxla2e/xNdGv3r6
        QRa6WsugmxKiwLsboOKs7HCbaLV8HUA+7wnI
X-Google-Smtp-Source: ABdhPJzGCHvolcKuXBzouIo/8m5X+JVM0sYap7B+r46t/NUJidbFxZ13yR/GYdtsBQLYH8VLkTJ/ug==
X-Received: by 2002:a62:7754:0:b029:35f:f70d:11cb with SMTP id s81-20020a6277540000b029035ff70d11cbmr1536136pfc.2.1627502709890;
        Wed, 28 Jul 2021 13:05:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m6sm810547pfc.151.2021.07.28.13.05.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 13:05:09 -0700 (PDT)
Message-ID: <6101b875.1c69fb81.bd3f7.33b9@mx.google.com>
Date:   Wed, 28 Jul 2021 13:05:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.199-1-ge25f07ced983
Subject: stable-rc/queue/4.19 baseline: 56 runs,
 3 regressions (v4.19.199-1-ge25f07ced983)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 56 runs, 3 regressions (v4.19.199-1-ge25f07c=
ed983)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.199-1-ge25f07ced983/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.199-1-ge25f07ced983
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e25f07ced98375ad51214ba78cce0687031c3333 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61018ab8c0b77b95545018f3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.199=
-1-ge25f07ced983/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.199=
-1-ge25f07ced983/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61018ab8c0b77b9554501=
8f4
        failing since 256 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61018058f1cce905bc5018d7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.199=
-1-ge25f07ced983/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.199=
-1-ge25f07ced983/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61018058f1cce905bc501=
8d8
        failing since 256 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61018010e2de5b24c55018cf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.199=
-1-ge25f07ced983/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.199=
-1-ge25f07ced983/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61018010e2de5b24c5501=
8d0
        failing since 256 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
