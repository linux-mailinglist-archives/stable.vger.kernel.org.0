Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 369D7401B16
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 14:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238449AbhIFMXO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 08:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239957AbhIFMXN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Sep 2021 08:23:13 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3DC8C06175F
        for <stable@vger.kernel.org>; Mon,  6 Sep 2021 05:22:08 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id g184so6642866pgc.6
        for <stable@vger.kernel.org>; Mon, 06 Sep 2021 05:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=g2I2dVGsjDF2HbqhybyFM7LbcS/YfFW5CvXC/NQZGN0=;
        b=JOIQI0jl/XGCLPdhDGld0afCqvSEHSi8FtPaiwH/R5QVJD42vLMykKh9zk0hfolem3
         Rtja29IJcNoFXs8dAMudSGsOaX0o37k2brpd+odvylvoNOTn7JSmnHXhf3EeF10Zhjdf
         WHeworxOMVDLRG3jAeXzpuKoqR/NWpB6H2IyjXMvYN/OBvIH/q55BKUJeEYFHbLu8PIr
         zx+k1Bpzu2O6gt7xQEM3griXGTzVRf5j/X3Xaye3V9XtM0JwZxwVsjR4H9gmC+9DEfmM
         5E2kE0J0SVbyIXJqEnT4Qy+mJMfb4wBTqkg5RHJf4eebP7uBgPQdQtIq1a3vvInwWK2T
         mKUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=g2I2dVGsjDF2HbqhybyFM7LbcS/YfFW5CvXC/NQZGN0=;
        b=VnOFJv4KfuMyOI5EuqhjdcKD4D0R0qEZWd6Nphs+ADlNyoUF7uLLp7eOXHvf2mdfiS
         sPVtDZWvJYgG1alI6QLN3zBckfALZm6qO1+/x78FLJ7JbKC+Hcrmyvhfe8l9pYbNHwqk
         C2t8oNfw4CIDBTR18YWkTEsQH/EmLDZk8RAFIu+374TNF1l15AGF6Xp/e6dKX9mvfGpY
         jay2WiwNzvliUlgWlYutiCr2RDoIMywMpEqzHuR7BY71uy8fTEDLuALC+zNHJ415zMUm
         5tMnI3R+8oiYh2v8t23GNizPNwLYMWHtEQzpmK7yUDk5RleKyZEYllY8XX1F0hmqlKGm
         akgA==
X-Gm-Message-State: AOAM531D0A5QXH3RuAYjYNvO8y38jY7lP/qUhNjKSE9GUeIqWJrsl5fz
        khiMjlCtvsxN1cwGqTy7XbqU2G65WVRNdJgr
X-Google-Smtp-Source: ABdhPJwYqyLIHc8K+2tqeRt1Ju/HeYTRGzY5eHq0vEcHcy1EFOU6b8jZJ/pyxwaKWI593/LowjYVMQ==
X-Received: by 2002:a63:7211:: with SMTP id n17mr12023145pgc.456.1630930928246;
        Mon, 06 Sep 2021 05:22:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p9sm7669653pfn.97.2021.09.06.05.22.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Sep 2021 05:22:07 -0700 (PDT)
Message-ID: <613607ef.1c69fb81.ae224.555c@mx.google.com>
Date:   Mon, 06 Sep 2021 05:22:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.282-9-g567fe77edc70
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 159 runs,
 5 regressions (v4.9.282-9-g567fe77edc70)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 159 runs, 5 regressions (v4.9.282-9-g567fe77e=
dc70)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.282-9-g567fe77edc70/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.282-9-g567fe77edc70
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      567fe77edc709f327ad75b2baa2382b585aee4fa =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6135d5645b7750da85d5966a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-9=
-g567fe77edc70/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-9=
-g567fe77edc70/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6135d5645b7750da85d59=
66b
        failing since 296 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6135d55b7df6f7a4a7d5966a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-9=
-g567fe77edc70/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-9=
-g567fe77edc70/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6135d55b7df6f7a4a7d59=
66b
        failing since 296 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6135d55a8591b2c769d5966d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-9=
-g567fe77edc70/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-9=
-g567fe77edc70/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6135d55a8591b2c769d59=
66e
        failing since 296 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6135e108087c3f28c3d59682

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-9=
-g567fe77edc70/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-9=
-g567fe77edc70/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6135e108087c3f28c3d59=
683
        failing since 296 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6135d4fce6af003e81d5969d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-9=
-g567fe77edc70/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-9=
-g567fe77edc70/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6135d4fce6af003e81d59=
69e
        failing since 296 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
