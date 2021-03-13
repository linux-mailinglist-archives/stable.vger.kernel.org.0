Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8E4E33A072
	for <lists+stable@lfdr.de>; Sat, 13 Mar 2021 20:27:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234407AbhCMT07 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Mar 2021 14:26:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234385AbhCMT06 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Mar 2021 14:26:58 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E358AC061574
        for <stable@vger.kernel.org>; Sat, 13 Mar 2021 11:26:57 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id e2so8189498pld.9
        for <stable@vger.kernel.org>; Sat, 13 Mar 2021 11:26:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ClEnERKwBG9CflG8ZGRXcN1sXvvgaoPzU5VD0NVYlkE=;
        b=U320ugb+URbMYiHWLBevvfs7LGyLOd0jU/PgRZBBSV01in67N+JFXCZtQfjEWNxN4S
         y1fcDmkHnx4aqaCqLtjZyQlH5TdnIyLqizFy6Yz5SQ+TotBPCovJf9qRMdwW/qCwVRYD
         2Q3X2T7zJ1LR3FsXj5OUEdY1bg1LeAUaQuqmmH5kTBV5RlZRjLt4j39pfJbLkqtUIMJx
         vTFRW3ikDLdnQKQF626ASioevs9NOYX5VqQ6ViDd+geIh1QDXwB4gS9X0c0EngNAxVDe
         VPfotMPXc6GAUYw5Yk4aG2tEjxMQCNBATOenpQFHI7y+bAQxs/EGv4t9OqVYnO/aGHrL
         rgYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ClEnERKwBG9CflG8ZGRXcN1sXvvgaoPzU5VD0NVYlkE=;
        b=An7E2lAROyIBniE+az8qFm7neKs/2EHFks6IynDXG/3Xzhi6yP2ThW9fJsbX5/Me7+
         +QDOcBBlHW4XKvdmtsK8i71lt+Lrpvay0BYT0jk8DQeByOysLqG8bRpwlLMRW5+oOD04
         yydNhllkD9I60Fom22qc1Qjtvy1j9Teu/pApwh9Q0q5QylTZmFrP5mwdO4cuJpBedovL
         tpHKd/GF45NrTxcwhJci+A3Ys1H6upCP2n5ssoux81gHGV6loUu+5Q88jOvmEreF+JCM
         iabzzIDEMnPbcFopKHEoVv2K8ynhv1TpvWYosjoL/PGzZK4IcM08/G594DP0nIsCluv0
         hIfQ==
X-Gm-Message-State: AOAM531130UigTY0vbZiLm4N9DIMSirImOYE0wUeA6PEI4nPxmPrm56c
        9qw3p0jz0KTKskZGtrHDuwgK2yEzh8W+QQ==
X-Google-Smtp-Source: ABdhPJxqmh9QpBVsMCWE2/HIt360mr+6rL1BAbDbPzdqISED2G7hXN4GpEDIcQ8kl/8Ax8Kn/PBIiQ==
X-Received: by 2002:a17:90a:4604:: with SMTP id w4mr4939160pjg.56.1615663617312;
        Sat, 13 Mar 2021 11:26:57 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i4sm9265993pfo.14.2021.03.13.11.26.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Mar 2021 11:26:57 -0800 (PST)
Message-ID: <604d1201.1c69fb81.44467.7c23@mx.google.com>
Date:   Sat, 13 Mar 2021 11:26:57 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.261-30-g7757f0f666c0
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 92 runs,
 6 regressions (v4.9.261-30-g7757f0f666c0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 92 runs, 6 regressions (v4.9.261-30-g7757f0f6=
66c0)

Regressions Summary
-------------------

platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
panda                | arm    | lab-collabora   | gcc-8    | omap2plus_defc=
onfig | 1          =

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.261-30-g7757f0f666c0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.261-30-g7757f0f666c0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7757f0f666c01d664659f2609dffab0b72a340de =



Test Regressions
---------------- =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
panda                | arm    | lab-collabora   | gcc-8    | omap2plus_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/604cd9dd32fe85d7f8addcc5

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-3=
0-g7757f0f666c0/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-3=
0-g7757f0f666c0/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/604cd9dd32fe85d=
7f8addcca
        failing since 0 day (last pass: v4.9.261-17-g0640bd71e2fe1, first f=
ail: v4.9.261-24-gc9deaed4c3062)
        2 lines

    2021-03-13 15:27:21.519000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/125
    2021-03-13 15:27:21.528000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/604cd7074662953e5caddd16

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-3=
0-g7757f0f666c0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-3=
0-g7757f0f666c0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604cd7074662953e5cadd=
d17
        failing since 119 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/604cd7b61d72e5abdeaddceb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-3=
0-g7757f0f666c0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-3=
0-g7757f0f666c0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604cd7b61d72e5abdeadd=
cec
        failing since 119 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-collabora   | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/604cd69da031ede758addccc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-3=
0-g7757f0f666c0/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-3=
0-g7757f0f666c0/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604cd69da031ede758add=
ccd
        failing since 119 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/604cd6a3cb8f8eedb2addcd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-3=
0-g7757f0f666c0/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-3=
0-g7757f0f666c0/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604cd6a3cb8f8eedb2add=
cd2
        failing since 119 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_x86_64-uefi     | x86_64 | lab-broonie     | gcc-8    | x86_64_defconf=
ig    | 1          =


  Details:     https://kernelci.org/test/plan/id/604cd6f40edc8aebacaddcce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-3=
0-g7757f0f666c0/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x86=
_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-3=
0-g7757f0f666c0/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x86=
_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604cd6f40edc8aebacadd=
ccf
        new failure (last pass: v4.9.261-24-gc9deaed4c3062) =

 =20
