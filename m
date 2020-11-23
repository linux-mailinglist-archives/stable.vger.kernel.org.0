Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 654112C196C
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 00:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbgKWX1q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 18:27:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726712AbgKWX1o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 18:27:44 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 774FAC0613CF
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 15:27:44 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id v21so15737630pgi.2
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 15:27:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lMs5Y3q9dkiDEM1TAyXq+EfvZA/Kd5eF9ZrJgZI/YWw=;
        b=i48+s0m0cfl/ETOhtI89SIpxP/x4tn2IICi5kJ2CjNbQmeLTwDPqUZd1eWfv6+7An8
         fQ+1bilKLBoxO8JfZQ/Oih94zd0MCCJzaTT3qq3EDyV2iOfwB6GITgiosc0AKHN1zeSB
         rCs8d04btT5tNneaNQS2cP0GDWTW6UUiUYKjzNsHNDBgTAaC0qAy433iSM174qAv49gn
         /GgWh9aoCyZsa6cCZxkn714TZ99wN5a/L8SdMRvyGLHEp4luAtDnwZG7kk6MBOQOM6yV
         kSrgtUFgXT3pUfWUy9ZqcjkB9Z8oKeOIfiITIaH+EISa0fpxL1fR0Vb8AQOC2fUb3mrH
         FvQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lMs5Y3q9dkiDEM1TAyXq+EfvZA/Kd5eF9ZrJgZI/YWw=;
        b=G8ZSdojnsEWu1MNvsOl/Ywu4Xtmx/WqFNGplqAzDze29vrSkD7Agkj3Fa9LIaU5g+8
         Q2fqAGBibHKN9U/WdOH5NJduT7yiBvTcjJtKgrfdYVuBdbTUmkpmXcgUkioIN5O2JGMr
         rQrqAwSxCn4GclbGqJA4zW8At3UdelN5JE2dRKnQ/zEX1xAfjHLMFVy/Vp4gNjpnF5p5
         HtBxALNrLSvVkWMB2n3JcJ3YxL2gsT+iqIvB39t7eOOtAj8yqhZsg10HGqpnOKuN2qtq
         SACv8NQbshgdg+mrI9bdjY3r3TiwOdcAyB9NfeFELUpbSC0VM2U1dQlPB0a7QkXpI2fo
         nZuA==
X-Gm-Message-State: AOAM532ZMTVHpsuLqAuZf4yi7hnz9irCWHpmR8PyWR4PLeX5l1Ji7Kjq
        A7JMoFqYsjV9YIkLVCwlmOHWa8FQqQ8p3w==
X-Google-Smtp-Source: ABdhPJzVW41K2l+FE1l1Mfw/KpZcnPLY8Cxo0i5FRtpLCrQ14AKc1OCHEbiSBPZT9qEk/Cw9kTP+OA==
X-Received: by 2002:a63:e809:: with SMTP id s9mr1472757pgh.138.1606174063661;
        Mon, 23 Nov 2020 15:27:43 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a21sm452050pjq.37.2020.11.23.15.27.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 15:27:42 -0800 (PST)
Message-ID: <5fbc456e.1c69fb81.b6e2f.1edc@mx.google.com>
Date:   Mon, 23 Nov 2020 15:27:42 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.245-48-g1a0738f3aaf5
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.9.y baseline: 39 runs,
 5 regressions (v4.9.245-48-g1a0738f3aaf5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 39 runs, 5 regressions (v4.9.245-48-g1a0738=
f3aaf5)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.245-48-g1a0738f3aaf5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.245-48-g1a0738f3aaf5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1a0738f3aaf5542394e8c7ce9738027a79b26241 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbbbe9219707f85a7d8d904

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.245=
-48-g1a0738f3aaf5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.245=
-48-g1a0738f3aaf5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbbbe9219707f85a7d8d=
905
        failing since 8 days (last pass: v4.9.243-17-g9c24315b745a0, first =
fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbbbeafa858eaca00d8d91a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.245=
-48-g1a0738f3aaf5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.245=
-48-g1a0738f3aaf5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbbbeafa858eaca00d8d=
91b
        failing since 8 days (last pass: v4.9.243-17-g9c24315b745a0, first =
fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbbbe9ea858eaca00d8d904

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.245=
-48-g1a0738f3aaf5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.245=
-48-g1a0738f3aaf5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbbbe9ea858eaca00d8d=
905
        failing since 8 days (last pass: v4.9.243-17-g9c24315b745a0, first =
fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbbbe7263cc67d91cd8d912

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.245=
-48-g1a0738f3aaf5/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.245=
-48-g1a0738f3aaf5/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbbbe7263cc67d91cd8d=
913
        failing since 8 days (last pass: v4.9.243-17-g9c24315b745a0, first =
fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbbbe45167eb0812bd8d933

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.245=
-48-g1a0738f3aaf5/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.245=
-48-g1a0738f3aaf5/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbbbe45167eb0812bd8d=
934
        failing since 5 days (last pass: v4.9.243-17-g9c24315b745a0, first =
fail: v4.9.243-79-gd3e70b39d31a) =

 =20
