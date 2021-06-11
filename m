Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08FB23A38FA
	for <lists+stable@lfdr.de>; Fri, 11 Jun 2021 02:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbhFKApH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 20:45:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbhFKApG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Jun 2021 20:45:06 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5913C061574
        for <stable@vger.kernel.org>; Thu, 10 Jun 2021 17:42:57 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id u18so1318404plc.0
        for <stable@vger.kernel.org>; Thu, 10 Jun 2021 17:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=y+kyyNQxS5VA6vnu/XbRvQ3ZWYND6g6Zvq4rBokdEII=;
        b=UnRhZIZZYZ1iOQTbCj3uX+EYmpgvuDDIc/QprJY0LYc8OxeDv/DGq2DdfS8k+W8WvR
         GZOpJY/8VeHhwE7+E2jvcENHgA0OnBCf7ZJwgI3ruIcWy9jnDf/2mUgaRnDuaSd0GPjV
         GftAC7yBxfRhSl/rP3eLFp1CO6ek4RcjOwfES/wAkhyEZ+hsgTjmeZhw/6HSMdSHWdTT
         IJTP5qJJ52f4qxgaU8FmOgV0Oe04F0FOv8F3xjAp5MvWLVRuaZKJw1zZkzTC8+3eGMJT
         I3/qwTnT7Mp9YTdzhh1iumj3fkDHSAYGV2WtYCeo4evm6TDRJTXeQfknXK8Kj8lJ+dTU
         p1FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=y+kyyNQxS5VA6vnu/XbRvQ3ZWYND6g6Zvq4rBokdEII=;
        b=nivDDj+6Bu8Ocicr0r/TzAFcJe8dAENNl3txw0+UshH2x+6KGni/o+eX6d7SvBoHi8
         bqEgGCGxQP+hLee01RGqUHPGEI8htQ04UXZ90sd8IdkZFlsoAlyTzywwiuA54svwbd26
         Cwp7v3X09f5vApv/goWkN+L6B2hBKt4QN8fGRkxLvjt+Uld8vQ9Gn/ui5NLFmO3UcQT4
         qO/OF0HsmmwaC5vtfsxM5gq+m7N98PLrdsBbzd0rdYsmvx5AFrcWFKL/Al7BDrSPSkH0
         YCYRYcCWPTDeSV8l7z0kZeFqhAbj+naaUXAw3yu4ndvdvPxmLw2X+VsAB+xWU0fdIPeM
         k8hA==
X-Gm-Message-State: AOAM530Vid56Y8GijEgVNguirzm7k/QecePy+Gf5Aku47zlC442smrvg
        tyq66YuALVIjjpaI7LGxpUSpSenRNsXzJjQe
X-Google-Smtp-Source: ABdhPJzPC+UibUs+KKEn6dgvEpNDq6uRlZodVPVGEyWOQEJMu0q0j9G18tU/0cxYaZC5TsgHpl4pjQ==
X-Received: by 2002:a17:90a:ad82:: with SMTP id s2mr1574342pjq.69.1623372177080;
        Thu, 10 Jun 2021 17:42:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 18sm3287423pfx.71.2021.06.10.17.42.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 17:42:56 -0700 (PDT)
Message-ID: <60c2b190.1c69fb81.1947d.b706@mx.google.com>
Date:   Thu, 10 Jun 2021 17:42:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.194
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 146 runs, 5 regressions (v4.19.194)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 146 runs, 5 regressions (v4.19.194)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
beaglebone-black     | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.194/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.194
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9a2dc0e6c531d595bcdf2c66d0be131679bd02df =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
beaglebone-black     | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 1          =


  Details:     https://kernelci.org/test/plan/id/60c27f0dd766ce3e6f0c0e08

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
94/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-beaglebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
94/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-beaglebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c27f0dd766ce3e6f0c0=
e09
        new failure (last pass: v4.19.193-58-g3a6c65ec05c0) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60c27c5a95281c2da40c0e05

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
94/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
94/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c27c5a95281c2da40c0=
e06
        failing since 204 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60c28a1d095b7e5ea20c0e08

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
94/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
94/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c28a1d095b7e5ea20c0=
e09
        failing since 204 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60c27c61cd8db8536d0c0df9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
94/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
94/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c27c61cd8db8536d0c0=
dfa
        failing since 204 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60c27c019947791d4e0c0dfe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
94/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
94/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c27c019947791d4e0c0=
dff
        failing since 204 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
