Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF0F84538BD
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 18:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239068AbhKPRsO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 12:48:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238906AbhKPRsJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 12:48:09 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5358C061570
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 09:45:12 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id n26so81317pff.3
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 09:45:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9f7dQPlxGPLO2dV/u05uMxSOF7yjauFLXqhl2vbvNg0=;
        b=hSS0I1+Cn4JSooSf9qGs79yZoTAAzAN0ElxqpPWgjbrM8TJWQAvpvly7WUgdYgnROK
         YjT/qntW+JSTcNg5pbEpJedMYMHRmlLGRtU+6U5+COAQSH1DFmpsfCINV4RojlLuIasm
         30TGlgrDUxY7OUDTormt1xdfczgiQ6FYwyY+40A7d1zm/1MvWDPyo9L86sAWm6YuZKRe
         mEodMQqaTIcSrxjI82SH1mRscIKc61N+Ih1LNaCFxKoHK6oNTGM8lRp0CqPKIudbm6Ub
         qNXCWdIg+9mXcddhYLhPCczevc6cFlVC06hbrGnwDihqytwgQ302y1Cnn/qSN3JkNMOj
         BJ5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9f7dQPlxGPLO2dV/u05uMxSOF7yjauFLXqhl2vbvNg0=;
        b=DlhcFQiK8VoyEKZAG78zOJkm9ayGzweryQNtwCnWalymiwRF/y2t5mfwUE1YtC4bSn
         kzrE82FxPWc6JmMCZ1N6sSt7oImL0HT2kdHuncFJ3FfBj8/QMx3U1K1cwUJm96FQrSeh
         wYjU9+KAmmdIjI1X8VmUyHhl60hklCIbBMmXB74sj7EIUIWpf+aKAaGTjTD7COfn4BdN
         zEx8+SKIkMYMdfgABh+dzD4wKNVQPj4wtgsiufRn+bXtYuuTcBv1L9ca8R4+EEoWB12q
         nYTUduU80dzcxBE6ScsURjGh+fvO7cLFjipXbGJRz7GC4Ht2ArUq/2hq17AX7Kslvvp7
         /pqw==
X-Gm-Message-State: AOAM531OESJfSW+D0ZKTB+Np5oAGPkM/Dfu6mhJOxUqnh4/YAh7dikUN
        JDFui+g969ydrCJAG12wwoF5s57zsNA1/UhY
X-Google-Smtp-Source: ABdhPJzHLvFzJOLW2vNe6GlEcpN30Q+MWm1Z1IgVPSCHpVVGjZBd+M9+FG/icboSIB6cwtEdeOfw8g==
X-Received: by 2002:a63:be4e:: with SMTP id g14mr548291pgo.194.1637084711435;
        Tue, 16 Nov 2021 09:45:11 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mn15sm2913022pjb.35.2021.11.16.09.45.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 09:45:11 -0800 (PST)
Message-ID: <6193ee27.1c69fb81.af9ad.83c2@mx.google.com>
Date:   Tue, 16 Nov 2021 09:45:11 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.2-924-g5bcef522d237
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 132 runs,
 37 regressions (v5.15.2-924-g5bcef522d237)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 132 runs, 37 regressions (v5.15.2-924-g5bcef=
522d237)

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

sun50i-h6-pine-h64           | arm64 | lab-collabora   | gcc-10   | defconf=
ig | 1          =

zynqmp-zcu102                | arm64 | lab-cip         | gcc-10   | defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.2-924-g5bcef522d237/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.2-924-g5bcef522d237
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5bcef522d23752af104c7543564604958f1187a2 =



