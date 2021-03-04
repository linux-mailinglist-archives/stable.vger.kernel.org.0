Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61B9632C9EF
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 02:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbhCDBPu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 20:15:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238056AbhCDBJ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 20:09:58 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0554C061756
        for <stable@vger.kernel.org>; Wed,  3 Mar 2021 17:09:15 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id a188so188372pfb.4
        for <stable@vger.kernel.org>; Wed, 03 Mar 2021 17:09:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VGUIRApsCQ93G6KfHfF7NpCXpUmIkpLGAM9ssM4pEAU=;
        b=l73f+Ms0H7igEIWt5vo35uDM351evOBg43/NFQ2uMs/Nqyl+lCeABQrFqUAHRAPnyB
         NzH7k2DZRjhO0hfTZQDh/L+HQGqFvrVy0aJ5GpwlafsFibCMhX9cPYe3d9l+foV30D4K
         0d/yCz4D3n7ZufZ9VW7FwoAWEGpSyaGg/dov9xFVCpE14L3IX7y86JZZZIb0Jq6etcxu
         m/wEi2slfY77GHp8UBsmkQ0Zvqq2YaT15SXINuUjFrpq0QmDSJCXDa0mqa0ZEEauByrQ
         koI6PDXjVfsqxvWULslCuNz1cO7hPDxOsACPOm89MVWBVFibljGq9JB81nfXtwjN2j6T
         9nEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VGUIRApsCQ93G6KfHfF7NpCXpUmIkpLGAM9ssM4pEAU=;
        b=IGO0F+6N7PZeqIjR1Zuorv/xv0MLmhPob/vNxpAG9qM5Enww5Gkhie5NTRRMU/ALCf
         +z4luvmHm233ANhcMh8f5Ny59HW8IhG/fcUndNWklwv+CYLuJqT7B/3xlD6pej3jexFa
         oHnaND9MJ2h1J3DuNREwYbotkvHM2UhOSBZhaSy12db4GSyzMroPoMCf7RK4eLzVnpnI
         OSNlyTog8beBauxHn871gDC/Bg3RuAZdC7Ln/5kL8eNQNCZbWAknBFyiDaLmb2cBGnxt
         isiTJp2d+1E0+k2tK0YQGEqocyMIUjOyRJ3N8cbDyJ3Zj8yrtc15HUF8npJye2yM8V+I
         hxqQ==
X-Gm-Message-State: AOAM530ifmcEbOcu8pOz/jcQKLyLzhSmjRdSFZp7Zyi+gmTBOqUs4VGc
        NkYiexfIt8Bosf1oFc0/oQOORM5JnavMp9Ef
X-Google-Smtp-Source: ABdhPJwobIZc3SEuzXYARoFCrUZ/BoGRcCUEX8lLXSB2fJzzfTyGzIP8ofb4n43McLEDG5EbTvIBYg==
X-Received: by 2002:aa7:9010:0:b029:1ee:253b:ebca with SMTP id m16-20020aa790100000b02901ee253bebcamr1400957pfo.53.1614820155309;
        Wed, 03 Mar 2021 17:09:15 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m18sm28304743pfd.206.2021.03.03.17.09.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 17:09:15 -0800 (PST)
Message-ID: <6040333b.1c69fb81.a0a24.07b0@mx.google.com>
Date:   Wed, 03 Mar 2021 17:09:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.259
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.9.y
Subject: stable/linux-4.9.y baseline: 107 runs, 5 regressions (v4.9.259)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y baseline: 107 runs, 5 regressions (v4.9.259)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =

r8a7795-salvator-x   | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.9.y/kernel/=
v4.9.259/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.9.y
  Describe: v4.9.259
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      2e782b1d9958ac86cccb317a83e5574f154c3b1b =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/603ffe0e9bdfe9680aaddcdb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.259/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.259/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603ffe0e9bdfe9680aadd=
cdc
        failing since 105 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/603ffe2d684444cc70addcc5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.259/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.259/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603ffe2d684444cc70add=
cc6
        failing since 105 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/603ffdb42f85a5daeeaddcc4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.259/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.259/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603ffdb42f85a5daeeadd=
cc5
        failing since 105 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/603ffdbd2f85a5daeeaddccc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.259/ar=
m/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.259/ar=
m/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603ffdbd2f85a5daeeadd=
ccd
        failing since 105 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
r8a7795-salvator-x   | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/60400034c82bb2f459addcbf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.259/ar=
m64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.259/ar=
m64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60400034c82bb2f459add=
cc0
        failing since 105 days (last pass: v4.9.243, first fail: v4.9.244) =

 =20
