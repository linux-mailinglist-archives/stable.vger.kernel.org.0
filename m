Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27FCA32DA05
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 20:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236342AbhCDTHB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 14:07:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232604AbhCDTG6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 14:06:58 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C1CC061761
        for <stable@vger.kernel.org>; Thu,  4 Mar 2021 11:06:18 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id i4-20020a17090a7184b02900bfb60fbc6bso4932949pjk.0
        for <stable@vger.kernel.org>; Thu, 04 Mar 2021 11:06:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VmezyiRl4ej772YHwht2C1nQ8oEk095dZgIz44iW2fU=;
        b=pYPiQm74/FBlMira2wrmXJWNhRD4kRiREIM7KbB6d0ovkWr1iHBB2U/lxe9do1ozQZ
         SoaWdBOQopowDwt/5Jj4QS6xDoqUYLXrTjVswb7i57c+B6/Q9QpZaujl3ynf8/VZUtq1
         dy8U9hf7FOITT8xAu/X/5+OCu9Qip+Q4g2xDQd2IKHLeXdcuEDneseT2881dTuX9Haz3
         kEey9fwulTmbDsAbJLcZRbbWm8lIEwZdLmGBdfm83bb81rKPmipns8vx4jjmltblr91i
         Qy6G1jMexQkdYJgiMXPuRpSbfjwHJFL1GarcLXrkRJ3ZhiON6PmxJ82wAbdaqNc8QTFg
         YX0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VmezyiRl4ej772YHwht2C1nQ8oEk095dZgIz44iW2fU=;
        b=nKotym8/X2OWGCqPu1y1IwiaTmPM2ekEnP3Dyvjq5qeXojKjrQKN1iFqbDig1NNlJG
         TX8/PYRz69hH4sNBQdsHcIVbwBKajQ1qHAwgCVi+/M1Tmt/2bKjAOApRmxpXhRVz3DEq
         upmjGkM4QjN8xp4f3KBImHM9zxXDiHmXYtBcp8/NIbux/YsMDsZCSYO5iRIeCd9aP4yN
         96CLLZwkGIRFjLTIEIlSgdUoAkwj/GkkQ0ccADzH9VmF9d78ljqmkh9y0KDccgKF5SQ0
         PFXfK70XQ4MPDqHua8aY4wnKQDYi07n/arVQGMhETbmPRy7A6IlXnRErJQXqOfmul2Ir
         7AJg==
X-Gm-Message-State: AOAM530Ka1QxF2Ovs2bhPNxs/aJz4U7VvckDYrR44L7TX7zb3dnpf6Mp
        yHT/pKBea1zThSbr0dY8KNhQ5XxESt4Hl1xH
X-Google-Smtp-Source: ABdhPJyzEU9ZwAQymAzh/HNJPBEuCbqrcxPBdeA3gwLLtN/NMa8NIWlC2yn6PSFk9h8h0koCWZcNJw==
X-Received: by 2002:a17:902:a5c6:b029:e5:df57:e156 with SMTP id t6-20020a170902a5c6b02900e5df57e156mr2874479plq.71.1614884777916;
        Thu, 04 Mar 2021 11:06:17 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b15sm156292pgg.85.2021.03.04.11.06.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 11:06:17 -0800 (PST)
Message-ID: <60412fa9.1c69fb81.dd1b.0931@mx.google.com>
Date:   Thu, 04 Mar 2021 11:06:17 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.178-16-gdaaebef7f79c0
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 160 runs,
 5 regressions (v4.19.178-16-gdaaebef7f79c0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 160 runs, 5 regressions (v4.19.178-16-gdaaeb=
ef7f79c0)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.178-16-gdaaebef7f79c0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.178-16-gdaaebef7f79c0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      daaebef7f79c08e4489fccb6294b59323168d17b =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6040fb0417fb68a43caddcec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-16-gdaaebef7f79c0/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-16-gdaaebef7f79c0/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6040fb0417fb68a43cadd=
ced
        failing since 110 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604122e3aae3df2ee6addcd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-16-gdaaebef7f79c0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-16-gdaaebef7f79c0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604122e3aae3df2ee6add=
cd3
        failing since 110 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6040fb80eb4615db01addccd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-16-gdaaebef7f79c0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-16-gdaaebef7f79c0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6040fb80eb4615db01add=
cce
        failing since 110 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6040faf0980cbe3a1baddcc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-16-gdaaebef7f79c0/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-16-gdaaebef7f79c0/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6040faf0980cbe3a1badd=
cc3
        failing since 110 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604127bed16a363536addcdc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-16-gdaaebef7f79c0/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-16-gdaaebef7f79c0/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604127bed16a363536add=
cdd
        failing since 110 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
