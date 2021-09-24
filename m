Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9B254175C6
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346325AbhIXNdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346146AbhIXNcz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Sep 2021 09:32:55 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 378FCC07E5F2
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 06:22:31 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id s11so9807671pgr.11
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 06:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=n5ENAW7Dl+Ie9DHJ0u6DyrbgR3pjtj5hfHadXtqGwaU=;
        b=ZFQ7Omy5E/DwUOEVCo3a7YsipIYN4j1qvZBE/3IZQGMLfnQyydlRFQkmjMUeCrTA5K
         k70rEdnJNHjaFIONnc2oErwQoYHtvJ9hZhAtEh7l+GECxpK5j7Jb3CN52TGgCllvD0dl
         GZQiX+awXON6xV5A46xhdmBTDvIy7nN4Zxzz3833Sj2J7MYzksDYOL4Nvdx3bn0H8bBA
         bm8NDa6W7vXLgyMxNqffsq4Z25I0I2EAPvr5xhygTLhfFE/mXnMTlx6IDBwmBSC7uAGn
         btcGaTnYCf4WGfwY3Y/24G3FYitw6SMrd0KqOA6/w2iUR9bTPP1Q27GbpQcUOtH9TikW
         YSYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=n5ENAW7Dl+Ie9DHJ0u6DyrbgR3pjtj5hfHadXtqGwaU=;
        b=I4xorfBPnDOrxZtFnJrgpNFjHHDG4XYMsJ7zY6upl59LbTGnupuGldhV/ypcVcV1KP
         2CFOPhX/8xtALnMOgTHi4pSr4BGyTuYvDbuiBWaWyNZtAH1elB8tbznAbkrsCx69y53r
         DeaHCcLZezh0R3yBRBxwNcUjS3E8Nd+uTXzvqXkvzs6xftb1FK175VWFNYQTQUl699s+
         1KJ6WkBX0WqXGmTAjoa2wygi6kYIKC7XfOsQq3FgWJDiTkHZAJqYiT3VBPqoV9fuHSgM
         njPwdp+w4APitx0xRHKdw/3YvEyu5ke4hDLqv1p/8NBI9aaWar+LB4Va7vR4frl8bpxi
         vT4Q==
X-Gm-Message-State: AOAM531JNIldhNU33h7RO2YII/1ZvsMyrWe0ioAHsErEXjhmpaUAOZb+
        PMY+3qu+DEd2FPysWbiq+rwtIsAJzJcjyFz3
X-Google-Smtp-Source: ABdhPJyStFria9wdMd1X7cB4lg2yiOnb5JX2jT7oFqRzRm38hV3zYML47WlYqjqBdlEc/uS4HbWVZw==
X-Received: by 2002:a65:6658:: with SMTP id z24mr3880898pgv.266.1632489750561;
        Fri, 24 Sep 2021 06:22:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q4sm4133503pfl.50.2021.09.24.06.22.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 06:22:30 -0700 (PDT)
Message-ID: <614dd116.1c69fb81.ae7d6.e010@mx.google.com>
Date:   Fri, 24 Sep 2021 06:22:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.207-10-gd913a3e0b460
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 81 runs,
 3 regressions (v4.19.207-10-gd913a3e0b460)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 81 runs, 3 regressions (v4.19.207-10-gd913a3=
e0b460)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.207-10-gd913a3e0b460/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.207-10-gd913a3e0b460
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d913a3e0b46066dd31a0f042a2a534205aa50fff =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/614d964fb95b0cbb2d99a2de

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.207=
-10-gd913a3e0b460/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.207=
-10-gd913a3e0b460/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614d964fb95b0cbb2d99a=
2df
        failing since 314 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/614d9679d08754ad2999a2f2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.207=
-10-gd913a3e0b460/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.207=
-10-gd913a3e0b460/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614d9679d08754ad2999a=
2f3
        failing since 314 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/614d9655b95b0cbb2d99a305

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.207=
-10-gd913a3e0b460/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.207=
-10-gd913a3e0b460/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614d9655b95b0cbb2d99a=
306
        failing since 314 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
