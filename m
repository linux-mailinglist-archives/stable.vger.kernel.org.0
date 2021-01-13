Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E91322F4B82
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 13:45:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbhAMMnW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 07:43:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbhAMMnW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jan 2021 07:43:22 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC273C061786
        for <stable@vger.kernel.org>; Wed, 13 Jan 2021 04:42:41 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id d4so1006742plh.5
        for <stable@vger.kernel.org>; Wed, 13 Jan 2021 04:42:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xzne1lRbqoudj9PN5wZJYKcyu9bF1bIiSbJvShnV9Fw=;
        b=luurNLn8sPyCNwuiRps+Xv6k1g7fcr+tiP/jRqR//kzXqooUR+XCtICM0PSnzebyFO
         VslZ/C7odIiOonrqpcMUFEhgtoyany7jUxt8EAy8BpdAZJZvEfP8vs0ldbC2niJoKwjt
         GA3Z8Qsv3te52NG05K0eTmblbAeS32Fxugp7u0UGZG5rkqaGTR7skQJiYuiOnIiftRpk
         KxNdvJCgQ5o/IF2ttXN/MbpRX/a7JXKPGZX9sYSUf1C+rlCmd5Kb5jVh14lwMhwB5nIT
         ySTYl8O39AZgkmQCDSiwA70Kmg37IQqr7IMRqL2bx5IpFCueeyrMgtimoH0mCZGcYRnv
         zVnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xzne1lRbqoudj9PN5wZJYKcyu9bF1bIiSbJvShnV9Fw=;
        b=WZlMTITioUgpCNVFAq/6goHlZKpqsyUMISgZbdxpaVgV9XOQJBVC8GVhG23uKUWAT1
         s3c2kD8L2rTOvwkDRuR10ZnSmRBEeml1s3sb4irsd1WoJQtedyuYEXV9vGSyl6hTdmWr
         t+2MxfTkqH49vDAwFFEW+qFK864ZthxSiQ1/NojGAyMlCXKA3r9Y2uItK4c9xCCjQTel
         tyAjcm4efGiHQEPnvM45se1fPZoT5H4oAkaKrEXFom4DXgV5xc/hczUA0uqCxTSwE0Ul
         ZwViYhcvyn4/8LJGX8hUrdtWm0l4LAh8yvCrdMLAqPg4qN+Z0X9u9FwjKkOQzLCooa6K
         akcg==
X-Gm-Message-State: AOAM531Vn/DrsfDvSAjM8Ode+lphH/w2LKqVkygx2eRV2/eCJQZ9O6y9
        ItB9tDQrmijgYzdq0hSZGQiNbQ7KpqvCGA==
X-Google-Smtp-Source: ABdhPJwpRQind6X6fNR+LOTyK91e42oM8h8rAInJPe6hbdPG4IeJVBCNa6MHwcArgs2nTfzYNQrjDQ==
X-Received: by 2002:a17:902:9342:b029:dc:4868:d9af with SMTP id g2-20020a1709029342b02900dc4868d9afmr2017429plp.33.1610541761045;
        Wed, 13 Jan 2021 04:42:41 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w11sm2616049pge.28.2021.01.13.04.42.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 04:42:40 -0800 (PST)
Message-ID: <5ffeeac0.1c69fb81.affbd.4d9b@mx.google.com>
Date:   Wed, 13 Jan 2021 04:42:40 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.4.89
X-Kernelci-Report-Type: test
Subject: stable/linux-5.4.y baseline: 197 runs, 10 regressions (v5.4.89)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 197 runs, 10 regressions (v5.4.89)

Regressions Summary
-------------------

platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
bcm2837-rpi-3-b-32         | arm   | lab-baylibre    | gcc-8    | bcm2835_d=
efconfig   | 2          =

hifive-unleashed-a00       | riscv | lab-baylibre    | gcc-8    | defconfig=
           | 1          =

meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre    | gcc-8    | defconfig=
           | 1          =

