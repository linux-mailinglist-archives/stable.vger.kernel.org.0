Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7F84523A2
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347108AbhKPB1h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:27:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355568AbhKPBWj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 20:22:39 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5298EC08B772
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 15:09:30 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id y8so10278293plg.1
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 15:09:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2iiBaUTp5ndbf4A+OWXPeNOVwsb+nC3ADTqcfBcwEH0=;
        b=zo9O7U3aG3UClClYGrc2hHUg5/aj2s94EW7ojXFtuxTPFMrlWaSAIxzbqvcaNN7wZ9
         LVNWV391ThmW2z6Wm7O6voHZWWO7KYN9o8F7wvbG+51CY3vdfuCZQDBV4ars5Lv+pPHm
         QipBVy31fUsvjaJpBlFpcywVLacVngvCCG6nxNwBtMuaRdl02H5HfdCLdP1kjjiQiUc9
         nK2IPvm52nnV9H0/RIUsXAX3rAnc2lHYPBJSYVA6PC6b5JhbQx9h5o5zRSE3YDGMJ8Ig
         49hSkf2bPn842co1UXIr4YcCHbzXWO5Z2NmvFUd9gYLW6jOei5Z2RghXr+PCv3YLQcCb
         xv0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2iiBaUTp5ndbf4A+OWXPeNOVwsb+nC3ADTqcfBcwEH0=;
        b=HYrgB/5Gr0wWv+cg/7ViWUlBLabVYu6R2i6TeTlItlLV7Z1N+5IXEZcypLAdicFQDE
         NIpsX9GpTsGBRuWF2O4Q312Qqzz9iBDDrKfDjG+RAej0UiHK4ffY9nmj+8W0wAxEgF0J
         kHxszn6MVq4FrMwxWpu/KcteM9VfHTr7LF/Zo/sGRl6IQm0jzX+fn8GwmiHft5QI/KNc
         Wh15K9zHaxr9ZlkvuHYpUr37mvNxLlKgjZGx1Aeg4/v7qw7tsoU1yGqIlYAWBwY+pQgy
         AMmRfY9L+1o5uX8qEqP++UYPmzKFGaYXapZQf2JOZ/KwobmvC8MpQ+uml2nxFaxBC9oz
         tcow==
X-Gm-Message-State: AOAM532n5+an3NAH9DM9PiQX0+VW1P+ME7djRyUYESuPow5vejX3AF3p
        BPOdPOLmNPinxkLjSaAnVYEKEShU6n4Z9eaM
X-Google-Smtp-Source: ABdhPJz1uWHl+XVSu6OuMa4EzoVM0bgta9sXgwfFZiiuICNlSvD2M4V/e9bdAzLi5js0Bvg0pSre3Q==
X-Received: by 2002:a17:902:744b:b0:142:46fe:7fbf with SMTP id e11-20020a170902744b00b0014246fe7fbfmr39777444plt.83.1637017768966;
        Mon, 15 Nov 2021 15:09:28 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k14sm12813148pga.65.2021.11.15.15.09.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 15:09:28 -0800 (PST)
Message-ID: <6192e8a8.1c69fb81.94120.6372@mx.google.com>
Date:   Mon, 15 Nov 2021 15:09:28 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.2-917-g2a257c5e57ee
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 167 runs,
 47 regressions (v5.15.2-917-g2a257c5e57ee)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 167 runs, 47 regressions (v5.15.2-917-g2a257=
c5e57ee)

Regressions Summary
-------------------

platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
fsl-ls1028a-rdb              | arm64 | lab-nxp         | gcc-10   | defconf=
ig | 1          =

fsl-ls1043a-rdb              | arm64 | lab-nxp         | gcc-10   | defconf=
ig | 1          =

fsl-lx2160a-rdb              | arm64 | lab-nxp         | gcc-10   | defconf=
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

meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre    | gcc-10   | defconf=
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

meson-gxm-khadas-vim2        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =

meson-gxm-q200               | arm64 | lab-baylibre    | gcc-10   | defconf=
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

