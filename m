Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4AD2F38C1
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 19:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405411AbhALSYR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 13:24:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405611AbhALSYR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jan 2021 13:24:17 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB440C061575
        for <stable@vger.kernel.org>; Tue, 12 Jan 2021 10:23:36 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id r4so1829037pls.11
        for <stable@vger.kernel.org>; Tue, 12 Jan 2021 10:23:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bBjSLnvM3+ilZdKJD2FbywAg4ezQANvICTn+vxqet58=;
        b=Ra65X19Xfva8KBiv6Vnc4JyEofbDRZSzVXEsuuYu4JfDyFANxfYiTyTWK8r8Pei8ve
         sldWGyoca/msv1jzzr86rvimgCpJBs5ge7O4cfhScNsLeK18cAl0O4Hu21Ri3DkOivzA
         TRgm3+aEYCLQFUZWXVv++oVMT2Y9hki4LxmHCYVmqTZk+3O69MOPUQPAo/ZPKgonE4E9
         Hjq/oTCj3i6DUPmJPeI7VvWMs6y9K8fNRf1k7wUqpZsI94/XsatjoR0xR2FQTr8dtpgx
         DFj+8d7oFxowVL4XGqqUod+uHB1yP86YJ5nTNZCrlTRSZFyXbMjVTj1NuT0wcsXkjz8N
         6BdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bBjSLnvM3+ilZdKJD2FbywAg4ezQANvICTn+vxqet58=;
        b=MWfDTINNqfkLVQZOlmfF8Y7rU+o/QI1vIz2KGmN/M5wVVgF8/DD6GGHVMjjIp/kBvh
         vwlFIr+WWkRA1UABw5R2Bfylds+RYycXTRVEn10VKGzdR/YlB3ix99QELXXv6jXjYaNa
         PW2qeBFvSWb5I2xbOxGD5pDOuwmoPas/8QOhH1trbomaInPOU4UlE+5HKiDmphc0o4/y
         zj9wffvaqZurfoyhSEWNJIfVlvoz6gSJiTaIneZDbGPYgz2M1yNcR7qAhMv6TcaDKByf
         YMlTPmDq/43L/j+PBh13VVFP6p4maH+E14VNorG52aDNxZjW8qMtwOsWDTEsTF5hSyNe
         ETqQ==
X-Gm-Message-State: AOAM531NZ5JFJPEj4di7E0SW6Sdkch62CS0a3bDnoT/o7nJ882aNpiJQ
        YIShg+0btJ4T3qXiADwCKkNi2kk0g6HsCA==
X-Google-Smtp-Source: ABdhPJx8S5xe3MXrjt4WEh+gDIVXn5JG/GImknXie/C5egFegSO07T/iUxvuN/nW9SRdpNLQGUBwRA==
X-Received: by 2002:a17:902:426:b029:db:65c4:dbf7 with SMTP id 35-20020a1709020426b02900db65c4dbf7mr442668ple.3.1610475815215;
        Tue, 12 Jan 2021 10:23:35 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e10sm4575854pgu.42.2021.01.12.10.23.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 10:23:34 -0800 (PST)
Message-ID: <5ffde926.1c69fb81.19c50.89a9@mx.google.com>
Date:   Tue, 12 Jan 2021 10:23:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.88-93-gcdbc5a73c7f4
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.4.y baseline: 194 runs,
 8 regressions (v5.4.88-93-gcdbc5a73c7f4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 194 runs, 8 regressions (v5.4.88-93-gcdbc5a=
73c7f4)

Regressions Summary
-------------------

platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
hifive-unleashed-a00  | riscv  | lab-baylibre    | gcc-8    | defconfig    =
       | 1          =

meson-gxm-khadas-vim2 | arm64  | lab-baylibre    | gcc-8    | defconfig    =
       | 1          =

qemu_arm-versatilepb  | arm    | lab-baylibre    | gcc-8    | versatile_def=
config | 1          =

qemu_arm-versatilepb  | arm    | lab-broonie     | gcc-8    | versatile_def=
config | 1          =

qemu_arm-versatilepb  | arm    | lab-cip         | gcc-8    | versatile_def=
config | 1          =

qemu_arm-versatilepb  | arm    | lab-collabora   | gcc-8    | versatile_def=
config | 1          =

qemu_arm-versatilepb  | arm    | lab-linaro-lkft | gcc-8    | versatile_def=
config | 1          =

qemu_x86_64           | x86_64 | lab-baylibre    | gcc-8    | x86_64_defcon=
fig    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.88-93-gcdbc5a73c7f4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.88-93-gcdbc5a73c7f4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cdbc5a73c7f4b2b8796ceea91083a4ad1ebfd113 =



Test Regressions
---------------- =



platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
hifive-unleashed-a00  | riscv  | lab-baylibre    | gcc-8    | defconfig    =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffdb0ad7873f68625c94cd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.88-=
93-gcdbc5a73c7f4/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.88-=
93-gcdbc5a73c7f4/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffdb0ad7873f68625c94=
cd4
        failing since 53 days (last pass: v5.4.77-152-ga3746663c3479, first=
 fail: v5.4.78) =

 =



platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
meson-gxm-khadas-vim2 | arm64  | lab-baylibre    | gcc-8    | defconfig    =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffdb2cbf94c59c87cc94d0f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.88-=
93-gcdbc5a73c7f4/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-khad=
as-vim2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.88-=
93-gcdbc5a73c7f4/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-khad=
as-vim2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffdb2cbf94c59c87cc94=
d10
        new failure (last pass: v5.4.88-87-g9a508dac62ec) =

 =



platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
qemu_arm-versatilepb  | arm    | lab-baylibre    | gcc-8    | versatile_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffdb06c11306dcd8fc94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.88-=
93-gcdbc5a73c7f4/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.88-=
93-gcdbc5a73c7f4/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffdb06c11306dcd8fc94=
cba
        failing since 58 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
qemu_arm-versatilepb  | arm    | lab-broonie     | gcc-8    | versatile_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffdb01e859498349dc94cc5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.88-=
93-gcdbc5a73c7f4/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.88-=
93-gcdbc5a73c7f4/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffdb01e859498349dc94=
cc6
        failing since 58 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
qemu_arm-versatilepb  | arm    | lab-cip         | gcc-8    | versatile_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffdb016e31c2cdc68c94cce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.88-=
93-gcdbc5a73c7f4/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.88-=
93-gcdbc5a73c7f4/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffdb016e31c2cdc68c94=
ccf
        failing since 58 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
qemu_arm-versatilepb  | arm    | lab-collabora   | gcc-8    | versatile_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffdafd0245a01dd4ec94ccf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.88-=
93-gcdbc5a73c7f4/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.88-=
93-gcdbc5a73c7f4/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffdafd0245a01dd4ec94=
cd0
        failing since 58 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
qemu_arm-versatilepb  | arm    | lab-linaro-lkft | gcc-8    | versatile_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffdafd71c15e6e154c94cc4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.88-=
93-gcdbc5a73c7f4/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.88-=
93-gcdbc5a73c7f4/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffdafd71c15e6e154c94=
cc5
        failing since 58 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
qemu_x86_64           | x86_64 | lab-baylibre    | gcc-8    | x86_64_defcon=
fig    | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffdb10b2216d21b0fc94cd7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.88-=
93-gcdbc5a73c7f4/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.88-=
93-gcdbc5a73c7f4/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffdb10b2216d21b0fc94=
cd8
        new failure (last pass: v5.4.88-87-g9a508dac62ec) =

 =20
