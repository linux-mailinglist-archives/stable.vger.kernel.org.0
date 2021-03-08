Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 758A0331726
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 20:23:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbhCHTWb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 14:22:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231400AbhCHTWY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Mar 2021 14:22:24 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21725C06174A
        for <stable@vger.kernel.org>; Mon,  8 Mar 2021 11:22:24 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id kk2-20020a17090b4a02b02900c777aa746fso3719049pjb.3
        for <stable@vger.kernel.org>; Mon, 08 Mar 2021 11:22:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7nGH6iv1Kxa6NUX47I/ocCLtt7aocW3aOPKqg2+ij6U=;
        b=h88k6MdVIynkWHyvxpSzDWwLN5G/wywGYQnjCqloCThHsWcJAAxCO+GSf5yFXN2j8K
         z6FXbsBgOFEKNAwDQ7lw6+nvtSHeAKHQ19giLxocmr2YkC0fCGbpeU7eRkCsYgo3bWRf
         j3G3LuNPyFZF5CZlGyZVZs7U43CPlW6C6q532EPBngAy6UV0wk5+iLWE/FGWrn4urf+/
         b+c0/2eOJF/U+NkZeXfEADxm+mqRbt2lUhIbaPE1wd31izhsiazk+SyB5PaAmDMBodxF
         ovHDRWADOwvS/+YK6o5lYtAnWOboQaq5+z1Dh0ADVFcXnhke2cXi6iGgSZ9/etbcwZhS
         xqiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7nGH6iv1Kxa6NUX47I/ocCLtt7aocW3aOPKqg2+ij6U=;
        b=I60XOUm7xpx4jxLPwmHGUbnlOyUhgjeCNouzq20DOREycwcyetqmKmJgbWJXXWOAgI
         syZB0KOZDVwadOOh7kvfzx65IGzatKBhtuCW2fldL/dZ8F2aUJ0ttYNJzKMEjj+z+/xu
         fs7oyW9aomPBi+Otf199jXE10yvcJ0JZc3AoKzCRn4nJZcDQMMqR1W10+KYl+UqF7SHE
         HzK/bQV5at8s02WUf1ERuG9LRg8tSH6kiKjCPWwAQGePCA2DYn/UjQLhUqn8Q3uxH4Pd
         oNtZjabINqNu+2XXfKcFUZdjcn9EZoxFpPGU9s/4c/veLqufVMRJdPP6+u/PIJ1/C3L0
         QLKw==
X-Gm-Message-State: AOAM530ytCYTeosuag3v1jp+/dhS9khhfGtUKvqGfHzHagcheoubkwlL
        +g1PlKeNRX9v/dOIw89jQ+cS+Tb8aih629go
X-Google-Smtp-Source: ABdhPJw6QB3GlRRXNXalauof1C3Ae0YljjJL8/DM+HMrhEoU9VYyMyswPVE1NIbiXNasSsmnFq9t5Q==
X-Received: by 2002:a17:90a:db51:: with SMTP id u17mr409801pjx.194.1615231343565;
        Mon, 08 Mar 2021 11:22:23 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u20sm11200406pfm.146.2021.03.08.11.22.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 11:22:23 -0800 (PST)
Message-ID: <6046796f.1c69fb81.b47e8.c32c@mx.google.com>
Date:   Mon, 08 Mar 2021 11:22:23 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.224-6-gf096db8a2a39
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 84 runs,
 3 regressions (v4.14.224-6-gf096db8a2a39)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 84 runs, 3 regressions (v4.14.224-6-gf096db8=
a2a39)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.224-6-gf096db8a2a39/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.224-6-gf096db8a2a39
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f096db8a2a3981ca414eb3e1b3ebcc6423c45909 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604644f31cca50665eaddcc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.224=
-6-gf096db8a2a39/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.224=
-6-gf096db8a2a39/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604644f31cca50665eadd=
cc4
        failing since 114 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604645011cca50665eaddccf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.224=
-6-gf096db8a2a39/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.224=
-6-gf096db8a2a39/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604645011cca50665eadd=
cd0
        failing since 114 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60464497522e118e32addd13

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.224=
-6-gf096db8a2a39/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.224=
-6-gf096db8a2a39/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60464497522e118e32add=
d14
        failing since 114 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
