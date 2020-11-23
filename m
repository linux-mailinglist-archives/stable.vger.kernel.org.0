Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0C92BFDC3
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 01:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbgKWAm5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Nov 2020 19:42:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbgKWAm5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Nov 2020 19:42:57 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 807DAC0613CF
        for <stable@vger.kernel.org>; Sun, 22 Nov 2020 16:42:56 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id w4so12634938pgg.13
        for <stable@vger.kernel.org>; Sun, 22 Nov 2020 16:42:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ORkm4r+96D7XIWOsxzr2ioKnNOVWJAMxHatswx09NCE=;
        b=UXrOowJZtpw2yMmvauMWcxeGPjugHCAfBpIy+a2S9QZsnusdmsYhwo1BhxK4GRj0oQ
         LpWRF+GzSjk/pWKBxpWjYgg9Jbi9ST4nwfVZIrSVgmk+QbPdEIBmYT0HEHUeQnhbXYM/
         h1kO2kmXGhAFhi2S5ptpmqaWOmTPBFdLv2JEbDlS9MA3icoLK1lOL8JNoPK6MGyLpSbo
         Hvemj+jUy5WNQaoPMbMlOgb0hu4lzTYX8qNy1Nn8Eak6ZjjUZtdZg8TugGiWFVt8I8zB
         XiycZ7qp+BQ/MItnvgiFYg/M3+Bzk83GSY6jDXmaYb4HB3LUOENCXouyZJm90W4mE76Y
         Pcfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ORkm4r+96D7XIWOsxzr2ioKnNOVWJAMxHatswx09NCE=;
        b=gnajM1XDzuEB8BQ8SSlkEuphUY9vm/UDEuwuI/S2lNqVmHPFjjow0beHuA46j+/TMe
         qjRb4r7opzLarFD1W4+wjJg0ykTh3MPY40RcKpXb+LoXkmdvi52u5idlSD9x3QOGboYt
         gsx75iTjooPwySzJh9Tbzj3hUlXA6IRyW+dqivdQjZypITQcLo1oF/dtO/WC6Mqqzh2o
         dWPXIq8qa3jrCdG7bJeDrBnq4+LIrGXsswW5Ms4rCS1CtwqhlHC9L3vQDqqfVFhaSxF5
         FdRCx7cbUY6CMTXPAadg5o3McpQr3q2QUAuOBziyn3PFVDZ6pSWI1zNCvzETrj3dS4pT
         1+BQ==
X-Gm-Message-State: AOAM5315xfNbYDHk0HwobX4IaB9Y+utTPutR3T1sy6wcj162vAPT71OU
        KEfm6IcMeKZjNQYhGNLWqkiEYOVVUU1NGw==
X-Google-Smtp-Source: ABdhPJzezbQ+OzI9fPbK21cg9L6r9pdp1vcPq2SvnIwbFxXrJ76DDLa+mBy6g8lgVrFKWTPLnFHOWw==
X-Received: by 2002:a62:e416:0:b029:197:eed6:c8b9 with SMTP id r22-20020a62e4160000b0290197eed6c8b9mr6636052pfh.57.1606092175546;
        Sun, 22 Nov 2020 16:42:55 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z128sm8972573pgz.69.2020.11.22.16.42.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2020 16:42:54 -0800 (PST)
Message-ID: <5fbb058e.1c69fb81.5f74c.350b@mx.google.com>
Date:   Sun, 22 Nov 2020 16:42:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.208-23-g2be7299a7fe0
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 126 runs,
 6 regressions (v4.14.208-23-g2be7299a7fe0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 126 runs, 6 regressions (v4.14.208-23-g2be72=
99a7fe0)

Regressions Summary
-------------------

platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =

qemu_i386            | i386   | lab-baylibre    | gcc-8    | i386_defconfig=
      | 1          =

qemu_x86_64          | x86_64 | lab-baylibre    | gcc-8    | x86_64_defconf=
ig    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.208-23-g2be7299a7fe0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.208-23-g2be7299a7fe0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2be7299a7fe01d6568fdf7bb5b041f9ac5cec8ac =



Test Regressions
---------------- =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbad0a81bd58df30dd8d928

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-23-g2be7299a7fe0/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-23-g2be7299a7fe0/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbad0a81bd58df30dd8d=
929
        failing since 9 days (last pass: v4.14.206-21-g787a7a3ca16c, first =
fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbad0aa58729ee97cd8d914

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-23-g2be7299a7fe0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-23-g2be7299a7fe0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbad0aa58729ee97cd8d=
915
        failing since 9 days (last pass: v4.14.206-21-g787a7a3ca16c, first =
fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbad0d92d7bce5128d8d92d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-23-g2be7299a7fe0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-23-g2be7299a7fe0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbad0d92d7bce5128d8d=
92e
        failing since 9 days (last pass: v4.14.206-21-g787a7a3ca16c, first =
fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbad0632647a86c99d8d917

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-23-g2be7299a7fe0/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-23-g2be7299a7fe0/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbad0632647a86c99d8d=
918
        failing since 9 days (last pass: v4.14.206-21-g787a7a3ca16c, first =
fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_i386            | i386   | lab-baylibre    | gcc-8    | i386_defconfig=
      | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbad113775c5623cfd8d937

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-23-g2be7299a7fe0/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-23-g2be7299a7fe0/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbad113775c5623cfd8d=
938
        new failure (last pass: v4.14.208-20-gcbb1be1f4dc6) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_x86_64          | x86_64 | lab-baylibre    | gcc-8    | x86_64_defconf=
ig    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbad1c73a65e9f490d8d920

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-23-g2be7299a7fe0/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-23-g2be7299a7fe0/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbad1c73a65e9f490d8d=
921
        new failure (last pass: v4.14.208-20-gcbb1be1f4dc6) =

 =20
