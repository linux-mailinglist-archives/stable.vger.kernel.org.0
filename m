Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED88F33A176
	for <lists+stable@lfdr.de>; Sat, 13 Mar 2021 22:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234451AbhCMViK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Mar 2021 16:38:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234806AbhCMVhr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Mar 2021 16:37:47 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11116C061574
        for <stable@vger.kernel.org>; Sat, 13 Mar 2021 13:37:47 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id 205so1143444pgh.9
        for <stable@vger.kernel.org>; Sat, 13 Mar 2021 13:37:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2b4LwmCgxjYcijAWE3MelvHOSVpA2uWKeJOv/grrOYI=;
        b=sRW433T4CNmBu8u7IeqErsgItuyqd8PCF6s7ouQWuqTPWv0pJ5z35L2VBdN9SZnjn3
         YKggkZbWWdX1p7uoz45fRukNXcduOob+bcMYJYt2KFFm6J3fVKi7fsvg54Mi4qb7VkJv
         M/0oRmk0nBRIEGWClj7hjwO26lpvaE8TCFC6j3x6qV3M6V6/bTxlbP4XIVKxcq4k0tqo
         0xWEBDngDX+OiSomoimkCV+l80fIQJ6TKi28rZV3Kkc7PuuvkAxFFwhziXDhISM2JyNo
         ZKZooppFZWj2o1y8MBs5nsaDUBlbxZUp5xE7pkRx5lONnHOuTMbIkdfG82pt9a7WO2xS
         koTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2b4LwmCgxjYcijAWE3MelvHOSVpA2uWKeJOv/grrOYI=;
        b=SvF+FkDEJR0Iu9WjUYWxr7ezgpHSO45Nr0zOvrvtaDgEeQOma4kKZSRy55a4hKS+L+
         jnzUu8uRjELAUsVkBQEmILyaqpyZVHSoOSFXYbcYVAwns0rQ2DQ2nhLdqUPeDY8IjMcj
         /PHhX5vdE2A6SDLy/B6oAcU6p+S7kqGBI6BxoMU+H8rwF1XSXETjLu+8k2b1smjlgy9I
         0hFEMPLNXT4hslJgv9yRZCBwQBssZPzBu1C/w8B2KJPjFud4KRX0xJIp+lNKP4oEWVsc
         v9wEUJwnTjNjZjGyZBi2J8Z6VE7R5YxFx214g8qMuxm+WENE3by9AqCmXgjUZeHpP0nL
         t5Sg==
X-Gm-Message-State: AOAM531PzkXgc0X9mPuRkHAMju+MuHVLW6+KNuxUt2RLx2DZ7REBsEur
        lT/p2kTavkRHrEgPKF7s+JYMAlUfu5jweA==
X-Google-Smtp-Source: ABdhPJxfsOhPvcNgE2mamhpLNtsG40OFQ/30j6R1ZOlGR/nMfAzwO+YLtc+vztge5weahDZt0N/qng==
X-Received: by 2002:a65:4386:: with SMTP id m6mr17689556pgp.384.1615671466333;
        Sat, 13 Mar 2021 13:37:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u7sm8764004pfh.150.2021.03.13.13.37.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Mar 2021 13:37:46 -0800 (PST)
Message-ID: <604d30aa.1c69fb81.a22a.6a8e@mx.google.com>
Date:   Sat, 13 Mar 2021 13:37:46 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.105-119-g2bcbae06b8fb
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 114 runs,
 5 regressions (v5.4.105-119-g2bcbae06b8fb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 114 runs, 5 regressions (v5.4.105-119-g2bcb=
ae06b8fb)

Regressions Summary
-------------------

platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-collabora   | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =

qemu_x86_64-uefi     | x86_64 | lab-broonie     | gcc-8    | x86_64_defconf=
ig    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.105-119-g2bcbae06b8fb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.105-119-g2bcbae06b8fb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2bcbae06b8fb9030973ee996e1b8ed43f3bfd4ab =



Test Regressions
---------------- =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/604cfb63721a6f9454addcb4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.105=
-119-g2bcbae06b8fb/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.105=
-119-g2bcbae06b8fb/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604cfb63721a6f9454add=
cb5
        failing since 119 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/604cfbaf721a6f9454addcd4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.105=
-119-g2bcbae06b8fb/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.105=
-119-g2bcbae06b8fb/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604cfbaf721a6f9454add=
cd5
        failing since 119 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-collabora   | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/604cfb07f99ef1ab72addcd0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.105=
-119-g2bcbae06b8fb/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.105=
-119-g2bcbae06b8fb/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604cfb07f99ef1ab72add=
cd1
        failing since 119 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/604cfb0ce33fa96b9baddcc5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.105=
-119-g2bcbae06b8fb/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.105=
-119-g2bcbae06b8fb/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604cfb0ce33fa96b9badd=
cc6
        failing since 119 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_x86_64-uefi     | x86_64 | lab-broonie     | gcc-8    | x86_64_defconf=
ig    | 1          =


  Details:     https://kernelci.org/test/plan/id/604cfc197797228264addce0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.105=
-119-g2bcbae06b8fb/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_=
x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.105=
-119-g2bcbae06b8fb/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_=
x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604cfc197797228264add=
ce1
        new failure (last pass: v5.4.105-106-gc1720e578a90) =

 =20
