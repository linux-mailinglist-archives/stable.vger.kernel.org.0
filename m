Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7B956927DA
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 21:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233671AbjBJUSy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 15:18:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233663AbjBJUSh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 15:18:37 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E57777BA1
        for <stable@vger.kernel.org>; Fri, 10 Feb 2023 12:18:24 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id m2-20020a17090a414200b00231173c006fso10307323pjg.5
        for <stable@vger.kernel.org>; Fri, 10 Feb 2023 12:18:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=7GO0gqWH8vrQSaZYHohflVc5lk70n1EUL0RtB78z/og=;
        b=nfCnvD+jwz/r0FKvCjBJcZL0tShws8juxuLcf4/zncw2GGr/pftznnVLUu7AdqODpq
         0PQWPSf+WC3L0Ibh/v29KUhLep8OLpdZvDPxXCbRLXyWSqVIHV59ZEnnlCfK6rlzDi2W
         eZn36qz3a6oSLrmVo3Sa2LWXf+966d9nXbCpfxY0oHmkGeuNFBMc59Hk/SroDn84j4PC
         f1u+fK+8j2Qb1C1jZ52I+LF3im1hvEZME+DUEkBsOMPzbKavMxv0n2egkwwVOInOTb00
         eALOP92ibcbIZe+r1bMqyUyfkH0H6DvBMBCVRpqAEo/VctdOOHDadopOpxkas3P5jqAn
         uoXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7GO0gqWH8vrQSaZYHohflVc5lk70n1EUL0RtB78z/og=;
        b=nAD8JLrlDXt5B9pb5Hxd0mrVVkTQamNj0wZAOjvTMD98t/x4vJWrd3Xg7OfHwEpjjx
         JcWeOKBEloo9BHYMoevkAEMZsYd59Rg55v8TvYzPjBCvfZ6F5O/dUhraGyFzpUPcOhMZ
         tbG5jDq/HUF1XvJQFQqMyI5c9rZWotv84r8AYGPM3JkEZK62jYQQqHWO0EqUdYzhNhYZ
         eaQq6YsHkP45zBcExQS+ZonwXwqHHrQX9+Irdzlw1rV6U5Y5o2NA4gPjPU8otwHl3pbo
         euVldq6CsvgrfZvbWMtImZjeiFzOjks+QpfPav9ZRwCUf4adPK8IniZAGXE3brxIqwlU
         WR5g==
X-Gm-Message-State: AO0yUKXkGq12TaGiI5E1prs48PCepl6i2G8XnXd4+oFLkjy7Tm6O9wcR
        kOf1eAJvTy3Brt4BmVxHms9Z9GyQ3h0MhEoDd30=
X-Google-Smtp-Source: AK7set+1YhpyFm6FS9xgHR8mOpt/yW9rqT+dcmQedfGjop9ClBtVn8BVoGNTp8Cn9SKnu9S31rA/DA==
X-Received: by 2002:a17:902:d4c2:b0:199:1852:d2e with SMTP id o2-20020a170902d4c200b0019918520d2emr18760399plg.9.1676060302903;
        Fri, 10 Feb 2023 12:18:22 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d2-20020a170902654200b0019919b7e5b1sm3731293pln.168.2023.02.10.12.18.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 12:18:22 -0800 (PST)
Message-ID: <63e6a68e.170a0220.ce2e.7599@mx.google.com>
Date:   Fri, 10 Feb 2023 12:18:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.167-99-g1ad87c7b6bae
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 157 runs,
 28 regressions (v5.10.167-99-g1ad87c7b6bae)
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

stable-rc/queue/5.10 baseline: 157 runs, 28 regressions (v5.10.167-99-g1ad8=
7c7b6bae)

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

kontron-sl28-var3-ads2       | arm64 | lab-kontron     | gcc-10   | defconf=
ig                  | 5          =

meson8b-odroidc1             | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 1          =

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

sun8i-h3-orangepi-pc         | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =

tegra124-nyan-big            | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =

tegra124-nyan-big            | arm   | lab-collabora   | gcc-10   | tegra_d=
efconfig            | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.167-99-g1ad87c7b6bae/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.167-99-g1ad87c7b6bae
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1ad87c7b6bae75a8e2671264e8f97d344d60e460 =