Test Regressions
---------------- =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
fsl-ls1028a-rdb              | arm64 | lab-nxp         | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193b59407557c728e335905

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls1028a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls1028a-rdb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193b59407557c728e335=
906
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
imx8mn-ddr4-evk              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193b55891175140c53358e9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4-e=
vk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4-e=
vk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193b55891175140c5335=
8ea
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
imx8mn-ddr4-evk              | arm64 | lab-nxp         | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193b58eba0bbedbaf335960

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-evk.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193b58eba0bbedbaf335=
961
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
imx8mp-evk                   | arm64 | lab-nxp         | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193b57db4a1774cce3358eb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193b57db4a1774cce335=
8ec
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
kontron-pitx-imx8m           | arm64 | lab-kontron     | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193b5ba24fb03712c3358dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-i=
mx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-i=
mx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193b5ba24fb03712c335=
8dd
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
meson-g12a-sei510            | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193b5007291fcd95b3358e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-se=
i510.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-se=
i510.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193b5007291fcd95b335=
8e7
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
meson-g12a-u200              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193b52a16d61ffe1f335908

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-u2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-u2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193b52a16d61ffe1f335=
909
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
meson-g12a-x96-max           | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193b52cb4625778563358f5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-x9=
6-max.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-x9=
6-max.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193b52cb462577856335=
8f6
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-collabora   | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193b50f6f2d07edc03358fa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12b-a=
311d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12b-a=
311d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193b50f6f2d07edc0335=
8fb
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
meson-g12b-odroid-n2         | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193b5027291fcd95b3358f9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-od=
roid-n2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-od=
roid-n2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193b5027291fcd95b335=
8fa
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
meson-gxl-s805x-libretech-ac | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193b52b16d61ffe1f33590d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s80=
5x-libretech-ac.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s80=
5x-libretech-ac.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193b52b16d61ffe1f335=
90e
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
meson-gxl-s905d-p230         | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193b5e66b830444dc3358e7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s90=
5d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s90=
5d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193b5e66b830444dc335=
8e8
        failing since 0 day (last pass: v5.15.1-26-g09a73fe37edc, first fai=
l: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
meson-gxl-s905x-khadas-vim   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193b69d9d17adc36d3358fc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s90=
5x-khadas-vim.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s90=
5x-khadas-vim.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193b69d9d17adc36d335=
8fd
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193b52eb4625778563358fb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s90=
5x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s90=
5x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193b52eb462577856335=
8fc
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
meson-sm1-khadas-vim3l       | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193b550f23fbfc3753358e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-kha=
das-vim3l.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-kha=
das-vim3l.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193b550f23fbfc375335=
8e1
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
mt8173-elm-hana              | arm64 | lab-collabora   | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193b530e9ad4d8e553358de

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-collabora/baseline-mt8173-elm-h=
ana.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-collabora/baseline-mt8173-elm-h=
ana.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193b530e9ad4d8e55335=
8df
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora   | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193b529b4625778563358eb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-collabora/baseline-mt8183-kukui=
-jacuzzi-juniper-sku16.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-collabora/baseline-mt8183-kukui=
-jacuzzi-juniper-sku16.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193b529b462577856335=
8ec
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qcom-qdf2400                 | arm64 | lab-linaro-lkft | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193b5d424fb03712c335954

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-linaro-lkft/baseline-qcom-qdf24=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-linaro-lkft/baseline-qcom-qdf24=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193b5d424fb03712c335=
955
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qemu_arm64-virt-gicv2        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193b52c11d58aac053358f7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193b52c11d58aac05335=
8f8
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qemu_arm64-virt-gicv2        | arm64 | lab-broonie     | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193b52711d58aac053358de

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193b52711d58aac05335=
8df
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qemu_arm64-virt-gicv2        | arm64 | lab-cip         | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193b5b63703a70f27335910

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-cip/baseline-qemu_arm64-virt-gi=
cv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-cip/baseline-qemu_arm64-virt-gi=
cv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193b5b63703a70f27335=
911
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193b505d642eae7053358dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193b505d642eae705335=
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


  Details:     https://kernelci.org/test/plan/id/6193b52616d61ffe1f3358ff

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193b52616d61ffe1f335=
900
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-cip         | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193b56691175140c53358f6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-cip/baseline-qemu_arm64-virt-gi=
cv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-cip/baseline-qemu_arm64-virt-gi=
cv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193b56691175140c5335=
8f7
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qemu_arm64-virt-gicv3        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193b4efddb4ffce363358e9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193b4efddb4ffce36335=
8ea
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qemu_arm64-virt-gicv3        | arm64 | lab-broonie     | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193b50a6f2d07edc03358f3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193b50a6f2d07edc0335=
8f4
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qemu_arm64-virt-gicv3        | arm64 | lab-cip         | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193b522b4625778563358e4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-cip/baseline-qemu_arm64-virt-gi=
cv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-cip/baseline-qemu_arm64-virt-gi=
cv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193b522b462577856335=
8e5
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193b51a16d61ffe1f3358f3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193b51a16d61ffe1f335=
8f4
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie     | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193b5315e723447c33358fe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193b5315e723447c3335=
8ff
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-cip         | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193b585b4a1774cce3358f5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-cip/baseline-qemu_arm64-virt-gi=
cv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-cip/baseline-qemu_arm64-virt-gi=
cv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193b585b4a1774cce335=
8f6
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
r8a774a1-hihope-rzg2m-ex     | arm64 | lab-cip         | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193b54b8f2db753c83358f2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-cip/baseline-r8a774a1-hihope-rz=
g2m-ex.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-cip/baseline-r8a774a1-hihope-rz=
g2m-ex.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193b54b8f2db753c8335=
8f3
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
r8a774b1-hihope-rzg2n-ex     | arm64 | lab-cip         | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193b656a1682ecdb23358f9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-cip/baseline-r8a774b1-hihope-rz=
g2n-ex.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-cip/baseline-r8a774b1-hihope-rz=
g2n-ex.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193b656a1682ecdb2335=
8fa
        new failure (last pass: v5.15.2-181-g9a604828be7c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
r8a774c0-ek874               | arm64 | lab-cip         | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193b69240fa174120335915

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-cip/baseline-r8a774c0-ek874.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-cip/baseline-r8a774c0-ek874.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193b69240fa174120335=
916
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
r8a77960-ulcb                | arm64 | lab-collabora   | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193ed08a87843d6853358e8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-collabora/baseline-r8a77960-ulc=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-collabora/baseline-r8a77960-ulc=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193ed08a87843d685335=
8e9
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-915-gb71b884d1f9b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
rk3399-gru-kevin             | arm64 | lab-collabora   | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193b59907557c728e335911

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193b59907557c728e335=
912
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
sun50i-h6-pine-h64           | arm64 | lab-collabora   | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193b5315e723447c3335901

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-pi=
ne-h64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-pi=
ne-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193b5315e723447c3335=
902
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig | regressions
-----------------------------+-------+-----------------+----------+--------=
---+------------
zynqmp-zcu102                | arm64 | lab-cip         | gcc-10   | defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6193b506d642eae7053358df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-cip/baseline-zynqmp-zcu102.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.2-9=
24-g5bcef522d237/arm64/defconfig/gcc-10/lab-cip/baseline-zynqmp-zcu102.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193b506d642eae705335=
8e0
        failing since 0 day (last pass: v5.15.2-181-g9a604828be7c, first fa=
il: v5.15.2-917-g2a257c5e57ee) =

 =20
