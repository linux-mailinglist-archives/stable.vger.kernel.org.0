Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF4B15930E0
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 16:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242201AbiHOOi5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 10:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232338AbiHOOi4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 10:38:56 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF1B3DA5
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 07:38:53 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 12so6662955pga.1
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 07:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=tG99HSo/MrfQSCrdmILGtfZU1qfpzmte+d0djg1C1Nc=;
        b=aBdb6+lEZdaPwYqQ8xw+DAtpuGfyteeM76jj54IVdB6rEW/t7XkrIqcm9DzyUUXISq
         iuPxWyyYtzmoQgfZg69xqUGxqv1Nm+B7EpoZwp7RtzFutJzzo8KdQQpGfBPv1ZiCFqs6
         7FpfXsHZBCBwKql/uI9R23g99C3CCydt3pp2+axHbyN6A1o2Wzs53Lmt7wqbnusW6EUd
         W8cwG0kdtigzvvTw9lFRmf13N71LaDTHdUwre0J8RhaPAbvO/ml1heu6ivgC0jASDCnT
         hwRCNMCFZggl6Ko4FlMW4NucvalihcukcC8mKJ6+qRVUaLhXY5EIhXJOyK4lZuk7JT8o
         5Z0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=tG99HSo/MrfQSCrdmILGtfZU1qfpzmte+d0djg1C1Nc=;
        b=YSNR7TPZFoFagjhrFX8TiqJIilEPrpOAf0X8CeTQEtqXpsYMbJydqZt3vXTm4OMVei
         Z5hkS2cpDfLIwv8JAlthQuuXZq8ojtD9Edtaqvs06ICx66QWQZ2mFTaXn81b5mmPh6As
         /puXp7WcC+/h6ySINx6yqG1S5EzC2PlEY9ZWGbXy0zmIjqRWFSZMAbPRQyUP6RIByJ8P
         57Pn4HDJG9yERaFx/HIA5AGQGA2ZntVQIzmrZfGj/OwdSmr2/bWgcnR86M0e1qYsxuVj
         HfJPFK3pT6rIhq0SFwEjU58DQlXu5xG8V3RaNw1WtDCkEw1+GPlb4zZZ80wTr2ucaAu/
         ZeQQ==
X-Gm-Message-State: ACgBeo1GOJYRpABGavfrx9Cdn8oCitDbb392ldHoB6E1BlqO9GMJw8qG
        9fas3/VKV/RHCn1AuTp0LnPJJIpp1GZ+/M6U
X-Google-Smtp-Source: AA6agR4eD5/Pn9DPQWxtSpUYdv4JeywlAM09S0s1iESeOfiWfxh80gDRNnnLZRgQfHf71iuIAgheRA==
X-Received: by 2002:a65:604a:0:b0:3f9:f423:b474 with SMTP id a10-20020a65604a000000b003f9f423b474mr13702686pgp.527.1660574332753;
        Mon, 15 Aug 2022 07:38:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h35-20020a635763000000b0041a67913d5bsm5143517pgm.71.2022.08.15.07.38.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 07:38:52 -0700 (PDT)
Message-ID: <62fa5a7c.630a0220.c345c.7d34@mx.google.com>
Date:   Mon, 15 Aug 2022 07:38:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.290-154-gc3e4c291190ba
Subject: stable-rc/linux-4.14.y baseline: 118 runs,
 34 regressions (v4.14.290-154-gc3e4c291190ba)
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

stable-rc/linux-4.14.y baseline: 118 runs, 34 regressions (v4.14.290-154-gc=
3e4c291190ba)

Regressions Summary
-------------------

platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
at91sam9g20ek              | arm   | lab-broonie     | gcc-10   | at91_dt_d=
efconfig          | 1          =

cubietruck                 | arm   | lab-baylibre    | gcc-10   | sunxi_def=
config            | 1          =

imx6dl-riotboard           | arm   | lab-pengutronix | gcc-10   | imx_v6_v7=
_defconfig        | 1          =

imx6dl-riotboard           | arm   | lab-pengutronix | gcc-10   | multi_v7_=
defconfig         | 1          =

