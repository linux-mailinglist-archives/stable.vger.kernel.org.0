Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33AD22B7CE7
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 12:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbgKRLi6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 06:38:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727814AbgKRLi5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Nov 2020 06:38:57 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D35C0613D4
        for <stable@vger.kernel.org>; Wed, 18 Nov 2020 03:38:57 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id ei22so962625pjb.2
        for <stable@vger.kernel.org>; Wed, 18 Nov 2020 03:38:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=u6ED9s2VXRZaN1DKa4L9bnrOcg7P9dX8U5X2Zx4WYak=;
        b=WGFjUXphz0z6l0bRiO74i8Ora1Vel6UbatB8f7ZXtWjazXi+PDCqaZ6l278Pbanenl
         QyzA/wV0wtrztRrRDAJ+9jtnytMCikU4uodJTfG4lDkJ4e9/2eLw0XqaQZun9vyMuu/t
         l/0+RQaJ7/y7spASVpZ0LX6uNo284sIXjcSwqtQnqJ+0MyudOfAD7fUkac2Mvh0l8LEn
         oSXmt2kqsQsw18IKNsfXyoxiPDbJ9aXOk5Uj6ER5nLFD8rblc/uFRne2zXYIMo6o+xZo
         nDVAx7YHSQv2992Gyi/HNsh9iCXl6zAln+PoBDzvls9gJ4GjjUlHYNTNpLIaHGe+Tkoh
         EBWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=u6ED9s2VXRZaN1DKa4L9bnrOcg7P9dX8U5X2Zx4WYak=;
        b=WhbXwsW5TBgIX7W+3Ep9fBbUQKvnSgqeAh8rNDMh7UCJ1RZtLB5ir3LHc1Z+8bWv6n
         7xPrQcyAATEBorncOeoQnVjn94UPTmH9GIojClkYyz5IkP8ls0KCf7UuMYV8AVfVedf2
         evhtCHnP9XQkjGt10hcfC8Xjve8Y3vuPtsSGsZP3GYZegt5yqnMhl2V1iYZP9/utM84S
         DgdIeThOb1sfbWN9GX6yIVB8Rz7Is+HqBr1tiL+2DvYO4ldKijRwsx7V9fIp80/GRXGu
         Rh2FAPJOFvj5YAavg+3GWYjv56WoxEBEtFpZs18iCmeWpqry9be43cFmSr4l2kHq4e8+
         xGww==
X-Gm-Message-State: AOAM531r8wUmedIWXgZWeV9PuypZIGbYzsunxuFFfNkqeeS1knbixf3W
        EVHVAibR47BayLIEG7ZTEdWhsDxeaFeFkQ==
X-Google-Smtp-Source: ABdhPJwvheKmt8Pz2xMAubZBdnmbV0BAaQtyKZV6xdrTU74Rudy8ymE0ZZzoHzTUtjYyJf3Bhtvigw==
X-Received: by 2002:a17:90a:5309:: with SMTP id x9mr3541872pjh.98.1605699536478;
        Wed, 18 Nov 2020 03:38:56 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v18sm24891030pfn.35.2020.11.18.03.38.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 03:38:55 -0800 (PST)
Message-ID: <5fb507cf.1c69fb81.bc6fb.64ff@mx.google.com>
Date:   Wed, 18 Nov 2020 03:38:55 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.206-86-gabaf3bc53e47
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 133 runs,
 8 regressions (v4.14.206-86-gabaf3bc53e47)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 133 runs, 8 regressions (v4.14.206-86-gaba=
f3bc53e47)

Regressions Summary
-------------------

platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
at91-sama5d4_xplained | arm    | lab-baylibre    | gcc-8    | sama5_defconf=
ig     | 1          =

fsl-ls2088a-rdb       | arm64  | lab-nxp         | gcc-8    | defconfig    =
       | 1          =

meson-gxbb-p200       | arm64  | lab-baylibre    | gcc-8    | defconfig    =
       | 1          =

qemu_arm-versatilepb  | arm    | lab-baylibre    | gcc-8    | versatile_def=
config | 1          =

