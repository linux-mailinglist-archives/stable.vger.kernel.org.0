Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC522E2270
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 23:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbgLWWev (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 17:34:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbgLWWeu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 17:34:50 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94F80C061794
        for <stable@vger.kernel.org>; Wed, 23 Dec 2020 14:34:10 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id j1so395883pld.3
        for <stable@vger.kernel.org>; Wed, 23 Dec 2020 14:34:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fs+dkLxSQDaoPnUkTDGhcDWpCS2P6+a3DNPKaJYGD8Y=;
        b=IhQWetqNJe6vkH57zeIFZUIENpbw8v6NGcrmTKxCDUVd54y7zdts4wKpgbdpWjqZFa
         Lni749yItigRcHJq6Qh9U4rSj0uhIllb66bEyLwL1B4V140AHl0OJC/2ZzuoBXDQmqLP
         uGPrsHZbv51hrjF3VvkmcDCCqyDg1LampoNIfzWN993boKVMm1NHFkH/QLBuPCutfBl9
         1Rx7yng5KZ936eijyilRatJ6a071Z+e/sBRt4fSEHu0T4kq89pAMSA32YG+fMtivjYzt
         QOm5VH2tuWDN6eAzsEktl9G0cXChVai4HHGNpZW5jqB15N9I3eCC8R9h/TpRNr6fabsv
         dQbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fs+dkLxSQDaoPnUkTDGhcDWpCS2P6+a3DNPKaJYGD8Y=;
        b=DqQ/KPNAc6QDiY+bVQcQU1z18vObzKh1DL2sHWHbjV3QYYDJdT9nNPax22KWjSyAZL
         4f+Ok55mvpB5mSH2PI8nr7ibn7DpGD88rCLJknInY0FHP41ULcN9kjKIfeSxKstWyMjw
         kiKEIHalaX7OX5tLgj/HZg7vqV+lj+ecuhwQ36v2C/NAEOxTPryXFkvciM1BXnA+c4Ct
         sLlravyKfMuDnAvJSkwY/jkKrIrff3Rm5D4wAbVw5f/1bbrHTILI5bX1TJu+Gs3vDJal
         RTLKxmsJRHeH3LAhRfPynCqGmDxlICKSphLQ6p94sEOj/pDqw/0QqX+d3s8utdu3aSGe
         /+og==
X-Gm-Message-State: AOAM532XkYP9MaxSo05sTAxYk0nMpiPLYg3TIFlqQp8Cfry1hHOZNGzy
        nMb06gbBzGMVTOR5vVMM+y9y0GvMBTVSeg==
X-Google-Smtp-Source: ABdhPJz2OiB/1XpJfhG7+bCNLFs2reIrGtlAtC1pxlwWkIaz1U1eWR1uSRb2HXijMMVDMWr5otjrBw==
X-Received: by 2002:a17:902:d90d:b029:da:5114:7275 with SMTP id c13-20020a170902d90db02900da51147275mr27716127plz.64.1608762849713;
        Wed, 23 Dec 2020 14:34:09 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z3sm4837841pgs.61.2020.12.23.14.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Dec 2020 14:34:09 -0800 (PST)
Message-ID: <5fe3c5e1.1c69fb81.2322b.bc49@mx.google.com>
Date:   Wed, 23 Dec 2020 14:34:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.85-72-ge4ff6f3aa771
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.4.y baseline: 126 runs,
 6 regressions (v5.4.85-72-ge4ff6f3aa771)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 126 runs, 6 regressions (v5.4.85-72-ge4ff6f=
3aa771)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
bcm2837-rpi-3-b-32   | arm   | lab-baylibre  | gcc-8    | bcm2835_defconfig=
   | 1          =

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.85-72-ge4ff6f3aa771/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.85-72-ge4ff6f3aa771
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e4ff6f3aa771cbdc09bc4269204849985c66ae8b =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
bcm2837-rpi-3-b-32   | arm   | lab-baylibre  | gcc-8    | bcm2835_defconfig=
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe391a7d1ed3c46c3c94ccc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.85-=
72-ge4ff6f3aa771/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.85-=
72-ge4ff6f3aa771/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe391a7d1ed3c46c3c94=
ccd
        new failure (last pass: v5.4.85) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe390a0e46a4bba4ac94cce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.85-=
72-ge4ff6f3aa771/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.85-=
72-ge4ff6f3aa771/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe390a0e46a4bba4ac94=
ccf
        failing since 33 days (last pass: v5.4.77-152-ga3746663c3479, first=
 fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe3910f2367785e21c94cda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.85-=
72-ge4ff6f3aa771/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.85-=
72-ge4ff6f3aa771/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe3910f2367785e21c94=
cdb
        failing since 39 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe391152367785e21c94cdf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.85-=
72-ge4ff6f3aa771/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.85-=
72-ge4ff6f3aa771/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe391152367785e21c94=
ce0
        failing since 39 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe39112da90602403c94cc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.85-=
72-ge4ff6f3aa771/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.85-=
72-ge4ff6f3aa771/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe39112da90602403c94=
cc1
        failing since 39 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe390c9b03f9e2fcbc94cce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.85-=
72-ge4ff6f3aa771/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.85-=
72-ge4ff6f3aa771/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe390c9b03f9e2fcbc94=
ccf
        failing since 39 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =20
