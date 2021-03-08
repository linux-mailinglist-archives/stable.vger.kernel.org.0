Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA9DD331645
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 19:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbhCHSih (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 13:38:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbhCHSic (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Mar 2021 13:38:32 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F7BFC06174A
        for <stable@vger.kernel.org>; Mon,  8 Mar 2021 10:38:32 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id z5so5299852plg.3
        for <stable@vger.kernel.org>; Mon, 08 Mar 2021 10:38:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HND2Klj1qHVZVutXn8ZDtDhopPyvTLWnGGfhaiTk/Gw=;
        b=g3F6Xj73lD+ZMv3WzlhAVFWO9VvNfprzH6ykwr1VDXhT11qzGyoW0geaG/P3ZnQLqb
         BeSoJ8Yiyu7+E2fJtx+U7UWZazttSSg0eeG6HAElBybgKW4ddBtF0mAhjpeEI6lghYp0
         D1BFS4t9xEnUeftHcDDOcjM/MmRY9SU+BO8fFKdE6Zj0NO6IxykGliyOzlcSQQAkJ2Jn
         3Ril9G1ZG5e+ZHuQvPkuF97Apyn+5ghsypryuIh1UCyZQ8bmrnORsiQhaIw9pcPikZmM
         MwaK45vXn04LN2p+Af7sKoaQ60hdr+oaaUO5kHPmgSWg9CVMqiIHWZpXx139uLeEx7BJ
         vAWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HND2Klj1qHVZVutXn8ZDtDhopPyvTLWnGGfhaiTk/Gw=;
        b=WN8a0Onxna++183IVeT7Uf/PaLk8Kyb8TbFCI36g6/PJZqGilFhR0n/5y27iX/wAsh
         oylLwUiXdZoX1E6dKws3hENV39D2vOiK+Ql+9O78mdbLE3wtPxMK+sGTAd95YXbA0lFt
         rWkmNDfhnj6EmlR//YFB2R46HRuLy0jtwnlT2GLQu0LNkHJWJKyvC6UOnEX2ojOc/ovi
         tuJ5w483euXKrdg5nBMov2KY3lcru5IGB0jKX5+Nz/N6jk2XJKIV8tUBCCHEfPwV7w1W
         9kFVrAJCLOBL27lh6B2VljEcxutJsZzeM01OLLgEqpyB0O6Z13p38uY6s0YAHnW8c4Id
         cTWQ==
X-Gm-Message-State: AOAM530i1UY2DBhyYt/OfU4+RBEkwkjIsfglxRGqgl1+7uJff2qJkpUi
        DoPJUeACelz9dP8Km3pPGQLu47s9hi/xhDnh
X-Google-Smtp-Source: ABdhPJw/S0q1GbCFZrMLMP01rkp68IqcQ5u7cAnfEJQ3rbO+wPdEdby2J+vMmeKYZo5M1ncaO6WMkw==
X-Received: by 2002:a17:90a:e556:: with SMTP id ei22mr208504pjb.214.1615228711396;
        Mon, 08 Mar 2021 10:38:31 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i14sm94467pjh.17.2021.03.08.10.38.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 10:38:31 -0800 (PST)
Message-ID: <60466f27.1c69fb81.9aea6.0568@mx.google.com>
Date:   Mon, 08 Mar 2021 10:38:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.224-7-g145d5b40ad9f
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 84 runs,
 3 regressions (v4.14.224-7-g145d5b40ad9f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 84 runs, 3 regressions (v4.14.224-7-g145d5=
b40ad9f)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.224-7-g145d5b40ad9f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.224-7-g145d5b40ad9f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      145d5b40ad9f34cd3736562992f635efeea7d678 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604639398c73da4b70addcec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
24-7-g145d5b40ad9f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
24-7-g145d5b40ad9f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604639398c73da4b70add=
ced
        failing since 114 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6046391b606c69bcc5addcc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
24-7-g145d5b40ad9f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
24-7-g145d5b40ad9f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6046391b606c69bcc5add=
cc7
        failing since 114 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604638e0d384a898e6addcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
24-7-g145d5b40ad9f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
24-7-g145d5b40ad9f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604638e0d384a898e6add=
cb2
        failing since 114 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =20
