Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2CC2F03E1
	for <lists+stable@lfdr.de>; Sat,  9 Jan 2021 22:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726006AbhAIVqO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Jan 2021 16:46:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbhAIVqN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Jan 2021 16:46:13 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B034FC061786
        for <stable@vger.kernel.org>; Sat,  9 Jan 2021 13:45:33 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id 11so8561820pfu.4
        for <stable@vger.kernel.org>; Sat, 09 Jan 2021 13:45:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GAdITUp8JMKHP/sjARDC2SxKmeyxGxO7D/61zW5kbe0=;
        b=jGIn9l3bGjcf4YdnBGiQV/cCeQh7k98V5dfVaNdCWA81dJ30WP2FeBlZHE2GkqVVD6
         OBT+PBi6WrbZRbtGuTHTYK7Id9a2IGqfvGKs3INPT0YANolzGy5fnF05L6jsWl2vuy1h
         hvmwu41D/Mvi5XyjkBokRYhkJ4zdMPQ0oOWk62xFdboy8Z7jtJGSZK2r7qG97fhPnpoU
         U6AKJcq8yNYTXPe6E0k0beN2qN8Kqiu/ZNpjdZg0rO6VGeaFAvGBnSn9ozwqbl7JuRtX
         B7wlnbvuQ2zPrJNBGgV3BBw+s+KCDzMx1fAxTwKq0OqJOMwV9FMAU6GmclV8FiX8dZBO
         cOTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GAdITUp8JMKHP/sjARDC2SxKmeyxGxO7D/61zW5kbe0=;
        b=AitOOMB6mLS+scKE0t66jPlET46NGTA/UrMCNdaDSHb4V/LE7f4sM/yuPLSX59Mqlf
         xPl1mRk9CP5bBJGYzx3R8NOqgXMZNe1qB94lU6SfktMQ5cEr0/ImwY+BBhCir2Qgi6oD
         wZCYZiG9QFZI6HvVqetKyZRVokewgXPdV1N8BdABmyoSHIz75MoEr21hLJgUiDExnow2
         7tb/tdvlaODleauu1V6ULJKJj0nUOCgYuzOm4wfaxONZCMTQBUDW1pHFiwdPK78Scqdo
         CtSJpCywyNLdqRdOWWE3/jKg1qK6yruw7bWx1D/lpdwn4Ee9rgHA0ye6AbWBN/lOSyHn
         NxjQ==
X-Gm-Message-State: AOAM531Up3UaE64c3TjWKCgARdLbAxcvFtzlHNyKurzQB7eEvaHTTLUK
        gJ4DWZBLjjDuYwW13bCXFaNUVCTc5uM+Nw==
X-Google-Smtp-Source: ABdhPJwBTIvydM1fSc5+N85xhZ99nznE18EG3pee+p+tKplNw2Ulc7hcTIs2JYpZqmvBjXd6go5itQ==
X-Received: by 2002:a63:b4a:: with SMTP id a10mr12967574pgl.112.1610228732911;
        Sat, 09 Jan 2021 13:45:32 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 6sm13807242pfj.216.2021.01.09.13.45.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jan 2021 13:45:32 -0800 (PST)
Message-ID: <5ffa23fc.1c69fb81.71090.f0ec@mx.google.com>
Date:   Sat, 09 Jan 2021 13:45:32 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.166-9-g84297b8c2cc7a
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 150 runs,
 5 regressions (v4.19.166-9-g84297b8c2cc7a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 150 runs, 5 regressions (v4.19.166-9-g84297b=
8c2cc7a)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre  | gcc-8    | defconfig  =
         | 1          =

qemu_arm-versatilepb       | arm   | lab-baylibre  | gcc-8    | versatile_d=
efconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-broonie   | gcc-8    | versatile_d=
efconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-cip       | gcc-8    | versatile_d=
efconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-collabora | gcc-8    | versatile_d=
efconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.166-9-g84297b8c2cc7a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.166-9-g84297b8c2cc7a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      84297b8c2cc7ae1cf3f52927bc49d0eedc73dc71 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre  | gcc-8    | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff9f0ef82a806fdc8c94d0f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.166=
-9-g84297b8c2cc7a/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s90=
5x-khadas-vim.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.166=
-9-g84297b8c2cc7a/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s90=
5x-khadas-vim.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff9f0ef82a806fdc8c94=
d10
        new failure (last pass: v4.19.166-7-gc896c168805bb) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm-versatilepb       | arm   | lab-baylibre  | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff9ef35c79f1d820fc94cc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.166=
-9-g84297b8c2cc7a/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.166=
-9-g84297b8c2cc7a/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff9ef35c79f1d820fc94=
cc1
        failing since 56 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm-versatilepb       | arm   | lab-broonie   | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff9ef43c178c16a0dc94cda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.166=
-9-g84297b8c2cc7a/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.166=
-9-g84297b8c2cc7a/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff9ef43c178c16a0dc94=
cdb
        failing since 56 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm-versatilepb       | arm   | lab-cip       | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff9ef26bac9368034c94ced

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.166=
-9-g84297b8c2cc7a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.166=
-9-g84297b8c2cc7a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff9ef26bac9368034c94=
cee
        failing since 56 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm-versatilepb       | arm   | lab-collabora | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff9ef04ae35fa1c74c94cde

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.166=
-9-g84297b8c2cc7a/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.166=
-9-g84297b8c2cc7a/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff9ef04ae35fa1c74c94=
cdf
        failing since 56 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =20
