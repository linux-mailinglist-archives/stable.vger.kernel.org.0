Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 449D12B813E
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 16:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbgKRPyt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 10:54:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbgKRPyt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Nov 2020 10:54:49 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBB8FC0613D4
        for <stable@vger.kernel.org>; Wed, 18 Nov 2020 07:54:48 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id f18so1459459pgi.8
        for <stable@vger.kernel.org>; Wed, 18 Nov 2020 07:54:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uIGfexo2tve8Q7kZNPJFlT+tS7ta9UfNZBiAphjaByA=;
        b=Xzlvto8HU2DnmmXmJM7852oTpPutkxUJ7W3PYHNFjehYgQVHLTKYAExeC9y7D9cri0
         SH01FSxyWUEiED2VpUQLkV/AMm9nFdBPK+qhaL6hS/Ym1f+vGdXLkMw4geVTzFhd0jdA
         9eyzdkxqE+ImCPNtjM3YDHBDQXSnuj88XJVl2DvC6lMnlYbkRitGV4LqW/S99oEcN1fH
         890aIycuQFUO9FwBHuL18coqQAES7CnL/Um2xgBLiLmuXN+qEHDiMOGqLVqdfgrG9uVV
         cGNel+9l+Kgh+gZD6Kvht/NQrwnUnQ45X4GLo7BR34W193ulB04nWHR1n0dyVKTueJuw
         i2Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uIGfexo2tve8Q7kZNPJFlT+tS7ta9UfNZBiAphjaByA=;
        b=aP87XoEgV5/ee6MJ6fCvtUz/9ztBtsJakZbUc/cfBWKhGMM5wJ2sgy93ZQ/VtQ8+z3
         +bWbAlBn+4cR7WjbyLXr5lVIt+q+N+Ye9mOukkErQ6r9x4eDobfPylcmX/52HkE+f/Cl
         R57VofXbvrO974Wv8FKb+Sm5qAOL5wylVshhZ+YYdoxMUaonMqw8DdJy07GO5WUvIMRA
         OfobKe8AcHr0Ptw42Tb4AAXXjf5+hBXgmaql3h7fSXi1TPSniVLk+ns1+xvoOtE7gKQu
         gTN9+neO2Au/6NJGRMXjitFHhBKDXEkNo+Z9dfWXGpia2HeIocfqmSgi89VZr2v+l7v4
         o/4A==
X-Gm-Message-State: AOAM533vbzH7JOXezWQ4h637FkdLijPR/Y/rq9aLivzR8+0Egv6ZTJip
        T3TLkIxY2RDANyfeKS1/4nk8PnS033HLsQ==
X-Google-Smtp-Source: ABdhPJwTRkGL+X/hNcnNACzE8NF2sBwVmwkNTk4ZDot8qYSqC7gTbeJF6nOmeCy1FQzjHtG+SSP8hg==
X-Received: by 2002:a62:6586:0:b029:164:1cb9:8aff with SMTP id z128-20020a6265860000b02901641cb98affmr5440755pfb.64.1605714887712;
        Wed, 18 Nov 2020 07:54:47 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m6sm25515798pfa.61.2020.11.18.07.54.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 07:54:46 -0800 (PST)
Message-ID: <5fb543c6.1c69fb81.4f3b7.77f0@mx.google.com>
Date:   Wed, 18 Nov 2020 07:54:46 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.77-150-gf13a1c15d0a0
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 199 runs,
 9 regressions (v5.4.77-150-gf13a1c15d0a0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 199 runs, 9 regressions (v5.4.77-150-gf13a1c1=
5d0a0)

Regressions Summary
-------------------

platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
at91-sama5d4_xplained | arm   | lab-baylibre    | gcc-8    | sama5_defconfi=
g     | 1          =

hifive-unleashed-a00  | riscv | lab-baylibre    | gcc-8    | defconfig     =
      | 1          =

meson-gxm-q200        | arm64 | lab-baylibre    | gcc-8    | defconfig     =
      | 1          =

qemu_arm-versatilepb  | arm   | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb  | arm   | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb  | arm   | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb  | arm   | lab-collabora   | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb  | arm   | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =

stm32mp157c-dk2       | arm   | lab-baylibre    | gcc-8    | multi_v7_defco=
nfig  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.77-150-gf13a1c15d0a0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.77-150-gf13a1c15d0a0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f13a1c15d0a0603a33b889cab2a021acc7ca7592 =



Test Regressions
---------------- =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
at91-sama5d4_xplained | arm   | lab-baylibre    | gcc-8    | sama5_defconfi=
g     | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb50efa18f0f49119d8d92b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-15=
0-gf13a1c15d0a0/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-15=
0-gf13a1c15d0a0/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb50efa18f0f49119d8d=
92c
        failing since 20 days (last pass: v5.4.72-409-gbbe9df5e07cf, first =
fail: v5.4.72-409-ga6e47f533653) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
hifive-unleashed-a00  | riscv | lab-baylibre    | gcc-8    | defconfig     =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb50f18ce5f8cb6fcd8d925

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-15=
0-gf13a1c15d0a0/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashe=
d-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-15=
0-gf13a1c15d0a0/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashe=
d-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb50f18ce5f8cb6fcd8d=
926
        failing since 4 days (last pass: v5.4.77-44-gce6b18c3a8969, first f=
ail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
meson-gxm-q200        | arm64 | lab-baylibre    | gcc-8    | defconfig     =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb526cba0659bdd0bd8d934

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-15=
0-gf13a1c15d0a0/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-15=
0-gf13a1c15d0a0/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb526cba0659bdd0bd8d=
935
        new failure (last pass: v5.4.77-150-g50ea73ff14b98) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb50d02d8805a045bd8d916

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-15=
0-gf13a1c15d0a0/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-15=
0-gf13a1c15d0a0/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb50d02d8805a045bd8d=
917
        failing since 4 days (last pass: v5.4.77-44-gce6b18c3a8969, first f=
ail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb50d09d8805a045bd8d925

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-15=
0-gf13a1c15d0a0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-15=
0-gf13a1c15d0a0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb50d09d8805a045bd8d=
926
        failing since 4 days (last pass: v5.4.77-44-gce6b18c3a8969, first f=
ail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb50d0ad8805a045bd8d928

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-15=
0-gf13a1c15d0a0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-15=
0-gf13a1c15d0a0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb50d0ad8805a045bd8d=
929
        failing since 4 days (last pass: v5.4.77-44-gce6b18c3a8969, first f=
ail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-collabora   | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb50cc8fbc87424f2d8d90b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-15=
0-gf13a1c15d0a0/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-15=
0-gf13a1c15d0a0/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb50cc8fbc87424f2d8d=
90c
        failing since 4 days (last pass: v5.4.77-44-gce6b18c3a8969, first f=
ail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb50cd317c347f86bd8d929

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-15=
0-gf13a1c15d0a0/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-15=
0-gf13a1c15d0a0/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb50cd317c347f86bd8d=
92a
        failing since 4 days (last pass: v5.4.77-44-gce6b18c3a8969, first f=
ail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
stm32mp157c-dk2       | arm   | lab-baylibre    | gcc-8    | multi_v7_defco=
nfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb50f9ee206b2c7b9d8d926

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-15=
0-gf13a1c15d0a0/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-15=
0-gf13a1c15d0a0/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb50f9ee206b2c7b9d8d=
927
        failing since 23 days (last pass: v5.4.72-54-gc97bc0eb3ef2, first f=
ail: v5.4.72-402-g22eb6f319bc6) =

 =20
