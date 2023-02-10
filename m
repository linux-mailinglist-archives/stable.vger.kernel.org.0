Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBC1B6924EF
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 18:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232400AbjBJR6U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 12:58:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232163AbjBJR6U (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 12:58:20 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E280B4F852
        for <stable@vger.kernel.org>; Fri, 10 Feb 2023 09:58:16 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id o13so5963318pjg.2
        for <stable@vger.kernel.org>; Fri, 10 Feb 2023 09:58:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=AwOcTmtVb9+xDLk/vwKNlQL10NOhXVYLJuz7J92/XaQ=;
        b=pNDQHUGPZbWMrkore9nFF9ZXSC/76+LmL8967xRNIsmfOadp0VeP3LQSP3oR42uqRI
         aihy8th2y8FZAUr72oRpjF/gBwAVrdeazlFm5DUmUX49qfasZ/XxdiBVIfaS1qtfYMDk
         /lvKHy3wnstluSaujJ2aYjUZfwG15ZVsGKq/lDOCoynmSRoQsOy9eyTh9r2ihKSbouU2
         3MSJG2N2dnw3MIy0TF981WDFxSSjgAdHWhpx5Ep3B5Pf2TENE5OZEMSENQUG0nLad6BW
         Yjl+EEahceORbeODVChxpyKfubkEGpyIMHEElHd+ZUsfgSV+zG2YKJy34AC7GDGEOY2l
         2pYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AwOcTmtVb9+xDLk/vwKNlQL10NOhXVYLJuz7J92/XaQ=;
        b=wbf3st6dcALSVDa9HDBZvlUN+ScMWsX0AAJuZX7tozsMDXFB9Pqmzlm0GiriRp84RQ
         1L+zWV9s7ibUY4qtbJhW7Vi2ryIo3PX/raQK264F0zJ6TnG1iYsG6my9QXqHXOCYhiLo
         Hs2QKgm3ojIspL0utpzVSyTWvdZFWXDhx+ZwE8anYFHnSy2I2/esOLzi99Cgw+UjeSOc
         h7FUoX+NXGrBggNWEm/uAL95BLyy99tdM3NB5mp3E8qmGOr0/FN9PUPJJ3MN/f68DZF7
         NvFOvdsUGtC78MlPla9iTgTgqxvQl6uMv2RiUVLODtyUykTmj0iGAQ9M6Uk2UulyPDJI
         z1eg==
X-Gm-Message-State: AO0yUKUDvzwYIBAE6PXA7NhP5ECeZ5XBXJJTeK0XB+rbWjEF9O8MaCDG
        NS0FsfEHv2exSt16UKdUhyCGEMNDtIC0FRGzLJI=
X-Google-Smtp-Source: AK7set95DjIOVYFygXjyGkJbBFx29061nNJVbk6q6xObGxB+lHMklgDkD6uReWhkBtvDoQWhvFrIxA==
X-Received: by 2002:a17:902:e205:b0:19a:80c9:2cdb with SMTP id u5-20020a170902e20500b0019a80c92cdbmr127743plb.42.1676051895783;
        Fri, 10 Feb 2023 09:58:15 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id jb14-20020a170903258e00b001964c8164aasm3664900plb.129.2023.02.10.09.58.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 09:58:15 -0800 (PST)
Message-ID: <63e685b7.170a0220.1567a.7550@mx.google.com>
Date:   Fri, 10 Feb 2023 09:58:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.167-97-g823a8dcef4738
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 156 runs,
 29 regressions (v5.10.167-97-g823a8dcef4738)
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

stable-rc/queue/5.10 baseline: 156 runs, 29 regressions (v5.10.167-97-g823a=
8dcef4738)

Regressions Summary
-------------------

platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
cubietruck                   | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 1          =

imx6dl-riotboard             | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig        | 1          =

imx6dl-riotboard             | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 1          =

imx6q-sabrelite              | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =

imx6qp-wandboard-revd1       | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig        | 1          =

imx6qp-wandboard-revd1       | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 1          =

imx8mn-ddr4-evk              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 2          =

jetson-tk1                   | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 1          =

jetson-tk1                   | arm   | lab-baylibre    | gcc-10   | tegra_d=
efconfig            | 1          =

kontron-kbox-a-230-ls        | arm64 | lab-kontron     | gcc-10   | defconf=
ig                  | 1          =

kontron-sl28-var3-ads2       | arm64 | lab-kontron     | gcc-10   | defconf=
ig                  | 5          =

meson8b-odroidc1             | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 2          =

rk3399-gru-kevin             | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

sun50i-a64-bananapi-m64      | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =

sun50i-a64-pine64-plus       | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =

sun50i-h5-lib...ch-all-h3-cc | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

sun50i-h5-lib...ch-all-h3-cc | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =

sun50i-h6-pine-h64           | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =

sun50i-h6-pine-h64           | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =

sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 1          =

sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =

tegra124-nyan-big            | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =

tegra124-nyan-big            | arm   | lab-collabora   | gcc-10   | tegra_d=
efconfig            | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.167-97-g823a8dcef4738/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.167-97-g823a8dcef4738
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      823a8dcef47389203b13478e1a235f16f6aebb7f =



Test Regressions
---------------- =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
cubietruck                   | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63e6511d6e035eca658c8666

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-97-g823a8dcef4738/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-97-g823a8dcef4738/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e6511d6e035eca658c866f
        failing since 15 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-02-10T14:13:34.511142  + set +x<8>[   11.344172] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3321944_1.5.2.4.1>
    2023-02-10T14:13:34.511718  =

    2023-02-10T14:13:34.620893  / # #
    2023-02-10T14:13:34.724195  export SHELL=3D/bin/sh
    2023-02-10T14:13:34.725209  #
    2023-02-10T14:13:34.827540  / # export SHELL=3D/bin/sh. /lava-3321944/e=
nvironment
    2023-02-10T14:13:34.828579  =

    2023-02-10T14:13:34.930843  / # . /lava-3321944/environment/lava-332194=
4/bin/lava-test-runner /lava-3321944/1
    2023-02-10T14:13:34.932429  =

    2023-02-10T14:13:34.937403  / # /lava-3321944/bin/lava-test-runner /lav=
a-3321944/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6dl-riotboard             | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/63e651b6df0538340f8c8642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-97-g823a8dcef4738/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-97-g823a8dcef4738/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e651b6df0538340f8c8=
643
        failing since 0 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6dl-riotboard             | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63e650b153c5216f578c863b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-97-g823a8dcef4738/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-97-g823a8dcef4738/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e650b153c5216f578c8=
63c
        failing since 0 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6q-sabrelite              | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63e650ace24aecb24f8c863e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-97-g823a8dcef4738/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-imx=
6q-sabrelite.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-97-g823a8dcef4738/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-imx=
6q-sabrelite.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e650ace24aecb24f8c8=
63f
        failing since 0 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6qp-wandboard-revd1       | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/63e651b5d23313d3988c863a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-97-g823a8dcef4738/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6qp-wandboard-revd1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-97-g823a8dcef4738/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6qp-wandboard-revd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e651b5d23313d3988c8=
63b
        failing since 0 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6qp-wandboard-revd1       | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63e65076403a0c206e8c863e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-97-g823a8dcef4738/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6qp-wandboard-revd1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-97-g823a8dcef4738/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6qp-wandboard-revd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e65076403a0c206e8c8=
63f
        failing since 0 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx8mn-ddr4-evk              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 2          =


  Details:     https://kernelci.org/test/plan/id/63e6533beb4c4bd8358c8641

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-97-g823a8dcef4738/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4=
-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-97-g823a8dcef4738/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4=
-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63e6533beb4c4bd=
8358c8644
        failing since 0 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7)
        2 lines

    2023-02-10T14:22:12.527804  kern  :alert :   ESR =3D 0x96000004
    2023-02-10T14:22:12.528752  kern  :alert :   EC =3D 0x25: DABT (current=
 EL), IL =3D 32 bits
    2023-02-10T14:22:12.529868  kern  :alert :   SET =3D 0, FnV =3D 0
    2023-02-10T14:22:12.530928  kern  :alert :   EA =3D 0, S1PT<8>[   19.39=
2931] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dline=
s MEASUREMENT=3D2>
    2023-02-10T14:22:12.531888  W =3D 0   =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63e6533beb4c4bd=
