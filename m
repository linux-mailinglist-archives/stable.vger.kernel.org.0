Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 545B33922D2
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 00:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233207AbhEZWge (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 18:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233648AbhEZWge (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 May 2021 18:36:34 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D312CC061574
        for <stable@vger.kernel.org>; Wed, 26 May 2021 15:35:01 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id x188so2082101pfd.7
        for <stable@vger.kernel.org>; Wed, 26 May 2021 15:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mZrb58btBZVpCyGqZkQ2iOZmo6wSBFrhlqTyNRYCHVA=;
        b=pQHLfJqjMF5Ab6oRxA1Y0Ci3/UGwPmbLI4vy1I0yWOuEeEiUNkTaIigsPXfcSTkPZ/
         reW17jDOn4w3sbqaFW7LK0h/Us3dA+MzMvU1pE10CPDVIODz1ze5IFyf+9DzIpQlbomJ
         Lnwt2cJNaKOcJafiHWmDl4qGGJr/wjowWHYRdOQQtInQGLX1t6Ss2m97zj3bsjGVWg3z
         T+Jubc0AWoPgA9msi3aW/WX7omM9guAs3phAI5y27x+tIp/ZQ0qUjI5rsOYqi2L+Kcs6
         9p3lRfqBa+dJm6Tq1N/JgCSch4kO0vs8t0N0Q5qR+FNi1IhFEvSUYmlQcuPTkvBpc3c6
         5j2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mZrb58btBZVpCyGqZkQ2iOZmo6wSBFrhlqTyNRYCHVA=;
        b=QRriWpAHCyi9XOSJzlnMWJpqa9ePtGHnB89pWpj1yx3XmTkPGsdEDTWSyBdy0yUJEG
         mljeG34aZZmjq7bPiYY4CNeV0gHhG9euL1r9uEOlpyB8zgkdIIXNPhybCvrwrWgUoKHs
         DX9AuWud78CIl9c4NdttkSKEKLIUPJR17d7GAZoHwLmKOQ/2S8pWJCjbzg+B5GQb8szt
         HOnPrKUcXKNXHLVmY7jH0KjRQy8/w0AxJixEK5RddvMC3TT+BhQVQJJ+B3J2vpGsQgjT
         V192BVwpF+oOtSboNSjOjSXSrsWAGgaipAdBBTi8HVO0uR4jHPrHFTqUemb4jPBQRu62
         Ygzw==
X-Gm-Message-State: AOAM532rlsBlP+42ExlVqu6+T6lM6YXIqnjLIyAMdoNnG2phQUbOWlK5
        g7kOVrJgvN4+6V32JRIzxKKIrVgWFsJcCk9D
X-Google-Smtp-Source: ABdhPJx8nxCcPkIe9Or3ZMta9jSmj/DBeSXknoGFvgHkclwl4YxI+ThrFCjl1sxm0yj3B4lL6GgAFg==
X-Received: by 2002:a63:e105:: with SMTP id z5mr706353pgh.321.1622068501181;
        Wed, 26 May 2021 15:35:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g18sm187062pfi.199.2021.05.26.15.35.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 15:35:00 -0700 (PDT)
Message-ID: <60aecd14.1c69fb81.55df3.1120@mx.google.com>
Date:   Wed, 26 May 2021 15:35:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.234
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.14.y baseline: 86 runs, 3 regressions (v4.14.234)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 86 runs, 3 regressions (v4.14.234)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.234/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.234
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ad8397a84e1e425e3f8221638cee2bfa237d9b2c =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ae9b62376c5af41db3afa4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
34/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
34/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ae9b62376c5af41db3a=
fa5
        failing since 193 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ae996f3178da60b3b3af9b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
34/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
34/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ae996f3178da60b3b3a=
f9c
        failing since 193 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ae99072f439de872b3afba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
34/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
34/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ae99072f439de872b3a=
fbb
        failing since 193 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =20