imx6q-sabrelite            | arm   | lab-collabora   | gcc-10   | multi_v7_=
defconfig         | 1          =

imx6qp-sabresd             | arm   | lab-nxp         | gcc-10   | imx_v6_v7=
_defconfig        | 1          =

imx6sx-sdb                 | arm   | lab-nxp         | gcc-10   | imx_v6_v7=
_defconfig        | 1          =

imx6sx-sdb                 | arm   | lab-nxp         | gcc-10   | multi_v7_=
defconfig         | 1          =

imx6ul-14x14-evk           | arm   | lab-nxp         | gcc-10   | imx_v6_v7=
_defconfig        | 1          =

imx6ul-14x14-evk           | arm   | lab-nxp         | gcc-10   | multi_v7_=
defconfig         | 1          =

imx6ul-pico-hobbit         | arm   | lab-pengutronix | gcc-10   | imx_v6_v7=
_defconfig        | 1          =

imx6ul-pico-hobbit         | arm   | lab-pengutronix | gcc-10   | multi_v7_=
defconfig         | 1          =

imx7d-sdb                  | arm   | lab-nxp         | gcc-10   | imx_v6_v7=
_defconfig        | 1          =

jetson-tk1                 | arm   | lab-baylibre    | gcc-10   | multi_v7_=
defconfig         | 1          =

jetson-tk1                 | arm   | lab-baylibre    | gcc-10   | tegra_def=
config            | 1          =

meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre    | gcc-10   | defconfig=
                  | 1          =

odroid-xu3                 | arm   | lab-collabora   | gcc-10   | exynos_de=
fconfig           | 1          =

odroid-xu3                 | arm   | lab-collabora   | gcc-10   | multi_v7_=
defconfig         | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie     | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-collabora   | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie     | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie     | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie     | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =

sun4i-a10-olinuxino-lime   | arm   | lab-baylibre    | gcc-10   | sunxi_def=
config            | 1          =

sun5i-a13-olinuxino-micro  | arm   | lab-baylibre    | gcc-10   | sunxi_def=
config            | 1          =

sun7i-a20-cubieboard2      | arm   | lab-baylibre    | gcc-10   | sunxi_def=
config            | 1          =

sun7i-a20-cubieboard2      | arm   | lab-clabbe      | gcc-10   | sunxi_def=
config            | 1          =

sun7i-a20-olinuxino-lime2  | arm   | lab-baylibre    | gcc-10   | sunxi_def=
config            | 1          =

sun8i-a33-olinuxino        | arm   | lab-clabbe      | gcc-10   | sunxi_def=
config            | 1          =

sun8i-h3-orangepi-pc       | arm   | lab-clabbe      | gcc-10   | sunxi_def=
config            | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.290-154-gc3e4c291190ba/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.290-154-gc3e4c291190ba
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c3e4c291190ba7dd6727ba3b4981761372282849 =



Test Regressions
---------------- =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
at91sam9g20ek              | arm   | lab-broonie     | gcc-10   | at91_dt_d=
efconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa287f24a8c443eedaf05c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at9=
1sam9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at9=
1sam9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa287f24a8c443eedaf=
05d
        new failure (last pass: v4.14.290) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
cubietruck                 | arm   | lab-baylibre    | gcc-10   | sunxi_def=
config            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa30d59ac443c5f5daf079

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa30d59ac443c5f5daf=
07a
        new failure (last pass: v4.14.290-13-g428ff765bf44) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
imx6dl-riotboard           | arm   | lab-pengutronix | gcc-10   | imx_v6_v7=
_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa2c97a4aec9728adaf0ac

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseli=
ne-imx6dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseli=
ne-imx6dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa2c97a4aec9728adaf=
0ad
        new failure (last pass: v4.14.290-13-g428ff765bf44) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
imx6dl-riotboard           | arm   | lab-pengutronix | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa30f77e9aff5f12daf079

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx6dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx6dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa30f77e9aff5f12daf=
07a
        new failure (last pass: v4.14.290-13-g428ff765bf44) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
imx6q-sabrelite            | arm   | lab-collabora   | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa2a22bfedcc0d46daf06d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-=
imx6q-sabrelite.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-=
imx6q-sabrelite.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa2a22bfedcc0d46daf=
06e
        new failure (last pass: v4.14.290-13-g428ff765bf44) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
