Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 459482DF112
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 19:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726028AbgLSSfJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 13:35:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbgLSSfI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Dec 2020 13:35:08 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC1E7C0613CF
        for <stable@vger.kernel.org>; Sat, 19 Dec 2020 10:34:26 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id v1so3209019pjr.2
        for <stable@vger.kernel.org>; Sat, 19 Dec 2020 10:34:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UXMoYEB9S51EkijNU1igJLwtE9o0zwUuR79giY3SGFA=;
        b=hoO6PSiynlHMhEz5Mqf7jNfV9L5Tnwvm2UQ6Y+w9mJBR++Qj6ISmKbxiYQPoQWk1mH
         7hWw1yYzMoSxcwt4TjzcZYo2zNwzZz5fdJh6VYCq7a4Mh+3/60egsJ78Jn7tPjf6owE8
         QpqUzEmX/o/LTX117dKBrV2zjsHb8SkZLsrPDSu0EZXbP/RT6rF1heapT5DUEfyIacmz
         vUNNraCj8OxnzCfDZjYKKoHrC2xOR3omdVGetbiwcivMd+YcMParI1TLksDemMU/AN4x
         hF6waB4cqqh8BRi2nXtfcKlMDMWwg0H9DvzaqJhqsSnfU4yVumQlBCuM5FRaMEsf/72y
         TewQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UXMoYEB9S51EkijNU1igJLwtE9o0zwUuR79giY3SGFA=;
        b=eA0kzE8XDZMLdL1BwNXuLi1XdDOkk0FcK9O2R4MUnnaERyT4TNn9qfPsZn0Jo7abrl
         4gPm2UNLl6tdkQNYmdxhamC4orXf6h3UUcScyHl3lswJPB3X2MI0GsH1rk+qXdK797fc
         +ouB2B3j/LmQ/5B/ZzpPRJZmZl2SowkXWKVBb2XNzV700NiXAYihmFp7/Ht2rQznqhyK
         VY08dyUfn8XCnbpu+zLEO/j2cNDJyh9ebfktCp+tDXxJB7gUfkU/jaDipU4HmGLxePnd
         Tion1BZBsMH5mwum2jNnjVQHoSMSqqkF6LBl4n1Nsz6pE5ms4XORn9MYDCyBzqif32e9
         86yg==
X-Gm-Message-State: AOAM533cUhDx2zbEHzEgfgdnFT9BIC+WSN1eV6W33iXZjlhsZ6hQa/Lt
        JYrG77vvlaZThGONww+guriFs4NPbnYdnw==
X-Google-Smtp-Source: ABdhPJxNfxIlIrLID4aMwMir6X0ulLIDgSzoXq687RcyyjvvaG+a8rxNB+3JvVIiU14mW3x/bG+kYA==
X-Received: by 2002:a17:90a:9e5:: with SMTP id 92mr10125337pjo.176.1608402865834;
        Sat, 19 Dec 2020 10:34:25 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o7sm13029490pfp.144.2020.12.19.10.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Dec 2020 10:34:25 -0800 (PST)
Message-ID: <5fde47b1.1c69fb81.bb58e.4582@mx.google.com>
Date:   Sat, 19 Dec 2020 10:34:25 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.83-72-gbcf35e05a5263
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.4.y baseline: 132 runs,
 4 regressions (v5.4.83-72-gbcf35e05a5263)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 132 runs, 4 regressions (v5.4.83-72-gbcf35e=
05a5263)

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

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.83-72-gbcf35e05a5263/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.83-72-gbcf35e05a5263
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bcf35e05a52636bd982a253c1ed928d3b128a332 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fde14f6d7c941e5a5c94cc1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.83-=
72-gbcf35e05a5263/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.83-=
72-gbcf35e05a5263/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fde14f6d7c941e5a5c94=
cc2
        failing since 29 days (last pass: v5.4.77-152-ga3746663c3479, first=
 fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fde142dfab04833d2c94d1e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.83-=
72-gbcf35e05a5263/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.83-=
72-gbcf35e05a5263/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fde142dfab04833d2c94=
d1f
        failing since 34 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fde1436f2734bc8bfc94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.83-=
72-gbcf35e05a5263/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.83-=
72-gbcf35e05a5263/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fde1436f2734bc8bfc94=
cba
        failing since 34 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fde1405e7eeeade35c94cc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.83-=
72-gbcf35e05a5263/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.83-=
72-gbcf35e05a5263/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fde1405e7eeeade35c94=
cc3
        failing since 34 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =20
