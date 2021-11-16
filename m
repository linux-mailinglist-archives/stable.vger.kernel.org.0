Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15EEF453AB5
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 21:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbhKPUNJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 15:13:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231225AbhKPUNH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 15:13:07 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 901C1C061570
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 12:10:10 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id y14-20020a17090a2b4e00b001a5824f4918so3218285pjc.4
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 12:10:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QjvAd3kdXxS22LvF/1ZJ2siEwgIMxLgXT/QDXPuelkg=;
        b=nRBS2IG6Ftb69eCZ+E5X+Zeif+Ljde77B1jWeseaQoHQEs1RQGeCVgicR+wj8Kp1qt
         p5VqrFHRDYIQnZddWAq7hHBloizI3BR5sNj5ecHI2UWyAaF/QyIyuxJDDRC46hhxXnyM
         cfhCaah8uOCNaac6n+wi6D3Spc9ZSpSdS3qr6bh8dK2BvHVbgLwCo9vj0CUS++RD2vX0
         +y4dTby8EmpSTgTgDnnChaowP/LK8/1ztV1WPa6P0pUMPj/tWXiaHfT6Z6bH0r8FJ5yV
         kqCqTRUR+qw3r3rFgzmdCdOa0HfjWN3EYkr0zOXWT2IyVmNMuguGb9PMcrHPbO2C4Xey
         DicA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QjvAd3kdXxS22LvF/1ZJ2siEwgIMxLgXT/QDXPuelkg=;
        b=ardtBnIreY1Q5NzjLZ+Q+4tFzEql3Zcho/4BlVcMqPnNCKcnXDRzDuGBIR/YELZ8Vx
         6ERiS7EH5fAYMXqOlTfatYY88PE2W+z/vjXEYhgI+UFMxY5kf6VQ19rlVfOODS5AxZ8L
         Yz4XzvDfixJ1syPMjqKlCNQQxGxObMyWTkyxlIg4hYy6uYa1iqzfxN486BkgCUt2ENJ9
         nKzHf2T8kH5bYpbHDX+Pj+nSGd5g69VWRycYWpreJgi7bdXaFTpx7KX/u0FxAStPKshu
         DKqAfRdnBvwd2Aa6/udnt0QdzExYZ3BQvXm54BHACKWaIvLoO0gIiK0IuItMFvRkcgeN
         OgeQ==
X-Gm-Message-State: AOAM533AwVyyUm89UyZIq604ohdiCLbLBBLzTbcqehxuZJm3PEew/jOk
        V/4gHofGDmR8J0yUdL1R4+GUubkRSxvN4v9Y
X-Google-Smtp-Source: ABdhPJzhqvmBxvW3P2pN/kNHXyx9ISlKVQdaSV+i6HNlbkd0gCr/b+0tzZ6CT6vVWIXnbvLKe80jTQ==
X-Received: by 2002:a17:90b:1bcb:: with SMTP id oa11mr2294010pjb.140.1637093409372;
        Tue, 16 Nov 2021 12:10:09 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u22sm21324164pfk.148.2021.11.16.12.10.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 12:10:09 -0800 (PST)