Test Regressions
---------------- =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
cubietruck                   | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63e6749658dbb9624f8c8635

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-99-g1ad87c7b6bae/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-99-g1ad87c7b6bae/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e6749658dbb9624f8c863e
        failing since 15 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-02-10T16:45:01.291679  <8>[   11.343350] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3322266_1.5.2.4.1>
    2023-02-10T16:45:01.402720  / # #
    2023-02-10T16:45:01.505676  export SHELL=3D/bin/sh
    2023-02-10T16:45:01.506798  #
    2023-02-10T16:45:01.608875  / # export SHELL=3D/bin/sh. /lava-3322266/e=
nvironment
    2023-02-10T16:45:01.609880  =

    2023-02-10T16:45:01.711964  / # . /lava-3322266/environment/lava-332226=
6/bin/lava-test-runner /lava-3322266/1
    2023-02-10T16:45:01.713883  =

    2023-02-10T16:45:01.718626  / # /lava-3322266/bin/lava-test-runner /lav=
a-3322266/1
    2023-02-10T16:45:01.798133  <3>[   11.851132] Bluetooth: hci0: command =
0xfc18 tx timeout =

    ... (12 line(s) more)  =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6dl-riotboard             | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/63e67401cdcb39fe1f8c864d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-99-g1ad87c7b6bae/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-99-g1ad87c7b6bae/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e67401cdcb39fe1f8c8=
64e
        failing since 0 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6dl-riotboard             | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63e674a1f4649bc6578c8654

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-99-g1ad87c7b6bae/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-99-g1ad87c7b6bae/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e674a1f4649bc6578c8=
655
        failing since 0 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6q-sabrelite              | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63e674667148b6e10c8c867d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-99-g1ad87c7b6bae/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-imx6=
q-sabrelite.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-99-g1ad87c7b6bae/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-imx6=
q-sabrelite.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e674667148b6e10c8c8=
67e
        failing since 0 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6qp-wandboard-revd1       | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/63e6741659db8e14b18c8631

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-99-g1ad87c7b6bae/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6qp-wandboard-revd1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-99-g1ad87c7b6bae/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6qp-wandboard-revd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e6741659db8e14b18c8=
632
        failing since 0 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6qp-wandboard-revd1       | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63e67451bd1667b2168c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-99-g1ad87c7b6bae/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6qp-wandboard-revd1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-99-g1ad87c7b6bae/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6qp-wandboard-revd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e67451bd1667b2168c8=
630
        failing since 0 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx8mn-ddr4-evk              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 2          =


  Details:     https://kernelci.org/test/plan/id/63e6775915bf74e2f48c86da

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-99-g1ad87c7b6bae/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4-=
evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-99-g1ad87c7b6bae/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4-=
evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63e6775915bf74e=
2f48c86dd
        failing since 0 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7)
        2 lines

    2023-02-10T16:56:37.035784  kern  :alert : Mem abort info:
    2023-02-10T16:56:37.036858  kern  :alert :   ESR =3D 0x96000004
    2023-02-10T16:56:37.038169  kern  :alert :   EC =3D 0x25: DABT (current=
 EL), IL =3D 32 bits
    2023-02-10T16:56:37.039358  kern  :alert :   SET =3D 0, FnV =3D 0
    2023-02-10T16:56:37.040330  kern  :alert :   EA =3D 0, S1PT<8>[   19.68=
3337] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dline=
s MEASUREMENT=3D2>
    2023-02-10T16:56:37.041410  W =3D 0   =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63e6775915bf74e=
2f48c86de
        failing since 0 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7)
        11 lines

    2023-02-10T16:56:37.029777  kern  :alert : Unable to handle kernel pagi=
ng request at virtual<8>[   19.657872] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=
=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D11>
    2023-02-10T16:56:37.030851   address fffffffffffffff8   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
jetson-tk1                   | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63e676ef8cd54300a88c8633

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-99-g1ad87c7b6bae/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-99-g1ad87c7b6bae/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e676ef8cd54300a88c8=
634
        failing since 0 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
jetson-tk1                   | arm   | lab-baylibre    | gcc-10   | tegra_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63e67524376a5295658c8692

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-99-g1ad87c7b6bae/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-t=
k1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-99-g1ad87c7b6bae/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-t=
k1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e67524376a5295658c8=
693
        failing since 0 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
