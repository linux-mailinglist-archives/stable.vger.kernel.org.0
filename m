Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFB6332D3A9
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 13:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237427AbhCDMxG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 07:53:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237637AbhCDMwz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 07:52:55 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 434DAC061756
        for <stable@vger.kernel.org>; Thu,  4 Mar 2021 04:52:15 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id l18so6866523pji.3
        for <stable@vger.kernel.org>; Thu, 04 Mar 2021 04:52:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8bxz3waUe6ZfZIElZFBEOUJS9BK6oUh02KZphWFQu+k=;
        b=Ra+zlAV7VBW5UkiLvXrUKICRgFqrsIbPl7ZcnUinuHJhflCBqRIfy0kokojxwgn0HF
         9vGH0evWOlREeppgcnpTSYyezkhu7fkAFAbTgcEcy5JeoonkTc4YHLOOjj+qqIssiOnG
         0QBHTg8rZAiVCpo+ANT1An8Nc6NkCMhSKWqG8syDz6DrBhbTRycXG/NonbuzoDTfam3k
         ZifnW9+CXVcNXldh/Hk52GtniGXFWxsD8ja56SZXa+RypZ57Gwj9gUOSWABEB4Y31F9h
         pF98mRAPbkObGM+3AXCMECndbBrLtIFfFa+NjCgyHk/HVif+GqHO8glBfUbAOhx0vXq1
         hZNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8bxz3waUe6ZfZIElZFBEOUJS9BK6oUh02KZphWFQu+k=;
        b=h25KFVWndUXhgLQksCyGkGuEvy12LAFrY/pTrM3PVTgnWYmckAKEhJb58AL4LEXlUv
         daiH8z4yX2yPJXZd4QOtjGLis0rAvsAJqShgnqD1rYBHvaOyTI++cEFGztHwSZGaoqf2
         0P5Je/EmScVHf5ZIwg8V8afQUxp0VVUqjDlo5cmcl8zwBLIeZEJq2CIMmbKggke/B4Cj
         0HkU/sYcDs3iMhL/EeTecPiBuPnqAy6UjM3fH41b5BJqQafNZtcv/Y4JWb57bVywyK27
         r/ExF4XF1/NCWmE5O2CkbXBGQ1W2QFc7ZK7Gk5DQLUX7Poso3s/WamnwpReIfcYKOmFO
         jMnQ==
X-Gm-Message-State: AOAM530L2Ru9c9AQRy+jUAyftpp+bomEGvVKzBcDUPjhve6RXM1HyJ5p
        TwmpjkCdYJN4fCnATCqAf9gm0p+y619qlTtv
X-Google-Smtp-Source: ABdhPJyfZ+VYwPelxr4rcIoMu/W+DOkIDAAnSdn2q1zZsQe6xsxMpsVVprHKDv1A2jNlaoZq0pJ4eA==
X-Received: by 2002:a17:902:d64f:b029:e3:8ef6:1775 with SMTP id y15-20020a170902d64fb02900e38ef61775mr3998119plh.28.1614862334537;
        Thu, 04 Mar 2021 04:52:14 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id cp22sm9637417pjb.15.2021.03.04.04.52.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 04:52:14 -0800 (PST)
