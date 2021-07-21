Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 061133D06A4
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 04:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbhGUBct (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 21:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbhGUBcs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Jul 2021 21:32:48 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5296EC061574
        for <stable@vger.kernel.org>; Tue, 20 Jul 2021 19:13:25 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id j199so1071033pfd.7
        for <stable@vger.kernel.org>; Tue, 20 Jul 2021 19:13:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=P/eV/PB1gx3upQXdLg7diUh3J4qVDhjG6JitQJijMTc=;
        b=sCVAl/krn2bXPEVUczbHa5N04eqm266tHUQP+klG+uiO5d1rVKZ+HfFXl4NcUV8N+5
         pH5JQ7IFOn7zgy7Vf/dRwp5dtEPkgQzDXgeOf5kMF45fXYmaOJ7ivtaYhcNbEwaH9rLB
         H2OABjcCGGpFH8uVskqDcRf+NTIY8MHcy0XtYUtbenhkwBH1duhfoHViARO0/+lvFEQi
         rmzrQJO+a/eBdcJvqXQKDOzJBaWFeeU0wjP2eB5adzXeOsNVR8tAOBTDfge/GPkfHvWM
         HwAFhdpcVnB10Llve6C5c8c6SnSJEWj95qRMEr5TYQDX/b4shtQPGKnb4rRdJYk/Wy3C
         vuMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=P/eV/PB1gx3upQXdLg7diUh3J4qVDhjG6JitQJijMTc=;
        b=ib0xuLTmYvLhBasZHPOPa1INSlMML2WkZ7K6doxnFhq7Y/1XOTfe+/DbK1PstDcRV8
         f2DSJSilKr3Jdk7mf823nFQ8dIqv50PEWfiEC5MAs30UlaISxjIE3aL2Z+Bg1LzULcEk
         gQVSrjjvqgj5jNC2cOGgqNIx94OweWLrs4hoXzgMoGgtlwOF+xSs1Ep7kERkNsxUZiy0
         XDjfSdrguwzUupm+2n2gRTzX8wVgbo54vlkWmBlc4Zc20PA58ryH0hWF7BEgJ1GcRIdJ
         sacmGf76WOMlRw9oAtUJ7G6UC2L5wEczaC8++308deBSMrYi1a5MfHuFqYbMGR6XM2XX
         20XQ==
X-Gm-Message-State: AOAM530YCKldBIoNO38f8a1GOukjB2YcsKmSLug1b8YGCIll7dzXH14u
        VvofGBDt82ab2filXhHkQLfi4BC4A9fFe4bx
X-Google-Smtp-Source: ABdhPJxJZ8ojsP75R6H5k/nhqmFj4IHSSjnuqG/bPmUTbQPocliH6YQGZeoA7ywX4IoQQWEZ4X6QAQ==
X-Received: by 2002:aa7:804f:0:b029:334:4951:da88 with SMTP id y15-20020aa7804f0000b02903344951da88mr28114784pfm.29.1626833604728;
        Tue, 20 Jul 2021 19:13:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h19sm22980803pfo.161.2021.07.20.19.13.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 19:13:24 -0700 (PDT)
Message-ID: <60f782c4.1c69fb81.bdb5.55a9@mx.google.com>
Date:   Tue, 20 Jul 2021 19:13:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.13.y
X-Kernelci-Kernel: v5.13.3-349-g1d9dba03aebe5
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.13.y baseline: 143 runs,
 4 regressions (v5.13.3-349-g1d9dba03aebe5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.13.y baseline: 143 runs, 4 regressions (v5.13.3-349-g1d9d=
ba03aebe5)

Regressions Summary
-------------------

platform  | arch   | lab          | compiler | defconfig                   =
 | regressions
----------+--------+--------------+----------+-----------------------------=
-+------------
beagle-xm | arm    | lab-baylibre | gcc-8    | multi_v7_defconfig          =
 | 1          =

beagle-xm | arm    | lab-baylibre | gcc-8    | omap2plus_defconfig         =
 | 1          =

d2500cc   | x86_64 | lab-clabbe   | gcc-8    | x86_64_defconfig            =
 | 1          =

d2500cc   | x86_64 | lab-clabbe   | gcc-8    | x86_64_defcon...6-chromebook=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.13.y/ker=
nel/v5.13.3-349-g1d9dba03aebe5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.13.y
  Describe: v5.13.3-349-g1d9dba03aebe5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1d9dba03aebe5171ad487d3ec69485c6cd17544a =



Test Regressions
---------------- =



platform  | arch   | lab          | compiler | defconfig                   =
 | regressions
----------+--------+--------------+----------+-----------------------------=
-+------------
beagle-xm | arm    | lab-baylibre | gcc-8    | multi_v7_defconfig          =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60f74b1434b63d4b4c85c258

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.3=
-349-g1d9dba03aebe5/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.3=
-349-g1d9dba03aebe5/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f74b1434b63d4b4c85c=
259
        new failure (last pass: v5.13.3-350-g6c45a6a40ddee) =

 =



platform  | arch   | lab          | compiler | defconfig                   =
 | regressions
----------+--------+--------------+----------+-----------------------------=
-+------------
beagle-xm | arm    | lab-baylibre | gcc-8    | omap2plus_defconfig         =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60f74e705cf8dc3dc485c275

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.3=
-349-g1d9dba03aebe5/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.3=
-349-g1d9dba03aebe5/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f74e705cf8dc3dc485c=
276
        failing since 5 days (last pass: v5.13.2, first fail: v5.13.2-254-g=
761e4411c50e) =

 =



platform  | arch   | lab          | compiler | defconfig                   =
 | regressions
----------+--------+--------------+----------+-----------------------------=
-+------------
d2500cc   | x86_64 | lab-clabbe   | gcc-8    | x86_64_defconfig            =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60f7485fcb965da2ef85c27f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.3=
-349-g1d9dba03aebe5/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500=
cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.3=
-349-g1d9dba03aebe5/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500=
cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f7485fcb965da2ef85c=
280
        failing since 9 days (last pass: v5.13.1, first fail: v5.13.1-783-g=
664307fdb480) =

 =



platform  | arch   | lab          | compiler | defconfig                   =
 | regressions
----------+--------+--------------+----------+-----------------------------=
-+------------
d2500cc   | x86_64 | lab-clabbe   | gcc-8    | x86_64_defcon...6-chromebook=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60f74a0300ce62ad0185c263

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.3=
-349-g1d9dba03aebe5/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe=
/baseline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.3=
-349-g1d9dba03aebe5/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe=
/baseline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f74a0300ce62ad0185c=
264
        failing since 9 days (last pass: v5.13.1, first fail: v5.13.1-783-g=
664307fdb480) =

 =20