kontron-sl28-var3-ads2       | arm64 | lab-kontron     | gcc-10   | defconf=
ig                  | 5          =


  Details:     https://kernelci.org/test/plan/id/63e675b634cfa28ed58c8680

  Results:     92 PASS, 8 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-99-g1ad87c7b6bae/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-sl28-=
var3-ads2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-99-g1ad87c7b6bae/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-sl28-=
var3-ads2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.spi-nor-probed: https://kernelci.org/test/case/id/63e67=
5b634cfa28ed58c868f
        failing since 0 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7)

    2023-02-10T16:49:45.677131  /lava-271765/1/../bin/lava-test-case
    2023-02-10T16:49:45.677518  <8>[   18.489571] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dspi-nor-probed RESULT=3Dfail>
    2023-02-10T16:49:45.677782  /lava-271765/1/../bin/lava-test-case   =


  * baseline.bootrr.at24-probed: https://kernelci.org/test/case/id/63e675b6=
34cfa28ed58c8691
        failing since 0 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7)

    2023-02-10T16:49:39.354845  /lava-271765/1/../bin/lava-test-case
    2023-02-10T16:49:39.355219  <8>[   12.138983] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dat24-probed RESULT=3Dfail>   =


  * baseline.bootrr.spi-nor-probed: https://kernelci.org/test/case/id/63e67=
5b634cfa28ed58c868f
        failing since 0 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7)

    2023-02-10T16:49:45.677131  /lava-271765/1/../bin/lava-test-case
    2023-02-10T16:49:45.677518  <8>[   18.489571] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dspi-nor-probed RESULT=3Dfail>
    2023-02-10T16:49:45.677782  /lava-271765/1/../bin/lava-test-case   =


  * baseline.bootrr.at24-eeprom0-probed: https://kernelci.org/test/case/id/=
63e675b634cfa28ed58c86dd
        failing since 0 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7)

    2023-02-10T16:49:46.700712  /lava-271765/1/../bin/lava-test-case
    2023-02-10T16:49:46.703867  <8>[   19.523431] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dat24-eeprom0-probed RESULT=3Dfail>   =


  * baseline.bootrr.at24-eeprom1-probed: https://kernelci.org/test/case/id/=
63e675b634cfa28ed58c86de
        failing since 0 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7)

    2023-02-10T16:49:47.753327  /lava-271765/1/../bin/lava-test-case
    2023-02-10T16:49:47.753770  <8>[   20.542884] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dat24-eeprom1-probed RESULT=3Dfail>
    2023-02-10T16:49:47.754022  /lava-271765/1/../bin/lava-test-case
    2023-02-10T16:49:47.754254  <8>[   20.559290] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drtc-rv8803-driver-present RESULT=3Dpass>   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson8b-odroidc1             | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63e67471829fb710848c864a

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-99-g1ad87c7b6bae/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-99-g1ad87c7b6bae/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e67471829fb710848c8653
        new failure (last pass: v5.10.167-97-g823a8dcef4738)

    2023-02-10T16:44:08.212392  <8>[   18.095648] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2023-02-10T16:44:08.212640  + set +x
    2023-02-10T16:44:08.214878  <8>[   18.100067] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3322274_1.5.2.4.1>
    2023-02-10T16:44:08.320027  / # #
    2023-02-10T16:44:08.421723  export SHELL=3D/bin/sh
    2023-02-10T16:44:08.422072  #
    2023-02-10T16:44:08.523381  / # export SHELL=3D/bin/sh. /lava-3322274/e=
nvironment
    2023-02-10T16:44:08.523733  =

    2023-02-10T16:44:08.625063  / # . /lava-3322274/environment/lava-332227=
4/bin/lava-test-runner /lava-3322274/1
    2023-02-10T16:44:08.625670   =

    ... (13 line(s) more)  =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
rk3399-gru-kevin             | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63e674ca929a0b2faf8c864e

  Results:     85 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-99-g1ad87c7b6bae/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-99-g1ad87c7b6bae/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-efuse-probed: https://kernelci.org/test/case/i=
