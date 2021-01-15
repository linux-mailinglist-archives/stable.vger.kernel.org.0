Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B347E2F7E6C
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 15:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729056AbhAOOnB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 09:43:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725910AbhAOOnB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 09:43:01 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED51C061757
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 06:42:21 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id p18so6103280pgm.11
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 06:42:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=A+Huc8vEOtTqE1272smhcSGKeidTtXZ56Ik56JmM9IQ=;
        b=KtDx8DPwcTOM6AXG61jQUqSSPpNc/E3WZSnvQ95SMdE6B3ob7ZXySdKfc8sXySLfs0
         dk+sZG/1oBlyg9UtREQaQhpGv3jLlYTedqvXdPoIA2zs/fzmp/HJMSaYs5coGLaG1StB
         ZLkYRUYYuNVs5rBhsMXjw/bXsutXWjSRizplbHFw/hWpmFZ27/kjmZ5MozTIxRf+9BbD
         M6TKUEDYhBd+DF+5BOSyOmjye/Z8K1eotj/dQ3TZuZX45w6YhwHuUycxZU9/7KKGHMFN
         wwnFNawsp0n02r0Mjce0PaejYfvclhNB4ricBeQUiWqPJ38BGRj1u2QubWahhz8s8Sh1
         0OrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=A+Huc8vEOtTqE1272smhcSGKeidTtXZ56Ik56JmM9IQ=;
        b=U18E0wecS5z9BQrZe5qhujiXSCFBKRDaMhUVpBrrjo1w1xflt22xTEDI0BkV6rDNpj
         UK0UeJZmXlnsjx462atZmTlNH/gVwpMC6ieLQWNs8VpGDEYNEzL9v9BdJGvT0zuOFDbF
         ctw6WeUtwy2CXcIwriDVgG+TaGcNms5a+y1h1PADd+bIAFScxDkYpoVqP707Bur6hUmR
         K46d/Ba/PQTLVpnO4H8zAoxYVbhqwCOrM94UgterGB+0uUpFSqE9fLpQH2m8M1Ri8mUU
         J/leEY5gy6A/FP4AFKO/vu+8EpI6jh4mjbBzgrtDzvFL6beEu/x6LWhlyhAp+fIOf596
         Hr7w==
X-Gm-Message-State: AOAM530Ubrs4wjOGTAnshl8QEFRtK3+eIixiOMDsMl3QYzzjTfJJHASA
        21aQruzk7YJdFwoOuxjYiRQZ6RWGik/p2w==
X-Google-Smtp-Source: ABdhPJwwFQyEqWt3A+JOk/RCid2/p7OAaYu1t1mu4LB5mUNEX+kI9La9AB6LubkhKjL/92Q233N7kQ==
X-Received: by 2002:a63:f19:: with SMTP id e25mr12871718pgl.220.1610721740251;
        Fri, 15 Jan 2021 06:42:20 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 21sm8403911pfx.84.2021.01.15.06.42.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 06:42:19 -0800 (PST)
Message-ID: <6001a9cb.1c69fb81.5f34d.50df@mx.google.com>
Date:   Fri, 15 Jan 2021 06:42:19 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.89-32-g249e36280d300
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 160 runs,
 5 regressions (v5.4.89-32-g249e36280d300)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 160 runs, 5 regressions (v5.4.89-32-g249e3628=
0d300)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.89-32-g249e36280d300/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.89-32-g249e36280d300
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      249e36280d3002a7c3e2b68c4de775f67492338e =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60017408547e92aa9cc94cc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.89-32=
-g249e36280d300/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashe=
d-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.89-32=
-g249e36280d300/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashe=
d-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60017408547e92aa9cc94=
cc9
        failing since 56 days (last pass: v5.4.78-5-g843222460ebea, first f=
ail: v5.4.78-13-g81acf0f7c6ec) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6001759c103fdb3fc2c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.89-32=
-g249e36280d300/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.89-32=
-g249e36280d300/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6001759c103fdb3fc2c94=
cba
        failing since 62 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/600173eb6de3969ba9c94cd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.89-32=
-g249e36280d300/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.89-32=
-g249e36280d300/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600173eb6de3969ba9c94=
cd2
        failing since 62 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/600173f1d6a9c4bd51c94cd5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.89-32=
-g249e36280d300/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.89-32=
-g249e36280d300/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600173f1d6a9c4bd51c94=
cd6
        failing since 62 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60019226cee039e6d8c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.89-32=
-g249e36280d300/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.89-32=
-g249e36280d300/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60019226cee039e6d8c94=
cba
        failing since 62 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =20
