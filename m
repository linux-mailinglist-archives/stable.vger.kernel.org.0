Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F613592FA0
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 15:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbiHONRG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 09:17:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242945AbiHONRF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 09:17:05 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83F7717E26
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 06:17:02 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id 130so6341505pfy.6
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 06:17:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=Qt3RvdilF8RBSZWdfrHQ8TYeNBJ4VCX7BqubgjrsvGM=;
        b=laFt/1qHOYe4FNjvJ6V4cVh/aho57+4GXpdXQYIFpZocKp/g4PsFBlZlDEyPc7DS5/
         2yJBPAdEawDSezAN7TxGiBV56SGt7F0TynxRMVis0blD+J42LMWzCs8/2H9prqMiXbDx
         m2WdM/EcCcp+32DouLUME++TGtfbTXyskbtUUaMNamhG1Eoqy4+Yzl5c1bATPw1yKE47
         BF+XjRFl2v264HGPWf2nzvjYMh3wcAXAVfZl00rXtEdjshA4wUdU0mcK5Dz9UsUJ7oCk
         k/Gmfg5BGStnb8ZGaSJd5Soqzhthoc6fKDP7CP8m9aUJZOv5lfCM3NihsWFnZTbKgvrG
         hXuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=Qt3RvdilF8RBSZWdfrHQ8TYeNBJ4VCX7BqubgjrsvGM=;
        b=tVS704DmF1BAsgESspBjFtudVsVOo8vFpcbnhzWM+ANcEQS2pkHHAkdYLxPCFEXNTG
         1l1O5/pt3/fO0yF5sDBEhi7fB9cLIYSOysCiPc1+dWn1+EundORBc7DpcWK6DyTfXG/c
         M3QkXkefLhtHxjzfvJ7zzgemCnDMxOvytZ2gfqNUes8OGJo3xS9qlcKDXHkHqhuTT3S0
         eKun0zlRG8etuiYU1AckqlpFmM7UmF5NpuLcFRYSm9kcJIhnuS9RgYfdDRRR6rik6N3S
         z+3Q9kVGc6ZTqXqK0bq3xJ88vs6IiaeHOKl7rj7z6jXFOHgiyz/27cRW577U3xGQb1RH
         zPdQ==
X-Gm-Message-State: ACgBeo2ged0z+HsY61/g4/C86aBLQMbbdV9xXlpwCBpQiBi5EBE0ngOG
        QzDiD+lFsjlVDGr3VpcQ32fXqD4xrwfVzfRn
X-Google-Smtp-Source: AA6agR6i3zPMrdyL8XZSTcZeU3N2roeckAvy2urm4HrEPXWX7zWvkEJtM28+rdpnJvF9Y1xROUAuUA==
X-Received: by 2002:a65:490e:0:b0:41c:5b91:e845 with SMTP id p14-20020a65490e000000b0041c5b91e845mr13800404pgs.436.1660569421533;
        Mon, 15 Aug 2022 06:17:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d1-20020a170902cec100b0015e8d4eb1dbsm6993355plg.37.2022.08.15.06.17.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 06:17:01 -0700 (PDT)
Message-ID: <62fa474d.170a0220.ff00c.b557@mx.google.com>
Date:   Mon, 15 Aug 2022 06:17:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.290-152-ga1616983bfc34
Subject: stable-rc/queue/4.14 baseline: 100 runs,
 27 regressions (v4.14.290-152-ga1616983bfc34)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 100 runs, 27 regressions (v4.14.290-152-ga16=
16983bfc34)

Regressions Summary
-------------------

platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
at91sam9g20ek               | arm   | lab-broonie     | gcc-10   | at91_dt_=
defconfig          | 1          =

cubietruck                  | arm   | lab-baylibre    | gcc-10   | sunxi_de=
fconfig            | 1          =

imx6dl-riotboard            | arm   | lab-pengutronix | gcc-10   | multi_v7=
_defconfig         | 1          =

imx6q-sabrelite             | arm   | lab-collabora   | gcc-10   | multi_v7=
_defconfig         | 1          =

imx6sx-sdb                  | arm   | lab-nxp         | gcc-10   | multi_v7=
_defconfig         | 1          =

imx6ul-14x14-evk            | arm   | lab-nxp         | gcc-10   | multi_v7=
_defconfig         | 1          =

