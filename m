Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F38035BEDF6
	for <lists+stable@lfdr.de>; Tue, 20 Sep 2022 21:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbiITTm1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 15:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230506AbiITTm0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 15:42:26 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E276B8F6
        for <stable@vger.kernel.org>; Tue, 20 Sep 2022 12:42:23 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id j6-20020a17090a694600b00200bba67dadso3475116pjm.5
        for <stable@vger.kernel.org>; Tue, 20 Sep 2022 12:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=U4qoS/wn5EXo1uhw7OC1SLl4kqwNutLCer+sOn07EKk=;
        b=BzaPezPtLEB9AXu2ChrQ6Zc8a8CTiqMwp1rVrmG5vdExXYlZYKquoqqyYlQNfUm0RL
         f+ErKGwV8p/Uk2N14e3JyXN0FcMODLP0lQHskRoH+1m3zSz8lke5pw64B7cuIM4AkfkO
         eLvqjVbKgULudz1bzyGDVMMu63dIo+0Y4EhU3j18+51qVq4K7ePCEIlNxcSnFm6TeaI/
         JrRDHZebjgsm5nrfnTUYz894jR9s4H6kA6C2VPBSrVN2Dcgrq03hz/CtEbcOfA3KYz6h
         thm+WsOjtDaAPW8ericoIrXQrAcVMcFb+onKOTdzaMQ1cnZty37L0DX8a5jG1YjRjetb
         9JMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=U4qoS/wn5EXo1uhw7OC1SLl4kqwNutLCer+sOn07EKk=;
        b=H/prpUZORzVD3TEJvXwkNKHclTjZ+pSZH1+2xXOxNNBQ9xBJ8tiq2FoBpjUixxjj/k
         lJmlWJcj4wrpYP1qUyx/VyCFAseHtqsWJ9BMRUaFDEPCRvBdb6K4uMnypuS6YUiqKrWH
         W3VUYpe1wUk6n1jkzLbrjr3epXT71RFo7cA8E1BDudPWtpVI8mPncjM6D0rw45JgZwI+
         WBSZ5/uePPV4m55/Kk4RTzitUcbiNibFFS6oDVMRyA3R5giKo6IKICAdIq/ZM+V688YD
         kUMuxixyEd7EHoRj7BbUsik9vgzvPC7VPcv7EUMhc2cFoAJM1FKPDOS9Pa+xBFKhGZbI
         3nPA==
X-Gm-Message-State: ACrzQf1BFeN6ZIcmpQdS6lhGrDoyIonjj8ykStytE2nj5XGxCh9uBPAp
        DPMd0LKugkEcfjWTt2r7u7wcQaq5RqaV4sxZwdo=
X-Google-Smtp-Source: AMsMyM5w3GxJp4aVfvUo4fdhScUPyHJ8FK6KuSnFOCMJ8+ULvbkFZCxnTjDbBl401K8Io+B2+8z0JQ==
X-Received: by 2002:a17:902:e80b:b0:176:de36:f5a8 with SMTP id u11-20020a170902e80b00b00176de36f5a8mr1161249plg.127.1663702942277;
        Tue, 20 Sep 2022 12:42:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d5-20020a170902cec500b00176a715653dsm276642plg.145.2022.09.20.12.42.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 12:42:21 -0700 (PDT)
Message-ID: <632a179d.170a0220.137a0.0c7b@mx.google.com>
Date:   Tue, 20 Sep 2022 12:42:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.69-17-g7d846e6eef7f
Subject: stable-rc/queue/5.15 baseline: 170 runs,
 43 regressions (v5.15.69-17-g7d846e6eef7f)
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

stable-rc/queue/5.15 baseline: 170 runs, 43 regressions (v5.15.69-17-g7d846=
e6eef7f)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
at91sam9g20ek                | arm   | lab-broonie   | gcc-10   | at91_dt_d=
efconfig   | 1          =

bcm2711-rpi-4-b              | arm64 | lab-collabora | gcc-10   | defconfig=
           | 1          =