Message-ID: <61941021.1c69fb81.819dc.c489@mx.google.com>
Date:   Tue, 16 Nov 2021 12:10:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.2-927-gd7ce0f93f7eb
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 141 runs,
 41 regressions (v5.15.2-927-gd7ce0f93f7eb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 141 runs, 41 regressions (v5.15.2-927-gd7ce0=
f93f7eb)

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

meson-gxl-s805x-libretech-ac | arm64 | lab-baylibre    | gcc-10   | defconf=
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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.2-927-gd7ce0f93f7eb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.2-927-gd7ce0f93f7eb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d7ce0f93f7eb811c54061de3e9ec353f20415658 =



Test Regressions
---------------- =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
fsl-ls1028a-rdb              | arm64 | lab-nxp         | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193d947221c2fed053358dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls1028a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls1028a-rdb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193d947221c2fed05335=
8dd
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
imx8mn-ddr4-evk              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193d9646b51c8895f335913

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4-e=
vk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4-e=
vk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193d9646b51c8895f335=
914
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
imx8mn-ddr4-evk              | arm64 | lab-nxp         | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193d92238b876c53c3358e1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-evk.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193d92238b876c53c335=
8e2
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
imx8mp-evk                   | arm64 | lab-nxp         | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193d9247f41838c833358fc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193d9247f41838c83335=
8fd
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
kontron-pitx-imx8m           | arm64 | lab-kontron     | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193d8614947885be63358ef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-i=
mx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-i=
mx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193d8614947885be6335=
8f0
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
meson-g12a-sei510            | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193d846e0ce6146ad3358e5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-se=
i510.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-se=
i510.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193d846e0ce6146ad335=
8e6
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
meson-g12a-u200              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193d86f13f61c91bf3358e2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-u2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-u2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193d86f13f61c91bf335=
8e3
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
meson-g12a-x96-max           | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193d848e0ce6146ad3358e8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-x9=
6-max.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-x9=
6-max.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193d848e0ce6146ad335=
8e9
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-collabora   | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193d8534947885be63358eb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12b-a=
311d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12b-a=
311d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193d8534947885be6335=
8ec
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
meson-g12b-odroid-n2         | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193d87fc96d8425693358f3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-od=
roid-n2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-od=
roid-n2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193d87fc96d842569335=
8f4
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
meson-gxl-s805x-libretech-ac | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193d872f0dde23e0e3358e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s80=
5x-libretech-ac.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s80=
5x-libretech-ac.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193d872f0dde23e0e335=
8e1
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
meson-gxl-s905d-p230         | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193d951221c2fed053358ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s90=
5d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s90=
5d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193d951221c2fed05335=
8ed
        failing since 0 day (last pass: v5.15.1-26-g09a73fe37edc, first fai=
l: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
meson-gxl-s905x-khadas-vim   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193d9400785c525e8335941

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s90=
5x-khadas-vim.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s90=
5x-khadas-vim.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193d9400785c525e8335=
942
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193d86dd64d3097473358e5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s90=
5x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s90=
5x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193d86dd64d309747335=
8e6
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
meson-sm1-khadas-vim3l       | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193d85e3f8fc104ad3358ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-kha=
das-vim3l.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-kha=
das-vim3l.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193d85e3f8fc104ad335=
8ed
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
meson-sm1-sei610             | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193d86ba8f5ad71a73358ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-sei=
610.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-sei=
610.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193d86ba8f5ad71a7335=
8ef
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
mt8173-elm-hana              | arm64 | lab-collabora   | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193d8816b5cd574aa3358dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-collabora/baseline-mt8173-elm-h=
ana.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-collabora/baseline-mt8173-elm-h=
ana.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193d8816b5cd574aa335=
8dd
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora   | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193d887abf0a716793358e5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-collabora/baseline-mt8183-kukui=
-jacuzzi-juniper-sku16.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-collabora/baseline-mt8183-kukui=
-jacuzzi-juniper-sku16.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193d887abf0a71679335=
8e6
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qcom-qdf2400                 | arm64 | lab-linaro-lkft | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193d92638b876c53c3358e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-linaro-lkft/baseline-qcom-qdf24=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-linaro-lkft/baseline-qcom-qdf24=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193d92638b876c53c335=
8e7
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qemu_arm64-virt-gicv2        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193d836d6753b760d3358e5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193d836d6753b760d335=
8e6
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qemu_arm64-virt-gicv2        | arm64 | lab-broonie     | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193d87f226d4d894f3358f4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193d87f226d4d894f335=
8f5
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qemu_arm64-virt-gicv2        | arm64 | lab-cip         | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193d8674947885be63358f2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-cip/baseline-qemu_arm64-virt-gi=
cv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-cip/baseline-qemu_arm64-virt-gi=
cv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193d8674947885be6335=
8f3
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193d848db95b152003358dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193d848db95b15200335=
8dd
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie     | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193d86bdad76d68fe3358df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193d86bdad76d68fe335=
8e0
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-cip         | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193d8741b2fa0a2493358e7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-cip/baseline-qemu_arm64-virt-gi=
cv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-cip/baseline-qemu_arm64-virt-gi=
cv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193d8741b2fa0a249335=
8e8
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qemu_arm64-virt-gicv3        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193d8359f4bdf498f3358e8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193d8359f4bdf498f335=
8e9
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qemu_arm64-virt-gicv3        | arm64 | lab-broonie     | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193d86ba8f5ad71a73358eb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193d86ba8f5ad71a7335=
8ec
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qemu_arm64-virt-gicv3        | arm64 | lab-cip         | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193d8a4d808f3bdbc3358fc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-cip/baseline-qemu_arm64-virt-gi=
cv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-cip/baseline-qemu_arm64-virt-gi=
cv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193d8a4d808f3bdbc335=
8fd
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193d85c34fa152c463358ef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193d85c34fa152c46335=
8f0
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie     | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193d8629ddfa32f1e3358eb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193d8629ddfa32f1e335=
8ec
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-cip         | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193d8a7d808f3bdbc335900

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-cip/baseline-qemu_arm64-virt-gi=
cv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-cip/baseline-qemu_arm64-virt-gi=
cv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193d8a7d808f3bdbc335=
901
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
r8a774a1-hihope-rzg2m-ex     | arm64 | lab-cip         | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193d8890f93fedd033358e2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-cip/baseline-r8a774a1-hihope-rz=
g2m-ex.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-cip/baseline-r8a774a1-hihope-rz=
g2m-ex.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193d8890f93fedd03335=
8e3
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
r8a774b1-hihope-rzg2n-ex     | arm64 | lab-cip         | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193dad2fb70d18ee7335913

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-cip/baseline-r8a774b1-hihope-rz=
g2n-ex.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-cip/baseline-r8a774b1-hihope-rz=
g2n-ex.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193dad2fb70d18ee7335=
914
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-924-g5bcef522d237) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
r8a774c0-ek874               | arm64 | lab-cip         | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193dafb811ae6c5c73358fc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-cip/baseline-r8a774c0-ek874.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-cip/baseline-r8a774c0-ek874.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193dafb811ae6c5c7335=
8fd
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
r8a77960-ulcb                | arm64 | lab-collabora   | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193efe0aa428301ab3358fe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-collabora/baseline-r8a77960-ulc=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-collabora/baseline-r8a77960-ulc=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193efe0aa428301ab335=
8ff
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-915-gb71b884d1f9b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
rk3399-gru-kevin             | arm64 | lab-collabora   | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193d966e4630873ce3358e8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193d966e4630873ce335=
8e9
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
sun50i-a64-pine64-plus       | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/61940fbbacdd56ce4b33594c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-pi=
ne64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-pi=
ne64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61940fbbacdd56ce4b335=
94d
        failing since 1 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
sun50i-h5-lib...ch-all-h3-cc | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193d874a8f5ad71a73358f4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-h5-lib=
retech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-h5-lib=
retech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193d874a8f5ad71a7335=
8f5
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
sun50i-h6-pine-h64           | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193d870c96d8425693358ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-h6-pin=
e-h64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-h6-pin=
e-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193d870c96d842569335=
8ef
        failing since 0 day (last pass: v5.15.1-26-g09a73fe37edc, first fai=
l: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
sun50i-h6-pine-h64           | arm64 | lab-collabora   | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193d885d808f3bdbc3358de

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-pi=
ne-h64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-pi=
ne-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193d885d808f3bdbc335=
8df
        failing since 0 day (last pass: v5.15.1-26-g09a73fe37edc, first fai=
l: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
zynqmp-zcu102                | arm64 | lab-cip         | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193d87fdd13c692e4335903

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-cip/baseline-zynqmp-zcu102.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
27-gd7ce0f93f7eb/arm64/defconfig/gcc-10/lab-cip/baseline-zynqmp-zcu102.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193d87fdd13c692e4335=
904
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =20
