Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5DEB453D16
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 01:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbhKQAWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 19:22:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhKQAWw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 19:22:52 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E0DFC061570
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 16:19:55 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id o6-20020a17090a0a0600b001a64b9a11aeso915054pjo.3
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 16:19:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nd0VHT0dHgeYoSHec5B7f6xJ4gfA7Qk/bpl1alxyLSM=;
        b=KzAIW9W3TLqMMRWH/VZHwbRnQEtq9ke7eJ9Obv77DbP+kAeCSLm2d8R5tVDGaVfM0n
         YDw4F2+SCzVxC/Pz+IVCzdIaVoJtJrG39p2D22usJYZwleosUGloeY2TPw2af7gS63UZ
         ET8tqhBLWX2aFExwwhg31iSD1pEfm2P3u7G56qK5Fx5prMxIAtEL8wJsg0hV5vMo/VGj
         iwVSJBOwZBotslFsDB6/LlcI4HuM+/kdM7Qpvt4ZzMOyTPpHRYUn3DGVNYxL/m7HmVbD
         n6D2Sqezbk7hTe6CdL+OPcCzeKStPudkvCGnfXYanDrbprIxim370+uWawcSew5W7l/m
         hQQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nd0VHT0dHgeYoSHec5B7f6xJ4gfA7Qk/bpl1alxyLSM=;
        b=gLo+KOz/A/q/0yjzaVRClP6gT7fcPMJOdv6pMQewMNqpNxUg3iZAXYsdEGkdBiggOz
         zhcoBRv55AGbjeHNXxTFc1nt/4D0VBgnFXRYp0EiD4Cd47hqCbMNU4i3jXAhOEls2jPk
         32k9gVhfOfLHKOiVXwSE4lKdbMoPlFPvr3CYYlWf/nuyBCw4XhNMgHc1CgdPM/l3CSBU
         G/zskQ9GYbg+H9R+XftOBXXDHFGCj3PFwBV4sGZIcyAniLOiknn3ho4mg0QS7gJMp530
         UtCVxdZG8/lQZtZpEo/AmVU0orJdjWOknhrI3sRoWDJBmYKVRHbnWMPCz8G35/GOoUxY
         XV7w==
X-Gm-Message-State: AOAM532GAm2ogusbfY2q7EVFL1/BOy1b2Ez9cedKv0QiqKujgA6sZzbv
        AAv+7RRhaQz0p0guwilok8O+NH5nWi9hOdYS
X-Google-Smtp-Source: ABdhPJwySi4ULNdmQts7d3CywqmPkw+ZohXuYEnVbwI78AC20HSolS1nEs8pqn9y+HPVrh4TkEKPOw==
X-Received: by 2002:a17:902:ea11:b0:141:c6c8:823a with SMTP id s17-20020a170902ea1100b00141c6c8823amr49569852plg.29.1637108393518;
        Tue, 16 Nov 2021 16:19:53 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b18sm3248827pjo.31.2021.11.16.16.19.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 16:19:53 -0800 (PST)
