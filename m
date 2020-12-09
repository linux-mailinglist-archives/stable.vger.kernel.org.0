Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4B02D37C9
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 01:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731719AbgLIA2u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Dec 2020 19:28:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730656AbgLIA2o (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Dec 2020 19:28:44 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E070DC0613CF
        for <stable@vger.kernel.org>; Tue,  8 Dec 2020 16:28:03 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id q22so256599pfk.12
        for <stable@vger.kernel.org>; Tue, 08 Dec 2020 16:28:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2BHHhzRuUQPUOqfuLsoQo4516EZWCt2RmMMSxBXsM08=;
        b=ExAPQw891BwSpqSK4F2bfIdewWXtZL/jf3Ba4jV3zKUrbZDCsuAlJZfQKZFAOpifbh
         lRkWcUnX8AGBaYzmKz8Lzi3HXRf0ohCMMY8yvZIZ01O0GT8b5WxWdv3Teww73mhv0lOg
         dh2uOfXWCYEYqbfYGXr5dvdAUvcpkmLyfe2zfweHl85svhzVv8TeV3OWT2mNtZjjs2l0
         m3Kv4O+IIR7oF/UtVVJYw1+A5y/Msvhi92AtnXVpdaeGg1aFjqdIf1TpYvik6LcU2MW/
         puqOh8PanwoObD8EEzabBqx0AoW3zRDymKSWlXShMgNw3XpqWZTZpJlrt/PEzhe9A0hh
         BG2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2BHHhzRuUQPUOqfuLsoQo4516EZWCt2RmMMSxBXsM08=;
        b=GU3cvPseQ2kN9XM742AtwlyufncPgOxpdR7I3Y/p/2NkJxq3CLPoe9FV3keE2W79o5
         jAJq0aE+FKqdt7us9TUNvJAsP57yYk/D41fgAAvniSxGt1Bs3/FB9YmskFZlQNITczPO
         mZ5KisGAtHYH8gR9HINmtA5bY0OgKdLdT0vdMaSN4Mhwnyz1UPEa/zAPVIT8VT/cUD+c
         Cq3qztFvz44ctZvQ9RxtnfG8VfWZRzbAr5Y2F65Pd7uT0Zh7gNLmq2pBSs2BqmAT8PxO
         3EYZXvPLYuFQzAg0s4s/rJgnuz5+JYSGub19zhuHzNHKFJwxZjQJxd7bcL4XEok8gXJK
         pbBQ==
X-Gm-Message-State: AOAM5333BMVDHgInRv+2gQ31t4jj+OEKZjy/UDxR0pIK8HsIAmumYo2n
        MbOF00MapMntkhjreRmIQDJ5zbm52PALvA==
X-Google-Smtp-Source: ABdhPJxQFa1lbyFACTJaVstNR1p9Bpw1Jmm/ek/YQnEJYLGHNwocbtnxIDUzg+26dtLmykF+ZSFqLw==
X-Received: by 2002:a62:1c93:0:b029:198:1c0a:ea71 with SMTP id c141-20020a621c930000b02901981c0aea71mr319550pfc.22.1607473682931;
        Tue, 08 Dec 2020 16:28:02 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h7sm322781pfr.210.2020.12.08.16.28.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 16:28:02 -0800 (PST)
Message-ID: <5fd01a12.1c69fb81.bd949.0e94@mx.google.com>
Date:   Tue, 08 Dec 2020 16:28:02 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.82
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.4.y baseline: 182 runs, 10 regressions (v5.4.82)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 182 runs, 10 regressions (v5.4.82)

Regressions Summary
-------------------

platform               | arch   | lab           | compiler | defconfig     =
      | regressions
-----------------------+--------+---------------+----------+---------------=
------+------------
at91-sama5d4_xplained  | arm    | lab-baylibre  | gcc-8    | sama5_defconfi=
g     | 1          =

hifive-unleashed-a00   | riscv  | lab-baylibre  | gcc-8    | defconfig     =
      | 1          =

meson-gxm-q200         | arm64  | lab-baylibre  | gcc-8    | defconfig     =
      | 2          =

qemu_arm-versatilepb   | arm    | lab-baylibre  | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb   | arm    | lab-broonie   | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb   | arm    | lab-cip       | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb   | arm    | lab-collabora | gcc-8    | versatile_defc=
onfig | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconf=
ig    | 1          =

rk3288-veyron-jaq      | arm    | lab-collabora | gcc-8    | multi_v7_defco=
nfig  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.82/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.82
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ec274ecd62f9e0404c935ff073346d243d5082e6 =



Test Regressions
---------------- =



platform               | arch   | lab           | compiler | defconfig     =
      | regressions
-----------------------+--------+---------------+----------+---------------=
------+------------
at91-sama5d4_xplained  | arm    | lab-baylibre  | gcc-8    | sama5_defconfi=
g     | 1          =


  Details:     https://kernelci.org/test/plan/id/5fcfe793ca3e835959c94cc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.82/=
arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.82/=
arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fcfe793ca3e835959c94=
cc9
        failing since 241 days (last pass: v5.4.30-54-g6f04e8ca5355, first =
fail: v5.4.30-81-gf163418797b9) =

 =



platform               | arch   | lab           | compiler | defconfig     =
      | regressions
-----------------------+--------+---------------+----------+---------------=
------+------------
hifive-unleashed-a00   | riscv  | lab-baylibre  | gcc-8    | defconfig     =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/5fcfe5f5743ad890bbc94cca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.82/=
riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.82/=
riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fcfe5f5743ad890bbc94=
ccb
        failing since 18 days (last pass: v5.4.77-152-ga3746663c3479, first=
 fail: v5.4.78) =

 =



platform               | arch   | lab           | compiler | defconfig     =
      | regressions
-----------------------+--------+---------------+----------+---------------=
------+------------
meson-gxm-q200         | arm64  | lab-baylibre  | gcc-8    | defconfig     =
      | 2          =


  Details:     https://kernelci.org/test/plan/id/5fcfe4e2be61c79421c94cd9

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.82/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.82/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/5fcfe4e2be61c79=
421c94cdd
        new failure (last pass: v5.4.81-40-g08a1fd1f5653)
        10 lines

    2020-12-08 20:41:01.168000+00:00  kern  :alert : Mem abort info:
    2020-12-08 20:41:01.168000+00:00  kern  :alert :   ESR =3D 0x96000004
    2020-12-08 20:41:01.208000+00:00  kern  :alert :   EC =3D 0x25: DABT (c=
urrent EL), IL =3D 32 bits
    2020-12-08 20:41:01.208000+00:00  kern  :alert :   SET =3D 0, FnV =3D 0
    2020-12-08 20:41:01.209000+00:00  kern  :alert :   EA =3D 0, S1PTW =3D 0
    2020-12-08 20:41:01.209000+00:00  kern  :alert : Data abort info:
    2020-12-08 20:41:01.209000+00:00  kern  :alert :   ISV =3D 0, ISS =3D 0=
x00000004
    2020-12-08 20:41:01.209000+00:00  kern  :alert :   CM =3D 0, WnR =3D 0
    2020-12-08 20:41:01.210000+00:00  kern  :alert : [000a000048348830] add=
ress between user and kernel address ranges   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fcfe4e2be61c79=
421c94cde
        new failure (last pass: v5.4.81-40-g08a1fd1f5653)
        2 lines

    2020-12-08 20:41:01.211000+00:00  kern  :emerg : Code: 90007f23 d2e0800=
4 eb04001f f9468460 (f9400021) =

    2020-12-08 20:41:01.234000+00:00  + set +x   =

 =



platform               | arch   | lab           | compiler | defconfig     =
      | regressions
-----------------------+--------+---------------+----------+---------------=
------+------------
qemu_arm-versatilepb   | arm    | lab-baylibre  | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fcfe4cb6a2375c08ac94cc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.82/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.82/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fcfe4cb6a2375c08ac94=
cc1
        failing since 24 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform               | arch   | lab           | compiler | defconfig     =
      | regressions
-----------------------+--------+---------------+----------+---------------=
------+------------
qemu_arm-versatilepb   | arm    | lab-broonie   | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fcfe4e14786a07c22c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.82/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.82/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fcfe4e14786a07c22c94=
cba
        failing since 24 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform               | arch   | lab           | compiler | defconfig     =
      | regressions
-----------------------+--------+---------------+----------+---------------=
------+------------
qemu_arm-versatilepb   | arm    | lab-cip       | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fcfe514e84d4d097ec94ccb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.82/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.82/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fcfe514e84d4d097ec94=
ccc
        failing since 24 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform               | arch   | lab           | compiler | defconfig     =
      | regressions
-----------------------+--------+---------------+----------+---------------=
------+------------
qemu_arm-versatilepb   | arm    | lab-collabora | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fcfe54889444ca81ec94d36

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.82/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.82/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fcfe54889444ca81ec94=
d37
        failing since 24 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform               | arch   | lab           | compiler | defconfig     =
      | regressions
-----------------------+--------+---------------+----------+---------------=
------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconf=
ig    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fcfe5ae3f1f1b46ebc94cc4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.82/=
x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64-uefi-mixed.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.82/=
x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64-uefi-mixed.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fcfe5ae3f1f1b46ebc94=
cc5
        new failure (last pass: v5.4.81-40-g08a1fd1f5653) =

 =



platform               | arch   | lab           | compiler | defconfig     =
      | regressions
-----------------------+--------+---------------+----------+---------------=
------+------------
rk3288-veyron-jaq      | arm    | lab-collabora | gcc-8    | multi_v7_defco=
nfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fcfe80c0385c25f59c94cd9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.82/=
arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.82/=
arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fcfe80c0385c25f59c94=
cda
        new failure (last pass: v5.4.81-40-g08a1fd1f5653) =

 =20