cubietruck                   | arm   | lab-baylibre  | gcc-10   | sunxi_def=
config     | 1          =

fsl-ls1028a-rdb              | arm64 | lab-nxp       | gcc-10   | defconfig=
           | 1          =

imx6q-sabrelite              | arm   | lab-collabora | gcc-10   | multi_v7_=
defconfig  | 1          =

imx6sx-sdb                   | arm   | lab-nxp       | gcc-10   | multi_v7_=
defconfig  | 1          =

imx6ul-14x14-evk             | arm   | lab-nxp       | gcc-10   | multi_v7_=
defconfig  | 1          =

imx7d-sdb                    | arm   | lab-nxp       | gcc-10   | multi_v7_=
defconfig  | 1          =

imx7ulp-evk                  | arm   | lab-nxp       | gcc-10   | multi_v7_=
defconfig  | 1          =

imx8mn-ddr4-evk              | arm64 | lab-baylibre  | gcc-10   | defconfig=
           | 1          =

imx8mn-ddr4-evk              | arm64 | lab-nxp       | gcc-10   | defconfig=
           | 1          =

jetson-tk1                   | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig  | 1          =

kontron-bl-imx8mm            | arm64 | lab-kontron   | gcc-10   | defconfig=
           | 1          =

kontron-pitx-imx8m           | arm64 | lab-kontron   | gcc-10   | defconfig=
           | 1          =

meson-g12a-sei510            | arm64 | lab-baylibre  | gcc-10   | defconfig=
           | 1          =

meson-g12a-u200              | arm64 | lab-baylibre  | gcc-10   | defconfig=
           | 1          =

meson-g12a-x96-max           | arm64 | lab-baylibre  | gcc-10   | defconfig=
           | 1          =

meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre  | gcc-10   | defconfig=
           | 1          =

meson-g12b-a311d-khadas-vim3 | arm64 | lab-collabora | gcc-10   | defconfig=
           | 1          =

meson-g12b-odroid-n2         | arm64 | lab-baylibre  | gcc-10   | defconfig=
           | 1          =

meson-gxl-s805x-libretech-ac | arm64 | lab-baylibre  | gcc-10   | defconfig=
           | 1          =

meson-gxl-s905x-khadas-vim   | arm64 | lab-baylibre  | gcc-10   | defconfig=
           | 1          =

meson-gxl-s905x-libretech-cc | arm64 | lab-baylibre  | gcc-10   | defconfig=
           | 1          =

meson-gxl-s905x-libretech-cc | arm64 | lab-broonie   | gcc-10   | defconfig=
           | 1          =

meson-gxl-s905x-libretech-cc | arm64 | lab-clabbe    | gcc-10   | defconfig=
           | 1          =

meson-gxm-khadas-vim2        | arm64 | lab-baylibre  | gcc-10   | defconfig=
           | 1          =

meson-sm1-khadas-vim3l       | arm64 | lab-baylibre  | gcc-10   | defconfig=
           | 1          =

meson-sm1-sei610             | arm64 | lab-baylibre  | gcc-10   | defconfig=
           | 1          =

odroid-xu3                   | arm   | lab-collabora | gcc-10   | exynos_de=
fconfig    | 1          =

odroid-xu3                   | arm   | lab-collabora | gcc-10   | multi_v7_=
defconfig  | 1          =

panda                        | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig  | 1          =

panda                        | arm   | lab-baylibre  | gcc-10   | omap2plus=
_defconfig | 1          =

rk3288-rock2-square          | arm   | lab-collabora | gcc-10   | multi_v7_=
defconfig  | 1          =

sun4i-a10-olinuxino-lime     | arm   | lab-baylibre  | gcc-10   | sunxi_def=
config     | 1          =

sun5i-a13-olinuxino-micro    | arm   | lab-baylibre  | gcc-10   | sunxi_def=
config     | 1          =

sun7i-a20-cubieboard2        | arm   | lab-baylibre  | gcc-10   | sunxi_def=
config     | 1          =

