Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 841802F19E6
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 16:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727917AbhAKPmk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 10:42:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727826AbhAKPmk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 10:42:40 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 717EEC061786
        for <stable@vger.kernel.org>; Mon, 11 Jan 2021 07:41:59 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id j1so27709pld.3
        for <stable@vger.kernel.org>; Mon, 11 Jan 2021 07:41:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=r5JIQTdOcnBQ7VBwr4hChzVkNze+BL5CxevIf4d8P00=;
        b=yX/DJXOVOzhwDajp+sw2+hMcOQ1fMfsx5oxGEHmbbT0X0uxqp6oA56/tmTMDUySAzO
         XpVc9AneztRiFnAP4pEk5mDJ54N1zbCZw35ntHUuxdR7ZfrQWmBCm7iN5+s9BaE7VPpt
         oxHfkL6HIBCjLxnF9vrExwg8yAFVC1GzA8mtnNlh/257A5/DOGFNGyocujOlVOYaxFju
         /GRinrEfaHZE/+/d3Qeto5yDpSfQJt/qaoOjXcHjtc+qOXKX31CqptJFQMJD9y+GBbHU
         36cjFWYf81GxkFHx7bY6LzG3hNRPZp5unvWFE6ymYVQ3Fa4WxcUtoQrD7lUYIvMuedrc
         7NwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=r5JIQTdOcnBQ7VBwr4hChzVkNze+BL5CxevIf4d8P00=;
        b=O8gXkI88WBCuXE9PX3+E5S/NcMI0gtoTFyuwhWTfF1lg8qzfWwSsthEmsSkSdpOZ7h
         py92o2yuxo1am5lLOD31r/yi1Byz5JBze1h8cGx6HBX0dbDZeN4/QWE9LtARLb5auhZE
         9oMo/ChZZ0Z/N5Z+jqfijf3zadcOe/RvKvXTE5sblq9wfKycwGPqruG5VV982VszMeU7
         Rhd3ki4w17sSsin6ZbZL9+SvItUGHFPrdVBCaQKn0weZtES60o7kvpd89nFF9A/7cXid
         7s4ED0O520Oo66xtLPjzePiRgqOm9O2DEdt86EiHJNPb09u6JissKm6yst3i1gq5v6SM
         ANcg==
X-Gm-Message-State: AOAM531T9+RAN3l3MOeteibSg5tmAywPock/QWG9svN1527cmgEDUn8B
        EbBiHUwrMjVDPcyiuxqO1g16Fd7lvdxyhA==
X-Google-Smtp-Source: ABdhPJz/CBdFK6UqKJWrfTvI1AR31/ma+tgcokZ6PV4Qq1jgvHlCb9wLW7eT3USZcL7v/L4OAEtv1w==
X-Received: by 2002:a17:90a:7502:: with SMTP id q2mr130024pjk.90.1610379718724;
        Mon, 11 Jan 2021 07:41:58 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n15sm129781pgl.31.2021.01.11.07.41.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 07:41:58 -0800 (PST)
Message-ID: <5ffc71c6.1c69fb81.e1b95.048a@mx.google.com>
Date:   Mon, 11 Jan 2021 07:41:58 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.166-73-ge19534864149
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.19.y baseline: 155 runs,
 4 regressions (v4.19.166-73-ge19534864149)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 155 runs, 4 regressions (v4.19.166-73-ge19=
534864149)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.166-73-ge19534864149/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.166-73-ge19534864149
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e195348641498586e29a3d0852b8de872ff4031b =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffc3df634c36c2d12c94cce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
66-73-ge19534864149/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
66-73-ge19534864149/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffc3df634c36c2d12c94=
ccf
        failing since 54 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffc3e3ccac9c58eebc94ce7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
66-73-ge19534864149/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
66-73-ge19534864149/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffc3e3ccac9c58eebc94=
ce8
        failing since 54 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffc3e0b775c935bfbc94cd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
66-73-ge19534864149/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
66-73-ge19534864149/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffc3e0b775c935bfbc94=
cd2
        failing since 54 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffc3dcc2fda575755c94ced

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
66-73-ge19534864149/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
66-73-ge19534864149/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffc3dcc2fda575755c94=
cee
        failing since 54 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =20
