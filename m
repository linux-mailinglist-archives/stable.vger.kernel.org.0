Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1853F3FAC12
	for <lists+stable@lfdr.de>; Sun, 29 Aug 2021 15:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbhH2N6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Aug 2021 09:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbhH2N6A (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Aug 2021 09:58:00 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BCC4C061575
        for <stable@vger.kernel.org>; Sun, 29 Aug 2021 06:57:08 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id 7so10018495pfl.10
        for <stable@vger.kernel.org>; Sun, 29 Aug 2021 06:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bc8Zv3qLNpANbvHd8TJFjtUx381/v7nXFBWzgVjTe2Q=;
        b=2AA3ObA3plPGNMeE33IAjJEOClmi0YlczMEC1UoVXQCS+km3BD7Xw+BlblOXYOHU0v
         9+JlRrRowB4jCWhvNZjMRspHxjRHncpuIOJcani9qcGy6H0Ud/tm6UO7fnq2y8e8ZHsU
         YJwXEKsba3pFHhmYRwQKX9MQIDAAVKghAMgGuHb3w5I6y8Upbisb7vuFohSZ3ihYrQYx
         o+r6F2d5IY8EigfGtdr+kmdRhCQJEFZBwJTL9uaQHXEscYvh5DMMt9GHg12QU5NBbuOs
         fjIAHzwhSSdh9CUdQbDz3gfAmOerMl3n+O/pS3zOD50imoS4j7vd67EAoklYFNeIIq+w
         PKCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bc8Zv3qLNpANbvHd8TJFjtUx381/v7nXFBWzgVjTe2Q=;
        b=hGJ4JTxJX0WzuIWb73FFWOWc4B3A1c/PbSTEo/AHobwoRqf+fqUKIZPQPmRIJKevBd
         9PsIViTP7/L+Xbb+idCrIe+xqXUCMrFVFVqTZq88Nk9Dtcd07ujpZX0GRfcgqlDSpZIb
         txiwoFNJ0LGNKPV1I0J4ieG+Gn77LnoVcjAlmFNbn+BDbYi5DhUjcQu7scDH/t9cp9Jl
         UM6r238tiyiXneUxoUC2Dyg4RQmRDbc9o5hL86cb1o2TIu8RpH//a5m7WrKScbXv5Mh7
         /7oYWlGP9Ujru5/EalvPDghmxRwLXD1TgGnIyV+sYDvMJv3HrOsalH3b8vnyQi4JTGo0
         DJeg==
X-Gm-Message-State: AOAM533NXIfOzgFtcTvMqTVq6vQpjKGlf/Ke53dVbr9wNDE4CoxST36j
        Dt4DZcEZxvsdjU301gbbVzjxi9MAh7uAsrkZ
X-Google-Smtp-Source: ABdhPJx3sLH7ioU2pb4/XCKLfZ1LXio/n39hqRCnk/C8muLfgc8IB7SkvTNo8bmKhzxqBCjYlbBh2g==
X-Received: by 2002:a63:2301:: with SMTP id j1mr17316753pgj.150.1630245427937;
        Sun, 29 Aug 2021 06:57:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 4sm11381033pjb.21.2021.08.29.06.57.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Aug 2021 06:57:07 -0700 (PDT)
Message-ID: <612b9233.1c69fb81.1492f.d583@mx.google.com>
Date:   Sun, 29 Aug 2021 06:57:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.205-13-gaa35e8bd0343
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 140 runs,
 3 regressions (v4.19.205-13-gaa35e8bd0343)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 140 runs, 3 regressions (v4.19.205-13-gaa3=
5e8bd0343)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.205-13-gaa35e8bd0343/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.205-13-gaa35e8bd0343
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      aa35e8bd034370a392e0db74898b4a458a76b332 =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/612b5e56b5059114918e2c99

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
05-13-gaa35e8bd0343/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
05-13-gaa35e8bd0343/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612b5e56b5059114918e2=
c9a
        failing since 284 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/612b618d94b0f83aae8e2c93

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
05-13-gaa35e8bd0343/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
05-13-gaa35e8bd0343/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612b618d94b0f83aae8e2=
c94
        failing since 284 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/612b5e64130601903f8e2c77

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
05-13-gaa35e8bd0343/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
05-13-gaa35e8bd0343/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612b5e64130601903f8e2=
c78
        failing since 284 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
