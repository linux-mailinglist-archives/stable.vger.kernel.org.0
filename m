Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D71F134F1DA
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 21:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233259AbhC3TyO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 15:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233337AbhC3Txl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Mar 2021 15:53:41 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5865C061574
        for <stable@vger.kernel.org>; Tue, 30 Mar 2021 12:53:41 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id h3so12851915pfr.12
        for <stable@vger.kernel.org>; Tue, 30 Mar 2021 12:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SCAfN+Q3LFO0baSYY/F6AuR2GrK7f4EkF7mmfr3vLbI=;
        b=0H/XTSqD7+YONYlLKiwYvddbeQK2bXWpv65FMi1TCoWIKnWnpP5hCZ+dQzqfFU1S+M
         tumCwuwc+A+A7rbmkbITgnrctnIoZRRZCmCN+B4gUu91vAqAE/x8v5l8oA7SviHYkCMo
         Xw0RTlPgL7sNsbhjCUstXmJ0YawkdWanBZZXM9JzwkDuC6LJjw9Up6PJCv7Bq2QCPcmA
         EtauXZJplH0p5KXAsVjeQ6pDC/VWU1hbgnyfhLZCLdQf5VQsa7pmoqwamPa1smO2TFdW
         a2cxMOelshXGrMVqjWJhyfW+8JtjUKooIU08sm7n8Ci2Ea5e68SEJTWCWQ0eJTRocvAs
         PTBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SCAfN+Q3LFO0baSYY/F6AuR2GrK7f4EkF7mmfr3vLbI=;
        b=ubYlL9cijnQ+VoV2QxjXSra49m4KChg/TAY07gzmoz8297K+mdcUXEEIxlBeTULuvC
         KW0D3hdTAnHxUh0UhpxOFM8K/QrvptPx8+FdB7+7cHJso/bLmGm8Bg0r7Z4tgKuV5ior
         Ot+gWyAxBI65mfjMDEoxnSm2ZT18X3YlQvWBYV9bK4lfqRB9vGx2BvulbX9tIVx5wWUa
         csBJYFNcfDUwSDkik2UnNxw8OtjxekpLcRSNZcdNGXNxdEaEHegqqPB1panWD+NI/doU
         +VNWKjHJcsaDSydfT2nBhAy9OElAQHsArGByz7E1KuHZuoIMfnUEUTeHLfgQc4G47dfp
         MYxA==
X-Gm-Message-State: AOAM532ThiEseKkbcX+AUNVXxJ/mhbR/TqbIlFBTKQwyJmsScVCyzlAw
        XKnoEe5dKoZj31fsS5kvpdUxqYY2dySLWg==
X-Google-Smtp-Source: ABdhPJytrFn3UsA3cfd7Jc5SQ145uM2Ip9LYhogBM3nBacFRm10jLKh7ZKsx3ZPJKXuMy0o+2aw2OQ==
X-Received: by 2002:a63:6744:: with SMTP id b65mr29481288pgc.314.1617134020959;
        Tue, 30 Mar 2021 12:53:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x125sm21508500pfd.124.2021.03.30.12.53.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 12:53:40 -0700 (PDT)
Message-ID: <606381c4.1c69fb81.ebcf8.47dd@mx.google.com>
Date:   Tue, 30 Mar 2021 12:53:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.227-60-g91b0dae99c608
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 136 runs,
 10 regressions (v4.14.227-60-g91b0dae99c608)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 136 runs, 10 regressions (v4.14.227-60-g91b0=
dae99c608)

Regressions Summary
-------------------

platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
meson-gxm-q200       | arm64  | lab-baylibre    | gcc-8    | defconfig     =
      | 1          =

qemu_arm-versatilepb | arm    | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-collabora   | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =

qemu_i386            | i386   | lab-baylibre    | gcc-8    | i386_defconfig=
      | 1          =

qemu_i386-uefi       | i386   | lab-baylibre    | gcc-8    | i386_defconfig=
      | 1          =

qemu_x86_64          | x86_64 | lab-baylibre    | gcc-8    | x86_64_defconf=
ig    | 1          =

qemu_x86_64-uefi     | x86_64 | lab-baylibre    | gcc-8    | x86_64_defconf=
ig    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.227-60-g91b0dae99c608/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.227-60-g91b0dae99c608
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      91b0dae99c608ef11d397e986f1bc1faeb3c651e =



Test Regressions
---------------- =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
meson-gxm-q200       | arm64  | lab-baylibre    | gcc-8    | defconfig     =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/6063541d61b30f56c0dac6ba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.227=
-60-g91b0dae99c608/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.227=
-60-g91b0dae99c608/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6063541d61b30f56c0dac=
6bb
        failing since 29 days (last pass: v4.14.222-11-g13b8482a0f700, firs=
t fail: v4.14.222-120-gdc8887cba23e) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60634ccd96b0705f3edac6d7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.227=
-60-g91b0dae99c608/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.227=
-60-g91b0dae99c608/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60634ccd96b0705f3edac=
6d8
        failing since 136 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60634ccf30e306966ddac6dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.227=
-60-g91b0dae99c608/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.227=
-60-g91b0dae99c608/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60634ccf30e306966ddac=
6dd
        failing since 136 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60634cceb038345473dac71b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.227=
-60-g91b0dae99c608/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.227=
-60-g91b0dae99c608/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60634cceb038345473dac=
71c
        failing since 136 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-collabora   | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60634ddd66d2bdba89dac6b2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.227=
-60-g91b0dae99c608/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.227=
-60-g91b0dae99c608/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60634ddd66d2bdba89dac=
6b3
        failing since 136 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60634c74af66f23e8fdac6b9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.227=
-60-g91b0dae99c608/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.227=
-60-g91b0dae99c608/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60634c74af66f23e8fdac=
6ba
        failing since 136 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_i386            | i386   | lab-baylibre    | gcc-8    | i386_defconfig=
      | 1          =


  Details:     https://kernelci.org/test/plan/id/60634f618f7e69d220dac6bc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.227=
-60-g91b0dae99c608/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i38=
6.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.227=
-60-g91b0dae99c608/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i38=
6.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60634f618f7e69d220dac=
6bd
        new failure (last pass: v4.14.227-59-gc0b36f1867878) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_i386-uefi       | i386   | lab-baylibre    | gcc-8    | i386_defconfig=
      | 1          =


  Details:     https://kernelci.org/test/plan/id/60634f3cf754fc344adac6bd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.227=
-60-g91b0dae99c608/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i38=
6-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.227=
-60-g91b0dae99c608/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i38=
6-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60634f3cf754fc344adac=
6be
        new failure (last pass: v4.14.227-59-gc0b36f1867878) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_x86_64          | x86_64 | lab-baylibre    | gcc-8    | x86_64_defconf=
ig    | 1          =


  Details:     https://kernelci.org/test/plan/id/60634ec2c63559e84adac6c8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.227=
-60-g91b0dae99c608/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.227=
-60-g91b0dae99c608/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60634ec2c63559e84adac=
6c9
        new failure (last pass: v4.14.227-59-g313a7305dd4c) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_x86_64-uefi     | x86_64 | lab-baylibre    | gcc-8    | x86_64_defconf=
ig    | 1          =


  Details:     https://kernelci.org/test/plan/id/60634ed624f331686cdac6e4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.227=
-60-g91b0dae99c608/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.227=
-60-g91b0dae99c608/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60634ed624f331686cdac=
6e5
        new failure (last pass: v4.14.227-59-g313a7305dd4c) =

 =20
