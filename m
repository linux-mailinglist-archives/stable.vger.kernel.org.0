Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA949373118
	for <lists+stable@lfdr.de>; Tue,  4 May 2021 21:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232667AbhEDT4V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 May 2021 15:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232637AbhEDT4V (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 May 2021 15:56:21 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02ED8C061761
        for <stable@vger.kernel.org>; Tue,  4 May 2021 12:55:26 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id n16so5824499plf.7
        for <stable@vger.kernel.org>; Tue, 04 May 2021 12:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NCdn0t9ZWweSTqZt9peFiTtmcMzA8fNm2VDWY2L5lF8=;
        b=Di4mhADPChy8YJnVXC+qmUxQwYE+THNt17hnzBxSWQSGnGr0jASVenn2Dq9DlXCV3A
         bV5tUmSqLyf3iIVMKJOYy2zOKtlhYXUqGAtXHv2+pnK0Mr7rL6DgB18gAsx5DwYjjIqZ
         hLNbancjBKfXenBzK/JU6XZs31ob9yCPN0zAMA4d78GSGqHdoKTSF+2lfqmVrUmK6Ley
         CW8LmBTgk0nJx68QIySiyLlsXZVoggjHRH3jG6RN53fqQEyE+dwZEh9bFnvuMJhboBwy
         vygbtcQ3PgTak/3moGWM1fkbgxauuexwadOH40LfN5yKEEytVr/wbfo23/TOxpT/1t2V
         BmoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NCdn0t9ZWweSTqZt9peFiTtmcMzA8fNm2VDWY2L5lF8=;
        b=MHdGKqJNhOtCtmPDG8reiXJp0FfimHwMOUGqzXEnovRYxopel4EmnyMeAzRHqgD0Xc
         jq5u+PhR/OV8KYewAkw+hAWzLSqp6XvdU2ord9SUOQiQ11ePu9pludctrE/e33OSilRK
         vH7wUUpaN6pIcCEJ00yb4N2nuKMsB2eNhTjYpqkg19FefsNoxLwAXMHf2mPi5oFrr8Wk
         vDhSGGbowqaFy3qBJqdBql03Yxg/K7gHeXABL/41mAo4OJmiImJLMgzqUOjmEPKlCqC6
         Po+MizLEuaeyNtGrk9WEPlwUyPyDHsKB9ZvuVfHcEzuwO6rPIiulKyXdO6YStai7oDLq
         dnzw==
X-Gm-Message-State: AOAM531M0ElGxOOj2YRvL/b0R62JddiPXCIxsNNZLvAwK2INiRmAQtlo
        eAyYaRU+EAdyOpvxqS4fXCRKXzB2HTZgOafr
X-Google-Smtp-Source: ABdhPJwYA8NrNGLcnPZnNumEZyzT5VSLMDUvUMdhqlwjDCL2ML3Jn2jwnykixifp7SrFCMaFRQ8tGA==
X-Received: by 2002:a17:902:9006:b029:ed:7f89:49d8 with SMTP id a6-20020a1709029006b02900ed7f8949d8mr27815924plp.52.1620158125359;
        Tue, 04 May 2021 12:55:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v185sm8383374pfb.190.2021.05.04.12.55.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 12:55:25 -0700 (PDT)
Message-ID: <6091a6ad.1c69fb81.2ba6b.5a4b@mx.google.com>
Date:   Tue, 04 May 2021 12:55:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.189-7-ge7f760cab9781
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 88 runs,
 4 regressions (v4.19.189-7-ge7f760cab9781)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 88 runs, 4 regressions (v4.19.189-7-ge7f760c=
ab9781)

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

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.189-7-ge7f760cab9781/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.189-7-ge7f760cab9781
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e7f760cab978171e72d713015dd264cbd2b071de =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60916c74beeba25d53843f25

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-7-ge7f760cab9781/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-7-ge7f760cab9781/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60916c74beeba25d53843=
f26
        failing since 171 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60916c7e09c1dd9d38843f23

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-7-ge7f760cab9781/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-7-ge7f760cab9781/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60916c7e09c1dd9d38843=
f24
        failing since 171 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60916c6fd71a086b0b843f24

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-7-ge7f760cab9781/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-7-ge7f760cab9781/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60916c6fd71a086b0b843=
f25
        failing since 171 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60916c26490939afdf843f2b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-7-ge7f760cab9781/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-7-ge7f760cab9781/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60916c26490939afdf843=
f2c
        failing since 171 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
