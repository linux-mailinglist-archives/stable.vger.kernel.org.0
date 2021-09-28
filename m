Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D68DC41B362
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 17:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241461AbhI1P6T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 11:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241405AbhI1P6S (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Sep 2021 11:58:18 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87042C06161C
        for <stable@vger.kernel.org>; Tue, 28 Sep 2021 08:56:39 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id u1-20020a17090ae00100b0019ec31d3ba2so2038898pjy.1
        for <stable@vger.kernel.org>; Tue, 28 Sep 2021 08:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Fp1qQAUJORQOrTgAkiFvmYIHI1SQEV7AeqdWFxdes8Q=;
        b=zkiVJjhYtz+/ew2Wjx+mXYDTjMWCyrZ4KB1vbeWArZnZorOq5wDmdUk0omQinTkIcN
         srjUm9udQAb7TG/CF5SxIRcQyejiijgtnwRhT8VpYPKNmQIVACOv1c58CsEYjWawjTxd
         wnvP3HPZqV6zCIRSbfVN0qsDbxgzQwhU4vSnFnkTfBbevg/6A5tjHTqLX9CgR1edbr/F
         4m1h4vSTAVSi9XW3KV6F9/eLdMChViHzm72PAjQwluz7CzwHcQWGJVeK9vkxPtO7IwUv
         BQujXwnOV2HuWWb6naw3igBWOzYoFNSYuNIiFomdOaECwRU+lfnzB+1Yu82C1NuR+qh5
         ErUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Fp1qQAUJORQOrTgAkiFvmYIHI1SQEV7AeqdWFxdes8Q=;
        b=Q0RZj1vZth1l4c8lgjPbBCMehRKGjaMrxMDpFk6/jV1MfGplKohVF7pa2KFScUC7IK
         JHLSmAVfi40krJspz1sizypbUina/YPcVq7u+YhCDjLQATHo57QHT6Pw193xqhmYzT9y
         NhSO9fALl4N+2TpQ8DitasdoodNta71PR50PVublY8LgPfccxa/L53Dg0cMP6ayvLqcb
         hZmN5vvHljq8/G4scuHal//VJKiRbjF2LccfscJNmjvD6dN92PqV1XpvjhytAB5Nckic
         t3OPrV7u+How9bSOwftj7bNh2hNdhW+uXeOJHspzKeaqooK9e3hgV/hYTmuw33aQ4Mrf
         Gb7g==
X-Gm-Message-State: AOAM532ACUqevRfmGaPOY+U76d2mfHsUX0N6pcQhQgBqfwyjZeQr3nHt
        Ih5BrkB+lVUVvjozc7oqolKApHJq2KwKToxO
X-Google-Smtp-Source: ABdhPJzU37/0ogBkmttRYhp+6IiEXUvECPheCOKP0By/IedsBazyVEkZQwnvCeDBFVhU1axJ/GtF9A==
X-Received: by 2002:a17:90b:14d6:: with SMTP id jz22mr638255pjb.61.1632844598848;
        Tue, 28 Sep 2021 08:56:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 130sm8009296pfz.77.2021.09.28.08.56.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 08:56:38 -0700 (PDT)
Message-ID: <61533b36.1c69fb81.6522e.a532@mx.google.com>
Date:   Tue, 28 Sep 2021 08:56:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.284-32-g78f9adc6c0af
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 119 runs,
 6 regressions (v4.9.284-32-g78f9adc6c0af)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 119 runs, 6 regressions (v4.9.284-32-g78f9a=
dc6c0af)

Regressions Summary
-------------------

platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
qemu_arm-versatilepb | arm    | lab-baylibre  | gcc-8    | versatile_defcon=
fig          | 1          =

qemu_arm-versatilepb | arm    | lab-broonie   | gcc-8    | versatile_defcon=
fig          | 1          =

qemu_arm-versatilepb | arm    | lab-cip       | gcc-8    | versatile_defcon=
fig          | 1          =

qemu_arm-versatilepb | arm    | lab-collabora | gcc-8    | versatile_defcon=
fig          | 1          =

qemu_x86_64          | x86_64 | lab-broonie   | gcc-8    | x86_64_defcon...=
6-chromebook | 1          =

r8a7795-salvator-x   | arm64  | lab-baylibre  | gcc-8    | defconfig       =
             | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.284-32-g78f9adc6c0af/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.284-32-g78f9adc6c0af
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      78f9adc6c0afe0a1625687d5e06296d7688597db =



Test Regressions
---------------- =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
qemu_arm-versatilepb | arm    | lab-baylibre  | gcc-8    | versatile_defcon=
fig          | 1          =


  Details:     https://kernelci.org/test/plan/id/61530440664496481999a30e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.284=
-32-g78f9adc6c0af/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.284=
-32-g78f9adc6c0af/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61530440664496481999a=
30f
        failing since 317 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
qemu_arm-versatilepb | arm    | lab-broonie   | gcc-8    | versatile_defcon=
fig          | 1          =


  Details:     https://kernelci.org/test/plan/id/61530550842897343c99a336

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.284=
-32-g78f9adc6c0af/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.284=
-32-g78f9adc6c0af/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61530550842897343c99a=
337
        failing since 317 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
qemu_arm-versatilepb | arm    | lab-cip       | gcc-8    | versatile_defcon=
fig          | 1          =


  Details:     https://kernelci.org/test/plan/id/6153043f75c8d2bff699a34c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.284=
-32-g78f9adc6c0af/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.284=
-32-g78f9adc6c0af/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6153043f75c8d2bff699a=
34d
        failing since 317 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
qemu_arm-versatilepb | arm    | lab-collabora | gcc-8    | versatile_defcon=
fig          | 1          =


  Details:     https://kernelci.org/test/plan/id/615303e7a8e9a4f81d99a2ed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.284=
-32-g78f9adc6c0af/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.284=
-32-g78f9adc6c0af/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615303e7a8e9a4f81d99a=
2ee
        failing since 317 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
qemu_x86_64          | x86_64 | lab-broonie   | gcc-8    | x86_64_defcon...=
6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/615307d141b31eead499a2ea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.284=
-32-g78f9adc6c0af/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/=
baseline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.284=
-32-g78f9adc6c0af/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/=
baseline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615307d141b31eead499a=
2eb
        new failure (last pass: v4.9.283-27-g09643351c2e1) =

 =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
r8a7795-salvator-x   | arm64  | lab-baylibre  | gcc-8    | defconfig       =
             | 1          =


  Details:     https://kernelci.org/test/plan/id/61530ad882a07de4b599a309

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.284=
-32-g78f9adc6c0af/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.284=
-32-g78f9adc6c0af/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61530ad882a07de4b599a=
30a
        failing since 314 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-79-gd3e70b39d31a) =

 =20