sun7i-a20-cubieboard2        | arm   | lab-clabbe    | gcc-10   | sunxi_def=
config     | 1          =

sun7i-a20-olinuxino-lime2    | arm   | lab-baylibre  | gcc-10   | sunxi_def=
config     | 1          =

sun8i-a33-olinuxino          | arm   | lab-clabbe    | gcc-10   | sunxi_def=
config     | 1          =

sun8i-h2-plus-orangepi-r1    | arm   | lab-baylibre  | gcc-10   | sunxi_def=
config     | 1          =

sun8i-h2-plus-orangepi-zero  | arm   | lab-baylibre  | gcc-10   | sunxi_def=
config     | 1          =

sun8i-h3-bananapi-m2-plus    | arm   | lab-baylibre  | gcc-10   | sunxi_def=
config     | 1          =

sun8i-h3-orangepi-pc         | arm   | lab-clabbe    | gcc-10   | sunxi_def=
config     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.69-17-g7d846e6eef7f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.69-17-g7d846e6eef7f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7d846e6eef7ff4a64bceed00b39239e6ad100d86 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
at91sam9g20ek                | arm   | lab-broonie   | gcc-10   | at91_dt_d=
efconfig   | 1          =


  Details:     https://kernelci.org/test/plan/id/6329e284e9e9fb3947355675

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9=
g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9=
g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329e284e9e9fb3947355=
676
        new failure (last pass: v5.15.68-34-gb4f486b4ff9c) =

 =



platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
bcm2711-rpi-4-b              | arm64 | lab-collabora | gcc-10   | defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/6329e7186e340cf0293556b2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm64/defconfig/gcc-10/lab-collabora/baseline-bcm2711-rpi-=
4-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm64/defconfig/gcc-10/lab-collabora/baseline-bcm2711-rpi-=
4-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329e7186e340cf029355=
6b3
        new failure (last pass: v5.15.68-34-gb4f486b4ff9c) =

 =



platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
cubietruck                   | arm   | lab-baylibre  | gcc-10   | sunxi_def=
config     | 1          =


  Details:     https://kernelci.org/test/plan/id/6329e8f20cc0e55cfb355655

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubietruc=
k.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubietruc=
k.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329e8f20cc0e55cfb355=
656
        new failure (last pass: v5.15.68-34-gb4f486b4ff9c) =

 =



platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
fsl-ls1028a-rdb              | arm64 | lab-nxp       | gcc-10   | defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/6329e76af103aa1cc0355689

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls1028a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls1028a-rdb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329e76af103aa1cc0355=
68a
        new failure (last pass: v5.15.68-34-gb4f486b4ff9c) =

 =



platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
imx6q-sabrelite              | arm   | lab-collabora | gcc-10   | multi_v7_=
defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6329e4ab23d4e24ce635565f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-imx6q=
-sabrelite.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-imx6q=
-sabrelite.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329e4ab23d4e24ce6355=
660
        new failure (last pass: v5.15.68-34-gb4f486b4ff9c) =

 =



platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
imx6sx-sdb                   | arm   | lab-nxp       | gcc-10   | multi_v7_=
defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6329e4d2b23c717c9e35567f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx-sdb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx-sdb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329e4d2b23c717c9e355=
680
        new failure (last pass: v5.15.68-34-gb4f486b4ff9c) =

 =



platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
imx6ul-14x14-evk             | arm   | lab-nxp       | gcc-10   | multi_v7_=
defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6329e4e50ad48e303f35564d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-14x1=
4-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-14x1=
4-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329e4e50ad48e303f355=
64e
        new failure (last pass: v5.15.68-34-gb4f486b4ff9c) =

 =



platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
imx7d-sdb                    | arm   | lab-nxp       | gcc-10   | multi_v7_=
defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6329e4d431fae16b0435567a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329e4d431fae16b04355=
67b
        new failure (last pass: v5.15.68-34-gb4f486b4ff9c) =

 =



platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
imx7ulp-evk                  | arm   | lab-nxp       | gcc-10   | multi_v7_=
defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6329e534b07068331c355643

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329e534b07068331c355=
644
        new failure (last pass: v5.15.68-34-gb4f486b4ff9c) =

 =



platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
imx8mn-ddr4-evk              | arm64 | lab-baylibre  | gcc-10   | defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/6329e86b10fc6e3fda35568f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4-e=
vk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4-e=
vk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329e86b10fc6e3fda355=
690
        new failure (last pass: v5.15.68-34-gb4f486b4ff9c) =

 =



platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
imx8mn-ddr4-evk              | arm64 | lab-nxp       | gcc-10   | defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/6329e74120088671f735568c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-evk.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329e74120088671f7355=
68d
        new failure (last pass: v5.15.68-34-gb4f486b4ff9c) =

 =



platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
jetson-tk1                   | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6329e6ec210bf551dc355674

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329e6ec210bf551dc355=
675
        new failure (last pass: v5.15.68-34-gb4f486b4ff9c) =

 =



platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
kontron-bl-imx8mm            | arm64 | lab-kontron   | gcc-10   | defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/6329e9351b81d4294c355655

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-bl-imx=
8mm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-bl-imx=
8mm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329e9351b81d4294c355=
656
        new failure (last pass: v5.15.68-34-gb4f486b4ff9c) =

 =



platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
kontron-pitx-imx8m           | arm64 | lab-kontron   | gcc-10   | defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/6329e937f3354df74835565a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-i=
mx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-i=
mx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329e937f3354df748355=
65b
        new failure (last pass: v5.15.68-34-gb4f486b4ff9c) =

 =



platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
meson-g12a-sei510            | arm64 | lab-baylibre  | gcc-10   | defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/6329e6ef6133aa6ee935565f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-se=
i510.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-se=
i510.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329e6ef6133aa6ee9355=
660
        new failure (last pass: v5.15.68-34-gb4f486b4ff9c) =

 =



platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
meson-g12a-u200              | arm64 | lab-baylibre  | gcc-10   | defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/6329e71677473a7834355648

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-u2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-u2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329e71677473a7834355=
649
        new failure (last pass: v5.15.68-34-gb4f486b4ff9c) =

 =



platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
meson-g12a-x96-max           | arm64 | lab-baylibre  | gcc-10   | defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/6329e71a6e340cf0293556b5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-x9=
6-max.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-x9=
6-max.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329e71a6e340cf029355=
6b6
        new failure (last pass: v5.15.68-34-gb4f486b4ff9c) =

 =



platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre  | gcc-10   | defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/6329eb1b1fb6863c64355643

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-a3=
11d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-a3=
11d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329eb1b1fb6863c64355=
644
        new failure (last pass: v5.15.68-34-gb4f486b4ff9c) =

 =



platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-collabora | gcc-10   | defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/6329effbfa45c01821355666

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12b-a=
311d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12b-a=
311d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329effbfa45c01821355=
667
        new failure (last pass: v5.15.68-34-gb4f486b4ff9c) =

 =



platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
meson-g12b-odroid-n2         | arm64 | lab-baylibre  | gcc-10   | defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/6329e9b4c11a95829135564c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-od=
roid-n2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-od=
roid-n2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329e9b4c11a958291355=
64d
        new failure (last pass: v5.15.68-34-gb4f486b4ff9c) =

 =



platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
meson-gxl-s805x-libretech-ac | arm64 | lab-baylibre  | gcc-10   | defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/6329e6feefd432911d35565c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s80=
5x-libretech-ac.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s80=
5x-libretech-ac.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329e6feefd432911d355=
65d
        new failure (last pass: v5.15.57-272-g5a71ddb7f7107) =

 =



platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
meson-gxl-s905x-khadas-vim   | arm64 | lab-baylibre  | gcc-10   | defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/6329e700b15c270d8d355660

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s90=
5x-khadas-vim.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s90=
5x-khadas-vim.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329e700b15c270d8d355=
661
        new failure (last pass: v5.15.68-34-gb4f486b4ff9c) =

 =



platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-baylibre  | gcc-10   | defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/6329ef5d37745c7e2d3556b8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s90=
5x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s90=
5x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329ef5d37745c7e2d355=
6b9
        new failure (last pass: v5.15.68-34-gb4f486b4ff9c) =

 =



platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie   | gcc-10   | defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/6329e7244efae13404355671

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s905=
x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s905=
x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329e7244efae13404355=
672
        new failure (last pass: v5.15.68-34-gb4f486b4ff9c) =

 =



platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-clabbe    | gcc-10   | defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/6329e8170b17cba2e5355685

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm64/defconfig/gcc-10/lab-clabbe/baseline-meson-gxl-s905x=
-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm64/defconfig/gcc-10/lab-clabbe/baseline-meson-gxl-s905x=
-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329e8170b17cba2e5355=
686
        new failure (last pass: v5.15.68-34-gb4f486b4ff9c) =

 =



platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
meson-gxm-khadas-vim2        | arm64 | lab-baylibre  | gcc-10   | defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/6329e6fd4452370b21355664

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-kha=
das-vim2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-kha=
das-vim2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329e6fd4452370b21355=
665
        new failure (last pass: v5.15.68-34-gb4f486b4ff9c) =

 =



platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
meson-sm1-khadas-vim3l       | arm64 | lab-baylibre  | gcc-10   | defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/6329e7625c34035de8355643

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-kha=
das-vim3l.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-kha=
das-vim3l.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329e7625c34035de8355=
644
        new failure (last pass: v5.15.68-34-gb4f486b4ff9c) =

 =



platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
meson-sm1-sei610             | arm64 | lab-baylibre  | gcc-10   | defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/6329e6ed210bf551dc355677

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-sei=
610.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-sei=
610.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329e6ed210bf551dc355=
678
        new failure (last pass: v5.15.68-34-gb4f486b4ff9c) =

 =



platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
odroid-xu3                   | arm   | lab-collabora | gcc-10   | exynos_de=
fconfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/6329fb858f5eb52c2235565c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid-=
xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid-=
xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329fb858f5eb52c22355=
65d
        new failure (last pass: v5.15.68-34-gb4f486b4ff9c) =

 =



platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
odroid-xu3                   | arm   | lab-collabora | gcc-10   | multi_v7_=
defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6329fe4149df9ffbe835566b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odroi=
d-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odroi=
d-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329fe4149df9ffbe8355=
66c
        new failure (last pass: v5.15.68-34-gb4f486b4ff9c) =

 =



platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
panda                        | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6329e54db07068331c355750

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329e54db07068331c355=
751
        failing since 35 days (last pass: v5.15.60-48-g789367af88749, first=
 fail: v5.15.60-779-ge1dae9850fdff) =

 =



platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
panda                        | arm   | lab-baylibre  | gcc-10   | omap2plus=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6329eb3ccbff6fff76355650

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329eb3ccbff6fff76355=
651
        failing since 28 days (last pass: v5.15.61-1-geccb923b9eab2, first =
fail: v5.15.62-232-g7f3b8845612d) =

 =



platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
rk3288-rock2-square          | arm   | lab-collabora | gcc-10   | multi_v7_=
defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6329e6283444cec205355650

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk328=
8-rock2-square.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk328=
8-rock2-square.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329e6283444cec205355=
651
        new failure (last pass: v5.15.68-34-gb4f486b4ff9c) =

 =



platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
sun4i-a10-olinuxino-lime     | arm   | lab-baylibre  | gcc-10   | sunxi_def=
config     | 1          =


  Details:     https://kernelci.org/test/plan/id/632a02101f3aa48bfd355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun4i-a10=
-olinuxino-lime.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun4i-a10=
-olinuxino-lime.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632a02101f3aa48bfd355=
643
        new failure (last pass: v5.15.63-135-g75ba94c564c1) =

 =



platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
sun5i-a13-olinuxino-micro    | arm   | lab-baylibre  | gcc-10   | sunxi_def=
config     | 1          =


  Details:     https://kernelci.org/test/plan/id/6329ee0d02e7dc475035566c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5i-a13=
-olinuxino-micro.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5i-a13=
-olinuxino-micro.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329ee0d02e7dc4750355=
66d
        new failure (last pass: v5.15.68-34-gb4f486b4ff9c) =

 =



platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
sun7i-a20-cubieboard2        | arm   | lab-baylibre  | gcc-10   | sunxi_def=
config     | 1          =


  Details:     https://kernelci.org/test/plan/id/6329e41ded6892a95e355651

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-a20=
-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-a20=
-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329e41ded6892a95e355=
652
        new failure (last pass: v5.15.68-34-gb4f486b4ff9c) =

 =



platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
sun7i-a20-cubieboard2        | arm   | lab-clabbe    | gcc-10   | sunxi_def=
config     | 1          =


  Details:     https://kernelci.org/test/plan/id/6329e41ba7663fe5f935566b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-a20-c=
ubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-a20-c=
ubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329e41ba7663fe5f9355=
66c
        new failure (last pass: v5.15.68-34-gb4f486b4ff9c) =

 =



platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
sun7i-a20-olinuxino-lime2    | arm   | lab-baylibre  | gcc-10   | sunxi_def=
config     | 1          =


  Details:     https://kernelci.org/test/plan/id/632a16639449996f9f355646

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-a20=
-olinuxino-lime2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-a20=
-olinuxino-lime2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632a16639449996f9f355=
647
        new failure (last pass: v5.15.68-34-gb4f486b4ff9c) =

 =



platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
sun8i-a33-olinuxino          | arm   | lab-clabbe    | gcc-10   | sunxi_def=
config     | 1          =


  Details:     https://kernelci.org/test/plan/id/6329e50b8e2911ebab3556a8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33-o=
linuxino.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33-o=
linuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329e50b8e2911ebab355=
6a9
        new failure (last pass: v5.15.68-34-gb4f486b4ff9c) =

 =



platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
sun8i-h2-plus-orangepi-r1    | arm   | lab-baylibre  | gcc-10   | sunxi_def=
config     | 1          =


  Details:     https://kernelci.org/test/plan/id/6329e9e79202785c2e355645

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h2-=
plus-orangepi-r1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h2-=
plus-orangepi-r1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329e9e79202785c2e355=
646
        new failure (last pass: v5.15.63-136-g13e06cfc9a76) =

 =



platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
sun8i-h2-plus-orangepi-zero  | arm   | lab-baylibre  | gcc-10   | sunxi_def=
config     | 1          =


  Details:     https://kernelci.org/test/plan/id/632a011fa67a137f633556b7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h2-=
plus-orangepi-zero.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h2-=
plus-orangepi-zero.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632a011fa67a137f63355=
6b8
        new failure (last pass: v5.15.68-34-gb4f486b4ff9c) =

 =



platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
sun8i-h3-bananapi-m2-plus    | arm   | lab-baylibre  | gcc-10   | sunxi_def=
config     | 1          =


  Details:     https://kernelci.org/test/plan/id/6329e4172eaf584fa3355661

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3-=
bananapi-m2-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3-=
bananapi-m2-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329e4172eaf584fa3355=
662
        new failure (last pass: v5.15.58-69-g101d0d76bf0e) =

 =



platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
sun8i-h3-orangepi-pc         | arm   | lab-clabbe    | gcc-10   | sunxi_def=
config     | 1          =


  Details:     https://kernelci.org/test/plan/id/6329ea47ec27444af235565d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-or=
angepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
17-g7d846e6eef7f/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-or=
angepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329ea47ec27444af2355=
65e
        new failure (last pass: v5.15.68-34-gb4f486b4ff9c) =

 =20
