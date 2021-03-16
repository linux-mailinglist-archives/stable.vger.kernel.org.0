Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B99EC33CE1E
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 07:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbhCPGvx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 02:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233762AbhCPGvu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Mar 2021 02:51:50 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF980C06174A
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 23:51:49 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id mz6-20020a17090b3786b02900c16cb41d63so912922pjb.2
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 23:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=embHa3OAWTDOrErmMSevmomBcJyuZsAjH4grkwkfTJo=;
        b=Q+NwmCLbrqAEI2uHmOExhZfnIuij9VO3c2x/l0hP2ewjrnV4E507mI6CJrb0y3JSNu
         16YpZoQhuWZY8Pt3XauCHUcyO5gGL0KcOflyQIAQdGJoisihvuKgrr71W96mPPCq02SZ
         5TC6taUO8eIS75ptGNOQc64HrkRGI9eo0tWqmZEZ9GwsPdN3FGzOsxBazaBdkdYNTLCi
         dAWbwvf9sJI0jpitKYSva+T6IIqIooOhsSccva0DGSLHBKS5O5/aWdmxAvUdg0z8BxJ4
         6GEdfmafl0FbAsrWBZB9JnW1UbydBv4Z3SXU66kLSuLFOv3bCnuX8XrPCTpdcGmFvtph
         HH4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=embHa3OAWTDOrErmMSevmomBcJyuZsAjH4grkwkfTJo=;
        b=XEX8DRnvrDbz2FbaE4mbSsFNB1DPpcE1hEZzWplKxOQh/4YCNDRK9Gw5Hidi3QdRlt
         XlYIJklARM0RAWts+v7io4f67b5E5RoyB5r2202mpA5zGpyrgwJMh17/3P4eYozWk9cI
         xtN8IHbG2Abhz9rSangavJWwodTFQzZC2jToxje+8HN8eCzUNzRkMyqlKlSs72Lvtimd
         f/mnN98adrZZAZqPoA60JPli3YcWj4wLLpuSytg8wGMviY/dEwVvNjjYnhiXz/mwsGjk
         kolMTANG3dNzBdoPmE9vCwI00UPmJwQMfQ1lXmJd28Z+/G0ZZYLpu8Oj9mNaKjclaP9u
         9+Hg==
X-Gm-Message-State: AOAM5332KG17s3dXcDVkOGEFEFI4LxMhX9ifhiUTbfwoqn4/1aRH/5av
        oKFrbJ9eAZJimHZor9BOfCmgMDCJpux0Nw==
X-Google-Smtp-Source: ABdhPJyA8oMGlMRPL8OcDKrd1qv/ASDJF652+mmwqxlNmq2gOt3BK55Wi9pnRS8y4M1ScHE3zG5DeA==
X-Received: by 2002:a17:90b:4d0c:: with SMTP id mw12mr3434751pjb.216.1615877509039;
        Mon, 15 Mar 2021 23:51:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i22sm1705963pjz.56.2021.03.15.23.51.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 23:51:48 -0700 (PDT)
Message-ID: <60505584.1c69fb81.87b74.52e4@mx.google.com>
Date:   Mon, 15 Mar 2021 23:51:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.180-121-ga636947af93f0
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 105 runs,
 4 regressions (v4.19.180-121-ga636947af93f0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 105 runs, 4 regressions (v4.19.180-121-ga6=
36947af93f0)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.180-121-ga636947af93f0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.180-121-ga636947af93f0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a636947af93f0a20fdba2c08ae38b7825ebf9c56 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/605022591a657d243faddcc1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
80-121-ga636947af93f0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
80-121-ga636947af93f0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605022591a657d243fadd=
cc2
        failing since 117 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60502255eabd26fc85addcca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
80-121-ga636947af93f0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
80-121-ga636947af93f0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60502255eabd26fc85add=
ccb
        failing since 117 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60502249ceb5b0b84caddcbc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
80-121-ga636947af93f0/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-=
qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
80-121-ga636947af93f0/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-=
qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60502249ceb5b0b84cadd=
cbd
        failing since 117 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/605021fa0aa5dd4c4caddcb5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
80-121-ga636947af93f0/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baselin=
e-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
80-121-ga636947af93f0/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baselin=
e-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605021fa0aa5dd4c4cadd=
cb6
        failing since 117 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
