Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E265936285A
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 21:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235907AbhDPTJh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 15:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235715AbhDPTJg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Apr 2021 15:09:36 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81AA8C061574
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 12:09:10 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id f2-20020a17090a4a82b02900c67bf8dc69so16929551pjh.1
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 12:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=14Z/GaYZBZ6HoBuA5dIAIsnw7um9EX/tC6i5kWshVnw=;
        b=IvelMxcprzVy9+Rl+bvRLvBukhOG9nVu2vC2c7C3H7VNSVPNW6JULzUjPK5Iav4sxM
         xXxIG/iozietvlNLExjEgWb8N6L+LOWVVey0p31hQ+mlFiG2Aw6y7hbCTOkBHCooSB27
         6Ixd1lDgkrTCTAHU71R7pYmaFJvNwpWg8nISXTlFv+G/kGPbDN4qoULFsh/JzthZoeAu
         nbBOaduQyHOL98H6M+52yfvY/GzevCIrnmQsRnyEi0fGzN7VgiEfTBrwMtrM/ExaSHgB
         VS8xuWLEOwPOF7wa7w9V4Mw7hTqdbcqMlJou0UVDaOriwTPmiIdFWUPVN2UMvJLNyDV8
         XgGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=14Z/GaYZBZ6HoBuA5dIAIsnw7um9EX/tC6i5kWshVnw=;
        b=GDxysD1zub3UZfQSeioNXmy6kZQNxFqAYSuMVqHyyDhxEXIPT7N4VORnGXWdatikBO
         OZL6wIknnazOE2+V5oaMJ06zLt3t3QRHgayKAdtr4B7wmDREycqmDM7qPUsOgm6yOqdv
         v8kWrEHYGp3J1fXv8yFEk/DTvzw0lbWr4n5btMHljKbbNprWAqDKOFbyBqiQFoRfU5D/
         voxY7BbpsItCQaAAcPWSRhFAxGWUX3HiJez0oJ9r26QrIYBLpsMVTyseKTUsT6jgwKTu
         PltOdI6ZDXpenqIwYu4Ak4OAlOVCAkL1CRay6I1hx0QercAdkgU0dBNpCnR6XRI+PRNF
         bt5A==
X-Gm-Message-State: AOAM533SU80Gxu6MxYqNYBQwBs13PPLu3eYLG7zgabUWACVAnmJXO8U+
        6zEdbVZmTZMJKDUgMzyDetzCsvV7mWFBIA==
X-Google-Smtp-Source: ABdhPJyugRaS9PVKw3OzS3yXCzakAg0N5JMJmANE1O4RiSjwqn32fYdwfIqbk9WG6eXFzXArdszUsw==
X-Received: by 2002:a17:902:8697:b029:ea:a5dc:925f with SMTP id g23-20020a1709028697b02900eaa5dc925fmr10983583plo.56.1618600149923;
        Fri, 16 Apr 2021 12:09:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p126sm5295104pfb.32.2021.04.16.12.09.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 12:09:09 -0700 (PDT)
Message-ID: <6079e0d5.1c69fb81.ab1c6.f2ab@mx.google.com>
Date:   Fri, 16 Apr 2021 12:09:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.113
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.4.y baseline: 176 runs, 5 regressions (v5.4.113)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 176 runs, 5 regressions (v5.4.113)

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


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.113/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.113
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      ab3bed80f9d34641966eaa329fc7b296a21dab07 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6079abbf35813aace3dac6b6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.113/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.113/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6079abbf35813aace3dac=
6b7
        failing since 148 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6079abd7330a0491bedac76b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.113/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.113/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6079abd7330a0491bedac=
76c
        failing since 148 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6079aba439fc6c75fedac6e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.113/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.113/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6079aba439fc6c75fedac=
6e7
        failing since 148 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6079ab6b16181502bbdac6cf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.113/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.113/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6079ab6c16181502bbdac=
6d0
        failing since 148 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6079ab6a16181502bbdac6cb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.113/ar=
m/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.113/ar=
m/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6079ab6a16181502bbdac=
6cc
        failing since 148 days (last pass: v5.4.77, first fail: v5.4.78) =

 =20
