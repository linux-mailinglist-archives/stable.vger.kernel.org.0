Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3224E309F66
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 00:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbhAaXOi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Jan 2021 18:14:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbhAaXOf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 Jan 2021 18:14:35 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AABFC061573
        for <stable@vger.kernel.org>; Sun, 31 Jan 2021 15:13:55 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id z9so1285237pjl.5
        for <stable@vger.kernel.org>; Sun, 31 Jan 2021 15:13:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7hhXtOZ1pAr5a+0HLmv5/6aIXWhQh9nk7th9vyykaPo=;
        b=yaRISC7aqJsy1IOuRXnkcN4xUS40dvUNlzCkD7EcMg6Lx43lZWJD7uT/yWfDEJqejx
         Dip1laq6fzL2g72IGXJlkG5hf8zwbrPdAzN3kkajmN+ZdLM/L6Lj3dHUIXegnV2S/6K3
         cZ+dfZBibCDHIAEyNMFCMh6caT7pm0D/BldD6u7xHsiesmT4DACGcFDvlG9rffnHqrnN
         rHy7/89Ss0yqVLww5pTIo2aIKQsCMTWJOuOHvg5LUJnOEF6qooMr3AOaJ2cn0apwpDAo
         pD5vC3zi7qxy2dIFH3a5jwZH55GAKTvJaRMzhLniixhDV6Mi8OCgHzCLhbHYXDvHpdrc
         LQNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7hhXtOZ1pAr5a+0HLmv5/6aIXWhQh9nk7th9vyykaPo=;
        b=MozEvB2rLTH2RyPDE04UygUMsIPALdXFLG70tI5PMQxmQmfyYiXccT8PDyPm3YY5al
         vEHGuXUWP3W/RYvGnKbtNAaC9iv0ansT0FKCX6e+0FmPdHpq0X26VJVRRR4bQOAxLsF5
         0mbA7a0hiRQI7Uen6NO08aEGlwH6zmUJ7X87nzjlXB/KB9IWwaIs8jAxY++8srFXkPhV
         bFRutlca2vjJWtBMKsBm2fyGnyWKdUmxG5dsXQmI80cSiFBE4tYkb9LLoUXjypDj39C0
         3Myhl9FOAf0lSjnFZrgxeAk8XsOS40PaEzZSula0mDvFz/qWM1+lQxFsp18ZSVFesabv
         6lMA==
X-Gm-Message-State: AOAM531Qtmek+X8or3enj3zbtlWrNhV/pvoit+p+1AKPzCNAvkY2hDev
        xQEpRIw2L2fwWWtM6qjCJAy+oiRh6CQz2Q==
X-Google-Smtp-Source: ABdhPJxz8HHPXgEo4178OtkT6ff1G4YIki1s6yL+qCDh/Cq6WXvz5ah7rNEJKQvCK/mOiwTh4jnVKg==
X-Received: by 2002:a17:90a:4598:: with SMTP id v24mr14016302pjg.135.1612134834404;
        Sun, 31 Jan 2021 15:13:54 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q12sm15505504pgj.24.2021.01.31.15.13.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Jan 2021 15:13:53 -0800 (PST)
Message-ID: <601739b1.1c69fb81.bee27.5ecb@mx.google.com>
Date:   Sun, 31 Jan 2021 15:13:53 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.172-11-ga6e2645963a6
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 161 runs,
 4 regressions (v4.19.172-11-ga6e2645963a6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 161 runs, 4 regressions (v4.19.172-11-ga6e=
2645963a6)

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
nel/v4.19.172-11-ga6e2645963a6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.172-11-ga6e2645963a6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a6e2645963a64df62b7144274ec512547c50dd7f =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60170111a1d19942f6d3dfee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
72-11-ga6e2645963a6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
72-11-ga6e2645963a6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60170111a1d19942f6d3d=
fef
        failing since 74 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601701255120ec5a8fd3dfc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
72-11-ga6e2645963a6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
72-11-ga6e2645963a6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601701255120ec5a8fd3d=
fca
        failing since 74 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6017010aa1d19942f6d3dfd9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
72-11-ga6e2645963a6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
72-11-ga6e2645963a6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6017010aa1d19942f6d3d=
fda
        failing since 74 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601700c985773ddd7fd3dff6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
72-11-ga6e2645963a6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
72-11-ga6e2645963a6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601700c985773ddd7fd3d=
ff7
        failing since 74 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =20
