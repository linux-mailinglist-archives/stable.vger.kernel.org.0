Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 130D83DC654
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 16:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232752AbhGaOiz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Jul 2021 10:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232770AbhGaOix (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Jul 2021 10:38:53 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17829C06175F
        for <stable@vger.kernel.org>; Sat, 31 Jul 2021 07:38:47 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id c16so14520510plh.7
        for <stable@vger.kernel.org>; Sat, 31 Jul 2021 07:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MxrMvIxhWnZTA4ZsT/A4gRPoXi3QzxUXi9/nlGIiIiE=;
        b=egyELTm+YX8fdX9DWg9gWnQlRIox2tiWKeOTNQ8Nypm/VH6bpaM/GesFkrUnSKhdjM
         y5QPk2v35xUrmuIZJqshTC3Xr0WTc8pNoa4iqZW9dWvSRG+fvXLutM7r/6Eclsj+X6Ik
         wkfIii6J3sSOQ8FrVaEWmLLesZjNHXoJ8gDkBcfWCtonG7D7UYOXL7urdzrLFeIoF0WN
         /G08jRuluc57ywoEno5kF99P7iHY+De0OFmp+udqpIeIdQ6bMUDliz/URoLiaqM7IDM1
         T7BHacQNekMPldXBW4kOOwXrZPdIDDoSIk9WGb+/9G5Pf2reyOvjKQG8aeNiU8ZzD9+B
         Lppg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MxrMvIxhWnZTA4ZsT/A4gRPoXi3QzxUXi9/nlGIiIiE=;
        b=UnIgi4vfBnnXWMKWzHP/JhQDs0PEpxblDAcI9z9K0XpI+m7UJUDNjsRLBmYtjdIcFm
         beY7fWHWj1O9WeVNM4OvT4X2Jt927B/IdcEVwzf53a7BA+iUDj8OFQmXNDVAKVpu35lv
         pDXHyIWZn+0/eqB+IasnboffTCfBXqPduV+3XuTiqxzghMPMgBHTOgUOkOKK1IUGdf1x
         vfNLHWNys+45qL6htBZzYAVTNlWVs2+cMYfHQGZPRfDFTjUhltVT9m6ku40ZVsPa5LxB
         Mjtgewcroif/givsqywYUHoukGI0BmneSaHqcEJ/uiMBbeUih9MkaBNeMLUp1Uo8kZkQ
         iAnA==
X-Gm-Message-State: AOAM533WdVG+Qg2A6ReZZOUfQtRRjJ6ue72OmqVbk13xz89F67UsTsYZ
        ghIieshZyiUSbk04HBOytVU0nWJ/Qyx1aM/R
X-Google-Smtp-Source: ABdhPJymdrmHwZEyFV1uaMa3JQB1w3+7u5X1vvFYyR+0IcCyI6zFYecWVD/9+lh2nS2lG6K8oVK4xA==
X-Received: by 2002:a17:90b:4c0f:: with SMTP id na15mr8648018pjb.8.1627742326357;
        Sat, 31 Jul 2021 07:38:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u17sm1650463pfh.184.2021.07.31.07.38.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jul 2021 07:38:46 -0700 (PDT)
Message-ID: <61056076.1c69fb81.70e8c.3594@mx.google.com>
Date:   Sat, 31 Jul 2021 07:38:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.241-27-gc9a4a7fd3215
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 114 runs,
 4 regressions (v4.14.241-27-gc9a4a7fd3215)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 114 runs, 4 regressions (v4.14.241-27-gc9a=
4a7fd3215)

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

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.241-27-gc9a4a7fd3215/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.241-27-gc9a4a7fd3215
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c9a4a7fd32157b71db9458f41deacb6ae540e265 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/61052cec4270c27ab985f45a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
41-27-gc9a4a7fd3215/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
41-27-gc9a4a7fd3215/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61052cec4270c27ab985f=
45b
        failing since 486 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/61052f425e6ae887a585f472

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
41-27-gc9a4a7fd3215/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
41-27-gc9a4a7fd3215/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61052f425e6ae887a585f=
473
        failing since 258 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/61052f3e0b42379c7285f49c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
41-27-gc9a4a7fd3215/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
41-27-gc9a4a7fd3215/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61052f3e0b42379c7285f=
49d
        failing since 258 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/61052f20e10a19cc9085f467

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
41-27-gc9a4a7fd3215/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
41-27-gc9a4a7fd3215/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61052f20e10a19cc9085f=
468
        failing since 258 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =20