qemu_arm64-virt-gicv2        | arm64 | lab-collabora   | gcc-10   | defconf=
ig | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie     | gcc-10   | defconf=
ig | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-cip         | gcc-10   | defconf=
ig | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-collabora   | gcc-10   | defconf=
ig | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-broonie     | gcc-10   | defconf=
ig | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-cip         | gcc-10   | defconf=
ig | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-collabora   | gcc-10   | defconf=
ig | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie     | gcc-10   | defconf=
ig | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-collabora   | gcc-10   | defconf=
ig | 1          =

r8a774a1-hihope-rzg2m-ex     | arm64 | lab-cip         | gcc-10   | defconf=
ig | 1          =

r8a774c0-ek874               | arm64 | lab-cip         | gcc-10   | defconf=
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
nel/v5.15.2-917-g2a257c5e57ee/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.2-917-g2a257c5e57ee
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2a257c5e57eedc7f9c34b56f5cf46301cbcb5202 =



Test Regressions
---------------- =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
fsl-ls1028a-rdb              | arm64 | lab-nxp         | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6192b18d997f88c2363358dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls1028a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls1028a-rdb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6192b18d997f88c236335=
8de
        new failure (last pass: v5.15.2-181-g9a604828be7c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
fsl-ls1043a-rdb              | arm64 | lab-nxp         | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6192b1a7694515486e3358dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls1043a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls1043a-rdb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6192b1a7694515486e335=
8dd
        new failure (last pass: v5.15.2-181-g9a604828be7c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
fsl-lx2160a-rdb              | arm64 | lab-nxp         | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6192b1a4929ef3b8d63358f0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-rdb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6192b1a4929ef3b8d6335=
8f1
        new failure (last pass: v5.15.2-181-g9a604828be7c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
imx8mn-ddr4-evk              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6192b1802269d435923358e8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4-e=
vk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4-e=
vk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6192b1802269d43592335=
8e9
        new failure (last pass: v5.15.2-181-g9a604828be7c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
imx8mn-ddr4-evk              | arm64 | lab-nxp         | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6192b1a2997f88c2363358f5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-evk.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6192b1a2997f88c236335=
8f6
        new failure (last pass: v5.15.2-181-g9a604828be7c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
imx8mp-evk                   | arm64 | lab-nxp         | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6192b17bd45634d7d43358eb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6192b17bd45634d7d4335=
8ec
        new failure (last pass: v5.15.2-181-g9a604828be7c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
kontron-pitx-imx8m           | arm64 | lab-kontron     | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6192b15f498ad4867b3358ea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-i=
mx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-i=
mx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6192b15f498ad4867b335=
8eb
        new failure (last pass: v5.15.2-181-g9a604828be7c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
meson-g12a-sei510            | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6192b0f1522d263eab3358ef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-se=
i510.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-se=
i510.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6192b0f1522d263eab335=
8f0
        new failure (last pass: v5.15.2-181-g9a604828be7c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
meson-g12a-u200              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6192b0fea5678ceb6b3358e3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-u2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-u2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6192b0fea5678ceb6b335=
8e4
        new failure (last pass: v5.15.2-181-g9a604828be7c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
meson-g12a-x96-max           | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6192b11465fc56f13f3358f6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-x9=
6-max.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-x9=
6-max.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6192b11465fc56f13f335=
8f7
        new failure (last pass: v5.15.2-181-g9a604828be7c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6192c507e07b7fc7fc335915

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-a3=
11d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-a3=
11d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6192c507e07b7fc7fc335=
916
        new failure (last pass: v5.15.2-181-g9a604828be7c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-collabora   | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6192b0d248703db6003358e9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12b-a=
311d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12b-a=
311d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6192b0d248703db600335=
8ea
        new failure (last pass: v5.15.2-181-g9a604828be7c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
meson-g12b-odroid-n2         | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6192b113a5678ceb6b3358f8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-od=
roid-n2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-od=
roid-n2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6192b113a5678ceb6b335=
8f9
        new failure (last pass: v5.15.2-181-g9a604828be7c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
meson-gxl-s805x-libretech-ac | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6192b111045805fd223358fb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s80=
5x-libretech-ac.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s80=
5x-libretech-ac.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6192b111045805fd22335=
8fc
        new failure (last pass: v5.15.2-181-g9a604828be7c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
meson-gxl-s905d-p230         | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6192b5af77b5ba11013358e2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s90=
5d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s90=
5d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6192b5af77b5ba1101335=
8e3
        new failure (last pass: v5.15.1-26-g09a73fe37edc) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
meson-gxl-s905x-khadas-vim   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6192b460b35ee48f883358f3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s90=
5x-khadas-vim.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s90=
5x-khadas-vim.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6192b460b35ee48f88335=
8f4
        new failure (last pass: v5.15.2-181-g9a604828be7c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6192b0fa522d263eab33596e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s90=
5x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s90=
5x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6192b0fa522d263eab335=
96f
        new failure (last pass: v5.15.2-181-g9a604828be7c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
meson-gxm-khadas-vim2        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6192c8f0933631458e3358dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-kha=
das-vim2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-kha=
das-vim2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6192c8f0933631458e335=
8dd
        new failure (last pass: v5.15.2-181-g9a604828be7c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
meson-gxm-q200               | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6192bc857846d335923358ed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6192bc857846d33592335=
8ee
        new failure (last pass: v5.15.2-181-g9a604828be7c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
meson-sm1-khadas-vim3l       | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6192b0fb37563feb2d3358f2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-kha=
das-vim3l.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-kha=
das-vim3l.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6192b0fb37563feb2d335=
8f3
        new failure (last pass: v5.15.2-181-g9a604828be7c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
meson-sm1-sei610             | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6192b0fd522d263eab33597b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-sei=
610.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-sei=
610.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6192b0fd522d263eab335=
97c
        new failure (last pass: v5.15.2-181-g9a604828be7c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
mt8173-elm-hana              | arm64 | lab-collabora   | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6192b170594dfd92bc3358e8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-collabora/baseline-mt8173-elm-h=
ana.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-collabora/baseline-mt8173-elm-h=
ana.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6192b170594dfd92bc335=
8e9
        new failure (last pass: v5.15.2-181-g9a604828be7c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora   | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6192b102a5678ceb6b3358e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-collabora/baseline-mt8183-kukui=
-jacuzzi-juniper-sku16.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-collabora/baseline-mt8183-kukui=
-jacuzzi-juniper-sku16.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6192b102a5678ceb6b335=
8e7
        new failure (last pass: v5.15.2-181-g9a604828be7c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qcom-qdf2400                 | arm64 | lab-linaro-lkft | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6192b1ae694515486e3358ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-linaro-lkft/baseline-qcom-qdf24=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-linaro-lkft/baseline-qcom-qdf24=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6192b1ae694515486e335=
8ef
        new failure (last pass: v5.15.2-181-g9a604828be7c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qemu_arm64-virt-gicv2        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6192b18bda1a61233a3358dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6192b18bda1a61233a335=
8dd
        new failure (last pass: v5.15.2-181-g9a604828be7c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qemu_arm64-virt-gicv2        | arm64 | lab-broonie     | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6192b12627c0ba994a3358ea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6192b12627c0ba994a335=
8eb
        new failure (last pass: v5.15.2-181-g9a604828be7c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qemu_arm64-virt-gicv2        | arm64 | lab-cip         | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6192b151752e20632f3358dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-cip/baseline-qemu_arm64-virt-gi=
cv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-cip/baseline-qemu_arm64-virt-gi=
cv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6192b151752e20632f335=
8dd
        new failure (last pass: v5.15.2-181-g9a604828be7c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qemu_arm64-virt-gicv2        | arm64 | lab-collabora   | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6192b45deac69ac02d33592b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6192b45deac69ac02d335=
92c
        new failure (last pass: v5.15.2-181-g9a604828be7c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6192b1b157cb5c27ed3358ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6192b1b157cb5c27ed335=
8ed
        new failure (last pass: v5.15.2-181-g9a604828be7c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie     | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6192b120ac46b41aee33594c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6192b120ac46b41aee335=
94d
        new failure (last pass: v5.15.2-181-g9a604828be7c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-cip         | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6192b1ae929ef3b8d633590c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-cip/baseline-qemu_arm64-virt-gi=
cv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-cip/baseline-qemu_arm64-virt-gi=
cv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6192b1ae929ef3b8d6335=
90d
        new failure (last pass: v5.15.2-181-g9a604828be7c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-collabora   | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6192b48c76b233d59933591f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6192b48c76b233d599335=
920
        new failure (last pass: v5.15.2-181-g9a604828be7c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qemu_arm64-virt-gicv3        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6192b1c1694515486e335902

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6192b1c1694515486e335=
903
        new failure (last pass: v5.15.2-181-g9a604828be7c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qemu_arm64-virt-gicv3        | arm64 | lab-broonie     | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6192b1392d249f340f3358f0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6192b1392d249f340f335=
8f1
        new failure (last pass: v5.15.2-181-g9a604828be7c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qemu_arm64-virt-gicv3        | arm64 | lab-cip         | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6192b18dda1a61233a3358e2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-cip/baseline-qemu_arm64-virt-gi=
cv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-cip/baseline-qemu_arm64-virt-gi=
cv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6192b18dda1a61233a335=
8e3
        new failure (last pass: v5.15.2-181-g9a604828be7c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qemu_arm64-virt-gicv3        | arm64 | lab-collabora   | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6192b4a2b5333693123358f0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6192b4a2b533369312335=
8f1
        new failure (last pass: v5.15.2-181-g9a604828be7c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6192b1c2ad2c5ca3da3358dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6192b1c2ad2c5ca3da335=
8dd
        new failure (last pass: v5.15.2-181-g9a604828be7c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie     | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6192b15a752e20632f3358ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6192b15a752e20632f335=
8ef
        new failure (last pass: v5.15.2-181-g9a604828be7c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-collabora   | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6192b4a4b77373ef6d3358dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6192b4a4b77373ef6d335=
8de
        new failure (last pass: v5.15.2-181-g9a604828be7c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
r8a774a1-hihope-rzg2m-ex     | arm64 | lab-cip         | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6192b11dac46b41aee335930

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-cip/baseline-r8a774a1-hihope-rz=
g2m-ex.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-cip/baseline-r8a774a1-hihope-rz=
g2m-ex.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6192b11dac46b41aee335=
931
        new failure (last pass: v5.15.2-181-g9a604828be7c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
r8a774c0-ek874               | arm64 | lab-cip         | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6192b5ab77b5ba11013358dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-cip/baseline-r8a774c0-ek874.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-cip/baseline-r8a774c0-ek874.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6192b5ab77b5ba1101335=
8de
        new failure (last pass: v5.15.2-181-g9a604828be7c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
rk3399-gru-kevin             | arm64 | lab-collabora   | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6192b29bd2f696892a335914

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6192b29bd2f696892a335=
915
        new failure (last pass: v5.15.2-181-g9a604828be7c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
sun50i-a64-pine64-plus       | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6192bb665ebfac851f3358e8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-pi=
ne64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-pi=
ne64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6192bb665ebfac851f335=
8e9
        new failure (last pass: v5.15.2-181-g9a604828be7c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
sun50i-h5-lib...ch-all-h3-cc | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6192b10ea5678ceb6b3358eb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-h5-lib=
retech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-h5-lib=
retech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6192b10ea5678ceb6b335=
8ec
        new failure (last pass: v5.15.2-181-g9a604828be7c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
sun50i-h6-pine-h64           | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6192b10f65fc56f13f3358e5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-h6-pin=
e-h64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-h6-pin=
e-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6192b10f65fc56f13f335=
8e6
        new failure (last pass: v5.15.1-26-g09a73fe37edc) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
sun50i-h6-pine-h64           | arm64 | lab-collabora   | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6192b544fb22008b7a3358e5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-pi=
ne-h64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-pi=
ne-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6192b544fb22008b7a335=
8e6
        new failure (last pass: v5.15.1-26-g09a73fe37edc) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
zynqmp-zcu102                | arm64 | lab-cip         | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6192b0ed522d263eab3358df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-cip/baseline-zynqmp-zcu102.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
17-g2a257c5e57ee/arm64/defconfig/gcc-10/lab-cip/baseline-zynqmp-zcu102.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6192b0ed522d263eab335=
8e0
        new failure (last pass: v5.15.2-181-g9a604828be7c) =

 =20
