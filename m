Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27D7B3E3BE8
	for <lists+stable@lfdr.de>; Sun,  8 Aug 2021 19:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbhHHRYQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Aug 2021 13:24:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231199AbhHHRYP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Aug 2021 13:24:15 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26D2C061760
        for <stable@vger.kernel.org>; Sun,  8 Aug 2021 10:23:55 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id mt6so24291858pjb.1
        for <stable@vger.kernel.org>; Sun, 08 Aug 2021 10:23:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/kUQMi42w2DnRXdb7kr/PC/y/7rjEmDaEtqFN0AQbdY=;
        b=wp1RZIXS8hUBaLbRKYQkwFAXdeMTabf/8r7fQcruHuXzw5G6MeGJ+4XVhuAJheGmJi
         xl/rnG97J5mzB3nz+bG/0DF38NwhKnbmFHOieA7+Wou1vyTy5P/u0uWaxE9BoC7kqMuv
         irPGVkC3EjYjRmM5lO5tVKIMY1MtHsJB9H5WmeJKA3zePHnXKcFjrfUOU8vH35BidNA6
         eimh+EWTBdtOBnwn6G48gR8US6wE/xXz8fgyENUHKZDpYt31+9cank/07e2HTU0DQQtB
         fFQWzXrt1tlEb/Sxmpc0FkHImCfHE4cC34V/M8BZM1/F6UnGKRcjuMH4kU4/5sNAA4qp
         7r+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/kUQMi42w2DnRXdb7kr/PC/y/7rjEmDaEtqFN0AQbdY=;
        b=PYKpaFrl5P304oKjyPFTX1vLRyB0HOQtMSZPY3cInI5x/nCWTxLOWFs7puAMDs3Q28
         k8FI9K0FnyVmD6F0pp2coFQqkkQf0j2ZOKrs5x2Kg1YhRdbfBmgDoCC5lY2Td5USlWH6
         WPbHb7MpBea3pJJ4pR2XSPYybrU6Q96TLhBc1nNcmZ5fHj0xiOM36SUido7npLe9wBOw
         /rie/NVZSz++vO6FM9dKtH77675O77A6cpWYJ6ciWTCUpxAgXTbcXxc5bEiq6LAi50Y9
         F/E2wFL+EAhgnL3NS8siezzf1sO1kP82n+D2QOIFpCz758ig/kqoUiNQ9RaP2EYH0+j3
         0hzg==
X-Gm-Message-State: AOAM533iRmxVcEklUpvC58ZFoYg+TPROsFptWnDxVZuPeHkiQgsQzc3I
        Wqby0TZ/VkL5Fh0hC4tctw+7VXXnYjUfhWe4
X-Google-Smtp-Source: ABdhPJyvnNidqJWgDdVu2iRfhwc4DHPwTU/Su/whYsbr1irVj8cIGc4EE08ZQGXcOaaO2j8wW9h4fw==
X-Received: by 2002:a17:902:bd43:b029:12c:def4:588e with SMTP id b3-20020a170902bd43b029012cdef4588emr411824plx.25.1628443435125;
        Sun, 08 Aug 2021 10:23:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id fu10sm5282488pjb.8.2021.08.08.10.23.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Aug 2021 10:23:54 -0700 (PDT)
Message-ID: <6110132a.1c69fb81.28b64.e595@mx.google.com>
Date:   Sun, 08 Aug 2021 10:23:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.14.243
X-Kernelci-Report-Type: test
Subject: stable/linux-4.14.y baseline: 104 runs, 5 regressions (v4.14.243)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 104 runs, 5 regressions (v4.14.243)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
fsl-ls2088a-rdb      | arm64 | lab-nxp         | gcc-8    | defconfig      =
     | 1          =

meson-gxbb-p200      | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.243/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.243
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      46914f96189be290174e378c6bf9ccadfdb9ca1e =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
fsl-ls2088a-rdb      | arm64 | lab-nxp         | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/610ff3c547db6b629bb136a4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.243/=
arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.243/=
arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610ff3c547db6b629bb13=
6a5
        new failure (last pass: v4.14.241) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
meson-gxbb-p200      | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/610fddb065cd4b64b7b1366c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.243/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.243/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610fddb065cd4b64b7b13=
66d
        failing since 492 days (last pass: v4.14.172, first fail: v4.14.175=
) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/610fd99922e05d312fb13671

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.243/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.243/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610fd99922e05d312fb13=
672
        failing since 262 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61100416ccdfc5387ab1368f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.243/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.243/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61100416ccdfc5387ab13=
690
        failing since 262 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/610fedf7772374719cb1368a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.243/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.243/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610fedf7772374719cb13=
68b
        failing since 262 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =20