imx6qp-sabresd             | arm   | lab-nxp         | gcc-10   | imx_v6_v7=
_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa29346dd6c6dabddaf06e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6q=
p-sabresd.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6q=
p-sabresd.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa29346dd6c6dabddaf=
06f
        new failure (last pass: v4.14.290-13-g428ff765bf44) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
imx6sx-sdb                 | arm   | lab-nxp         | gcc-10   | imx_v6_v7=
_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa29e65fcb23f1e4daf064

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6s=
x-sdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6s=
x-sdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa29e65fcb23f1e4daf=
065
        new failure (last pass: v4.14.290-13-g428ff765bf44) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
imx6sx-sdb                 | arm   | lab-nxp         | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa2b4f182fba72fadaf05b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx=
-sdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx=
-sdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa2b4f182fba72fadaf=
05c
        new failure (last pass: v4.14.290-13-g428ff765bf44) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
imx6ul-14x14-evk           | arm   | lab-nxp         | gcc-10   | imx_v6_v7=
_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa2a0e5fcb23f1e4daf08b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6u=
l-14x14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6u=
l-14x14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa2a0e5fcb23f1e4daf=
08c
        new failure (last pass: v4.14.290-13-g428ff765bf44) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
imx6ul-14x14-evk           | arm   | lab-nxp         | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa2b76d2460b9f15daf086

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul=
-14x14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul=
-14x14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa2b76d2460b9f15daf=
087
        new failure (last pass: v4.14.290-13-g428ff765bf44) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
imx6ul-pico-hobbit         | arm   | lab-pengutronix | gcc-10   | imx_v6_v7=
_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa339f128fea014adaf077

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseli=
ne-imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseli=
ne-imx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa339f128fea014adaf=
078
        new failure (last pass: v4.14.290-13-g428ff765bf44) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
imx6ul-pico-hobbit         | arm   | lab-pengutronix | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa37ffee3ca2e755daf05e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa37ffee3ca2e755daf=
05f
        new failure (last pass: v4.14.290-13-g428ff765bf44) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
imx7d-sdb                  | arm   | lab-nxp         | gcc-10   | imx_v6_v7=
_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa29322e514b153bdaf056

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d=
-sdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d=
-sdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa29322e514b153bdaf=
057
        new failure (last pass: v4.14.290-13-g428ff765bf44) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
jetson-tk1                 | arm   | lab-baylibre    | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa3a412941f15272daf0b1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-j=
etson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-j=
etson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa3a412941f15272daf=
0b2
        new failure (last pass: v4.14.290-13-g428ff765bf44) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
jetson-tk1                 | arm   | lab-baylibre    | gcc-10   | tegra_def=
config            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa35ecb39606d1addaf061

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa35ecb39606d1addaf=
062
        new failure (last pass: v4.14.290-13-g428ff765bf44) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre    | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa28f63600975311daf092

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gx=
l-s905x-khadas-vim.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gx=
l-s905x-khadas-vim.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa28f63600975311daf=
093
        failing since 41 days (last pass: v4.14.285, first fail: v4.14.286) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
odroid-xu3                 | arm   | lab-collabora   | gcc-10   | exynos_de=
fconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa37b80a8b41b029daf156

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-od=
roid-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-od=
roid-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa37b80a8b41b029daf=
157
        new failure (last pass: v4.14.290-13-g428ff765bf44) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
odroid-xu3                 | arm   | lab-collabora   | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa3c05c122a99478daf083

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-=
odroid-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-=
odroid-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa3c05c122a99478daf=
084
        new failure (last pass: v4.14.290-13-g428ff765bf44) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie     | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa2ee875611d2a38daf09e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm6=
4-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm6=
4-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa2ee875611d2a38daf=
09f
        failing since 96 days (last pass: v4.14.277-55-gfb8b8dfe0168, first=
 fail: v4.14.277-79-ga6b67a30bbcc) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa30c9522a697979daf075

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa30c9522a697979daf=
076
        new failure (last pass: v4.14.267-33-g871c9e115feb) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-collabora   | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa2a84f02e9f8afcdaf07a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora=
