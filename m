Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A832138F5A3
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 00:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbhEXWbj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 18:31:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbhEXWbi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 18:31:38 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72BD1C061574
        for <stable@vger.kernel.org>; Mon, 24 May 2021 15:30:08 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id n8so10131043plf.7
        for <stable@vger.kernel.org>; Mon, 24 May 2021 15:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+Y9xTT5Xx72I+Cf1cDVgUdwk0g2XyOmiRN1V20SI7Bc=;
        b=1X7V91ZTMmoI9qoFo2aJ477phQvTWyO1FFc098XC7ax7L6h6d4xpee/f03ViiLScFo
         qEWyjSbb106obeRPgL9nxGXFMl5U6X/SYs7+brFCF9Wo8KipIdWNhy3LAAMRlGaNH+2u
         7Vin6Gcw2CwHAZ69kJF7X6cgf5PVzSlG++ciXzxIZeB1YP68OaTTfedHw85s/9tt27m6
         vwYbVHTY28c0p0NGRIUO0UFdnBsAvonhICSlRv8MsbIEQvR8TjIsuJteh2xlphf2LA49
         HFiWuzkbjVY3qgiZLdW6a+jyzXtO0GHI8QuCCJ0CKjF619oZu2oQG7hNjHbE81HsH1F8
         0ftw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+Y9xTT5Xx72I+Cf1cDVgUdwk0g2XyOmiRN1V20SI7Bc=;
        b=it+AaxuZnFTbD8Fy5QTqnQ0df2dH4D3m20Ogv7IdceSPjBg7sB02pQufF02FXlSeJh
         bDp7CXTGvcRtKSpeIIlRjFYP/GG5xSvCODP4sel4wKqAIP0HZjTuimWA5jwTcYbMk4BO
         J2+xwDQvV941JOtWZVtqV1usY6GGupPMqFp1IyuUKuW2sVTpcz6Wcc/KpQo5UGs2RQWj
         qKSsApfvCoNiYcUDfYF0e+ph2PzuZ5XfMj+98rbTynZEy3qeMMot6VNfvfWOYwdPnSXm
         TK5zO0uoYZ59VBlYWTbozRBmPDoecZGfeZgVmbshSZeOeqVpP76x/CQbPKL5Tx9exTC/
         7AYQ==
X-Gm-Message-State: AOAM533lpR1fvwAjQENikOsoDJ0xgWofIkj5Vy6boYJkNo50+LTD0jeO
        xzJb9d5zh7JpcUFPyaTf6YJm6unyvP8Doa3r
X-Google-Smtp-Source: ABdhPJyzCN8JGBCR21jvk1/nfnrHuv+UVmY9uLIbQAJ42MusLWJXsQc1At00DLiIaSJNJCjAN2kSBA==
X-Received: by 2002:a17:90a:a386:: with SMTP id x6mr1443321pjp.193.1621895407643;
        Mon, 24 May 2021 15:30:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 126sm11936795pfv.82.2021.05.24.15.30.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 15:30:07 -0700 (PDT)
Message-ID: <60ac28ef.1c69fb81.8fb2d.7532@mx.google.com>
Date:   Mon, 24 May 2021 15:30:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.191-50-g01268129ebb2
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.19.y baseline: 99 runs,
 3 regressions (v4.19.191-50-g01268129ebb2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 99 runs, 3 regressions (v4.19.191-50-g0126=
8129ebb2)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.191-50-g01268129ebb2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.191-50-g01268129ebb2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      01268129ebb2be2b9872ed9bc56d075f438318e8 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60abf65285270acbb0b3afbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
91-50-g01268129ebb2/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
91-50-g01268129ebb2/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60abf65285270acbb0b3a=
fbf
        failing since 187 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60abf64f85270acbb0b3afb7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
91-50-g01268129ebb2/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
91-50-g01268129ebb2/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60abf64f85270acbb0b3a=
fb8
        failing since 187 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60abf5f8fc7e71477eb3afbf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
91-50-g01268129ebb2/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
91-50-g01268129ebb2/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60abf5f8fc7e71477eb3a=
fc0
        failing since 187 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