qemu_arm-versatilepb  | arm    | lab-broonie     | gcc-8    | versatile_def=
config | 1          =

qemu_arm-versatilepb  | arm    | lab-cip         | gcc-8    | versatile_def=
config | 1          =

qemu_arm-versatilepb  | arm    | lab-linaro-lkft | gcc-8    | versatile_def=
config | 1          =

qemu_x86_64           | x86_64 | lab-baylibre    | gcc-8    | x86_64_defcon=
fig    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.206-86-gabaf3bc53e47/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.206-86-gabaf3bc53e47
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      abaf3bc53e472252e05a2c43674a48e7aed19e7e =



Test Regressions
---------------- =



platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
at91-sama5d4_xplained | arm    | lab-baylibre    | gcc-8    | sama5_defconf=
ig     | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb4d46b1058af4598d8d939

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
06-86-gabaf3bc53e47/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
06-86-gabaf3bc53e47/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb4d46b1058af4598d8d=
93a
        failing since 116 days (last pass: v4.14.188-126-g5b1e982af0f8, fir=
st fail: v4.14.189) =

 =



platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
fsl-ls2088a-rdb       | arm64  | lab-nxp         | gcc-8    | defconfig    =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb4d7dad32893a346d8d920

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
06-86-gabaf3bc53e47/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
06-86-gabaf3bc53e47/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb4d7dad32893a346d8d=
921
        new failure (last pass: v4.14.206-21-gf1262f26e4d0) =

 =



platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
meson-gxbb-p200       | arm64  | lab-baylibre    | gcc-8    | defconfig    =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb4d3da3d0ddfbf77d8d921

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
06-86-gabaf3bc53e47/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
06-86-gabaf3bc53e47/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb4d3da3d0ddfbf77d8d=
922
        failing since 231 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
qemu_arm-versatilepb  | arm    | lab-baylibre    | gcc-8    | versatile_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb4d32f77abee21a4d8d90c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
06-86-gabaf3bc53e47/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
06-86-gabaf3bc53e47/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb4d32f77abee21a4d8d=
90d
        failing since 3 days (last pass: v4.14.206-21-gf1262f26e4d0, first =
fail: v4.14.206-23-g520c3568920c8) =

 =



platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
qemu_arm-versatilepb  | arm    | lab-broonie     | gcc-8    | versatile_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb4d330290b2dc9f6d8d910

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
06-86-gabaf3bc53e47/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
06-86-gabaf3bc53e47/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb4d330290b2dc9f6d8d=
911
        failing since 3 days (last pass: v4.14.206-21-gf1262f26e4d0, first =
fail: v4.14.206-23-g520c3568920c8) =

 =



platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
qemu_arm-versatilepb  | arm    | lab-cip         | gcc-8    | versatile_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb4d3300ae2bb3e4dd8d926

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
06-86-gabaf3bc53e47/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
06-86-gabaf3bc53e47/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb4d3300ae2bb3e4dd8d=
927
        failing since 3 days (last pass: v4.14.206-21-gf1262f26e4d0, first =
fail: v4.14.206-23-g520c3568920c8) =

 =



platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
qemu_arm-versatilepb  | arm    | lab-linaro-lkft | gcc-8    | versatile_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb4e0d74abc6bd34cd8d911

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
06-86-gabaf3bc53e47/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-=
qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
06-86-gabaf3bc53e47/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-=
qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb4e0d74abc6bd34cd8d=
912
        failing since 3 days (last pass: v4.14.206-21-gf1262f26e4d0, first =
fail: v4.14.206-23-g520c3568920c8) =

 =



platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
qemu_x86_64           | x86_64 | lab-baylibre    | gcc-8    | x86_64_defcon=
fig    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb4d55a39f0888517d8d926

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
06-86-gabaf3bc53e47/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
06-86-gabaf3bc53e47/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb4d55a39f0888517d8d=
927
        new failure (last pass: v4.14.206-23-g520c3568920c8) =

 =20
