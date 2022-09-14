Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69C5A5B8B1E
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 16:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiINO4T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 10:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbiINO4P (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 10:56:15 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C873673301
        for <stable@vger.kernel.org>; Wed, 14 Sep 2022 07:56:13 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id o70-20020a17090a0a4c00b00202f898fa86so5256235pjo.2
        for <stable@vger.kernel.org>; Wed, 14 Sep 2022 07:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=4GResB3q1ATZBrdms/UKfm4OK2hTGWCWRnSOYBr94Gk=;
        b=oZFNj46A/aJK+07eeUMe5DEg7AkLbpJpWCz2o0X90kfbRChf9cXt+C0v8/AcnU/cYa
         bF1/yrHMxerAGOCTErno5HIegJhDlkT2m4aH2FYF0Xsp0V+i72njf5Nu/lb3yk20/QtL
         Sq/RMKMsnOhGkVPpIJkEtYGVl4VxWohc6ptiSExsC907lgeOYEJGsE71SXZ1igPfZJhG
         hRq4n0Urp2YE5nueyc7Svmsnx63PQdkgfIrsXzPXEpILg0oBcAtnM0L8vaHDHDeAsVjE
         Tf4SZysBKgQneafK8oZB2cxWz48uz4tSpTBotyx/nCXU0JQ9sdnBmnu9yJX5NJTaN1Hd
         mbBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=4GResB3q1ATZBrdms/UKfm4OK2hTGWCWRnSOYBr94Gk=;
        b=J/A+FQJsIOUFlS+16w1g8pVgFboX+Z82lLS+IP5E3e6C4bqBbUCqbCSkgsArhH8aNn
         o8dnCLCbIj0gELm5kNQ3ZpRbGN3Me6C2sQeecqLusl22DSujx4KoYpnoF7YO7Zz7MQ71
         k5D4swbV+z/Xa/vW+0iCGD+/F8z2nmXQ9m1R17gBK/pHSn38Zds+nv0kcSPlVIXf4l0h
         oP6qhdmpZnRE0oC4KMbgOBLuTC90N9F+xe9aK59//3SgFa49yE2s6a6Eet3EHvT7HeNw
         RGkWIuLrH9sjE0hv5rmVOkrPcd/UDoNJ5kYhoNhnvMiDu8SarM1QH0NJgT5UwrS1rvlf
         4C+A==
X-Gm-Message-State: ACgBeo2X7WJ+Bv3NZidS5t2xMgtx00BffGnaX2g/liQx4UHzyILVxtnD
        CXgNnRfQZpvEfw7kfsWgmGpWW8kCZajmU4EUdWs=
X-Google-Smtp-Source: AA6agR5kydY4pjxQz+/AL3BxwaFlQXoqHAaiUXHrGLEly+D1PPy7q05IXaVWCkSaDuDwMr1NfNgRcw==
X-Received: by 2002:a17:902:d890:b0:16c:abb4:94d0 with SMTP id b16-20020a170902d89000b0016cabb494d0mr37331584plz.50.1663167372774;
        Wed, 14 Sep 2022 07:56:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n185-20020a6227c2000000b00546d8c2185dsm3157565pfn.170.2022.09.14.07.56.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Sep 2022 07:56:11 -0700 (PDT)
Message-ID: <6321eb8b.620a0220.4134a.67fa@mx.google.com>
Date:   Wed, 14 Sep 2022 07:56:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.18
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.19-1-g429feaa18205
Subject: stable-rc/queue/5.18 baseline: 204 runs,
 9 regressions (v5.18.19-1-g429feaa18205)
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

stable-rc/queue/5.18 baseline: 204 runs, 9 regressions (v5.18.19-1-g429feaa=
18205)

Regressions Summary
-------------------

platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
bcm2835-rpi-b-rev2           | arm   | lab-broonie     | gcc-10   | bcm2835=
_defconfig          | 1          =

bcm2836-rpi-2-b              | arm   | lab-collabora   | gcc-10   | bcm2835=
_defconfig          | 1          =

beagle-xm                    | arm   | lab-baylibre    | gcc-10   | omap2pl=
us_defconfig        | 1          =

hifive-unleashed-a00         | riscv | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

imx6ul-pico-hobbit           | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 1          =

mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

odroid-xu3                   | arm   | lab-collabora   | gcc-10   | exynos_=
defconfig           | 1          =

rk3288-veyron-jaq            | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =

sc7180-trogdo...zor-limozeen | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.19-1-g429feaa18205/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.19-1-g429feaa18205
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      429feaa18205917f1d0b4e360f6b01b33011bd38 =



Test Regressions
---------------- =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
bcm2835-rpi-b-rev2           | arm   | lab-broonie     | gcc-10   | bcm2835=
_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/6321b82872c678fee8355647

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g429feaa18205/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g429feaa18205/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6321b82872c678fee8355=
648
        failing since 28 days (last pass: v5.18.16-7-g7fc5e6c7e4db1, first =
fail: v5.18.17-1094-g906dae830019d) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
bcm2836-rpi-2-b              | arm   | lab-collabora   | gcc-10   | bcm2835=
_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/6321b93afe02ed8565355652

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g429feaa18205/arm/bcm2835_defconfig/gcc-10/lab-collabora/baseline-bcm2836=
-rpi-2-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g429feaa18205/arm/bcm2835_defconfig/gcc-10/lab-collabora/baseline-bcm2836=
-rpi-2-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6321b93afe02ed8565355=
653
        failing since 29 days (last pass: v5.18.17-134-g620d3eac5bbd1, firs=
t fail: v5.18.17-1078-g5c55e4c4afa02) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
beagle-xm                    | arm   | lab-baylibre    | gcc-10   | omap2pl=
us_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/6321b9f690a3d5b8db35566d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g429feaa18205/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g429feaa18205/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6321b9f690a3d5b8db355=
66e
        failing since 8 days (last pass: v5.18.18-6-gad8a0ac8e472, first fa=
il: v5.18.19-1-g1330c8c8f8f63) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
hifive-unleashed-a00         | riscv | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/6321b9c14f9a468035355685

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g429feaa18205/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleash=
ed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g429feaa18205/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleash=
ed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6321b9c14f9a468035355=
686
        failing since 1 day (last pass: v5.18.19-1-g935d5e1a94dd, first fai=
l: v5.18.19-1-g05c6ce2df587) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6ul-pico-hobbit           | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/6321bbe9a9dd4b7b7135564d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g429feaa18205/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6=
ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g429feaa18205/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6=
ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6321bbe9a9dd4b7b71355=
64e
        failing since 70 days (last pass: v5.18.9-96-g91cfa3d0b94d, first f=
ail: v5.18.9-102-ga6b8287ea0b9) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6321b7ebec43cdb287355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g429feaa18205/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-mt8183-kukui-jacuzzi-juniper-sku16.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g429feaa18205/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-mt8183-kukui-jacuzzi-juniper-sku16.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6321b7ebec43cdb287355=
643
        new failure (last pass: v5.18.19-1-g0e020e474faec) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
odroid-xu3                   | arm   | lab-collabora   | gcc-10   | exynos_=
defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6321bc33186d4fa427355666

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g429feaa18205/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid-x=
u3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g429feaa18205/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid-x=
u3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6321bc33186d4fa427355=
667
        failing since 31 days (last pass: v5.18.17-41-g6a725335d402d, first=
 fail: v5.18.17-134-g620d3eac5bbd1) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
rk3288-veyron-jaq            | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/6321bf2e3be56c2130355648

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g429feaa18205/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g429feaa18205/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6321bf2e3be56c2130355=
649
        failing since 29 days (last pass: v5.18.17-134-g620d3eac5bbd1, firs=
t fail: v5.18.17-1078-g5c55e4c4afa02) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sc7180-trogdo...zor-limozeen | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6321b786190a32902f355673

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g429feaa18205/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-sc7180-trogdor-lazor-limozeen.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g429feaa18205/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-sc7180-trogdor-lazor-limozeen.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6321b786190a32902f355=
674
        new failure (last pass: v5.18.19-1-g0e020e474faec) =

 =20
