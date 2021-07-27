Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65FF13D6D78
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 06:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234797AbhG0Ecd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 00:32:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233496AbhG0Ecc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 00:32:32 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C7BC061757
        for <stable@vger.kernel.org>; Mon, 26 Jul 2021 21:32:32 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id b1-20020a17090a8001b029017700de3903so1889207pjn.1
        for <stable@vger.kernel.org>; Mon, 26 Jul 2021 21:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cHnPe6flBRlf7SS5xKOsnxzbCU1OP8OD8ge/bPYff7U=;
        b=mMRGD7bdPvKrmLdwHiyt3ISUeTRCqQnot0u4cR+j17A1RbUWBoYiV9FhCWBk/ypSZo
         NfODzjU5GogmZEAFFUjvld1KhHOvVMbFPVGnBEUlB/r6p56tcGjXfiwr84JiXomL4MY1
         vUvaLQL0G2wAM/3g5kOO+ZcsT5phfcryUqVscyrhzLv8ywtdP5LuLSgoHZwAHgwXXg2G
         viLJehfSb+pqWFaFwqZ/iAXQATtfJKjaE2XW8fbw9n0JtPj0AK1BmwkYwIF8jZNqqLbV
         cOfvKb56ilQRckWxrhg+x63+MkE21s6fC8fEOG0zmfA6YOS8BhDA6vvAX7rodl+eig7d
         U8yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cHnPe6flBRlf7SS5xKOsnxzbCU1OP8OD8ge/bPYff7U=;
        b=hKfywAjPVqjRAtvg2tUeXxNZnG8u7K6bl7jNsv9SZ6eyw8ToOozOh2fI1ATSgy/67I
         XC/znoARWFGdMHfvOrzBpeNphLzglLV9aM5I8oa7usVxqmKjXISrtIViM8Mxdo2z1s/O
         hzA4Z/14odflIPDGIbvZD6eEU26cibPlWtSwLrKl18PmWVb+5TZ30Xr8J2U5w4NKIJFT
         a6+vssMMqf2XADkY7ezwKTm+LG+eOjlECTZB/EPIW5yVex2DMwigY3NVgbsEUlyq4IVe
         CwQbCuTpgm0r5SHIZSrTNEN+EHQFENJUth6OpaEW5vLoPValEPDknhFUd52QH75UVTcz
         09hQ==
X-Gm-Message-State: AOAM532UmxujQg+L67cSpyrhhv6VLTgtr6enTat59Tb17aJwIM8ImHGm
        YWdnefORK1EJo7B8ybTCLbiYh7KRDWlC6PYz
X-Google-Smtp-Source: ABdhPJzDdf9HWevw5nGl9X60AOm+xjdh2gxyFURfxR7/Xc8kuMMOLbG91gWWL9Zq8jubssC9HDFfqw==
X-Received: by 2002:a63:4e04:: with SMTP id c4mr21389765pgb.294.1627360352174;
        Mon, 26 Jul 2021 21:32:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 19sm1700880pgg.36.2021.07.26.21.32.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 21:32:31 -0700 (PDT)
Message-ID: <60ff8c5f.1c69fb81.68f8f.7459@mx.google.com>
Date:   Mon, 26 Jul 2021 21:32:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.240-83-g1e359c9ebe19
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 145 runs,
 5 regressions (v4.14.240-83-g1e359c9ebe19)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 145 runs, 5 regressions (v4.14.240-83-g1e3=
59c9ebe19)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.240-83-g1e359c9ebe19/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.240-83-g1e359c9ebe19
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1e359c9ebe19fe0834c30a3a7a7c4c6f17a9a2d7 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60ff5a938abef60e2f3a2f2a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
40-83-g1e359c9ebe19/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
40-83-g1e359c9ebe19/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ff5a938abef60e2f3a2=
f2b
        failing since 482 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ff53abf7d0afe7d93a2f29

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
40-83-g1e359c9ebe19/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
40-83-g1e359c9ebe19/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ff53abf7d0afe7d93a2=
f2a
        failing since 254 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ff6c61c0cbc827dd3a2f22

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
40-83-g1e359c9ebe19/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
40-83-g1e359c9ebe19/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ff6c61c0cbc827dd3a2=
f23
        failing since 254 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ff53a2f7d0afe7d93a2f22

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
40-83-g1e359c9ebe19/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
40-83-g1e359c9ebe19/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ff53a2f7d0afe7d93a2=
f23
        failing since 254 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ff534317d4754c963a2f34

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
40-83-g1e359c9ebe19/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
40-83-g1e359c9ebe19/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ff534417d4754c963a2=
f35
        failing since 254 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =20