8358c8645
        failing since 0 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7)
        11 lines

    2023-02-10T14:22:12.521403  kern  :alert : Unable to handle kernel pagi=
ng request at virtual<8>[   19.366910] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=
=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D11>
    2023-02-10T14:22:12.522498   address fffffffffffffff8
    2023-02-10T14:22:12.523405  kern  :alert : Mem abort info:   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
jetson-tk1                   | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63e651cc6b6affec638c8672

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-97-g823a8dcef4738/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-97-g823a8dcef4738/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e651cc6b6affec638c8=
673
        failing since 0 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
jetson-tk1                   | arm   | lab-baylibre    | gcc-10   | tegra_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63e6506b65be6a15298c863c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-97-g823a8dcef4738/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-97-g823a8dcef4738/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e6506b65be6a15298c8=
63d
        failing since 0 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
kontron-kbox-a-230-ls        | arm64 | lab-kontron     | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63e6533c13e4789ee88c8644

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-97-g823a8dcef4738/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-kbox=
-a-230-ls.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-97-g823a8dcef4738/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-kbox=
-a-230-ls.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e6533c13e4789ee88c8=
645
        new failure (last pass: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
kontron-sl28-var3-ads2       | arm64 | lab-kontron     | gcc-10   | defconf=
ig                  | 5          =


  Details:     https://kernelci.org/test/plan/id/63e65238cd108981ee8c862f

  Results:     92 PASS, 8 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-97-g823a8dcef4738/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-sl28=
-var3-ads2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-97-g823a8dcef4738/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-sl28=
-var3-ads2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.spi-nor-probed: https://kernelci.org/test/case/id/63e65=
238cd108981ee8c863e
        failing since 0 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7)

    2023-02-10T14:18:24.938313  /lava-271687/1/../bin/lava-test-case
    2023-02-10T14:18:24.938721  <8>[   18.550776] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dspi-nor-probed RESULT=3Dfail>   =


  * baseline.bootrr.at24-probed: https://kernelci.org/test/case/id/63e65238=
