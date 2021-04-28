Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B136536DF7C
	for <lists+stable@lfdr.de>; Wed, 28 Apr 2021 21:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbhD1TWM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Apr 2021 15:22:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbhD1TWJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Apr 2021 15:22:09 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D1EC061573
        for <stable@vger.kernel.org>; Wed, 28 Apr 2021 12:21:24 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id gc22-20020a17090b3116b02901558435aec1so5935495pjb.4
        for <stable@vger.kernel.org>; Wed, 28 Apr 2021 12:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2o+iE1HGk1ec/Ks8MRM5kpnuFAeVYwmOgQqojptllKk=;
        b=AxKvc+bO7ciyBWtvY31kyvZKKk5aTxeQ0IuuL6V8zbVsWXN9kRv0knwumFnm/FBhpr
         5cEgrXid7QjYS3Ifj5XTBQcVH+FGjRv75gbwPmd2w1JtCEg9xe2UnKWJdUmmynHcvYPt
         66+GL6iHgT119fjV/ioMDHdlJQM57KXkF/LDheIV6limAoLbrf+T5eISXPBN6i6ocw8B
         AXzCZkHMGITE2lQ1OcYuQes4nSr7EvXmJoanRlqEDnXeig35RE0W70sBku4CItPy4nIi
         PRCFes5lNFoQ4/zQu1eqCE2wam3AAsWesR43ffxN2Y9gY9wW1vGdbA5rKZg2SfNsSu7K
         NDJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2o+iE1HGk1ec/Ks8MRM5kpnuFAeVYwmOgQqojptllKk=;
        b=i22iQUCYB+UDDOIT3DhmQPV/XV3hyrCZ4W3ahOMcew/d6Ej5BdrCP/Fi5fMDDWYxW3
         e3bZT6dGuIAbpAQbnmCwIFkhUQW0Lme4C/LmJJWjzprXQvrxy/7y8nAVz8xpSPBw0xl/
         qqNbNof6ZWjUcNCN0V8QuS/jqYREah/aZRcG/JsYVCMdwfC3pXJWp3xkYvrbTAPQZd12
         S3Cc8eNbFI8zr/O+ylyThDGypg6i6xkv7+nW9arBU1FbA3CF9oi+OKHyxa+tuSchMNGh
         P77Af+78cGXSD4qGvBrYJfWoQtX2PDMgQa18Z0PrE5/vZljjTUtIwFrThY/bvNg68RQT
         p7ng==
X-Gm-Message-State: AOAM530nzTvCxfx6/cMnyldXU6ZF8XDVUMmbsBQClXn9KasRHqkVQUug
        SXGRu6G3y7IWEq28m/wzJNDbYewfHbKBFY+7
X-Google-Smtp-Source: ABdhPJwm0SxQVImFrdPi4wzKCj/UgtOp2cW3WYbhQYGef9VRvKW8QmpchMT8NUpNsSQvU+K6cyXKcQ==
X-Received: by 2002:a17:902:20e:b029:ec:a39a:4194 with SMTP id 14-20020a170902020eb02900eca39a4194mr31193645plc.31.1619637684223;
        Wed, 28 Apr 2021 12:21:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a129sm449936pfa.36.2021.04.28.12.21.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 12:21:24 -0700 (PDT)
Message-ID: <6089b5b4.1c69fb81.10857.1d68@mx.google.com>
Date:   Wed, 28 Apr 2021 12:21:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.189
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 101 runs, 3 regressions (v4.19.189)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 101 runs, 3 regressions (v4.19.189)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.189/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.189
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      97a8651cadce7c2b7c4d8f108b392eff31fe2c08 =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60898035746737c8099b779a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
89/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
89/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60898035746737c8099b7=
79b
        failing since 161 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6089802c0eeaa367499b77bc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
89/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
89/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6089802c0eeaa367499b7=
7bd
        failing since 161 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60898063b01e1aad619b77b6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
89/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
89/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60898063b01e1aad619b7=
7b7
        failing since 161 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
