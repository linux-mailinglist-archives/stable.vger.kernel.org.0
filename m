Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F18F34D21C
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 16:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbhC2OH7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 10:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbhC2OHr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 10:07:47 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E23FC061574
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 07:07:47 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id ha17so6054845pjb.2
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 07:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tEdjSyP46JtjuCEwPx6tdEe+ItOuMLj0UVMuSNoUEAE=;
        b=wEGI26zMXCmTXJzkZgbtUYNLzB7beKKnC/3gd+sVTs5TGjojNN6PaJvmvQXIABHh0W
         MXevbaKA3CquD8AH3Nq1GqlsEQpPb0LjIlL9lu1Kj1W5iROHF42Hzj5it3bwabRL1il/
         lwM+gF34Qke0HplezidIleQcJGxYSg1kmqkrXVXb1y8rokatjs4NCL1L7tpfwvaLbci+
         RmTn+sFbbHH+GjSyTUBFiKdGNd6XtyN3EYERhQmCqRTTbvgzhzTWPtKk2Lrq1/REsKiP
         WaR6QgQBa+MW1JCRRnXM5F/kN48OHQjzyfXOtDNJZFyrvOcYwlxC+jtpAGtYe/pfN6yJ
         QQ6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tEdjSyP46JtjuCEwPx6tdEe+ItOuMLj0UVMuSNoUEAE=;
        b=PWmBoGdNGmzCnroHsnpj1F9t2X2pbALdXqSpFmM2EjLD+yy8k6WN/FUdpBr9jpAmWe
         ZTX4DmBwj0m/5OC2cSD5IR6BiP1bYq1Jc8Cw2poKkJ8MzSsA1ecoNRPTM5N7Ivsk/jiL
         56lltJ2PsnEYWL1TqAUqzmyWIjdSvavywtDDkYSBHmEmUZilQdsJPcb7RAS75oecdvrv
         KPBBwi5Le6p1HVf3s2RyW3XxIVcd+V8U4Fx22ffpFX+Gm/BTgpVTvnpa6VXQ/1xFhKGm
         d4Syvwd6IOoRweH/ia27Vu4bzxg/pPZ2SPkvvnmg9BLzqICz16hKN3ft8OsvO8sepZrY
         21uw==
X-Gm-Message-State: AOAM530iIce9ktO2JVFbINmmiyk5YTOccBAQ/+Df6A0e4MUQbkRzU+F3
        hXIks8q/XzrL8AgiOeRT9Q5wBG0BYaPzcQ==
X-Google-Smtp-Source: ABdhPJy3jTlVr92wslt1W0NUHPtNuFVDPi2vaJrIb91hpERbAkJIcNjMohd/c34xwNzqX6g771zWmg==
X-Received: by 2002:a17:902:ce86:b029:e6:b1f6:3c5c with SMTP id f6-20020a170902ce86b02900e6b1f63c5cmr29235533plg.13.1617026866494;
        Mon, 29 Mar 2021 07:07:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l3sm15079784pju.44.2021.03.29.07.07.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 07:07:46 -0700 (PDT)
Message-ID: <6061df32.1c69fb81.33bc9.5422@mx.google.com>
Date:   Mon, 29 Mar 2021 07:07:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.183-72-g64855add8d40
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 139 runs,
 4 regressions (v4.19.183-72-g64855add8d40)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 139 runs, 4 regressions (v4.19.183-72-g64855=
add8d40)

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
nel/v4.19.183-72-g64855add8d40/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.183-72-g64855add8d40
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      64855add8d40924ec22a5f25f46f4d304a40b0df =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6061a2d32f75afa68aaf02bc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.183=
-72-g64855add8d40/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.183=
-72-g64855add8d40/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6061a2d32f75afa68aaf0=
2bd
        failing since 135 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6061a2e12f75afa68aaf02e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.183=
-72-g64855add8d40/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.183=
-72-g64855add8d40/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6061a2e12f75afa68aaf0=
2e1
        failing since 135 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6061a2d62f75afa68aaf02c5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.183=
-72-g64855add8d40/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.183=
-72-g64855add8d40/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6061a2d62f75afa68aaf0=
2c6
        failing since 135 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6061ccb6b8c7650480af02ae

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.183=
-72-g64855add8d40/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.183=
-72-g64855add8d40/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6061ccb6b8c7650480af0=
2af
        failing since 135 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
