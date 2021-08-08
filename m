Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96DC63E3ADE
	for <lists+stable@lfdr.de>; Sun,  8 Aug 2021 16:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231806AbhHHOn2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Aug 2021 10:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbhHHOn1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Aug 2021 10:43:27 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DCFCC061760
        for <stable@vger.kernel.org>; Sun,  8 Aug 2021 07:43:08 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id l11so2043814plk.6
        for <stable@vger.kernel.org>; Sun, 08 Aug 2021 07:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=359GEReoMfopuquwRFSd1lTADm3OZFL3gRfVs2U927o=;
        b=xjXVyxER1O/RNGCbvSnXa5tPeQkz73KzNpE6tg0zFph65WyaUqfshxUvzEWqyQC4db
         Ivd0KV87AjokfwRyl1i+z3WBf1/4QqiWgls9A7PqIqNQKJRPFfb9FpcqU/2kQWO/oN/a
         wpyg6qgDtS5/wcJeCohbE8vd7eVCwPuZ8gM7D9lziDas+Q1MwAE6BJhbtRPHpdtAly1J
         zXVLcZL7P4UeqtggZvjvopZmyXZ3ktG+BWnL+WVLXmlIhp53WNWdFuRURIrrVjOYtKcK
         Z9idGfiTTPXsFzc2+M+KDlrxfwFnUJVbseRh/qkzM3JgcmCrqwC/YzirdBoghpVRsbXn
         5ZBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=359GEReoMfopuquwRFSd1lTADm3OZFL3gRfVs2U927o=;
        b=JRmv3X+g/D0dMquS57Aha/Voa4+sCa8XhPNF8/e3sgSZgx4Q9HrIG6Ef5hejS1OIIV
         FDPHNAIfabpdltYnJtEGDvqZGrWKnTMIWS6hCyHlh9DUg0NlLDr6TptI8GzHuS94YsrI
         PWdmL6wapIhPluyAadSswLHkZLB+fHtCumgmURKMtrA+Mueunn/2XeY7TeSVt/vGLfYs
         1MOA446GzRGRgtvHKCfEC4M1C0RGh/3C1feSTBekrzxOea26xh3WhIhbJUxxy9EyP/Wp
         RSncVC+o6UxdX9wwowE78b0NUCURlCDJo4WJ/v/SiJAnoCavNDf3n2HqRKxhBJmw5m2Z
         7r+w==
X-Gm-Message-State: AOAM530aMTLAdMIQPhSXu3KG29dPz+jqeaeazSxh35b+BLUaMSz+K+KJ
        bJ+CkuL907yIfVFYseN5xQsn7Y9v21oQQMi4
X-Google-Smtp-Source: ABdhPJxkpdLLFQ7MKfnoN3qVYHRWJubghvbeBPlA7d66JDLiMAjjAgza9aa96F+1oi/+mNDa7ufkWA==
X-Received: by 2002:a17:90a:f0cb:: with SMTP id fa11mr785227pjb.214.1628433787541;
        Sun, 08 Aug 2021 07:43:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r3sm1043075pff.119.2021.08.08.07.43.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Aug 2021 07:43:07 -0700 (PDT)
Message-ID: <610fed7b.1c69fb81.1652.249d@mx.google.com>
Date:   Sun, 08 Aug 2021 07:43:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.279
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.9.y baseline: 89 runs, 4 regressions (v4.9.279)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 89 runs, 4 regressions (v4.9.279)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =

r8a7795-salvator-x   | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.279/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.279
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8028d2cebd46a484e6688b49a323e9f4543d774a =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/610fbb2d51f39bd498b1366e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.279=
/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.279=
/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610fbb2d51f39bd498b13=
66f
        failing since 266 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/610fe2c71c15af6eeeb13686

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.279=
/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.279=
/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610fe2c71c15af6eeeb13=
687
        failing since 266 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/610fe8a7ce01462815b13690

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.279=
/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilep=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.279=
/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilep=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610fe8a7ce01462815b13=
691
        failing since 266 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
r8a7795-salvator-x   | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/610fb21872d18b9afcb13676

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.279=
/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.279=
/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610fb21872d18b9afcb13=
677
        failing since 263 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-79-gd3e70b39d31a) =

 =20
