Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CEEC3B88FF
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 21:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233693AbhF3TJh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 15:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233085AbhF3TJh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Jun 2021 15:09:37 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC638C061756
        for <stable@vger.kernel.org>; Wed, 30 Jun 2021 12:07:07 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id a14so1831923pls.4
        for <stable@vger.kernel.org>; Wed, 30 Jun 2021 12:07:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vYFoTCzR1hhb4h0+WsOT5QXcla7pq54CxeXPTt6VSf0=;
        b=y36qA7A5ntSFB8XEceLm4tKOTkYvoK5CuKVLOlVreweTl7uSPc60jNrBADrvcstJ+A
         Kuzi0FYI8Pw10L77CUUHOp5iIleFMO/OPROJup7+X3dEeuaA1mtFFltTdSyJyrSHHKEW
         yqoKSMMUCQ1CI3ST8yU9k/7kNhJEucPDBN6i99m3+vj9RV03XT882DFfw/PvQejpOhSp
         /Pb0hXlQKSacWGkABb3OLr14W9MoqnTPzEG2n6OTu7DQc9lRs+cpe1PM3R78awLcUd0s
         yFao/5OI6LSI3CrHwUQzmRyWjPuhJhyUd4BPn5wB0tD0QOYc4rf6VKMkAgAKrLLOoeI3
         byGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vYFoTCzR1hhb4h0+WsOT5QXcla7pq54CxeXPTt6VSf0=;
        b=Ae696jPCvBXgxYS576PjeDA8oAcLWmhN3RJTerIT0YN6VDSB6A8B3rzIFz1gI3oGCL
         zJCbmzOQnCNKWGij41m9c+QueSfRCwPw/eQJIAZHn61/u2SF5Wox+xomQB33C7lfTqOF
         FTjljUksgbcqDTiQWq9fXa6i2eTiH3sZr8/2veC6ixFbldH6gC4deuhrCO9dVNvq735c
         HS2uLFREIrxxAfxGzVB/cCSFAUvdfrEpaX6/lCZnkwz57xq7aekDynV9Xb4V+lzsup1A
         /srnhhPmop/d8IHqUGlTD1QjmAQ3HJJ6ZinSaMhLZWHAavHIg4HQbrkUsNpsm+l1EzM6
         KRiQ==
X-Gm-Message-State: AOAM532GzNXiJl+dA/+WLAZRZP6T0WChFbNPoNjCL3iZfOXjQdgYr8zq
        /LKBv9IgZoUfZN87ikR34qhjsXweZ1sgNkD6
X-Google-Smtp-Source: ABdhPJxv0VUilN9nPaIu6t314hV0K4z6BqEknvVCtO3MZZZ8RbW679oHCZ67Yp0urckonuVyxoG4DQ==
X-Received: by 2002:a17:902:e8d8:b029:117:8e2c:1ed5 with SMTP id v24-20020a170902e8d8b02901178e2c1ed5mr34136972plg.39.1625080027019;
        Wed, 30 Jun 2021 12:07:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j13sm22465109pgp.29.2021.06.30.12.07.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 12:07:06 -0700 (PDT)
Message-ID: <60dcc0da.1c69fb81.096a.348d@mx.google.com>
Date:   Wed, 30 Jun 2021 12:07:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.47
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.10.y
Subject: stable/linux-5.10.y baseline: 158 runs, 2 regressions (v5.10.47)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 158 runs, 2 regressions (v5.10.47)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
| regressions
---------------------+-------+--------------+----------+-------------------=
+------------
bcm2837-rpi-3-b-32   | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig =
| 1          =

meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-8    | defconfig         =
| 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.47/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.47
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      4357ae26d4cd133a86982f23cb6b321304faac50 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
| regressions
---------------------+-------+--------------+----------+-------------------=
+------------
bcm2837-rpi-3-b-32   | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60dc8c58852a4f8c8423bbc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.47/a=
rm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.47/a=
rm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60dc8c58852a4f8c8423b=
bc9
        failing since 7 days (last pass: v5.10.43, first fail: v5.10.46) =

 =



platform             | arch  | lab          | compiler | defconfig         =
| regressions
---------------------+-------+--------------+----------+-------------------=
+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-8    | defconfig         =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60dc8d6564878e1dd423bbca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.47/a=
rm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.47/a=
rm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60dc8d6564878e1dd423b=
bcb
        new failure (last pass: v5.10.46) =

 =20