qemu_arm-versatilepb       | arm   | lab-baylibre    | gcc-8    | versatile=
_defconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-broonie     | gcc-8    | versatile=
_defconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-cip         | gcc-8    | versatile=
_defconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-collabora   | gcc-8    | versatile=
_defconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-linaro-lkft | gcc-8    | versatile=
_defconfig | 1          =

qemu_i386                  | i386  | lab-baylibre    | gcc-8    | i386_defc=
onfig      | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.89/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.89
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      a829146c3fdcf6d0b76d9c54556a223820f1f73b =



Test Regressions
---------------- =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
bcm2837-rpi-3-b-32         | arm   | lab-baylibre    | gcc-8    | bcm2835_d=
efconfig   | 2          =


  Details:     https://kernelci.org/test/plan/id/5ffe684bff4c21cb98c94d00

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.89/arm=
/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.89/arm=
/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/5ffe684bff4c21c=
b98c94d04
        new failure (last pass: v5.4.88)
        4 lines

    2021-01-13 03:25:50.786000+00:00  kern  :alert : Unable to handle kerne=
l NULL pointer dereference at virtual address 00000000
    2021-01-13 03:25:50.787000+00:00  <8>[   13.812931] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>
    2021-01-13 03:25:50.788000+00:00  kern  :alert : pgd =3D b35e14b1   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5ffe684bff4c21c=
b98c94d05
        new failure (last pass: v5.4.88)
        28 lines

    2021-01-13 03:25:50.831000+00:00  kern  :emerg : Internal error: Oops: =
17 [#1] ARM
    2021-01-13 03:25:50.832000+00:00  kern  :emerg : Process udevd (pid: 89=
, stack limit =3D 0xe67c5b4f)
    2021-01-13 03:25:50.833000+00:00  kern<8>[   13.855551] <LAVA_SIGNAL_TE=
STCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D28>
    2021-01-13 03:25:50.834000+00:00    :emerg : Stack: (0xeae<8>[   13.866=
206] <LAVA_SIGNAL_ENDRUN 0_dmesg 579097_1.5.2.4.1>
    2021-01-13 03:25:50.835000+00:00  2bd10 to 0xeae2c000)
    2021-01-13 03:25:50.836000+00:00  kern  :emerg : bd00:                 =
                    c0d04248 00000000 00000040 c024a260   =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
hifive-unleashed-a00       | riscv | lab-baylibre    | gcc-8    | defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffe6903850032ac54c94cf5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.89/ris=
cv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.89/ris=
cv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffe6903850032ac54c94=
cf6
        failing since 55 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre    | gcc-8    | defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffe6b92406eef982ac94ce1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.89/arm=
64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905x-khadas-vim.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.89/arm=
64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905x-khadas-vim.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffe6b92406eef982ac94=
ce2
        new failure (last pass: v5.4.88) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-baylibre    | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffe680c1230ffb92ec94cdc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.89/arm=
/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.89/arm=
/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffe680c1230ffb92ec94=
cdd
        failing since 55 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-broonie     | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffe681625628900d0c94cd9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.89/arm=
/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.89/arm=
/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffe681625628900d0c94=
cda
        failing since 55 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-cip         | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffe68082ce3b62618c94d08

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.89/arm=
/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.89/arm=
/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffe68082ce3b62618c94=
d09
        failing since 55 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-collabora   | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffe6e17e9d8addd3dc94d29

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.89/arm=
/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.89/arm=
/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffe6e17e9d8addd3dc94=
d2a
        failing since 55 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-linaro-lkft | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffe67c89e239c2cb5c94cdf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.89/arm=
/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.89/arm=
/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffe67c89e239c2cb5c94=
ce0
        failing since 55 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_i386                  | i386  | lab-baylibre    | gcc-8    | i386_defc=
onfig      | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffe671bcda1923510c94ce9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.89/i38=
6/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.89/i38=
6/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffe671bcda1923510c94=
cea
        new failure (last pass: v5.4.88) =

 =20
