Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EEA238F5D5
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 00:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbhEXWuW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 18:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbhEXWuW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 18:50:22 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D2FC061574
        for <stable@vger.kernel.org>; Mon, 24 May 2021 15:48:52 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id b7so11209748plg.0
        for <stable@vger.kernel.org>; Mon, 24 May 2021 15:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=arcVod+nE/jcGnEHdU7kNBkL0S0z53Gimevz1eN1XGg=;
        b=wZlItduLZQhVTX4Lb+DKMx7F8RhgvXHVxQsvl2iQht7xgiLZLacjp2fpe+MRtMeF/I
         jUnNGNVpeDGC1GVsSo8esbGxWr/5Bit5fVho19jyTaXjCX1usNn0K6DYrE2WbIhN+sr5
         6/Kopvx9V5xPkCo8ujln23WrIEwllhqP67p4ZNrFad2iQcPkNgqpx/Xmt10ufoTg6scL
         5Dbm+wqIMgblHCKXrr8Y4rb7ymxG3u2Wfr+pxmjhi44xDtWf7yVqxxlZFLJwYy5ibkSS
         n2whP1ZL2DdkFCqeJB+122duc69kBZzZb0nbG9oKbdY1za+yuFTK/KjSfhH3PuQ+vzD5
         9dwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=arcVod+nE/jcGnEHdU7kNBkL0S0z53Gimevz1eN1XGg=;
        b=klXdmsYRgpMLqda5X4MB6hOeYHTTdogs1V9Bmulgu2MDSyYlBJl9th7Uc66XTN7Q8Q
         Vo7+wQcqARiAJlvxljomfLvavGnCE75Z/F1sbNwIiLXhYFNZaxGA9s4Y3kYKsZ5Z4lx5
         NdV4kGJu+2iEKgRKi9Ce4TO6vctlGvCFp2BUbmn/HBISRVNJRYH1n5Sefj02qygdCquQ
         uGKAB48EnWNnDFbgUIqg+y6YDRjOUYi5bhnUxnxbNg9dg7KCcQ6oXcy0TMUlZsWqbLLD
         WowsLbLMxLoI7o3WkUg6DhNeQkcxRK13aAtZ06f+7TAJmN9cdZX+ZdMYvuXt9ev6eoNj
         +fhw==
X-Gm-Message-State: AOAM531TgpRyFuKWBbls0tsJ6ktXCwBTbLmOa8/t0wDSyvwfHYc+Cybz
        DMDUNErRAjM9omgO8HFs1ZhaJ3bn5ZLvM9Mw
X-Google-Smtp-Source: ABdhPJxv1ZQGIYu8xPLMb7Dc3mlDE3MR3L++jbC89hH/24sU7iH3zz0Y2p1YvFjLtHSoxYI8tYnupg==
X-Received: by 2002:a17:90a:1c02:: with SMTP id s2mr26916608pjs.172.1621896531461;
        Mon, 24 May 2021 15:48:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id bt4sm10707121pjb.53.2021.05.24.15.48.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 15:48:51 -0700 (PDT)
Message-ID: <60ac2d53.1c69fb81.81747.40fb@mx.google.com>
Date:   Mon, 24 May 2021 15:48:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.233-38-g535f9ea88cc8
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.14.y baseline: 86 runs,
 3 regressions (v4.14.233-38-g535f9ea88cc8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 86 runs, 3 regressions (v4.14.233-38-g535f=
9ea88cc8)

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
nel/v4.14.233-38-g535f9ea88cc8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.233-38-g535f9ea88cc8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      535f9ea88cc881bdcb3db703d1a9f589effffdcf =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60abf2a578b02f194eb3afdc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
33-38-g535f9ea88cc8/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
33-38-g535f9ea88cc8/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60abf2a578b02f194eb3a=
fdd
        failing since 191 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60abf28caf7b413a7fb3afb5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
33-38-g535f9ea88cc8/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
33-38-g535f9ea88cc8/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60abf28caf7b413a7fb3a=
fb6
        failing since 191 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60abf26a5f6fe868d1b3afb7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
33-38-g535f9ea88cc8/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
33-38-g535f9ea88cc8/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60abf26a5f6fe868d1b3a=
fb8
        failing since 191 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =20
