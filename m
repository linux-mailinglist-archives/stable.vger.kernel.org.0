Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDE93595371
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 09:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbiHPHJB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 03:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231735AbiHPHIo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 03:08:44 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE132D4C20
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 20:32:39 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d16so8053237pll.11
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 20:32:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=EyMKFDSwsGU2RuYOFdoyofuJ9St8hg4eIdmJwZjulgM=;
        b=BPu3AJ9nGpSHzEONpu6lCzJ8w/qnB+v8eeFV1zFKvMecB26qUX7PmHoJTxjFrt8oIK
         VTTDOfnJRB7mB3IUzT4f+XYPrAemznR/QRdTdWsb1NSZuo7Vj/kvH/CRKHzy1VTS6JZi
         d2GEJlcmzrjlXF2tmP1mrJEKBK5SiqEx8pLmxBfXHI8EF+uGPmS/aCxvrSdOpNNWN5Eu
         dzPSqoiK4XzwcIjEAG+5y+0FDkDl7n/ubkypIM9plzg+Gy7KtEBDslSFYidMxgAks9qN
         4HX1iGiw1V2ZZvG+ZsCZnjbrIGCjT9AZXKHKoOE1N76toqLZe8eK63/9Q9a4vWxX82vd
         J+JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=EyMKFDSwsGU2RuYOFdoyofuJ9St8hg4eIdmJwZjulgM=;
        b=ORE/C5iEfLjSNEOpOvaQYVks0PoFUHSY9eZs5JkYxSPR/0RrKHXqWIg71KU/1n9EWb
         nNYb/jBSc/dK7wcEetbUYyhHGZdX3AA/a1313UGD7RZ0vhq9r7DcxDo6J3FSNdLVhjDL
         HqcQYx4ej0epC3iO2SW8u3fLeQN3ejl5uEYIxuDF60HnhPlUGHZEXkodqj0oI0gYSEYq
         Pb0Y47lD6t05Mp/h5lGUJRZcDYfPNEJIJX/sol0uh8Px9bMFppL3MW8Xs7B5/4sDlCkJ
         wMdRq75/cW5rx35q3t9EFURSJktrAqdzbUm8pjwQhidN+M8h375rPlz1R2++OiKFh6Ma
         CgzQ==
X-Gm-Message-State: ACgBeo19kDUqP/nLDGiB2vxeXmgQeYoc37U7LVfVfmohktx2ihot+wTv
        giryveJbYGbBGs1L6j9HfIxXOBxNBlmKmUU1
X-Google-Smtp-Source: AA6agR47xYLXjYeH+6VOEmR1J1D683LysGX8uIWUzuEk4Ho9TTbXrUQc5bONCv0sqmD8e4u7xjtYSg==
X-Received: by 2002:a17:902:a586:b0:170:f3ae:bd06 with SMTP id az6-20020a170902a58600b00170f3aebd06mr19842475plb.104.1660620757789;
        Mon, 15 Aug 2022 20:32:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s1-20020a170902a50100b0016f0c2ea14csm7683369plq.275.2022.08.15.20.32.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 20:32:37 -0700 (PDT)
Message-ID: <62fb0fd5.170a0220.9d86a.d058@mx.google.com>
Date:   Mon, 15 Aug 2022 20:32:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.290-176-g1ee5c98a9d0bc
Subject: stable-rc/linux-4.14.y baseline: 80 runs,
 24 regressions (v4.14.290-176-g1ee5c98a9d0bc)
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

stable-rc/linux-4.14.y baseline: 80 runs, 24 regressions (v4.14.290-176-g1e=
e5c98a9d0bc)

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

hip07-d05                  | arm64 | lab-collabora   | gcc-10   | defconfig=
+arm64-chromebook | 1          =

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

qemu_arm64-virt-gicv2      | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora   | gcc-10   | defconfig=
+arm64-chromebook | 1          =

sun5i-a13-olinuxino-micro  | arm   | lab-baylibre    | gcc-10   | sunxi_def=
config            | 1          =

sun7i-a20-cubieboard2      | arm   | lab-baylibre    | gcc-10   | sunxi_def=
config            | 1          =

sun7i-a20-cubieboard2      | arm   | lab-clabbe      | gcc-10   | sunxi_def=
config            | 1          =

sun8i-a33-olinuxino        | arm   | lab-clabbe      | gcc-10   | sunxi_def=
config            | 1          =

sun8i-h3-orangepi-pc       | arm   | lab-clabbe      | gcc-10   | sunxi_def=
config            | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.290-176-g1ee5c98a9d0bc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.290-176-g1ee5c98a9d0bc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1ee5c98a9d0bcb84f152b51d033548c830778841 =



