Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5144839373C
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 22:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235739AbhE0Uho (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 16:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235263AbhE0Uho (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 May 2021 16:37:44 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAC3DC061574
        for <stable@vger.kernel.org>; Thu, 27 May 2021 13:36:09 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id q67so1500944pfb.4
        for <stable@vger.kernel.org>; Thu, 27 May 2021 13:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=w4Tv68i4FYUy/ySP33mieYuwFVea7+KrVIZHP+mpr4M=;
        b=1HK6SM2oYSm01CilD6XuIaZKJeXEBsQVFQY9v/8I51fveSqShTf7CmScCCwhtSHbgL
         URnMltVqiFCNrhzorEDZ6klNQHV+KgAG+pR8ZS+9dIahLK3dlKPJI8usJPxDmN/mo+VI
         3PAS3ZHcVyXC8s5hHlpoi7X1J+Nhp1XRjAr9aKopTyuKm2IDzis3zbWIDqIxm4PTrA9/
         jC7LDOp/XxOucBVJ0HZiu4v9c9DyysEdon39iCFcNZUeZiRvmZlQNwjLVBr9XZQGUFKw
         w3TiTm3L71Dkmf29Ot+cjoR3dG1mMfAVSKNvdtN9BikMTGEFwt+K7nRM/tJu6WxvSoKM
         k2VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=w4Tv68i4FYUy/ySP33mieYuwFVea7+KrVIZHP+mpr4M=;
        b=iey9PDwPv8gcN7B1JVMZfD4w8zhcMQJ/LvpLHFy3r6DaL84zaDX2kHHk42bEOvHgoU
         Qszb3huMB2LVd3R9l+UwDxEOtZImqhmuoYyU2Kjznw+10/CPx0uFXO1KNeQ7eyE+tXm4
         Bkqh5xe1fCU6owQoG5CKFngA2vflwuxyd8qcFE1sWtXrGsaDNRXMP3G1acKKM+I93TQL
         rxKaCqyOKScX18hiRXGc72PttCHEil+Z0FpgCPCH5TBEN/C3wLTSDK8SvuKpQXvS9aef
         IbPuAaG2RWFkZK09zherNUu0FmNWwS6PM8G5gf7AQfNwuvSUFxs4Ce0BAs7IU47N5UaP
         i9Ow==
X-Gm-Message-State: AOAM531SkQoWa5/Tm1k4KsnyLE2HozadQTbyI3H+6dRrHyPSymqhq3ur
        1pJ1vGlzmkDNZjRO1l7jEdMzhIV0OBbhQg==
X-Google-Smtp-Source: ABdhPJwejYWzvNP8GLA46iX+a5iHwTKg0cHx12afo8GoPnSJLNCKyqvgUWuhs6Iy3btD6dfbUZWpFQ==
X-Received: by 2002:a63:982:: with SMTP id 124mr5469302pgj.37.1622147769160;
        Thu, 27 May 2021 13:36:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b7sm2347836pfv.149.2021.05.27.13.36.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 13:36:08 -0700 (PDT)
Message-ID: <60b002b8.1c69fb81.ec573.8887@mx.google.com>
Date:   Thu, 27 May 2021 13:36:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.192-4-gf96d7c02c0d0
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.19.y baseline: 105 runs,
 3 regressions (v4.19.192-4-gf96d7c02c0d0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 105 runs, 3 regressions (v4.19.192-4-gf96d=
7c02c0d0)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.192-4-gf96d7c02c0d0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.192-4-gf96d7c02c0d0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f96d7c02c0d0a6180888c0241399373121777708 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60afc98858c8233338b3afa4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
92-4-gf96d7c02c0d0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
92-4-gf96d7c02c0d0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60afc98858c8233338b3a=
fa5
        failing since 190 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60afc57e75178752bfb3afc1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
92-4-gf96d7c02c0d0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
92-4-gf96d7c02c0d0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60afc57e75178752bfb3a=
fc2
        failing since 190 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60afc55375178752bfb3afa5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
92-4-gf96d7c02c0d0/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
92-4-gf96d7c02c0d0/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60afc55375178752bfb3a=
fa6
        failing since 190 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