imx6ul-pico-hobbit          | arm   | lab-pengutronix | gcc-10   | multi_v7=
_defconfig         | 1          =

jetson-tk1                  | arm   | lab-baylibre    | gcc-10   | multi_v7=
_defconfig         | 1          =

jetson-tk1                  | arm   | lab-baylibre    | gcc-10   | tegra_de=
fconfig            | 1          =

odroid-xu3                  | arm   | lab-collabora   | gcc-10   | exynos_d=
efconfig           | 1          =

odroid-xu3                  | arm   | lab-collabora   | gcc-10   | multi_v7=
_defconfig         | 1          =

qemu_arm64-virt-gicv2       | arm64 | lab-broonie     | gcc-10   | defconfi=
g+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2       | arm64 | lab-collabora   | gcc-10   | defconfi=
g+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi  | arm64 | lab-broonie     | gcc-10   | defconfi=
g+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi  | arm64 | lab-collabora   | gcc-10   | defconfi=
g+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3       | arm64 | lab-broonie     | gcc-10   | defconfi=
g+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3       | arm64 | lab-collabora   | gcc-10   | defconfi=
g+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi  | arm64 | lab-broonie     | gcc-10   | defconfi=
g+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi  | arm64 | lab-collabora   | gcc-10   | defconfi=
g+arm64-chromebook | 1          =

sun4i-a10-olinuxino-lime    | arm   | lab-baylibre    | gcc-10   | sunxi_de=
fconfig            | 1          =

sun5i-a13-olinuxino-micro   | arm   | lab-baylibre    | gcc-10   | sunxi_de=
fconfig            | 1          =

sun7i-a20-cubieboard2       | arm   | lab-baylibre    | gcc-10   | sunxi_de=
fconfig            | 1          =

sun7i-a20-cubieboard2       | arm   | lab-clabbe      | gcc-10   | sunxi_de=
fconfig            | 1          =

sun7i-a20-olinuxino-lime2   | arm   | lab-baylibre    | gcc-10   | sunxi_de=
fconfig            | 1          =

sun8i-a33-olinuxino         | arm   | lab-clabbe      | gcc-10   | sunxi_de=
fconfig            | 1          =

sun8i-h2-plus-orangepi-zero | arm   | lab-baylibre    | gcc-10   | sunxi_de=
fconfig            | 1          =

sun8i-h3-orangepi-pc        | arm   | lab-clabbe      | gcc-10   | sunxi_de=
fconfig            | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.290-152-ga1616983bfc34/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.290-152-ga1616983bfc34
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a1616983bfc34dda5aba6f24c0f7e473d1876fb9 =



