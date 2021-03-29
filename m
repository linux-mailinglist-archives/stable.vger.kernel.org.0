Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2CC34D5C3
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 19:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231442AbhC2RJI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 13:09:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbhC2RIw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 13:08:52 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C8EC061574
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 10:08:52 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id kk2-20020a17090b4a02b02900c777aa746fso6227152pjb.3
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 10:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6h+28hG+T4IwQELm9Gquad/HSzKNQVdJR55fI/VBNLg=;
        b=km26G1etSlvT2devp32MHX4dJ5jdn7J0GOic6rR7zAeDsmioAiO/V82uCzHxAP3KQ6
         3N8Dt0nHEwXjhGS9z1//PI78JK/11koBJKV3Jfb10pXVNILG6fqx0vA6vKXX4WbQcg2D
         Da2QOpm/89VWypiJKs9nx1j5z4UgPrx6DulGbKKvWeBwyry4Q9yN/qZp6815Jau5U+bm
         q++6OaMeAuuP5G5Y01vYBdC8Kd4HpMoEE1opJZf4aHUD3HGJArjiSRB6lt2WHHzYaQY8
         tB/FL4I4VMIlERDGYXjrRZOcQfGieahAumDGg/L28J5z6I588MJN3K0J9RB2xs6fPJh1
         2IMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6h+28hG+T4IwQELm9Gquad/HSzKNQVdJR55fI/VBNLg=;
        b=a5c+rq4Q+stRqiogAnPCzcjvhiDFLRsKqdeo+Ug7W4mF7/iPSGHTibPBldc9GIx6lo
         US7jEX3e0Cd7ujCM1hhmqX0pTJrkZ3hr2/xAIGupI0JAEMaYFOLT4OFPyjZX7ChYpZt+
         TxhnQ39gcEVzXpz015YXBAdcP+nzWzmhEds1fQw7d8SItOKK5lhYXu7FMMcGqgrYHeOU
         QKxzXPQrE5NrhEyMdV8FVqddqbwi+VgrPj3f5pR0mAo0Cuk5a+fsjBDwCrqzQXqQW4ih
         iCIBMHENYk67DFTzcW4sKz1AhSlz5q8HEmwMNWoJaZpwqddje++/A+jNU1V4HX/rO1Z/
         R5SA==
X-Gm-Message-State: AOAM530N26/oyn6kA3vuJiEqrXrTZbAjeUYIuTJTRKip3mf9yhvqWHMQ
        JxQWQK8CAZMv/wJtTGyyoQXtYD4s09c81dDN
X-Google-Smtp-Source: ABdhPJyf89m6y9/jvPjlg6+Q3SOb8S2pJIcryw/wfGplBKei2l3NM2zkh6a+FA1Nviyyu+y9r54ypQ==
X-Received: by 2002:a17:90a:29e4:: with SMTP id h91mr77547pjd.225.1617037731964;
        Mon, 29 Mar 2021 10:08:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 35sm16337506pgr.14.2021.03.29.10.08.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 10:08:51 -0700 (PDT)
Message-ID: <606209a3.1c69fb81.ae544.8500@mx.google.com>
Date:   Mon, 29 Mar 2021 10:08:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.183-72-g32ff5b6b3d79
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 143 runs,
 4 regressions (v4.19.183-72-g32ff5b6b3d79)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 143 runs, 4 regressions (v4.19.183-72-g32ff5=
b6b3d79)

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
nel/v4.19.183-72-g32ff5b6b3d79/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.183-72-g32ff5b6b3d79
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      32ff5b6b3d79a4979dfbe081866c4e9e447063fe =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6061ceede1292de6bbaf02c7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.183=
-72-g32ff5b6b3d79/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.183=
-72-g32ff5b6b3d79/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6061ceede1292de6bbaf0=
2c8
        failing since 135 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6061cee7e1292de6bbaf02c2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.183=
-72-g32ff5b6b3d79/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.183=
-72-g32ff5b6b3d79/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6061cee7e1292de6bbaf0=
2c3
        failing since 135 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6061cee7cf86146915af02c9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.183=
-72-g32ff5b6b3d79/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.183=
-72-g32ff5b6b3d79/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6061cee7cf86146915af0=
2ca
        failing since 135 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6061e1a8f48772fbd7af02da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.183=
-72-g32ff5b6b3d79/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.183=
-72-g32ff5b6b3d79/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6061e1a8f48772fbd7af0=
2db
        failing since 135 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