cd108981ee8c8640
        failing since 0 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7)

    2023-02-10T14:18:18.591968  /lava-271687/1/../bin/lava-test-case
    2023-02-10T14:18:18.592369  <8>[   12.174229] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dat24-probed RESULT=3Dfail>
    2023-02-10T14:18:18.592628  /lava-271687/1/../bin/lava-test-case
    2023-02-10T14:18:18.592862  <8>[   12.189906] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dwm8904-driver-present RESULT=3Dpass>   =


  * baseline.bootrr.spi-nor-probed: https://kernelci.org/test/case/id/63e65=
238cd108981ee8c863e
        failing since 0 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7)

    2023-02-10T14:18:24.938313  /lava-271687/1/../bin/lava-test-case
    2023-02-10T14:18:24.938721  <8>[   18.550776] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dspi-nor-probed RESULT=3Dfail>   =


  * baseline.bootrr.at24-eeprom0-probed: https://kernelci.org/test/case/id/=
63e65238cd108981ee8c868c
        failing since 0 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7)

    2023-02-10T14:18:25.961917  /lava-271687/1/../bin/lava-test-case
    2023-02-10T14:18:25.965759  <8>[   19.584656] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dat24-eeprom0-probed RESULT=3Dfail>   =


  * baseline.bootrr.at24-eeprom1-probed: https://kernelci.org/test/case/id/=
63e65238cd108981ee8c868d
        failing since 0 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7)

    2023-02-10T14:18:27.013533  /lava-271687/1/../bin/lava-test-case
    2023-02-10T14:18:27.013958  <8>[   20.603455] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dat24-eeprom1-probed RESULT=3Dfail>
    2023-02-10T14:18:27.014227  /lava-271687/1/../bin/lava-test-case
    2023-02-10T14:18:27.014463  <8>[   20.619392] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drtc-rv8803-driver-present RESULT=3Dpass>   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson8b-odroidc1             | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 2          =


  Details:     https://kernelci.org/test/plan/id/63e650a753c5216f578c8630

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-97-g823a8dcef4738/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meso=
n8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-97-g823a8dcef4738/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meso=
n8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63e650a753c5216=
f578c8633
        new failure (last pass: v5.10.167-97-g08e29bf32dce7)
        47 lines

    2023-02-10T14:11:37.402851  kern  :emerg : Internal error: Oops: 17 [#1=
] SMP ARM
    2023-02-10T14:11:37.439023  kern  :emerg : Process kworker/1:4 (pid: 67=
, stack limit =3D 0x(ptrval))
    2023-02-10T14:11:37.439668  kern  :emerg : Stack: (0xe208bd68 to 0xe208=
c000)
    2023-02-10T14:11:37.439945  kern  :emerg : bd60:                   e208=
bd8c ef7f42cc c0a2a660 e208a000 c21df010 c0762874
    2023-02-10T14:11:37.440167  kern  :emerg : bd80: 00000000 c0a2f74c c229=
9078 c22e1a58 e246ea34 deb8fa50 a0000013 ef7f42cc
    2023-02-10T14:11:37.440381  kern  :emerg : bda0: c0a2a660 c21df010 c21d=
f000 c0e2f548 ef7f42cc ef7f4484 c21df010 c0e2f864
    2023-02-10T14:11:37.446835  kern  :emerg : bdc0: e24651c0 bf0232d4 c21d=
f010 c0e2f90c e24651c0 bf0232d4 c21df010 c21df000
    2023-02-10T14:11:37.482083  kern  :emerg : bde0: c21df010 c0e2fa98 0000=
