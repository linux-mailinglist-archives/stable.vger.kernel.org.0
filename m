Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 141F9602EA2
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 16:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbiJROgP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 10:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbiJROgO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 10:36:14 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FCD9C96E6
        for <stable@vger.kernel.org>; Tue, 18 Oct 2022 07:36:10 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id y191so14282735pfb.2
        for <stable@vger.kernel.org>; Tue, 18 Oct 2022 07:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=SE//bdwIa5vl1oItX+U0Ts0n5uXYPxd4TE98lmatznQ=;
        b=MZVNC4rENCLj2SM9r8FwVWXRvWpaFQcNftiKfJ5GVFAXMQ7BzSsM32027jOdSVXdJO
         0a2r89ZmfglPymGA4ALrxgaNaDMsZmVgOiOxRkaxfy+lRQ2wZuDLr8nXAeIjVzIa/crp
         roOlH8QtKL3LEL/o+x1fVC82/DGUoT3kqhrvQlMN2F9Cy1jLMs5MKsCn0+oBtg5tQCra
         R4GMP78ZlAmwi5pCgvUaouBV9Pp8KlqppBfTT4Tg6ovV1vcLqkE/Svgmy57HdePA43ZR
         qGybCkllIsUX7Gm1rcnM1IFLBZ2EOePaQFEJiFOv13UtyjhRrBDf/iCKPcC7D4MXaJ5U
         nbPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SE//bdwIa5vl1oItX+U0Ts0n5uXYPxd4TE98lmatznQ=;
        b=OjyQEa813jfNgnoZHWe/XvjaYOZf4WOAHUpKL6zpUAFLfs1he4uKuPzQE1HDXoGT5E
         fqr+8qjSv9tCr/EmALrMXamLgNeoiyZAoVWhg4WEhzf5SPcWnDEQM4SxIqMh1+oyQmAO
         Iei5lQrcvWH5q9QxSm1i4vpl3vQ77R4Pl94mqHIIF0ZDm9CQeskzQ3DnTKe7fVZYsGBo
         GNfmgcI0zi+2/N8bqaAPMQp5U1l/KOs69c5Yb4XsG3vjRMnC84LlWgk02YS6KzCL3BY8
         bM5CBpvf8r7GL0coZP+pCbdIDd4JepRLOD4QDaHzysfr/7Sav6s1TFpsAtFa0bmmH9/C
         y2vg==
X-Gm-Message-State: ACrzQf24Z6X+Fg4BM/qFNzLeO3FJTIzTKpcOTAJFVKgcAAg1nyBm4SLA
        VvLYv17r9fi+6DW0eUoeeFGVkrrg4RE98nbr
X-Google-Smtp-Source: AMsMyM6IuBiCHKjHQNVGPf7gY1sdEycGe7nODEyRKKvaSW3MoBMcUNoR7VlgNHtXBR1Nlvrf799iOA==
X-Received: by 2002:a62:d448:0:b0:565:ef61:ee0d with SMTP id u8-20020a62d448000000b00565ef61ee0dmr3503789pfl.73.1666103768608;
        Tue, 18 Oct 2022 07:36:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id cp5-20020a170902e78500b0017f5c7d3931sm8627884plb.282.2022.10.18.07.36.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 07:36:08 -0700 (PDT)