d/63e674cb929a0b2faf8c8679
        failing since 0 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7)

    2023-02-10T16:45:36.793140  /lava-9104665/1/../bin/lava-test-case

    2023-02-10T16:45:36.803292  <8>[   33.572075] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-efuse-probed RESULT=3Dfail>
   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-a64-bananapi-m64      | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63e6770f8cd54300a88c865b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-99-g1ad87c7b6bae/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-99-g1ad87c7b6bae/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e6770f8cd54300a88c8=
65c
        failing since 0 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-a64-pine64-plus       | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63e676e5025fba44768c880f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-99-g1ad87c7b6bae/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pi=
ne64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-99-g1ad87c7b6bae/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pi=
ne64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e676e5025fba44768c8=
810
        failing since 0 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-h5-lib...ch-all-h3-cc | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63e6783f492722189b8c8630

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-99-g1ad87c7b6bae/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-h5-li=
bretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-99-g1ad87c7b6bae/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-h5-li=
bretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e6783f492722189b8c8=
631
        failing since 0 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-h5-lib...ch-all-h3-cc | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63e676fac085934b868c8649

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-99-g1ad87c7b6bae/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-h5-lib=
retech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-99-g1ad87c7b6bae/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-h5-lib=
retech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e676fac085934b868c8=
64a
        failing since 0 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-h6-pine-h64           | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63e676b02f534d50c68c8635

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-99-g1ad87c7b6bae/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-pine=
-h64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-99-g1ad87c7b6bae/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-pine=
-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e676b02f534d50c68c8=
636
        failing since 0 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-h6-pine-h64           | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63e676af2f534d50c68c8632

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-99-g1ad87c7b6bae/arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-p=
ine-h64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-99-g1ad87c7b6bae/arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-p=
ine-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e676af2f534d50c68c8=
633
        failing since 0 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63e6746e829fb710848c863c

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-99-g1ad87c7b6bae/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i=
-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-99-g1ad87c7b6bae/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i=
-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e6746e829fb710848c8645
        failing since 8 days (last pass: v5.10.165-139-gefb57ce0f880, first=
 fail: v5.10.165-149-ge30e8271d674)

    2023-02-10T16:44:04.590587  / # #
    2023-02-10T16:44:04.692295  export SHELL=3D/bin/sh
    2023-02-10T16:44:04.692666  #
    2023-02-10T16:44:04.793989  / # export SHELL=3D/bin/sh. /lava-3322273/e=
nvironment
    2023-02-10T16:44:04.794346  =

    2023-02-10T16:44:04.895683  / # . /lava-3322273/environment/lava-332227=
3/bin/lava-test-runner /lava-3322273/1
    2023-02-10T16:44:04.896299  =

    2023-02-10T16:44:04.901756  / # /lava-3322273/bin/lava-test-runner /lav=
a-3322273/1
    2023-02-10T16:44:04.965842  + export 'TESTRUN_ID=3D1_bootrr'
    2023-02-10T16:44:05.013630  + cd /lava-3322273/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63e674f9a15d1f111b8c8634

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-99-g1ad87c7b6bae/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3=
-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-99-g1ad87c7b6bae/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3=
-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e674f9a15d1f111b8c8=
635
        failing since 0 day (last pass: v5.10.167-97-g08e29bf32dce7, first =
fail: v5.10.167-97-g823a8dcef4738) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h3-orangepi-pc         | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63e675435518393d6c8c864f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-99-g1ad87c7b6bae/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-o=
rangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-99-g1ad87c7b6bae/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-o=
rangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e675435518393d6c8c8=
650
        new failure (last pass: v5.10.167-97-g823a8dcef4738) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
tegra124-nyan-big            | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63e676d8025fba44768c877e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-99-g1ad87c7b6bae/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegr=
a124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-99-g1ad87c7b6bae/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegr=
a124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e676d8025fba44768c8=
77f
        failing since 0 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
tegra124-nyan-big            | arm   | lab-collabora   | gcc-10   | tegra_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63e674f728f1f03f008c8642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-99-g1ad87c7b6bae/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra12=
4-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-99-g1ad87c7b6bae/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra12=
4-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e674f728f1f03f008c8=
643
        failing since 0 day (last pass: v5.10.167-88-g51abf75149f2, first f=
ail: v5.10.167-97-g08e29bf32dce7) =

 =20
