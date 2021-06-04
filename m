Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFAE539AF3E
	for <lists+stable@lfdr.de>; Fri,  4 Jun 2021 02:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbhFDAzB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 20:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbhFDAzA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Jun 2021 20:55:00 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC120C06174A
        for <stable@vger.kernel.org>; Thu,  3 Jun 2021 17:53:01 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id o9so3659146pgd.2
        for <stable@vger.kernel.org>; Thu, 03 Jun 2021 17:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3EAJdkD8G1+Pg1bIsIJVy+qcLbny3zLjARJ6NmwOYzk=;
        b=aL/mKbZPogT/LWYMjpxOS2uzjiHZuzi8fUrzMBxQ7RGX7EsJfgam8u14eGb1nYcMGN
         yut6ueRBZcJ6kAv3KwrTxKgqKogdxU26uK2Vi2LjffTgMvZtCXmPV54Ah7ui6Uq+ctka
         rNLzDdSS+4UB5UStvsIj92t5RO5K+7tOlInLKumWMEPdyr7IxfBmSXYgOeBh6EopNILM
         o7L6PI1wW0dOrcpJFXvviaoxMxTnNt8/xAtj5h8p3FuqFI/qv1ULv6Mp3pZJhPMGUEs1
         ymU7jbLR09rZvJWUGPuH92OEFuvKFUQhzq/a/rf0JOuWVSXmFcV6GbI95ZZ+BdFcYoMc
         0z+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3EAJdkD8G1+Pg1bIsIJVy+qcLbny3zLjARJ6NmwOYzk=;
        b=B9Cx6re0vMaf2AxBjAjEqh1l59CRas6nV+EJOjz9FEyWyzYPxG+ruYr/2oWm8mgIPS
         mYNqFztzAjheKoE/OEUjHLHvQJn9IAjDt8Yr5XNBIrHfgEhRCQA+u5BxrMamA1XcvHG8
         fbg3qAbcr/BYg9Pt9k4hPx6BhqlO9jLqzertl90C16erBwqsfi7/0JBDpTx3d9gVqD86
         PkpOgHo5KBUk5TfunkU8wcQUl1msF368LcVpB2lXMILIbA9DU6MKX2gXh7su1vaGSnax
         KrKVWjVQFWG3bo28rzlQI/BTr0lVGQNlME/U2oIG8RmWpvTsdIZCgSUD4g+jr+GP59NL
         L/hA==
X-Gm-Message-State: AOAM532au8BqnxkbB5AFO+2IzwOIBNQbU4C6a9KMSGpPZZTtYGjU+OH6
        l9zKMB99IksZyzzNlV7v9wMl8umrK8twbA==
X-Google-Smtp-Source: ABdhPJx9aVBVMVOpHVXGd0IsFA+l8xK6ae/kj7UZY88sH4SDsBIU3mKnXwce2phDeiBSIMHDR7as3Q==
X-Received: by 2002:a63:f954:: with SMTP id q20mr2128256pgk.451.1622767981129;
        Thu, 03 Jun 2021 17:53:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 6sm206652pfw.56.2021.06.03.17.53.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 17:53:00 -0700 (PDT)
Message-ID: <60b9796c.1c69fb81.cdb63.1513@mx.google.com>
Date:   Thu, 03 Jun 2021 17:53:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.271
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.9.y baseline: 99 runs, 5 regressions (v4.9.271)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 99 runs, 5 regressions (v4.9.271)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
asus-C523NA-A20057-coral | x86_64 | lab-collabora | gcc-8    | x86_64_defco=
n...6-chromebook | 1          =

qemu_arm-versatilepb     | arm    | lab-baylibre  | gcc-8    | versatile_de=
fconfig          | 1          =

qemu_arm-versatilepb     | arm    | lab-broonie   | gcc-8    | versatile_de=
fconfig          | 1          =

qemu_arm-versatilepb     | arm    | lab-cip       | gcc-8    | versatile_de=
fconfig          | 1          =

r8a7795-salvator-x       | arm64  | lab-baylibre  | gcc-8    | defconfig   =
                 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.271/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.271
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d0291f712a37d9075856822b50178f6d300ab590 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
asus-C523NA-A20057-coral | x86_64 | lab-collabora | gcc-8    | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/60b94f7a9e6197c349b3afbc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.271=
/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-collabora/baseline-asus-C=
523NA-A20057-coral.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.271=
/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-collabora/baseline-asus-C=
523NA-A20057-coral.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b94f7a9e6197c349b3a=
fbd
        new failure (last pass: v4.9.270-72-g7c0244f56992) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
qemu_arm-versatilepb     | arm    | lab-baylibre  | gcc-8    | versatile_de=
fconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/60b946fdb7116d1c9fb3afa1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.271=
/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.271=
/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b946fdb7116d1c9fb3a=
fa2
        failing since 201 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
qemu_arm-versatilepb     | arm    | lab-broonie   | gcc-8    | versatile_de=
fconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/60b94709b7116d1c9fb3afa5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.271=
/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.271=
/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b94709b7116d1c9fb3a=
fa6
        failing since 201 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
qemu_arm-versatilepb     | arm    | lab-cip       | gcc-8    | versatile_de=
fconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/60b9470927af6a440ab3afa9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.271=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.271=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b9470927af6a440ab3a=
faa
        failing since 201 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
r8a7795-salvator-x       | arm64  | lab-baylibre  | gcc-8    | defconfig   =
                 | 1          =


  Details:     https://kernelci.org/test/plan/id/60b945d520eb3b600bb3afb2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.271=
/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.271=
/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b945d520eb3b600bb3a=
fb3
        failing since 197 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-79-gd3e70b39d31a) =

 =20