Message-ID: <6040d7fe.1c69fb81.2d981.570c@mx.google.com>
Date:   Thu, 04 Mar 2021 04:52:14 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.101-337-g43f5d6aa0971d
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 178 runs,
 9 regressions (v5.4.101-337-g43f5d6aa0971d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 178 runs, 9 regressions (v5.4.101-337-g43f5d6=
aa0971d)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =

meson-gxm-q200       | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 3          =

qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.101-337-g43f5d6aa0971d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.101-337-g43f5d6aa0971d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      43f5d6aa0971d6405b6d57a1c0f5e7d8c923f038 =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/60409feb00a7900a76addcbf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-3=
37-g43f5d6aa0971d/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-3=
37-g43f5d6aa0971d/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60409feb00a7900a76add=
cc0
        failing since 103 days (last pass: v5.4.78-5-g843222460ebea, first =
fail: v5.4.78-13-g81acf0f7c6ec) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
meson-gxm-q200       | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 3          =


  Details:     https://kernelci.org/test/plan/id/6040a42ef8392b9b43addccf

  Results:     1 PASS, 3 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-3=
37-g43f5d6aa0971d/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-3=
37-g43f5d6aa0971d/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/6040a42ef8392b9b=
43addcd2
        new failure (last pass: v5.4.101-336-g3c46b38d7ba7)
        1 lines

    2021-03-04 09:08:58.393000+00:00  Connected to meson-gxm-q200 console [=
channel connected] (~$quit to exit)
    2021-03-04 09:08:58.394000+00:00  (user:khilman) is already connected
    2021-03-04 09:09:10.328000+00:00  GXM:BL1:dc8b51:76f1a5;FEAT:ADFC318C:0=
;POC:3;RCY:0;EMMC:0;READ:0;CHK:AA;SD:0;READ:0;0.0;CHK:0;
    2021-03-04 09:09:10.328000+00:00  no sdio debug board detected =

    2021-03-04 09:09:10.328000+00:00  TE: 314975
    2021-03-04 09:09:10.329000+00:00  =

    2021-03-04 09:09:10.329000+00:00  BL2 Built : 11:58:42, May 27 2017. =

    2021-03-04 09:09:10.329000+00:00  gxl gc3c9a84 - xiaobo.gu@droid05
    2021-03-04 09:09:10.329000+00:00  =

    2021-03-04 09:09:10.329000+00:00  set vcck to 1120 mv =

    ... (600 line(s) more)  =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/6040a42ef8392b9=
b43addcd3
        new failure (last pass: v5.4.101-336-g3c46b38d7ba7)
        11 lines

    2021-03-04 09:09:59.641000+00:00  kern  :alert :   EC =3D 0x25: DABT (c=
urrent EL), IL =3D 32 bits
    2021-03-04 09:09:59.642000+00:00  kern  :alert :   SET =3D 0, FnV =3D 0
    2021-03-04 09:09:59.642000+00:00  kern  :alert :   EA =3D 0, S1PTW =3D 0
    2021-03-04 09:09:59.642000+00:00  kern  :alert : Data abort info:
    2021-03-04 09:09:59.642000+00:00  kern  :a<8>[   16.446134] <LAVA_SIGNA=
L_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>
    2021-03-04 09:09:59.642000+00:00  lert :   ISV <8>[   16.455445] <LAVA_=
SIGNAL_ENDRUN 0_dmesg 781450_1.5.2.4.1>
    2021-03-04 09:09:59.642000+00:00  =3D 0, ISS =3D 0x00000005   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6040a42ef8392b9=
b43addcd4
        new failure (last pass: v5.4.101-336-g3c46b38d7ba7)
        4 lines =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6040a12b713910375baddcc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-3=
37-g43f5d6aa0971d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-3=
37-g43f5d6aa0971d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6040a12b713910375badd=
cca
        failing since 110 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6040d4a2a910367216addcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-3=
37-g43f5d6aa0971d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-3=
37-g43f5d6aa0971d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6040d4a2a910367216add=
cb2
        failing since 110 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6040a16541133969a0addcd8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-3=
37-g43f5d6aa0971d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-3=
37-g43f5d6aa0971d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6040a16541133969a0add=
cd9
        failing since 110 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6040a179746159582faddce6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-3=
37-g43f5d6aa0971d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-3=
37-g43f5d6aa0971d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6040a179746159582fadd=
ce7
        failing since 110 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6040a0cc8c070dce35addcfe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-3=
37-g43f5d6aa0971d/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-3=
37-g43f5d6aa0971d/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6040a0cc8c070dce35add=
cff
        failing since 110 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =20
