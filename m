Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7C272D44AA
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 15:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733189AbgLIOqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 09:46:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733191AbgLIOqn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 09:46:43 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B296DC0613CF
        for <stable@vger.kernel.org>; Wed,  9 Dec 2020 06:46:02 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id h7so806560pjk.1
        for <stable@vger.kernel.org>; Wed, 09 Dec 2020 06:46:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uQNthrJt0engSxAORExc/89EyYgck51IJRqnyXancJU=;
        b=oFv/VTaJVubIwTKAfMlIKoAjaHZVg3vsZWW1StsxL8pNRBjFIdb0i9Lvh4dxvl8D69
         3IM0sSB0Yg/G04MSKv7UgKJQVp04pI0CZNfd4pRvBexhxgRW2IcspIEB4gWfvb0f9bTB
         KKv1fYIzy02YXgfDCFohVHyRugCGijkkyDZ50OLkAFPohmW0A9LlMcKuP2UkYvlVfwMs
         8Gox2D8I66RmDmM6ub16zrBp5OEAz4HohMQ16PUUX0hY4MaEFoRMkhP7/YBOke/E+IU1
         uyP6lz5RlEZTM4DUFdpFAci1yzMwkdNjW8N1hfQktOBYCTbopQJgcGmfSAtQxCGGAX5S
         t9+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uQNthrJt0engSxAORExc/89EyYgck51IJRqnyXancJU=;
        b=R5lpkvf2HEubUmvBDvH6Xq1CVL9BzqYbuqwmwA1Oj5aurjDqsx5WNTLBppyk6jBNOy
         1nur1ygNSH/wjs9clBiShwGI0s7tTRMZPAZaPmdclXgk8jNUfIKNwNT7gIDpMCznkQjJ
         DZjk5bJcc7kSs5D+VxCA3KfNL3MJgSjJJG3eqzwnpeMPtBc9i6AWxJpwfMUsHEPfsxM8
         gQ7ggp9luO6ca/7DRfozSttDxVtEnMdcyFRv/Qfu6gzo4IZmEml5UCE9eOjCuqyasd8b
         QOMcnprKNX31CuJZeHZTDLs1vAVkp4gCMg5AMVkUc0B4rhzQgxGzDbFjZPceVBWooEUR
         M2rQ==
X-Gm-Message-State: AOAM530WcCuI/tgcu3DGxcfHN+WfxF3YMFa1GBG4XcVn/QhyDgHN6iyJ
        jHEYOtArzUHTSMX1cxMMojm61VC/436sUA==
X-Google-Smtp-Source: ABdhPJx+JGnfUojN64pAYjTE9z9Cb+Bm2nUS+/WmOLFACvZmLOs60TOQLiJSi8Jj7jTzsE1yYZV8yg==
X-Received: by 2002:a17:902:6b:b029:da:725b:fcea with SMTP id 98-20020a170902006bb02900da725bfceamr2516605pla.16.1607525161652;
        Wed, 09 Dec 2020 06:46:01 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y129sm2902301pfb.3.2020.12.09.06.46.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 06:46:01 -0800 (PST)
Message-ID: <5fd0e329.1c69fb81.f819e.5398@mx.google.com>
Date:   Wed, 09 Dec 2020 06:46:01 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.211-18-g5fff4d03d49d
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 114 runs,
 5 regressions (v4.14.211-18-g5fff4d03d49d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 114 runs, 5 regressions (v4.14.211-18-g5fff4=
d03d49d)

Regressions Summary
-------------------

platform                   | arch  | lab          | compiler | defconfig   =
        | regressions
---------------------------+-------+--------------+----------+-------------=
--------+------------
meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre | gcc-8    | defconfig   =
        | 1          =

meson-gxm-q200             | arm64 | lab-baylibre | gcc-8    | defconfig   =
        | 1          =

qemu_arm-versatilepb       | arm   | lab-baylibre | gcc-8    | versatile_de=
fconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-broonie  | gcc-8    | versatile_de=
fconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-cip      | gcc-8    | versatile_de=
fconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.211-18-g5fff4d03d49d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.211-18-g5fff4d03d49d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5fff4d03d49d9b4c718de482273d08204a45c1f5 =



Test Regressions
---------------- =



platform                   | arch  | lab          | compiler | defconfig   =
        | regressions
---------------------------+-------+--------------+----------+-------------=
--------+------------
meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre | gcc-8    | defconfig   =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0af39b7b96094b4c94cc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.211=
-18-g5fff4d03d49d/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s90=
5x-khadas-vim.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.211=
-18-g5fff4d03d49d/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s90=
5x-khadas-vim.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd0af39b7b96094b4c94=
cc7
        failing since 0 day (last pass: v4.14.210-25-gfd5af7f51219, first f=
ail: v4.14.211-18-g19a45ebf43bb) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
        | regressions
---------------------------+-------+--------------+----------+-------------=
--------+------------
meson-gxm-q200             | arm64 | lab-baylibre | gcc-8    | defconfig   =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0af04f4799f9dc6c94cd4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.211=
-18-g5fff4d03d49d/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.211=
-18-g5fff4d03d49d/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd0af04f4799f9dc6c94=
cd5
        failing since 0 day (last pass: v4.14.210-20-gc32b9f7cbda7, first f=
ail: v4.14.210-20-g5ea7913395d3) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
        | regressions
---------------------------+-------+--------------+----------+-------------=
--------+------------
qemu_arm-versatilepb       | arm   | lab-baylibre | gcc-8    | versatile_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0b0169628561f5dc94cd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.211=
-18-g5fff4d03d49d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.211=
-18-g5fff4d03d49d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd0b0169628561f5dc94=
cd2
        failing since 25 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
        | regressions
---------------------------+-------+--------------+----------+-------------=
--------+------------
qemu_arm-versatilepb       | arm   | lab-broonie  | gcc-8    | versatile_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0b17dfa24d413b2c94cca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.211=
-18-g5fff4d03d49d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.211=
-18-g5fff4d03d49d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd0b17dfa24d413b2c94=
ccb
        failing since 25 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
        | regressions
---------------------------+-------+--------------+----------+-------------=
--------+------------
qemu_arm-versatilepb       | arm   | lab-cip      | gcc-8    | versatile_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0b01f9628561f5dc94ce8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.211=
-18-g5fff4d03d49d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.211=
-18-g5fff4d03d49d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd0b01f9628561f5dc94=
ce9
        failing since 25 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =20
