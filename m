Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9D512D05A1
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 16:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbgLFPUV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 10:20:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbgLFPUU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Dec 2020 10:20:20 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B26CCC0613D0
        for <stable@vger.kernel.org>; Sun,  6 Dec 2020 07:19:40 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id j1so5812275pld.3
        for <stable@vger.kernel.org>; Sun, 06 Dec 2020 07:19:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rWLenyOYWd8e3ke9tNIKuln3gtoIlKBdAySQS2pVijQ=;
        b=YP4X3okCAfH2j8LB3oRBp6RTZgrS15vKEhIRhS5Av/r25zvuoNZ9nLf+UUon+d1kY7
         j0FixWB2BsN9P3lRqqouxFmTl7IcQlRdNuh8kaGSwiTKjwteEyvOfN6OQBaRqldgt8Jx
         UiBOX6aTb9VAQEuFh3ATU2ztRJarSfAOy21FFKuwLduyZZwG0ljp41iZ3H2F7bny63uE
         dpixiE2qvSSayzYN+cedhV58X6p/loHPf7qkNv0BcHEgCcDn6iB0EB5DTUXcGRWBWYAK
         2mNWtQ/8VYEquaeC4r+Jg0C5NeWLtbtlXhd5eJjQgCdeLgXlDQ+uxDbFrGVOo1Nvjayv
         CZ4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rWLenyOYWd8e3ke9tNIKuln3gtoIlKBdAySQS2pVijQ=;
        b=UHKVJuYCmR+mAKRcxtyAljS9WKNf0SlM/BfCZ48qmw4RrtgDSkekuIqEwdRPdVOc8e
         cROwAiBBj7XcAE/a+UzCzpowW/haS+R4VoX9q7iYzOr3Am2P6VJsQ+vf4fG+lhI7E9ms
         oqO0fD7o8rYSxT2edqaOrbPrsrQnhd6RvNJvHEXC/waKFq9tQBI+vWMWxoGmsBjKflzP
         r8esgu8b+288zi4dcug8gggWVl5UbPFPp6n8tvvEb3tZD755yItitG6MhmpCaO2tbsCX
         YNMGF/PxzWnMY5YC0crOChCcLmrdvVPaOCdk/TkZ3x7iuXSEmLffY9BG9sbmo1pi7Qjx
         D77w==
X-Gm-Message-State: AOAM530KCvzSg2DHddq+IUfBi6T3Y7iEfcVBJyGjW2UcSUwSOycf3QyE
        U8VeSAeBP33kEkn2zynHlkDepiR8l4WDZQ==
X-Google-Smtp-Source: ABdhPJzjO3myxhQEJyG9VXrQcG3zWD4FBpMF8y7u7wi1ujrLfIwU8lwj5wis4U3TIwFo6sFXXO47pQ==
X-Received: by 2002:a17:90b:1b43:: with SMTP id nv3mr12845394pjb.67.1607267979757;
        Sun, 06 Dec 2020 07:19:39 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e6sm7597132pjr.34.2020.12.06.07.19.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 07:19:39 -0800 (PST)
Message-ID: <5fccf68b.1c69fb81.737b4.1ecc@mx.google.com>
Date:   Sun, 06 Dec 2020 07:19:39 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.210-21-ga6f93b82e1d6
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.14.y baseline: 148 runs,
 5 regressions (v4.14.210-21-ga6f93b82e1d6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 148 runs, 5 regressions (v4.14.210-21-ga6f=
93b82e1d6)

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
nel/v4.14.210-21-ga6f93b82e1d6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.210-21-ga6f93b82e1d6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a6f93b82e1d6291be12516c5afc5672e0a89eed3 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccbc0a9ec9ebc1e5c94cc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
10-21-ga6f93b82e1d6/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
10-21-ga6f93b82e1d6/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fccbc0a9ec9ebc1e5c94=
cc3
        failing since 249 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccbb98d1ea87fc18c94cdc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
10-21-ga6f93b82e1d6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
10-21-ga6f93b82e1d6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fccbb98d1ea87fc18c94=
cdd
        failing since 21 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccbb8a2ce2beb5f5c94cc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
10-21-ga6f93b82e1d6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
10-21-ga6f93b82e1d6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fccbb8a2ce2beb5f5c94=
cc9
        failing since 21 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccbb5e7c2e8dc911c94cd7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
10-21-ga6f93b82e1d6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
10-21-ga6f93b82e1d6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fccbb5e7c2e8dc911c94=
cd8
        failing since 21 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccbb062365caf57ec94ce0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
10-21-ga6f93b82e1d6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
10-21-ga6f93b82e1d6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fccbb062365caf57ec94=
ce1
        failing since 21 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =20