Test Regressions
---------------- =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
at91sam9g20ek              | arm   | lab-broonie     | gcc-10   | at91_dt_d=
efconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/62fada95347268f29e355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-176-g1ee5c98a9d0bc/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at9=
1sam9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-176-g1ee5c98a9d0bc/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at9=
1sam9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fada95347268f29e355=
643
        failing since 0 day (last pass: v4.14.290, first fail: v4.14.290-15=
4-gc3e4c291190ba) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
cubietruck                 | arm   | lab-baylibre    | gcc-10   | sunxi_def=
config            | 1          =


  Details:     https://kernelci.org/test/plan/id/62faefa539b1ab5f01355644

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-176-g1ee5c98a9d0bc/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-176-g1ee5c98a9d0bc/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62faefa539b1ab5f01355=
645
        failing since 0 day (last pass: v4.14.290-13-g428ff765bf44, first f=
ail: v4.14.290-154-gc3e4c291190ba) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
hip07-d05                  | arm64 | lab-collabora   | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62faf55427ce6d5a04355658

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-176-g1ee5c98a9d0bc/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora=
/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-176-g1ee5c98a9d0bc/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora=
/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62faf55427ce6d5a04355=
659
        new failure (last pass: v4.14.290-154-gc3e4c291190ba) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
imx6dl-riotboard           | arm   | lab-pengutronix | gcc-10   | imx_v6_v7=
_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62fae4755cfc78b51135567a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-176-g1ee5c98a9d0bc/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseli=
ne-imx6dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-176-g1ee5c98a9d0bc/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseli=
ne-imx6dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fae4755cfc78b511355=
67b
        failing since 0 day (last pass: v4.14.290-13-g428ff765bf44, first f=
ail: v4.14.290-154-gc3e4c291190ba) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
imx6dl-riotboard           | arm   | lab-pengutronix | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fae745e288302ddf35564c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-176-g1ee5c98a9d0bc/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx6dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-176-g1ee5c98a9d0bc/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx6dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fae745e288302ddf355=
64d
        failing since 0 day (last pass: v4.14.290-13-g428ff765bf44, first f=
ail: v4.14.290-154-gc3e4c291190ba) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
imx6q-sabrelite            | arm   | lab-collabora   | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fadcbcbe2e3857f9355644

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-176-g1ee5c98a9d0bc/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-=
imx6q-sabrelite.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-176-g1ee5c98a9d0bc/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-=
imx6q-sabrelite.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fadcbcbe2e3857f9355=
645
        failing since 0 day (last pass: v4.14.290-13-g428ff765bf44, first f=
ail: v4.14.290-154-gc3e4c291190ba) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
imx6qp-sabresd             | arm   | lab-nxp         | gcc-10   | imx_v6_v7=
_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62fadaf187b270ff9335565b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-176-g1ee5c98a9d0bc/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6q=
p-sabresd.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-176-g1ee5c98a9d0bc/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6q=
p-sabresd.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fadaf187b270ff93355=
65c
        failing since 0 day (last pass: v4.14.290-13-g428ff765bf44, first f=
ail: v4.14.290-154-gc3e4c291190ba) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
imx6sx-sdb                 | arm   | lab-nxp         | gcc-10   | imx_v6_v7=
_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62fadc787deedc273635567f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-176-g1ee5c98a9d0bc/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6s=
x-sdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-176-g1ee5c98a9d0bc/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6s=
x-sdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fadc787deedc2736355=
680
        failing since 0 day (last pass: v4.14.290-13-g428ff765bf44, first f=
ail: v4.14.290-154-gc3e4c291190ba) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
imx6sx-sdb                 | arm   | lab-nxp         | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62faddf385ac5b62e8355653

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-176-g1ee5c98a9d0bc/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx=
-sdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-176-g1ee5c98a9d0bc/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx=
-sdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62faddf385ac5b62e8355=
654
        failing since 0 day (last pass: v4.14.290-13-g428ff765bf44, first f=
ail: v4.14.290-154-gc3e4c291190ba) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
imx6ul-14x14-evk           | arm   | lab-nxp         | gcc-10   | imx_v6_v7=
_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62fadc8ba52ff9c5a835566b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-176-g1ee5c98a9d0bc/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6u=
l-14x14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-176-g1ee5c98a9d0bc/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6u=
l-14x14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fadc8ba52ff9c5a8355=
66c
        failing since 0 day (last pass: v4.14.290-13-g428ff765bf44, first f=
ail: v4.14.290-154-gc3e4c291190ba) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
imx6ul-14x14-evk           | arm   | lab-nxp         | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fade0670a0803675355651

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-176-g1ee5c98a9d0bc/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul=
-14x14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-176-g1ee5c98a9d0bc/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul=
-14x14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fade0670a0803675355=
652
        failing since 0 day (last pass: v4.14.290-13-g428ff765bf44, first f=
ail: v4.14.290-154-gc3e4c291190ba) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
imx6ul-pico-hobbit         | arm   | lab-pengutronix | gcc-10   | imx_v6_v7=
_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62fb023ac71d48ae9035565f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-176-g1ee5c98a9d0bc/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseli=
ne-imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-176-g1ee5c98a9d0bc/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseli=
ne-imx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fb023ac71d48ae90355=
660
        failing since 0 day (last pass: v4.14.290-13-g428ff765bf44, first f=
ail: v4.14.290-154-gc3e4c291190ba) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
imx6ul-pico-hobbit         | arm   | lab-pengutronix | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fb050afe01b31cf0355663

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-176-g1ee5c98a9d0bc/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-176-g1ee5c98a9d0bc/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fb050afe01b31cf0355=
664
        failing since 0 day (last pass: v4.14.290-13-g428ff765bf44, first f=
ail: v4.14.290-154-gc3e4c291190ba) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
imx7d-sdb                  | arm   | lab-nxp         | gcc-10   | imx_v6_v7=
_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62fadaf6b53526acd835564a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-176-g1ee5c98a9d0bc/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d=
-sdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-176-g1ee5c98a9d0bc/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d=
-sdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fadaf6b53526acd8355=
64b
        failing since 0 day (last pass: v4.14.290-13-g428ff765bf44, first f=
ail: v4.14.290-154-gc3e4c291190ba) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fadcd89ac3d4827635564e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-176-g1ee5c98a9d0bc/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-176-g1ee5c98a9d0bc/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fadcd89ac3d48276355=
64f
        failing since 98 days (last pass: v4.14.277-55-gfb8b8dfe0168, first=
 fail: v4.14.277-71-geacdf1a71409) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fadcafe650f8c81d35565e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-176-g1ee5c98a9d0bc/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-176-g1ee5c98a9d0bc/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fadcafe650f8c81d355=
