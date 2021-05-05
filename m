Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4579F373D6C
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 16:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbhEEOPv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 10:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbhEEOPu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 10:15:50 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CD85C061574
        for <stable@vger.kernel.org>; Wed,  5 May 2021 07:14:54 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id q2so2013615pfh.13
        for <stable@vger.kernel.org>; Wed, 05 May 2021 07:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nfEd9TrX8X/cvI+WaG7GmsdKwWvvKk/9Mffk8oJNU3w=;
        b=0cyY6Vvrm7/FWY6T+cxVRPvHpTj3llcYumc8a/Z7G0N2VIR4veCFZYf1GplB3XCe/Y
         Jp4zGFJc4PYh331a6wK1nP5DYU1PRf04C9bwMgHcl+/nRIzfKZR1S2T+Fz3hvTXSqr8G
         FoaQHZS4lb3kvhrlrAd9kRlifWQcsZyXrw0uDycxJagkPIorMt81IDwqgFbshqb+8zCs
         yeDR3t3AxtIAEwfKX1lQ9uVh9ibqfhGgQwDDY7n2puirG8lsQzAteOrD83ElvwCE7YUe
         4oq5vhlZpPrpVzCdJ8JRDtUwPcAlC8ZBUzPlhyBOvJ3VGbS6xlEl6j9dZp0N4x5oNQlF
         F+5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nfEd9TrX8X/cvI+WaG7GmsdKwWvvKk/9Mffk8oJNU3w=;
        b=eUAR5KRKDBpxC60Fhl+vgZIvupz8jPFA8Uh0kBpu+EHo0RtFt3YX042zaKY8JKMAye
         JiXJSe5g2Nf0pvrPuNmXpVVSuxYmbiXGQ5DYGCOCUzlwEQBA0UhcEJRQQsIdFRUbDwa6
         NLG59tBhWSBn2xJ2r3x3dIxapMdLBzy8j1t5XsnOvjDvrI/IVexBQrwKDzNnK0/h7PjL
         0CSolNssAb6tOeNtgAVglZpScGA9sO9Y+HFqIrS6r0tV1dSQPoTJUmEIZrusa3dGCwJh
         BLhIOJWYaCgUgiMaUVIFwHAHq6y5d2S9cz3dh1AdXW+dfc+LG5gdZeTS2hPrIf3zeZkZ
         arAA==
X-Gm-Message-State: AOAM531O+N2Lr3Rs59gqLVra4dUyNRQ219x5V33MB9V04ekx3BJ4yRn8
        lXoNlm1cNfqFdDGBW58UjxP2k6QhtRoTud57
X-Google-Smtp-Source: ABdhPJyQPXAeEEy/eMv2CWHbJuFwloQ2JFcJhPvpQn3ifJoCNUbQFSYgIll++jGADTj7+S44KXX/BQ==
X-Received: by 2002:a63:1f4d:: with SMTP id q13mr28502162pgm.453.1620224093653;
        Wed, 05 May 2021 07:14:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g14sm16037373pfm.143.2021.05.05.07.14.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 07:14:53 -0700 (PDT)
Message-ID: <6092a85d.1c69fb81.fa3e1.90f4@mx.google.com>
Date:   Wed, 05 May 2021 07:14:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.189-16-g63da09e7651e3
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 70 runs,
 3 regressions (v4.19.189-16-g63da09e7651e3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 70 runs, 3 regressions (v4.19.189-16-g63da=
09e7651e3)

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
nel/v4.19.189-16-g63da09e7651e3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.189-16-g63da09e7651e3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      63da09e7651e340c3f6b1cb62d401239a6c45f0d =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/609271978d61f76c0d6f546a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
89-16-g63da09e7651e3/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
89-16-g63da09e7651e3/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609271978d61f76c0d6f5=
46b
        failing since 168 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6092719d53d012370d6f5468

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
89-16-g63da09e7651e3/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
89-16-g63da09e7651e3/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6092719d53d012370d6f5=
469
        failing since 168 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6092719b3b5bc839606f546e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
89-16-g63da09e7651e3/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
89-16-g63da09e7651e3/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6092719b3b5bc839606f5=
46f
        failing since 168 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
