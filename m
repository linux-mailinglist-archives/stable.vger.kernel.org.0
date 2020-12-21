Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04E252DFFF9
	for <lists+stable@lfdr.de>; Mon, 21 Dec 2020 19:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgLUSh5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 13:37:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725910AbgLUSh5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Dec 2020 13:37:57 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 171E5C0613D6
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 10:37:17 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id c12so6916399pfo.10
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 10:37:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eA/8hQB54WlZjOKPIMjrGkLKRLMbnQy2e6cQ2kB4jCU=;
        b=ayz82s6PQohF650tTVR/w3Hy1PsHAIRHuk3VQ/7tS1o58I6jgAJawzVu8MtDzYck7W
         /uc9OpFIlqZdYcvtBdm1+m6qQZdbxePytoDBM3WyACxYEMMOueGuW5E5TTPLTPHmXFGp
         2hhqRVqIlizi0HleZtO3rQ/lSQxkLo6i/tz8btcK/dDXYECCAt26H97c4oY0wndu+dtU
         xN5SknHouafxtG8WipLerLWaZvSxXdXhTWGLn/6eR0bHC+QMaC4TP8nMrjwVNJX+SS63
         LHUG8FkgqaAyAq582++hrrbj8WHgLlLhoaUiHVBEBywrJWTqTCx/OsB57+kvjR/XAEOB
         tLww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eA/8hQB54WlZjOKPIMjrGkLKRLMbnQy2e6cQ2kB4jCU=;
        b=kAdkQ9+tvd2Gt84gExXALoi2wNhlnfok21aGj0SwgVowXpQfNN6zVK5mXn+i926eLf
         LqXXjHKqqXZEe+z/dutcPWomtcPDYtLTaCCWDgdjgdGOG52dbv5e0g1Y1kzeSOYNsKtK
         L1S1G5og16QreUR85Fm4TZAQQahHn0sUTXHwPSTuN9glNm5Y7EpBIGwL6+tiDg8SosO8
         lG0tvn09LwhkXppLCW28NbmOtKOU4xG4Dka2h/T93JJRiSkwtHnbOOD5Em85ZCNI+Lci
         0VuscMFhSDdTlNTvIBBLpaK2tf3aVqCcEBWSWTlD3k87u+WVjeG+7uOFtvzwLm60B8Bp
         8pnQ==
X-Gm-Message-State: AOAM53227UFSnSg3lLWhb9VeZo+uE2rpI6tXqMCM51vcEcz/ygZCXJnz
        5sEIOlmOJ7XLOopjQaVl2GXxlEDXLV/mzA==
X-Google-Smtp-Source: ABdhPJxBh4gjVLa+Z7lXoT+eujec28ASaX1vLU83ZveAkmMEGCze5mnf1kBcMVnPngRxYMMq0oT2eg==
X-Received: by 2002:a63:4d0e:: with SMTP id a14mr16143819pgb.112.1608575836122;
        Mon, 21 Dec 2020 10:37:16 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y6sm17683145pfn.145.2020.12.21.10.37.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 10:37:15 -0800 (PST)
Message-ID: <5fe0eb5b.1c69fb81.54c55.24de@mx.google.com>
Date:   Mon, 21 Dec 2020 10:37:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.248-21-g91c1ef779a3c
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 92 runs,
 8 regressions (v4.4.248-21-g91c1ef779a3c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 92 runs, 8 regressions (v4.4.248-21-g91c1ef77=
9a3c)

Regressions Summary
-------------------

platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
dove-cubox          | arm  | lab-pengutronix | gcc-8    | mvebu_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_i386-uefi      | i386 | lab-baylibre    | gcc-8    | i386_defconfig   =
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.248-21-g91c1ef779a3c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.248-21-g91c1ef779a3c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      91c1ef779a3cfea4611a949f3e67335e8b3ff555 =



Test Regressions
---------------- =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
dove-cubox          | arm  | lab-pengutronix | gcc-8    | mvebu_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe0bb1c24f8037b8dc94cbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: mvebu_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.248-2=
1-g91c1ef779a3c/arm/mvebu_v7_defconfig/gcc-8/lab-pengutronix/baseline-dove-=
cubox.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.248-2=
1-g91c1ef779a3c/arm/mvebu_v7_defconfig/gcc-8/lab-pengutronix/baseline-dove-=
cubox.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe0bb1c24f8037b8dc94=
cbe
        new failure (last pass: v4.4.248-21-ga3b412f9e7f5) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe0b6e0a7ff3e475ec94cce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.248-2=
1-g91c1ef779a3c/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.248-2=
1-g91c1ef779a3c/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe0b6e0a7ff3e475ec94=
ccf
        failing since 37 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe0b6d6fdcb8fe07ac94cbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.248-2=
1-g91c1ef779a3c/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.248-2=
1-g91c1ef779a3c/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe0b6d6fdcb8fe07ac94=
cbf
        failing since 37 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe0ba42f4797be08bc94ccf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.248-2=
1-g91c1ef779a3c/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.248-2=
1-g91c1ef779a3c/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe0ba42f4797be08bc94=
cd0
        failing since 37 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe0b6ffc54ff0d0f5c94cd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.248-2=
1-g91c1ef779a3c/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.248-2=
1-g91c1ef779a3c/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe0b6ffc54ff0d0f5c94=
cd4
        failing since 37 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe0b6f1c54ff0d0f5c94ccd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.248-2=
1-g91c1ef779a3c/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.248-2=
1-g91c1ef779a3c/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe0b6f1c54ff0d0f5c94=
cce
        failing since 37 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe0bab50e747bee6dc94ce2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.248-2=
1-g91c1ef779a3c/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.248-2=
1-g91c1ef779a3c/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe0bab50e747bee6dc94=
ce3
        failing since 37 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_i386-uefi      | i386 | lab-baylibre    | gcc-8    | i386_defconfig   =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe0b5057f0b8d53eac94cc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.248-2=
1-g91c1ef779a3c/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-u=
efi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.248-2=
1-g91c1ef779a3c/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-u=
efi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe0b5057f0b8d53eac94=
cc4
        failing since 1 day (last pass: v4.4.248-20-g064f72560703, first fa=
il: v4.4.248-21-ga3b412f9e7f5) =

 =20