Test Regressions
---------------- =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
at91sam9g20ek               | arm   | lab-broonie     | gcc-10   | at91_dt_=
defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/62f8359b19f362262cdaf058

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91s=
am9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91s=
am9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f8359b19f362262cdaf=
059
        failing since 0 day (last pass: v4.14.290-20-ga295b3a60a7eb, first =
fail: v4.14.290-39-gb218cc2aa47dd) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
cubietruck                  | arm   | lab-baylibre    | gcc-10   | sunxi_de=
fconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/62f834b6e03dd69cdadaf064

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubiet=
ruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubiet=
ruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f834b6e03dd69cdadaf=
065
        failing since 0 day (last pass: v4.14.290-25-gbc7b4d3fdf350, first =
fail: v4.14.290-39-gb218cc2aa47dd) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
imx6dl-riotboard            | arm   | lab-pengutronix | gcc-10   | multi_v7=
_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62f839410d6fee76cadaf07e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f839410d6fee76cadaf=
07f
        failing since 0 day (last pass: v4.14.290-20-ga295b3a60a7eb, first =
fail: v4.14.290-39-gb218cc2aa47dd) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
imx6q-sabrelite             | arm   | lab-collabora   | gcc-10   | multi_v7=
_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62f837baa8aca981bddaf077

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-im=
x6q-sabrelite.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-im=
x6q-sabrelite.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f837baa8aca981bddaf=
078
        failing since 0 day (last pass: v4.14.290-20-ga295b3a60a7eb, first =
fail: v4.14.290-39-gb218cc2aa47dd) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
imx6sx-sdb                  | arm   | lab-nxp         | gcc-10   | multi_v7=
_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62f837f71438a557badaf05d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx-s=
db.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx-s=
db.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f837f71438a557badaf=
05e
        failing since 0 day (last pass: v4.14.290-20-ga295b3a60a7eb, first =
fail: v4.14.290-39-gb218cc2aa47dd) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
imx6ul-14x14-evk            | arm   | lab-nxp         | gcc-10   | multi_v7=
_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62f837f987a15874f2daf078

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-1=
4x14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-1=
4x14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f837f987a15874f2daf=
079
        failing since 0 day (last pass: v4.14.290-20-ga295b3a60a7eb, first =
fail: v4.14.290-39-gb218cc2aa47dd) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
imx6ul-pico-hobbit          | arm   | lab-pengutronix | gcc-10   | multi_v7=
_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62f837c5a8aca981bddaf082

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f837c5a8aca981bddaf=
083
        failing since 0 day (last pass: v4.14.290-20-ga295b3a60a7eb, first =
fail: v4.14.290-39-gb218cc2aa47dd) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
jetson-tk1                  | arm   | lab-baylibre    | gcc-10   | multi_v7=
_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62f83979741a6f7986daf059

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jet=
son-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jet=
son-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f83979741a6f7986daf=
05a
        failing since 0 day (last pass: v4.14.290-20-ga295b3a60a7eb, first =
fail: v4.14.290-39-gb218cc2aa47dd) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
jetson-tk1                  | arm   | lab-baylibre    | gcc-10   | tegra_de=
fconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/62f838244e90b8d5d9daf056

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f838244e90b8d5d9daf=
057
        failing since 0 day (last pass: v4.14.290-20-ga295b3a60a7eb, first =
fail: v4.14.290-39-gb218cc2aa47dd) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
odroid-xu3                  | arm   | lab-collabora   | gcc-10   | exynos_d=
efconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62f837ef1438a557badaf056

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odro=
id-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odro=
id-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f837ef1438a557badaf=
057
        failing since 0 day (last pass: v4.14.290-25-gbc7b4d3fdf350, first =
fail: v4.14.290-39-gb218cc2aa47dd) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
odroid-xu3                  | arm   | lab-collabora   | gcc-10   | multi_v7=
_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62f83c3c75849d2fe8daf068

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-od=
roid-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-od=
roid-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f83c3c75849d2fe8daf=
069
        failing since 0 day (last pass: v4.14.290-20-ga295b3a60a7eb, first =
fail: v4.14.290-39-gb218cc2aa47dd) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
qemu_arm64-virt-gicv2       | arm64 | lab-broonie     | gcc-10   | defconfi=
g+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62f8364d5c86327db4daf068

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f8364d5c86327db4daf=
069
        failing since 19 days (last pass: v4.14.267-41-g23609abc0d54, first=
 fail: v4.14.289-19-g8ed326806c84) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
qemu_arm64-virt-gicv2       | arm64 | lab-collabora   | gcc-10   | defconfi=
g+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62f836375c86327db4daf05d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f836375c86327db4daf=
05e
        failing since 19 days (last pass: v4.14.267-41-g23609abc0d54, first=
 fail: v4.14.289-19-g8ed326806c84) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
qemu_arm64-virt-gicv2-uefi  | arm64 | lab-broonie     | gcc-10   | defconfi=
g+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62f8364fb6cdd501bfdaf05d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f8364fb6cdd501bfdaf=
05e
        failing since 19 days (last pass: v4.14.267-41-g23609abc0d54, first=
 fail: v4.14.289-19-g8ed326806c84) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
qemu_arm64-virt-gicv2-uefi  | arm64 | lab-collabora   | gcc-10   | defconfi=
g+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62f83636dfc95846b8daf080

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f83636dfc95846b8daf=
081
        failing since 19 days (last pass: v4.14.267-41-g23609abc0d54, first=
 fail: v4.14.289-19-g8ed326806c84) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
qemu_arm64-virt-gicv3       | arm64 | lab-broonie     | gcc-10   | defconfi=
g+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62f8364cb6cdd501bfdaf057

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f8364cb6cdd501bfdaf=
058
        failing since 19 days (last pass: v4.14.267-41-g23609abc0d54, first=
 fail: v4.14.289-19-g8ed326806c84) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
qemu_arm64-virt-gicv3       | arm64 | lab-collabora   | gcc-10   | defconfi=
g+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62f83636dfc95846b8daf083

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f83636dfc95846b8daf=
084
        failing since 19 days (last pass: v4.14.267-41-g23609abc0d54, first=
 fail: v4.14.289-19-g8ed326806c84) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
