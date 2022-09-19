Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87A5B5BC1EA
	for <lists+stable@lfdr.de>; Mon, 19 Sep 2022 06:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbiISEDw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Sep 2022 00:03:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiISEDu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Sep 2022 00:03:50 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C128183A9
        for <stable@vger.kernel.org>; Sun, 18 Sep 2022 21:03:49 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id go6so22346325pjb.2
        for <stable@vger.kernel.org>; Sun, 18 Sep 2022 21:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=16c9qO1by7IXR+ehN3KBCcw4Pf9NaT1qS3AenwO26HM=;
        b=0XLgYUSWkPESxxWxKFOxJuoQphp3WiGHIMu9K8kdYpro1J3nGgoSLvMmZSBjcQpt66
         4Bu5gEIxl7tA6W8zBnFzwUv1jdn7lmA/KgkFSOtY9vMFpRE8PBm2aNTi3ODz3a8AkYZY
         TC+A2DXQrStR1BsiUeoCOg0mhKwcG+CpZcpO/s0EhDAS9gZOPknBFQ9vnPQu0jAMJbDy
         iEi+VBL8ETC2jJuJgeclywOBxy5L2yHFhV2SosD1VGxoBEd3ztKlKFlMJRXjR6GbIgjy
         C6rzSBAVfIQ/oDbhRx0EblUTEkPyd0WJdbnhGe7077gzB2EHtic/axcFSkJYULFch+DI
         NdLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=16c9qO1by7IXR+ehN3KBCcw4Pf9NaT1qS3AenwO26HM=;
        b=YJeHhbe1ikmRCFMJaQDJI3nkqJgscJwDIINgwmVByEUJrfCi43WnYA/+dIYFQb5jqp
         pZ8geUwZ8VVyLmjsB5ARhlrlPjRjgtB6ysHD8Vn51seXCSO43QqJHh8xTtwKanJUNXIn
         rqLFSR9CH9RmACWT9/ZI/g8xBMxJ7WtYdUPhM5P4drB6IN+4PcgljVe9pwHc03yQYxe1
         htLWKE4RBxc9PhA1RPjK0IdaaZa4SaBsro8wNZ2aAkUPd924AZPGARIL8/W8u9xAcl4I
         JOQweits3JzXVRTyp7Av+2a4aRE1FiweiKUZTb6BhQvAPDKxfkCqsGaJFk5PIcKLbGxj
         PhOQ==
X-Gm-Message-State: ACrzQf1/AFywvlTEg+2xS2lXpfZiFhT89wOlAiuqXB+pts9Na7gmI2Ih
        e+wZTxvh9iBj3Cr8DuuoTA0vI/TSRcSANN+R53g=
X-Google-Smtp-Source: AMsMyM7j6eSsPUNe/HlslfH1ALM0LMI5u0Hgd4WkY3IYRtLkyvq9Z9kqdL14nIKZxh62g8rI1ceb1Q==
X-Received: by 2002:a17:902:f547:b0:178:39fe:5b14 with SMTP id h7-20020a170902f54700b0017839fe5b14mr11174889plf.100.1663560228417;
        Sun, 18 Sep 2022 21:03:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w187-20020a6282c4000000b0053e156e9475sm18819664pfd.182.2022.09.18.21.03.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Sep 2022 21:03:48 -0700 (PDT)
Message-ID: <6327ea24.620a0220.1d39a.199d@mx.google.com>
Date:   Sun, 18 Sep 2022 21:03:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.18
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.19-1-g1e27be8389f7
Subject: stable-rc/queue/5.18 baseline: 193 runs,
 7 regressions (v5.18.19-1-g1e27be8389f7)
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

stable-rc/queue/5.18 baseline: 193 runs, 7 regressions (v5.18.19-1-g1e27be8=
389f7)

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

hifive-unleashed-a00         | riscv | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

imx6ul-pico-hobbit           | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 1          =

odroid-xu3                   | arm   | lab-collabora   | gcc-10   | exynos_=
defconfig           | 1          =

rk3288-veyron-jaq            | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =

sc7180-trogdo...zor-limozeen | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.19-1-g1e27be8389f7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.19-1-g1e27be8389f7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1e27be8389f74261455e5641ecafc09afa07ce82 =



Test Regressions
---------------- =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
bcm2835-rpi-b-rev2           | arm   | lab-broonie     | gcc-10   | bcm2835=
_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/6327b9a3cd58e85930355655

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g1e27be8389f7/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g1e27be8389f7/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327b9a3cd58e85930355=
656
        failing since 33 days (last pass: v5.18.16-7-g7fc5e6c7e4db1, first =
fail: v5.18.17-1094-g906dae830019d) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
bcm2836-rpi-2-b              | arm   | lab-collabora   | gcc-10   | bcm2835=
_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/6327bba833b135b054355664

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g1e27be8389f7/arm/bcm2835_defconfig/gcc-10/lab-collabora/baseline-bcm2836=
-rpi-2-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g1e27be8389f7/arm/bcm2835_defconfig/gcc-10/lab-collabora/baseline-bcm2836=
-rpi-2-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327bba833b135b054355=
665
        failing since 34 days (last pass: v5.18.17-134-g620d3eac5bbd1, firs=
t fail: v5.18.17-1078-g5c55e4c4afa02) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
hifive-unleashed-a00         | riscv | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/6327baa41e296c6523355659

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g1e27be8389f7/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleash=
ed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g1e27be8389f7/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleash=
ed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327baa41e296c6523355=
65a
        failing since 6 days (last pass: v5.18.19-1-g935d5e1a94dd, first fa=
il: v5.18.19-1-g05c6ce2df587) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6ul-pico-hobbit           | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/6327ba791cdc84c194355671

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g1e27be8389f7/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6=
ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g1e27be8389f7/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6=
ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327ba791cdc84c194355=
672
        failing since 75 days (last pass: v5.18.9-96-g91cfa3d0b94d, first f=
ail: v5.18.9-102-ga6b8287ea0b9) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
odroid-xu3                   | arm   | lab-collabora   | gcc-10   | exynos_=
defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6327bc34fda2c80aa6355768

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g1e27be8389f7/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid-x=
u3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g1e27be8389f7/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid-x=
u3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327bc34fda2c80aa6355=
769
        failing since 36 days (last pass: v5.18.17-41-g6a725335d402d, first=
 fail: v5.18.17-134-g620d3eac5bbd1) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
rk3288-veyron-jaq            | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/6327c110a1dd2a7854355752

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g1e27be8389f7/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g1e27be8389f7/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327c110a1dd2a7854355=
753
        failing since 34 days (last pass: v5.18.17-134-g620d3eac5bbd1, firs=
t fail: v5.18.17-1078-g5c55e4c4afa02) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sc7180-trogdo...zor-limozeen | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6327b7d8de2edea00e355656

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g1e27be8389f7/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-sc7180-trogdor-lazor-limozeen.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g1e27be8389f7/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-sc7180-trogdor-lazor-limozeen.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327b7d8de2edea00e355=
657
        new failure (last pass: v5.18.19-1-g3cc7eb2847e1) =

 =20