Message-ID: <61944aa9.1c69fb81.31801.a16a@mx.google.com>
Date:   Tue, 16 Nov 2021 16:19:53 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.2-928-gcb98d6b416c1a
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.15.y baseline: 91 runs,
 40 regressions (v5.15.2-928-gcb98d6b416c1a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.15.y baseline: 91 runs, 40 regressions (v5.15.2-928-gcb98=
d6b416c1a)

Regressions Summary
-------------------

platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
fsl-ls1028a-rdb              | arm64 | lab-nxp         | gcc-10   | defconf=
ig | 1          =

imx8mn-ddr4-evk              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =

imx8mn-ddr4-evk              | arm64 | lab-nxp         | gcc-10   | defconf=
ig | 1          =

imx8mp-evk                   | arm64 | lab-nxp         | gcc-10   | defconf=
ig | 1          =

kontron-pitx-imx8m           | arm64 | lab-kontron     | gcc-10   | defconf=
ig | 1          =

meson-g12a-sei510            | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =

meson-g12a-u200              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =

meson-g12a-x96-max           | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =

meson-g12b-a311d-khadas-vim3 | arm64 | lab-collabora   | gcc-10   | defconf=
ig | 1          =

meson-g12b-odroid-n2         | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =

meson-gxl-s905d-p230         | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =

meson-gxl-s905x-khadas-vim   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =

meson-gxl-s905x-libretech-cc | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =

meson-sm1-khadas-vim3l       | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =

meson-sm1-sei610             | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =

mt8173-elm-hana              | arm64 | lab-collabora   | gcc-10   | defconf=
ig | 1          =

mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora   | gcc-10   | defconf=
ig | 1          =

qcom-qdf2400                 | arm64 | lab-linaro-lkft | gcc-10   | defconf=
ig | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-broonie     | gcc-10   | defconf=
ig | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-cip         | gcc-10   | defconf=
ig | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie     | gcc-10   | defconf=
ig | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-cip         | gcc-10   | defconf=
ig | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-broonie     | gcc-10   | defconf=
ig | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-cip         | gcc-10   | defconf=
ig | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie     | gcc-10   | defconf=
ig | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-cip         | gcc-10   | defconf=
ig | 1          =

r8a774a1-hihope-rzg2m-ex     | arm64 | lab-cip         | gcc-10   | defconf=
ig | 1          =

r8a774b1-hihope-rzg2n-ex     | arm64 | lab-cip         | gcc-10   | defconf=
ig | 1          =

r8a774c0-ek874               | arm64 | lab-cip         | gcc-10   | defconf=
ig | 1          =

r8a77960-ulcb                | arm64 | lab-collabora   | gcc-10   | defconf=
ig | 1          =

rk3399-gru-kevin             | arm64 | lab-collabora   | gcc-10   | defconf=
ig | 1          =

sun50i-a64-pine64-plus       | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =

sun50i-h5-lib...ch-all-h3-cc | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =

sun50i-h6-pine-h64           | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =

sun50i-h6-pine-h64           | arm64 | lab-collabora   | gcc-10   | defconf=
ig | 1          =

zynqmp-zcu102                | arm64 | lab-cip         | gcc-10   | defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.2-928-gcb98d6b416c1a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.2-928-gcb98d6b416c1a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cb98d6b416c1a202f89fa1a3cebf05b054c3aa96 =



Test Regressions
---------------- =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
fsl-ls1028a-rdb              | arm64 | lab-nxp         | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/619413c99e19514e61335905

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls1028a-rdb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls1028a-rdb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619413c99e19514e61335=
906
        failing since 0 day (last pass: v5.15.2, first fail: v5.15.2-918-gf=
f5232812521) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
imx8mn-ddr4-evk              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/619413bc9e19514e613358f2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr=
4-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr=
4-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619413bc9e19514e61335=
8f3
        failing since 0 day (last pass: v5.15.2-121-g0299785967d3, first fa=
il: v5.15.2-918-gff5232812521) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
imx8mn-ddr4-evk              | arm64 | lab-nxp         | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/619413937b9703c5773358dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-evk=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-evk=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619413937b9703c577335=
8dd
        failing since 0 day (last pass: v5.15.2-121-g0299785967d3, first fa=
il: v5.15.2-918-gff5232812521) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
imx8mp-evk                   | arm64 | lab-nxp         | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/619413a77b9703c5773358e8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619413a77b9703c577335=
8e9
        failing since 0 day (last pass: v5.15.2-121-g0299785967d3, first fa=
il: v5.15.2-918-gff5232812521) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
kontron-pitx-imx8m           | arm64 | lab-kontron     | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/61941355bd3e17701c33590f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pit=
x-imx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pit=
x-imx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61941355bd3e17701c335=
910
        failing since 0 day (last pass: v5.15.2-121-g0299785967d3, first fa=
il: v5.15.2-918-gff5232812521) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
meson-g12a-sei510            | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6194133e268241e7c13358df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a=
-sei510.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a=
-sei510.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6194133e268241e7c1335=
8e0
        failing since 0 day (last pass: v5.15.2-121-g0299785967d3, first fa=
il: v5.15.2-918-gff5232812521) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
meson-g12a-u200              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/619413604d781cd6593358f5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a=
-u200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a=
-u200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619413604d781cd659335=
8f6
        failing since 0 day (last pass: v5.15.2-121-g0299785967d3, first fa=
il: v5.15.2-918-gff5232812521) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
meson-g12a-x96-max           | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6194133d268241e7c13358dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a=
-x96-max.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a=
-x96-max.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6194133d268241e7c1335=
8dd
        failing since 0 day (last pass: v5.15.2-121-g0299785967d3, first fa=
il: v5.15.2-918-gff5232812521) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-collabora   | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/61941362e1993c76923358fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12=
b-a311d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12=
b-a311d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61941362e1993c7692335=
8fe
        failing since 0 day (last pass: v5.15.2-121-g0299785967d3, first fa=
il: v5.15.2-918-gff5232812521) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
meson-g12b-odroid-n2         | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/61941374446972859a3358ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b=
-odroid-n2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b=
-odroid-n2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61941374446972859a335=
8ed
        failing since 0 day (last pass: v5.15.2-121-g0299785967d3, first fa=
il: v5.15.2-918-gff5232812521) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
meson-gxl-s905d-p230         | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/619414d0f5ac7d61a6335905

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-=
s905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-=
s905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619414d0f5ac7d61a6335=
906
        failing since 0 day (last pass: v5.15.1-27-g12d0445d66e0, first fai=
l: v5.15.2-918-gff5232812521) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
meson-gxl-s905x-khadas-vim   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6194175329225957143358ed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-=
s905x-khadas-vim.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-=
s905x-khadas-vim.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619417532922595714335=
8ee
        failing since 0 day (last pass: v5.15.2-121-g0299785967d3, first fa=
il: v5.15.2-918-gff5232812521) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6194136218aa53b78d3358e8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-=
s905x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-=
s905x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6194136218aa53b78d335=
8e9
        failing since 0 day (last pass: v5.15.2-121-g0299785967d3, first fa=
il: v5.15.2-918-gff5232812521) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
meson-sm1-khadas-vim3l       | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/61941354bd3e17701c3358fe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-=
khadas-vim3l.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-=
khadas-vim3l.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61941354bd3e17701c335=
8ff
        failing since 0 day (last pass: v5.15.2-121-g0299785967d3, first fa=
il: v5.15.2-918-gff5232812521) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
meson-sm1-sei610             | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/61941364e1993c7692335905

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-=
sei610.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-=
sei610.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61941364e1993c7692335=
906
        failing since 0 day (last pass: v5.15.2-121-g0299785967d3, first fa=
il: v5.15.2-918-gff5232812521) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
mt8173-elm-hana              | arm64 | lab-collabora   | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6194136af828e1b2eb335907

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-collabora/baseline-mt8173-el=
m-hana.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-collabora/baseline-mt8173-el=
m-hana.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6194136af828e1b2eb335=
908
        failing since 0 day (last pass: v5.15.2-121-g0299785967d3, first fa=
il: v5.15.2-918-gff5232812521) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora   | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/61941345bd3e17701c3358e1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-collabora/baseline-mt8183-ku=
kui-jacuzzi-juniper-sku16.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-collabora/baseline-mt8183-ku=
kui-jacuzzi-juniper-sku16.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61941345bd3e17701c335=
8e2
        failing since 2 days (last pass: v5.15.2, first fail: v5.15.2-121-g=
0299785967d3) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qcom-qdf2400                 | arm64 | lab-linaro-lkft | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/61941413a906148e4f3358ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-linaro-lkft/baseline-qcom-qd=
f2400.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-linaro-lkft/baseline-qcom-qd=
f2400.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61941413a906148e4f335=
8ef
        failing since 0 day (last pass: v5.15.2-121-g0299785967d3, first fa=
il: v5.15.2-918-gff5232812521) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qemu_arm64-virt-gicv2        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6194132eec52fcb71b335901

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6194132eec52fcb71b335=
902
        failing since 0 day (last pass: v5.15.2-121-g0299785967d3, first fa=
il: v5.15.2-918-gff5232812521) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qemu_arm64-virt-gicv2        | arm64 | lab-broonie     | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/61941343268241e7c13358e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61941343268241e7c1335=
8e7
        failing since 0 day (last pass: v5.15.2-121-g0299785967d3, first fa=
il: v5.15.2-918-gff5232812521) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qemu_arm64-virt-gicv2        | arm64 | lab-cip         | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6194138c6206fc78e63358df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-cip/baseline-qemu_arm64-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-cip/baseline-qemu_arm64-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6194138c6206fc78e6335=
8e0
        failing since 0 day (last pass: v5.15.2-121-g0299785967d3, first fa=
il: v5.15.2-918-gff5232812521) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6194133f3a20ce86d9335903

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6194133f3a20ce86d9335=
904
        failing since 0 day (last pass: v5.15.2-121-g0299785967d3, first fa=
il: v5.15.2-918-gff5232812521) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie     | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/61941373cbbac533f93358e5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61941373cbbac533f9335=
8e6
        failing since 0 day (last pass: v5.15.2-121-g0299785967d3, first fa=
il: v5.15.2-918-gff5232812521) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-cip         | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6194135fc299a315ae3358dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-cip/baseline-qemu_arm64-virt=
-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-cip/baseline-qemu_arm64-virt=
-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6194135fc299a315ae335=
8dd
        failing since 0 day (last pass: v5.15.2-121-g0299785967d3, first fa=
il: v5.15.2-918-gff5232812521) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qemu_arm64-virt-gicv3        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6194132cec52fcb71b3358fc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6194132cec52fcb71b335=
8fd
        failing since 0 day (last pass: v5.15.2-121-g0299785967d3, first fa=
il: v5.15.2-918-gff5232812521) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qemu_arm64-virt-gicv3        | arm64 | lab-broonie     | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6194135f4d781cd6593358ed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6194135f4d781cd659335=
8ee
        failing since 0 day (last pass: v5.15.2-121-g0299785967d3, first fa=
il: v5.15.2-918-gff5232812521) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qemu_arm64-virt-gicv3        | arm64 | lab-cip         | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/61941363c299a315ae3358e9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-cip/baseline-qemu_arm64-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-cip/baseline-qemu_arm64-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61941363c299a315ae335=
8ea
        failing since 0 day (last pass: v5.15.2-121-g0299785967d3, first fa=
il: v5.15.2-918-gff5232812521) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6194132fec52fcb71b335909

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6194132fec52fcb71b335=
90a
        failing since 0 day (last pass: v5.15.2-121-g0299785967d3, first fa=
il: v5.15.2-918-gff5232812521) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie     | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/61941360f828e1b2eb3358e9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61941360f828e1b2eb335=
8ea
        failing since 0 day (last pass: v5.15.2-121-g0299785967d3, first fa=
il: v5.15.2-918-gff5232812521) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-cip         | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/61941372f828e1b2eb335914

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-cip/baseline-qemu_arm64-virt=
-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-cip/baseline-qemu_arm64-virt=
-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61941372f828e1b2eb335=
915
        failing since 0 day (last pass: v5.15.2-121-g0299785967d3, first fa=
il: v5.15.2-918-gff5232812521) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
r8a774a1-hihope-rzg2m-ex     | arm64 | lab-cip         | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/61941386446972859a33590c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-cip/baseline-r8a774a1-hihope=
-rzg2m-ex.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-cip/baseline-r8a774a1-hihope=
-rzg2m-ex.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61941386446972859a335=
90d
        failing since 0 day (last pass: v5.15.2-121-g0299785967d3, first fa=
il: v5.15.2-918-gff5232812521) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
r8a774b1-hihope-rzg2n-ex     | arm64 | lab-cip         | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/61941453b87ef4e5013358de

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-cip/baseline-r8a774b1-hihope=
-rzg2n-ex.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-cip/baseline-r8a774b1-hihope=
-rzg2n-ex.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61941453b87ef4e501335=
8df
        new failure (last pass: v5.15.2-121-g0299785967d3) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
r8a774c0-ek874               | arm64 | lab-cip         | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/619413a17b9703c5773358e5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-cip/baseline-r8a774c0-ek874.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-cip/baseline-r8a774c0-ek874.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619413a17b9703c577335=
8e6
        failing since 0 day (last pass: v5.15.2-121-g0299785967d3, first fa=
il: v5.15.2-918-gff5232812521) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
r8a77960-ulcb                | arm64 | lab-collabora   | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/61941360e1993c76923358f8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-collabora/baseline-r8a77960-=
ulcb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-collabora/baseline-r8a77960-=
ulcb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61941360e1993c7692335=
8f9
        failing since 0 day (last pass: v5.15.2-121-g0299785967d3, first fa=
il: v5.15.2-918-gff5232812521) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
rk3399-gru-kevin             | arm64 | lab-collabora   | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6194137a2202e098f53358e3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-collabora/baseline-rk3399-gr=
u-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-collabora/baseline-rk3399-gr=
u-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6194137a2202e098f5335=
8e4
        failing since 0 day (last pass: v5.15.2-121-g0299785967d3, first fa=
il: v5.15.2-918-gff5232812521) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
sun50i-a64-pine64-plus       | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/619442de20733b70533358e1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64=
-pine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64=
-pine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619442de20733b7053335=
8e2
        failing since 0 day (last pass: v5.15.2-121-g0299785967d3, first fa=
il: v5.15.2-918-gff5232812521) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
sun50i-h5-lib...ch-all-h3-cc | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/61941379446972859a3358f5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-h5-=
libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-h5-=
libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61941379446972859a335=
8f6
        failing since 0 day (last pass: v5.15.2, first fail: v5.15.2-918-gf=
f5232812521) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
sun50i-h6-pine-h64           | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/619413664d781cd659335904

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-h6-=
pine-h64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-h6-=
pine-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619413664d781cd659335=
905
        failing since 0 day (last pass: v5.15.1-27-g12d0445d66e0, first fai=
l: v5.15.2-918-gff5232812521) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
sun50i-h6-pine-h64           | arm64 | lab-collabora   | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/619414e3334a8943143358f6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6=
-pine-h64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6=
-pine-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619414e3334a894314335=
8f7
        failing since 0 day (last pass: v5.15.1-27-g12d0445d66e0, first fai=
l: v5.15.2-918-gff5232812521) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
zynqmp-zcu102                | arm64 | lab-cip         | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/61941354bd3e17701c335901

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-cip/baseline-zynqmp-zcu102.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-928-gcb98d6b416c1a/arm64/defconfig/gcc-10/lab-cip/baseline-zynqmp-zcu102.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61941354bd3e17701c335=
902
        failing since 0 day (last pass: v5.15.2-121-g0299785967d3, first fa=
il: v5.15.2-918-gff5232812521) =

 =20
