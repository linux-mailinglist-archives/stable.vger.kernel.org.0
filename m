Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86002389B0F
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 03:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbhETB6Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 21:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbhETB6P (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 May 2021 21:58:15 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85CD9C061574
        for <stable@vger.kernel.org>; Wed, 19 May 2021 18:56:54 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id g18so9547231pfr.2
        for <stable@vger.kernel.org>; Wed, 19 May 2021 18:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tHLEtRJn+XDx7+piz22lSGckOzaxVcQJDE/LFEbLrwI=;
        b=aU6DOV7wm/xz+EAT3xGh4sfQyic3ghVQS1fYgGoHhlJ6FjZ0IYZU47y1kI69+iqcv1
         rMGR4N0gTQRcSP5mXAPoaDWX+WXxnbyY2FJtSOlSEtOdjIGEvpqHpuPm3thmWp+hdEH+
         92AC3+z+LMlZVcM3qKy8bdOAwQUgV/UYrUsyonKuu8CTCVFy343IFxSmG+7b8EsKf2ZT
         ZDQMUJ5PGcoKIpbZUcaI/Rf4fwe3tFRnjDWBtslPq37V6IwLiLT9GquT6hMkbF4Jlcgy
         8+8WuPK23K8HW+T/Yu7eW4cNiBLN01tXnQToqRXdHbc5UnwmsbsNMUzCBRRMe+ZyFyge
         0oWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tHLEtRJn+XDx7+piz22lSGckOzaxVcQJDE/LFEbLrwI=;
        b=PSAHsIvbyXFANTBEmC11VN4G8G3p80QWmDY1KmjCRTpcNNJPdsn083E05z6J84MMQ7
         8e03zWvmeNs8waxH9YaSweBSgz+SoR/lIMMy33i1ncWaEsMPG60yvbs1H75+dvhCBL4W
         rIZ8xPn2BtazD00n9BapxUEmfCj/lIgdlVsY5QuIu4zlrqewI4EYCsI9R7nDMhKSOzj6
         ifxmbyp3LXXYsBE/tQXL4/GkOFT/eMulJ2tVOwsudjfICtOglz/rGxEPYTxjoW2lkT3L
         8Yf9ik2pc6Lmqq4dDBdJEzjlVF7IFlqxjZwADzy5WvaLu3Njvju1DPyymC3LIndTSB6g
         R6Ag==
X-Gm-Message-State: AOAM530oK8TF/OWXRkEQutHHklichnxzpdHBBg+lCyqPu/xw+YYtYl1U
        TpnM2+8kD2sI5KzGDww+B9tlX+rzteeFOGHA
X-Google-Smtp-Source: ABdhPJwxOwkcxgZwjj+b8YXdHxrR6sN42OY9AQdgj8SPmgLAe4RFLduYNJRmz11P8bR/dWMgPJf2eg==
X-Received: by 2002:a63:7e13:: with SMTP id z19mr2106430pgc.184.1621475813860;
        Wed, 19 May 2021 18:56:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y1sm523089pfn.13.2021.05.19.18.56.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 18:56:53 -0700 (PDT)
Message-ID: <60a5c1e5.1c69fb81.4f122.3186@mx.google.com>
Date:   Wed, 19 May 2021 18:56:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.4.120
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Report-Type: test
Subject: stable/linux-5.4.y baseline: 172 runs, 7 regressions (v5.4.120)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 172 runs, 7 regressions (v5.4.120)

Regressions Summary
-------------------

platform                 | arch  | lab             | compiler | defconfig  =
         | regressions
-------------------------+-------+-----------------+----------+------------=
---------+------------
hifive-unleashed-a00     | riscv | lab-baylibre    | gcc-8    | defconfig  =
         | 1          =

qemu_arm-versatilepb     | arm   | lab-baylibre    | gcc-8    | versatile_d=
efconfig | 1          =

qemu_arm-versatilepb     | arm   | lab-broonie     | gcc-8    | versatile_d=
efconfig | 1          =

qemu_arm-versatilepb     | arm   | lab-cip         | gcc-8    | versatile_d=
efconfig | 1          =

qemu_arm-versatilepb     | arm   | lab-collabora   | gcc-8    | versatile_d=
efconfig | 1          =

qemu_arm-versatilepb     | arm   | lab-linaro-lkft | gcc-8    | versatile_d=
efconfig | 1          =

r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip         | gcc-8    | defconfig  =
         | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.120/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.120
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      e05d387ba736bcabe414b0aa05831d151ac40385 =



Test Regressions
---------------- =



platform                 | arch  | lab             | compiler | defconfig  =
         | regressions
-------------------------+-------+-----------------+----------+------------=
---------+------------
hifive-unleashed-a00     | riscv | lab-baylibre    | gcc-8    | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/60a58ca83c818fc2b4b3afa2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.120/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.120/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a58ca83c818fc2b4b3a=
fa3
        failing since 182 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform                 | arch  | lab             | compiler | defconfig  =
         | regressions
-------------------------+-------+-----------------+----------+------------=
---------+------------
qemu_arm-versatilepb     | arm   | lab-baylibre    | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a589c96ecab1af44b3afa4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.120/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.120/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a589c96ecab1af44b3a=
fa5
        failing since 182 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform                 | arch  | lab             | compiler | defconfig  =
         | regressions
-------------------------+-------+-----------------+----------+------------=
---------+------------
qemu_arm-versatilepb     | arm   | lab-broonie     | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a589d98deae1e871b3afcf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.120/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.120/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a589d98deae1e871b3a=
fd0
        failing since 182 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform                 | arch  | lab             | compiler | defconfig  =
         | regressions
-------------------------+-------+-----------------+----------+------------=
---------+------------
qemu_arm-versatilepb     | arm   | lab-cip         | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a589fd67b2962d5db3afb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.120/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.120/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a589fd67b2962d5db3a=
fb2
        failing since 182 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform                 | arch  | lab             | compiler | defconfig  =
         | regressions
-------------------------+-------+-----------------+----------+------------=
---------+------------
qemu_arm-versatilepb     | arm   | lab-collabora   | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a5899179091e691eb3afbb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.120/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.120/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a5899179091e691eb3a=
fbc
        failing since 182 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform                 | arch  | lab             | compiler | defconfig  =
         | regressions
-------------------------+-------+-----------------+----------+------------=
---------+------------
qemu_arm-versatilepb     | arm   | lab-linaro-lkft | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a5bbda229484000db3af97

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.120/ar=
m/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.120/ar=
m/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a5bbda229484000db3a=
f98
        failing since 182 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform                 | arch  | lab             | compiler | defconfig  =
         | regressions
-------------------------+-------+-----------------+----------+------------=
---------+------------
r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip         | gcc-8    | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/60a58d6ed7859dc21fb3afa9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.120/ar=
m64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg2m-ex.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.120/ar=
m64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg2m-ex.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a58d6ed7859dc21fb3a=
faa
        new failure (last pass: v5.4.119) =

 =20
