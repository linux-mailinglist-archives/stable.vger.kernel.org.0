Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3AE436D9D3
	for <lists+stable@lfdr.de>; Wed, 28 Apr 2021 16:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239047AbhD1Ouh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Apr 2021 10:50:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237717AbhD1Ouh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Apr 2021 10:50:37 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 761FDC061573
        for <stable@vger.kernel.org>; Wed, 28 Apr 2021 07:49:52 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id p17so7057321plf.12
        for <stable@vger.kernel.org>; Wed, 28 Apr 2021 07:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=diJDRMkTVRxKJ367GAU7edaTpElpSfilL06ie9iRFEs=;
        b=nxXXnwDBq95YiSaJ8faQAu2tm9xq4gJSQ/cujqNvifk7DP5T6sNp1+7PpdSV/t+MeI
         VJr5NvvO+YVYyfH+8LU3rSQZV4ELq7urhGwmHmm0XWXFTT5QL2ej749ryMdJ6/ItsQbt
         MuVnAP1MM1h8Ao6YaVKgT0riPDTFb4fzi9x8EeJAcekAJGVFv3CcdKNklACQHyS2i3hk
         cERN2sbm13hAHxIPkiRCiTjFfJM5kD6h0vBHVe+I01a8fUwTRdLtljhZaog3AQJK2nDC
         raHlhhL/uu6FaYwen8kfUdgrCWVQoXnKSngTbbz6dSBWFNSES7AVqxaF2dTQWZ1egtp0
         89NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=diJDRMkTVRxKJ367GAU7edaTpElpSfilL06ie9iRFEs=;
        b=U8XoDxq/6lpUDXOZzYHc9KxzYYRj3hdrHMrt6dmnQbSn+MPgwIMXGNxgaDAz5UgIMW
         EaGcxPH42DVPD2Y8lgD1yTQU9NVxNhEh9C4wWfg4sGZELe+L1Ru2bOTtZi8pLqWwLiDM
         iPB6KID3Xn7jim3XAXYDiarUBa4T/beYfZsXxlcNTvbcIEXehRLrjYgEdZrEz6iTG+Y3
         mSoGcSf3riYB2v9L+JSpBbeTfyRjH9i53YZh3jn7ZJegA34xmRPK9a0l7JAnbRN7CN+m
         MHFjAdlzPnotyssbYUPyuxIljT2/Jk07O80Wsm4s++3n8LjqVVDU2kl/W3ehMBz5xQh9
         Tfng==
X-Gm-Message-State: AOAM531widv273YTmWlqX5oHKGSpmjWA/YdZFk43RNtfFtVITMclEdoj
        d6tQSf/9t5hoVYZvoL/HB+wjcE7O6iRXLyqE
X-Google-Smtp-Source: ABdhPJygN9/SWvtjWua174P0DfMQFqOwqNMF2MJkxyOaTiASPA8HnRi5047pVM9uRcRZGwYV46HyuA==
X-Received: by 2002:a17:90b:1183:: with SMTP id gk3mr32596390pjb.172.1619621391784;
        Wed, 28 Apr 2021 07:49:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id oa9sm136550pjb.44.2021.04.28.07.49.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 07:49:51 -0700 (PDT)
Message-ID: <6089760f.1c69fb81.bb11b.067c@mx.google.com>
Date:   Wed, 28 Apr 2021 07:49:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.232
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
Subject: stable/linux-4.14.y baseline: 110 runs, 5 regressions (v4.14.232)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 110 runs, 5 regressions (v4.14.232)

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


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.232/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.232
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      7d7d1c0ab3eb7c8d8f63a126535018007823b207 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/6089414c09299f5e659b77b1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.232/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.232/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6089414c09299f5e659b7=
7b2
        failing since 390 days (last pass: v4.14.172, first fail: v4.14.175=
) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60894209157a40d57a9b77e5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.232/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.232/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60894209157a40d57a9b7=
7e6
        failing since 160 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6089420f17d65a4c5d9b77aa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.232/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.232/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6089420f17d65a4c5d9b7=
7ab
        failing since 160 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60894211fe1b1ccf889b77ad

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.232/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.232/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60894211fe1b1ccf889b7=
7ae
        failing since 160 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/608970c208e8bd71d69b77c4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.232/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.232/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/608970c208e8bd71d69b7=
7c5
        failing since 160 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =20