Message-ID: <634eb9d8.170a0220.a4bc7.ff99@mx.google.com>
Date:   Tue, 18 Oct 2022 07:36:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.74-620-g8307726994d1
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 126 runs,
 43 regressions (v5.15.74-620-g8307726994d1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 126 runs, 43 regressions (v5.15.74-620-g8307=
726994d1)

Regressions Summary
-------------------

platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
bcm2711-rpi-4-b              | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =

imx8mn-ddr4-evk              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

juno-uboot                   | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =

kontron-bl-imx8mm            | arm64 | lab-kontron     | gcc-10   | defconf=
ig                  | 1          =

kontron-kbox-a-230-ls        | arm64 | lab-kontron     | gcc-10   | defconf=
ig                  | 1          =

kontron-pitx-imx8m           | arm64 | lab-kontron     | gcc-10   | defconf=
ig                  | 1          =

kontron-sl28-var3-ads2       | arm64 | lab-kontron     | gcc-10   | defconf=
ig                  | 1          =

meson-g12a-sei510            | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

meson-g12a-u200              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

meson-g12a-x96-max           | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

meson-g12b-a311d-khadas-vim3 | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =

meson-g12b-odroid-n2         | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

meson-gxbb-nanopi-k2         | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

meson-gxbb-p200              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

meson-gxl-s805x-libretech-ac | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

meson-gxl-s905d-p230         | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

meson-gxl-s905x-khadas-vim   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

meson-gxl-s905x-libretech-cc | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =

meson-gxm-khadas-vim2        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

meson-sm1-khadas-vim3l       | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

mt8173-elm-hana              | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

qcom-qdf2400                 | arm64 | lab-linaro-lkft | gcc-10   | defconf=
ig                  | 1          =

qcom-qdf2400                 | arm64 | lab-linaro-lkft | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

rk3399-gru-kevin             | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

rk3399-roc-pc                | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =

rk3399-rock-pi-4b            | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =

sun50i-a64-bananapi-m64      | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =

sun50i-h6-orangepi-3         | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =

sun50i-h6-pine-h64           | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

sun50i-h6-pine-h64           | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =

sun50i-h6-pine-h64           | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.74-620-g8307726994d1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.74-620-g8307726994d1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8307726994d17061ea001a44bed495349a6b39f5 =



Test Regressions
---------------- =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
bcm2711-rpi-4-b              | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/634e84b58f12947838c2a845

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-collabora/baseline-bcm2711-rpi=
-4-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-collabora/baseline-bcm2711-rpi=
-4-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634e84b58f12947838c2a=
846
        failing since 0 day (last pass: v5.15.74-135-g19e8e8e20e2b, first f=
ail: v5.15.74-617-g3ae4b7de8c29) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx8mn-ddr4-evk              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/634e8524bf6728eddbc2a84f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4-=
evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4-=
evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634e8524bf6728eddbc2a=
850
        failing since 0 day (last pass: v5.15.74-135-g19e8e8e20e2b, first f=
ail: v5.15.74-617-g3ae4b7de8c29) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
juno-uboot                   | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/634e8529847b7c2a12c2a852

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-broonie/baseline-juno-uboot.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-broonie/baseline-juno-uboot.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634e8529847b7c2a12c2a=
853
        failing since 0 day (last pass: v5.15.74-135-g19e8e8e20e2b, first f=
ail: v5.15.74-617-g3ae4b7de8c29) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
kontron-bl-imx8mm            | arm64 | lab-kontron     | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/634e85039e35aceaf6c2a85f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-bl-im=
x8mm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-bl-im=
x8mm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634e85049e35aceaf6c2a=
860
        failing since 0 day (last pass: v5.15.74-135-g19e8e8e20e2b, first f=
ail: v5.15.74-617-g3ae4b7de8c29) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
kontron-kbox-a-230-ls        | arm64 | lab-kontron     | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/634e849183403a46c0c2a852

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-kbox-=
a-230-ls.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-kbox-=
a-230-ls.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634e849183403a46c0c2a=
853
        failing since 0 day (last pass: v5.15.74-135-g19e8e8e20e2b, first f=
ail: v5.15.74-617-g3ae4b7de8c29) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
kontron-pitx-imx8m           | arm64 | lab-kontron     | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/634e8503bf6728eddbc2a844

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-=
imx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-=
imx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634e8503bf6728eddbc2a=
845
        failing since 0 day (last pass: v5.15.74-135-g19e8e8e20e2b, first f=
ail: v5.15.74-617-g3ae4b7de8c29) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
kontron-sl28-var3-ads2       | arm64 | lab-kontron     | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/634e84e36aaf6b7c42c2a88f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-sl28-=
var3-ads2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-sl28-=
var3-ads2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634e84e36aaf6b7c42c2a=
890
        failing since 0 day (last pass: v5.15.74-135-g19e8e8e20e2b, first f=
ail: v5.15.74-624-g18dff220d7d2) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12a-sei510            | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/634e847b4055ba0206c2a842

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-s=
ei510.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-s=
ei510.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634e847b4055ba0206c2a=
843
        failing since 0 day (last pass: v5.15.74-135-g19e8e8e20e2b, first f=
ail: v5.15.74-617-g3ae4b7de8c29) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12a-u200              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/634e84b2499e5c5777c2a841

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-u=
200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-u=
200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634e84b2499e5c5777c2a=
842
        failing since 0 day (last pass: v5.15.73-33-g934604a7d346, first fa=
il: v5.15.74-624-g18dff220d7d2) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12a-x96-max           | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/634e84e0e0493ec602c2a85f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-x=
96-max.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-x=
96-max.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634e84e0e0493ec602c2a=
860
        failing since 0 day (last pass: v5.15.74-135-g19e8e8e20e2b, first f=
ail: v5.15.74-617-g3ae4b7de8c29) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/634e9fcdcf5d16e577c2a862

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-a=
311d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-a=
311d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634e9fcdcf5d16e577c2a=
863
        failing since 0 day (last pass: v5.15.74-135-g19e8e8e20e2b, first f=
ail: v5.15.74-617-g3ae4b7de8c29) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/634e858b8a6b45349fc2a85d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12b-=
a311d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12b-=
a311d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634e858b8a6b45349fc2a=
85e
        failing since 0 day (last pass: v5.15.74-135-g19e8e8e20e2b, first f=
ail: v5.15.74-617-g3ae4b7de8c29) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12b-odroid-n2         | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/634e861a91d0b32e41c2a86b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-o=
droid-n2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-o=
droid-n2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634e861a91d0b32e41c2a=
86c
        failing since 0 day (last pass: v5.15.74-135-g19e8e8e20e2b, first f=
ail: v5.15.74-617-g3ae4b7de8c29) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-gxbb-nanopi-k2         | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/634e8495b07161df2cc2a873

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-n=
anopi-k2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-n=
anopi-k2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634e8495b07161df2cc2a=
874
        new failure (last pass: v5.15.72-36-g40cafafcdb983) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-gxbb-p200              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/634e854d59376821dac2a854

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p=
200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p=
200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634e854d59376821dac2a=
855
        failing since 0 day (last pass: v5.15.74-135-g19e8e8e20e2b, first f=
ail: v5.15.74-617-g3ae4b7de8c29) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-gxl-s805x-libretech-ac | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/634e8490d06f7ed092c2a841

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s8=
05x-libretech-ac.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s8=
05x-libretech-ac.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634e8490d06f7ed092c2a=
842
        new failure (last pass: v5.15.72-36-g40cafafcdb983) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-gxl-s905d-p230         | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/634e84d57008043523c2a842

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s9=
05d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s9=
05d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634e84d67008043523c2a=
843
        failing since 0 day (last pass: v5.15.74-135-g19e8e8e20e2b, first f=
ail: v5.15.74-617-g3ae4b7de8c29) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-gxl-s905x-khadas-vim   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/634e84aa4055ba0206c2a85e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s9=
05x-khadas-vim.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s9=
05x-khadas-vim.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634e84aa4055ba0206c2a=
85f
        new failure (last pass: v5.15.72-36-g1dafe9f099a1) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/634e851f847b7c2a12c2a84f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-clabbe/baseline-meson-gxl-s905=
x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-clabbe/baseline-meson-gxl-s905=
x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634e851f847b7c2a12c2a=
850
        failing since 0 day (last pass: v5.15.74-135-g19e8e8e20e2b, first f=
ail: v5.15.74-617-g3ae4b7de8c29) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-gxm-khadas-vim2        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/634e84a14055ba0206c2a85b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-kh=
adas-vim2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-kh=
adas-vim2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634e84a14055ba0206c2a=
85c
        new failure (last pass: v5.15.72-36-g40cafafcdb983) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-sm1-khadas-vim3l       | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/634e84f2b1b680cf95c2a85f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-kh=
adas-vim3l.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-kh=
adas-vim3l.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634e84f2b1b680cf95c2a=
860
        failing since 0 day (last pass: v5.15.73-33-g934604a7d346, first fa=
il: v5.15.74-624-g18dff220d7d2) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
mt8173-elm-hana              | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/634e865a0c7d915d71c2a851

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-mt8173-elm-hana.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-mt8173-elm-hana.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634e865a0c7d915d71c2a=
852
        failing since 0 day (last pass: v5.15.74-135-g19e8e8e20e2b, first f=
ail: v5.15.74-617-g3ae4b7de8c29) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/634e86608c7947dd53c2a876

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-mt8183-kukui-jacuzzi-juniper-sku16.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-mt8183-kukui-jacuzzi-juniper-sku16.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634e86608c7947dd53c2a=
877
        failing since 0 day (last pass: v5.15.74-135-g19e8e8e20e2b, first f=
ail: v5.15.74-617-g3ae4b7de8c29) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qcom-qdf2400                 | arm64 | lab-linaro-lkft | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/634e8726db1189cf96c2a85e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-linaro-lkft/baseline-qcom-qdf2=
400.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-linaro-lkft/baseline-qcom-qdf2=
400.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634e8727db1189cf96c2a=
85f
        failing since 0 day (last pass: v5.15.74-135-g19e8e8e20e2b, first f=
ail: v5.15.74-617-g3ae4b7de8c29) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qcom-qdf2400                 | arm64 | lab-linaro-lkft | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/634e89b75faf65a0a4c2a845

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig+arm64-chromebook/gcc-10/lab-linaro-lkft/b=
aseline-qcom-qdf2400.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig+arm64-chromebook/gcc-10/lab-linaro-lkft/b=
aseline-qcom-qdf2400.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634e89b75faf65a0a4c2a=
846
        failing since 0 day (last pass: v5.15.74-135-g19e8e8e20e2b, first f=
ail: v5.15.74-617-g3ae4b7de8c29) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/634e8563ba7d7894aac2a862

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634e8563ba7d7894aac2a=
863
        failing since 0 day (last pass: v5.15.74-135-g19e8e8e20e2b, first f=
ail: v5.15.74-624-g18dff220d7d2) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/634e86ae636538a408c2a887

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634e86ae636538a408c2a=
888
        failing since 0 day (last pass: v5.15.74-135-g19e8e8e20e2b, first f=
ail: v5.15.74-617-g3ae4b7de8c29) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/634e847a7883c8ff9ac2a875

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634e847a7883c8ff9ac2a=
876
        failing since 0 day (last pass: v5.15.74-135-g19e8e8e20e2b, first f=
ail: v5.15.74-624-g18dff220d7d2) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/634e856685d9da9bf0c2a8cf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634e856685d9da9bf0c2a=
8d0
        failing since 0 day (last pass: v5.15.74-135-g19e8e8e20e2b, first f=
ail: v5.15.74-624-g18dff220d7d2) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/634e86cf7ebc800f9dc2a86f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634e86cf7ebc800f9dc2a=
870
        failing since 0 day (last pass: v5.15.74-135-g19e8e8e20e2b, first f=
ail: v5.15.74-617-g3ae4b7de8c29) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/634e84a77883c8ff9ac2a89f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634e84a77883c8ff9ac2a=
8a0
        failing since 0 day (last pass: v5.15.74-135-g19e8e8e20e2b, first f=
ail: v5.15.74-624-g18dff220d7d2) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/634e856385d9da9bf0c2a8cb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634e856385d9da9bf0c2a=
8cc
        failing since 0 day (last pass: v5.15.74-135-g19e8e8e20e2b, first f=
ail: v5.15.74-617-g3ae4b7de8c29) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/634e86c48c37a3b49fc2a84a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634e86c48c37a3b49fc2a=
84b
        failing since 0 day (last pass: v5.15.74-135-g19e8e8e20e2b, first f=
ail: v5.15.74-617-g3ae4b7de8c29) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/634e85460b63f347eac2a84e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634e85460b63f347eac2a=
84f
        failing since 0 day (last pass: v5.15.74-135-g19e8e8e20e2b, first f=
ail: v5.15.74-617-g3ae4b7de8c29) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/634e86ab7263469279c2a867

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634e86ab7263469279c2a=
868
        failing since 0 day (last pass: v5.15.74-135-g19e8e8e20e2b, first f=
ail: v5.15.74-617-g3ae4b7de8c29) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
rk3399-gru-kevin             | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/634e866e8c7947dd53c2a87c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634e866e8c7947dd53c2a=
87d
        failing since 0 day (last pass: v5.15.74-135-g19e8e8e20e2b, first f=
ail: v5.15.74-617-g3ae4b7de8c29) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
rk3399-roc-pc                | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/634e84972c60be3bfac2a847

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-clabbe/baseline-rk3399-roc-pc.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-clabbe/baseline-rk3399-roc-pc.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634e84972c60be3bfac2a=
848
        failing since 0 day (last pass: v5.15.74-135-g19e8e8e20e2b, first f=
ail: v5.15.74-617-g3ae4b7de8c29) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
rk3399-rock-pi-4b            | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/634e84a02c60be3bfac2a84f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-collabora/baseline-rk3399-rock=
-pi-4b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-collabora/baseline-rk3399-rock=
-pi-4b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634e84a02c60be3bfac2a=
850
        failing since 0 day (last pass: v5.15.74-135-g19e8e8e20e2b, first f=
ail: v5.15.74-624-g18dff220d7d2) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-a64-bananapi-m64      | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/634e84b02c60be3bfac2a853

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634e84b02c60be3bfac2a=
854
        failing since 0 day (last pass: v5.15.74-135-g19e8e8e20e2b, first f=
ail: v5.15.74-617-g3ae4b7de8c29) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-h6-orangepi-3         | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/634e859ecef243a48cc2a868

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-oran=
gepi-3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-oran=
gepi-3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634e859ecef243a48cc2a=
869
        failing since 0 day (last pass: v5.15.74-135-g19e8e8e20e2b, first f=
ail: v5.15.74-617-g3ae4b7de8c29) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-h6-pine-h64           | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/634e847cab28442728c2a84e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-h6-pi=
ne-h64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-h6-pi=
ne-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634e847cab28442728c2a=
84f
        new failure (last pass: v5.15.72-36-g1dafe9f099a1) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-h6-pine-h64           | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/634e849dbe066c679cc2a858

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-pine=
-h64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-pine=
-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634e849dbe066c679cc2a=
859
        new failure (last pass: v5.15.72-36-g1dafe9f099a1) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-h6-pine-h64           | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/634e849654691b642dc2a86a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-p=
ine-h64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.74-=
620-g8307726994d1/arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-p=
ine-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634e849754691b642dc2a=
86b
        new failure (last pass: v5.15.72-36-g1dafe9f099a1) =

 =20
