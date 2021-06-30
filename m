Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3590B3B8A39
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 23:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232304AbhF3VyO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 17:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232095AbhF3VyO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Jun 2021 17:54:14 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D9CC061756
        for <stable@vger.kernel.org>; Wed, 30 Jun 2021 14:51:44 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id w15so3709796pgk.13
        for <stable@vger.kernel.org>; Wed, 30 Jun 2021 14:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Iq+9gEYIGd4WRfpK4cTmLzCicdYAF7wJsn1vsMBytXo=;
        b=MFRNMEIy4oVMNKZ7LKnTosiljS/ABlQUH+5qF4r6bg10i8LEJhU/XycHfcS3n1dc+U
         Dj1fSCNaqBzINAfjDdlT7ywAGsjS4/dZDYsdzmpKbOJCd0OmJ2Q6u1Am74gJ2TCpVrfs
         5ANkITp7ZKux/Q3LIYKyK9UdJO6SHFx4mnxMnO7BX8KyA6P3BngV7kDFkHJhetxzkeOS
         uvQ5+W2XX56Uxin+5wqVKCmLvncPF0h1g/70aEfs5I0oyWFZQe1hh44oCPAPTPBcSZqs
         symidw63pa5j3zEuCroTUXJ+6upkh7+6X45ajkxgxD/bLO+PGYUIia6e1K1mBB6Fjie2
         1/sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Iq+9gEYIGd4WRfpK4cTmLzCicdYAF7wJsn1vsMBytXo=;
        b=D05GiCCf9EZ/YnhdmDnECVb8FvuY/U+DA3gdgPUHRevVDTwg7NHi0ogROxYD+JeChp
         1buhiiIGn3ZNWieHbVf1kJO6KbhLO8vT45HBMn6Djz37ELxuZMEVrchdCtkfskOE/cEJ
         xRDWOFSCv/Eo9BHC/RbWQUOtGQwIEa4Gj7zwJl6kPB9VdCx2bjwZL3LuELJqlltiJWwL
         mBAyefcG4j6HIPL+D0IcVexV5f5AdCI/0ZZdFenwN4lXwztYMiv/6NEw9IWHtskg/XL6
         G0cbdJp15qkIy6UsVIFHLkvEU07WIIXht3CJMg7UQfDEf6Z9fyDEkWHcnPQJ4U3OiOzi
         JMBg==
X-Gm-Message-State: AOAM5321+BRwKF/PtfDfhXrkUVKO2F9ZPxerN2je6deFggN6QxPi4zd2
        7934TMvKMa9BL0P5lyo1r4H/pwD2gs+0aXUQ
X-Google-Smtp-Source: ABdhPJwmguS0sAAHHea2e3goa246aSBWAtcTj13MLl8Hv5AgaHrWwEIz7sZ23kTOBdgMG/xp/0aXtQ==
X-Received: by 2002:a63:eb4f:: with SMTP id b15mr36532866pgk.2.1625089903464;
        Wed, 30 Jun 2021 14:51:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ch6sm2939463pjb.55.2021.06.30.14.51.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 14:51:43 -0700 (PDT)
Message-ID: <60dce76f.1c69fb81.61602.8644@mx.google.com>
Date:   Wed, 30 Jun 2021 14:51:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.196
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 136 runs, 4 regressions (v4.19.196)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 136 runs, 4 regressions (v4.19.196)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.196/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.196
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9f84340f012ee60c12aacc03662bcdd67419a31a =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60dcb2ca226fce9cb623bbc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
96/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
96/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60dcb2ca226fce9cb623b=
bca
        failing since 224 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60dcbd9829f969e7f423bbd9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
96/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
96/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60dcbd9829f969e7f423b=
bda
        failing since 224 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60dcb2e669bb28def823bbd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
96/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
96/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60dcb2e669bb28def823b=
bd4
        failing since 224 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60dcc011281b885fc223bbd6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
96/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
96/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60dcc011281b885fc223b=
bd7
        failing since 224 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