0000 e23e7c00 e23e7f40 bf0223c4 00000080 c21ca080
    2023-02-10T14:11:37.482672  kern  :emerg : be00: e23e7c00 c1a78968 c1a7=
8960 f08b568c 00000012 c0defdd8 ffffffff c2260140
    2023-02-10T14:11:37.482944  kern  :emerg : be20: c110ca78 e208be38 0000=
0000 00000000 00000001 00000004 e24641c0 deb8fa50 =

    ... (34 line(s) more)  =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63e650a753c5216=
f578c8634
        new failure (last pass: v5.10.167-97-g08e29bf32dce7)
        4 lines =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
rk3399-gru-kevin             | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63e6550d6f7fe9d7208c864a

  Results:     85 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-97-g823a8dcef4738/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-97-g823a8dcef4738/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-efuse-probed: https://kernelci.org/test/case/i=
d/63e6550d6f7fe9d7208c8675
        failing since 0 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7)

    2023-02-10T14:30:11.601059  /lava-9103038/1/../bin/lava-test-case

    2023-02-10T14:30:11.611240  <8>[   33.910246] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-efuse-probed RESULT=3Dfail>
   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-a64-bananapi-m64      | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63e6531b811ed9ecf98c8641

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-97-g823a8dcef4738/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-97-g823a8dcef4738/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e6531b811ed9ecf98c8=
642
        failing since 0 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-a64-pine64-plus       | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63e65472a2afb624298c8637

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-97-g823a8dcef4738/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-p=
ine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-97-g823a8dcef4738/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-p=
ine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e65472a2afb624298c8=
638
        failing since 0 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-h5-lib...ch-all-h3-cc | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63e6532e647e57a9088c863e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-97-g823a8dcef4738/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-h5-l=
ibretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-97-g823a8dcef4738/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-h5-l=
ibretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e6532e647e57a9088c8=
63f
        failing since 0 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-h5-lib...ch-all-h3-cc | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63e653a68b0c75fe988c8636

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-97-g823a8dcef4738/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-h5-li=
bretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-97-g823a8dcef4738/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-h5-li=
bretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e653a68b0c75fe988c8=
637
        failing since 0 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-h6-pine-h64           | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63e65308811ed9ecf98c8630

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-97-g823a8dcef4738/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-pin=
e-h64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-97-g823a8dcef4738/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-pin=
e-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e65308811ed9ecf98c8=
631
        failing since 0 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-h6-pine-h64           | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63e65316a20ba3e0c48c863c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-97-g823a8dcef4738/arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-=
pine-h64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-97-g823a8dcef4738/arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-=
pine-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e65316a20ba3e0c48c8=
63d
        failing since 0 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63e650c0f10716e1d28c8649

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-97-g823a8dcef4738/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-97-g823a8dcef4738/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e650c0f10716e1d28c8652
        failing since 8 days (last pass: v5.10.165-139-gefb57ce0f880, first=
 fail: v5.10.165-149-ge30e8271d674)

    2023-02-10T14:11:45.281514  / # #
    2023-02-10T14:11:45.383907  export SHELL=3D/bin/sh
    2023-02-10T14:11:45.384635  #
    2023-02-10T14:11:45.486208  / # export SHELL=3D/bin/sh. /lava-3321932/e=
nvironment
    2023-02-10T14:11:45.486747  =

    2023-02-10T14:11:45.588137  / # . /lava-3321932/environment/lava-332193=
2/bin/lava-test-runner /lava-3321932/1
    2023-02-10T14:11:45.588966  =

    2023-02-10T14:11:45.606174  / # /lava-3321932/bin/lava-test-runner /lav=
a-3321932/1
    2023-02-10T14:11:45.694087  + export 'TESTRUN_ID=3D1_bootrr'
    2023-02-10T14:11:45.694480  + cd /lava-3321932/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63e6518cdb4a01c52f8c864e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-97-g823a8dcef4738/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-97-g823a8dcef4738/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e6518cdb4a01c52f8c8=
64f
        new failure (last pass: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
tegra124-nyan-big            | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63e651b1df0538340f8c8636

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-97-g823a8dcef4738/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-teg=
ra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-97-g823a8dcef4738/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-teg=
ra124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e651b1df0538340f8c8=
637
        failing since 0 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
tegra124-nyan-big            | arm   | lab-collabora   | gcc-10   | tegra_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63e6505b65be6a15298c8637

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-97-g823a8dcef4738/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra1=
24-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-97-g823a8dcef4738/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra1=
24-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e6505b65be6a15298c8=
638
        failing since 0 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =20
