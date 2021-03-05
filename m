Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA9E32F48C
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 21:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbhCEUUx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 15:20:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbhCEUUT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 15:20:19 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 145F2C06175F
        for <stable@vger.kernel.org>; Fri,  5 Mar 2021 12:20:19 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id p5so1986138plo.4
        for <stable@vger.kernel.org>; Fri, 05 Mar 2021 12:20:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=e2cR15+CWzBXLe7+tCoebFqLslPC7glzhtQRHOObJoM=;
        b=E/5csp8mm7z/tkwM+z4RL+6d9QImFEwVnl2DJZZ92RazNvfMVZB0p9ZC5bhNsLr5q6
         yYYxw8mj3Yc8PbmXX+v2/HYpOABuBZz83mXgRISlzt59Mx+aAeG5awRpeAi3SplmG1QN
         fF+EETbzSKW5gjAQNvSVMq1bs4CVzDxypfnQ4OqpBjlq+Ee0TL7ilAaD422UCJ+T5OaG
         3iMw2gi02rQ4kXOtBHRzq+E4pOMRoGmkkJ6jjLTTLgM5cpFzkHFjlm+Sdzc4SNcGrcD8
         kKhvwidoJSbAttcMwIYMPAwCjeypQzb60RRtekRZDXM8knc7yyeULDnvrAorKjnwfxt3
         Qv0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=e2cR15+CWzBXLe7+tCoebFqLslPC7glzhtQRHOObJoM=;
        b=tfY8QfElSm5//KkTO39JLAFWysIa9V6bHJkZB8KVpfz4/Giw85ys70wa4NzDzJh9BM
         i5lIB8jsr6bgiUD6H+7l0fLICHLXdMqXxHXGhmUC5L1u5sE/aq1JybnDT9goIb0My5+C
         TYh0YtWrjYSbDEUQ3UizysotyVwT5xpAIBGhifYXNBchPAsLEoDEot7Nbx9UBSfRbZ2U
         3yOFgUPIgp7dsEV5QAjPSCP0ACuHDRnWOm0YL5yFt4vwcNXPiiS34XWVr0KBz9WZgpiv
         vkQ9E8JXtj8UG+WpHyxGkUzbk4N4fMPGpe29RhGzTpwjZmmpcxLDWy6hseNInAdme9Wd
         KE3A==
X-Gm-Message-State: AOAM531yM+6FHvSW0KRiaF7HGAOBsKdxwyLiP91W9zcLsDaCCAx1aclS
        xaw5K38jujT1zl58fHxzJybbRagQqEHPWQXC
X-Google-Smtp-Source: ABdhPJzV/dcMWbzOLcPZFdmYoVUyHdpAXvVUbTy6wsanRvNZ7Jp8Z0UVrflil91QqC3EgO+wCHxJjA==
X-Received: by 2002:a17:90a:c7d5:: with SMTP id gf21mr11678692pjb.165.1614975618387;
        Fri, 05 Mar 2021 12:20:18 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g141sm3377483pfb.67.2021.03.05.12.20.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 12:20:18 -0800 (PST)
Message-ID: <60429282.1c69fb81.1246a.9271@mx.google.com>
Date:   Fri, 05 Mar 2021 12:20:18 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.102-72-g2219284ec8a8b
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 162 runs,
 5 regressions (v5.4.102-72-g2219284ec8a8b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 162 runs, 5 regressions (v5.4.102-72-g2219284=
ec8a8b)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.102-72-g2219284ec8a8b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.102-72-g2219284ec8a8b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2219284ec8a8b7c145ca11b8500da4092a925906 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60425ef45c91265eaeaddcf8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-7=
2-g2219284ec8a8b/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-7=
2-g2219284ec8a8b/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60425ef45c91265eaeadd=
cf9
        failing since 105 days (last pass: v5.4.78-5-g843222460ebea, first =
fail: v5.4.78-13-g81acf0f7c6ec) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60425da6c297ce74a4addcb3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-7=
2-g2219284ec8a8b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-7=
2-g2219284ec8a8b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60425da6c297ce74a4add=
cb4
        failing since 111 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/604277e2df0cd368e2addcdc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-7=
2-g2219284ec8a8b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-7=
2-g2219284ec8a8b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604277e2df0cd368e2add=
cdd
        failing since 111 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6042753358712405f6addcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-7=
2-g2219284ec8a8b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-7=
2-g2219284ec8a8b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6042753358712405f6add=
cb2
        failing since 111 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60425d3422e483be1faddcc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-7=
2-g2219284ec8a8b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-7=
2-g2219284ec8a8b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60425d3422e483be1fadd=
cc9
        failing since 111 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =20