65f
        failing since 98 days (last pass: v4.14.277-55-gfb8b8dfe0168, first=
 fail: v4.14.277-71-geacdf1a71409) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fadcd72cbab36c3035565d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-176-g1ee5c98a9d0bc/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-176-g1ee5c98a9d0bc/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fadcd72cbab36c30355=
65e
        failing since 98 days (last pass: v4.14.277-55-gfb8b8dfe0168, first=
 fail: v4.14.277-71-geacdf1a71409) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fadc9b52910a1717355650

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-176-g1ee5c98a9d0bc/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-176-g1ee5c98a9d0bc/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fadc9b52910a1717355=
651
        failing since 98 days (last pass: v4.14.277-55-gfb8b8dfe0168, first=
 fail: v4.14.277-71-geacdf1a71409) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora   | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fae3ac272d87820235564f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-176-g1ee5c98a9d0bc/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora=
/baseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-176-g1ee5c98a9d0bc/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora=
/baseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fae3ac272d878202355=
650
        failing since 98 days (last pass: v4.14.277-55-gfb8b8dfe0168, first=
 fail: v4.14.277-71-geacdf1a71409) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
sun5i-a13-olinuxino-micro  | arm   | lab-baylibre    | gcc-10   | sunxi_def=
config            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fadb82a63cd644d9355659

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-176-g1ee5c98a9d0bc/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5=
i-a13-olinuxino-micro.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-176-g1ee5c98a9d0bc/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5=
i-a13-olinuxino-micro.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fadb82a63cd644d9355=
65a
        failing since 0 day (last pass: v4.14.290-13-g428ff765bf44, first f=
ail: v4.14.290-154-gc3e4c291190ba) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
sun7i-a20-cubieboard2      | arm   | lab-baylibre    | gcc-10   | sunxi_def=
config            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fadb65926f8b6b7435566d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-176-g1ee5c98a9d0bc/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7=
i-a20-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-176-g1ee5c98a9d0bc/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7=
i-a20-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fadb65926f8b6b74355=
66e
        failing since 0 day (last pass: v4.14.290-13-g428ff765bf44, first f=
ail: v4.14.290-154-gc3e4c291190ba) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
sun7i-a20-cubieboard2      | arm   | lab-clabbe      | gcc-10   | sunxi_def=
config            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fadb4e926f8b6b74355643

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-176-g1ee5c98a9d0bc/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-=
a20-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-176-g1ee5c98a9d0bc/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-=
a20-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fadb4e926f8b6b74355=
644
        failing since 0 day (last pass: v4.14.290-13-g428ff765bf44, first f=
ail: v4.14.290-154-gc3e4c291190ba) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
sun8i-a33-olinuxino        | arm   | lab-clabbe      | gcc-10   | sunxi_def=
config            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fadbda4a54ae43d0355662

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-176-g1ee5c98a9d0bc/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-=
a33-olinuxino.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-176-g1ee5c98a9d0bc/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-=
a33-olinuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fadbda4a54ae43d0355=
663
        failing since 0 day (last pass: v4.14.290-13-g428ff765bf44, first f=
ail: v4.14.290-154-gc3e4c291190ba) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
sun8i-h3-orangepi-pc       | arm   | lab-clabbe      | gcc-10   | sunxi_def=
config            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fadd6a6a32a5c335355650

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-176-g1ee5c98a9d0bc/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-=
h3-orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
90-176-g1ee5c98a9d0bc/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-=
h3-orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fadd6a6a32a5c335355=
651
        failing since 0 day (last pass: v4.14.290-13-g428ff765bf44, first f=
ail: v4.14.290-154-gc3e4c291190ba) =

 =20
