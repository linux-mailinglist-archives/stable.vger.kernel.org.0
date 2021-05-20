Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8EBC38B235
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 16:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbhETOv1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 10:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbhETOvX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 May 2021 10:51:23 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D189C061574
        for <stable@vger.kernel.org>; Thu, 20 May 2021 07:50:01 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id t9so745423ply.6
        for <stable@vger.kernel.org>; Thu, 20 May 2021 07:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=T4HVVSL1Z/tES7vO6OUSVRINEhbON352W/Tm01aXWQs=;
        b=ppWRDF/vvl548TbH0qwuomn7A9emIqdc6rwtuqJUkfdMhpUztjqJWsXNWkdwkxeCbm
         tdklbWOt30brWNQsKP9Ou00HFV8UEAzY5SmJF0tRE4CkO6VDy70AIQqPn8g//4IWT0fM
         vEPs+04+1RrX6hqDQ31XMGyY4mc3t5iSWx0f/3lip0e18m1bh5DbGpvREsB3I9/mJLdw
         FTGwDLjvWTpDPDfhfCS78AYPLHuQcWKVWV0JEaboFm3Uozcx7SvGk2NCaRC85TocYBPy
         5codZv3FOH1VFo9ItN7yoilMaGldstILYzXo0r40NxPj2KzXdf1a2Jin+SVdbjwNGl/T
         vGDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=T4HVVSL1Z/tES7vO6OUSVRINEhbON352W/Tm01aXWQs=;
        b=KeZqHVi6c6VLFWXOkRyb/UBNPfzVW4sUL+CCN2fBbkUV0Pjq0PyjCcgOep2Z1UNbvY
         kqYh/GvEgUDZtGbUO/QZcTX2La2eTIoeDj5hIB5uZpwWja97JcGa3XV4UPN3k82fO4sm
         Iasvn8834LQrfYG2iV4gSAv/EAeXpcbeyT1tNvTqyZQEpSZiIUt5McFLDcnbDEdZLGyN
         sBFw1V0dmfkF8HjwBAvNze98NFaJzEDB/CNPhrm5L6R12lK6PKnQg+i1jkOp9uzuDgxM
         1xg+OdxeZ3TjaMQKuxKp7YSYFBJxxR6vbrMDMd7lbk4yKJhHHhe5mzr3VwBol9dgmVNK
         dMHg==
X-Gm-Message-State: AOAM531Q0Q+Zqq8mCPYPb/SW6FpTz9B8EkUO5fW9NnlK2/b2GRzR+SKP
        GJR6wDEBGhG6pv3OGCM6yBD9/T/9yhgz89vT
X-Google-Smtp-Source: ABdhPJxY4tpIOlTTv5EGcZgAM+9x0IGJRnjqm2AxHz4hcsdHQUWYapJ/7+Lm7tEFL3mw8gMdvrRtGg==
X-Received: by 2002:a17:90a:549:: with SMTP id h9mr5749627pjf.158.1621522200333;
        Thu, 20 May 2021 07:50:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l1sm2216928pjt.40.2021.05.20.07.49.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 07:49:59 -0700 (PDT)
Message-ID: <60a67717.1c69fb81.b203d.7a16@mx.google.com>
Date:   Thu, 20 May 2021 07:49:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.190-426-g06c717b4df3a
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.19.y baseline: 139 runs,
 4 regressions (v4.19.190-426-g06c717b4df3a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 139 runs, 4 regressions (v4.19.190-426-g06=
c717b4df3a)

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
nel/v4.19.190-426-g06c717b4df3a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.190-426-g06c717b4df3a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      06c717b4df3acb666920610a100d04ebdc485e6c =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a642bde39a027b24b3afa4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
90-426-g06c717b4df3a/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
90-426-g06c717b4df3a/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a642bde39a027b24b3a=
fa5
        failing since 183 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a642c65852209b8fb3afa8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
90-426-g06c717b4df3a/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
90-426-g06c717b4df3a/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a642c65852209b8fb3a=
fa9
        failing since 183 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a642b04a6e993148b3afa5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
90-426-g06c717b4df3a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
90-426-g06c717b4df3a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a642b04a6e993148b3a=
fa6
        failing since 183 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a6425b3fe269d666b3af9e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
90-426-g06c717b4df3a/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
90-426-g06c717b4df3a/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a6425b3fe269d666b3a=
f9f
        failing since 183 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
