Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9A03979C4
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 20:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234637AbhFASKR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 14:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234675AbhFASKP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 14:10:15 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F450C06174A
        for <stable@vger.kernel.org>; Tue,  1 Jun 2021 11:08:32 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id x18so111184pfi.9
        for <stable@vger.kernel.org>; Tue, 01 Jun 2021 11:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=i2u2TVliPNnM2mpR3QPztFbNJdChqf/702UDfLxlfn0=;
        b=anyJNxl7eib20yqI2kuvkICL7gAdzbfru2o15R8pZd7NxFglEI6p+2jW+r5Po47XYg
         8juaVUF+oTKFNaUxnrXV6PYW3pCeYTmtl4XcWK5du3L3rAmhAUBOtgPzK2yk8JkEyDMJ
         4NTeRTpRc49nStg65elBORX8L4n/0DuUWgL8ihT27/+BqXd091zYVdO85rhsN5W9pEyO
         JTVuHYJf5BoQ60b9/6YJ4wD4TI1Lka9fZqG/FhnwICT/OWAuhUZwdyRtNayXexCRHURx
         D+18mnJPA1P/5SRLlPsfaJsbFQnwuZmclt8MKc2qOypLPS5zHOQcozSclECECaSi/7B8
         mIxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=i2u2TVliPNnM2mpR3QPztFbNJdChqf/702UDfLxlfn0=;
        b=iejl2uhcBawWXdjMp6rhUArbbe3TOk5nMKXoGl+lE/u/PvmEJD/MMSRIYIi+6r9VWn
         TuP63Eb+WUuWu9+GgX+30LU/Usz4F6fudpbJ1RPNIjNP4LfV5rkx+QJxCSmBdVzyUBc8
         4YRsQMMm3/Gk1WEa0hF1FFQ7MuVxfeGxR1L+0NXQij4N0vj3IJL/gwJJDeuq/vok3Z+7
         X+tO8gA4rcTh2u6bOJeJUfWgmufQ30Sxl3Qzo9e1+oKMuTwdFbRY5+F7LDqKoJpkDNJr
         E095M66eL754DruLvR0Qsf1+oS/0N+AFClG6Ts6/uQt6tNWjMVfpP8fl7rLaQ0RqeM5g
         uyvA==
X-Gm-Message-State: AOAM532KLPiduWI8/CrrU6aIrb2AIoH0PZaNAQAn46h1rWR/lRuukKiJ
        W3zZwlQaA+jjiAodFLxWVUEONs12d81oWeRA
X-Google-Smtp-Source: ABdhPJxgAev2a0ccEFqsEJYQ59MjzLmlOir2b2txZEp0XGXKW2TVkKtO4tvk0QocxjzxB1kj4J8/EQ==
X-Received: by 2002:a63:5522:: with SMTP id j34mr16774494pgb.148.1622570911523;
        Tue, 01 Jun 2021 11:08:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i5sm9342367pfc.139.2021.06.01.11.08.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 11:08:31 -0700 (PDT)
Message-ID: <60b6779f.1c69fb81.3e144.c304@mx.google.com>
Date:   Tue, 01 Jun 2021 11:08:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.234-84-g5435e59b434c
X-Kernelci-Branch: queue/4.14
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 157 runs,
 4 regressions (v4.14.234-84-g5435e59b434c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 157 runs, 4 regressions (v4.14.234-84-g5435e=
59b434c)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
fsl-ls2088a-rdb   | arm64 | lab-nxp       | gcc-8    | defconfig          |=
 1          =

meson-gxm-q200    | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =

qemu_i386         | i386  | lab-broonie   | gcc-8    | i386_defconfig     |=
 1          =

tegra124-nyan-big | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.234-84-g5435e59b434c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.234-84-g5435e59b434c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5435e59b434cd77e9e587ac2b68f2751e3fa1fd1 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
fsl-ls2088a-rdb   | arm64 | lab-nxp       | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60b63d1c21871bd83bb3af98

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.234=
-84-g5435e59b434c/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.234=
-84-g5435e59b434c/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b63d1c21871bd83bb3a=
f99
        new failure (last pass: v4.14.234-78-g1558b596dfa2) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
meson-gxm-q200    | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60b63ec700cdfdf087b3afad

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.234=
-84-g5435e59b434c/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.234=
-84-g5435e59b434c/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b63ec700cdfdf087b3a=
fae
        failing since 92 days (last pass: v4.14.222-11-g13b8482a0f700, firs=
t fail: v4.14.222-120-gdc8887cba23e) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
qemu_i386         | i386  | lab-broonie   | gcc-8    | i386_defconfig     |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60b63c02355003184fb3af97

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.234=
-84-g5435e59b434c/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.234=
-84-g5435e59b434c/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b63c02355003184fb3a=
f98
        new failure (last pass: v4.14.234-78-gbf651a64dd24) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
tegra124-nyan-big | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60b657cfa4ad1008ebb3affa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.234=
-84-g5435e59b434c/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-tegra=
124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.234=
-84-g5435e59b434c/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-tegra=
124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b657cfa4ad1008ebb3a=
ffb
        new failure (last pass: v4.14.234-79-g1cf75ca15187) =

 =20
