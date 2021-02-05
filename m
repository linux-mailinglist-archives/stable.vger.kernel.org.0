Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79082311848
	for <lists+stable@lfdr.de>; Sat,  6 Feb 2021 03:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbhBFCdE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 21:33:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbhBFCcN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 21:32:13 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A807C08ECB6
        for <stable@vger.kernel.org>; Fri,  5 Feb 2021 14:59:59 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id s24so4427923pjp.5
        for <stable@vger.kernel.org>; Fri, 05 Feb 2021 14:59:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+oqr5EnC6A2vKJWNYUn5yP8q8nL3i0OEpFhvQn9j2YY=;
        b=k7KK+idXxIp9c4fDuaxklAun3FfCmdFOF+Ntfny6QyxlpKEUpQE8cqTX2kiA12grAE
         rtLQtDWXiarcLEvA9i99YH5A0BLW3UMLuofmzht8R8d2Em1VEwQiSrY2/KE7r5uvUkk9
         0c2cxOX+80UDmS2n/ztTcI2nRYZFLRx1sH4kMPJGURfsrgQK5rL5j4OpM7xhcxR/LWq7
         Nai90dCoLuv9Kfyh1BUY9kzKHy1GYwGO6cK/TU1ttF7rzfAs8sJUx+QeAr+bcNseLxwD
         X0pnZcNzjXV1ppT7BtihHJ4/SPsm1glP5uCTAwh4ZwVoF4YO5q1VtSQp6un5SM8QA31O
         2hLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+oqr5EnC6A2vKJWNYUn5yP8q8nL3i0OEpFhvQn9j2YY=;
        b=ppxeHSR+RJJTA1NTmxbPiKaRH31D1qF/voLXf2f5k1C+0BWdyjSjPQkiHBJvUjgCFn
         bFrARrGDCRZQ1aPiznOvqGcGhdA1NBRRPegnHbmOc5fCDh9JKSUq1K8GmsRnb15oMOGs
         jP6SzdBZdGRguTV6IGzyobsj/h8NQ6De3DYlFgPIjvPb0vL/cH0Q+nQSYFedParzUkqm
         ae79MVXBjCfvcRqP8tzvfyDyGti7JJZ6qkk6LEjUF8v2tPusl+CH62xNHpXhKQfpWNqX
         q9WbeDzbopz5cyQrqXeAjeHaz1VGktkYjZNjdzev29n66kBCG6xOkC86KYeojEyTXZts
         TtCQ==
X-Gm-Message-State: AOAM533iQiBqkusYsmqmZTNIybdIMP4/RZ32qA4xQevmzwOlGcMl+MfG
        qCiEC35DWJoscXh4+ReCQDp08V+sOV2Naw==
X-Google-Smtp-Source: ABdhPJyIl0Ov6MfDchME7saI9R78FpeRKd6/woNd02GX+6qJSZwAnfgjnJv2k22NLhGlDszUtgsITw==
X-Received: by 2002:a17:902:102:b029:e1:2a4c:61ed with SMTP id 2-20020a1709020102b02900e12a4c61edmr6308114plb.61.1612565998873;
        Fri, 05 Feb 2021 14:59:58 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l2sm9846333pju.25.2021.02.05.14.59.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 14:59:57 -0800 (PST)
Message-ID: <601dcded.1c69fb81.64c4d.5b12@mx.google.com>
Date:   Fri, 05 Feb 2021 14:59:57 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.256
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.9.y
Subject: stable/linux-4.9.y baseline: 98 runs, 5 regressions (v4.9.256)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y baseline: 98 runs, 5 regressions (v4.9.256)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =

r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.9.y/kernel/=
v4.9.256/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.9.y
  Describe: v4.9.256
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      80111b606c80e4945b437efced62282ac993b318 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/601d998a90f04715d73abe67

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.256/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.256/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d998a90f04715d73ab=
e68
        failing since 78 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/601d99c91b24034c2c3abe62

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.256/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.256/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d99c91b24034c2c3ab=
e63
        failing since 78 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/601d99a75b3b0c4f453abe99

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.256/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.256/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d99a75b3b0c4f453ab=
e9a
        failing since 78 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/601d993b6aac50e1ac3abe6c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.256/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.256/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d993b6aac50e1ac3ab=
e6d
        failing since 78 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/601d9c6de6cf7835723abec3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.256/ar=
m64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.256/ar=
m64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d9c6de6cf7835723ab=
ec4
        failing since 78 days (last pass: v4.9.243, first fail: v4.9.244) =

 =20
