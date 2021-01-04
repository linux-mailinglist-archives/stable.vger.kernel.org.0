Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 619EB2EA12F
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 00:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbhADX5M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 18:57:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726333AbhADX5M (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 18:57:12 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CAB4C061793
        for <stable@vger.kernel.org>; Mon,  4 Jan 2021 15:56:32 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id e2so20123860pgi.5
        for <stable@vger.kernel.org>; Mon, 04 Jan 2021 15:56:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kdn+zxcLaSlttPIALk4pm6cX+JPW/EaQ0Jn9SP0BrMA=;
        b=Ayg/6uNSTwftE1R3/22pl2gASMYbwPQAafS9kuWRNvQTfrTe7YFoVLtwJunS09OUC7
         TBNZ/xa3v/YUPbMjVlvdWxYvojui1d2Lf7XR7Pr1RvwfjnM0iVeuRjSvSzGI6GdnL2mX
         9honFAMP4MCb4kYRkkr4mesBsVz2OzVYcK11KDuFtd026QNi+Qidm3N5hjseoyWWE5mB
         50nzT21MPBh6a0UNYTtax9b/RNpfhurxoGicWgywAk6UHhRcT6E3PpqQrmlMqZ+3apLy
         Slw0GwLqvnaDpl1XGiq+QqbX5Iz4rJdXYoE1fgPyOmO+Bj8rnaCILiMRquJ2HLMO53Fb
         FeTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kdn+zxcLaSlttPIALk4pm6cX+JPW/EaQ0Jn9SP0BrMA=;
        b=hKkUaRmx3dWlukWSycLLTB9QZlLbGdk0C/LZla7BuAqgqVv9xMJMZOTse8QngFVMH8
         YloJ0b6fq5Q4RKmthCL3Cp8YRDda/aFMobZFC2uBX++M5GQbh61c5OocQlDQHzAd1ZVA
         tPMpl/9vrk4azMNF8T1NLkIY0iKdDLPVBJT/K/eTLDt5gl+IlgyoWB9z+K2RXlo3Qg5S
         qHHLQ9Tf5t6gwKZigcy6/xMxl7oMCFBOqFMh8jdv2u+hprQytIOW4ELzov02zaxoOypn
         X7yQBw1KffSYqd5MoYF7+chgiKWbD4hCtWthmke9/mwyjL4sCFW6oS2GyY9WaZoDNJnX
         CXgg==
X-Gm-Message-State: AOAM530iPtzXtaCZnx62eqLUUTMLzslr4YfYeKv6xMjmPVUAMhppm7gK
        DSICyhsYPlPKFEMVt4LXDrRQ8Dmotx3ZjQ==
X-Google-Smtp-Source: ABdhPJx0OqAzkscE4cIvwjW4dYzTd9HAFx0RBJqxH1QTAwOn6yjXMo9cM5vUyTotQRkN2a7Bbq8LfA==
X-Received: by 2002:a05:6a00:228a:b029:18b:212a:1af7 with SMTP id f10-20020a056a00228ab029018b212a1af7mr67004960pfe.55.1609804591445;
        Mon, 04 Jan 2021 15:56:31 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b189sm56123479pfb.194.2021.01.04.15.56.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 15:56:30 -0800 (PST)
Message-ID: <5ff3ab2e.1c69fb81.23e80.fa1c@mx.google.com>
Date:   Mon, 04 Jan 2021 15:56:30 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.19.164
X-Kernelci-Report-Type: test
Subject: stable/linux-4.19.y baseline: 157 runs, 5 regressions (v4.19.164)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 157 runs, 5 regressions (v4.19.164)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.164/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.164
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      3207316b3beec7e38e5dbe2f463df0cec71e0b97 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff3782f6ff0b4b59cc94cdb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.164/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.164/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff3782f6ff0b4b59cc94=
cdc
        new failure (last pass: v4.19.163) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff3776a89e1641060c94cc7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.164/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.164/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff3776a89e1641060c94=
cc8
        failing since 47 days (last pass: v4.19.157, first fail: v4.19.158) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff3775b89e1641060c94cc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.164/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.164/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff3775b89e1641060c94=
cc4
        failing since 47 days (last pass: v4.19.157, first fail: v4.19.158) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff37754c931d8d827c94cd7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.164/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.164/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff37754c931d8d827c94=
cd8
        failing since 47 days (last pass: v4.19.157, first fail: v4.19.158) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff37b11c0bd3ea8a8c94cc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.164/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.164/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff37b11c0bd3ea8a8c94=
cc3
        failing since 47 days (last pass: v4.19.157, first fail: v4.19.158) =

 =20