qemu_arm64-virt-gicv3-uefi  | arm64 | lab-broonie     | gcc-10   | defconfi=
g+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62f836505c86327db4daf06e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f836505c86327db4daf=
06f
        failing since 19 days (last pass: v4.14.267-41-g23609abc0d54, first=
 fail: v4.14.289-19-g8ed326806c84) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
qemu_arm64-virt-gicv3-uefi  | arm64 | lab-collabora   | gcc-10   | defconfi=
g+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62f836375c86327db4daf05a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f836375c86327db4daf=
05b
        failing since 19 days (last pass: v4.14.267-41-g23609abc0d54, first=
 fail: v4.14.289-19-g8ed326806c84) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
sun4i-a10-olinuxino-lime    | arm   | lab-baylibre    | gcc-10   | sunxi_de=
fconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/62f834d9e03dd69cdadaf073

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun4i-=
a10-olinuxino-lime.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun4i-=
a10-olinuxino-lime.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f834d9e03dd69cdadaf=
074
        failing since 0 day (last pass: v4.14.290-25-gbc7b4d3fdf350, first =
fail: v4.14.290-39-gb218cc2aa47dd) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
sun5i-a13-olinuxino-micro   | arm   | lab-baylibre    | gcc-10   | sunxi_de=
fconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/62f834d8e03dd69cdadaf070

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5i-=
a13-olinuxino-micro.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5i-=
a13-olinuxino-micro.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f834d8e03dd69cdadaf=
071
        failing since 0 day (last pass: v4.14.290-25-gbc7b4d3fdf350, first =
fail: v4.14.290-39-gb218cc2aa47dd) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
sun7i-a20-cubieboard2       | arm   | lab-baylibre    | gcc-10   | sunxi_de=
fconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/62f834b8625a711249daf056

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-=
a20-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-=
a20-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f834b8625a711249daf=
057
        failing since 0 day (last pass: v4.14.290-25-gbc7b4d3fdf350, first =
fail: v4.14.290-39-gb218cc2aa47dd) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
sun7i-a20-cubieboard2       | arm   | lab-clabbe      | gcc-10   | sunxi_de=
fconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/62f834b55c7ed6bb72daf073

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-a2=
0-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-a2=
0-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f834b55c7ed6bb72daf=
074
        failing since 0 day (last pass: v4.14.290-25-gbc7b4d3fdf350, first =
fail: v4.14.290-39-gb218cc2aa47dd) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
sun7i-a20-olinuxino-lime2   | arm   | lab-baylibre    | gcc-10   | sunxi_de=
fconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/62f87d8f4ef0c86964daf056

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-=
a20-olinuxino-lime2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-=
a20-olinuxino-lime2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f87d8f4ef0c86964daf=
057
        failing since 0 day (last pass: v4.14.290-25-gbc7b4d3fdf350, first =
fail: v4.14.290-39-gb218cc2aa47dd) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
sun8i-a33-olinuxino         | arm   | lab-clabbe      | gcc-10   | sunxi_de=
fconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/62f834c9c7132beedbdaf077

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a3=
3-olinuxino.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a3=
3-olinuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f834c9c7132beedbdaf=
078
        failing since 0 day (last pass: v4.14.290-25-gbc7b4d3fdf350, first =
fail: v4.14.290-39-gb218cc2aa47dd) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
sun8i-h2-plus-orangepi-zero | arm   | lab-baylibre    | gcc-10   | sunxi_de=
fconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/62f834c6923ff375d2daf057

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-=
h2-plus-orangepi-zero.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-=
h2-plus-orangepi-zero.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f834c6923ff375d2daf=
058
        failing since 0 day (last pass: v4.14.290-25-gbc7b4d3fdf350, first =
fail: v4.14.290-39-gb218cc2aa47dd) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
sun8i-h3-orangepi-pc        | arm   | lab-clabbe      | gcc-10   | sunxi_de=
fconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/62f83609dfc95846b8daf06a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3=
-orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.290=
-152-ga1616983bfc34/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3=
-orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f83609dfc95846b8daf=
06b
        failing since 0 day (last pass: v4.14.290-25-gbc7b4d3fdf350, first =
fail: v4.14.290-39-gb218cc2aa47dd) =

 =20
