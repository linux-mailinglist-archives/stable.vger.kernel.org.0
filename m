Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3F452CA7CA
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 17:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389389AbgLAQKJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 11:10:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388738AbgLAQKJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Dec 2020 11:10:09 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25616C0613D6
        for <stable@vger.kernel.org>; Tue,  1 Dec 2020 08:09:29 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id j13so1512760pjz.3
        for <stable@vger.kernel.org>; Tue, 01 Dec 2020 08:09:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JbZ+DFFfZ0dxHh8bBGI+Jb3KYcLSG12mBHNpQLBMH7c=;
        b=B4VM4eVDG80SKeMu841/8vBFVvoE1FQPEXuRD+hAIPjyR4TYiUg1d+YCaY4tJTD+sw
         XZLy4mEyGqPOjCCgEdLyKKfXdLfctlfgJesGPd2aoZhIjX8qPKp7HvpwAY3T95vNDXKC
         2URw9Nov9ZlmR6FxL0I3M17KPxP6J89+MTGObD6jhxJXLWHnzsmDnZveoFvVIvQzaWl6
         kD2WMBvf/IGOlUPC2xiPxoqS+kC5M5hxfLut9ezPVE8Py+cwHBMOtuGv1te/BZCJm/4Z
         2yY5aLQ0zrhdGi6wrFTI66B/a8bq1l1j14jzk1T1Ootprl/yfrTTlUK3ji0ZHbmZPD3d
         wspA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JbZ+DFFfZ0dxHh8bBGI+Jb3KYcLSG12mBHNpQLBMH7c=;
        b=ZLTDu2NA/c0vILor167SLNXVVuql9L5b3O9lkyGef3QJmZg9/FM6D5zNfz7Ug0RXkB
         uvdzgvU/yFFkRVKs14ItKpyI5sM78KZxvRkq0mbp/YyAM74gZFlTxAsef7iTdhKrBDzZ
         fSF0i4nrKN50qFpQxbGZy50j5ri4sOfpodtT0f5bUlydR5L2qKXLWL9ieusUuDrDXx1/
         Ng0DapHFPQGsNxUVPXQqteQ3A9NpsaJJL+zkrL//K57a4yRAWcOGhzozP36snNoG0L8u
         LD7PAzBtvcY0mBm6o4HDiZai8HfvckrXOaxjPwL44cbtKmK8Vu/pTATBjlULaUO3GpvA
         z3pQ==
X-Gm-Message-State: AOAM532F42LuPJ7msc8HGB5tbmw8Kug3wKuxRGYEJKPZF7I29+RYC0Gq
        KIJQjD0GUMNJigOEDFapt32j86bsgnXi4A==
X-Google-Smtp-Source: ABdhPJxixdSXNQmcbt5QxKorbG4FX4wNM+9Ln02E+WlHgabybgx5LfbYoBiJ2iPh2kCUwVwxcG0pRw==
X-Received: by 2002:a17:902:ed11:b029:da:3137:2695 with SMTP id b17-20020a170902ed11b02900da31372695mr3467929pld.1.1606838968199;
        Tue, 01 Dec 2020 08:09:28 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a16sm190475pfl.125.2020.12.01.08.09.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 08:09:27 -0800 (PST)
Message-ID: <5fc66ab7.1c69fb81.280b.05ff@mx.google.com>
Date:   Tue, 01 Dec 2020 08:09:27 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.209-51-g07930d77d7ba
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.14.y baseline: 147 runs,
 5 regressions (v4.14.209-51-g07930d77d7ba)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 147 runs, 5 regressions (v4.14.209-51-g079=
30d77d7ba)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.209-51-g07930d77d7ba/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.209-51-g07930d77d7ba
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      07930d77d7baeac481d5ec4b88f8b26ac810c4bd =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc633d0d84006fa13c94cd9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
09-51-g07930d77d7ba/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
09-51-g07930d77d7ba/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc633d0d84006fa13c94=
cda
        failing since 245 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc6359d2bb43bdba3c94d0e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
09-51-g07930d77d7ba/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
09-51-g07930d77d7ba/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc6359d2bb43bdba3c94=
d0f
        failing since 16 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc635f2e25b12a8c8c94cc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
09-51-g07930d77d7ba/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
09-51-g07930d77d7ba/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc635f2e25b12a8c8c94=
cc9
        failing since 16 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc635ceef43d3a4b6c94ccd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
09-51-g07930d77d7ba/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
09-51-g07930d77d7ba/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc635ceef43d3a4b6c94=
cce
        failing since 16 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc63bde3ef6212b84c94cc1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
09-51-g07930d77d7ba/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
09-51-g07930d77d7ba/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc63bde3ef6212b84c94=
cc2
        failing since 16 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =20