/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora=
/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa2a84f02e9f8afcdaf=
07b
        new failure (last pass: v4.14.267-33-g871c9e115feb) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie     | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa2ec075611d2a38daf066

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm6=
4-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm6=
4-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa2ec075611d2a38daf=
067
        failing since 96 days (last pass: v4.14.277-55-gfb8b8dfe0168, first=
 fail: v4.14.277-79-ga6b67a30bbcc) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa30dd7e9aff5f12daf059

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa30dd7e9aff5f12daf=
05a
        failing since 97 days (last pass: v4.14.277-55-gfb8b8dfe0168, first=
 fail: v4.14.277-71-geacdf1a71409) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie     | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa2efe252d10b4a1daf063

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm6=
4-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm6=
4-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa2efe252d10b4a1daf=
064
        failing since 96 days (last pass: v4.14.277-55-gfb8b8dfe0168, first=
 fail: v4.14.277-79-ga6b67a30bbcc) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa30f17e9aff5f12daf070

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa30f17e9aff5f12daf=
071
        failing since 97 days (last pass: v4.14.277-55-gfb8b8dfe0168, first=
 fail: v4.14.277-71-geacdf1a71409) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie     | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa2efc8dd1d6d3d2daf078

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm6=
4-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm6=
4-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa2efc8dd1d6d3d2daf=
079
        failing since 96 days (last pass: v4.14.277-55-gfb8b8dfe0168, first=
 fail: v4.14.277-79-ga6b67a30bbcc) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa30ca522a697979daf078

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa30ca522a697979daf=
079
        failing since 97 days (last pass: v4.14.277-55-gfb8b8dfe0168, first=
 fail: v4.14.277-71-geacdf1a71409) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
sun4i-a10-olinuxino-lime   | arm   | lab-baylibre    | gcc-10   | sunxi_def=
config            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa40f42f646f54a6daf092

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun4=
i-a10-olinuxino-lime.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun4=
i-a10-olinuxino-lime.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa40f42f646f54a6daf=
093
        new failure (last pass: v4.14.290-13-g428ff765bf44) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
sun5i-a13-olinuxino-micro  | arm   | lab-baylibre    | gcc-10   | sunxi_def=
config            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa318e93d1341103daf073

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5=
i-a13-olinuxino-micro.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5=
i-a13-olinuxino-micro.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa318e93d1341103daf=
074
        new failure (last pass: v4.14.290-13-g428ff765bf44) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
sun7i-a20-cubieboard2      | arm   | lab-baylibre    | gcc-10   | sunxi_def=
config            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa285472653544abdaf05b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7=
i-a20-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7=
i-a20-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa285472653544abdaf=
05c
        new failure (last pass: v4.14.290-13-g428ff765bf44) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
sun7i-a20-cubieboard2      | arm   | lab-clabbe      | gcc-10   | sunxi_def=
config            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa287912a1bdd157daf075

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-=
a20-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-=
a20-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa287912a1bdd157daf=
076
        new failure (last pass: v4.14.290-13-g428ff765bf44) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
sun7i-a20-olinuxino-lime2  | arm   | lab-baylibre    | gcc-10   | sunxi_def=
config            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa46b07cf48a3c1edaf06b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7=
i-a20-olinuxino-lime2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7=
i-a20-olinuxino-lime2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa46b07cf48a3c1edaf=
06c
        new failure (last pass: v4.14.290-13-g428ff765bf44) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
sun8i-a33-olinuxino        | arm   | lab-clabbe      | gcc-10   | sunxi_def=
config            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa286584110203dfdaf05f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-=
a33-olinuxino.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-=
a33-olinuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa286584110203dfdaf=
060
        new failure (last pass: v4.14.290-13-g428ff765bf44) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
sun8i-h3-orangepi-pc       | arm   | lab-clabbe      | gcc-10   | sunxi_def=
config            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa29cd929304f28bdaf060

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-=
h3-orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-154-gc3e4c291190ba/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-=
h3-orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa29cd929304f28bdaf=
061
        new failure (last pass: v4.14.290-13-g428ff765bf44) =

 =20
