Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 574BD319798
	for <lists+stable@lfdr.de>; Fri, 12 Feb 2021 01:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbhBLAr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 19:47:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbhBLArz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Feb 2021 19:47:55 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42771C061574
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 16:47:15 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id a24so2336732plm.11
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 16:47:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QH34qiQ3Xyow7C4rG62T4kpKpB75Qov9O7h6P8Wj6b8=;
        b=jbOyY8sLbmVDoPpok45jAJ1JzB6bDp6fDI4vCQKtUaM7fiTh9Ue2zxFNop1uy6h8KP
         KorMCdjos4U3WnIc7tDReN5bocbVUFVx3PIDxygVveg1uEabAnHsJ29lg4PA7CRZuROd
         NI15retfLOdJwqUk35fZkSHZnqBw3seiLXP+ruV7kYCxoQFG5bcsavSAl9o5BVuaPOaE
         /LbRNpcM3sxnk5LZnnTE1OvaxTAWGFJqHlnyuVqun/5cdl4hw4A6wWExnw7P/BOAnRk5
         lMoNXTVoBgnjcPS3+Rbrch4XLFnrLdILKUxAffwzxnY1oOt5WfdUrQgo+9F6czlFJ+iq
         A+sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QH34qiQ3Xyow7C4rG62T4kpKpB75Qov9O7h6P8Wj6b8=;
        b=NZQiJAKp4l5JRLpRSOhd5Niw0Z4KrgIvWJs9XFsd7JAEVnOtXTWVLA70fMtKrlJ+Dq
         Mk/9OVdiYEKp0AdgL0Rs1e48LLCudt2rd3ZJ/UbL/WoAY66z52yACmD9bYmVTSze/sPP
         gw7DSQ8MIme/R8vH3rBNA43LSH0niSjjYH4L32BOpJTkqo0t/Rg94EPDCaehisgo+im1
         kLSuXrO+urluIhea/6lTTvA67J1gnIqBs9grxcY6LceXQxifLtLihlEUjNRP7sF+d3f9
         n3TAh/A2YBorJJ5wQcvfGkKS+1ukKF0Gv+xf1JdxIfsO4/TCUYQ1orPU0yG1z0Q3maIm
         vdbQ==
X-Gm-Message-State: AOAM533ZlyN4DkgOYtCrDJrGlraWTIEvU1OfEJjPVSPuOcITvI7e3Npz
        D0wg/UOc9dTLwGlIwu6n95yqPMfd8ebjrA==
X-Google-Smtp-Source: ABdhPJxkbm0HFvUBijTbS7IDv5zEcd9DIcYOLehtb1wbOJRpbl7hMcoB4eUiZxIqqghvIAqGJ8mpmw==
X-Received: by 2002:a17:90b:14cf:: with SMTP id jz15mr370575pjb.180.1613090834393;
        Thu, 11 Feb 2021 16:47:14 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j1sm6639412pfr.78.2021.02.11.16.47.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 16:47:13 -0800 (PST)
Message-ID: <6025d011.1c69fb81.79d1a.f892@mx.google.com>
Date:   Thu, 11 Feb 2021 16:47:13 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.221-16-g7d2e667e5a8e
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 65 runs,
 2 regressions (v4.14.221-16-g7d2e667e5a8e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 65 runs, 2 regressions (v4.14.221-16-g7d2e66=
7e5a8e)

Regressions Summary
-------------------

platform       | arch  | lab           | compiler | defconfig           | r=
egressions
---------------+-------+---------------+----------+---------------------+--=
----------
meson-gxm-q200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | 1=
          =

panda          | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.221-16-g7d2e667e5a8e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.221-16-g7d2e667e5a8e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7d2e667e5a8e8924c97b567ee3c8b910db808555 =



Test Regressions
---------------- =



platform       | arch  | lab           | compiler | defconfig           | r=
egressions
---------------+-------+---------------+----------+---------------------+--=
----------
meson-gxm-q200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | 1=
          =


  Details:     https://kernelci.org/test/plan/id/6025b61d8a7f500d0f3abe63

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-16-g7d2e667e5a8e/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-16-g7d2e667e5a8e/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6025b61d8a7f500d0f3ab=
e64
        failing since 65 days (last pass: v4.14.210-20-gc32b9f7cbda7, first=
 fail: v4.14.210-20-g5ea7913395d3) =

 =



platform       | arch  | lab           | compiler | defconfig           | r=
egressions
---------------+-------+---------------+----------+---------------------+--=
----------
panda          | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/6025968d52f84a6ff93abe8b

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-16-g7d2e667e5a8e/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-16-g7d2e667e5a8e/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6025968d52f84a6=
ff93abe92
        failing since 5 days (last pass: v4.14.219-15-g82c6ae41b66a6, first=
 fail: v4.14.219-15-g8b9453943a205)
        2 lines

    2021-02-11 20:41:45.504000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-02-11 20:41:45.520000+00:00  [   20.706787] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
